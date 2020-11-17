Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CB0C83011
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A68812467A
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="u6eskt9l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A68812467A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B2194B559;
	Tue, 17 Nov 2020 13:17:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n2Wra-h1R6vT; Tue, 17 Nov 2020 13:17:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 180974B8A6;
	Tue, 17 Nov 2020 13:17:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24FA14B8CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82tplc3tNgmC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:09 -0500 (EST)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 904454B837
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:08 -0500 (EST)
Received: by mail-qv1-f74.google.com with SMTP id dp12so7862147qvb.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=YRRsngS9OD6tBnxQxVeL/idwsF6yEfmuwUZwYdjr4cI=;
 b=u6eskt9lKKmGSunnDChD5nx9UAFs54CCl+3VWgy6MyEcVVg8OeGSLy6w+3jrAgg5wo
 lIQFdYhOvLApYwomcOOT904ylp69grlIlOZX+z4g49TOTxv58iJt30YEMMbaDkgokaiV
 +kDh/6I2WkKdw1mI/OeSLV7yoQu8bc9QP/M3gsk0AO2v4897Wo4N8zHFREx6/Mmrycej
 FaBnrvSuEuIl+wMhPSOrswKNQVY/YQYHpDnZtnmHTfXn3RryY102vNLKNzxLh5JQxvcA
 ikQQMFvZGh6oA+q0po5wCBIIFKVotM758kswEkO/JkHpisi3Q+W2jTRHPSKvegIXFjFe
 7iFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=YRRsngS9OD6tBnxQxVeL/idwsF6yEfmuwUZwYdjr4cI=;
 b=jwmEKLKLHRroAjw3Ri4jm7jOIGJbfeZy46f6McZFGckssvbTP7Svk8SRc+y46AZO2z
 2kBJmUk86z1vYMG0cu3iLNVaGQ/ghN1seKBkZ0NhCJtMol+6b+b8xtqdWwc581W61q0u
 oNvet+PulmbE4rxhai4b01JW40d414hc/9rB+JcuR0ZRm026D/0ARVusmvL2mcWa8cFN
 FjseZjg1C+bWMjn6KyLPQW7V7OBMOIyOSuSEYcaq2Fl3MxLS/PeJ5Vy/Ic67n41nh1CF
 cKg61U3PFqVRfKVTymK281xD68T59rWEy+M/lptWSfXh/YQ3s5xdWi+IVcmxV36WAR9d
 YAEg==
X-Gm-Message-State: AOAM532/Jlvug9H15esSA8E5voElYvzbvjJ3RwVbMGr2ooNRXTdfE5rm
 dFPGcJWIBVtSnC+CcZnJvLeRyM0acSRT
X-Google-Smtp-Source: ABdhPJx5Z5F0VDtWsI/mKAVXvn+oRTGzalsg8aLfqcFVm74qRo8wjQOMWj3cl7sUTCwGro5vT2NLftM2aBIV
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a0c:e443:: with SMTP id
 d3mr975170qvm.18.1605637028048; Tue, 17 Nov 2020 10:17:08 -0800 (PST)
Date: Tue, 17 Nov 2020 18:16:01 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-22-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 21/27] KVM: arm64: Refactor kvm_arm_setup_stage2()
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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
index 714357ebd278..5a76358e8c7a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -256,6 +256,54 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
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
index 3e772ea4e066..074b39dbe539 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -384,19 +384,10 @@ int kvm_set_ipa_limit(void)
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
@@ -411,33 +402,8 @@ int kvm_arm_setup_stage2(struct kvm *kvm, unsigned long type)
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
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
