Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114364;
	b=EWdiaTOqHFuMkCDaW4/EEuWp8omn1/uXWkxR8ZBO+YD2ApzuQdqD/Gk/K9a0r0cPqYV4
	 eacFySLspP2svyZocBs+q4L6M5RRdL+2y/OczeYqLxUL5VKvUC7CDkgrkdvgG/r+ddNAW
	 ZdL26Xx1TSgC1rXLg5b7jLAGPNPapH+EkvPNxvpqc5uyvTJmpvr8l8KuSVPlplMlZzDpN
	 uIE+zuNBghK3DKxWY2PSvrTNSutv/BbYBYsiGKFzOzakvx7xHpv7a8Vc1MGZ4hSNOfi+I
	 IJQDrWok8jnK6raTNBTASPExj3Wn86Sh2oRmRD49TPwhe1cVy9mQKx2eKck/1asQGXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kBLazxNLE8Go1XC9nR3wZ5LelNIUiohw0hHT+NLGaBs=;
	b=nSLa+z2dfrsKHb4nTVXlKD3etFyOgssM8DD5BsuSHZAhxxP8RSPZ8u5FzopgBmZM/9YY
	 sMk4ZWMrQkXpwC5XciLmF+oILAFUwwlrh+t5SlldVu/NO0NptUIn5JAqCASgojuB9g3zu
	 ngfl9wIy3LjhkGwZotgY9G7T/+jOCWgFBJcbATSG/4bfSBhXAts3f8BHn0kCNyTFucb29
	 oPFB5vVhoij5JoDlLDzlPwfQKr4IpdT+KCQmkV2bntjfed9210NLpNXPmbZzxhjc8QRrw
	 Lbk1XBbsWj9xDNqR6G0hAWzriR5qDq9OF7Hdf+5+gwXWMApU7zEx+mnqT3ZIXQKIQ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ahX0nQJF;
	arc=none smtp.remote-ip=209.85.160.70
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CC460713CD
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17CC460713CD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ahX0nQJF
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4adae323d5fso82968fac.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114363; x=1795719163; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kBLazxNLE8Go1XC9nR3wZ5LelNIUiohw0hHT+NLGaBs=;
        b=ahX0nQJFLkDjHffHomc/d3Xs4iTulhyRKqT2AtllaUl+lDoDSYij1aovEuIxpi9kMr
         cI6ZHFjvY071vWF2NQ/F3PEYmJQHGZuNTak2bB1pVWfqYwWYYzXxzbA1LAXIPt4jPauL
         Dns5OMGHs/cgwRtxYJZYgSsWyCqhmAYEjzmgWSM6X5hSsweN2pngSHCApWpjXSZZq8Tp
         TCEjwHZwAo3WWqNZS4/RGHwvlGv03se0x1YrjD+B8ZmfS7xXBTOs0KXKdrYEJaMcA65c
         TGZF4eT3rLbi4iiaEDbJe9iUG76zbLAHzxzWk6otBjj0U3l0rFsLDApfknRZfwYSDapm
         ToNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114363; x=1795719163;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kBLazxNLE8Go1XC9nR3wZ5LelNIUiohw0hHT+NLGaBs=;
        b=j5R0mgOkDabKd4kHVP7nBH8hqdGXnFYio2qFuvJIaidEMkd0xbiViOvYaW44GqY+7V
         zOL7qVHliTG+AYNAL7Q9fRptQkUMtTktQPfEoH3DXuYJR+EJx+3TmvTsWb2R5Ur1PVOG
         QaWp6exhQpyIpMqz8k9Fo7TpX5wKkvgj/lULDaWPeU8zxFbiO61uLe0ojRwoM8UWlWDY
         Hn8hzYCanu9g/cAUXnZHGOut4kxTH8BR/sKCTXJjATkRBesBOYIjzsbYEKlpRIJPfK/w
         +Uv9npnJhkWU6MPgQ4293KAlYAJMQTasNq1/BTzSd+hyqTzcHn77sLCsC3awxPp2KCyV
         IJow==
