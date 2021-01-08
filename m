Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A883C433E6
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B646623998
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B646623998
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5801C4B409;
	Fri,  8 Jan 2021 07:16:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1EuO7agNnCwy; Fri,  8 Jan 2021 07:16:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2A874B45F;
	Fri,  8 Jan 2021 07:16:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AB14B444
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gXXfdhnXo04e for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:16:12 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 877A54B409
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:12 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id l8so15379668ybj.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=GhGffTy323Yc+svVJ64exq2jWsG8vcFR1ycW44G52EU=;
 b=X6LuXuqSMOCXGstdrtYG446m5i+SA1fYqx6i8lVcMTiFWou9/nsB7x54DWzDLtiES2
 Fg23HyDLfoSFjmty3TbmbhmEOSbW6X66j/PyorgqtZDJedMf1nv/dM7Df4ONZZasdtP+
 oviDJS3boNBbOZ1SjvbnT69MRbt0w9jfzZxYCO4RMNPfHjHmd9oog/roAMMYEufaINzT
 zYTfYjpPDKiu0l/EjrI/FMMuYWp7uMozeSwxThsvSBBsqTPI5+0KkRnj4Iv1DOX+dWG+
 yQhZXVMYJN50EtL1lDp1OlkTlYOl8wC7/26msdhpKU4wBvO4tM+j0JWx6Z+xbDiQcwZ2
 YXzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GhGffTy323Yc+svVJ64exq2jWsG8vcFR1ycW44G52EU=;
 b=nRKXoYyVwS+nD+N8Fk1GgkxbXk/+9XCQx1m01g0gSt5BPRO/JokZcVCjdOxdYiYzKJ
 33xXhkzJM0+8xUQpn7QR2tYQsjI+07iOKxHWnzoNOOpgsHDm0wD1MHKC0EUstkqFcpvp
 4F9h5gLUka5V6FlW9/w6F9XKuWqmT88g+8ujE2qZb7DvNta1fhT7jgP2n2HFsZovrbkm
 1/4fmyT0zQ+sUx0bAJCfylx5EvmoHKo7LorOoURhj+MtRsr1uC/m6wL5Nl0Adu+CeI2S
 0HYZAPnQ0oDfYcLht09QuIA+8X24KQCePawVBQUSZrcQho1LUHmQG0QltjGZCIosmWbL
 5L+A==
X-Gm-Message-State: AOAM532b/12ok1o7jDUqPqacsB631mD96PaUbv8S4wA66ECzjaCQ3gNQ
 LtuEeQouDDpmDURYAWQFZOnyxgRwQWDI
X-Google-Smtp-Source: ABdhPJy5ayKMRyDgH4Jki/zohuoMLZrHsKaWpuc3Szg88TgJjpuy2vC9qXyeS+x0GSaUvDCuYV8J0Q+G2MHJ
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a25:69d1:: with SMTP id
 e200mr5049678ybc.3.1610108172058; Fri, 08 Jan 2021 04:16:12 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:19 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-22-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 21/26] KVM: arm64: Refactor kvm_arm_setup_stage2()
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
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

In order to re-use some of the stage 2 setup at EL2, factor parts of
kvm_arm_setup_stage2() out into static inline functions.

No functional change intended.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 48 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c           | 42 +++-------------------------
 2 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 662f0415344e..83b4c5cf4768 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -280,6 +280,54 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 	return ret;
 }
 
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
+/*
+ * The VTCR value is common across all the physical CPUs on the system.
+ * We use system wide sanitised values to fill in different fields,
+ * except for Hardware Management of Access Flags. HA Flag is set
+ * unconditionally on all CPUs, as it is safe to run with or without
+ * the feature and the bit is RES0 on CPUs that don't support it.
+ */
+static inline u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
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
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
 static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
