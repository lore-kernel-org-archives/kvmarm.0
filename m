From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 02/37] KVM: arm64: Rework hyp_panic for VHE and non-VHE
Date: Thu, 12 Oct 2017 19:06:26 +0200
Message-ID: <20171012170626.GB26425@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-3-christoffer.dall@linaro.org>
 <313239e5-d755-95b6-4db7-6dafe2027155@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <313239e5-d755-95b6-4db7-6dafe2027155@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 12, 2017 at 04:55:16PM +0100, Marc Zyngier wrote:
> On 12/10/17 11:41, Christoffer Dall wrote:
> > VHE actually doesn't rely on clearing the VTTBR when returning to the
> > hsot kernel, and that is the current key mechanism of hyp_panic to
> 
> host
> 
> > figure out how to attempt to return to a state good enough to print a
> > panic statement.
> > 
> > Therefore, we split the hyp_panic function into two functions, a VHE and
> > a non-VHE, keeping the non-VHE version intact, but changing the VHE
> > behavior.
> > 
> > The vttbr_el2 check on VHE doesn't really make that much sense, because
> > the only situation where we can get here on VHE is when the hypervisor
> > assembly code actually caleld into hyp_panic, which only happens when
> 
> called
> 
> > VBAR_EL2 has been set to the KVM exception vectors.  On VHE, we can
> > always safely disable the traps and restore the host registers at this
> > point, so we simply do that unconditionally and call into the panic
> > function directly.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 45 +++++++++++++++++++++++----------------------
> >  1 file changed, 23 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index a0123ad..a50ddf3 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -394,10 +394,20 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n";
> >  
> >  static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> > -					     struct kvm_vcpu *vcpu)
> > +					     struct kvm_cpu_context *__host_ctxt)
> >  {
> > +	struct kvm_vcpu *vcpu;
> >  	unsigned long str_va;
> >  
> > +	vcpu = __host_ctxt->__hyp_running_vcpu;
> > +
> > +	if (read_sysreg(vttbr_el2)) {
> > +		__timer_disable_traps(vcpu);
> > +		__deactivate_traps(vcpu);
> > +		__deactivate_vm(vcpu);
> > +		__sysreg_restore_host_state(__host_ctxt);
> > +	}
> > +
> >  	/*
> >  	 * Force the panic string to be loaded from the literal pool,
> >  	 * making sure it is a kernel address and not a PC-relative
> > @@ -411,40 +421,31 @@ static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par,
> >  		       read_sysreg(hpfar_el2), par, vcpu);
> >  }
> >  
> > -static void __hyp_text __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
> > -					    struct kvm_vcpu *vcpu)
> > +static void __hyp_call_panic_vhe(u64 spsr, u64 elr, u64 par,
> > +				 struct kvm_cpu_context *host_ctxt)
> >  {
> > +	struct kvm_vcpu *vcpu;
> > +	vcpu = host_ctxt->__hyp_running_vcpu;
> > +
> > +	__deactivate_traps_vhe();
> 
> Is there a reason why we can't just call __deactivate_traps(), rather
> than the VHE-specific subset? It doesn't really matter, as we're about
> to panic, but still...
> 

It doesn't really matter, especially as later patches will change this,
but this patch would be slightly nicer keeping the __deactivate_traps.
I don't mind changing that around in the next version.


> > +	__sysreg_restore_host_state(host_ctxt);
> > +
> >  	panic(__hyp_panic_string,
> >  	      spsr,  elr,
> >  	      read_sysreg_el2(esr),   read_sysreg_el2(far),
> >  	      read_sysreg(hpfar_el2), par, vcpu);
> >  }
> >  
> > -static hyp_alternate_select(__hyp_call_panic,
> > -			    __hyp_call_panic_nvhe, __hyp_call_panic_vhe,
> > -			    ARM64_HAS_VIRT_HOST_EXTN);
> > -
> >  void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *__host_ctxt)
> >  {
> > -	struct kvm_vcpu *vcpu = NULL;
> > -
> >  	u64 spsr = read_sysreg_el2(spsr);
> >  	u64 elr = read_sysreg_el2(elr);
> >  	u64 par = read_sysreg(par_el1);
> >  
> > -	if (read_sysreg(vttbr_el2)) {
> > -		struct kvm_cpu_context *host_ctxt;
> > -
> > -		host_ctxt = __host_ctxt;
> > -		vcpu = host_ctxt->__hyp_running_vcpu;
> > -		__timer_disable_traps(vcpu);
> > -		__deactivate_traps(vcpu);
> > -		__deactivate_vm(vcpu);
> > -		__sysreg_restore_host_state(host_ctxt);
> > -	}
> > -
> > -	/* Call panic for real */
> > -	__hyp_call_panic()(spsr, elr, par, vcpu);
> > +	if (!has_vhe())
> > +		__hyp_call_panic_nvhe(spsr, elr, par, __host_ctxt);
> > +	else
> > +		__hyp_call_panic_vhe(spsr, elr, par, __host_ctxt);
> >  
> >  	unreachable();
> >  }
> > 
> 
> Otherwise looks good.
> 

Thanks,
-Christoffer
