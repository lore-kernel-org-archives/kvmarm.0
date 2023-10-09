Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E945F59
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 23:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpdRf7Mr"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a397a7c1cso1044071276.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Oct 2023 16:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892949; x=1697497749; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cXPuzl6uaVFzYoq9buwIVqk8xkxt/D9RaR/u9SrhOvY=;
        b=NpdRf7MrhvSKspReJ3aD2wVa1W1QKOHeIJKHzFsprgd/kmo1q40ZrxsLWjOQD8BDKX
         WS4h27ZIPv4GAmQIhQgW0ofFP2HMFdDtXLvx2LUYjKR13P4527u9YZKkn4lIdNErfRDK
         iz66oEwtzdYOLeDud3h66IugcM2yeD5nD2QCJtohNTqZl62VHkQWtkCkYUmA7NYnB3Wr
         QsDOSslIM0SkxiC9K0jR5a9JSXDKMYr/HoRbcmNPE6cqu0mUxFOZUSPNLCrePnsM9EN9
         /jSPJwgrUokgMdnRW7b+Tj+hVmyCATJioo7j/qMitgrDTJDCmbW7cDkerBlpClW0oHZb
         7fZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892949; x=1697497749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXPuzl6uaVFzYoq9buwIVqk8xkxt/D9RaR/u9SrhOvY=;
        b=EisrXOMeJ0mvUpde6nqwmyre3yOxIy0phQjRLW0Uj/EBx9/tIx17FpD9BB0mHPHRQA
         lgaLjSgrZ4LHfqNb2kcbOfIY5dEkrypYepJ6c9ZjJdqYMQYoNcawgsdl+8zkS63h+m70
         5DGXDSJftg5fmhoxdCbKn7TBfzEGEWQnEXXM60B9cSPTUjJHjGKL9ZcOSLnc2I0dnnUC
         r6p/hHqqw56dR5IZKhlZFyRWE7R7/w8rh5OxYbreD1Jwj1V1a0Hl85icVTc3uqLD2VDP
         14x5rYDXOR0H6fwlm5U79/v02qlbhlJuqK4zTV5u46JgTXqmZoylyjt//S+nhpk4c8Os
         ex3Q==
X-Gm-Message-State: AOJu0YyKrCTuznR51cTatqE5nmCqw8Nb09mytp4/5iHjug/KCKTnOdIt
	9I442fboXyInXfqO/S8JB9srpiAmBUlL
X-Google-Smtp-Source: AGHT+IG4uRulO8JptMPCQ4DX/9b0/rpuNBezzxOn6tjqyRoJZpeMXHChmkbZ2aiMwc0/drTQ5DDqedDUYX2y
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a5b:584:0:b0:d7b:94f5:1301 with SMTP id
 l4-20020a5b0584000000b00d7b94f51301mr272090ybp.9.1696892949104; Mon, 09 Oct
 2023 16:09:09 -0700 (PDT)
Date: Mon,  9 Oct 2023 23:08:51 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-6-rananta@google.com>
Subject: [PATCH v7 05/12] KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
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
index 708a53b70a7b..0af4d6bbe3d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -854,8 +854,7 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 
 		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
-			kvm_pmu_handle_pmcr(vcpu,
-					    __vcpu_sys_reg(vcpu, PMCR_EL0));
+			kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
 		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
 			kvm_vcpu_pmu_restore_guest(vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index cc30c246c010..a161d6266a5c 100644
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
index 08af7824e9d8..ff0f7095eaca 100644
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
index 858ed9ce828a..cd980d78b86b 100644
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
2.42.0.609.gbb76f46606-goog

