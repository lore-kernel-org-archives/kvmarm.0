From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 07/37] KVM: arm/arm64: Add kvm_vcpu_load_sysregs and
 kvm_vcpu_put_sysregs
Date: Thu, 23 Nov 2017 12:08:10 +0100
Message-ID: <20171123110810.qofr2akh4jhux7m3@kamzik.brq.redhat.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-8-christoffer.dall@linaro.org>
 <20171107111000.uwpiofgbchm3s5gn@kamzik.brq.redhat.com>
 <20171122203417.GV28855@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171122203417.GV28855@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 22, 2017 at 09:34:17PM +0100, Christoffer Dall wrote:
> On Tue, Nov 07, 2017 at 12:10:00PM +0100, Andrew Jones wrote:
> > On Thu, Oct 12, 2017 at 12:41:11PM +0200, Christoffer Dall wrote:
> > > As we are about to move a buch of save/restore logic for VHE kernels to
> > > the load and put functions, we need some infrastructure to do this.
> > > 
> > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > ---
> > >  arch/arm/include/asm/kvm_host.h   |  3 +++
> > >  arch/arm64/include/asm/kvm_host.h |  3 +++
> > >  arch/arm64/kvm/hyp/sysreg-sr.c    | 27 +++++++++++++++++++++++++++
> > >  virt/kvm/arm/arm.c                |  2 ++
> > >  4 files changed, 35 insertions(+)
> > > 
> > > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > > index 1100170..13f8165 100644
> > > --- a/arch/arm/include/asm/kvm_host.h
> > > +++ b/arch/arm/include/asm/kvm_host.h
> > > @@ -290,4 +290,7 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
> > >  int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
> > >  			       struct kvm_device_attr *attr);
> > >  
> > > +static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
> > > +static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
> > > +
> > >  #endif /* __ARM_KVM_HOST_H__ */
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 27305e7..7d3bfa7 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -383,4 +383,7 @@ static inline void __cpu_init_stage2(void)
> > >  		  "PARange is %d bits, unsupported configuration!", parange);
> > >  }
> > >  
> > > +void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
> > > +void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
> > > +
> > >  #endif /* __ARM64_KVM_HOST_H__ */
> > > diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > index c54cc2a..b7438c8 100644
> > > --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> > > +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> > > @@ -183,3 +183,30 @@ void __hyp_text __sysreg32_restore_state(struct kvm_vcpu *vcpu)
> > >  	if (vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY)
> > >  		write_sysreg(sysreg[DBGVCR32_EL2], dbgvcr32_el2);
> > >  }
> > > +
> > > +/**
> > > + * kvm_vcpu_load_sysregs - Load guest system register to physical CPU
> > > + *
> > > + * @vcpu: The VCPU pointer
> > > + *
> > > + * If the kernel runs in EL2 then load the system register state for the VCPU
> > > + * for EL1 onto the physical CPU so that we can go back and foward between the
> > > + * VM and the hypervisor without switching all this state around.
> > 
> > Actually, on second thought, I'm a bit confused by this comment. Maybe
> > it'll be clearer after the code that goes here will be added, but, ATM,
> > I'm not sure why we want to specifically load EL1 VCPU state here. Will
> > that always be the case, even with nested? Also, I'm not sure what
> > alternative loading scheme we're avoiding in order to ensure the state
> > isn't "switched around", which I don't really understand either.
> > 
> 
> I was referring to the EL1 hardware state.  Even for nesting, that's the
> best we can do, because we can't load EL2 state if we're running in EL2,
> or EL1 state if we're running in EL1, because we'd be shooting ourselves
> in the foot.
> 
> The alternative loading scheme is what we have today, where we save and
> restore everything every time we exit/enter the VM, even though we don't
> have to.
> 
> How about:
> 
> /*
>  * Load system registers that do not affect the host's execution, for
>  * example EL1 system registers on a VHE system where the host kernel
>  * runs at EL2.  This function is called from KVM's vcpu_load() function
>  * and loading system register state early avoids having to load them on
>  * every entry to the VM.
>  */

Yeah, I like this. Thanks for the clarification.

(I guess it's time for me to return to reviewing this series. Sorry for
 stalling out on it.)

drew

> 
> Thanks,
> -Christoffer
