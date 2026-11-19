Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114363;
	b=KZyxVXqBuQ7xaiV0up+FEO25aeSIh/pQd0Qsbu/5utPKNn4sOKQ4HnuykeNrOsbno7pa
	 vamifjKzaCyu+/ZVmhJQso5OMkmWswmMT5Pf3rWEER8yD9z4CrGVf2JnAnv8i4+j0MC6l
	 rjozGJVXqEDyo430zRWAodRDr2G/mAgQYklvOPHUhzsJK6Bok0dTy0huyMN/ZFdGUOfwL
	 YbHt50o42NsELHLLf+m+gb9qdh2hHnh67MWI5zOf96fw5yf6WChMIwGituRS79ILpzcAM
	 X81AKpEGNd+6BrRK0QIao0/jMDfDHkvetwETetFtM72q/A74zJ3Adwzho5ZSK4/x/nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=uR6hwOVOf1viEvb3VasAxS9sAQNBNMXg72RIlWJe484=;
	b=oFwMhYvT70XOrO5BUFfknLCj3rFTUc+pOOSuWTbVnz3KxE64xMTYxOzPCoTOGCZYbja0
	 YeKLyLGWpgTBmZR70LSwUjD6Hdup5iPTxZHE3ZuV55qQPv9D7zXUNPlnI9hnC1BdYZCUR
	 zNpucWco10VrqA9jBm5OjLeUa8J1wgOVjBePK/jHop6qQ6CuhC1Bh+ks5NlgQMaPJ+vLP
	 D2Z2PoOld7xfmC6tAf8Ujj1GJ1QZTY7TxVzNcOMTFfBYCOTkZdPD3knKOzuZxA7FoCE8s
	 dQs/HQ/UVJBeMDGRav4Y/Rn2uHqP0VGMdv/95P6XCVBimjkrUWGBud8PJXvAY1vd0gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="GVfyM/49";
	arc=none smtp.remote-ip=209.85.160.70
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0686070623
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC0686070623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GVfyM/49
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-49dd26d6f07so162159fac.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114362; x=1795719162; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uR6hwOVOf1viEvb3VasAxS9sAQNBNMXg72RIlWJe484=;
        b=GVfyM/49Aq9xXGqe5HKLLb7NLe/6TMYIlgzKWKLoJjmKfN7FXwpXZQH2Fw+6ese6SY
         RrZGSSjenC+rrcHBvw7wVZQcytsvkgK6RQaUkRcHZhVCAwR+bXpj4LqtmlfpiRu2vl0P
         imP1CX5OpdjZS4F/YoZlDhnR8Fq3OmpU1EOmexcEoymrdGk4ghzf1bro5jRvih/fVT4B
         6pyStFiknjF6ALZP4wYRIKo8dCu5aksg8W3F72fIZSmM6j8XkXRtEca+swtAKj/JHymo
         /EjOQHYkYPpqiZN8wNg3Hu+ugO0stw4rqA9EY3BC88iTAwO+vDYz3Ts+LGxMV38kARG1
         zD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114362; x=1795719162;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uR6hwOVOf1viEvb3VasAxS9sAQNBNMXg72RIlWJe484=;
        b=I0iPiON+s4dLh193qd01blGGYH+IhqsHmu/CrZRylMis56buQidJ+ury4NgwCjMQw0
         Fe1k32ZlG4mFnTgTd5lNfrY03CznFPJafJUEtt+SM4mNK12ucTUfv4FTw2rC/NYtr4jE
         FMNGvtoiII1BYitOEsZnN/reZi+4enMckDG29hwK/90/dJAElkv1IMrPkkmXjPyFVtqU
         25uUM+xdzeHNGU7dtOQEG2HpTB53D7wGib+pvx84A801XIdqBrvdediJRrFi/R/QNfL6
         I8T3USu9cSomJj0Ms5jFNH75ZWNYpUxyPQ2ERfssAKIq4oKLgtIZLkiIt6pJ9VK8rVZH
         Mizg==
