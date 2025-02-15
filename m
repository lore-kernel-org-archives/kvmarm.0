Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88DA19E7ED
	for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739614433; cv=none; b=Vc1ODvoJzDucvx7Fg1LNdKJauCrg0zdCtE5uJGPl98l7Li3VqUj/HXFz2+z63eTk5XyfaRvunRtVNHVgHdOtZvoAbnB5357vubs+8fGGFzJiKTPu7s+OOX216h2h+Kx8nqkJbS7wTTYdef7bAPSZsxftx3oaUY9TsCVC4dzuvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739614433; c=relaxed/simple;
	bh=MQm7BH+3HDxolqvajl41IzAtVc3dFvt8yipGo/g6mms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXw3tyXvyhHD5krdeR2RfUCHJ0yEJYAtYttEtLqjriCq4j1BjP+Cz985hiQ7yqgXzfilg/Pl1XmbHXjd/E8U09wUpFOjaCkyw0sq/8rVhqy4xoGegEoxMjMyHxFSoSPJWO3RJeaHL2pGMCrRcNoHzYiZTvhYSdaAbpfcldrnXUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=klUcepXr; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="klUcepXr"
Date: Sat, 15 Feb 2025 02:13:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739614418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dy3olq3E5jadbVfjBXT4DnMOc2rqSKWH12ClnJamJeA=;
	b=klUcepXrGPatRwl2AXtl0bWN9JAoryVIFhLxFMxGnWDwrsEtMnXNlRWeJADSGvBay9alA8
	zRbnkTpmelJPLy/LrCWo16ViUB5Y0ymEqkzZygMaEC+hYm1nBwFPG7ucWsbYfcO1poTh5R
	HhTBPS0wQ7H2Zo5a7iWmj6Gdnfu9Ijw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ott <sebott@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
Message-ID: <Z7BoydkyT_h0gwOV@linux.dev>
References: <20250211143910.16775-1-sebott@redhat.com>
 <20250211143910.16775-2-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211143910.16775-2-sebott@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Sebastian,

On Tue, Feb 11, 2025 at 03:39:07PM +0100, Sebastian Ott wrote:
> +static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			      u64 val)
> +{
> +	u32 id = reg_to_encoding(rd);
> +	int ret;
> +
> +	mutex_lock(&vcpu->kvm->arch.config_lock);

There's quite a few early outs, guard() might be a better fit than
explicitly dropping the lock.

> +	/*
> +	 * Since guest access to MIDR_EL1 is not trapped
> +	 * set up VPIDR_EL2 to hold the MIDR_EL1 value.
> +	 */
> +	if (id == SYS_MIDR_EL1)
> +		write_sysreg(val, vpidr_el2);

This is problematic for a couple reasons:

 - If the kernel isn't running at EL2, VPIDR_EL2 is undefined

 - VPIDR_EL2 needs to be handled as part of the vCPU context, not
   written to without a running vCPU. What would happen if two vCPUs
   have different MIDR values?

Here's a new diff with some hacks thrown in to handle VPIDR_EL2
correctly. Very lightly tested :)

