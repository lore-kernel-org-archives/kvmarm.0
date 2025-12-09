Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2221D30CD95
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313571; cv=none; b=Ne1NhcZWhhpVv0xglmtqjCDThTbEj2Atv9eu3wsoHNwCyYoEXjO5hkv6TzJIJfPuagh4UyeTxgsv7qdTaaebiKJQxRhk6B9zx4cyyQgS+ZtbuprlJTBeta4rp+IjvdOFoSPgoD1XvkdUY4B10gnmjEixROKwUZwEExasCTAl/2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313571; c=relaxed/simple;
	bh=Qz4r177CFGhy0LXqT9yrizG49NOxmJkZrufdw1DdziU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WMH+31K19zDXSQGfmKblSZCRNKMf+ZnfNG4lIm6PlUEaJtwK87rwYLFxY4+YjbmBk5/dDrBxyCSTAgKH/0J6vSmi10vcjIOrDBa0jvuca0McywoZ0mpRmQcVzQerji4xwJpVYrY2/iQbztZaFfuNzwOOsd065kp74162dlYywqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O8y25Po/; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O8y25Po/"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6574a047ec5so4837039eaf.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313563; x=1765918363; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/sFeK5VmbytXpjUspgl5j2szwkI07ChP0duwQoez5c=;
        b=O8y25Po/Y/1FJT3w7EwN0o46pAvtNVv0hGb+GTZhcOtmHbpy2SFY9jyOQcIrdDVydc
         R88iWYi8NzQlGbj0/QfoFtWA/3hVYBgv8DvLkiTL8oVMBJJnOsmxhoqEBdNhQQVn6ep4
         aMd9cGAZ7l3s3xZ+aAsJS+2DbQXnexw8OZlCQ2/81c7CwYMVk7RbH6tvh0kNRYrsq2so
         jT9d+8M95dGn4h3Un01f7MxTNkQc3NxjQHmsJQFOcyEEiUSwD/6+MLR1ssa/RE0ir8wy
         0NCi+7tXe8bYi3xnYe0Pgw4DFe3+HXTvIbpyjWv7fkYl+lvw4Z69mqo7n3YC1ITTrLZR
         hkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313563; x=1765918363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/sFeK5VmbytXpjUspgl5j2szwkI07ChP0duwQoez5c=;
        b=n/RPJWDLarz6W6Quz6HCoHtRBaolVvtj+zLIXDKGwIdE+ead/l/KcIcqCp6Et/PBsB
         voIbONs51oxAbb4+P3rUKcbwCxvfTjs3zn2SUpcLF/xjIL+v0kh9sPIWbWr34dMic/YU
         +zJXoXxqhLCHc7OsGipF3lEa4/p/BRuuC149VDwnGu7/g+WU8mu9oaG+KGh/eDl3efck
         VokSqNl3jLmxtgqYUGmeHhBjPmhR4ynNPVa1/uwH/ZqqnKrc0yqYJ43lkLuHKjo1aLDn
         rMbmfZQOzo6D617ENXvqA7+PlxMe4eKak3WOK5wXOGP6EXWlGOmZWkZ9Gc+6lXlZvor9
         r3yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvvBAMJXGkq26bIi/dI4oxsmKnWg1WA+LObhV4zIU9d4+bTxJyo2gpM0XmrWSFPosPpvRI6jo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCiP1AIn5Drc7+FPAgwH917ZppJjsMN342925jACOAFVG+8JjP
	ntActNJ6iEpBKv4reUMXS96aQKlsKcjLrjzxaZaigKgAmbYQ3e3/06HdE+ISoRdMPERJSk1oYFl
	VwTc4Ze+qcgdabBdWXzRpkvCjFQ==
X-Google-Smtp-Source: AGHT+IE/HaqRyprFnQdYwiWTY8frwPnLF0+hPo1GlYvxcyhgVPd88+4NFT3OoEIrs06Xz4mz8hzl498G4Aoi8k4qdw==
X-Received: from ilbbd2.prod.google.com ([2002:a05:6e02:3002:b0:436:f324:48])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2207:b0:65b:2869:c616 with SMTP id 006d021491bc7-65b2ac078bfmr114176eaf.33.1765313563180;
 Tue, 09 Dec 2025 12:52:43 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:14 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-18-coltonlewis@google.com>
