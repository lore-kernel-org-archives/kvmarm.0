Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307EDC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 11:24:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9F44B2E6;
	Wed, 25 May 2022 07:24:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IHb3FA0W6czv; Wed, 25 May 2022 07:24:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E4F4B321;
	Wed, 25 May 2022 07:24:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 139374B2E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:24:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m51pdCTY4i2N for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 07:24:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A684B321
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 07:24:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A04A1042;
 Wed, 25 May 2022 04:24:01 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C28E43F70D;
 Wed, 25 May 2022 04:23:59 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
Subject: [PATCH v3 kvmtool 12/13] Introduce kvm__arch_default_ram_address()
Date: Wed, 25 May 2022 12:23:44 +0100
Message-Id: <20220525112345.121321-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220525112345.121321-1-alexandru.elisei@arm.com>
References: <20220525112345.121321-1-alexandru.elisei@arm.com>
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
index 2134528bf7f2..357936844046 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -46,6 +46,11 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 	}
 }
 
+u64 kvm__arch_default_ram_address(void)
+{
+	return ARM_MEMORY_AREA;
+}
+
 /*
  * Return the TEXT_OFFSET value that the guest kernel expects. Note
  * that pre-3.17 kernels expose this value using the native endianness
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
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
