Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359D61DDEA
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706295956; cv=none; b=kesoiTV+p3EB9/oVF6Gvl0g8qnpB4k/TFJfOmTIonJo8MgrjIeJaRNeTjnQoW/Jg20BTboxqk3DCntpNpLiVrup5b0iMMZWdoIEU0ViRLer8DPbzULg8ZV52KYVk3jdTMrvC30IrGhIzrwyMo1zjOp715/tMZS/XdeQDZlv5YKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706295956; c=relaxed/simple;
	bh=zR4quB7eq1uUDGMAg/RxjP3luL1kUJg8Yn9rvFBZkSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfNvXou43+1xk8XXXFwWwyWOnfy/2KftHkhGEIC30u2GY4cCaRT5UM70k4/rO73caL41I5lAJP+gJrOly1SwBrJBVGBM/4YeBZnpV2Io/FmFSog3c9QtDTWc7ZIQ71m51MVQVnf0cC/LbkReg/OJIvbGoFd2SfjDmU03xFgkXRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vPbWd4Xf; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vPbWd4Xf"
Date: Fri, 26 Jan 2024 19:05:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706295952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jk9fgwZBRKzJP61HfhdNU0FZbzBbiCNcQ1Rr26fWDQo=;
	b=vPbWd4XfW1WmRsuebYRpTjSvJj6ZApGXwqS7Ckb43uBozPhp3tuwEGNTG20eF0e1IgOLcc
	wmAIJbp4DOFLcmBkTdv8afvksTxE2L8br7JaaJh/mS0pSNVc6uv00UBHBqZr4tvJ4Vaed0
	XZ4YQtow/Z0oDEAywgFvPPSZ70olAV8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 02/25] KVM: arm64: Add feature checking helpers
Message-ID: <ZbQCi_GZ6XuMx49a@linux.dev>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 08:18:29PM +0000, Marc Zyngier wrote:
> In order to make it easier to check whether a particular feature
> is exposed to a guest, add a new set of helpers, with kvm_has_feat()
> being the most useful.
> 
> Follow-up work will make heavy use of these.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

I very much like the way these helpers appear to work. However, I
noticed there are still a few places where we are doing explicit feature
checks against register values instead of using the macros, did you want
to address these?

Using kvm_has_feat() consistently in KVM will hopefully drive the point
home that this is the way we want to see things done going forward.

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3d9467ff73bc..925522470b2b 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -64,12 +64,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 {
 	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
 		   kvm_pmu_event_mask(kvm);
-	u64 pfr0 = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
 
-	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL2, pfr0))
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
 		mask |= ARMV8_PMU_INCLUDE_EL2;
 
-	if (SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr0))
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
 		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
 			ARMV8_PMU_EXCLUDE_NS_EL1 |
 			ARMV8_PMU_EXCLUDE_EL3;
@@ -83,8 +82,10 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
  */
 static bool kvm_pmc_is_64bit(struct kvm_pmc *pmc)
 {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
 	return (pmc->idx == ARMV8_PMU_CYCLE_IDX ||
-		kvm_pmu_is_3p5(kvm_pmc_to_vcpu(pmc)));
+		kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5));
 }
 
 static bool kvm_pmc_has_64bit_overflow(struct kvm_pmc *pmc)
@@ -556,7 +557,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		return;
 
 	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
-	if (!kvm_pmu_is_3p5(vcpu))
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30253bd19917..955eb06f821d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -505,10 +505,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64MMFR1_EL1);
 	u32 sr = reg_to_encoding(r);
 
-	if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
+	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, LO, IMP)) {
 		kvm_inject_undefined(vcpu);
 		return false;
 	}
@@ -2737,8 +2736,7 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 		return ignore_write(vcpu, p);
 	} else {
 		u64 dfr = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
-		u64 pfr = IDREG(vcpu->kvm, SYS_ID_AA64PFR0_EL1);
-		u32 el3 = !!SYS_FIELD_GET(ID_AA64PFR0_EL1, EL3, pfr);
+		u32 el3 = kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, EL3, IMP);
 
 		p->regval = ((SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr) << 28) |
 			     (SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr) << 24) |
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 4b9d8fb393a8..eb4c369a79eb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -90,16 +90,6 @@ void kvm_vcpu_pmu_resync_el0(void);
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
-/*
- * Evaluates as true when emulating PMUv3p5, and false otherwise.
- */
-#define kvm_pmu_is_3p5(vcpu) ({						\
-	u64 val = IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);		\
-	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);	\
-									\
-	pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P5;				\
-})
-
 u8 kvm_arm_pmu_get_pmuver_limit(void);
 u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
@@ -168,7 +158,6 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 }
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
-#define kvm_pmu_is_3p5(vcpu)		({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}

-- 
Thanks,
Oliver