X-Forwarded-Encrypted: i=1; AL+hErHMGj40OtwCZW6Wl+0hD+6fxLz990wf8X//R1Zhxf4yD7SZ9YcTKkKTlY50SA1/885olM3oD1w=@lists.linux.dev
X-Gm-Message-State: APuU4Z8sElXDua4UvsDnHW3j2gwCJ/r1a+iobLpgWct0yeYG3GnAIQk2
	Gzf+457HVRji1RmP2SGUbqm+bUPWl7B82VyQVcg74uMmb7El6XtVH4iNy886kQbKTuh5xggqNRm
	e+uUjNfc8e5NpHe6Kok1TrKVVFg==
X-Received: from iogk9-n2.prod.google.com ([2002:a05:6602:c489:20b0:9cb:53d5:ffff])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:244d:b0:55b:f88d:6e8b with SMTP id 5614622812f47-57a0a10c8b9mr1106981b6e.13.1795114362378;
 Thu, 19 Nov 2026 10:52:42 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:09 +0000
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
Message-ID: <20261119185215.632334-28-coltonlewis@google.com>
Subject: [PATCH v10 27/33] KVM: arm64: Emulate mismatched LP and HLP overflow
 widths for sub-partitioned L1
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

When an L1 hypervisor sub-partitions its counters (vHPMN < N_L1) on
FEAT_PMUv3p5, all N_L1 guest counters lie below physical MDCR_EL2.HPMN
and share a single physical overflow width bit (PMCR_EL0.LP), whereas
architecturally counters 0..vHPMN-1 use vPMCR_EL0.LP and hypervisor
counters vHPMN..N_L1-1 use vMDCR_EL2.HLP.

When vPMCR_EL0.LP != vMDCR_EL2.HLP (and both sub-ranges are non-empty):
- Force physical PMCR_EL0.LP to 1 (64-bit hardware overflow) and bias
  each counter in the 32-bit sub-range (ovf32_mask) to
  0xffffffff00000000 | lower_32_bits(val) so hardware overflows after
  2^32 events, storing the upper-32-bit architectural offset in
  vcpu->arch.pmu.ovf32_offset[idx].
- Trap PMEVCNTR<n>_EL0 reads and writes via HDFG{R,W}TR_EL2.PMEVCNTRn_EL0
  while ovf32_mask is non-zero to translate between biased hardware
  values and architectural 64-bit values, and trigger KVM_REQ_RELOAD_PMU
  when guest PMCR_EL0.LP or MDCR_EL2.HLP changes.
- Defer re-biasing until non-interrupt context (counter reads,
  kvm_pmu_part_overflow_status(), or __kvm_pmu_put()) so NMI/IRQ
  overflow handlers remain lockless while phys_val + ovf32_offset[idx]
  stays exact modulo 2^64 across wraparound.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c     |   4 +
 arch/arm64/kvm/pmu-direct.c | 187 +++++++++++++++++++++++++++++-------
 arch/arm64/kvm/sys_regs.c   |   3 +-
 include/kvm/arm_pmu.h       |   8 ++
 4 files changed, 164 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 4089a144b8f2b..a523dde1b57a7 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1803,6 +1803,8 @@ static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
 
 		if (kvm_pmu_hyp_counter_mask(vcpu))
 			set |= HDFGRTR_EL2_PMCNTEN;
+		if (kvm_pmu_part_ovf32_mask(vcpu))
+			set |= HDFGRTR_EL2_PMEVCNTRn_EL0;
 
 		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= set & ~hdfgrtr_masks.res0;
 	}
@@ -1825,6 +1827,8 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 
 		if (kvm_pmu_hyp_counter_mask(vcpu))
 			set |= HDFGWTR_EL2_PMCNTEN;
+		if (kvm_pmu_part_ovf32_mask(vcpu))
+			set |= HDFGWTR_EL2_PMEVCNTRn_EL0;
 
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= set & ~hdfgwtr_masks.res0;
 	}
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 725b5fc17533e..b7bec06b36b0a 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -91,6 +91,41 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
 
