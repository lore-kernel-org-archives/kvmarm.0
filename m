Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E7AC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 14:11:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD94B6105A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 14:11:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD94B6105A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17C5E4B32F;
	Thu, 29 Apr 2021 10:11:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HOyNwsc-Lp7l; Thu, 29 Apr 2021 10:11:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12764B35C;
	Thu, 29 Apr 2021 10:11:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DF554B32F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 10:11:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UT8qdBj4qCkw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 10:11:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A4394B311
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 10:11:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B3C01FB;
 Thu, 29 Apr 2021 07:11:26 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC8BC3F73B;
 Thu, 29 Apr 2021 07:11:25 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v3] configure: arm: Replace --vmm with --target
Date: Thu, 29 Apr 2021 15:12:04 +0100
Message-Id: <20210429141204.51848-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Cc: pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The --vmm configure option was added to distinguish between the two virtual
machine managers that kvm-unit-tests supports for the arm and arm64
architectures, qemu or kvmtool. There are plans to make kvm-unit-tests work
as an EFI app, which will require changes to the way tests are compiled.
Instead of adding a new configure option specifically for EFI and have it
coexist with --vmm, or overloading the semantics of the existing --vmm
option, let's replace --vmm with the more generic name --target.

Since --target is only valid for arm and arm64, reject the option when it's
specified for another architecture, which is how --vmm should have behaved
from the start.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Changes in v3:

* Using --target for any architecture other than arm and arm64 generates an
  error.
* Don't generate the TARGET variable in config.mak for other architectures.
* Cosmetic changes to the commit message.

Changes in v2:

* Removed the RFC tag and cover letter.
* Removed --vmm entirely.

 configure | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/configure b/configure
index 01a0b262a9f2..d5d223fe3a90 100755
--- a/configure
+++ b/configure
@@ -21,7 +21,7 @@ pretty_print_stacks=yes
 environ_default=yes
 u32_long=
 wa_divide=
-vmm="qemu"
+target=
 errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
@@ -35,8 +35,8 @@ usage() {
 	Options include:
 	    --arch=ARCH            architecture to compile for ($arch)
 	    --processor=PROCESSOR  processor to compile for ($arch)
-	    --vmm=VMM              virtual machine monitor to compile for (qemu
-	                           or kvmtool, default is qemu) (arm/arm64 only)
+	    --target=TARGET        target platform that the tests will be running on (qemu or
+	                           kvmtool, default is qemu) (arm/arm64 only)
 	    --cross-prefix=PREFIX  cross compiler prefix
 	    --cc=CC		   c compiler to use ($cc)
 	    --ld=LD		   ld linker to use ($ld)
@@ -58,7 +58,7 @@ usage() {
 	    --earlycon=EARLYCON
 	                           Specify the UART name, type and address (optional, arm and
 	                           arm64 only). The specified address will overwrite the UART
-	                           address set by the --vmm option. EARLYCON can be one of
+	                           address set by the --target option. EARLYCON can be one of
 	                           (case sensitive):
 	               uart[8250],mmio,ADDR
 	                           Specify an 8250 compatible UART at address ADDR. Supported
@@ -88,8 +88,8 @@ while [[ "$1" = -* ]]; do
         --processor)
 	    processor="$arg"
 	    ;;
-	--vmm)
-	    vmm="$arg"
+	--target)
+	    target="$arg"
 	    ;;
 	--cross-prefix)
 	    cross_prefix="$arg"
@@ -146,6 +146,15 @@ arch_name=$arch
 [ "$arch" = "aarch64" ] && arch="arm64"
 [ "$arch_name" = "arm64" ] && arch_name="aarch64"
 
+if [ -z "$target" ]; then
+    target="qemu"
+else
+    if [ "$arch" != "arm64" ] && [ "$arch" != "arm" ]; then
+        echo "--target is not supported for $arch"
+        usage
+    fi
+fi
+
 if [ -z "$page_size" ]; then
     [ "$arch" = "arm64" ] && page_size="65536"
     [ "$arch" = "arm" ] && page_size="4096"
@@ -177,13 +186,13 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
-    if [ "$vmm" = "qemu" ]; then
+    if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
-    elif [ "$vmm" = "kvmtool" ]; then
+    elif [ "$target" = "kvmtool" ]; then
         arm_uart_early_addr=0x3f8
         errata_force=1
     else
-        echo '--vmm must be one of "qemu" or "kvmtool"!'
+        echo '--target must be one of "qemu" or "kvmtool"!'
         usage
     fi
 
@@ -318,6 +327,11 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 EOF
+if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
+cat <<EOF >> config.mak
+TARGET=$target
+EOF
+fi
 
 cat <<EOF > lib/config.h
 #ifndef CONFIG_H
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
