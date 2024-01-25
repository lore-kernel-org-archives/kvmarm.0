Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A1412A16D
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706204131; cv=none; b=j5U63jBWBgR3OvtswwTg2oxr32jj52B/00egxepJPI7pPHCygJYj5AubfJLAItT/ANnW6ZWOQj2rOovT+4EudVITNEAG0u1A5yDhzBNZm/Veoy5x2tdfTTwK92k8FOBgUxIupuwpYhaFNV/0e6y2CvG5hVvgrgi7VOi+Z8ZWwV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706204131; c=relaxed/simple;
	bh=/cLAk+F1AABJ4sbcosvM8VuQlC52sTIRj1drP60tknE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/P201bnNwH95y0QCBRHgDJlIYaZURAWyqJG2WrJz2G2ZXrWi7+pG1QqxTPw90d6on/8Wm0Uq9DAOg8gnsP/JaGhijzFPLE0+7n4x1zo+m5f7y6dPiPZrBKva6b+YBD+tWv7EOfwRb5azziGXTplkHh+zh8IR4r/s6Ksj1Gw9/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 991D91FB;
	Thu, 25 Jan 2024 09:36:12 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D70B73F73F;
	Thu, 25 Jan 2024 09:35:26 -0800 (PST)
Date: Thu, 25 Jan 2024 17:35:21 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 24/25] KVM: arm64: Make FEAT_MOPS UNDEF if not advertised
 to the guest
Message-ID: <20240125172646.GA1709884@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-25-maz@kernel.org>
 <20240125162538.GF1535978@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240125162538.GF1535978@e124191.cambridge.arm.com>

It's me again!

On Thu, Jan 25, 2024 at 04:25:38PM +0000, Joey Gouly wrote:
> On Mon, Jan 22, 2024 at 08:18:51PM +0000, Marc Zyngier wrote:
> > We unconditionally enable FEAT_MOPS, which is obviously wrong.
> > 
> > So let's only do that when it is advertised to the guest.
> > Which means we need to rely on a per-vcpu HCRX_EL2 shadow register.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h        | 4 +---
> >  arch/arm64/include/asm/kvm_host.h       | 1 +
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
> >  arch/arm64/kvm/sys_regs.c               | 8 ++++++++
> >  4 files changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 3c6f8ba1e479..a1769e415d72 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -102,9 +102,7 @@
> >  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
> >  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
> >  
> > -#define HCRX_GUEST_FLAGS \
> > -	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
> > -	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
> > +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
> >  #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
> >  
> >  /* TCR_EL2 Registers bits */
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index fe5ed4bcded0..22343354db3e 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -584,6 +584,7 @@ struct kvm_vcpu_arch {
> >  
> >  	/* Values of trap registers for the guest. */
> >  	u64 hcr_el2;
> > +	u64 hcrx_el2;
> >  	u64 mdcr_el2;
> >  	u64 cptr_el2;
> >  
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 2d5891518006..e3fcf8c4d5b4 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -236,7 +236,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> >  
> >  	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> > -		u64 hcrx = HCRX_GUEST_FLAGS;
> > +		u64 hcrx = vcpu->arch.hcrx_el2;
> >  		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> >  			u64 clr = 0, set = 0;
> >  
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index afe6975fcf5c..b7977e08e4ef 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -3952,6 +3952,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
> >  	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> >  		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
> >  
> > +	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> > +		vcpu->arch.hcrx_el2 = HCRX_GUEST_FLAGS;
> > +
> > +		if (kvm_has_feat(kern_hyp_va(vcpu->kvm),
> 
> Not sure if the use of kern_hyp_va is intentional, seems out of place since we
> use the bare `kvm` variable everyone else.

My conclusion is that it's a mistake (kvm-arm.mode=nvhe):

[ 2707.523935] Unable to handle kernel paging request at virtual address 0000d34801b3fdb0                                                                      
[ 2707.523945] Mem abort info:                                                                                                                                 
[ 2707.523951]   ESR = 0x0000000096000004                                                                                                                      
[ 2707.523957]   EC = 0x25: DABT (current EL), IL = 32 bits                                                                                                    
[ 2707.523966]   SET = 0, FnV = 0                                                                                                                              
[ 2707.523973]   EA = 0, S1PTW = 0                                                                                                                             
[ 2707.523980]   FSC = 0x04: level 0 translation fault                                                                                                         
[ 2707.523988] Data abort info:                                                                                                                                
[ 2707.523993]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[ 2707.524001]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[ 2707.524010]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 2707.524019] user pgtable: 4k pages, 48-bit VAs, pgdp=000000088341d000
[ 2707.524029] [0000d34801b3fdb0] pgd=0000000000000000, p4d=0000000000000000
[ 2707.524043] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[ 2707.524053] Modules linked in:
[ 2707.524060] CPU: 0 PID: 95 Comm: kvm-vcpu-0 Tainted: G                T  6.8.0-rc1-asahi+ #4542 a70fa90dc88a9bc3f39943d7335081d8cc583f45
[ 2707.524076] Hardware name: FVP Base RevC (DT)
[ 2707.524083] pstate: 141402005 (nZcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--) 
[ 2707.524096] pc : kvm_init_sysreg+0x100/0x398
[ 2707.524106] lr : kvm_init_sysreg+0xd8/0x398
[ 2707.524116] sp : ffff8000808e3a60
[ 2707.524123] x29: ffff8000808e3a60 x28: ffff000802f0d640 x27: 0000000000000001
[ 2707.524141] x26: 0000000000000000 x25: ffff000802f30000 x24: 0000000000000000
[ 2707.524159] x23: ffff000800189100 x22: ffff000802f0d640 x21: ffff000801b3fbc8
[ 2707.524177] x20: ffff000802f30000 x19: ffff000801b3f000 x18: ffffffffffffffff
[ 2707.524195] x17: 0000000000000000 x16: 0000000000000000 x15: ffff8001008e36e7
[ 2707.524213] x14: 0000000000000000 x13: ffffd7c64c841608 x12: 0000000000000537
[ 2707.524230] x11: 00000000000001bd x10: ffffd7c64c899608 x9 : ffffd7c64c841608
[ 2707.524248] x8 : 00000000ffffefff x7 : ffffd7c64c899608 x6 : 0000000000000000
[ 2707.524266] x5 : 000000000000bff4 x4 : 0000000000000000 x3 : 0000000000000000
[ 2707.524283] x2 : ffff000802f0d640 x1 : 0000000000004020 x0 : 0000d34801b3f000
[ 2707.524301] Call trace:
[ 2707.524306]  kvm_init_sysreg+0x100/0x398
[ 2707.524316]  kvm_arch_vcpu_run_pid_change+0xe8/0x3f4
[ 2707.524330]  kvm_vcpu_ioctl+0x878/0x944
[ 2707.524341]  __arm64_sys_ioctl+0x404/0xc68

Thanks,
Joey