+/**
+ * kvm_pmu_part_ovf32_mask() - Counters requiring 32-bit overflow emulation
+ * @vcpu: Pointer to vcpu struct
+ *
+ * When L1 sub-partitions its counters (vHPMN < N_L1) on FEAT_PMUv3p5 and
+ * configures mismatched overflow widths (vPMCR_EL0.LP != vMDCR_EL2.HLP),
+ * physical PMCR_EL0.LP is forced to 1 and the 32-bit sub-range is biased
+ * 2^32 events below 64-bit overflow.
+ *
+ * Return: Bitmask of general-purpose counters requiring 32-bit overflow bias
+ */
+u64 kvm_pmu_part_ovf32_mask(struct kvm_vcpu *vcpu)
+{
+	u64 hyp_mask = kvm_pmu_hyp_counter_mask(vcpu);
+	u64 pmcr, mdcr, ev_mask;
+	bool lp, hlp;
+
+	if (!hyp_mask ||
+	    !kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+		return 0;
+
+	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	lp = !!(pmcr & ARMV8_PMU_PMCR_LP);
+	hlp = !!(mdcr & MDCR_EL2_HLP);
+	if (lp == hlp)
+		return 0;
+
+	ev_mask = kvm_vcpu_pmu_guest_counter_mask(vcpu) &
+		  ~BIT_ULL(ARMV8_PMU_CYCLE_IDX);
+	if (!(ev_mask & ~hyp_mask))
+		return 0;
+
+	return lp ? hyp_mask : (ev_mask & ~hyp_mask);
+}
 static u64 kvm_pmu_part_active_cnten_mask(struct kvm_vcpu *vcpu)
 {
 	u64 guest_mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
@@ -110,6 +145,8 @@ static u64 kvm_pmu_part_active_cnten_mask(struct kvm_vcpu *vcpu)
 static void kvm_pmu_part_sync_hw_enables(struct kvm_vcpu *vcpu)
 {
 	u64 guest_mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	u64 ev_mask = guest_mask & ~BIT_ULL(ARMV8_PMU_CYCLE_IDX);
+	u64 hyp_mask = kvm_pmu_hyp_counter_mask(vcpu);
 	u64 cnten = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &
 		    kvm_pmu_part_active_cnten_mask(vcpu);
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
@@ -123,12 +160,109 @@ static void kvm_pmu_part_sync_hw_enables(struct kvm_vcpu *vcpu)
 	pmcr &= pmcr_mask;
 	if (mdcr & MDCR_EL2_HPME)
 		pmcr |= ARMV8_PMU_PMCR_E;
+	if (kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5)) {
+		if (ev_mask && !(ev_mask & ~hyp_mask)) {
+			if (mdcr & MDCR_EL2_HLP)
+				pmcr |= ARMV8_PMU_PMCR_LP;
+			else
+				pmcr &= ~ARMV8_PMU_PMCR_LP;
+		} else if (vcpu->arch.pmu.ovf32_mask) {
+			pmcr |= ARMV8_PMU_PMCR_LP;
+		}
+	}
 
 	write_sysreg(~cnten & guest_mask, pmcntenclr_el0);
 	write_sysreg(cnten & guest_mask, pmcntenset_el0);
 	write_sysreg(pmcr, pmcr_el0);
 }
 
+static void kvm_pmu_part_write_hw_cntr(struct kvm_vcpu *vcpu, u8 idx, u64 val)
+{
+	if (idx == ARMV8_PMU_CYCLE_IDX) {
+		write_pmccntr(val);
+		return;
+	}
+
+	if (vcpu->arch.pmu.ovf32_mask & BIT_ULL(idx)) {
+		vcpu->arch.pmu.ovf32_offset[idx] =
+			(val & GENMASK_ULL(63, 32)) + BIT_ULL(32);
+		val = GENMASK_ULL(63, 32) | lower_32_bits(val);
+	}
+
+	write_pmevcntrn(idx, val);
+}
+
+static void kvm_pmu_part_rebias_single(struct kvm_vcpu *vcpu, u8 idx)
+{
+	u64 phys_val, arch_val, cnten;
+
+	phys_val = read_pmevcntrn(idx);
+	if (upper_32_bits(phys_val) == U32_MAX)
+		return;
+
+	cnten = read_sysreg(pmcntenset_el0) & BIT_ULL(idx);
+	if (cnten) {
+		write_sysreg(cnten, pmcntenclr_el0);
+		isb();
+	}
+
+	if (read_sysreg(pmovsset_el0) & BIT_ULL(idx)) {
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, BIT_ULL(idx));
+		write_sysreg(BIT_ULL(idx), pmovsclr_el0);
+	}
+
+	phys_val = read_pmevcntrn(idx);
+	arch_val = phys_val + vcpu->arch.pmu.ovf32_offset[idx];
+	kvm_pmu_part_write_hw_cntr(vcpu, idx, arch_val);
+
+	if (cnten) {
+		isb();
+		write_sysreg(cnten, pmcntenset_el0);
+	}
+}
+
+static void kvm_pmu_part_rebias_ovf32(struct kvm_vcpu *vcpu)
+{
+	unsigned long mask = vcpu->arch.pmu.ovf32_mask;
+	u8 i;
+
+	for_each_set_bit(i, &mask, ARMV8_PMU_MAX_GENERAL_COUNTERS)
+		kvm_pmu_part_rebias_single(vcpu, i);
+}
+
+static void kvm_pmu_direct_cntr_write(struct kvm_vcpu *vcpu, u8 idx, u64 val)
+{
+	lockdep_assert_preemption_disabled();
+
+	__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + idx, val);
+	if (kvm_pmu_part_on_cpu(vcpu))
+		kvm_pmu_part_write_hw_cntr(vcpu, idx, val);
+}
+
+static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
+{
+	lockdep_assert_preemption_disabled();
+
+	if (!kvm_pmu_part_on_cpu(vcpu))
+		return __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + idx);
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		return read_pmccntr();
+
+	if (vcpu->arch.pmu.ovf32_mask & BIT_ULL(idx)) {
+		unsigned long flags;
+		u64 val;
+
+		local_irq_save(flags);
+		kvm_pmu_part_rebias_single(vcpu, idx);
+		val = read_pmevcntrn(idx) + vcpu->arch.pmu.ovf32_offset[idx];
+		local_irq_restore(flags);
+		return val;
+	}
+
+	return read_pmevcntrn(idx);
+}
+
 static void kvm_pmu_direct_cnten_write(struct kvm_vcpu *vcpu, u64 val, bool set)
 {
 	u64 mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
@@ -172,11 +306,12 @@ static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 	bool reset_p = val & ARMV8_PMU_PMCR_P;
 	bool reset_c = val & ARMV8_PMU_PMCR_C;
 	unsigned long mask;
-	u64 pmcr_mask;
+	u64 old, pmcr_mask;
 	int i;
 
 	lockdep_assert_preemption_disabled();
 
+	old = __vcpu_sys_reg(vcpu, PMCR_EL0);
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
@@ -195,6 +330,9 @@ static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 			__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, 0);
 	}
 