X-Forwarded-Encrypted: i=1; AL+hErHVM2zHEQqMI/WDHSmtIjMJ4IBXSq7HHhv7dssFhvWRHMnckpm9RGAAC1XFbwGP/138ZYLM+aM=@lists.linux.dev
X-Gm-Message-State: APuU4Z+tfEytyA6wQPLyYWzp2ypT7R68NKjn9eF87fqhRHnhrW1MgoB2
	a0CYZjWgkPNBp7mw1V8fcLgN7igC8oeYRGFbXR6Q24pzoo9af1vSlB2UJMLhDFDa5SudoWY8BcF
	Sepzb6RMq2boy2bI4jMIQME3sRw==
X-Received: from jafo1-n2.prod.google.com ([2002:a05:6639:301:20b0:620:c289:80b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3023:b0:573:6a05:9b0c with SMTP id 5614622812f47-57a0b851c59mr966873b6e.39.1795114361504;
 Thu, 19 Nov 2026 10:52:41 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:08 +0000
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
Message-ID: <20261119185215.632334-27-coltonlewis@google.com>
Subject: [PATCH v10 26/33] KVM: arm64: Multiplex PMCR_EL0.E and MDCR_EL2.HPME
 for sub-partitioned L1
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

When an L1 hypervisor sub-partitions its counters (vHPMN < N_L1, so
kvm_pmu_hyp_counter_mask(vcpu) is non-zero), all N_L1 guest counters lie
below physical MDCR_EL2.HPMN == N_L1 and are gated in hardware by
physical PMCR_EL0.E. Architecturally, however, counters 0..vHPMN-1 and
PMCCNTR_EL0 are gated by vPMCR_EL0.E while L1's hypervisor counters
vHPMN..N_L1-1 are gated independently by vMDCR_EL2.HPME.

Multiplex both domain enables onto physical PMCNTENSET_EL0 and
PMCR_EL0.E whenever L1 sub-partitions its counters (leaving
non-sub-partitioned guests completely untrapped):
- Keep MDCR_EL2.TPMCR and HDFG{R,W}TR_EL2.PMCNTEN enabled when
  kvm_pmu_hyp_counter_mask(vcpu) is non-zero.
- Maintain architectural guest PMCR_EL0 and PMCNTENSET_EL0 values in
  sys_regs[], set physical PMCR_EL0.E when either vPMCR_EL0.E or
  vMDCR_EL2.HPME is set, and program physical PMCNTENSET_EL0 with only
  those guest-enabled counters whose domain enable is active.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/config.c     |   6 ++
 arch/arm64/kvm/debug.c      |  10 ++-
 arch/arm64/kvm/pmu-direct.c | 166 +++++++++++++++++++++++++++---------
 include/kvm/arm_pmu.h       |   1 +
 4 files changed, 140 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 3220ed6fc9453..4089a144b8f2b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1801,6 +1801,9 @@ static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
 		    (__vcpu_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_TPM))
 			set |= HDFGRTR_EL2_PMUSERENR_EL0;
 
+		if (kvm_pmu_hyp_counter_mask(vcpu))
+			set |= HDFGRTR_EL2_PMCNTEN;
+
 		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= set & ~hdfgrtr_masks.res0;
 	}
 }
@@ -1820,6 +1823,9 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		if (is_hyp_ctxt(vcpu))
 			set |= HDFGWTR_EL2_PMUSERENR_EL0;
 
