From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 03/11] run_tests: allow
 passing of options to QEMU
Date: Thu, 24 Nov 2016 16:10:25 +0000
Message-ID: <20161124161033.11456-4-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: "Qemu-devel" <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: mttcg@listserver.greensocs.com, peter.maydell@linaro.org, claudio.fontana@huawei.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, a.rigo@virtualopensystems.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, fred.konrad@greensocs.com
List-Id: kvmarm@lists.cs.columbia.edu

This introduces a the option -o for passing of options directly to QEMU
which is useful. In my case I'm using it to toggle MTTCG on an off:

  ./run_tests.sh -t -o "-tcg mttcg=on"

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 run_tests.sh           | 10 +++++++---
 scripts/functions.bash | 13 +++++++------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 4f2e5cb..05cc7fb 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -13,10 +13,11 @@ function usage()
 {
 cat <<EOF
 
-Usage: $0 [-g group] [-a accel] [-t] [-h] [-v]
+Usage: $0 [-g group] [-a accel] [-o qemu_opts] [-t] [-h] [-v]
 
     -g: Only execute tests in the given group
     -a: Force acceleration mode (tcg/kvm)
+    -o: additional options for QEMU command line
     -t: disable timeouts
     -h: Output this help text
     -v: Enables verbose mode
@@ -30,7 +31,7 @@ EOF
 RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
-while getopts "g:a:thv" opt; do
+while getopts "g:a:o:thv" opt; do
     case $opt in
         g)
             only_group=$OPTARG
@@ -38,6 +39,9 @@ while getopts "g:a:thv" opt; do
         a)
             force_accel=$OPTARG
             ;;
+        o)
+            extra_opts=$OPTARG
+            ;;
         t)
             no_timeout="yes"
             ;;
@@ -67,4 +71,4 @@ RUNTIME_log_stdout () {
 config=$TEST_DIR/unittests.cfg
 rm -f test.log
 printf "BUILD_HEAD=$(cat build-head)\n\n" > test.log
-for_each_unittest $config run
+for_each_unittest $config run "$extra_opts"
diff --git a/scripts/functions.bash b/scripts/functions.bash
index ee9143c..d38a69e 100644
--- a/scripts/functions.bash
+++ b/scripts/functions.bash
@@ -2,11 +2,12 @@
 function for_each_unittest()
 {
 	local unittests="$1"
-	local cmd="$2"
-	local testname
+        local cmd="$2"
+        local extra_opts=$3
+        local testname
 	local smp
 	local kernel
-	local opts
+        local opts=$extra_opts
 	local groups
 	local arch
 	local check
@@ -21,7 +22,7 @@ function for_each_unittest()
 			testname=${BASH_REMATCH[1]}
 			smp=1
 			kernel=""
-			opts=""
+                        opts=$extra_opts
 			groups=""
 			arch=""
 			check=""
@@ -32,7 +33,7 @@ function for_each_unittest()
 		elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
 			smp=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
-			opts=${BASH_REMATCH[1]}
+                        opts="$opts ${BASH_REMATCH[1]}"
 		elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
 			groups=${BASH_REMATCH[1]}
 		elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
@@ -45,6 +46,6 @@ function for_each_unittest()
 			timeout=${BASH_REMATCH[1]}
 		fi
 	done
-	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+        "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 	exec {fd}<&-
 }
-- 
2.10.1
