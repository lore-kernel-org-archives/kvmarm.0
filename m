Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F593803D7;
	Mon,  1 Jun 2026 20:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780344830; cv=none; b=VKmbmu0gSqmbmMGLxPkS6maPZoadpSIfqJRef+nZl+MxWwJskXvnbBpaUNRIPOACjWj1dN3iGlWyqVRM3mUXeitoGoRiQHg9Sc3hFxCkBTIyFgsZbJIZp3MbM0NT3s40m1X886LiAvAsrtg7eG20i+pJxlwD6P2RZw/qlUecH1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780344830; c=relaxed/simple;
	bh=iOTMRaougFSruAPV90c8wVMzXHwHA150i469InjbQCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhmhiEIf8qFhklD4Qs0qr6AKCNPNUks0p52A4dv/2j/u+F+idFPJ8HZLZXhFSM0Fkh2e7B+zOAirEYTuScHPnGvSmXd8fQTA/Zi+qsaTL/qKttDi+zwBcMX9Q3tKkmxOUUyJBKOdNLxk9b1JydaOfu8VTsXlLzfzKl1WqWNTM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSnz8epZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSnz8epZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC6F1F00893;
	Mon,  1 Jun 2026 20:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780344829;
	bh=SyLftI4v2ZI5SSSxd2cSNuFFkA2m7fCbLhxHXaTG4Tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OSnz8epZDByl1PEdgIXPsni+fIDLWZZ3EXOByVsu7NjxrmubwnAs4exoAWc6BugNE
	 RTibzD/HHbWeXvuBDpUYyAAewmY4ib03gSpP0cgNopFmQPOMwtiUyjiyJYyEKS7lv2
	 BGylUCP4lG/tFkvflBeTnY3JL4J2PTftk8lc/jYMWX3JN0rjBqAk1MXQKcmiImbFHf
	 ZnFQEBsdzcXRfao/BhKwbVvj7nFDL3FbOYmtfFJRDdcci8DoJKr8INz1TJHCUwiRyY
	 unkQ11EBkoIUkZyQ7wCVb9l3sxn+ky4ApyTHzQlXiDjN9x/1ov0BNWyc9gAtTvJ7Y6
	 puaSJyDs0OHyg==
Date: Mon, 1 Jun 2026 13:13:47 -0700
From: Oliver Upton <oupton@kernel.org>
To: Congkai Tan <congkai@amazon.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Haris Okanovic <harisokn@amazon.com>,
	Geoff Blake <blakgeof@amazon.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Message-ID: <ah3n-7is_6DpmfEj@kernel.org>
References: <20260601193954.2103455-1-congkai@amazon.com>
 <ah3mObchzwb80_3S@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah3mObchzwb80_3S@kernel.org>

On Mon, Jun 01, 2026 at 01:06:17PM -0700, Oliver Upton wrote:
> Hi Congkai,
> 
> On Mon, Jun 01, 2026 at 07:39:54PM +0000, Congkai Tan wrote:
> > Commit 46081078feb4 ("KVM: arm64: Upgrade PMU support to ARMv8.4")
> > trapped PMMIR_EL1 as RAZ/WI and masked STALL_SLOT* from PMCEID1 to
> > discourage guests from relying on a register they could not read.
> > 
> > Forward the SLOTS field of PMMIR_EL1 so that the perf userspace tool
> > can read the correct value from
> > /sys/bus/event_source/devices/armv8_pmuv3_0/caps/slots. Today, perf
> > stat fails with message "Failure to read '#slots'" because it can
> > only read 0x0 from the sysfs location, causing the parsing failure
> > of the default metrics.
> > 
> > Fix this by:
> > 1. Adding an access_pmmir() handler that reads arm_pmu->reg_pmmir
> >    and returns a masked value containing only the SLOTS field [7:0]
> >    to the guest. Other PMMIR_EL1 fields are kept as RAZ to limit
> >    the extra information that this change exposes; individual
> >    fields can be unmasked as KVM gains support for each feature.
> > 2. Removing the STALL_SLOT, STALL_SLOT_FRONTEND and STALL_SLOT_BACKEND
> >    mask in PMCEID1. The mask existed to hide these events under the
> >    sysfs events/ directory when PMMIR_EL1 was RAZ; with SLOTS now
> >    readable they should be correctly exposed.
> > 
> > Tested on Graviton 2 (Neoverse N1, pre-PMUv3p4), Graviton 3
> > (Neoverse V1) and Graviton 4 (Neoverse V2) metal hosts with QEMU:
> > caps/slots reads 0x00000008 in guests on Graviton 3/4 and 0x00000000
> > on Graviton 2 (correct for pre-PMUv3p4). perf stat correctly
> > evaluates the default metrics.
> > 
> > Fixes: 46081078feb4 ("KVM: arm64: Upgrade PMU support to ARMv8.4")
> > Cc: stable@vger.kernel.org
> 
> This is not stable-worthy, nor is it a bugfix. As KVM presently does not
> implement the STALL_SLOTS* events, PMMIR_EL0.SLOTS = 0 is a legal
> implementation of FEAT_PMUv3p4.
> 
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 11 +----------
> >  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
> >  2 files changed, 25 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index e1860acae641..bafd5a258927 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -864,16 +864,7 @@ static u64 compute_pmceid0(struct arm_pmu *pmu)
> >  
> >  static u64 compute_pmceid1(struct arm_pmu *pmu)
> >  {
> > -	u64 val = __compute_pmceid(pmu, 1);
> > -
> > -	/*
> > -	 * Don't advertise STALL_SLOT*, as PMMIR_EL0 is handled
> > -	 * as RAZ
> > -	 */
> > -	val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
> > -		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
> > -		 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
> > -	return val;
> > +	return __compute_pmceid(pmu, 1);
> >  }
> 
> Make the change to PMCEID1 in a separate patch from PMMIR_EL1.
> 
> > +/*
> > + * Expose only PMMIR_EL1.SLOTS to the guest, which is consumed by perf in its
> > + * topdown default metric group. Other PMMIR_EL1 fields remain RAZ. Future
> > + * patches can extend the exposed mask incrementally as KVM gains support for
> > + * those features.
> > + */
> > +static bool access_pmmir(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> > +			 const struct sys_reg_desc *r)
> > +{
> > +	struct arm_pmu *cpu_pmu = vcpu->kvm->arch.arm_pmu;
> > +
> > +	if (p->is_write)
> > +		return write_to_read_only(vcpu, p, r);
> > +
> > +	if (check_pmu_access_disabled(vcpu, 0))
> > +		return false;

Also, we don't need this check. PMMIR_EL1 is UNDEF at EL0 so we should
never take a trap from userspace. Same goes for access_pminten() which
is where this probably came from.

> > +	p->regval = cpu_pmu->reg_pmmir & ARMV8_PMU_SLOTS;
> > +	return true;
> > +}
> > +
> 
> We can't change the value of PMMIR_EL1 unconditionally since older KVM
> treated this register as RAZ/WI. This also mixes poorly with the default
> PMU garbage that we have since as the value of the register can change
> based on where KVM_ARM_VCPU_INIT gets called...
> 
> Considering everything, I'd like to see this wired up where:
> 
>  - PMMIR_EL1.SLOTS takes the value of the underlying hardware PMU only
>    if the VMM explicitly selects a particular PMU implementation
> 
>  - KVM allows userspace to set PMMIR_EL1.SLOTS=0 for backwards
>    compatibility
> 
> Thanks,
> Oliver
>

Thanks,
Oliver
