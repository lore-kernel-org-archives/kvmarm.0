Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114360;
	b=TEuKs9ocWFJd66VnZ+1xpSvF2P7+tjD+rYgUYnCV6mvEwpduRa73V4SQnzgfyNv0B8Pd
	 O9/QF6Gasesg4aF3kpK4wssZz7RSb30SucVurerTkns+y9W7Y84C3bcnhJ+4kFkZz2mWd
	 /pbfds+uFlZ7LyCWGKJeklSSQKvEvfVa/V7HVxUV0zZWDKBP47PNeRok7AlIWSlZ3Bxuu
	 pocMdtqX1foPIA4HCzBEnRJdEpUMIP3lqvm90VLwOoXG5FdTIvihQn/sNHcADzqHfUuii
	 yAnUM6zf64pE7RypJCD4a0SYMZiLM9XdLiYrRtIC61lbggxU15N0jXJj3jK/jT8AKsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=50V8By3qaoM+m1P7Cs38mlFoYamAGiTjPOma1ckrspI=;
	b=eOvIgi0n5TYj2y/Za1FvuIVIg87SzgzTTarRAedV7NJMf3JIqhIxmBPil2KKYzmp7Nhq
	 HW4wzI2BmbIKRCmpzxT6z6EsQe+gVH9CkqvzPHaJT6pZD19+g3l98iDh5aVGc5ZZzONl0
	 YfNizhW6YWs6UhLxNkU0YmcH5SRn/9MGUFrG5qZ/J/jHeJsllkczYPruvkZe4RqtDCajL
	 LjFsGrxlLvJff3zBJaTmXmo30vDjq9AUj7BESLrO++tWqrRL9W5hujd2WfFiJdTEDqxLs
	 eXuzphi459vDsUjuieJ+2iwplbo6LHcUDV3iHUArtcEi+UQk7wNIsUXVAY0rHRdK4OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nOsizlKr;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF060A3822
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CABF060A3822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nOsizlKr
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4dab94dc3e7so199114b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114359; x=1795719159; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=50V8By3qaoM+m1P7Cs38mlFoYamAGiTjPOma1ckrspI=;
        b=nOsizlKr9izF0lSfIjEDkT5sjGI3REGepWj1iMXEbLwnGRNR4GiAR6ojAuuRKZN0vJ
         VrQBH3zlSI+uomtxGkxDw/+mHoV3OxM9svWREu/WPN0xVvnHJvPKEv8ffE51UDxmygW9
         bCur/JmoSiooHzY6IugDBe2YAT5aXV35BCp5dRwGyV5GStvjNyAdB9O53PLtC6hrGJkH
         IxDeAb/B9PaohIQbTuLkFeL3as/kiUnBiVDhMDA9uR6LUe5ZM0D4p5uXlcPTQiNKwOus
         dpP0QiOrmieSl80t17bCcO1nFrbVjLbtTFLqYEoUJOgrxE8B/bu4Dvfaus9gc80hNqH/
         us2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114359; x=1795719159;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=50V8By3qaoM+m1P7Cs38mlFoYamAGiTjPOma1ckrspI=;
        b=1I6JZ2SVZg23m0ZXMieTfaU3xtRTCnms4C05zlFA+LggB0vxu8/OR/dPFhO7kbZqOc
         LdLelvH7QPiPvdLWP7LUaXO8Hlpa2sclwbwklulb0shYkYoFHz4SUbXOZehmfIxOdEPz
         xDcj62thVVkSNwPlLCPmgJ0VgLgpIpgC5LQfvHKRmSq/vCvhcHdEDocbR5lXHcOCLq8c
         YSxfwTYOP786kdhk7rsuPrVe10Gsjo0BD3KcYvD86Y38z/GYILYrbWKS+/z5c/AoGKEJ
         MC9fj5E46ApRQ89JHwCWRla4gofGfRn6CPHLCUtQ65+38a5+1haUm7RqLmK4OWBgLkkg
         dbpw==
X-Forwarded-Encrypted: i=1; AL+hErGZbQ4I3ZyegGWHGJ/1KJun5FBB6/NzsuyQLsSeyp31WqLw6SjRf/dYM4Rq1KipLceOQak51hY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+2yd18kM0K6MsVHTtHKjVw4YNgSctrRMSuuT2sD3chF90iHp4m
	ZWAQHrvivhwjjzK7cTC9Brz9lFpC8w8vxwTCvBbynmZSarsUqc4bSlHBX5mfcYLK8G/XUzlanGI
	tTcwhypDGvoYGCqratT0ayrWQnQ==
