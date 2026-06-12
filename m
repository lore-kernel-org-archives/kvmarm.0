Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D784F3ACA5E
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292573; cv=none; b=FBQ88ejfUk4hFWwrSPa1lNkvpruIugxA7fbjLw/sl+3YLp7uHjsFfrgfJR0H57xk73M5m9wfVzHE9btM68OOePjMX36AnvnCRWKcD+yyb3/j3OxMt6SA998iRWqt3eijrV8Uv6acsutQTYptsDrtATWjVbr+BPnxoIww67R40/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292573; c=relaxed/simple;
	bh=0to4/ihJht/FqtAHs4iUYvZvyFbsAXk6Avft6FDns1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g5entftCtLZVl45d7mpgrYUT31RlkHN5IenNXwH5AsuAXJ1hTujNNTlmnDubiIhr+VIjhxc2H/y75Hx+WJvJadvRPeUhxVyfzOSRmIvVSzMafo4EmgTyJyyouiTSN/L5vVdrhLSe0XU5/8o8ugHgot50KXZoGbPaanOIQmfasYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJjnBItT; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJjnBItT"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-486a2231742so2184472b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292564; x=1781897364; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeOBnz88LAlhog5jirlBqQZyuxdGojHS56ePpzSH+kM=;
        b=pJjnBItT5SUVzjfresPFGaCsbRDF+54T9wG4Qn0Zlrug6ZdxE1waGTmo9sD3afzcXG
         OiJB/91vc/HOoxM6we6yb1QEWYfjyCnr1Tdjpoihwz66LXFts7Cma49tvZWvfO1GtqcC
         ZGUfpQ1J1YJyFYJjMzsk2UrjDtshouaKbywrO2/f5yvN3Bjnko7Y56Bm3wThDBYaEZag
         sVZPjIARBEwq97Vkvbv9goAbrXRnGSi2iGMXyAmclLCbFOelF+EJw+LVl6RGTnuCNXQ0
         fvb1aZvMZFOVYs+XXCRd3mEK0UGl2DeBTJ72SV9scCcS3asIlTmd6SitHIxHvXNz2isl
         LcsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292564; x=1781897364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OeOBnz88LAlhog5jirlBqQZyuxdGojHS56ePpzSH+kM=;
        b=RQhPh0uUK0+Oz+d3t9L+YQjxFNqwVyQ+pHyvcWW45JvvzrHYdO+HkkRp6JtB8yd4pt
         t31AnUrqi3VJGkA+7E4FJK8mmvRY2P+ksz8QGbwd4F7ncmWkhtvzQTn2GNO1lVHq5a5l
         pOZWUNIvKK5q13KARYNkzw/nvuRqh2mr3iOEtZcKUS0lsH2IW+pv8102tiqIDcftLNlr
         pG5qQWfGQbuX0gx4Pncieytwwei3119fvul6gfm5ADtQpkhjMxcGHNHSgw/tXecvplDj
         qv/gIYEnZhqLK8k2eJFCEiQD0FOilLLF6ivnxqVvh0KTDrTd1x9ivHR6Sv2aVU1OSaX4
         f1sQ==
X-Forwarded-Encrypted: i=1; AFNElJ8iXeW1MhfqHCloNk8AU/79C9G0zGyIo6Slkxebgbye3AvkHlZOUQCNgymJy3QzuhXOKPYSxhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBPRH36qivwMd9NqZl2IPd+PkPyGotvzYJcEo5HA6iSuE96Uto
	hUpB5TwXGQw8qg6T/dd9iH2F85uzxNkTReMpv369bAQIJW/Huf3kGIotC85S3AGNEm35G9yLYXE
	QDkm9Imo3NvSnR3WuqKwpItQfVA==
