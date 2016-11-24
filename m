From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v7 01/11] run_tests: allow forcing of
 acceleration mode
Date: Thu, 24 Nov 2016 16:10:23 +0000
Message-ID: <20161124161033.11456-2-alex.bennee@linaro.org>
References: <20161124161033.11456-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A2640A01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2016 11:10:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pdwq9zktze7z for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Nov 2016 11:10:21 -0500 (EST)
Received: from mail-wj0-f178.google.com (mail-wj0-f178.google.com
 [209.85.210.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53B06409E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2016 11:10:20 -0500 (EST)
Received: by mail-wj0-f178.google.com with SMTP id xy5so37023171wjc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Nov 2016 08:11:03 -0800 (PST)
In-Reply-To: <20161124161033.11456-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: mttcg@listserver.greensocs.com, nikunj@linux.vnet.ibm.com, jan.kiszka@siemens.com, mark.burton@greensocs.com, qemu-devel@nongnu.org, cota@braap.org, serge.fdrv@gmail.com, pbonzini@redhat.com, bobby.prani@gmail.com, rth@twiddle.net
List-Id: kvmarm@lists.cs.columbia.edu

While tests can be pegged to tcg it is useful to override this from time
to time, especially when testing correctness on real systems.
---
 run_tests.sh         | 8 ++++++--
 scripts/runtime.bash | 4 ++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/run_tests.sh b/run_tests.sh
index 254129d..b88c36f 100755
--- a/run_tests.sh
+++ b/run_tests.sh
@@ -13,9 +13,10 @@ function usage()
 {
 cat <<EOF
 
-Usage: $0 [-g group] [-h] [-v]
+Usage: $0 [-g group] [-a accel] [-h] [-v]
 
     -g: Only execute tests in the given group
+    -a: Force acceleration mode (tcg/kvm)
     -h: Output this help text
     -v: Enables verbose mode
 
@@ -28,11 +29,14 @@ EOF
 RUNTIME_arch_run="./$TEST_DIR/run"
 source scripts/runtime.bash
 
-while getopts "g:hv" opt; do
+while getopts "g:a:hv" opt; do
     case $opt in
         g)
             only_group=$OPTARG
             ;;
+        a)
+            force_accel=$OPTARG
+            ;;
         h)
             usage
             exit
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 11a40a9..578cf32 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -75,6 +75,10 @@ function run()
         return;
     fi
 
+    if [ -n "$force_accel" ]; then
+        accel=$force_accel
+    fi
+
     if [ -n "$arch" ] && [ "$arch" != "$ARCH" ]; then
         echo "`SKIP` $1 ($arch only)"
         return 2
-- 
2.10.1
