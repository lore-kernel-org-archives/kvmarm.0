From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 19:07:24 +0200
Message-ID: <20170404170724.smrhn4ghg7selko2@kamzik.brq.redhat.com>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <44739aad-ba52-4f02-8d3d-643365b7f8a7@arm.com>
 <20170404144724.epa45tewewnydnc6@kamzik.brq.redhat.com>
 <f615bc88-0a18-47a3-1122-e7e6db38bf3d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f615bc88-0a18-47a3-1122-e7e6db38bf3d@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@linaro.org, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 04:51:40PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/04/2017 16:47, Andrew Jones wrote:
> >>> -#define KVM_REQ_VCPU_EXIT	8
> >>> +#define KVM_REQ_PAUSE		8
> >> Small nit: can we have a #define for this 8? KVM_REQ_ARCH_BASE, or
> >> something along those lines?
> > Sounds good to me.  Should I even do something like
> > 
> >  #define KVM_REQ_ARCH_BASE 8
> > 
> >  #define KVM_ARCH_REQ(bit) ({ \
> >      BUILD_BUG_ON(((bit) + KVM_REQ_ARCH_BASE) >= BITS_PER_LONG); \
> 
> Please make this 32 so that we don't fail on 32-bit machines.
> 
> or even
> 
> BUILD_BUG_ON((unsigned)(bit) >= BITS_PER_LONG - KVM_REQ_ARCH_BASE);
> 
> in case someone is crazy enough to pass a negative value!

Will do.

Thanks,
drew

> 
> Paolo
> 
> >      ((bit) + KVM_REQ_ARCH_BASE); \
> >  })
> > 
> >  #define KVM_REQ_PAUSE KVM_ARCH_REQ(0)
> > 
> > or would that be overkill?  Also, whether we switch to just the base
> > define, or the macro, I guess it would be good to do for all
> > architectures.
> 
