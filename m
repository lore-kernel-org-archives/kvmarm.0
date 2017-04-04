From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 3/9] KVM: arm/arm64: prepare to use vcpu requests
Date: Tue, 4 Apr 2017 19:06:49 +0200
Message-ID: <20170404170649.2oxbeyuwz333f2jm@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-4-drjones@redhat.com>
 <20170404153401.GM11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170404153401.GM11752@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 05:34:01PM +0200, Christoffer Dall wrote:
> On Fri, Mar 31, 2017 at 06:06:52PM +0200, Andrew Jones wrote:
> > Make sure we don't leave vcpu requests we don't intend to
> > handle later set in the request bitmap. If we don't clear
> > them, then kvm_request_pending() may return true when we
> > don't want it to.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > Acked-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  arch/arm/kvm/handle_exit.c   | 1 +
> >  arch/arm/kvm/psci.c          | 1 +
> >  arch/arm64/kvm/handle_exit.c | 1 +
> >  3 files changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
> > index 96af65a30d78..ffb2406e5905 100644
> > --- a/arch/arm/kvm/handle_exit.c
> > +++ b/arch/arm/kvm/handle_exit.c
> > @@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		trace_kvm_wfx(*vcpu_pc(vcpu), false);
> >  		vcpu->stat.wfi_exit_stat++;
> >  		kvm_vcpu_block(vcpu);
> > +		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
> 
> I actually don't understand the idea behind KVM_REQ_UNHALT?
> 
> It seems there's a semantic difference that architectures should adhere
> by when returning from kvm_vcpu_block() with or without KVM_REQ_UNHALT
> set (i.e. if the vcpu was runnable when kvm_vcpu_check_blocK() was
> called?) - can you explain what the deal is?  Perhaps that belongs in
> the documentation patch.

Yup, will address this in the doc patch.

> 
> >  	}
> >  
> >  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> > diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
> > index c2b131527a64..82fe7eb5b6a7 100644
> > --- a/arch/arm/kvm/psci.c
> > +++ b/arch/arm/kvm/psci.c
> > @@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  	 * for KVM will preserve the register state.
> >  	 */
> >  	kvm_vcpu_block(vcpu);
> > +	clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
> >  
> >  	return PSCI_RET_SUCCESS;
> >  }
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> > index fa1b18e364fc..e4937fb2fb89 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
> >  		vcpu->stat.wfi_exit_stat++;
> >  		kvm_vcpu_block(vcpu);
> > +		clear_bit(KVM_REQ_UNHALT, &vcpu->requests);
> >  	}
> >  
> >  	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> > -- 
> > 2.9.3
> > 
> 
> Ignoring my comment above, for the content of this patch:
> 
> Acked-by: Christoffer Dall <cdall@linaro.org>

Thanks,
drew
