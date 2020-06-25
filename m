Return-Path: <SRS0=2KC8=AG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C28C433E2
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 592C02072E
	for <kvmarm@archiver.kernel.org>; Thu, 25 Jun 2020 13:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ptUYaqaC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 592C02072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14F2B4B533;
	Thu, 25 Jun 2020 09:14:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4m+FXtb9KJNV; Thu, 25 Jun 2020 09:14:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB2B84B563;
	Thu, 25 Jun 2020 09:14:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 162D94B407
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J7Xm6K2b43Xd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Jun 2020 09:14:40 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6663C4B2AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 09:14:40 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id j94so5826237wrj.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Jun 2020 06:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=8YaXLDxxzlKAiESgNRq8wdJ40whWlk3lT5J1UV9ShEk=;
 b=ptUYaqaC2fNbn4dFnNBvjrml34RgtIWxecFGQZ/rtO5cK2Ktr69rNMtVd+7KLtrVaU
 vYbQR9jiUt2YGFm5AMtGMFiW2vJmnma8HuPx5HTyDOhNzmq5X+4pq3GCJLYvxqgjhijQ
 SB7i4uAk7yRQQp1Y07MtuvJ2wYX9JlJgabFaFGDUUpfL+f/cLzxrEnV3Eqyx5z9p5oT5
 MFnD5BFal4/GRzbmpW9b0KeuJYSCq2vMQohzeTX/7DeLKFSw97ti4GuZqYVHYes8/i+X
 z6mly0+ExPsofWqW/OKDtF1ACJS1CVODPDde9p3tM9DesBZodxOHvuqZNEvElb2KLOoq
 FnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=8YaXLDxxzlKAiESgNRq8wdJ40whWlk3lT5J1UV9ShEk=;
 b=Spn4hDWF5tg53jOkbV3gQD1eMRw2RTTYyJmlHAnH1WUgdWTdzOWFNxoFmaLdBBkPo/
 g1vonNfNlI3g1dA2zO0u9vpIb2CPMJwC9r6tPh6GlboK3fhMeM2+FDn5DzAJb4yJjWSp
 gUvD6oyqvYPTTMA0+TPWjF3BNzgEyEE7T6/cUR3JkA9nhFaAYX8r+IenEWNG67HXRMQ6
 Xv9mTjtSPPd9Ab9Twtl0ILhy6/dDF1dwz9fusi2e3ERcBt3cfbVwmn3XydPmhbzqoLLX
 pHyXXCa+WD3Cg8HZzuQk9f1nwtLgv5YtgW9VtY0jvEqiM2Y0AQRiF8Uc71SzIGbODbe0
 lskg==
X-Gm-Message-State: AOAM532VDXIGQMLPhuYvuSR6ZhO1hLyThuI0DISxLDUH3xMkssVbd/xU
 tixldqRMCvt6OqF4Lp/3ycuFJQ==
X-Google-Smtp-Source: ABdhPJyX21tUaR8lSQzSoYuCZextAN9yErT7506pCYgBsfXJoeyLWsHRNE0sQ44n4PXOoIfMXH4qYg==
X-Received: by 2002:adf:a507:: with SMTP id i7mr39649354wrb.0.1593090879212;
 Thu, 25 Jun 2020 06:14:39 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:c126:6748:7a9d:2d])
 by smtp.gmail.com with ESMTPSA id 26sm10326690wmj.25.2020.06.25.06.14.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Jun 2020 06:14:38 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v4 08/15] arm64: kvm: Duplicate hyp/tlb.c for VHE/nVHE
Date: Thu, 25 Jun 2020 14:14:13 +0100
Message-Id: <20200625131420.71444-9-dbrazdil@google.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625131420.71444-1-dbrazdil@google.com>
References: <20200625131420.71444-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: android-kvm@google.com, linux-kernel@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

tlb.c contains code for flushing the TLB, with code shared between VHE/nVHE.
Because common code is small, duplicate tlb.c and specialize each copy for
VHE/nVHE.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/kernel/image-vars.h      |  14 +--
 arch/arm64/kvm/hyp/Makefile         |   2 +-
 arch/arm64/kvm/hyp/nvhe/Makefile    |   2 +-
 arch/arm64/kvm/hyp/{ => nvhe}/tlb.c |  94 +---------------
 arch/arm64/kvm/hyp/vhe/Makefile     |   2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c        | 162 ++++++++++++++++++++++++++++
 6 files changed, 178 insertions(+), 98 deletions(-)
 rename arch/arm64/kvm/hyp/{ => nvhe}/tlb.c (62%)
 create mode 100644 arch/arm64/kvm/hyp/vhe/tlb.c

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index c3643df22a9b..5d7cb61bfa9a 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -81,12 +81,6 @@ KVM_NVHE_ALIAS(__kvm_enable_ssbs);
 /* Symbols defined in timer-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__kvm_timer_set_cntvoff);
 
-/* Symbols defined in tlb.c (not yet compiled with nVHE build rules). */
-KVM_NVHE_ALIAS(__kvm_flush_vm_context);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_local_vmid);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid);
-KVM_NVHE_ALIAS(__kvm_tlb_flush_vmid_ipa);
-
 /* Symbols defined in vgic-v3-sr.c (not yet compiled with nVHE build rules). */
 KVM_NVHE_ALIAS(__vgic_v3_get_ich_vtr_el2);
 KVM_NVHE_ALIAS(__vgic_v3_init_lrs);
