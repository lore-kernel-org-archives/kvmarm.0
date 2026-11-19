Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114366;
	b=JfU1QxgTmL4Z4qMEXQiaC10sm05nbi22QpPc49rpTnF/E1eoSMQ2RjeF0wWrVI2XKURK
	 WrhYsdaTfzYxwq/YO43cF78WP32Mw8C0ldWhcaLhW+oD4jbXtx1jIPgxoobkLYI1pKoLd
	 v4n8jBBnsCmW01w9ge8EiFuEL70Bb4ZF6Yboztuz5XU+EF8wIrN9BXiPj51g7rdn7DHt3
	 86/hC6C4bgrSDZXNCat0k6AV1+93CEPMgXyxruyzPlCaQoD1ercioIx/MjHRT5DM5aFeX
	 jP5ENU/C9eePHOSjbWrtDzY89Mb23cg5jqGePcI1zuQD0qwcH/LaELZUqQyFaWJVJYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114366;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=6SUYGTh6KQ+CEW5/gGpwzlpf1PM6Ff3twZ/q0wEHr9g=;
	b=oFMQS7LIOLxxYYxDiKGjR6SqCpjpsXwFIAWpOH6CAy4godo3alPGiBbUzqMeAQPo6xyz
	 UVuUDsnLhLulb8kNHN9SWTG8CbFCIdm6rGdZCiJLmyqTYOFEZXuBsEEyYwFRa/JdLih8a
	 uFQm28nOxcWoxTCALmxljSIOqxQhlPGMiTAiaFBi67rtnMGP8io3axLmJ2DCDLPf/9TTr
	 u54zvRZWjIzXz0nEewFb1mXFpqhG+SU29ttrZaI1CCWNDdGRvU0u0bBA1c/IU1MQuB76r
	 fFobNxEvSKCQUcDHfcEeqR9sX11WpXF4ARWlS5K95laZ86O+tbDIUhL4oCwWEWDDP2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RqWJgbjF;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641E8606E8D3
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 641E8606E8D3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RqWJgbjF
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-85c1135c289so85747a34.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114365; x=1795719165; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6SUYGTh6KQ+CEW5/gGpwzlpf1PM6Ff3twZ/q0wEHr9g=;
        b=RqWJgbjFVss72SjlWC1DQpc5tZXzpwsU0pucum2eU1g3xw9ihDslSKxDn804yWgGla
         0Eey9F0Jl4zsqyYPSfTWjHOkqNSG5M9BKy3161cJr61/Cyxbh53CFTPhuLNlLMTnef5z
         Uwkg1oyyAYVIJ37+SCcOD3gT+xkAtDtJX3v0ofX5QJNTD45pfm7/ILhFdAoVRtpr+oAW
         IeY3X+qT8VuQ2e/oV9VNaNy0DFKD8wVyIZGoOHgzrJwUSs766ab87jXTpneB+OJw4flO
         a2y2+ZN6FJrV4VsveeUOwV8OKKxkSxbTvOhG9Jb07bQHo0Umq7pzrjhcxIR/ARti5AzN
         kM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114365; x=1795719165;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6SUYGTh6KQ+CEW5/gGpwzlpf1PM6Ff3twZ/q0wEHr9g=;
        b=iDdrWAI3SgngPquFJ1zNpkiWrD4I7Vj4g6+1a3uMsNrx6cybZxKV9gnGM/DIrIJkmI
         +GmJDQHu2fq5A0bhd4DP0T8bcu5y5UQaaF3SbooWnJlbC70KVCMey92RQEhcFNikYA+g
         ssHMzzpcU0n1OlPNpjXQ9AvEALg1wB2tYD9qRV+C+sPHIDDzAZ7wEnYUo+qblBxzms6S
         Bj+tmOhJ7jJNR3LQhtqeSDG6oCOdlGj0DFqVFS8ZsADp9EiD/Oo24Uw+GpuSgfNbnx7o
         KP/gzZB3MZoGzpZuoosYKTmkX8dcdz6WaZNyVW485V1dxDrFL2N4p3L3ycu1RVZBQKJY
         3bRQ==
X-Forwarded-Encrypted: i=1; AL+hErGPsXfSP9ako/109ZIx7PLn5BOdKyTnjVU1jWesmVitVZ7QrgF/3X0Ob+jcOPYrdN/1gNDu0aQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z/6kKo5019NapoB+ighVdprM3H3ihB/+rA4X4hsNJcq3ETTRrHa
	spMWgUDqTrN0EyawUZp6Jvsx7xCwR7AZsYqmmbOn9hJy35H7vXhGUEOrNFsNFnWbFMCxXjwLJsf
	jM0q9aYZA9BjQTowxkP2MLmo78A==