Subject: [PATCH v5 17/24] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Save and restore newly untrapped registers that can be directly
accessed by the guest when the PMU is partitioned.

* PMEVCNTRn_EL0
* PMCCNTR_EL0
* PMICNTR_EL0
* PMUSERENR_EL0
* PMSELR_EL0
* PMCR_EL0
* PMCNTEN_EL0
* PMINTEN_EL1

If we know we are not using FGT (that is, trapping everything), then
return immediately. Either the PMU is not partitioned, or it is but
all register writes are being written through the VCPU fields to
hardware, so all values are fresh.

Since we are taking over context switching, avoid the writes to
PMSELR_EL0 and PMUSERENR_EL0 that would normally occur in
__{,de}activate_traps_common()

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h        |   4 +
 arch/arm64/kvm/arm.c                    |   2 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |   4 +-
 arch/arm64/kvm/pmu-direct.c             | 112 ++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 8b634112eded2..25a5eb8c623da 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -103,6 +103,8 @@ void kvm_pmu_host_counters_disable(void);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+void kvm_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
@@ -184,6 +186,8 @@ static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 43e92f35f56ab..1750df5944f6d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -629,6 +629,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_pmu_load(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -671,6 +672,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	kvm_pmu_put(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 40bd00df6c58f..bde79ec1a1836 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -311,7 +311,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
 	 * EL1 instead of being trapped to EL2.
 	 */
-	if (system_supports_pmuv3()) {
+	if (system_supports_pmuv3() && !kvm_vcpu_pmu_is_partitioned(vcpu)) {
 		write_sysreg(0, pmselr_el0);
 
 		ctxt_sys_reg(hctxt, PMUSERENR_EL0) = read_sysreg(pmuserenr_el0);
@@ -340,7 +340,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 
 	write_sysreg(0, hstr_el2);
-	if (system_supports_pmuv3()) {
+	if (system_supports_pmuv3() && !kvm_vcpu_pmu_is_partitioned(vcpu)) {
 		write_sysreg(ctxt_sys_reg(hctxt, PMUSERENR_EL0), pmuserenr_el0);
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 7fb4fb5c22e2a..71977d24f489a 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -9,6 +9,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
 #include <asm/kvm_pmu.h>
 
 /**
@@ -219,3 +220,114 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 
 	return nr_host_cnt_max;
 }
+
+/**
+ * kvm_pmu_load() - Load untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_load(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't using FGT then we are trapping everything
+	 * anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
+		return;
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
+		write_pmevcntrn(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCNTR_EL0);
+	write_pmccntr(val);
+
+	val = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	write_pmuserenr(val);
+
+	val = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+	write_pmselr(val);
+
+	/* Save only the stateful writable bits. */
+	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	mask = ARMV8_PMU_PMCR_MASK &
+		~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+	write_pmcr(val & mask);
+
+	/*
+	 * When handling these:
+	 * 1. Apply only the bits for guest counters (indicated by mask)
+	 * 2. Use the different registers for set and clear
+	 */
+	mask = kvm_pmu_guest_counter_mask(pmu);
+
+	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	write_pmcntenset(val & mask);
+	write_pmcntenclr(~val & mask);
+
+	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	write_pmintenset(val & mask);
+	write_pmintenclr(~val & mask);
+}
+
+/**
+ * kvm_pmu_put() - Put untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Put all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_put(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't using FGT then we are trapping everything
+	 * anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
+		return;
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = read_pmevcntrn(i);
+		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
+	}
+
+	val = read_pmccntr();
+	__vcpu_assign_sys_reg(vcpu, PMCCNTR_EL0, val);
+
+	val = read_pmuserenr();
+	__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0, val);
+
+	val = read_pmselr();
+	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
+
+	val = read_pmcr();
+	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
+
+	/* Mask these to only save the guest relevant bits. */
+	mask = kvm_pmu_guest_counter_mask(pmu);
+
+	val = read_pmcntenset();
+	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+
+	val = read_pmintenset();
+	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
+}
-- 
2.52.0.239.gd5f0c6e74e-goog

