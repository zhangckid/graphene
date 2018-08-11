JAVA_VERSION = 1.8.0
SRC_VERSION = 8u
SRC_HG_URL = http://hg.openjdk.java.net/jdk$(SRC_VERSION)/jdk$(SRC_VERSION)/
SRC_HG_REV = 7abd14dd301d
SRC_DIR = jdk$(SRC_VERSION)
ifeq ($(DEBUG),1)
JAVA_DEBUG_LEVEL = fastdebug
else
JAVA_DEBUG_LEVEL = release
endif
INSTALL_DIR = build
JAVA_HOME = $(INSTALL_DIR)/jvm/openjdk-$(JAVA_VERSION)-internal$(if $(filter release,$(JAVA_DEBUG_LEVEL)),,-$(JAVA_DEBUG_LEVEL))/jre
JAVAC = $(JAVA_HOME)/../bin/javac

CLASSES = $(patsubst %.java,%.class,$(wildcard classes/*.java))
SUITES = classes/apache-sshd-1.2.0/sshd-core/target/sshd-core-1.2.0.jar \
	 classes/jmh-jdk-1.0/target/jmh-jdk-microbenchmarks-1.0-SNAPSHOT.jar

target = $(CLASSES) build-java
exec_target = java.manifest ls.manifest

clean-extra = clean-classes

ABSPATH_IN_MANIFEST := yes
extra_rules = \
	-e 's:\$$(DEBUGTYPE):$(if $(DEBUG),inline,none):g' \
	-e 's:\$$(JAVA_HOME):$(abspath $(JAVA_HOME)):g'

level = ../../
include ../../Makefile

.PHONY: build-java
build-java: $(JAVA_HOME)/bin/java

$(JAVA_HOME)/bin/java: $(SRC_DIR)/configure
	cd $(SRC_DIR) && sh configure --prefix=$(abspath $(INSTALL_DIR)) \
		--with-jvm-variants=server \
		--disable-headful --enable-openjdk-only \
		--disable-zip-debug-info \
		--with-debug-level=$(JAVA_DEBUG_LEVEL) JAVA_HOME=
	cd $(SRC_DIR) && make install LOG=debug

java.manifest: $(JAVA_HOME)/bin/java

$(SRC_DIR)/configure:
	hg clone $(SRC_HG_URL) -r $(SRC_HG_REV)
	cd $(SRC_DIR) && sh get_source.sh
	cd $(SRC_DIR) && patch -p1 < ../openjdk8-enclave.patch

%.class: %.java
	javac $<

.PHONY: test-suites
test-suites: $(SUITES)

classes/apache-sshd-1.2.0/sshd-core/target/sshd-core-1.2.0.jar:
	cd classes && wget http://archive.apache.org/dist/mina/sshd/1.2.0/apache-sshd-1.2.0-src.tar.gz
	cd classes && tar -xzf apache-sshd-1.2.0-src.tar.gz
	cd classes/apache-sshd-1.2.0 && mvn install -Dcheckstyle.skip -Dmaven.test.skip=true

classes/jmh-jdk-1.0/target/jmh-jdk-microbenchmarks-1.0-SNAPSHOT.jar:
	cd classes && wget http://hg.openjdk.java.net/code-tools/jmh-jdk-microbenchmarks/archive/tip.tar.gz -O jmh-jdk-1.0.tar.gz
	cd classes && mkdir -p jmh-jdk-1.0
	cd classes/jmh-jdk-1.0 && tar -xzf ../jmh-jdk-1.0.tar.gz --strip-components=1
	cd classes/jmh-jdk-1.0 && mvn install -Dcheckstyle.skip -Dmaven.test.skip=true

.PHONY: clean-classes
clean-classes:
	rm -f classes/*.class

.PHONY: distclean
distclean: clean
	rm -rf $(SRC_DIR) $(INSTALL_DIR)
	rm -ff $(SUITES)