X-Received: from ioi29-n1.prod.google.com ([2002:a05:6602:c65d:10b0:9e3:5e00:891c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:10cc:b0:4f8:4a95:9969 with SMTP id 5614622812f47-57a0a20ba84mr1036361b6e.15.1795114358443;
 Thu, 19 Nov 2026 10:52:38 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:05 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-24-coltonlewis@google.com>
Subject: [PATCH v10 23/33] KVM: arm64: Implement lazy PMU context swaps
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Since many guests never use the PMU, avoid reserving hardware counters
and context swapping PMU registers on every vCPU load and put until the
guest actively enables counting or overflow interrupts.

Track per-vCPU PMU ownership via enum vcpu_pmu_register_access
(VCPU_PMU_ACCESS_FREE vs. VCPU_PMU_ACCESS_GUEST_OWNED):
- While FREE, keep MDCR_EL2.HPMN at the full host counter count with TPM
  and TPMCR set so host perf retains all counters including PMCCNTR_EL0.
  Trapped reads and non-enabling writes (such as guest boot PMU probes)
  operate on shadow sys_regs[] without claiming hardware counters.
- When the guest enables counting or interrupts (setting PMCR_EL0.E,
  enabling MDCR_EL2.HPME with hypervisor counters, or setting guest bits
  in PMCNTENSET_EL0 or PMINTENSET_EL1), transition to GUEST_OWNED via
  kvm_pmu_set_guest_owned(), reserve the guest counter partition, and
  load guest state into hardware.

Add kvm_pmu_reload_part() to service KVM_REQ_RELOAD_PMU for partitioned
VMs (triggered by MDCR_EL2 or PMUSERENR_EL0 trap changes, vCPU reset,
and KVM_SET_ONE_REG writes). Unlike the emulated PMU, which only masks
shadow registers and reprograms perf_events, a partitioned PMU loaded on
the CPU must flush live hardware registers to sys_regs[], mask
unimplemented counter bits, recompute FGT, MDCR_EL2, and hardware event
filters, and reload hardware without dropping its host counter
reservation. When not yet loaded (such as after vCPU reset or
KVM_SET_ONE_REG), kvm_pmu_reload_part() transitions to GUEST_OWNED only
if PMCR_EL0.E or MDCR_EL2.HPME is enabled, avoiding false activation
from reset_unknown() poison bits in PMCNTENSET_EL0 or PMINTENSET_EL1.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h  |   1 +
 arch/arm64/include/asm/kvm_types.h |   6 +-
 arch/arm64/kvm/debug.c             |   4 +-
 arch/arm64/kvm/pmu-direct.c        | 139 ++++++++++++++++++++++++++---
 arch/arm64/kvm/pmu-emul.c          |   3 +
 arch/arm64/kvm/pmu.c               |   5 ++
 arch/arm64/kvm/sys_regs.c          |  14 ++-
 include/kvm/arm_pmu.h              |  14 +++
 8 files changed, 166 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 103c25001c0d2..1fcb12995c34c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1501,6 +1501,7 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
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
index a1cb4c076bdb4..ec9f942b452d8 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -36,7 +36,7 @@ static int cpu_has_spe(u64 dfr0)
  *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *  - Self-hosted Trace (MDCR_EL2_TTRF/MDCR_EL2_E2TB)
  */
-static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	unsigned long daif;
 	u64 mdcr;
@@ -55,7 +55,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 		 MDCR_EL2_TDRA |
 		 MDCR_EL2_TDOSA);
 
-	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+	if (kvm_pmu_is_partitioned(vcpu->kvm) && vcpu->arch.pmu.loaded_on_cpu) {
 		u8 nr_host_cntr = *host_data_ptr(nr_event_counters);
 		u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index cc4ff00d6f41e..c2ea1ce5efe74 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -11,6 +11,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/daifflags.h>
 #include <asm/kvm_emulate.h>
 #include <asm/virt.h>
 
@@ -68,13 +69,9 @@ bool kvm_pmu_is_partitioned(struct kvm *kvm)
 
 static bool kvm_pmu_part_on_cpu(struct kvm_vcpu *vcpu)
 {
-	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
-
 	lockdep_assert_preemption_disabled();
 
-	return kvm_pmu_is_partitioned(vcpu->kvm) &&
-	       vcpu == kvm_get_running_vcpu() && pmu &&
-	       cpumask_test_cpu(smp_processor_id(), &pmu->supported_cpus);
+	return vcpu == kvm_get_running_vcpu() && vcpu->arch.pmu.loaded_on_cpu;
 }
 
 static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
@@ -92,6 +89,8 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
+
 static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 {
 	bool reset_p = val & ARMV8_PMU_PMCR_P;
@@ -120,6 +119,9 @@ static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 			__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, 0);
 	}
 
+	if (val & ARMV8_PMU_PMCR_E)
+		kvm_pmu_set_guest_owned(vcpu);
+
 	if (!kvm_pmu_part_on_cpu(vcpu))
 		return;
 
@@ -230,7 +232,6 @@ static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
 
 	return read_pmevcntrn(idx);
 }
