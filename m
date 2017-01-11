From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 6/6] run_tests: allow passing of options to QEMU
Date: Wed, 11 Jan 2017 16:28:41 +0000
Message-ID: <20170111162841.15569-7-alex.bennee@linaro.org>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170111162841.15569-1-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This allows additional options to be passed to QEMU. It follows the
convention of passing parameters after a -- to the child process. In
my case I'm using it to toggle MTTCG on an off:

  ./run_tests.sh -- --accel tcg,thread=multi

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v1
  - changes from -o to --
  - fixed whitespace damage
---
 README.md              |  6 ++++++
 run_tests.sh           | 13 +++++++++++--
 scripts/functions.bash |  7 ++++---
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/README.md b/README.md
index fa3a445..1bd6dcb 100644
--- a/README.md
+++ b/README.md
@@ -55,6 +55,12 @@ To extend or disable the timeouts:
 
     TIMEOUT=0 ./run_tests.sh
 
+Any arguments past the end-of-arguments marker (--) is passed on down
+to the QEMU invocation. This can of course be combined with the other
+modifiers:
+
+    ACCEL=tcg ./run_tests.sh -v -- --accel tcg,thread=multi
+
 # Contributing
 
 ## Directory structure
diff --git a/run_tests.sh b/run_tests.sh
index 254129d..3270fba 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -13,7 +13,7 @@ function usage()
 {
 cat <<EOF
 
-Usage: $0 [-g group] [-h] [-v]
+Usage: $0 [-g group] [-h] [-v] [-- QEMU options]
 
     -g: Only execute tests in the given group
     -h: Output this help text
@@ -22,6 +22,8 @@ Usage: $0 [-g group] [-h] [-v]
 Set the environment variable QEMU=/path/to/qemu-system-ARCH to
 specify the appropriate qemu binary for ARCH-run.
 
+All options specified after -- are passed on to QEMU.
+
 EOF
 }
 
@@ -29,6 +31,7 @@ RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
 while getopts "g:hv" opt; do
+
     case $opt in
         g)
             only_group=$OPTARG
@@ -46,6 +49,12 @@ while getopts "g:hv" opt; do
     esac
 done
 
+# Any options left for QEMU?
+shift $((OPTIND-1))
+if [ "$#" -gt  0 ]; then
+    extra_opts="$@"
+fi
+
 RUNTIME_log_stderr () { cat >> test.log; }
 RUNTIME_log_stdout () {
     if [ "$PRETTY_PRINT_STACKS" = "yes" ]; then
@@ -59,4 +68,4 @@ RUNTIME_log_stdout () {
 config=$TEST_DIR/unittests.cfg
 rm -f test.log
 printf "BUILD_HEAD=$(cat build-head)\n\n" > test.log
-for_each_unittest $config run
+for_each_unittest $config run "$extra_opts"
diff --git a/scripts/functions.bash b/scripts/functions.bash
index ee9143c..60fbc6a 100644
--- a/scripts/functions.bash
+++ b/scripts/functions.bash
@@ -3,10 +3,11 @@ function for_each_unittest()
 {
 	local unittests="$1"
 	local cmd="$2"
+	local extra_opts=$3
 	local testname
 	local smp
 	local kernel
-	local opts
+	local opts=$extra_opts
 	local groups
 	local arch
 	local check
@@ -21,7 +22,7 @@ function for_each_unittest()
 			testname=${BASH_REMATCH[1]}
 			smp=1
 			kernel=""
-			opts=""
+			opts=$extra_opts
 			groups=""
 			arch=""
 			check=""
@@ -32,7 +33,7 @@ function for_each_unittest()
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
 			smp=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
-			opts=${BASH_REMATCH[1]}
+			opts="$opts ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
-- 
2.11.0