X-Received: from iohf23-n2.prod.google.com ([2002:a05:6602:a5d7:20b0:9c4:c2b7:385f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:17a1:b0:4c3:7073:8c4d with SMTP id 5614622812f47-57a0a211c58mr1003347b6e.20.1795114365076;
 Thu, 19 Nov 2026 10:52:45 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:12 +0000
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
Message-ID: <20261119185215.632334-31-coltonlewis@google.com>
Subject: [PATCH v10 30/33] KVM: arm64: Support zero event counters on
 Partitioned PMU without HPMN0
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

Programming MDCR_EL2.HPMN to 0 is CONSTRAINED UNPREDICTABLE on CPUs that
do not implement FEAT_HPMN0, preventing userspace from configuring a
cycle-counter-only Partitioned PMU guest (nr_pmu_counters == 0) on those
platforms if HPMN is set directly from nr_pmu_counters.

Support nr_pmu_counters == 0 without FEAT_HPMN0 whenever the PMU has at
least two general-purpose counters by setting physical MDCR_EL2.HPMN = 1
(via kvm_arm_pmu_part_hpmn()), reserving and quiescing physical counter 0
alongside PMCCNTR_EL0 on vCPU load so host perf uses counters 1..N-1,
keeping MDCR_EL2.TPMCR set so trapped PMCR_EL0 reads report N == 0, and
enabling fine-grained traps on PMEVCNTRn_EL0, PMCNTEN, PMINTEN, and
PMSWINC_EL0 so counter 0 remains completely hidden from the guest while
PMCCNTR_EL0 accesses stay untrapped on FEAT_FGT hosts.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c     | 16 ++++++++++----
 arch/arm64/kvm/debug.c      | 12 ++++++-----
 arch/arm64/kvm/pmu-direct.c | 42 ++++++++++++++++++++++++++++++-------
 arch/arm64/kvm/pmu.c        | 15 +++++++++++--
 include/kvm/arm_pmu.h       |  6 ++++++
 5 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 0ec74e45fdbf6..bbe940f6266aa 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1791,6 +1791,8 @@ static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HDFGRTR_EL2);
 
 	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		unsigned int n = vcpu->kvm->arch.nr_pmu_counters;
+		bool hide_gp0 = kvm_arm_pmu_part_hpmn(n) != n;
 		u64 set = HDFGRTR_EL2_PMOVS |
 			  HDFGRTR_EL2_PMCCFILTR_EL0 |
 			  HDFGRTR_EL2_PMEVTYPERn_EL0 |
@@ -1801,10 +1803,12 @@ static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
 		    (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_TPM))
 			set |= HDFGRTR_EL2_PMUSERENR_EL0;
 
-		if (kvm_pmu_hyp_counter_mask(vcpu))
+		if (kvm_pmu_hyp_counter_mask(vcpu) || hide_gp0)
 			set |= HDFGRTR_EL2_PMCNTEN;
-		if (kvm_pmu_part_ovf32_mask(vcpu))
+		if (kvm_pmu_part_ovf32_mask(vcpu) || hide_gp0)
 			set |= HDFGRTR_EL2_PMEVCNTRn_EL0;
+		if (hide_gp0)
+			set |= HDFGRTR_EL2_PMINTEN;
 
 		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= set & ~hdfgrtr_masks.res0;
 	}
@@ -1818,6 +1822,8 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
 
 	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		unsigned int n = vcpu->kvm->arch.nr_pmu_counters;
+		bool hide_gp0 = kvm_arm_pmu_part_hpmn(n) != n;
 		u64 set = HDFGWTR_EL2_PMOVS |
 			  HDFGWTR_EL2_PMCCFILTR_EL0 |
 			  HDFGWTR_EL2_PMEVTYPERn_EL0;
@@ -1825,10 +1831,12 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		if (is_hyp_ctxt(vcpu))
 			set |= HDFGWTR_EL2_PMUSERENR_EL0;
 
-		if (kvm_pmu_hyp_counter_mask(vcpu))
+		if (kvm_pmu_hyp_counter_mask(vcpu) || hide_gp0)
 			set |= HDFGWTR_EL2_PMCNTEN | HDFGWTR_EL2_PMSWINC_EL0;
-		if (kvm_pmu_part_ovf32_mask(vcpu))
+		if (kvm_pmu_part_ovf32_mask(vcpu) || hide_gp0)
 			set |= HDFGWTR_EL2_PMEVCNTRn_EL0;
