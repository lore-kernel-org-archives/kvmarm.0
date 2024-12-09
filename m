Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4724155327
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767822; cv=none; b=oXEYjdbqGNCSypPvvdkhkeB5tQ87EfNwvZRoaB18xgvsMuSvmgWWF4VEu4mT64VFRwUkg2TvVEsOsEHZdd9TD2BPnNOiBhlx2IHlO2vQPEMyLMJZ3EDoM8KmQA7+Qltqk/lWr1vusHkLtuBfZBkVv63GlxRWNJVVAnUoThvsHKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767822; c=relaxed/simple;
	bh=dDl9mifLx9P3npY23ud2feB10tk81JwtRJrMQDkKRyM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YdZo1tOUZ7HQ3gP27PD27OvPYEywDqs6yPTeJDJBje/nEqDNdcyKHF4ZELu1UQKNMhTNvTOZIDKLuxyviGHoKY2j49KFYbgGU67sBqd/aF/CuqnqAF05BldZFRNFfbAKa5E4KCQ46WGoplVE9cf2mezBYLTVNI7L/j8Lqd8cpK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MbkaQ30b; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MbkaQ30b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZgznvOI0Lx638WIK8Aytb6ptbaY3O3FenP4yaSRjNJY=;
	b=MbkaQ30b+y0cLV/wgn/sllNQKeJT3vpZTfF6qpofgNMPw/5UDSPRegmqHGT+iHbZ+pGOvH
	pBxDSAk2C9ztxGKmfl3TINOTiW2l6/fPE+6qYOVTQIAdCmoYxRipSwcX2CVlH0P3dJx8/D
	k39XgD8S+kZRMyFSd2xJcxpI4gtbLB8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 15/16] KVM: arm64: nv: Honor MDCR_EL2.TDE routing for debug exceptions
Date: Mon,  9 Dec 2024 10:09:25 -0800
Message-Id: <20241209180926.2161373-16-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Inject debug exceptions into vEL2 if MDCR_EL2.TDE is set.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/emulate-nested.c     | 23 +++++++++++++++++++----
 arch/arm64/kvm/handle_exit.c        |  3 +++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 233e65522716..ec6e28d63d26 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -64,6 +64,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 }
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
+extern bool forward_debug_exception(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1ffbfd1c3cf2..e37fb598cc24 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2345,14 +2345,14 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	return true;
 }
 
-static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+static bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
 	bool control_bit_set;
 
 	if (!vcpu_has_nv(vcpu))
 		return false;
 
-	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
 	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
@@ -2360,9 +2360,24 @@ static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
 	return false;
 }
 
+static bool forward_hcr_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, HCR_EL2, control_bit);
+}
+
 bool forward_smc_trap(struct kvm_vcpu *vcpu)
 {
-	return forward_traps(vcpu, HCR_TSC);
+	return forward_hcr_traps(vcpu, HCR_TSC);
+}
+
+static bool forward_mdcr_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, MDCR_EL2, control_bit);
+}
+
+bool forward_debug_exception(struct kvm_vcpu *vcpu)
+{
+	return forward_mdcr_traps(vcpu, MDCR_EL2_TDE);
 }
 
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
@@ -2406,7 +2421,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	 * Forward this trap to the virtual EL2 if the virtual
 	 * HCR_EL2.NV bit is set and this is coming from !EL2.
 	 */
-	if (forward_traps(vcpu, HCR_NV))
+	if (forward_hcr_traps(vcpu, HCR_NV))
 		return;
 
 	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1e302f0c8903..512d152233ff 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -183,6 +183,9 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 
+	if (!vcpu->guest_debug && forward_debug_exception(vcpu))
+		return 1;
+
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = lower_32_bits(esr);
 	run->debug.arch.hsr_high = upper_32_bits(esr);
-- 
2.39.5

