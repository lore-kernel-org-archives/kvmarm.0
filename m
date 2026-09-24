Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0182341A766
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270994; cv=none; b=EAORh/d8hCLi/Scxdv4ORB5iT4R0mCmcY9dW4MbTbh1Kg+u3tl36LfC9yqOTcjXDwpEVe+2J6JpDJ59yXIr6mj9mEfXF+jllP9EZGuM/kE32ZDC4HdrjWS2juliikFJpQXgccDrreM/BefoStk2ZIVnBIYY7+ZT1BtJJh6s5suI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270994; c=relaxed/simple;
	bh=TnKyEpcgBA6CB8nQw6+EyO5hcJkdWh4SiArNmuixhFY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hoAulWnU7f1PlVCvWwcV26UNXCycyMMPlUAZk2ct5SgYNEMsTbr083DmsvGKu+06hzJHJLhUst/gm6Y7m9mhUcazVaPDvO9Tvdd1KHho7NojezacsbbNUxvsRB+4gol3dXa+zWGequ3h/D8GGyitSvILhgE9kDlwOr1xxAT10ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUC8XUJQ; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUC8XUJQ"
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e99ff505c2so35839a34.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270988; x=1790875788; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sx4i7rLrLjUKxNonKTZBsgb0Jj/BfKfmEgD+eiXTprc=;
        b=OUC8XUJQqYKnMKVZQHn7YvmyNty54UJ9Ms+7Xv6g+PpbWFt7s3ncsVrTPyzHB4YgDA
         hoobgDzOOk/r5OOVHK6Hc9dv2q8DsDSnk1ra57IZUUtgfDJf+Rzc39phffbpO2koQ0/h
         BNvBxYnbI0GggT7R1L79wGTAp6K+zHLQNfzq+QuKXojfcFfCLI5hoe6Zlyo8xVcAmjUA
         NiGSJ53cPqZL/cyjIVLk7wh3ireoI/J6TtASvIHzY9Lk9NbH/XA26SGXrpRV7CLLbsem
         QYCDuMkHvq2Wzttrj5urQxB6XCf1FHqltRZkD9UojH61zJwZ9XctTrkvYfV8QAr5jl6D
         M9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270988; x=1790875788;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sx4i7rLrLjUKxNonKTZBsgb0Jj/BfKfmEgD+eiXTprc=;
        b=0bIhaFXRsI6HNMAjiWfO6fMESz6kvHL+1HNAEiR6B3SWa4u7y8HWziHNLz2klCF+0f
         Xo43To2yRMDcnIlSqBzeEslIWkqs/1vI0Az7WR3rgNkI2JZo3ilvK2rMsIaxEeN9uqhA
         tl9Uv8kCu5SqCcysGTLaOZegMKgftpTQWRJPD5qnulioPKMUoXV/jJJ3seHqRaNham6f
         mJe3jNIx7BXAJge17K+pxG8Ji/5FStVMUEj+XEH10LdQYwN2jlHFwnYa8+Bac5mB1Pal
         UhGiSR/YhwL7J5x5/9yqieSikbtkZYu2DVjvamqqEp+Wl7Syv66R0pcZU9f/JmndN/4c
         t5ew==
X-Forwarded-Encrypted: i=1; AKwUvBxDkmYDzOLNXKkTEa9eLWIvuNTD9/xycBAcy4vtc5fJgNxhjgVgUibpaK3WZ/tlqAvr7tGBmU8=@lists.linux.dev
X-Gm-Message-State: AFuF++miT3ZDHubhA9fmB4/3hdc1Xzc+husDyj9qso0RE8PS6fOJPB12
	5P5gggl/rfJxetzINkhyqc07tfN+sgtCbDj4TLlCP3trnV8noH6FzdSZ5R+5lw96NxvoAjxVbRM
	Gfb83pQ4qpAZh3qw2T9kqUNYzUw==
X-Received: from ilpx16.prod.google.com ([2002:a92:d650:0:b0:509:637c:4c67])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4fe0:b0:4d6:9133:23fc with SMTP id 5614622812f47-4d72b44c8aemr3907567b6e.50.1790270988101;
 Thu, 24 Sep 2026 10:29:48 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:18 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-13-coltonlewis@google.com>
Subject: [PATCH v9 12/22] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Save and restore newly untrapped registers that can be directly
accessed by the guest when the PMU is partitioned.

- PMEVCNTRn_EL0
- PMCCNTR_EL0
- PMSELR_EL0
- PMCR_EL0
- PMCNTEN_EL0
- PMINTEN_EL1

If we know we are not partitioned (that is, using the emulated vPMU),
then return immediately. A later patch will make this lazy so the
context swaps don't happen unless the guest has accessed the PMU.

PMEVTYPER is handled in a following patch since we must apply the KVM
event filter before writing values to hardware.

