Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2503E43E48D;
	Fri,  4 Sep 2026 10:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517615; cv=none; b=bggJePoX5PqrnJi50wG6YCG3+2P/oLtroKxq9YOc9UAwmeRgJAaE04fdUAg391QnCdIhgFBcpSiXFmp04WU0TpnX1a/5l9nKJWSLro82bszZsdrAj7lRMmhzrIeMhCvGdU6M22z3A7Pijj0VvYrEkERBWUFkv+dkUL7fZe1tE14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517615; c=relaxed/simple;
	bh=bsq/X1tPzJw5gycBNx/2c4qs3itZggqCT5+NO3V1Ca8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2edyhIdurIFTOWMAK7NTvxfcfxUsdJqIg5WR4aYgg0NSE1eJ03Po/Q4PCMBhFklB3RiwDTAykD7SDZ5TGKuhTekl45Ql6kItZ0tynEsQmGuAsNorcVlFlQUzT0J5fzdYk/GikDHI0+zFRcOwWaFVe4ig2DfdxSbj04jI3bVPgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VH4X8c1z; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VH4X8c1z"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6C1B153B;
	Fri,  4 Sep 2026 03:26:49 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.1.34.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1412A3F673;
	Fri,  4 Sep 2026 03:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788517613; bh=bsq/X1tPzJw5gycBNx/2c4qs3itZggqCT5+NO3V1Ca8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VH4X8c1zVWQTONFWQEJ4tvh89tnDfWB9YlyWFTBFHaufTO/8AIjIWsXw7Kw6PvgyV
	 9SBuIy5PtpVqWlVBTyHeWUwajamTqeRIHrr/Z6pnvLLleJiq5d27eRVVDclzlgweFo
	 6xnjmU+29Mndy/wcAYXqxRcAEZkt8iycPhaDxI2w=
Date: Fri, 4 Sep 2026 11:26:49 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v7 15/28] KVM: arm64: Use PMSVer from the assigned
 SPE instance
Message-ID: <apqc6SJHgjymMdCc@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-16-alexandru.elisei@arm.com>
 <20260903164127.497DB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903164127.497DB1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:41:26PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] kvm_spe_finalize_idregs() unconditionally overwrites the user-provided ID_AA64DFR0_EL1.PMSVer with the host's physical version on the first KVM_RUN, breaking live migration.
> - [High] sanitise_id_aa64dfr0_el1() evaluates PMSVer dynamically based on the assigned SPE PMU, returning 0 if called before the PMU is assigned, which breaks KVM_SET_ONE_REG validation.
> - [High] kvm_spe_finalize_idregs() is skipped if a vCPU without SPE runs first in a heterogeneous VM, permanently leaving PMSVer as 0 and hiding SPE from the guest.
> --
> 
> commit 45e0320e2eaeb926a33b978420aa5a133c7a42c6
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Use PMSVer from the assigned SPE instance
> 
> This commit updates KVM to initialize the VM's ID_AA64DFR0_EL1.PMSVer using
> the SPE PMU instance assigned to the VM rather than the physical CPU executing
> the vCPU init ioctl. This is intended to handle heterogeneous systems where
> SPE instances may have different versions or be entirely absent on some CPUs.
> 
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > index fa87d224c8af8..4426d614a9e0b 100644
> > --- a/arch/arm64/kvm/spe.c
> > +++ b/arch/arm64/kvm/spe.c
> [ ... ]
> > @@ -87,6 +87,30 @@ bool kvm_spe_pmu_set(struct kvm *kvm)
> >  	return !!kvm->arch.kvm_spe.spe_pmu;
> >  }
> >  
> > +void kvm_spe_finalize_idregs(struct kvm *kvm)
> > +{
> > +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> > +	u64 reg;
> > +
> > +	if (!spe_pmu)
> > +		return;
> > +
> > +	reg = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
> > +	reg &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
> > +	reg |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer, spe_pmu->pmsver);
> > +	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, reg);
> > +}
> 
> [Severity: High]
> Does this unconditionally overwrite the user-provided ID_AA64DFR0_EL1.PMSVer
> value on the first KVM_RUN?