X-Received: from ilbea21-n1.prod.google.com ([2002:a05:6e02:4515:10b0:501:bba8:87a4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:159c:b0:486:cab8:cb7e with SMTP id 5614622812f47-4872dd9f213mr2437196b6e.1.1781292564301;
 Fri, 12 Jun 2026 12:29:24 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:03 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-16-coltonlewis@google.com>
Subject: [PATCH 15/21] KVM: arm64: Implement lazy PMU context swaps
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Since many guests will never touch the PMU, they need not pay the cost
of context swapping those registers.

Use an enum to implement a simple state machine for PMU register
access. The PMU is either free or guest owned. We only need to context
swap if the PMU registers are guest owned. The PMU initially starts as
free and only transitions to guest owned if a guest has touched the
PMU registers.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/include/asm/kvm_types.h |  6 +++++-
 arch/arm64/kvm/debug.c             |  5 +++--
 arch/arm64/kvm/pmu-direct.c        | 21 +++++++++++++++++++--
 arch/arm64/kvm/sys_regs.c          | 29 ++++++++++++++++-------------
 include/kvm/arm_pmu.h              |  8 ++++++++
 6 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c7e9b92dfbd3..32573b10d9c5b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1445,6 +1445,7 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 	return cpus_have_final_cap(ARM64_SPECTRE_V3A);
 }
 
+void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu);
 void kvm_init_host_debug_data(void);
 void kvm_debug_init_vhe(void);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index 9a126b9e2d7c9..4e39cbc80aa0b 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -4,5 +4,9 @@
 
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
 
-#endif /* _ASM_ARM64_KVM_TYPES_H */
+enum vcpu_pmu_register_access {
+	VCPU_PMU_ACCESS_FREE,
+	VCPU_PMU_ACCESS_GUEST_OWNED,
+};
 
+#endif /* _ASM_ARM64_KVM_TYPES_H */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index c84321277d893..ab80325e67c5c 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -35,7 +35,7 @@ static int cpu_has_spe(u64 dfr0)
  *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *  - Self-hosted Trace (MDCR_EL2_TTRF/MDCR_EL2_E2TB)
  */
-static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
 
@@ -63,7 +63,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		 * fine grain traps and enforce counter access with
 		 * HPMN.
 		 */
-		if (!vcpu_on_unsupported_cpu(vcpu) &&
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED &&
+		    !vcpu_on_unsupported_cpu(vcpu) &&
 		    cpus_have_final_cap(ARM64_HAS_FGT) &&
 		    (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0)) {
 			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR | MDCR_EL2_HPMN);
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 044f011c9c84b..bb1f3dca03869 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -269,7 +269,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	 * If we aren't guest-owned then we know the guest isn't using
 	 * the PMU anyway, so no need to bother with the swap.
 	 */
-	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+	if (vcpu->arch.pmu.access != VCPU_PMU_ACCESS_GUEST_OWNED)
 		return;
 
 	preempt_disable();
@@ -343,7 +343,7 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	 * accessing the PMU anyway, so no need to bother with the
 	 * swap.
 	 */
-	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+	if (vcpu->arch.pmu.access != VCPU_PMU_ACCESS_GUEST_OWNED)
 		return;
 
 	preempt_disable();
@@ -388,3 +388,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	kvm_pmu_set_guest_counters(pmu, 0);
 	preempt_enable();
 }
