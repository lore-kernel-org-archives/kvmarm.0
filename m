Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9807119DF75
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 14:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729607499; cv=none; b=RYiwcKMvgVrA8yGnmE6vHB7j0jTK8UEQEEh7As/zwA29NP4i4lOjxaA02zwqi22idxnlhpalcu/lgBQHOUTl7BkJn4TxKER5bRDlrAQSZ0Ye+0mbL3cztFDExtlyxA0HqowUeKLPcxvNdM+b3MwX374S3H3ivtA0UwLogNLubAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729607499; c=relaxed/simple;
	bh=YIICbxSBUMBCyGXE2B5ZsX3IzNE/AzP2NdmkDfeRS80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcK7swTY1o28r8OhD0IkGQEIIkTfSO+tU1Bpa/D7TuaiQkXBpuq3fPWkbj0OmYP0j7zy/eiF5KQ0jLukKHGLjO/p8I5VLuRPmoBQD1K/WZvLFhiRzUPJ6ZZROnt3B/woDfyM3nuHYG2YjcEkxtPtu+nXCL1PcOsfe7TZCeHJqfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C69F497;
	Tue, 22 Oct 2024 07:32:06 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F0443F71E;
	Tue, 22 Oct 2024 07:31:34 -0700 (PDT)
Date: Tue, 22 Oct 2024 15:31:28 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, james.morse@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/7] KVM: arm64: Fix missing traps of guest accesses
 to the MPAM registers
Message-ID: <20241022143128.GA1050981@e124191.cambridge.arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
 <ZxBV6c4Z_GlyDoBr@linux.dev>
 <20241017105849.GA122054@e124191.cambridge.arm.com>
 <ZxE2NUNKSWuzVow2@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxE2NUNKSWuzVow2@linux.dev>

On Thu, Oct 17, 2024 at 09:07:17AM -0700, Oliver Upton wrote:
> On Thu, Oct 17, 2024 at 11:58:49AM +0100, Joey Gouly wrote:
> > On Wed, Oct 16, 2024 at 05:10:17PM -0700, Oliver Upton wrote:
> > > Hi Joey,
> > > 
> > > On Tue, Oct 15, 2024 at 02:39:20PM +0100, Joey Gouly wrote:
> > > > +static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> > > > +
> > > > +	if (!cpus_support_mpam())
> > > > +		return;
> > > > +
> > > > +	/* trap guest access to MPAMIDR_EL1 */
> > > > +	if (mpam_cpus_have_mpam_hcr()) {
> > > > +		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
> > > > +	} else {
> > > > +		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> > > > +		r |= MPAM2_EL2_TIDR;
> > > > +	}
> > > > +
> > > > +	write_sysreg_s(r, SYS_MPAM2_EL2);
> > > > +}
> > > > +
> > > > +static inline void __deactivate_traps_mpam(void)
> > > > +{
> > > > +	if (!cpus_support_mpam())
> > > > +		return;
> > > > +
> > > > +	write_sysreg_s(0, SYS_MPAM2_EL2);
> > > > +
> > > > +	if (mpam_cpus_have_mpam_hcr())
> > > > +		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
> > > > +}
> > > 
> > > TBH, I think our trap configuration should *not* be conditioned on
> > > CONFIG_ARM64_MPAM. Otherwise we're silently allowing the guest to change
> > > things under the nose of KVM/host kernel, assuming an unkind firmware
> > > that left the EL2 trap configuration in a permissive state.
> > > 
> > > WDYT about detecting the feature && enforcing traps regardless of the Kconfig?
> > 
> > I had actually thought about the same thing. I spoke with James and he agrees,
> > so I will look into removing that.
> > 
> > I will probably end up removing the Kconfig entirely, it can be added back in
> > later, when actual support for MPAM is added.
> 
> Sounds good, thanks Joey!
> 
> If we go down this route, I'm guessing we can also skip the boot
> time EL2 setup portion of it (for now). That'd constrain the fossilized
> EL3 issue to *just* failures to run KVM VMs as opposed to kernels not
> booting at all.
> 

If you run nVHE with a firmware that enabled the traps for some reason (or just
by default since TRAP_MPAMIDR_EL1 resets to UNKNOWN), you will hang at boot
without that change.  The cpufeature code that runs at EL1 in that case, reads
MPAMIDR_EL1 to check for HAS_HCR.

Thanks,
Joey
