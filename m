Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6C7C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 15:55:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53E304B291;
	Mon, 16 May 2022 11:55:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6X2upbaDPUBU; Mon, 16 May 2022 11:55:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 762544B2BE;
	Mon, 16 May 2022 11:55:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 775904B29E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FBOnFTr5+7j8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 11:55:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 294B74B293
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 11:55:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B259311FB;
 Mon, 16 May 2022 08:55:41 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D8B83F73D;
 Mon, 16 May 2022 08:55:40 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
 suzuki.poulose@arm.com, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com
Subject: [PATCH v2 kvmtool 11/12] Introduce kvm__arch_default_ram_address()
Date: Mon, 16 May 2022 16:55:25 +0100
Message-Id: <20220516155526.181694-12-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516155526.181694-1-alexandru.elisei@arm.com>
References: <20220516155526.181694-1-alexandru.elisei@arm.com>
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
index 5db8e295c433..af8e7eae0da2 100644
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
