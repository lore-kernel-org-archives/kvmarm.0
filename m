Return-Path: <SRS0=3b8a=HV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BC0C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 16:37:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC1DA64E57
	for <kvmarm@archiver.kernel.org>; Fri, 19 Feb 2021 16:37:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC1DA64E57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CA754B2BD;
	Fri, 19 Feb 2021 11:37:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YtH9btExMHib; Fri, 19 Feb 2021 11:37:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA32D4B2B1;
	Fri, 19 Feb 2021 11:37:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E89724B211
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 11:37:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pEL8N9WIqGaD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Feb 2021 11:37:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 769034B274
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Feb 2021 11:37:08 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8734ED1;
 Fri, 19 Feb 2021 08:37:07 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 144FE3F73B;
 Fri, 19 Feb 2021 08:37:06 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] configure: arm/arm64: Add --earlycon option to
 set UART type and address
Date: Fri, 19 Feb 2021 16:37:18 +0000
Message-Id: <20210219163718.109101-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
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

Currently, the UART early address is set indirectly with the --vmm option
and there are only two possible values: if the VMM is qemu (the default),
then the UART address is set to 0x09000000; if the VMM is kvmtool, then the
UART address is set to 0x3f8.

There several efforts under way to change the kvmtool UART address, and
kvm-unit-tests so far hasn't had mechanism to let the user set a specific
address, which means that the early UART won't be available.

This situation will only become worse as kvm-unit-tests gains support to
run as an EFI app, as each platform will have their own UART type and
address.

To address both issues, a new configure option is added, --earlycon. The
syntax and semantics are identical to the kernel parameter with the same
name. Specifying this option will overwrite the UART address set by --vmm.

At the moment, the UART type and register width parameters are ignored
since both qemu's and kvmtool's UART emulation use the same offset for the
TX register and no other registers are used by kvm-unit-tests, but the
parameters will become relevant once EFI support is added.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
The kvmtool patches I was referring to are the patches to unify ioport and
MMIO emulation [1] and to allow the user to specify a custom memory layout
for the VM [2] (these patches are very old, but I plan to revive them after
the ioport and MMIO unification series are merged).

[1] https://lore.kernel.org/kvm/20201210142908.169597-1-andre.przywara@arm.com/T/#t
[2] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

 configure | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/configure b/configure
index cdcd34e94030..d94b92255088 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
+earlycon=
 
 usage() {
     cat <<-EOF
@@ -54,6 +55,17 @@ usage() {
 	    --page-size=PAGE_SIZE
 	                           Specify the page size (translation granule) (4k, 16k or
 	                           64k, default is 64k, arm64 only)
+	    --earlycon=EARLYCON
+	                           Specify the UART name, type and address (optional, arm and
+	                           arm64 only). The specified address will overwrite the UART
+	                           address set by the --vmm option. EARLYCON can be on of (case
+	                           sensitive):
+	               uart[8250],mmio,ADDR
+	                           Specify an 8250 compatible UART at address ADDR. Supported
+	                           register stride is 8 bit only.
+	               pl011,mmio,ADDR
+	                           Specify a PL011 compatible UART at address ADDR. Supported
+	                           register stride is 8 bit only.
 EOF
     exit 1
 }
@@ -112,6 +124,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--earlycon)
+	    earlycon="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -170,6 +185,26 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         echo '--vmm must be one of "qemu" or "kvmtool"!'
         usage
     fi
+
+    if [ "$earlycon" ]; then
+        name=$(echo $earlycon|cut -d',' -f1)
+        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
+                [ "$name" != "pl011" ]; then
+            echo "unknown earlycon name: $name"
+            usage
+        fi
+        type=$(echo $earlycon|cut -d',' -f2)
+        if [ "$type" != "mmio" ]; then
+            echo "unknown earlycon type: $type"
+            usage
+        fi
+        addr=$(echo $earlycon|cut -d',' -f3)
+        if [ -z "$addr" ]; then
+            echo "missing earlycon address"
+            usage
+        fi
+        arm_uart_early_addr=$addr
+    fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
     firmware="$testdir/boot_rom.bin"
-- 
2.30.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