Thanks,
Oliver
---
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..3db8c773339e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -373,6 +373,7 @@ struct kvm_arch {
 #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
+	u64 midr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1469,6 +1470,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 	switch (reg) {
 	case sys_reg(3, 0, 0, 1, 0) ... sys_reg(3, 0, 0, 7, 7):
 		return &ka->id_regs[IDREG_IDX(reg)];
+	case SYS_MIDR_EL1:
+		return &ka->midr_el1;
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
 	default:
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 76ff095c6b6e..866411621a39 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -168,9 +168,11 @@ static inline void __sysreg_restore_user_state(struct kvm_cpu_context *ctxt)
 }
 
 static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
-					      u64 mpidr)
+					      u64 midr, u64 mpidr)
 {
-	write_sysreg(mpidr,				vmpidr_el2);
+	write_sysreg(midr, vpidr_el2);
+	write_sysreg(mpidr, vmpidr_el2);
+
 
 	if (has_vhe() ||
 	    !cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
index dba101565de3..a01be1add5ad 100644
--- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
@@ -28,7 +28,15 @@ void __sysreg_save_state_nvhe(struct kvm_cpu_context *ctxt)
 
 void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
 {
-	__sysreg_restore_el1_state(ctxt, ctxt_sys_reg(ctxt, MPIDR_EL1));
+	u64 midr;
+
+	if (ctxt_is_guest(ctxt))
+		midr = kvm_read_vm_id_reg(kern_hyp_va(ctxt_to_vcpu(ctxt)->kvm),
+					  SYS_MIDR_EL1);
+	else
+		midr = read_cpuid_id();
+
+	__sysreg_restore_el1_state(ctxt, midr, ctxt_sys_reg(ctxt, MPIDR_EL1));
 	__sysreg_restore_common_state(ctxt);
 	__sysreg_restore_user_state(ctxt);
 	__sysreg_restore_el2_return_state(ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 90b018e06f2c..1d4b9597eb29 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -87,11 +87,12 @@ static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
 	write_sysreg(__vcpu_sys_reg(vcpu, PAR_EL1),	par_el1);
 	write_sysreg(__vcpu_sys_reg(vcpu, TPIDR_EL1),	tpidr_el1);
 
-	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),		vmpidr_el2);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),	SYS_MAIR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),	SYS_VBAR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),	SYS_CONTEXTIDR);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),	SYS_AMAIR);
+	write_sysreg(kvm_read_vm_id_reg(vcpu->kvm, SYS_MIDR_EL1),	vpidr_el2);
+	write_sysreg(__vcpu_sys_reg(vcpu, MPIDR_EL1),			vmpidr_el2);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, MAIR_EL2),		SYS_MAIR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, VBAR_EL2),		SYS_VBAR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, CONTEXTIDR_EL2),		SYS_CONTEXTIDR);
+	write_sysreg_el1(__vcpu_sys_reg(vcpu, AMAIR_EL2),		SYS_AMAIR);
 
 	if (vcpu_el2_e2h_is_set(vcpu)) {
 		/*
@@ -191,7 +192,7 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
-	u64 mpidr;
+	u64 midr, mpidr;
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	__sysreg_save_user_state(host_ctxt);
@@ -222,10 +223,9 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 		if (vcpu_has_nv(vcpu)) {
 			/*
 			 * Use the guest hypervisor's VPIDR_EL2 when in a
-			 * nested state. The hardware value of MIDR_EL1 gets
-			 * restored on put.
+			 * nested state.
 			 */
-			write_sysreg(ctxt_sys_reg(guest_ctxt, VPIDR_EL2), vpidr_el2);
+			midr = ctxt_sys_reg(guest_ctxt, VPIDR_EL2);
 
 			/*
 			 * As we're restoring a nested guest, set the value
@@ -233,10 +233,11 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 			 */
 			mpidr = ctxt_sys_reg(guest_ctxt, VMPIDR_EL2);
 		} else {
+			midr = kvm_read_vm_id_reg(vcpu->kvm, SYS_MIDR_EL1);
 			mpidr = ctxt_sys_reg(guest_ctxt, MPIDR_EL1);
 		}
 
-		__sysreg_restore_el1_state(guest_ctxt, mpidr);
+		__sysreg_restore_el1_state(guest_ctxt, midr, mpidr);
 	}
 
 	vcpu_set_flag(vcpu, SYSREGS_ON_CPU);
@@ -271,9 +272,5 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
-	/* If leaving a nesting guest, restore MIDR_EL1 default view */
-	if (vcpu_has_nv(vcpu))
-		write_sysreg(read_cpuid_id(),	vpidr_el2);
-
 	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f6cd1ea7fb55..aa1a0443dc6a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1656,7 +1656,7 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
-	if (id == SYS_CTR_EL0)
+	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1)
 		return true;
 
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -1989,6 +1989,34 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	return 0;
 }
 
+static int set_id_reg_non_ftr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+			      u64 val)
+{
+	u32 id = reg_to_encoding(rd);
+
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
+
+	/*
+	 * Once the VM has started the ID registers are immutable. Reject any
+	 * write that does not match the final register value.
+	 */
+	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+		if (val != read_id_reg(vcpu, rd))
+			return -EBUSY;
+
+		return 0;
+	}
+
+	/*
+	 * For non ftr regs do a limited test against the writable mask only.
+	 */
+	if ((rd->val & val) != val)
+		return -EINVAL;
+
+	kvm_set_vm_id_reg(vcpu->kvm, id, val);
+	return 0;
+}
+
 static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		      u64 val)
 {
@@ -2483,6 +2511,15 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+#define FUNCTION_RESET(reg)						\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
+	{								\
+		return read_sysreg(reg);				\
+	}
+
+FUNCTION_RESET(midr_el1)
+
 
 /*
  * Architected system registers.
@@ -2532,6 +2569,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DBGVCR32_EL2), undef_access, reset_val, DBGVCR32_EL2, 0 },
 
+	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg_non_ftr, .visibility = id_visibility,
+	  .reset = reset_midr_el1, .val = GENMASK_ULL(31, 0) },
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
 
 	/*
@@ -4584,13 +4623,11 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
 	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