@@ -113,6 +107,14 @@ KVM_NVHE_ALIAS(panic);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
+/* Kernel symbol used by icache_is_vpipt(). */
+KVM_NVHE_ALIAS(__icache_flags);
+
+/* Kernel symbols needed for cpus_have_final/const_caps checks. */
+KVM_NVHE_ALIAS(arm64_const_caps_ready);
+KVM_NVHE_ALIAS(cpu_hwcap_keys);
+KVM_NVHE_ALIAS(cpu_hwcaps);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 8b0cf85080b5..87d3cce2b26e 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -14,7 +14,7 @@ obj-$(CONFIG_KVM) += hyp.o vhe/ nvhe/
 obj-$(CONFIG_KVM_INDIRECT_VECTORS) += smccc_wa.o
 
 hyp-y := vgic-v3-sr.o timer-sr.o aarch32.o vgic-v2-cpuif-proxy.o sysreg-sr.o \
-	 debug-sr.o entry.o switch.o fpsimd.o tlb.o
+	 debug-sr.o entry.o switch.o fpsimd.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index bf2d8dea5400..a5316e97d373 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_NVHE_HYPERVISOR__
 ccflags-y := -D__KVM_NVHE_HYPERVISOR__
 
-obj-y := hyp-init.o ../hyp-entry.o
+obj-y := tlb.o hyp-init.o ../hyp-entry.o
 
 obj-y := $(patsubst %.o,%.hyp.o,$(obj-y))
 extra-y := $(patsubst %.hyp.o,%.hyp.tmp.o,$(obj-y))
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
similarity index 62%
rename from arch/arm64/kvm/hyp/tlb.c
rename to arch/arm64/kvm/hyp/nvhe/tlb.c
index d063a576d511..9513ad41db9a 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -4,8 +4,6 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
-#include <linux/irqflags.h>
-
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/tlbflush.h>
@@ -16,52 +14,8 @@ struct tlb_inv_context {
 	u64		sctlr;
 };
 
-static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
-						 struct tlb_inv_context *cxt)
-{
-	u64 val;
-
-	local_irq_save(cxt->flags);
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/*
-		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
-		 * we cannot trust stage-1 to be in a correct state at that
-		 * point. Since we do not want to force a full load of the
-		 * vcpu state, we prevent the EL1 page-table walker to
-		 * allocate new TLBs. This is done by setting the EPD bits
-		 * in the TCR_EL1 register. We also need to prevent it to
-		 * allocate IPA->PA walks, so we enable the S1 MMU...
-		 */
-		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
-		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
-		write_sysreg_el1(val, SYS_TCR);
-		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
-		val |= SCTLR_ELx_M;
-		write_sysreg_el1(val, SYS_SCTLR);
-	}
-
-	/*
-	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
-	 * most TLB operations target EL2/EL0. In order to affect the
-	 * guest TLBs (EL1/EL0), we need to change one of these two
-	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
-	 * let's flip TGE before executing the TLB operation.
-	 *
-	 * ARM erratum 1165522 requires some special handling (again),
-	 * as we need to make sure both stages of translation are in
-	 * place before clearing TGE. __load_guest_stage2() already
-	 * has an ISB in order to deal with this.
-	 */
-	__load_guest_stage2(kvm);
-	val = read_sysreg(hcr_el2);
-	val &= ~HCR_TGE;
-	write_sysreg(val, hcr_el2);
-	isb();
-}
-
-static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
-						  struct tlb_inv_context *cxt)
+static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
+					     struct tlb_inv_context *cxt)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
@@ -84,37 +38,8 @@ static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
-static void __hyp_text __tlb_switch_to_guest(struct kvm *kvm,
-					     struct tlb_inv_context *cxt)
-{
-	if (has_vhe())
-		__tlb_switch_to_guest_vhe(kvm, cxt);
-	else
-		__tlb_switch_to_guest_nvhe(kvm, cxt);
-}
-
-static void __hyp_text __tlb_switch_to_host_vhe(struct kvm *kvm,
-						struct tlb_inv_context *cxt)
-{
-	/*
-	 * We're done with the TLB operation, let's restore the host's
-	 * view of HCR_EL2.
-	 */
-	write_sysreg(0, vttbr_el2);
-	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	isb();
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/* Restore the registers to what they were */
-		write_sysreg_el1(cxt->tcr, SYS_TCR);
-		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
-	}
-
-	local_irq_restore(cxt->flags);
-}
-
-static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
-						 struct tlb_inv_context *cxt)
+static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
+					    struct tlb_inv_context *cxt)
 {
 	write_sysreg(0, vttbr_el2);
 
@@ -126,15 +51,6 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 	}
 }
 
