From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 16/37] KVM: arm64: Remove noop calls to timer
 save/restore from VHE switch
Date: Sun, 3 Dec 2017 20:27:18 +0100
Message-ID: <20171203192718.GD4218@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-17-christoffer.dall@linaro.org>
 <20171107162528.q3rdlih5fpn7fnhd@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107162528.q3rdlih5fpn7fnhd@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 05:25:28PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:20PM +0200, Christoffer Dall wrote:
> > The VHE switch function calls __timer_enable_traps and
> > __timer_disable_traps which don't do anything on VHE systems.
> > Therefore, simply remove these calls from the VHE switch function and
> > make the functions non-conditional as they are now only called from the
> > non-VHE switch path.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/switch.c |  2 --
> >  virt/kvm/arm/hyp/timer-sr.c | 10 ++--------
> >  2 files changed, 2 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index 2cedf12..b98b73b 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -336,7 +336,6 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  	__activate_vm(vcpu);
> >  
> >  	__vgic_restore_state(vcpu);
> > -	__timer_enable_traps(vcpu);
> >  
> >  	/*
> >  	 * We must restore the 32-bit state before the sysregs, thanks
> > @@ -356,7 +355,6 @@ int kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  
> >  	__sysreg_save_guest_state(guest_ctxt);
> >  	__sysreg32_save_state(vcpu);
> > -	__timer_disable_traps(vcpu);
> >  	__vgic_save_state(vcpu);
> >  
> >  	__deactivate_traps(vcpu);
> > diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
> > index f398616..82c217e 100644
> > --- a/virt/kvm/arm/hyp/timer-sr.c
> > +++ b/virt/kvm/arm/hyp/timer-sr.c
> > @@ -53,16 +53,10 @@ void __hyp_text disable_el1_phys_timer_access(void)
> >  
> >  void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
> >  {
> > -	/*
> > -	 * We don't need to do this for VHE since the host kernel runs in EL2
> > -	 * with HCR_EL2.TGE ==1, which makes those bits have no impact.
> > -	 */
> 
> I was about to suggest that we should move this comment, instead of remove
> it, but it seems misleading anyway. We do call
> enable/disable_el1_phys_timer_access on VHE, but at VCPU load/put time
> instead of VM enter/exit time. So I guess removing it is best.
> 

That was actually a bug in the timer series, which has now been fixed.
In any case, I don't think the comment is necessary as it's already
explained in kvm_timer_init_vhe() in arch_timer.c.

> > -	if (!has_vhe())
> > -		enable_el1_phys_timer_access();
> > +	enable_el1_phys_timer_access();
> >  }
> >  
> >  void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
> >  {
> > -	if (!has_vhe())
> > -		disable_el1_phys_timer_access();
> > +	disable_el1_phys_timer_access();
> >  }
> > -- 
> > 2.9.0
> > 
> 
> Should we just call enable/disable_el1_phys_timer_access directly from
> __kvm_vcpu_run for non-VHE and drop this extra function level?
> 
I don't think there's a problem with this indirection and we could
imagine having more traps in the future.

Thanks,
-Christoffer
