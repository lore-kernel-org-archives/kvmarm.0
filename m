Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E6F4998F
	for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 23:40:17 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59f6902dc8bso129576357b3.0
        for <kvmarm@lists.linux.dev>; Tue, 26 Sep 2023 16:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771617; x=1696376417; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SOO0Owg6z13+zclWBI3i6GF1p4XONQg1yPDHHPPUyLA=;
        b=AcYI6LyI2tUKLklUSAu64YD3KT38iwNPuOgO7gRhLlcyMcB4kX5hBCqcf6VmhdRr8+
         cWIkFK/3BwuaNBRHTJeJvRH0AkF2W4R2AfI+gmM6rF+k10Hml0SUjUn/v0FA4dL71YwQ
         qC3Tiq7eQukZAxkDsCgWwl+Ug/gpjGcGyBtQ1oi5DDdBz3tdZApsKnKikKav3+7j6dOT
         baoBsEfp2jdMQScGV0ZbwuaLIkZfdfpleG5W+gm9BaePzFFfGzwX2LHzPreb/lNfXz9Y
         MiF4ndONjsKw/o4n7XQo5R2twGyy+vWDP5O36SMoSDFUZmPQrBHtd2UEPrwKkgNaqXmq
         0ILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771617; x=1696376417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SOO0Owg6z13+zclWBI3i6GF1p4XONQg1yPDHHPPUyLA=;
        b=sldXGBLhKLuMtOIomS99v5VxKmemfTb/Ju+sXLgfPsGPXH8doOdWRMAqUmSjjlPxQG
         z40+m8JGP9rxEEs7jMdo1B1jZ8kz59n7aVXUWyul6sqQi7A4QHgvgyvSl/ZaRuHetkw2
         GVgCi72TV/tNCfDNJ+v5IWNo5Ui9Rs9uu6knJIXEO6RZAkI4tSciv1fwBcXbC5XR4LqF
         DbS/bd2tBgYARYLP0hHRg3CHRFYBKIG98VZQ7u+EkiVEcmEfLeR8gZYX5LNHBz45z308
         FX6pL9cgE+KYYKXORxt+QvPwreWPYYW7DDC63jX5UecxPBbYAJyKLIgpuhM/f4dNa+Xa
         qhwA==
X-Gm-Message-State: AOJu0YzmO0ByKpt/ccH+n7KwYHKu5u2BVKfZa9fPghdSZXPWyU7Lv1md
	4e/HC5iRMZzTzyUygzB0ZLZWrWYGZK05
X-Google-Smtp-Source: AGHT+IGUgid3XJfM7WrI6SnBJ34jSBPnUHYgXF7YKekwIi79TmqyisbuzEStEJAn2EbwUP4ouzwhqXm/LTHk
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:ae01:0:b0:d89:4776:5d6b with SMTP id
 a1-20020a25ae01000000b00d8947765d6bmr4133ybj.5.1695771616728; Tue, 26 Sep
 2023 16:40:16 -0700 (PDT)
Date: Tue, 26 Sep 2023 23:40:02 +0000
In-Reply-To: <20230926234008.2348607-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230926234008.2348607-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-6-rananta@google.com>
Subject: [PATCH v6 05/11] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Reiji Watanabe <reijiw@google.com>

Add a helper to read a vCPU's PMCR_EL0, and use it when KVM
reads a vCPU's PMCR_EL0.

The PMCR_EL0 value is tracked by a sysreg file per each vCPU.
The following patches will make (only) PMCR_EL0.N track per guest.
Having the new helper will be useful to combine the PMCR_EL0.N
field (tracked per guest) and the other fields (tracked per vCPU)
to provide the value of PMCR_EL0.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c      |  3 +--
 arch/arm64/kvm/pmu-emul.c | 21 +++++++++++++++------
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     |  6 ++++++
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea3..86cafe5a6010b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -801,8 +801,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 998e1bbd5310d..d89438956f7d3 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -72,7 +72,7 @@ static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
 {
-	u64 val = __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), PMCR_EL0);
+	u64 val = kvm_vcpu_read_pmcr(kvm_pmc_to_vcpu(pmc));
 
 	return (pmc->idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
 	       (pmc->idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
@@ -250,7 +250,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = kvm_vcpu_read_pmcr(vcpu) >> ARMV8_PMU_PMCR_N_SHIFT;
 
 	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
@@ -272,7 +272,7 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -324,7 +324,7 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = 0;
 
-	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E)) {
+	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
 		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
@@ -426,7 +426,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 {
 	int i;
 
-	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
 		return;
 
 	/* Weed out disabled counters */
@@ -569,7 +569,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	return (__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
+	return (kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) &&
 	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
 }
 
@@ -1084,3 +1084,12 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 					      ID_AA64DFR0_EL1_PMUVer_V3P5);
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
 }
+
+/**
+ * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
+ * @vcpu: The vcpu pointer
+ */
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 66b9e1de54230..5ae7399f2b822 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -803,7 +803,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		 * Only update writeable bits of PMCR (continuing into
 		 * kvm_pmu_handle_pmcr() as well)
 		 */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		val = kvm_vcpu_read_pmcr(vcpu);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
@@ -811,7 +811,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
+		val = kvm_vcpu_read_pmcr(vcpu)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -860,7 +860,7 @@ static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
 	u64 pmcr, val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	pmcr = kvm_vcpu_read_pmcr(vcpu);
 	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b80c75d80886b..c6a5e49b850ab 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -103,6 +103,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
 
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -180,6 +181,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.42.0.582.g8ccd20d70d-goog

