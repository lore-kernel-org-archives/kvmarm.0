From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 16:47:24 +0200
Message-ID: <20170404144724.epa45tewewnydnc6@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <44739aad-ba52-4f02-8d3d-643365b7f8a7@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44739aad-ba52-4f02-8d3d-643365b7f8a7@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 02:39:19PM +0100, Marc Zyngier wrote:
> On 31/03/17 17:06, Andrew Jones wrote:
> > This not only ensures visibility of changes to pause by using
> > atomic ops, but also plugs a small race where a vcpu could get its
> > pause state enabled just after its last check before entering the
> > guest. With this patch, while the vcpu will still initially enter
> > the guest, it will exit immediately due to the IPI sent by the vcpu
> > kick issued after making the vcpu request.
> > 
> > We use bitops, rather than kvm_make/check_request(), because we
> > don't need the barriers they provide, nor do we want the side-effect
> > of kvm_check_request() clearing the request. For pause, only the
> > requester should do the clearing.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  5 +----
> >  arch/arm/kvm/arm.c                | 45 +++++++++++++++++++++++++++------------
> >  arch/arm64/include/asm/kvm_host.h |  5 +----
> >  3 files changed, 33 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 31ee468ce667..52c25536d254 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -45,7 +45,7 @@
> >  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
> >  #endif
> >  
> > -#define KVM_REQ_VCPU_EXIT	8
> > +#define KVM_REQ_PAUSE		8
> 
> Small nit: can we have a #define for this 8? KVM_REQ_ARCH_BASE, or
> something along those lines?

Sounds good to me.  Should I even do something like

 #define KVM_REQ_ARCH_BASE 8

 #define KVM_ARCH_REQ(bit) ({ \
     BUILD_BUG_ON(((bit) + KVM_REQ_ARCH_BASE) >= BITS_PER_LONG); \
     ((bit) + KVM_REQ_ARCH_BASE); \
 })

 #define KVM_REQ_PAUSE KVM_ARCH_REQ(0)

or would that be overkill?  Also, whether we switch to just the base
define, or the macro, I guess it would be good to do for all
architectures.

Thanks,
drew

> 
> I've otherwise started hammering this series over a number of systems,
> looking good so far.
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