PMOVS guest counters are cleared to avoid the possibility of
generating spurious interrupts when PMINTEN is written. This is fine
because the virtual register for PMOVS is always the canonical value.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/arm.c        |   4 +-
 arch/arm64/kvm/pmu-direct.c | 153 +++++++++++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c   |   6 +-
 include/kvm/arm_pmu.h       |   5 ++
 4 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90b..75e0f746623ec 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -714,6 +714,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_pmu_load(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
@@ -755,13 +756,14 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
+	kvm_pmu_put(vcpu);
+	kvm_vcpu_pmu_restore_host(vcpu);
 	kvm_vcpu_put_debug(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_vhe(vcpu);
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
-	kvm_vcpu_pmu_restore_host(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 5045051e91cd3..92eec0fa33867 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -155,7 +155,6 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
 
 	return 0;
 }
-
 /**
  * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
  *
@@ -169,3 +168,155 @@ u64 kvm_pmu_guest_counter_mask(void)
 {
 	return kvm_vcpu_pmu_guest_counter_mask(kvm_get_running_vcpu());
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
+	unsigned long guest_counters;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't guest-owned then we know the guest isn't using
+	 * the PMU anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+		return;
+
+	preempt_disable();
+
+	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
+
+		if (i == ARMV8_PMU_CYCLE_IDX)
+			write_pmccntr(val);
+		else
+			write_pmevcntrn(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+	write_sysreg(val, pmselr_el0);
+
+	if (!(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM)) {
+		val = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+		write_sysreg(val, pmuserenr_el0);
+	}
+
+	/* Save only the stateful writable bits. */
+	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	mask = ARMV8_PMU_PMCR_MASK &
+		~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+	write_sysreg(val & mask, pmcr_el0);
+
+	/*
+	 * When handling these:
+	 * 1. Apply only the bits for guest counters (indicated by mask)
+	 * 2. Use the different registers for set and clear
+	 */
+	mask = guest_counters;
+
+	/* Clear the hardware overflow flags so there is no chance of
+	 * creating spurious interrupts. The hardware here is never
+	 * the canonical version anyway.
+	 */
+	write_sysreg(mask, pmovsclr_el0);
+
+	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	write_sysreg(val & mask, pmcntenset_el0);
+	write_sysreg(~val & mask, pmcntenclr_el0);
+
+	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	write_sysreg(val & mask, pmintenset_el1);
+	write_sysreg(~val & mask, pmintenclr_el1);
+
+	preempt_enable();
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
+	unsigned long guest_counters;
+	unsigned long flags;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't guest-owned then we know the guest is not
+	 * accessing the PMU anyway, so no need to bother with the
+	 * swap.
+	 */
+	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+		return;
+
+	preempt_disable();
+
+	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	mask = guest_counters;
+
+	/* Mask these to only save the guest relevant bits. */
+	val = read_sysreg(pmcntenset_el0);
+	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+
+	val = read_sysreg(pmintenset_el1);
+	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
+
+	/* Stop guest counters and disable interrupts in hardware first. */
+	write_sysreg(mask, pmcntenclr_el0);
+	write_sysreg(mask, pmintenclr_el1);
+	isb();
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		if (i == ARMV8_PMU_CYCLE_IDX)
+			val = read_pmccntr();
+		else
+			val = read_pmevcntrn(i);
+
+		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
+	}
+
+	val = read_sysreg(pmselr_el0);
+	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
+
+	if (!(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM)) {
+		val = read_sysreg(pmuserenr_el0);
+		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0, val);
+	}
+
+	val = read_sysreg(pmcr_el0);
+	__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, &=, ~ARMV8_PMU_PMCR_MASK);
+	__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, |=, val & ARMV8_PMU_PMCR_MASK);
+
+	val = ARMV8_PMU_PMCR_LC;
+	if (pmu && pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
+		val |= ARMV8_PMU_PMCR_LP;
+	if (vcpu->arch.mdcr_el2 & MDCR_EL2_HPME)
+		val |= ARMV8_PMU_PMCR_E;
+	write_sysreg(val, pmcr_el0);
+
+	/* Save pending guest hardware overflows. */
+	local_irq_save(flags);
+	val = read_sysreg(pmovsset_el0);
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
+	write_sysreg(val & mask, pmovsclr_el0);
+	local_irq_restore(flags);
+
+	preempt_enable();
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8210a8b10389..ebcf52261df65 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1189,7 +1189,8 @@ static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val,
 		local_irq_restore(flags);
 		break;
 	case PMUSERENR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_is_partitioned(vcpu->kvm) &&
+		    !(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
 			write_sysreg(val, pmuserenr_el0);
 		__vcpu_assign_sys_reg(vcpu, reg, val);
 		break;
@@ -1274,7 +1275,8 @@ static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 		local_irq_restore(flags);
 		break;
 	case PMUSERENR_EL0:
-		if (kvm_pmu_is_partitioned(vcpu->kvm))
+		if (kvm_pmu_is_partitioned(vcpu->kvm) &&
+		    !(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
 			val = read_sysreg(pmuserenr_el0);
 		else
 			val = __vcpu_sys_reg(vcpu, reg);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index a24788243ac99..2604a6a46d5f3 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -102,6 +102,9 @@ void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val);
 u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_host_counter_mask(void);
 u64 kvm_pmu_guest_counter_mask(void);
+void kvm_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_pmu_put(struct kvm_vcpu *vcpu);
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -150,6 +153,8 @@ static inline u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
-- 
2.56.0.rc1.310.g51773c2048-goog

