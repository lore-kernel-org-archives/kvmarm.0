Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D301A48BD56;
	Fri,  4 Sep 2026 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530692; cv=none; b=qrtM7xL6LhmF1pFkvjxAytF3JRZxwNWcJPTo24T5IjqmvVhexSkBoT1TQZwmq2+HIHjOK7NwMtvLbfvEGFIm8r/lYxgkR3vk53QD0P/lFqEdQ0X8eYFFuR+xPt3avsst6I7A65+p5E88GN+WFy/wgtcSzdYjvhZ/2Xd4iegLIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530692; c=relaxed/simple;
	bh=14fjPP4GCJW0tAtv0hp2brghx5+0DkHLSR9NffUtcRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jS2WhC0W8mxY/1FNVc5fcvI9PCoMWP9y9ad8kNyjKiQP4iVevJu7JO1Y52POadOX0XStsXKCbougJxOJBIjWEVVKB8grAiQgqUWWvsWQGkFPHdWHEC+ORMehg3XHXqJbHI/iHKX0aBoHA+bb2+gMO1AQmYoWr+g8be2wQCi6mps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iaboepro; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iaboepro"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 716CD152B;
	Fri,  4 Sep 2026 07:04:45 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.57.70.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCD283F673;
	Fri,  4 Sep 2026 07:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788530689; bh=14fjPP4GCJW0tAtv0hp2brghx5+0DkHLSR9NffUtcRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iaboeproZVBKWaHdzcQECzQvsoHpKIdUYifeGeBeTGcFuXQyQKtf3XUaTJrU0JjXo
	 m922SxCYA4XGzDJIusSOzO0gKVBS0i9E/CS/DVik3vkOoRxj3LSK6bneZ8IdaLnIy9
	 CoZPqXZ5e2y52KRhCIzqj8ibdYD3fZzMCJO9AzjE=
Date: Fri, 4 Sep 2026 15:04:43 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v7 21/28] KVM: arm64: Handle SPE maintenance
 interrupts
Message-ID: <aprP-yXKb06rlUeS@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-22-alexandru.elisei@arm.com>
 <20260903165824.158A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903165824.158A21F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:58:23PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Medium] SPE system registers are not cleared during VCPU reset, leaking stale state across warm resets.
> 
> Pre-existing issues:
> - [High] Hardware profiling buffer is enabled before `PMBSR_EL1` is restored, creating a race condition that clobbers hardware events.
> --
> 
> commit 0111e834cf6f2849f99044fcfd2c2f6ef3480c83
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Handle SPE maintenance interrupts
> 
> This commit introduces handling for SPE maintenance interrupts in KVM. It
> injects the interrupt when the guest sets the PMBSR_EL1.S bit and re-injects
> hardware-raised maintenance interrupts.
> 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 4c4bf88c9aa53..ebe1c933f8d55 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1595,6 +1595,11 @@ static int get_user_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc
> >  	return 0;
> >  }
> >  
> > +static u64 reset_spe_sysreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > +{
> > +	return kvm_spe_reset_sysreg(vcpu, r->reg);
> > +}
> > +
> 
> [Severity: Medium]
> Does this change leak stale SPE register state across warm resets?
> 
> Previously, SPE registers used reset_val as their reset callback, which
> actively updated the vCPU sysreg array via __vcpu_assign_sys_reg().

Most of them still do.

> 
> Here, the new reset_spe_sysreg() callback returns 0 but misses a call to
> __vcpu_assign_sys_reg() to clear the VCPU's system register memory.
> Because the KVM sysreg reset caller ignores the return value, the values in
> vcpu->arch.ctxt.sys_regs remain untouched.
> 
> If a VM goes through a warm reset (e.g., via PSCI CPU_OFF / CPU_ON) while
> profiling is active, the new OS environment inherits a stale profiling state.
> Should kvm_spe_reset_sysreg() explicitly clear the register state?

Yeah, somehow got confused by the fact that the ->reset callbacks both assign
the value and return the assigned value and I incorrectly chose to return the
value without assigning it first.

> 
> >  static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  			   const struct sys_reg_desc *r)
> >  {
> > @@ -1642,7 +1647,7 @@ static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  
> >  #define SPE_SYS_REG(name)						\
> >  	SYS_DESC(SYS_##name), .reg = name, .access = access_spe_reg,	\
> > -	.reset = reset_val, .val = 0, .visibility = spe_visibility,	\
> > +	.reset = reset_spe_sysreg, .visibility = spe_visibility,	\
> >  	.set_user = set_user_spe_sysreg, .get_user = get_user_spe_sysreg
> 
> [Severity: High]
> This is a pre-existing issue, but does __kvm_spe_restore_guest_state_vhe()
> clobber hardware events by enabling the profiling buffer before restoring
> PMBSR_EL1?
> 
> In arch/arm64/kvm/hyp/vhe/spe-sr.c:__kvm_spe_restore_guest_state_vhe():
> 
> 	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> 		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
> 		isb();
> 		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> 		isb();
> 		/* A buffer management event preserves fields in PMBSR_EL1 */
> 		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
> 	}
> 
> Because PMBLIMITR_EL1 is restored (with the E bit set) and an ISB executed
> before PMBSR_EL1 is restored, hardware can autonomously trigger a buffer
> management event right after the ISB if the buffer is near full.

I don't think so. Sampling at EL2 has been disabled when the host state was
saved, and the buffer was drained immediately after. All of this was executed in
__kvm_spe_save_host_state_vhe(). There are no records here to be written back to
memory.

> 
> KVM's subsequent software write of the guest's PMBSR_EL1 (which has S = 0)
> overwrites the hardware register, wiping the event and clearing the
> interrupt.
> 
> This violates the ARM Architecture Reference Manual D10.1.5, which forbids

Please also state the version of the architecture reference manual, because in
M.c, D10.1.5 does not exist, and chapter D10 is about MTE, not SPE.

> software from writing to PMBSR_EL1 while PMBLIMITR_EL1.E == 1.
> Should PMBSR_EL1 be restored before PMBLIMITR_EL1 to prevent this race
> condition?

I believe there was a discussion about something like that, but that was never
merged into the Arm ARM.

Thanks,
Alex

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=21