+
+/**
+ * kvm_pmu_set_guest_owned() - Give PMU ownership to guest
+ * @vcpu: Pointer to vcpu struct
+ *
+ * Reconfigure the guest for physical access of PMU hardware if
+ * allowed. This means reconfiguring mdcr_el2.
+ *
+ */
+void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu)
+{
+	if (kvm_pmu_is_partitioned(vcpu->kvm) &&
+	    vcpu->arch.pmu.access == VCPU_PMU_ACCESS_FREE) {
+		vcpu->arch.pmu.access = VCPU_PMU_ACCESS_GUEST_OWNED;
+		kvm_arm_setup_mdcr_el2(vcpu);
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 94572bc52c32a..f0eebeeb5ed96 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1085,15 +1085,17 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 	u64 mask;
 	int idx;
 
+	kvm_pmu_set_guest_owned(vcpu);
+
 	switch (reg) {
 	case PMCR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			kvm_pmu_direct_pmcr_write(vcpu, val);
 		else
 			kvm_pmu_handle_pmcr(vcpu, val);
 		break;
 	case PMSELR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			write_sysreg(val, pmselr_el0);
 		else
 			__vcpu_assign_sys_reg(vcpu, reg, val);
@@ -1101,7 +1103,7 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
 		idx = reg - PMEVCNTR0_EL0;
 
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			if (idx == ARMV8_PMU_CYCLE_IDX)
 				write_sysreg(val, pmccntr_el0);
 			else
@@ -1122,7 +1124,7 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		}
 		break;
 	case PMCNTENSET_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			if (set)
 				write_sysreg(val, pmcntenset_el0);
 			else
@@ -1139,7 +1141,7 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		}
 		break;
 	case PMINTENSET_EL1:
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			if (set)
 				write_sysreg(val, pmintenset_el1);
 			else
@@ -1166,7 +1168,7 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		local_irq_restore(flags);
 		break;
 	case PMUSERENR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			write_sysreg(val, pmuserenr_el0);
 		else
 			__vcpu_assign_sys_reg(vcpu, reg, val);
@@ -1175,7 +1177,6 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		WARN_ON(1);
 		break;
 	}
-
 }
 
 /**
@@ -1192,15 +1193,17 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 	u64 val = 0;
 	int idx;
 
+	kvm_pmu_set_guest_owned(vcpu);
+
 	switch (reg) {
 	case PMCR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			val = kvm_pmu_direct_pmcr_read(vcpu);
 		else
 			val = kvm_vcpu_read_pmcr(vcpu);
 		break;
 	case PMSELR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			val = read_sysreg(pmselr_el0);
 		else
 			val = __vcpu_sys_reg(vcpu, reg);
@@ -1208,7 +1211,7 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
 		idx = reg - PMEVCNTR0_EL0;
 
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			if (idx == ARMV8_PMU_CYCLE_IDX)
 				val = read_sysreg(pmccntr_el0);
 			else
@@ -1221,7 +1224,7 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 		val = __vcpu_sys_reg(vcpu, reg);
 		break;
 	case PMCNTENSET_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			val = read_sysreg(pmcntenset_el0);
 			val &= kvm_pmu_guest_counter_mask(vcpu->kvm->arch.arm_pmu);
 		} else {
@@ -1229,7 +1232,7 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 		}
 		break;
 	case PMINTENSET_EL1:
-		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED) {
 			val = read_sysreg(pmintenset_el1);
 			val &= kvm_pmu_guest_counter_mask(vcpu->kvm->arch.arm_pmu);
 		} else {
@@ -1240,7 +1243,7 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 		val = __vcpu_sys_reg(vcpu, reg);
 		break;
 	case PMUSERENR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
 			val = read_sysreg(pmuserenr_el0);
 		else
 			val = __vcpu_sys_reg(vcpu, reg);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 61f8d4ed35e10..b77ddb94dc99b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,7 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 #include <linux/perf/arm_pmu.h>
@@ -43,6 +44,7 @@ struct kvm_pmu {
 	int irq_num;
 	bool created;
 	bool irq_level;
+	enum vcpu_pmu_register_access access;
 };
 
 struct arm_pmu_entry {
@@ -103,6 +105,9 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
+void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
+
+#define kvm_pmu_get_access(vcpu)	((vcpu)->arch.pmu.access)
 
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
@@ -147,6 +152,8 @@ static inline bool kvm_pmu_is_partitioned(struct kvm *kvm)
 {
 	return false;
 }
+
+#define kvm_pmu_get_access(vcpu)	(VCPU_PMU_ACCESS_FREE)
 static inline void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val) {}
 static inline u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 {
@@ -154,6 +161,7 @@ static inline u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 }
 static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
-- 
2.54.0.1136.gdb2ca164c4-goog

