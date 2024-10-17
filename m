Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1DA1D517A
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 10:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729162739; cv=none; b=MFuPtrbVRNUKYCfnOzT8XkWQf03wdL4XFqGGCOko+arX9CqdO0pWWEoYQr0wybEsyjDsgWX4WV01cOe/WD60ZjHNd1qBwlbfMHXmvMaGxaFbh9yBrfsc20ePCE+kNxtwXAu4qckQcVZJCYFEzT7+P+EdmUlA9DSnUq37ox2I+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729162739; c=relaxed/simple;
	bh=K7k0XI6rwQ/GVZ/Jm7ekmwlXhPQS6XYdRHi6pMMyWDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6EckLuj1hEKT2HKyVdxbRIwfUhAH2QwuDQGtmXPJuubCnp1RLtivL4S9fL7ndVN6yqtrcjYGrwtLWLXVF+T3ChlfIIQwBWX7GoYKyHucnM5tzK2qhJTBYr3/PRXy39hF29y0ds0ESLdgu9naKTSCeEvphK0dF+DsKNSp73z02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74A37FEC;
	Thu, 17 Oct 2024 03:59:26 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF21B3F528;
	Thu, 17 Oct 2024 03:58:54 -0700 (PDT)
Date: Thu, 17 Oct 2024 11:58:49 +0100
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
Message-ID: <20241017105849.GA122054@e124191.cambridge.arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
 <ZxBV6c4Z_GlyDoBr@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxBV6c4Z_GlyDoBr@linux.dev>

On Wed, Oct 16, 2024 at 05:10:17PM -0700, Oliver Upton wrote:
> Hi Joey,
> 
> On Tue, Oct 15, 2024 at 02:39:20PM +0100, Joey Gouly wrote:
> > +static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
> > +{
> > +	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
> > +
> > +	if (!cpus_support_mpam())
> > +		return;
> > +
> > +	/* trap guest access to MPAMIDR_EL1 */
> > +	if (mpam_cpus_have_mpam_hcr()) {
> > +		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
> > +	} else {
> > +		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
> > +		r |= MPAM2_EL2_TIDR;
> > +	}
> > +
> > +	write_sysreg_s(r, SYS_MPAM2_EL2);
> > +}
> > +
> > +static inline void __deactivate_traps_mpam(void)
> > +{
> > +	if (!cpus_support_mpam())
> > +		return;
> > +
> > +	write_sysreg_s(0, SYS_MPAM2_EL2);
> > +
> > +	if (mpam_cpus_have_mpam_hcr())
> > +		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
> > +}
> 
> TBH, I think our trap configuration should *not* be conditioned on
> CONFIG_ARM64_MPAM. Otherwise we're silently allowing the guest to change
> things under the nose of KVM/host kernel, assuming an unkind firmware
> that left the EL2 trap configuration in a permissive state.
> 
> WDYT about detecting the feature && enforcing traps regardless of the Kconfig?

I had actually thought about the same thing. I spoke with James and he agrees,
so I will look into removing that.

I will probably end up removing the Kconfig entirely, it can be added back in
later, when actual support for MPAM is added.

Thanks,
Joey

> 
> -- 
> Thanks,
> Oliver