+	if (((old ^ val) & ARMV8_PMU_PMCR_LP) && kvm_pmu_hyp_counter_mask(vcpu))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	if (val & ARMV8_PMU_PMCR_E)
 		kvm_pmu_set_guest_owned(vcpu);
 
@@ -206,7 +344,7 @@ static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 
 	if (reset_p) {
 		for_each_set_bit(i, &mask, ARMV8_PMU_MAX_GENERAL_COUNTERS)
-			write_pmevcntrn(i, 0);
+			kvm_pmu_part_write_hw_cntr(vcpu, i, 0);
 	}
 
 	if (vcpu->arch.pmu.multiplex_enables)
@@ -304,33 +442,6 @@ static void kvm_pmu_set_guest_counters(struct arm_pmu *cpu_pmu, u64 guest_mask)
 	local_irq_restore(flags);
 }
 
-static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
-{
-	lockdep_assert_preemption_disabled();
-
-	if (!kvm_pmu_part_on_cpu(vcpu))
-		return __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + idx);
-
-	if (idx == ARMV8_PMU_CYCLE_IDX)
-		return read_pmccntr();
-
-	return read_pmevcntrn(idx);
-}
-
-static void kvm_pmu_direct_cntr_write(struct kvm_vcpu *vcpu, u8 idx, u64 val)
-{
-	lockdep_assert_preemption_disabled();
-
-	__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + idx, val);
-	if (!kvm_pmu_part_on_cpu(vcpu))
-		return;
-
-	if (idx == ARMV8_PMU_CYCLE_IDX)
-		write_pmccntr(val);
-	else
-		write_pmevcntrn(idx, val);
-}
-
 /**
  * kvm_pmu_direct_reg_read() - Read a guest PMU register for Partitioned PMU
  * @vcpu: Pointer to vcpu struct
@@ -617,6 +728,7 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 
 	vcpu->arch.pmu.loaded_on_cpu = true;
 	vcpu->arch.pmu.multiplex_enables = !!kvm_pmu_hyp_counter_mask(vcpu);
+	vcpu->arch.pmu.ovf32_mask = kvm_pmu_part_ovf32_mask(vcpu);
 	kvm_arm_setup_mdcr_el2(vcpu);
 	isb();
 
@@ -624,11 +736,7 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 
 	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-
-		if (i == ARMV8_PMU_CYCLE_IDX)
-			write_pmccntr(val);
-		else
-			write_pmevcntrn(i, val);
+		kvm_pmu_part_write_hw_cntr(vcpu, i, val);
 	}
 
 	if (!(vcpu->arch.mdcr_el2 & MDCR_EL2_TPM)) {
@@ -754,6 +862,8 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 			write_pmccntr(0);
 		} else {
 			val = read_pmevcntrn(i);
+			if (vcpu->arch.pmu.ovf32_mask & BIT_ULL(i))
+				val += vcpu->arch.pmu.ovf32_offset[i];
 			write_pmevcntrn(i, 0);
 		}
 
@@ -793,6 +903,7 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 
 	vcpu->arch.pmu.loaded_on_cpu = false;
 	vcpu->arch.pmu.multiplex_enables = false;
+	vcpu->arch.pmu.ovf32_mask = 0;
 	kvm_arm_setup_mdcr_el2(vcpu);
 	isb();
 
@@ -824,9 +935,9 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
  * kvm_pmu_reload_part() - Reload partitioned PMU traps, filters, and state
  * @vcpu: Pointer to struct kvm_vcpu
  *
- * Refresh fine-grained traps, MDCR_EL2 trap bits, event filters, and
- * enable multiplexing without releasing the host counter reservation
- * when the partitioned PMU is already loaded on the CPU.
+ * Refresh fine-grained traps, MDCR_EL2 trap bits, event filters, enable
+ * multiplexing, and 32-bit overflow bias without releasing the host counter
+ * reservation when the partitioned PMU is already loaded on the CPU.
  */
 void kvm_pmu_reload_part(struct kvm_vcpu *vcpu)
 {
@@ -946,6 +1057,8 @@ bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
 			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, hw_ovf);
 			write_sysreg(hw_ovf, pmovsclr_el0);
 		}