+		if (kvm_pmu_hyp_counter_mask(vcpu))
+			set |= HDFGWTR_EL2_PMCNTEN;
+
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= set & ~hdfgwtr_masks.res0;
 	}
 }
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index ec9f942b452d8..b89f46cb59955 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -80,13 +80,17 @@ void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 			/*
 			 * Take out the coarse grain traps if we are using
 			 * fine grain traps and enforce counter access with
-			 * HPMN.
+			 * HPMN. Keep TPMCR when L1 sub-partitions its counters
+			 * so PMCR_EL0 reads and writes trap for multiplexing.
 			 */
 			mdcr &= ~MDCR_EL2_HPMN;
 			mdcr |= FIELD_PREP(MDCR_EL2_HPMN, nr_guest_cntr);
 
-			if (cpus_have_final_cap(ARM64_HAS_FGT))
-				mdcr &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
+			if (cpus_have_final_cap(ARM64_HAS_FGT)) {
+				mdcr &= ~MDCR_EL2_TPM;
+				if (!kvm_pmu_hyp_counter_mask(vcpu))
+					mdcr &= ~MDCR_EL2_TPMCR;
+			}
 		}
 	}
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index b0491d32b5d7b..725b5fc17533e 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -91,6 +91,82 @@ static u64 kvm_vcpu_pmu_guest_counter_mask(struct kvm_vcpu *vcpu)
 
 static void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
 
+static u64 kvm_pmu_part_active_cnten_mask(struct kvm_vcpu *vcpu)
+{
+	u64 guest_mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	u64 hyp_mask = kvm_pmu_hyp_counter_mask(vcpu);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	u64 active = 0;
+
+	if (pmcr & ARMV8_PMU_PMCR_E)
+		active |= guest_mask & ~hyp_mask;
+	if (mdcr & MDCR_EL2_HPME)
+		active |= hyp_mask;
+
+	return active;
+}
+
+static void kvm_pmu_part_sync_hw_enables(struct kvm_vcpu *vcpu)
+{
+	u64 guest_mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+	u64 cnten = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &
+		    kvm_pmu_part_active_cnten_mask(vcpu);
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
+	u64 pmcr_mask = ARMV8_PMU_PMCR_MASK &
+			~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+		pmcr_mask &= ~ARMV8_PMU_PMCR_LP;
+
+	pmcr &= pmcr_mask;
+	if (mdcr & MDCR_EL2_HPME)
+		pmcr |= ARMV8_PMU_PMCR_E;
+
+	write_sysreg(~cnten & guest_mask, pmcntenclr_el0);
+	write_sysreg(cnten & guest_mask, pmcntenset_el0);
+	write_sysreg(pmcr, pmcr_el0);
+}
+
+static void kvm_pmu_direct_cnten_write(struct kvm_vcpu *vcpu, u64 val, bool set)
+{
+	u64 mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+
+	lockdep_assert_preemption_disabled();
+
+	val &= mask;
+	if (set) {
+		__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
+		if (val)
+			kvm_pmu_set_guest_owned(vcpu);
+	} else {
+		__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
+	}
+
+	if (!kvm_pmu_part_on_cpu(vcpu))
+		return;
+
+	if (vcpu->arch.pmu.multiplex_enables)
+		kvm_pmu_part_sync_hw_enables(vcpu);
+	else if (set)
+		write_sysreg(val, pmcntenset_el0);
+	else
+		write_sysreg(val, pmcntenclr_el0);
+}
+
+static u64 kvm_pmu_direct_cnten_read(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_vcpu_pmu_guest_counter_mask(vcpu);
+
+	lockdep_assert_preemption_disabled();
+
+	if (kvm_pmu_part_on_cpu(vcpu) && !vcpu->arch.pmu.multiplex_enables)
+		return read_sysreg(pmcntenset_el0) & mask;
+
+	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+}
+
 static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 {
 	bool reset_p = val & ARMV8_PMU_PMCR_P;
@@ -133,7 +209,11 @@ static void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
 			write_pmevcntrn(i, 0);
 	}
 
-	write_sysreg(val & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C), pmcr_el0);
+	if (vcpu->arch.pmu.multiplex_enables)
+		kvm_pmu_part_sync_hw_enables(vcpu);
+	else
+		write_sysreg(val & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C),
+			     pmcr_el0);
 }
 
 static u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
