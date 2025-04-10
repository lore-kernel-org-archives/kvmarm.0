Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9912853F8
	for <kvmarm@lists.linux.dev>; Thu, 10 Apr 2025 17:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744306742; cv=none; b=flxG4o8u/UApVj9WJdUgvlnrOwin6sHhy7w5BuuvuJTwaHspDb3UOrLBpdiqtH+G7mY99Hrj1WTw4C7MVJU1rHKFRYN00GsIkCZqlpy826Hsk0kCdPQPAPeXd9aTbvmrA6xeCzqiV//4BvLLjrtXM0g3py1uQThXp8N/9pPkJPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744306742; c=relaxed/simple;
	bh=XJONTETz63TVmebRo092Mmjn4mQo3D+J5zYFDvgBxy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4M2z7ZSyQgzfEmUUNb9VlfE0HK0tJ28Bumf9mEmvOB6BGAw5n0a4x7Tieqk9x++D1ihgtEZOoIvx/oysnmxrnfjZNxrbAUMOsq/9F4cPMfIK7fKEc+lNd1JNDRGLbYtX6aISzSfDbqZZPThSPyogQaqIvrXhi9uU18rb3VGETQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LDt7/ePO; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LDt7/ePO"
Date: Thu, 10 Apr 2025 10:38:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744306738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QfyxTMni5BP5SV6CRH9ZSsPLHp0ae+0utnSwwkwnNb4=;
	b=LDt7/ePOoEvVHqeF3YQCr3fzz5+8/MAM2x6Lp9fQ3J+IrDianiEFWgh50j2+FogFRss7wq
	tPcnmlcVDJGH5R7gHiRy0PD1pXByBUCIiYPc47fkmnUVY6HTpBLXdVVS2VB6fiSFW+DP0u
	/kUkVH9Sy///MAlSUr+bV6y9t3wrcM4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 1/6] KVM: arm64: Fix MDCR_EL2.HPMN reset value
Message-ID: <Z_gCLmb11eMYKFDv@linux.dev>
References: <20250409160106.6445-1-maz@kernel.org>
 <20250409160106.6445-2-maz@kernel.org>
 <Z_bWzRSgyom1_hvJ@linux.dev>
 <86ikncl20s.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikncl20s.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 10, 2025 at 11:54:59AM +0100, Marc Zyngier wrote:
> On Wed, 09 Apr 2025 21:21:33 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Wed, Apr 09, 2025 at 05:01:01PM +0100, Marc Zyngier wrote:
> > > The MDCR_EL2 documentation indicates that the HPMN field has
> > > the following behaviour:
> > > 
> > > "On a Warm reset, this field resets to the expression NUM_PMU_COUNTERS."
> > > 
> > > However, it appears we reset it to zero, which is not very useful.
> > > 
> > > Add a reset helper for MDCR_EL2, and handle the case where userspace
> > > changes the target PMU, which may force us to change HPMN again.
> > > 
> > > Reported-by: Joey Gouly <joey.gouly@arm.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 13 +++++++++++++
> > >  arch/arm64/kvm/sys_regs.c |  8 +++++++-
> > >  2 files changed, 20 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index a1bc10d7116a5..4dc4f3a473c3f 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -1033,6 +1033,19 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
> > >  
> > >  	kvm->arch.arm_pmu = arm_pmu;
> > >  	kvm->arch.pmcr_n = kvm_arm_pmu_get_max_counters(kvm);
> > 
> > nit: Can we rename pmcr_n to nr_pmu_counters? The current name is misleading.
> 
> Fair enough.
> 
> > > +
> > > +	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
> > > +	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
> > > +		struct kvm_vcpu *vcpu;
> > > +		unsigned long i;
> > > +
> > > +		kvm_for_each_vcpu(i, vcpu, kvm) {
> > > +			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
> > > +			val &= ~MDCR_EL2_HPMN;
> > > +			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.pmcr_n);
> > > +			__vcpu_sys_reg(vcpu, MDCR_EL2) = val;
> > > +		}
> > 
> > Shouldn't we be taking the vCPU mutex(es) here?
> 
> If we needed to, it shouldn't be here. We hold the config_lock at this
> point, and taking a vcpu mutex would result in a locking inversion.
> 
> One option is to punt this to a request, but that makes the updated
> HPMN un-observable from userspace until the vcpu has run. This already
> affects the default PMU, btw, since it is only assigned on first run.

Ah, right. Default PMU is set at KVM_ARM_VCPU_INIT, so any race that
comes afterwards would be the fault of userspace.

Fine with it as is then.

Thanks,
Oliver