-
 static void kvm_pmu_direct_cntr_write(struct kvm_vcpu *vcpu, u8 idx, u64 val)
 {
 	lockdep_assert_preemption_disabled();
@@ -412,6 +413,8 @@ void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 		val &= kvm_vcpu_pmu_guest_counter_mask(vcpu);
 		if (set) {
 			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
+			if (val)
+				kvm_pmu_set_guest_owned(vcpu);
 			if (kvm_pmu_part_on_cpu(vcpu))
 				write_sysreg(val, pmcntenset_el0);
 		} else {
@@ -424,6 +427,8 @@ void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 		val &= kvm_vcpu_pmu_guest_counter_mask(vcpu);
 		if (set) {
 			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
+			if (val)
+				kvm_pmu_set_guest_owned(vcpu);
 			if (kvm_pmu_part_on_cpu(vcpu))
 				write_sysreg(val, pmintenset_el1);
 		} else {
@@ -444,13 +449,18 @@ void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 		}
 		local_irq_restore(flags);
 		break;
-	case PMUSERENR_EL0:
+	case PMUSERENR_EL0: {
+		u64 old = __vcpu_sys_reg(vcpu, reg);
+
 		val &= ARMV8_PMU_USERENR_MASK;
 		if (kvm_pmu_part_on_cpu(vcpu) &&
 		    !(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
 			write_sysreg(val, pmuserenr_el0);
 		__vcpu_assign_sys_reg(vcpu, reg, val);
+		if (vcpu_has_nv(vcpu) && ((old ^ val) & ARMV8_PMU_USERENR_MASK))
+			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 		break;
+	}
 	default:
 		WARN_ON(1);
 		break;
@@ -468,7 +478,12 @@ void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
  */
 u64 kvm_pmu_guest_counter_mask(void)
 {
-	return kvm_vcpu_pmu_guest_counter_mask(kvm_get_running_vcpu());
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (vcpu && vcpu->arch.pmu.loaded_on_cpu)
+		return kvm_vcpu_pmu_guest_counter_mask(vcpu);
+
+	return 0;
 }
 
 static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
@@ -491,6 +506,7 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long guest_counters;
 	unsigned long flags;
+	unsigned long daif;
 	u64 mask;
 	u8 i;
 	u64 val;
@@ -499,7 +515,9 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	 * If we aren't guest-owned then we know the guest isn't using
 	 * the PMU anyway, so no need to bother with the swap.
 	 */
-	if (!kvm_pmu_is_partitioned(vcpu->kvm) || !vcpu->wants_to_run || !pmu)
+	if (!kvm_pmu_is_partitioned(vcpu->kvm) ||
+	    kvm_pmu_get_access(vcpu) != VCPU_PMU_ACCESS_GUEST_OWNED ||
+	    vcpu->arch.pmu.loaded_on_cpu || !vcpu->wants_to_run || !pmu)
 		return;
 
 	preempt_disable();
@@ -514,6 +532,22 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	if (reserve_counters)
 		kvm_pmu_set_guest_counters(pmu, guest_counters);
 
+	daif = local_daif_save();
+
+	/*
+	 * Ensure guest counters, interrupts, and overflow flags are quiesced
+	 * in hardware before lowering MDCR_EL2.HPMN and marking the partition
+	 * live on this CPU.
+	 */
+	write_sysreg(guest_counters, pmcntenclr_el0);
+	write_sysreg(guest_counters, pmintenclr_el1);
+	write_sysreg(guest_counters, pmovsclr_el0);
+	isb();
+
+	vcpu->arch.pmu.loaded_on_cpu = true;
+	kvm_arm_setup_mdcr_el2(vcpu);
+	isb();
+
 	kvm_pmu_apply_event_filter(vcpu);
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
@@ -565,6 +599,7 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	write_sysreg(val & mask, pmintenset_el1);
 	write_sysreg(~val & mask, pmintenclr_el1);
 
+	local_daif_restore(daif);
 	local_irq_restore(flags);
 	preempt_enable();
 }
@@ -582,6 +617,9 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	bool reserve = !vcpu_get_flag(vcpu, IN_NESTED_ERET) &&
 		       !vcpu_get_flag(vcpu, IN_NESTED_EXCEPTION);
 
+	if (reserve && kvm_test_request(KVM_REQ_RELOAD_PMU, vcpu))
+		return;
+
 	__kvm_pmu_load(vcpu, reserve);
 }
 
@@ -590,29 +628,34 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
 	unsigned long guest_counters;
 	unsigned long flags;
+	unsigned long daif;
 	u64 pmcr_mask;
 	u64 mask;
 	u8 i;
 	u64 val;
 
 	/*
-	 * If we aren't guest-owned then we know the guest is not
+	 * If we aren't loaded on the CPU then we know the guest is not
 	 * accessing the PMU anyway, so no need to bother with the
 	 * swap.
 	 */
-	if (!kvm_pmu_is_partitioned(vcpu->kvm) || !vcpu->wants_to_run || !pmu)
+	if (!kvm_pmu_is_partitioned(vcpu->kvm) ||
+	    !vcpu->arch.pmu.loaded_on_cpu || !pmu)
 		return;
 
 	preempt_disable();
+	local_irq_save(flags);
 	if (!cpumask_test_cpu(smp_processor_id(), &pmu->supported_cpus)) {
+		local_irq_restore(flags);
 		preempt_enable();
 		return;
 	}
 
-	local_irq_save(flags);
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
 	mask = guest_counters;
 
+	daif = local_daif_save();
+
 	/* Mask these to only save the guest relevant bits. */
 	val = read_sysreg(pmcntenset_el0);
 	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
@@ -657,7 +700,7 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 	val = ARMV8_PMU_PMCR_LC;
 	if (pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
 		val |= ARMV8_PMU_PMCR_LP;
-	if (vcpu->arch.mdcr_el2 & MDCR_EL2_HPME)
+	if (READ_ONCE(vcpu->arch.mdcr_el2) & MDCR_EL2_HPME)
 		val |= ARMV8_PMU_PMCR_E;
 	write_sysreg(val, pmcr_el0);
 
@@ -666,6 +709,12 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
 	write_sysreg(val & mask, pmovsclr_el0);
 
+	vcpu->arch.pmu.loaded_on_cpu = false;
+	kvm_arm_setup_mdcr_el2(vcpu);
+	isb();
+
+	local_daif_restore(daif);
+
 	if (release_counters)
 		kvm_pmu_set_guest_counters(pmu, 0);
 	local_irq_restore(flags);
@@ -687,3 +736,67 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 
 	__kvm_pmu_put(vcpu, release);
 }
+
+/**
+ * kvm_pmu_reload_part() - Reload partitioned PMU traps, filters, and state
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Refresh MDCR_EL2 trap bits, event filters, and hardware register state
+ * without releasing the host counter reservation when the partitioned PMU is
+ * already loaded on the CPU.
+ */
+void kvm_pmu_reload_part(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	bool was_loaded;
+
+	guard(preempt)();
+
+	was_loaded = vcpu->arch.pmu.loaded_on_cpu;
+	if (was_loaded)
+		__kvm_pmu_put(vcpu, false);
+
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+		__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, &=, ~ARMV8_PMU_PMCR_LP);
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, mask);
+
+	kvm_vcpu_load_fgt(vcpu);
+	if (vcpu == kvm_get_running_vcpu() && has_vhe() &&
+	    cpus_have_final_cap(ARM64_HAS_FGT)) {
+		write_sysreg_s(*vcpu_fgt(vcpu, HDFGRTR_EL2), SYS_HDFGRTR_EL2);
+		write_sysreg_s(*vcpu_fgt(vcpu, HDFGWTR_EL2), SYS_HDFGWTR_EL2);
+		isb();
+	}
+
+	if (was_loaded) {
+		__kvm_pmu_load(vcpu, false);
+	} else {
+		bool hpme_active = (__vcpu_sys_reg(vcpu, MDCR_EL2) &
+				    MDCR_EL2_HPME) &&
+				   kvm_pmu_hyp_counter_mask(vcpu);
+
+		if ((__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) ||
+		    hpme_active)
+			kvm_pmu_set_guest_owned(vcpu);
+		else if (kvm_pmu_get_access(vcpu) == VCPU_PMU_ACCESS_GUEST_OWNED)
+			__kvm_pmu_load(vcpu, true);
+
+		if (!vcpu->arch.pmu.loaded_on_cpu &&
+		    vcpu == kvm_get_running_vcpu())
+			kvm_arm_setup_mdcr_el2(vcpu);
+	}
+}
+
+static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (kvm_pmu_is_partitioned(vcpu->kvm) &&
+	    vcpu == kvm_get_running_vcpu()) {
+		vcpu->arch.pmu.access = VCPU_PMU_ACCESS_GUEST_OWNED;
+		__kvm_pmu_load(vcpu, true);
+	}
+}
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9eff208547746..da66162c68042 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -625,6 +625,9 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 	unsigned long mask;
 	int i;
 