-static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
-					    struct tlb_inv_context *cxt)
-{
-	if (has_vhe())
-		__tlb_switch_to_host_vhe(kvm, cxt);
-	else
-		__tlb_switch_to_host_nvhe(kvm, cxt);
-}
-
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	struct tlb_inv_context cxt;
@@ -183,7 +99,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * The moral of this story is: if you have a VPIPT I-cache, then
 	 * you should be running with VHE enabled.
 	 */
-	if (!has_vhe() && icache_is_vpipt())
+	if (icache_is_vpipt())
 		__flush_icache_all();
 
 	__tlb_switch_to_host(kvm, &cxt);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 323029e02b4e..704140fc5d66 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -6,7 +6,7 @@
 asflags-y := -D__KVM_VHE_HYPERVISOR__
 ccflags-y := -D__KVM_VHE_HYPERVISOR__
 
-obj-y := ../hyp-entry.o
+obj-y := tlb.o ../hyp-entry.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
new file mode 100644
index 000000000000..35e8e112ba28
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ */
+
+#include <linux/irqflags.h>
+
+#include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
+#include <asm/tlbflush.h>
+
+struct tlb_inv_context {
+	unsigned long	flags;
+	u64		tcr;
+	u64		sctlr;
+};
+
+static void __tlb_switch_to_guest(struct kvm *kvm, struct tlb_inv_context *cxt)
+{
+	u64 val;
+
+	local_irq_save(cxt->flags);
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
+		/*
+		 * For CPUs that are affected by ARM errata 1165522 or 1530923,
+		 * we cannot trust stage-1 to be in a correct state at that
+		 * point. Since we do not want to force a full load of the
+		 * vcpu state, we prevent the EL1 page-table walker to
+		 * allocate new TLBs. This is done by setting the EPD bits
+		 * in the TCR_EL1 register. We also need to prevent it to
+		 * allocate IPA->PA walks, so we enable the S1 MMU...
+		 */
+		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
+		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
+		write_sysreg_el1(val, SYS_TCR);
+		val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
+		val |= SCTLR_ELx_M;
+		write_sysreg_el1(val, SYS_SCTLR);
+	}
+
+	/*
+	 * With VHE enabled, we have HCR_EL2.{E2H,TGE} = {1,1}, and
+	 * most TLB operations target EL2/EL0. In order to affect the
+	 * guest TLBs (EL1/EL0), we need to change one of these two
+	 * bits. Changing E2H is impossible (goodbye TTBR1_EL2), so
+	 * let's flip TGE before executing the TLB operation.
+	 *
+	 * ARM erratum 1165522 requires some special handling (again),
+	 * as we need to make sure both stages of translation are in
+	 * place before clearing TGE. __load_guest_stage2() already
+	 * has an ISB in order to deal with this.
+	 */
+	__load_guest_stage2(kvm);
+	val = read_sysreg(hcr_el2);
+	val &= ~HCR_TGE;
+	write_sysreg(val, hcr_el2);
+	isb();
+}
+
+static void __tlb_switch_to_host(struct kvm *kvm, struct tlb_inv_context *cxt)
+{
+	/*
+	 * We're done with the TLB operation, let's restore the host's
+	 * view of HCR_EL2.
+	 */
+	write_sysreg(0, vttbr_el2);
+	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
+	isb();
+
+	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
+		/* Restore the registers to what they were */
+		write_sysreg_el1(cxt->tcr, SYS_TCR);
+		write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
+	}
+
+	local_irq_restore(cxt->flags);
+}
+
+void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	kvm = kern_hyp_va(kvm);
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	/*
+	 * We could do so much better if we had the VA as well.
+	 * Instead, we invalidate Stage-2 for this IPA, and the
+	 * whole of Stage-1. Weep...
+	 */
+	ipa >>= 12;
+	__tlbi(ipas2e1is, ipa);
+
+	/*
+	 * We have to ensure completion of the invalidation at Stage-2,
+	 * since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
+	 * the Stage-1 invalidation happened first.
+	 */
+	dsb(ish);
+	__tlbi(vmalle1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_tlb_flush_vmid(struct kvm *kvm)
+{
+	struct tlb_inv_context cxt;
+
+	dsb(ishst);
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	__tlbi(vmalls12e1is);
+	dsb(ish);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct tlb_inv_context cxt;
+
+	/* Switch to requested VMID */
+	__tlb_switch_to_guest(kvm, &cxt);
+
+	__tlbi(vmalle1);
+	dsb(nsh);
+	isb();
+
+	__tlb_switch_to_host(kvm, &cxt);
+}
+
+void __kvm_flush_vm_context(void)
+{
+	dsb(ishst);
+	__tlbi(alle1is);
+
+	/*
+	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
+	 * is necessary across a VMID rollover.
+	 *
+	 * VPIPT caches constrain lookup and maintenance to the active VMID,
+	 * so we need to invalidate lines with a stale VMID to avoid an ABA
+	 * race after multiple rollovers.
+	 *
+	 */
+	if (icache_is_vpipt())
+		asm volatile("ic ialluis");
+
+	dsb(ish);
+}
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
