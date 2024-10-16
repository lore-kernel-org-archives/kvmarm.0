Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A348017A92F
	for <kvmarm@lists.linux.dev>; Wed, 16 Oct 2024 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729084761; cv=none; b=bO9aSikbBGm7gjK4gqAZKe/MgW2l097PJcNxp3GHG5yk2t2j2PXmHqx2riBrjhHOJnVpoUpBSPejq7VvFpEPMiZo9uMypD4WyefxH7Xhl2n4CNUItEWwwpVrIuIBqvR6KqT/w7nNz8TamIhg8KRFQITiDE6DQAEqAkxYMyDTy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729084761; c=relaxed/simple;
	bh=eQ3XQ5xCOVKHVO6j6DURkih8E8ejH6kHPbFeXY+gs6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+YbJDfJrZjdNa4QydxbBJ6QKuVQhX3kLWZiiqUzzjngb+vWMfnmqdr6qwEQ/SFW/Ebv1j0gyyuJO49b+IQkeYE4UVbz8fDig76YnWJ3sfRyd0EBmJRHK+x7JQBhxGjp/ej3973GzEXTzYKfByAk1METrmV85Tk8ve1S6Ovmwn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD363FEC;
	Wed, 16 Oct 2024 06:19:48 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62A063F528;
	Wed, 16 Oct 2024 06:19:17 -0700 (PDT)
Date: Wed, 16 Oct 2024 14:19:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 06/36] KVM: arm64: nv: Handle CNTHCTL_EL2 specially
Message-ID: <Zw-9UvkO6eJkAaYQ@raptor>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-7-maz@kernel.org>
 <Zw-JTojEW5ZXa8R-@raptor>
 <861q0g5ls1.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861q0g5ls1.wl-maz@kernel.org>

Hi,

On Wed, Oct 16, 2024 at 12:29:02PM +0100, Marc Zyngier wrote:
> On Wed, 16 Oct 2024 10:37:18 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > I'm planning to have a look at (some) of the patches, do you have a
> > timeline for merging the series? Just so I know what to prioritise.
> 
> I want it merged yesterday. All of it.
> 
> > 
> > On Wed, Oct 09, 2024 at 07:59:49PM +0100, Marc Zyngier wrote:
> > > Accessing CNTHCTL_EL2 is fraught with danger if running with
> > > HCR_EL2.E2H=1: half of the bits are held in CNTKCTL_EL1, and
> > > thus can be changed behind our back, while the rest lives
> > > in the CNTHCTL_EL2 shadow copy that is memory-based.
> > > 
> > > Yes, this is a lot of fun!
> > > 
> > > Make sure that we merge the two on read access, while we can
> > > write to CNTKCTL_EL1 in a more straightforward manner.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/sys_regs.c    | 28 ++++++++++++++++++++++++++++
> > >  include/kvm/arm_arch_timer.h |  3 +++
> > >  2 files changed, 31 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 3cd54656a8e2f..932d2fb7a52a0 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -157,6 +157,21 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
> > >  		if (!is_hyp_ctxt(vcpu))
> > >  			goto memory_read;
> > >  
> > > +		/*
> > > +		 * CNTHCTL_EL2 requires some special treatment to
> > > +		 * account for the bits that can be set via CNTKCTL_EL1.
> > > +		 */
> > > +		switch (reg) {
> > > +		case CNTHCTL_EL2:
> > > +			if (vcpu_el2_e2h_is_set(vcpu)) {
> > > +				val = read_sysreg_el1(SYS_CNTKCTL);
> > > +				val &= CNTKCTL_VALID_BITS;
> > > +				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
> > > +				return val;
> > > +			}
> > > +			break;
> > > +		}
> > > +
> > >  		/*
> > >  		 * If this register does not have an EL1 counterpart,
> > >  		 * then read the stored EL2 version.
> > > @@ -207,6 +222,19 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
> > >  		 */
> > >  		__vcpu_sys_reg(vcpu, reg) = val;
> > >  
> > > +		switch (reg) {
> > > +		case CNTHCTL_EL2:
> > > +			/*
> > > +			 * If E2H=0, CNHTCTL_EL2 is a pure shadow register.
> > > +			 * Otherwise, some of the bits are backed by
> > > +			 * CNTKCTL_EL1, while the rest is kept in memory.
> > > +			 * Yes, this is fun stuff.
> > > +			 */
> > > +			if (vcpu_el2_e2h_is_set(vcpu))
> > > +				write_sysreg_el1(val, SYS_CNTKCTL);
> > 
> > Sorry, but I just can't seem to get my head around why the RES0 bits aren't
> > cleared. Is KVM relying on the guest to implement Should-Be-Zero-or-Preserved,
> > as per the RES0 definition?
> 
> KVM isn't relying on anything. And it isn't about the RES0 bits not
> being cleared. It is about the HW not providing storage for some of
> the CNTHCTL_EL2 bits when the guest is using CNTKCTL_EL1 as a proxy
> for its own view of CNTHCTL_EL2.
> 
> Namely, bits outside of CNTKCTL_VALID_BITS are not guaranteed to be
> stored until (IIRC) FEAT_NV2p1, which retrospectively fixes the
> architecture by mandating that the relevant bits have dedicated
> storage.

The definition for RES0 says:

'A bit that is RES0 in a context is reserved for possible future use in that
context. To preserve forward compatibility, software:
 * Must not rely on the bit reading as 0.
 * Must use an SBZP policy to write to the bit.'

where Should-Be-Zero-of-Preserved (SBZP):

'When writing this field, software must either write all 0s to this field or, if
the register is being restored from a previously read state, write the
previously read value to this field. If this is not done, then the result is
unpredictable.'

And what about the rest of the RES0 bits from CNTKCTL_EL1, those that are RES0
in both registers?

Thanks,
Alex