+		if (hide_gp0)
+			set |= HDFGWTR_EL2_PMINTEN;
 
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= set & ~hdfgwtr_masks.res0;
 	}
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index b89f46cb59955..73d157f5b8f6f 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -58,11 +58,11 @@ void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	if (kvm_pmu_is_partitioned(vcpu->kvm) && vcpu->arch.pmu.loaded_on_cpu) {
 		u8 nr_host_cntr = *host_data_ptr(nr_event_counters);
 		u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
+		u8 guest_hpmn = kvm_arm_pmu_part_hpmn(nr_guest_cntr);
 
 		if (cpumask_test_cpu(smp_processor_id(),
 				     vcpu->kvm->arch.supported_cpus) &&
-		    nr_guest_cntr < nr_host_cntr &&
-		    (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0)) {
+		    guest_hpmn < nr_host_cntr) {
 			u64 hpmn = FIELD_GET(MDCR_EL2_HPMN, read_sysreg(mdcr_el2));
 			bool hpme;
 
@@ -81,14 +81,16 @@ void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 			 * Take out the coarse grain traps if we are using
 			 * fine grain traps and enforce counter access with
 			 * HPMN. Keep TPMCR when L1 sub-partitions its counters
-			 * so PMCR_EL0 reads and writes trap for multiplexing.
+			 * or when guest_hpmn > nr_guest_cntr (!FEAT_HPMN0 with
+			 * 0 event counters) so PMCR_EL0 accesses trap.
 			 */
 			mdcr &= ~MDCR_EL2_HPMN;
-			mdcr |= FIELD_PREP(MDCR_EL2_HPMN, nr_guest_cntr);
+			mdcr |= FIELD_PREP(MDCR_EL2_HPMN, guest_hpmn);
 
 			if (cpus_have_final_cap(ARM64_HAS_FGT)) {
 				mdcr &= ~MDCR_EL2_TPM;
-				if (!kvm_pmu_hyp_counter_mask(vcpu))
+				if (!kvm_pmu_hyp_counter_mask(vcpu) &&
+				    guest_hpmn == nr_guest_cntr)
 					mdcr &= ~MDCR_EL2_TPMCR;
 			}
 		}
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 6382233e54c71..7b8f0a69641bc 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -89,6 +89,22 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static u64 kvm_vcpu_pmu_reserved_counter_mask(struct kvm_vcpu *vcpu)
+{
+	if (vcpu && kvm_pmu_is_partitioned(vcpu->kvm)) {
+		u64 mask = ARMV8_PMU_CNT_MASK_C;
+		unsigned int hpmn =
+			kvm_arm_pmu_part_hpmn(vcpu->kvm->arch.nr_pmu_counters);
+
+		if (hpmn > 0)
+			mask |= GENMASK_ULL(hpmn - 1, 0);
+
+		return mask;
+	}
+
+	return 0;
+}
+
 static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
 
 /**
@@ -372,8 +388,12 @@ static u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		pmcr &= ~ARMV8_PMU_PMCR_LP;
 
-	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
-		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu)) {
+		u64 hpmn = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+
+		if (hpmn < n)
+			n = hpmn;
+	}
 
 	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
@@ -686,6 +706,7 @@ static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
 static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 {
 	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	unsigned long reserved_counters;
 	unsigned long guest_counters;
 	unsigned long flags;
 	unsigned long daif;
@@ -710,20 +731,27 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 		return;
 	}
 
+	reserved_counters = kvm_vcpu_pmu_reserved_counter_mask(vcpu);
 	guest_counters = kvm_vcpu_pmu_guest_counter_mask(vcpu);
 	if (reserve_counters)
-		kvm_pmu_set_guest_counters(pmu, guest_counters);
+		kvm_pmu_set_guest_counters(pmu, reserved_counters);
 
 	daif = local_daif_save();
 
 	/*
 	 * Ensure guest counters, interrupts, and overflow flags are quiesced
 	 * in hardware before lowering MDCR_EL2.HPMN and marking the partition
-	 * live on this CPU.
+	 * live on this CPU. If counter 0 is reserved solely to satisfy HPMN=1
+	 * without FEAT_HPMN0, scrub and filter it so it cannot count or leak.
 	 */
-	write_sysreg(guest_counters, pmcntenclr_el0);
-	write_sysreg(guest_counters, pmintenclr_el1);
-	write_sysreg(guest_counters, pmovsclr_el0);
+	write_sysreg(reserved_counters, pmcntenclr_el0);
+	write_sysreg(reserved_counters, pmintenclr_el1);
+	write_sysreg(reserved_counters, pmovsclr_el0);
+	if (reserved_counters & ~guest_counters) {
+		write_pmevcntrn(0, 0);
+		write_pmevtypern(0, ARMV8_PMU_EXCLUDE_EL0 |
+				    ARMV8_PMU_EXCLUDE_EL1);
+	}
 	isb();
 
 	vcpu->arch.pmu.loaded_on_cpu = true;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 9d4ad4b7bd8d5..02a1968bd6cb1 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -914,6 +914,13 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
 }
 
+unsigned int kvm_arm_pmu_part_hpmn(unsigned int n)
+{
+	if (!n && !cpus_have_final_cap(ARM64_HAS_HPMN0))
+		return 1;
+	return n;
+}
+
 /**
  * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
  * @vcpu: The vcpu pointer
@@ -923,8 +930,12 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
 	u64 n = vcpu->kvm->arch.nr_pmu_counters;
 
-	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
-		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu)) {
+		u64 hpmn = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+
+		if (hpmn < n)
+			n = hpmn;
+	}
 
 	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 0fe4f593d3f9a..bebf981855040 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -137,6 +137,7 @@ u8 kvm_arm_pmu_get_pmuver_limit(void);
 u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
+unsigned int kvm_arm_pmu_part_hpmn(unsigned int n);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
@@ -277,6 +278,11 @@ static inline u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	return 0;
 }
 
+static inline unsigned int kvm_arm_pmu_part_hpmn(unsigned int n)
+{
+	return n;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.56.1.708.g77570a6a1d-goog

