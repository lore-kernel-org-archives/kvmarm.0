From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 10/37] KVM: arm64: Slightly improve debug save/restore
 functions
Date: Fri, 1 Dec 2017 18:51:51 +0100
Message-ID: <20171201175151.GC6615@lvm>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-11-christoffer.dall@linaro.org>
 <20171107142229.6aoijhbzgvkvnjt2@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107142229.6aoijhbzgvkvnjt2@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 03:22:29PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:14PM +0200, Christoffer Dall wrote:
> > The debug save/restore functions can be improved by using the has_vhe()
> > static key instead of the instruction alternative.  Using the static key
> > uses the same paradigm as we're going to use elsewhere, it makes the
> > code more readable, and it generates slightly better code (no
> > stack setups and function calls unless necessary).
> > 
> > We also use a static key on the restore path, because it will be
> > marginally faster than loading a value from memory.
> > 
> > Finally, we don't have to conditionally clear the debug dirty flag if
> > it's set, we can just clear it.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/debug-sr.c | 22 +++++++++-------------
> >  1 file changed, 9 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > index 0fc0758..a2291b6 100644
> > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > @@ -75,11 +75,6 @@
> >  
> >  #define psb_csync()		asm volatile("hint #17")
> >  
> > -static void __hyp_text __debug_save_spe_vhe(u64 *pmscr_el1)
> > -{
> > -	/* The vcpu can run. but it can't hide. */
> > -}
> > -
> >  static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
> >  {
> >  	u64 reg;
> > @@ -109,10 +104,6 @@ static void __hyp_text __debug_save_spe_nvhe(u64 *pmscr_el1)
> >  	dsb(nsh);
> >  }
> >  
> > -static hyp_alternate_select(__debug_save_spe,
> > -			    __debug_save_spe_nvhe, __debug_save_spe_vhe,
> > -			    ARM64_HAS_VIRT_HOST_EXTN);
> > -
> >  static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
> >  {
> >  	if (!pmscr_el1)
> > @@ -174,17 +165,22 @@ void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
> >  {
> >  	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
> >  			   kern_hyp_va(vcpu->arch.host_cpu_context));
> > -	__debug_save_spe()(&vcpu->arch.host_debug_state.pmscr_el1);
> > +
> > +	/* Non-VHE: Disable and flush SPE data generation
> > +	 * VHE: The vcpu can run. but it can't hide. */
> 
> Not the standard comment format.
> s/./,/
> 
> I'm glad you kept the funny comment :-)
> 
> 
> > +	if (!has_vhe())
> > +		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
> >  }
> >  
> >  void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
> >  {
> > -	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> > +	if (!has_vhe())
> > +		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
> > +
> >  	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
> >  			      kern_hyp_va(vcpu->arch.host_cpu_context));
> >  
> > -	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> > -		vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
> > +	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
> 
> Guess I should have read ahead before commenting on this in the last
> patch :-)
> 
> >  }
> >  
> >  u32 __hyp_text __kvm_get_mdcr_el2(void)
> > -- 
> > 2.9.0
> >
> 
> Do we still need to pass vcpu->arch.host_debug_state.pmscr_el1 as a
> parameter to __debug_save_spe_nvhe and __debug_restore_spe? Or can
> we just pass the vcpu 

We could change that, but that's unrelated to any optimization and I
believe the idea behind doing the code this way is that it can be reused
for another context later on if it should become relevant.

> and remove the "if (!pmscr_el1) return" in
> __debug_restore_spe? 

That would change the logic (hint: the debug function takes a value, not
a pointer), so I don't think so.

> Should __debug_restore_spe be renamed to have
> a _nvhe for consistency?
> 
Yes.

Thanks,
-Christoffer