+	if (kvm_pmu_is_partitioned(vcpu->kvm))
+		return;
+
 	mask = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for_each_set_bit(i, &mask, 32) {
 		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index d3fd438a57b09..7389d61957fa9 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -925,6 +925,11 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
+	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		kvm_pmu_reload_part(vcpu);
+		return;
+	}
+
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
 	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
 	__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, mask);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index db6f3adcaae7c..6706f57aef8d5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3181,10 +3181,11 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
 
 	/*
-	 * Request a reload of the PMU to enable/disable the counters
-	 * affected by HPME.
+	 * Request a reload of the PMU to update the counters and filters
+	 * affected by MDCR_EL2.
 	 */
-	if ((old ^ val) & MDCR_EL2_HPME)
+	if ((old ^ val) & (MDCR_EL2_HPME | MDCR_EL2_HPMN | MDCR_EL2_HPMD |
+			   MDCR_EL2_HCCD | MDCR_EL2_TPM | MDCR_EL2_TPMCR))
 		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	return true;
@@ -5455,8 +5456,10 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
 
-	if (kvm_vcpu_has_pmu(vcpu))
+	if (kvm_vcpu_has_pmu(vcpu)) {
+		kvm_pmu_reset_access(vcpu);
 		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+	}
 }
 
 /**
@@ -5690,6 +5693,9 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		ret = 0;
 	}
 
+	if (!ret && kvm_vcpu_has_pmu(vcpu) && kvm_pmu_is_partitioned(vcpu->kvm))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return ret;
 }
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 4580f62234128..e3f5b9a1a4817 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -7,6 +7,7 @@
 #ifndef __ASM_ARM_KVM_PMU_H
 #define __ASM_ARM_KVM_PMU_H
 
+#include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 #include <linux/perf/arm_pmu.h>
@@ -43,6 +44,8 @@ struct kvm_pmu {
 	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
 	int irq_num;
 	bool created;
+	bool loaded_on_cpu;
+	enum vcpu_pmu_register_access access;
 };
 
 struct arm_pmu_entry {
@@ -101,10 +104,14 @@ bool kvm_pmu_is_partitioned(struct kvm *kvm);
 u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu, unsigned int reg);
 void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 			      u64 val, bool set);
+void kvm_pmu_reload_part(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_guest_counter_mask(void);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
+#define kvm_pmu_get_access(vcpu)	((vcpu)->arch.pmu.access)
+#define kvm_pmu_reset_access(vcpu)	((vcpu)->arch.pmu.access = VCPU_PMU_ACCESS_FREE)
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -126,6 +133,7 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
+	bool loaded_on_cpu;
 };
 
 static inline bool kvm_supports_guest_pmuv3(void)
@@ -144,6 +152,11 @@ static inline bool kvm_pmu_is_partitioned(struct kvm *kvm)
 	return false;
 }
 
+static inline enum vcpu_pmu_register_access kvm_pmu_get_access(struct kvm_vcpu *vcpu)
+{
+	return VCPU_PMU_ACCESS_FREE;
+}
+static inline void kvm_pmu_reset_access(struct kvm_vcpu *vcpu) {}
 static inline u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu,
 					  unsigned int reg)
 {
@@ -152,6 +165,7 @@ static inline u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu,
 static inline void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu,
 					    unsigned int reg, u64 val,
 					    bool set) {}
+static inline void kvm_pmu_reload_part(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
-- 
2.56.1.708.g77570a6a1d-goog