It doesn't look to me like ID_AA64DFR0_EL1.PMSVer is user writable:

static const struct sys_reg_desc sys_reg_descs[] = {
[..]
       ID_FILTERED(ID_AA64DFR0_EL1, id_aa64dfr0_el1,
                    ID_AA64DFR0_EL1_DoubleLock_MASK |
                    ID_AA64DFR0_EL1_WRPs_MASK |
                    ID_AA64DFR0_EL1_PMUVer_MASK |
                    ID_AA64DFR0_EL1_DebugVer_MASK),

unless I'm badly misunderstanding what the masks in the ID_FILTERED() macro do.

> 
> If a VMM restores ID_AA64DFR0_EL1 during live migration (for example, when
> migrating from an older host to a newer one), kvm_spe_finalize_idregs() will
> silently clobber the userspace-configured value and force it back to the host
> hardware's version. Could this violate the KVM ABI and break live migration
> sequences?
> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 44aae52c473d7..a6bb6884b965a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2220,8 +2220,11 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> >  		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMUVer,
> >  				      kvm_arm_pmu_get_pmuver_limit());
> >  
> > -	/* Hide SPE from guests */
> >  	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
> > +	if (vcpu_has_spe(vcpu))
> > +		val |= SYS_FIELD_PREP(ID_AA64DFR0_EL1, PMSVer,
> > +				      kvm_spe_get_pmsver(vcpu->kvm));
> 
> [Severity: High]
> Can this dynamic evaluation break KVM_SET_ONE_REG validation during VM setup?

What is "KVM_SET_ONE_REG validation"?

> 
> VMMs like QEMU typically restore VM ID registers via KVM_SET_ONE_REG
> immediately after KVM_ARM_VCPU_INIT, before configuring device attributes.
> Because sanitise_id_aa64dfr0_el1() evaluates PMSVer based on the assigned SPE
> PMU, kvm_spe_get_pmsver() returns 0 until the SPE PMU is assigned.
> 
> This strict ordering dependency will cause KVM_SET_ONE_REG to reject valid,
> non-zero userspace values with -EINVAL, which breaks standard live migration
> sequences.

I don't think ID_AA64DFR0_EL1.PMSVer is user-writable.

> 
> [ ... ]
> > @@ -5928,6 +5931,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
> >  		kvm_vgic_finalize_idregs(kvm);
> >  	}
> >  
> > +	if (vcpu_has_spe(vcpu))
> > +		kvm_spe_finalize_idregs(kvm);
> > +
> >  	return 0;
> >  }
> 
> [Severity: High]
> Can this leave PMSVer permanently set to 0 in a heterogeneous VM if a vCPU
> without SPE runs first?

Indeed. My understanding from how the PMU VCPU feature is handled is that even
though KVM doesn't forbid running a VCPU without a PMU when other VCPUs do have
one, this kind of setup is not supported in KVM. This is what I was trying to
implement here.

Should I tighten the check and explicitly forbid running a VCPU without a SPE
PMU?

Thanks,
Alex

> 
> kvm_finalize_sys_regs() executes on the first KVM_RUN for a given VM. It uses
> a per-vCPU feature check (vcpu_has_spe(vcpu)) to guard the VM-wide ID register
> initialization in kvm_spe_finalize_idregs(kvm).
> 
> If the first scheduled vCPU happens to lack SPE, vcpu_has_spe(vcpu) evaluates
> to false and kvm_spe_finalize_idregs(kvm) is skipped. The VM is then marked
> with KVM_ARCH_FLAG_HAS_RAN_ONCE, meaning SPE initialization is skipped forever.
> This would permanently hide SPE from all vCPUs in the VM.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=15
