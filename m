Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4243B21217F
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880668; cv=none; b=MaynYWqLZYPv64mIqXUEEsNUAxfIPY1X+3Obx7Ye+g8D6GGs9hDgnOlFqhB+PjSowKsnUZNl4m4KmMYCIomjnmPFdQQooTC9PQfhAWy6RXblsUqk7UiF+ZSLP8u0vWYmWnwoL0iA9qvKJKmP6BlmU94PIko/q6+JeFkhwdkHAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880668; c=relaxed/simple;
	bh=+CCGNeATfq1uVnjy7GKENLX5OKoPHdpQn41Y6gDlXMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBhpazhfK2QNCrGInPz7i4bQvN8PrOtJ1dBmYY6rZMAhuqx9/bgbIBiJNe0mtfOAbhjaaYaUaYxptfS9naLrfEudOIxASx0j1EezAKyUQfYO6dQ+Oqgu7jA1J7rB12I5zo4Gt6bLtwU9FkkjSFAALiWcQSopgwRTRebkQtwbF5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BHWNcQWP; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BHWNcQWP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jKTm4m4xkSSDot5gqGTZZQZNLb6OMOWuE8JyjW0IZZY=;
	b=BHWNcQWPDW1S1mG8FF6FNSbbPA6gMsGUnfLq7qoAakfp3QrKtVLHp1hE4I1Q8Yxn9KyTcM
	2JrFBBuq3MAwMvrO0NzOxMrDU8WxpP1NrplBleeyITXFegwZruuBZoBhqr003jNmwGgqvl
	7oHkKhlvePI2uDD92XrZH6d+ZqmjmzI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 08/18] KVM: arm64: nv: Reinject traps that take effect in Host EL0
Date: Fri, 25 Oct 2024 18:23:43 +0000
Message-ID: <20241025182354.3364124-9-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/emulate-nested.c      | 29 ++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

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
index e1a30d1bcd06..db3149379a4d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -20,6 +20,9 @@ enum trap_behaviour {
 	BEHAVE_FORWARD_READ	= BIT(0),
 	BEHAVE_FORWARD_WRITE	= BIT(1),
 	BEHAVE_FORWARD_RW	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
+
+	/* Traps that take effect in Host EL0, this is rare! */
+	BEHAVE_IN_HOST_EL0	= BIT(2),
 };
 
 struct trap_bits {
@@ -2128,11 +2131,19 @@ static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
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
 
@@ -2209,7 +2220,15 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	 * If we're not nesting, immediately return to the caller, with the
 	 * sysreg index, should we have it.
 	 */
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+	if (!vcpu_has_nv(vcpu))
+		goto local;
+
+	/*
+	 * There are a few traps that take effect InHost, but are constrained
+	 * to EL0. Don't bother with computing the trap behaviour if the vCPU
+	 * isn't in EL0.
+	 */
+	if (is_hyp_ctxt(vcpu) && !vcpu_is_host_el0(vcpu))
 		goto local;
 
 	switch ((enum fgt_group_id)tc.fgt) {
@@ -2255,12 +2274,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
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
2.47.0.163.g1226f6d8fa-goog

