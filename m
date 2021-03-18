Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98E7C433E6
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 16:20:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22AFD64F38
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 16:20:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22AFD64F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94D604B75C;
	Thu, 18 Mar 2021 12:20:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mEdolBb08SWV; Thu, 18 Mar 2021 12:20:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA454B75B;
	Thu, 18 Mar 2021 12:20:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D04B4B756
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 12:20:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mpUyUKSpJtKx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 12:20:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B3F4B73E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 12:20:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 918EE31B;
 Thu, 18 Mar 2021 09:20:01 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D207B3F792;
 Thu, 18 Mar 2021 09:20:00 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: drjones@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2] configure: arm/arm64: Add --earlycon option
 to set UART type and address
Date: Thu, 18 Mar 2021 16:20:22 +0000
Message-Id: <20210318162022.84482-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.2
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

The upstream kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO
at higher addresses") changed the UART address to 0x1000000, and
kvm-unit-tests so far hasn't had mechanism to let the user set a specific
address, which means that for recent versions of kvmtool the early UART
won't be available.

This situation will only become worse as kvm-unit-tests gains support to
run as an EFI app, as each platform will have their own UART type and
address.

To address both issues, a new configure option is added, --earlycon. The
syntax and semantics are identical to the kernel parameter with the same
name. For example, for kvmtool, --earlycon=uart,mmio,0x1000000 will set the
correct UART address. Specifying this option will overwrite the UART
address set by --vmm.

At the moment, the UART type and register width parameters are ignored
since both qemu's and kvmtool's UART emulation use the same offset for the
TX register and no other registers are used by kvm-unit-tests, but the
parameters will become relevant once EFI support is added.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
Besides working with current versions of kvmtool, this will also make early
console work if the user specifies a custom memory layout [1] (patches are
old, but I plan to pick them up at some point in the future).

Changes in v2:
* kvmtool patches were merged, so I reworked the commit message to point to
  the corresponding kvmtool commit.
* Restricted pl011 register size to 32 bits, as per Arm Base System
  Architecture 1.0 (DEN0094A), and to match Linux.
* Reworked the way the fields are extracted to make it more precise
  (without the -s argument, the entire string is echo'ed when no delimiter
  is found).
* The changes are not trivial, so I dropped Drew's Reviewed-by.

[1] https://lore.kernel.org/kvm/1569245722-23375-1-git-send-email-alexandru.elisei@arm.com/

 configure | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/configure b/configure
index cdcd34e94030..137b165db18f 100755
--- a/configure
+++ b/configure
@@ -26,6 +26,7 @@ errata_force=0
 erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
+earlycon=
 
 usage() {
     cat <<-EOF
@@ -54,6 +55,18 @@ usage() {
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
+	               pl011,ADDR
+	               pl011,mmio32,ADDR
+	                           Specify a PL011 compatible UART at address ADDR. Supported
+	                           register stride is 32 bit only.
 EOF
     exit 1
 }
@@ -112,6 +125,9 @@ while [[ "$1" = -* ]]; do
 	--page-size)
 	    page_size="$arg"
 	    ;;
+	--earlycon)
+	    earlycon="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -170,6 +186,51 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
         echo '--vmm must be one of "qemu" or "kvmtool"!'
         usage
     fi
+
+    if [ "$earlycon" ]; then
+        # Append delimiter and use cut -s to prevent cut from ignoring the field
+        # argument if no delimiter is specified by the user.
+        earlycon="$earlycon,"
+        name=$(echo $earlycon|cut -sd',' -f1)
+        if [ "$name" != "uart" ] && [ "$name" != "uart8250" ] &&
+                [ "$name" != "pl011" ]; then
+            echo "unknown earlycon name: $name"
+            usage
+        fi
+
+        if [ "$name" = "pl011" ]; then
+            type_addr=$(echo $earlycon|cut -sd',' -f2)
+            if [ -z "$type_addr" ]; then
+                echo "missing earlycon address"
+                usage
+            fi
+            addr=$(echo $earlycon|cut -sd',' -f3)
+            if [ -z "$addr" ]; then
+                addr=$type_addr
+            else
+                if [ "$type_addr" != "mmio32" ]; then
+                    echo "unknown $name earlycon type: $type_addr"
+                    usage
+                fi
+            fi
+        else
+            type=$(echo $earlycon|cut -sd',' -f2)
+            if [ -z "$type" ]; then
+                echo "missing $name earlycon type"
+                usage
+            fi
+            if [ "$type" != "mmio" ]; then
+                echo "unknown $name earlycon type: $type"
+                usage
+            fi
+            addr=$(echo $earlycon|cut -sd',' -f3)
+            if [ -z "$addr" ]; then
+                echo "missing earlycon address"
+                usage
+            fi
+        fi
+        arm_uart_early_addr=$addr
+    fi
 elif [ "$arch" = "ppc64" ]; then
     testdir=powerpc
     firmware="$testdir/boot_rom.bin"
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
