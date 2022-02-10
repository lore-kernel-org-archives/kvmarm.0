Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E781C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 15:09:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B884949F58;
	Thu, 10 Feb 2022 10:09:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2+QqZT6YxmNU; Thu, 10 Feb 2022 10:09:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59DAC49F46;
	Thu, 10 Feb 2022 10:09:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA594A0FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:09:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CJn5oXEAJPnx for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 10:09:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9790B49F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 10:09:44 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F8BB1042;
 Thu, 10 Feb 2022 07:09:44 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B5FE13F718;
 Thu, 10 Feb 2022 07:09:42 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
 varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 2/4] configure: Restrict --target-efi to x86_64
Date: Thu, 10 Feb 2022 15:09:41 +0000
Message-Id: <20220210150943.1280146-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220210150943.1280146-1-alexandru.elisei@arm.com>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

Setting the --target-efi option for any architecture but x86_64 results in
an error while trying to compile the tests:

$ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- --target-efi
$ make clean && make
Makefile:46: *** Cannot build aarch64 tests as EFI apps.  Stop.

Which might come as a surprise for users, as the help message for the
configure script makes no mention of an architectur being incompatible
with the option.

Document that --target-efi applies only to the x86_64 architecture and
check for illegal usage in the configure script, instead of failing later,
at compile time.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile  | 4 ----
 configure | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 4f4ad235fe0c..5af17f129ced 100644
--- a/Makefile
+++ b/Makefile
@@ -40,11 +40,7 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(TARGET_EFI),y)
-ifeq ($(ARCH_NAME),x86_64)
 EFI_ARCH = x86_64
-else
-$(error Cannot build $(ARCH_NAME) tests as EFI apps)
-endif
 EFI_CFLAGS := -DTARGET_EFI
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
diff --git a/configure b/configure
index 0ac9c85502ff..6620e78ec09c 100755
--- a/configure
+++ b/configure
@@ -74,7 +74,7 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
-	    --target-efi           Boot and run from UEFI
+	    --target-efi           Boot and run from UEFI (x86_64 only)
 EOF
     exit 1
 }
@@ -177,6 +177,11 @@ else
     fi
 fi
 
+if [ "$target_efi" ] && [ "$arch" != "x86_64" ]; then
+    echo "--target-efi is not supported for $arch"
+    usage
+fi
+
 if [ -z "$page_size" ]; then
     [ "$arch" = "arm64" ] && page_size="65536"
     [ "$arch" = "arm" ] && page_size="4096"
-- 
2.35.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
