Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A8FC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E74464FAB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E74464FAB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF594B631;
	Wed, 10 Mar 2021 12:58:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FQg5NA+ARATm; Wed, 10 Mar 2021 12:58:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D140B4B683;
	Wed, 10 Mar 2021 12:58:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3013A4B669
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1RZVTNx+ZRmb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:41 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D28C24B661
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:40 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id v5so2968385wml.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5IlrHyzKGX66i7zKiJ2V9j/u7ly1Dp8Z1hyFGz/2u64=;
 b=iVAj6JJV6CazuRaEPHki7YV1asV87XjurUX2cUuvZ+I5M5+7StJNzXQ21pGTkVmDPz
 2aczpVWNfqn7LkeVOxA4/yeE8nSN0ITE4MVenhoN2DdY+LEMGGlGB6dS2Fm2BhIRJXLD
 rSiLrmFClj4NldUmlaELdYXImbF1cUAqAObLSzjCF0Z6iB1wX08jVJ8aRTSKpGuuFLXC
 KLzpf94b1W+zksuPkHDjocduv3XlZIR/2ciHM7qd+bkMsL0xXUzrYwM98UcwaCO40nwX
 HBdxVkjPx1O/4/9AeMOtCur4ZXKGvLW3PbkmYR/LKB2Hovbu36MfZT+uDT99TDt7FF6c
 mAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5IlrHyzKGX66i7zKiJ2V9j/u7ly1Dp8Z1hyFGz/2u64=;
 b=NjmcIQyYjEiKf2pZ2MSm81kSpmFHIBfEYq6zV6yuawTDSx8t8klZBBhU9EHJde8FSY
 4umS9xMUV4addLrP0SLpTeS6Vi4l3lmNojPasWEaTE/5L42biD1uOHcwIi3HNamRGdKy
 GNIstT2mkwFFq5MIE83/bMdbgGOPqfCoLRrkrVxIaOG2S9yJ+6VOZz+vj16zw7islcTe
 8Ix3iB/lGlK8om3bp3t1h3NUf9eDxv/rFRwV5qU1mqAgMBiaZv7tWYqtV4FzmBE3H90d
 lvauak5rCL4tX9UGOMthnKEJtONQfccAL/TRYoMix9mzKte8ThdtBSUL9V9p2YyZEVU6
 neHQ==
X-Gm-Message-State: AOAM5328ifQ7VbhXDHhKfcM8xrHABR2xfcU9eIOlf2vozvV6wo5NVKTM
 BWZ1xv7gjwXKTzSwBCdtti7o6VcPMLA3
X-Google-Smtp-Source: ABdhPJxGHzNd7t0P9DMTeyoCUCJ6fZLjg9pp9aeQh2h0lWdksae5/FeYBt7pbAYrMnYAs7rK3cYXZJFsHPtR
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:6243:: with SMTP id
 w64mr1336092wmb.0.1615399119789; Wed, 10 Mar 2021 09:58:39 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:38 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-22-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 21/34] KVM: arm64: Refactor kvm_arm_setup_stage2()
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

In order to re-use some of the stage 2 setup code at EL2, factor parts
of kvm_arm_setup_stage2() out into separate functions.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 26 +++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 32 +++++++++++++++++++++
 arch/arm64/kvm/reset.c               | 42 +++-------------------------
 3 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7945ec87eaec..9cdc198ea6b4 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,6 +13,16 @@
 
 #define KVM_PGTABLE_MAX_LEVELS		4U
 
