Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E1923BB
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718180; cv=none; b=BKpNrGBlPNe4Mmh2U7y6jNZvedV0KKel7Sk6wnGLFwp1lOEvaf4t35Cb4ubG0aZ/rvUCjJ2Fl2AijUPX4ckf3/T0ByU7/5tmja7LpIZlWZYvPMlI/p8cI2B9ipmwW26W4wYb3JHQrrKTURd8Zeszv514pl+S06Bx2hgJBqQyO2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718180; c=relaxed/simple;
	bh=NXRXDKUN5mFCpk2+VYZXQ09I1IwnaN3unhzsOdXL3+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwDGl6NnXfXVGsr6rVhX0fxZJSD9C/p/zRRy+P2e2b9sA/uxsGC67Qk9+vxa717sccFgU4oBWIp23iB3jtWHmTLYETVc9wEr3KqYf+mwJXwnfvFeg9LftjxvQL8TT5m04yOnAXrgt9KAqO7FsjhUjmCIkupaJfT2gkilKCussvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IAo21yWr; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IAo21yWr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu9+TD+bb38HPdIfEAajF43HZcHJDO3VYBEqGiNwXAA=;
	b=IAo21yWrCxgUnhX6DNt73vbr0pk0InPi76Ls45MS0nEm0eIeQtlcdCk4cXD7a0Ihvg2rRF
	+CqZYQPpBAPZD7pz0aDcR0Ol50u8XVLcC/8+6wPfVsYfTYuhGOmjzFUDz1b+Q5TwmQKSUs
	Bckz7yZqwIjsSWxE+58OJ/GlIwXwCyo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 05/12] KVM: arm64: nv: Reinject traps that take effect in Host EL0
Date: Tue, 27 Aug 2024 00:22:28 +0000
Message-ID: <20240827002235.1753237-6-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Wire up the other end of traps that affect host EL0 by actually
injecting them into the guest hypervisor. Skip over FGT entirely, as a
cursory glance suggests no FGT is effective in host EL0.

Note that kvm_inject_nested() is already equipped for handling
exceptions while the VM is already in a host context.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++++
 arch/arm64/kvm/emulate-nested.c      | 25 +++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a601a9305b10..bf0c48403f59 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -225,6 +225,11 @@ static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 	return vcpu_has_nv(vcpu) && __is_hyp_ctxt(&vcpu->arch.ctxt);
 }
 
+static inline bool vcpu_is_host_el0(const struct kvm_vcpu *vcpu)
+{
+	return is_hyp_ctxt(vcpu) && !vcpu_is_el2(vcpu);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b9f3e19a1b96..4548725a0899 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2087,11 +2087,19 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 	return masks->mask[sr - __VNCR_START__].res0;
 }
 
-static bool check_fgt_bit(struct kvm *kvm, bool is_read,
+static bool check_fgt_bit(struct kvm_vcpu *vcpu, bool is_read,
 			  u64 val, const union trap_config tc)
 {
+	struct kvm *kvm = vcpu->kvm;
 	enum vcpu_sysreg sr;
 
+	/*
+	 * KVM doesn't know about any FGTs that apply to the host, and hopefully
+	 * that'll remain the case.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		return false;
+
 	if (tc.pol)
 		return (val & BIT(tc.bit));
 
@@ -2168,7 +2176,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	 * If we're not nesting, immediately return to the caller, with the
 	 * sysreg index, should we have it.
 	 */
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+	if (!vcpu_has_nv(vcpu))
+		goto local;
+
+	/*
+	 * Handle the trap locally if we're in a hyp context where the trap
+	 * config does not apply.
+	 */
+	if (is_hyp_ctxt(vcpu) && !(vcpu_is_host_el0(vcpu) && tc.in_host_el0))
 		goto local;
 
 	switch ((enum fgt_group_id)tc.fgt) {
@@ -2214,12 +2229,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 		goto local;
 	}
 
-	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu->kvm, is_read,
-							val, tc))
+	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(vcpu, is_read, val, tc))
 		goto inject;
 
 	b = compute_trap_behaviour(vcpu, tc);
 
+	if (!(b & BEHAVE_IN_HOST_EL0) && vcpu_is_host_el0(vcpu))
+		goto local;
+
 	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
 	    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
 		goto inject;
-- 
2.46.0.295.g3b9ea8a38a-goog