@@ -147,6 +227,10 @@ static u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 		return kvm_vcpu_read_pmcr(vcpu);
 
 	pmcr = read_sysreg(pmcr_el0);
+	if (vcpu->arch.pmu.multiplex_enables) {
+		pmcr &= ~ARMV8_PMU_PMCR_MASK;
+		pmcr |= __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_MASK;
+	}
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		pmcr &= ~ARMV8_PMU_PMCR_LP;
 
@@ -232,6 +316,7 @@ static u64 kvm_pmu_direct_cntr_read(struct kvm_vcpu *vcpu, u8 idx)
 
 	return read_pmevcntrn(idx);
 }
+
 static void kvm_pmu_direct_cntr_write(struct kvm_vcpu *vcpu, u8 idx, u64 val)
 {
 	lockdep_assert_preemption_disabled();
@@ -273,10 +358,7 @@ u64 kvm_pmu_direct_reg_read(struct kvm_vcpu *vcpu, unsigned int reg)
 	case PMEVTYPER0_EL0 ... PMCCFILTR_EL0:
 		return __vcpu_sys_reg(vcpu, reg);
 	case PMCNTENSET_EL0:
-		if (kvm_pmu_part_on_cpu(vcpu))
-			return read_sysreg(pmcntenset_el0) &
-			       kvm_vcpu_pmu_guest_counter_mask(vcpu);
-		return __vcpu_sys_reg(vcpu, reg);
+		return kvm_pmu_direct_cnten_read(vcpu);
 	case PMINTENSET_EL1:
 		if (kvm_pmu_part_on_cpu(vcpu))
 			return read_sysreg(pmintenset_el1) &
@@ -410,18 +492,7 @@ void kvm_pmu_direct_reg_write(struct kvm_vcpu *vcpu, unsigned int reg,
 		kvm_pmu_apply_single_event_filter(vcpu, reg - PMEVTYPER0_EL0);
 		break;
 	case PMCNTENSET_EL0:
-		val &= kvm_vcpu_pmu_guest_counter_mask(vcpu);
-		if (set) {
-			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
-			if (val)
-				kvm_pmu_set_guest_owned(vcpu);
-			if (kvm_pmu_part_on_cpu(vcpu))
-				write_sysreg(val, pmcntenset_el0);
-		} else {
-			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
-			if (kvm_pmu_part_on_cpu(vcpu))
-				write_sysreg(val, pmcntenclr_el0);
-		}
+		kvm_pmu_direct_cnten_write(vcpu, val, set);
 		break;
 	case PMINTENSET_EL1:
 		val &= kvm_vcpu_pmu_guest_counter_mask(vcpu);
@@ -545,6 +616,7 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	isb();
 
 	vcpu->arch.pmu.loaded_on_cpu = true;
+	vcpu->arch.pmu.multiplex_enables = !!kvm_pmu_hyp_counter_mask(vcpu);
 	kvm_arm_setup_mdcr_el2(vcpu);
 	isb();
 
@@ -568,14 +640,6 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 		write_sysreg(val, pmuserenr_el0);
 	}
 
-	/* Save only the stateful writable bits. */
-	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	mask = ARMV8_PMU_PMCR_MASK &
-		~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
-		mask &= ~ARMV8_PMU_PMCR_LP;
-	write_sysreg(val & mask, pmcr_el0);
-
 	/*
 	 * When handling these:
 	 * 1. Apply only the bits for guest counters (indicated by mask)
@@ -591,9 +655,23 @@ static void __kvm_pmu_load(struct kvm_vcpu *vcpu, bool reserve_counters)
 	write_sysreg(mask, pmovsclr_el0);
 	isb();
 
-	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
-	write_sysreg(val & mask, pmcntenset_el0);
-	write_sysreg(~val & mask, pmcntenclr_el0);
+	if (vcpu->arch.pmu.multiplex_enables) {
+		kvm_pmu_part_sync_hw_enables(vcpu);
+	} else {
+		u64 pmcr_mask = ARMV8_PMU_PMCR_MASK &
+				~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+			pmcr_mask &= ~ARMV8_PMU_PMCR_LP;
+
+		/* Save only the stateful writable bits. */
+		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		write_sysreg(val & pmcr_mask, pmcr_el0);
+
+		val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		write_sysreg(val & mask, pmcntenset_el0);
+		write_sysreg(~val & mask, pmcntenclr_el0);
+	}
 
 	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	write_sysreg(val & mask, pmintenset_el1);