+static inline u64 kvm_get_parange(u64 mmfr0)
+{
+	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
+				ID_AA64MMFR0_PARANGE_SHIFT);
+	if (parange > ID_AA64MMFR0_PARANGE_MAX)
+		parange = ID_AA64MMFR0_PARANGE_MAX;
+
+	return parange;
+}
+
 typedef u64 kvm_pte_t;
 
 /**
@@ -159,6 +169,22 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt);
 int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			enum kvm_pgtable_prot prot);
 
+/**
+ * kvm_get_vtcr() - Helper to construct VTCR_EL2
+ * @mmfr0:	Sanitized value of SYS_ID_AA64MMFR0_EL1 register.
+ * @mmfr1:	Sanitized value of SYS_ID_AA64MMFR1_EL1 register.
+ * @phys_shfit:	Value to set in VTCR_EL2.T0SZ.
+ *
+ * The VTCR value is common across all the physical CPUs on the system.
+ * We use system wide sanitised values to fill in different fields,
+ * except for Hardware Management of Access Flags. HA Flag is set
+ * unconditionally on all CPUs, as it is safe to run with or without
+ * the feature and the bit is RES0 on CPUs that don't support it.
+ *
+ * Return: VTCR_EL2 value
+ */
+u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift);
+
 /**
  * kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d79c8094cdd..296675e5600d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <asm/kvm_pgtable.h>
+#include <asm/stage2_pgtable.h>
 
 #define KVM_PTE_VALID			BIT(0)
 
@@ -449,6 +450,37 @@ struct stage2_map_data {
 	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
+u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
+{
+	u64 vtcr = VTCR_EL2_FLAGS;
+	u8 lvls;
+
+	vtcr |= kvm_get_parange(mmfr0) << VTCR_EL2_PS_SHIFT;
+	vtcr |= VTCR_EL2_T0SZ(phys_shift);
+	/*
+	 * Use a minimum 2 level page table to prevent splitting
+	 * host PMD huge pages at stage2.
+	 */
+	lvls = stage2_pgtable_levels(phys_shift);
+	if (lvls < 2)
+		lvls = 2;
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
+
+	/*
+	 * Enable the Hardware Access Flag management, unconditionally
+	 * on all CPUs. The features is RES0 on CPUs without the support
+	 * and must be ignored by the CPUs.
+	 */
+	vtcr |= VTCR_EL2_HA;
+
+	/* Set the vmid bits */
+	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
+		VTCR_EL2_VS_16BIT :
+		VTCR_EL2_VS_8BIT;
+
+	return vtcr;
+}
+
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
 				    struct stage2_map_data *data)
 {
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..6aae118c960a 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -332,19 +332,10 @@ int kvm_set_ipa_limit(void)
 	return 0;
 }
 
-/*
- * Configure the VTCR_EL2 for this VM. The VTCR value is common
- * across all the physical CPUs on the system. We use system wide
- * sanitised values to fill in different fields, except for Hardware
- * Management of Access Flags. HA Flag is set unconditionally on
- * all CPUs, as it is safe to run with or without the feature and
- * the bit is RES0 on CPUs that don't support it.
- */
 int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 {
-	u64 vtcr = VTCR_EL2_FLAGS, mmfr0;
-	u32 parange, phys_shift;
-	u8 lvls;
+	u64 mmfr0, mmfr1;
+	u32 phys_shift;
 
 	if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
 		return -EINVAL;
@@ -359,33 +350,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
 	}
 
 	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
-	parange = cpuid_feature_extract_unsigned_field(mmfr0,
-				ID_AA64MMFR0_PARANGE_SHIFT);
-	if (parange > ID_AA64MMFR0_PARANGE_MAX)
-		parange = ID_AA64MMFR0_PARANGE_MAX;
-	vtcr |= parange << VTCR_EL2_PS_SHIFT;
-
-	vtcr |= VTCR_EL2_T0SZ(phys_shift);
-	/*
-	 * Use a minimum 2 level page table to prevent splitting
-	 * host PMD huge pages at stage2.
-	 */
-	lvls = stage2_pgtable_levels(phys_shift);
-	if (lvls < 2)
-		lvls = 2;
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
-
-	/*
-	 * Enable the Hardware Access Flag management, unconditionally
-	 * on all CPUs. The features is RES0 on CPUs without the support
-	 * and must be ignored by the CPUs.
-	 */
-	vtcr |= VTCR_EL2_HA;
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	kvm->arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
 
-	/* Set the vmid bits */
-	vtcr |= (kvm_get_vmid_bits() == 16) ?
-		VTCR_EL2_VS_16BIT :
-		VTCR_EL2_VS_8BIT;
-	kvm->arch.vtcr = vtcr;
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
