Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02B31DB92E
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170409; cv=none; b=g+V3XxZ9+7YXzMSzi/Hh14N4Nyx1SDrYpCGa7aKXLLWFfxyDmPP5BRfqQtUu5MVcA8AH4hqLNo/bdbmNixbNeO3eYszFt2/7AlMcJFEYPNYFsAjazAgg6ffW1omIAQxDRQrrx/Zw3DjhVvmbKyidTykKtxQKpwPBnv427G/FS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170409; c=relaxed/simple;
	bh=WGvpJXXd6P/CLJplZIeUBOfA4pHVb3dzvoPRm11eY7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHVbzEN48HKevwc3ef/hFYUafghY2DyJJr4/LiIiVLuQl1bmkPH7NzZgFUxORLeqwYriJDUc8Um3knmryCa1q8krdyG4N/DgF3VQ24i0tiA5tU+JNr7qvDbZ71dM/3Rx2JOMojtwoXBFZszpng6nL+EZJbglxBDb4K1/yg4h8jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9625CFEC;
	Thu, 17 Oct 2024 06:07:15 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E115C3F71E;
	Thu, 17 Oct 2024 06:06:43 -0700 (PDT)
Date: Thu, 17 Oct 2024 14:06:38 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	anshuman.khandual@arm.com, james.morse@arm.com,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/7] KVM: arm64: Fix missing traps of guest accesses
 to the MPAM registers
Message-ID: <20241017130638.GA139029@e124191.cambridge.arm.com>
References: <20241015133923.3910916-1-joey.gouly@arm.com>
 <20241015133923.3910916-5-joey.gouly@arm.com>
 <86msj33py6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86msj33py6.wl-maz@kernel.org>

Hi Marc,

Thanks for looking!

On Thu, Oct 17, 2024 at 12:54:09PM +0100, Marc Zyngier wrote:
> On Tue, 15 Oct 2024 14:39:20 +0100,
> Joey Gouly <joey.gouly@arm.com> wrote:
> > 
> > @@ -204,6 +205,35 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
> >  		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
> >  }
> >  
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
> 
> Please use the write_sysreg_el2() accessor, so that VHE under NV has
> an easier time, should we ever get there.

Are you suggesting this, to avoid a trap (and instead get the register-memory
redirection)?

The two reasons I could see to keep it as-is:
	- The name changes from MPAM2_EL2 to MPAM1_EL1 (1 and 2 suffixes after
	  MPAM)
	- It's setting trap behaviour, which is an EL2 concept (and are RES0
	  bits in the MPAM1_EL1 reg). Other trap registers such as HCRX_EL2 use
	  that register directly, however they don't have an _EL1 counterpart so have to.

I'm fine to change it, just want to clarify before I do.

Thanks,
Joey

> 
> > +}
> > +
> > +static inline void __deactivate_traps_mpam(void)
> > +{
> > +	if (!cpus_support_mpam())
> > +		return;
> > +
> > +	write_sysreg_s(0, SYS_MPAM2_EL2);
> 
> Same thing.
> 
> > +
> > +	if (mpam_cpus_have_mpam_hcr())
> > +		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
> > +}
> > +
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