@@ -657,8 +735,10 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 	daif = local_daif_save();
 
 	/* Mask these to only save the guest relevant bits. */
-	val = read_sysreg(pmcntenset_el0);
-	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+	if (!vcpu->arch.pmu.multiplex_enables) {
+		val = read_sysreg(pmcntenset_el0);
+		__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+	}
 
 	val = read_sysreg(pmintenset_el1);
 	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
@@ -690,12 +770,14 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
 
-	val = read_sysreg(pmcr_el0);
-	pmcr_mask = ARMV8_PMU_PMCR_MASK;
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
-		pmcr_mask &= ~ARMV8_PMU_PMCR_LP;
-	__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, &=, ~ARMV8_PMU_PMCR_MASK);
-	__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, |=, val & pmcr_mask);
+	if (!vcpu->arch.pmu.multiplex_enables) {
+		pmcr_mask = ARMV8_PMU_PMCR_MASK;
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
+			pmcr_mask &= ~ARMV8_PMU_PMCR_LP;
+		val = read_sysreg(pmcr_el0);
+		__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, &=, ~ARMV8_PMU_PMCR_MASK);
+		__vcpu_rmw_sys_reg(vcpu, PMCR_EL0, |=, val & pmcr_mask);
+	}
 
 	val = ARMV8_PMU_PMCR_LC;
 	if (pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5)
@@ -710,6 +792,7 @@ static void __kvm_pmu_put(struct kvm_vcpu *vcpu, bool release_counters)
 	write_sysreg(val & mask, pmovsclr_el0);
 
 	vcpu->arch.pmu.loaded_on_cpu = false;
+	vcpu->arch.pmu.multiplex_enables = false;
 	kvm_arm_setup_mdcr_el2(vcpu);
 	isb();
 
@@ -741,9 +824,9 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
  * kvm_pmu_reload_part() - Reload partitioned PMU traps, filters, and state
  * @vcpu: Pointer to struct kvm_vcpu
  *
- * Refresh MDCR_EL2 trap bits, event filters, and hardware register state
- * without releasing the host counter reservation when the partitioned PMU is
- * already loaded on the CPU.
+ * Refresh fine-grained traps, MDCR_EL2 trap bits, event filters, and
+ * enable multiplexing without releasing the host counter reservation
+ * when the partitioned PMU is already loaded on the CPU.
  */
 void kvm_pmu_reload_part(struct kvm_vcpu *vcpu)
 {
@@ -864,7 +947,10 @@ bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
 			write_sysreg(hw_ovf, pmovsclr_el0);
 		}
 		pmint = read_pmintenset();
-		pmcr = read_pmcr();
+		if (vcpu->arch.pmu.multiplex_enables)
+			pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+		else
+			pmcr = read_pmcr();
 	} else {
 		pmint = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 		pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index fcd8e6331943e..9e5fcbe2ccbb1 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -45,6 +45,7 @@ struct kvm_pmu {
 	int irq_num;
 	bool created;
 	bool loaded_on_cpu;
+	bool multiplex_enables;
 	enum vcpu_pmu_register_access access;
 };
 
-- 
2.56.1.708.g77570a6a1d-goog

