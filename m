Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E291A5A8
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lQXQ9Ii4"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a61f7aaf8so1569351276.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 14:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838061; x=1698442861; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HzKv0aKoQ6Y11TCAac4g+R+SnDAhAHq7pzRLq3b0xvY=;
        b=lQXQ9Ii4GcFf9x4hkMMEE1qLGuu3cuFCXdjLOgzryTv1FVevbox3AnO/pKFQ7zWaSu
         6WrfAu4frsexbf85Bbbrw4bmF7prsfkIMohyNY/454VkkfcLCC+W1X9h3Fgr8iV/dr8T
         v/d2hZVvs2F1QGwA0Pqnqzb4wOYcYAHD9aCWN2YTsSZFkHDrccVHi/x1K+M+2phNO7qG
         HGTf2XRry8W7WnA0nFPuA95J9zQXhE71zzTeETlyQzn2GUuZi4uRcWdk8FYUbmlCm2J3
         AUXjRI/BnphKi9bd6M2m8kDIcw/5R+Sc1RDoORTthc+pohItccTxSAjRKa2i1IQGUQaA
         I3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838061; x=1698442861;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HzKv0aKoQ6Y11TCAac4g+R+SnDAhAHq7pzRLq3b0xvY=;
        b=dH3TbbCQ3x0Xs4yH5LnPUdxlgo5XyAEwlXI0egTuv5/BT8AcA+vg9uFwYxMB0dTKTK
         k4DGcWKcbD4YkY/Jw9m/a3aSpVrQybBtlf9sTrb0YvLjRx3xjcaMgE64DXha1YaunQx3
         xThz9k6qnbx7mAAH1kBstH8nGJW3jBlTH7KlNGq+BNMnbWvFGt59T3i+tHbFlA5X50Xx
         ghb2ORLiowdJ9rcAVWOUKdtWC5D/rF1AGFnG9Amv5tAZ07p3XekXK6pcSytb8onv3YHP
         cL0Q2uBUCo8/8GoDHWsS0uPvaTa9tRA37I3Hie2aP3yYjqGLI6TpmxX/sdJ9zDeTvL2H
         vg1g==
X-Gm-Message-State: AOJu0Yy2h2XM+sibF16G30au6wX376Bo+9hM/XvasB5vMKp8/jOU6ANC
	nc+sV4wTgvMj3ko7h0ChbkvsJKQm0Yvx
X-Google-Smtp-Source: AGHT+IEz81OMCPv2Iaq1w7pusbiHb7caWK+8uwpUHI9LXEqiprDd6246fiQePusr7USK+DANhtCWIqwUusMH
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:1083:b0:d9a:47ea:69a5 with SMTP
 id v3-20020a056902108300b00d9a47ea69a5mr87728ybu.1.1697838061072; Fri, 20 Oct
 2023 14:41:01 -0700 (PDT)
Date: Fri, 20 Oct 2023 21:40:44 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-5-rananta@google.com>
Subject: [PATCH v8 04/13] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on
 the associated PMU
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

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, the value is set to the same
value as the current PE on every vCPU reset.  Unless the vCPU is
pinned to PEs that has the PMU associated to the guest from the
initial vCPU reset, the value might be different from the PMU's
PMCR_EL0.N on heterogeneous PMU systems.

Fix this by setting the vCPU's PMCR_EL0.N to the PMU's PMCR_EL0.N
value. Track the PMCR_EL0.N per guest, as only one PMU can be set
for the guest (PMCR_EL0.N must be the same for all vCPUs of the
guest), and it is convenient for updating the value.

To achieve this, the patch introduces a helper,
kvm_arm_pmu_get_max_counters(), that reads the maximum number of
counters from the arm_pmu associated to the VM. Make the function
global as upcoming patches will be interested to know the value
while setting the PMCR.N of the guest from userspace.

KVM does not yet support userspace modifying PMCR_EL0.N.
The following patch will add support for that.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/pmu-emul.c         | 26 +++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 28 ++++++++++++++--------------
 include/kvm/arm_pmu.h             |  6 ++++++
 4 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 846a7706e925c..5653d3553e3ee 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -290,6 +290,9 @@ struct kvm_arch {
 
 	cpumask_var_t supported_cpus;
 
+	/* PMCR_EL0.N value for the guest */
+	u8 pmcr_n;
+
 	/* Hypercall features firmware registers' descriptor */
 	struct kvm_smccc_features smccc_feat;
 	struct maple_tree smccc_filter;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 097bf7122130d..9e24581206c24 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -690,6 +690,9 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	if (!entry)
 		goto out_unlock;
 
+	WARN_ON((pmu->num_events <= 0) ||
+		(pmu->num_events > ARMV8_PMU_MAX_COUNTERS));
+
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
@@ -873,11 +876,29 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	return true;
 }
 
+/**
+ * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
+ * @kvm: The kvm pointer
+ */
+int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/*
+	 * The arm_pmu->num_events considers the cycle counter as well.
+	 * Ignore that and return only the general-purpose counters.
+	 */
+	return arm_pmu->num_events - 1;
+}
+
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
+	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);
 }
 
 /**
@@ -1091,5 +1112,8 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
  */
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0) &
+			~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+
+	return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a31cecb3d29fb..faf97878dfbbb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -721,12 +721,7 @@ static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 n, mask = BIT(ARMV8_PMU_CYCLE_IDX);
 
-	/* No PMU available, any PMU reg may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
-	n &= ARMV8_PMU_PMCR_N_MASK;
+	n = vcpu->kvm->arch.pmcr_n;
 	if (n)
 		mask |= GENMASK(n - 1, 0);
 
@@ -762,17 +757,15 @@ static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
-	u64 pmcr;
+	u64 pmcr = 0;
 
-	/* No PMU available, PMCR_EL0 may UNDEF... */
-	if (!kvm_arm_support_pmu_v3())
-		return 0;
-
-	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
+	/*
+	 * The value of PMCR.N field is included when the
+	 * vCPU register is read via kvm_vcpu_read_pmcr().
+	 */
 	__vcpu_sys_reg(vcpu, r->reg) = pmcr;
 
 	return __vcpu_sys_reg(vcpu, r->reg);
@@ -1103,6 +1096,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+		    u64 *val)
+{
+	*val = kvm_vcpu_read_pmcr(vcpu);
+	return 0;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
@@ -2235,7 +2235,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SVCR), undef_access },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
-	  .reset = reset_pmcr, .reg = PMCR_EL0 },
+	  .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
 	{ PMU_SYS_REG(PMCNTENSET_EL0),
 	  .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
 	{ PMU_SYS_REG(PMCNTENCLR_EL0),
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index cd980d78b86b5..2e90f38090e6d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -102,6 +102,7 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
+int kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 #else
@@ -181,6 +182,11 @@ static inline int kvm_arm_set_default_pmu(struct kvm *kvm)
 	return -ENODEV;
 }
 
+static inline int kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.42.0.655.g421f12c284-goog