+		if (!in_interrupt() && vcpu->arch.pmu.ovf32_mask)
+			kvm_pmu_part_rebias_ovf32(vcpu);
 		pmint = read_pmintenset();
 		if (vcpu->arch.pmu.multiplex_enables)
 			pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6706f57aef8d5..24dd878fb58c4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3185,7 +3185,8 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	 * affected by MDCR_EL2.
 	 */
 	if ((old ^ val) & (MDCR_EL2_HPME | MDCR_EL2_HPMN | MDCR_EL2_HPMD |
-			   MDCR_EL2_HCCD | MDCR_EL2_TPM | MDCR_EL2_TPMCR))
+			   MDCR_EL2_HCCD | MDCR_EL2_HLP | MDCR_EL2_TPM |
+			   MDCR_EL2_TPMCR))
 		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 
 	return true;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 9e5fcbe2ccbb1..13e9230c9c714 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -42,6 +42,8 @@ struct kvm_pmu {
 	struct irq_work overflow_work;
 	struct kvm_pmu_events events;
 	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
+	u64 ovf32_offset[ARMV8_PMU_MAX_GENERAL_COUNTERS];
+	u64 ovf32_mask;
 	int irq_num;
 	bool created;
 	bool loaded_on_cpu;
@@ -107,6 +109,7 @@ bool kvm_pmu_is_partitioned(struct kvm *kvm);
 u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu, unsigned int reg);
 void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 			      u64 val, bool set);
+u64 kvm_pmu_part_ovf32_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_reload_part(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_guest_counter_mask(void);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
@@ -171,6 +174,11 @@ static inline u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu,
 static inline void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu,
 					    unsigned int reg, u64 val,
 					    bool set) {}
+
+static inline u64 kvm_pmu_part_ovf32_mask(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_reload_part(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
-- 
2.56.1.708.g77570a6a1d-goog

