From: Christoffer Dall <cdall@kernel.org>
Subject: Re: [PATCH 26/37] KVM: arm64: Prepare to handle traps on deferred
 AArch32 sysregs
Date: Sun, 3 Dec 2017 21:35:12 +0100
Message-ID: <20171203203512.GB32397@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-27-christoffer.dall@linaro.org>
 <20171113190701.7vgkady36c6keshh@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171113190701.7vgkady36c6keshh@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 13, 2017 at 08:07:01PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:30PM +0200, Christoffer Dall wrote:
> > Handle accesses to any AArch32 EL1 system registers where we can defer
> > saving and restoring them to vcpu_load and vcpu_put, and which are
> > stored in special EL2 registers only used support 32-bit guests.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/inject_fault.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > index f4513fc..02990f5 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -59,9 +59,18 @@ static void vcpu_set_elr_el1(struct kvm_vcpu *vcpu, u64 val)
> >  /* Set the SPSR for the current mode */
> >  static void vcpu_set_spsr(struct kvm_vcpu *vcpu, u64 val)
> >  {
> > -	if (vcpu_mode_is_32bit(vcpu))
> > +	if (vcpu_mode_is_32bit(vcpu)) {
> > +		if (vcpu->arch.sysregs_loaded_on_cpu)
> > +			__sysreg32_save_state(vcpu);
> > +
> >  		*vcpu_spsr32(vcpu) = val;
> >  
> > +		if (vcpu->arch.sysregs_loaded_on_cpu)
> > +			__sysreg32_restore_state(vcpu);
> > +
> > +		return;
> 
> Is this a fix? I don't understand why it's necessary now, but it wasn't
> before.
> 

All of these patches are not necessary before "KVM: arm64: Defer
saving/restoring system registers to vcpu load/put on VHE", but I needed
to find a way to split the patches into some smaller pieces, both for
debugging/bisecting and for easing the review.

> > +	}
> > +
> >  	if (vcpu->arch.sysregs_loaded_on_cpu)
> >  		write_sysreg_el1(val, spsr);
> >  	else
> > @@ -129,11 +138,13 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
> >  	 *   IFAR:  mapped to FAR_EL1
> >  	 *   DFSR:  mapped to ESR_EL1
> >  	 *   TTBCR: mapped to TCR_EL1
> > +	 *   IFSR:  stored in IFSR32_EL2
> >  	 */
> >  	if (vcpu->arch.sysregs_loaded_on_cpu) {
> >  		vcpu->arch.ctxt.sys_regs[FAR_EL1] = read_sysreg_el1(far);
> >  		vcpu->arch.ctxt.sys_regs[ESR_EL1] = read_sysreg_el1(esr);
> >  		vcpu->arch.ctxt.sys_regs[TCR_EL1] = read_sysreg_el1(tcr);
> > +		vcpu->arch.ctxt.sys_regs[IFSR32_EL2] = read_sysreg(ifsr32_el2);
> >  	}
> >  
> >  	if (is_pabt) {
> > @@ -161,6 +172,7 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
> >  	if (vcpu->arch.sysregs_loaded_on_cpu) {
> >  		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[FAR_EL1], far);
> >  		write_sysreg_el1(vcpu->arch.ctxt.sys_regs[ESR_EL1], esr);
> > +		write_sysreg(vcpu->arch.ctxt.sys_regs[IFSR32_EL2], ifsr32_el2);
> 
> This appears to be a fix. Why not squash it into the patch that
> save/restore the other registers?
> 

It's just more work we can do before we start being lazy.

I thought it would be easier to review in pieces, and I thought the
sequence of patches begining with "Prepare..." was a commonly used
theme, bt apparently not.

In any cae, this hunk has now gone away due to the shared logic of
32-bit fault injection, so it should be more obvious next time around.

Thanks,
-Christoffer
