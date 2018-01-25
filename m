From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 15/41] KVM: arm64: Remove kern_hyp_va() use in VHE
 switch function
Date: Thu, 25 Jan 2018 20:48:00 +0100
Message-ID: <20180125194800.GS21802@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-16-christoffer.dall@linaro.org>
 <20180124162415.GF5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180124162415.GF5862@e103592.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 24, 2018 at 04:24:15PM +0000, Dave Martin wrote:
> On Fri, Jan 12, 2018 at 01:07:21PM +0100, Christoffer Dall wrote:
> > VHE kernels run completely in EL2 and therefore don't have a notion of
> > kernel and hyp addresses, they are all just kernel addresses.  Therefore
> > don't call kern_hyp_va() in the VHE switch function.
> 
> Isn't this an example of avoidable forkage?
> 
> This looks like it's probably just saving a couple of nops, though I may
> have misunderstood how this interfacts with alternatives.

In isolation, and if we stopped here, you're absolutely right, it
doesn't make sense.  But this is just a step on the way to significantly
reduce the _vhe version.  Have a look at the following patches and the
end result and let me know if you still have concerns.

Thanks,
-Christoffer

> 
> > 
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/hyp/switch.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> > index accfe9a016f9..05fba76ec918 100644
> > --- a/arch/arm64/kvm/hyp/switch.c
> > +++ b/arch/arm64/kvm/hyp/switch.c
> > @@ -345,9 +345,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
> >  	struct kvm_cpu_context *guest_ctxt;
> >  	u64 exit_code;
> >  
> > -	vcpu = kern_hyp_va(vcpu);
> > -
> > -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > +	host_ctxt = vcpu->arch.host_cpu_context;
> >  	host_ctxt->__hyp_running_vcpu = vcpu;
> >  	guest_ctxt = &vcpu->arch.ctxt;
> >  
> > -- 
> > 2.14.2
> > 
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
