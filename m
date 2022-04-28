Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA966C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 15:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 841AA4B28A;
	Thu, 28 Apr 2022 11:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C2s-G5JvbTO4; Thu, 28 Apr 2022 11:56:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 494144B2AB;
	Thu, 28 Apr 2022 11:56:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D99F4B26D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMflexSLmOT2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 11:56:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 966564B29F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 11:56:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 515491477;
 Thu, 28 Apr 2022 08:56:25 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E27B63F774;
 Thu, 28 Apr 2022 08:56:23 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: julien.thierry.kdev@gmail.com, will@kernel.org, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH kvmtool 11/15] Introduce kvm__arch_default_ram_address()
Date: Thu, 28 Apr 2022 16:55:58 +0100
Message-Id: <20220428155602.29445-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220428155602.29445-1-alexandru.elisei@arm.com>
References: <20220428155602.29445-1-alexandru.elisei@arm.com>
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

Add a new function, kvm__arch_default_ram_address(), which returns the
default address for guest RAM for each architecture.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/kvm.c | 5 +++++
 arm/aarch64/kvm.c | 5 +++++
 include/kvm/kvm.h | 1 +
 mips/kvm.c        | 5 +++++
 powerpc/kvm.c     | 5 +++++
 riscv/kvm.c       | 5 +++++
 x86/kvm.c         | 5 +++++
 7 files changed, 31 insertions(+)

diff --git a/arm/aarch32/kvm.c b/arm/aarch32/kvm.c
index 9d68d7a15ee2..768a56bbb5b4 100644
--- a/arm/aarch32/kvm.c
+++ b/arm/aarch32/kvm.c
@@ -7,3 +7,8 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 		    kvm->cfg.ram_size, ARM_LOMAP_MAX_MEMORY);
 	}
 }
+
+u64 kvm__arch_default_ram_address(void)
+{
+	return ARM_MEMORY_AREA;
+}
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 73b2c5970f28..c52243b1f67f 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -5,6 +5,11 @@
 #include <linux/byteorder.h>
 #include <kvm/util.h>
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return ARM_MEMORY_AREA;
+}
+
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 	if (kvm->cfg.arch.aarch32_guest &&
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 640b76c095f9..360430b78b1e 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -190,6 +190,7 @@ void kvm__remove_socket(const char *name);
 void kvm__arch_validate_cfg(struct kvm *kvm);
 void kvm__arch_set_cmdline(char *cmdline, bool video);
 void kvm__arch_init(struct kvm *kvm);
+u64 kvm__arch_default_ram_address(void);
 void kvm__arch_delete_ram(struct kvm *kvm);
 int kvm__arch_setup_firmware(struct kvm *kvm);
 int kvm__arch_free_firmware(struct kvm *kvm);
diff --git a/mips/kvm.c b/mips/kvm.c
index d8610cf81b94..4cbc9907731b 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -12,6 +12,11 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return 0;
+}
+
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 }
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index d281b070fd0e..7b0d0669aff4 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -48,6 +48,11 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return 0;
+}
+
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 }
diff --git a/riscv/kvm.c b/riscv/kvm.c
index c46660772aa0..4d6f5cb57ac8 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -13,6 +13,11 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 },
 };
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return RISCV_RAM;
+}
+
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 }
diff --git a/x86/kvm.c b/x86/kvm.c
index 24b0305a1841..328fa7500596 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -35,6 +35,11 @@ struct kvm_ext kvm_req_ext[] = {
 	{ 0, 0 }
 };
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return 0;
+}
+
 void kvm__arch_validate_cfg(struct kvm *kvm)
 {
 }
-- 
2.36.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
