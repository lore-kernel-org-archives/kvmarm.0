From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 09/37] KVM: arm64: Move debug dirty flag calculation out
 of world switch
Date: Fri, 1 Dec 2017 18:25:46 +0100
Message-ID: <20171201172546.GB6615@lvm>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-10-christoffer.dall@linaro.org>
 <20171107140919.p6act55ubmzlv66b@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107140919.p6act55ubmzlv66b@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 07, 2017 at 03:09:19PM +0100, Andrew Jones wrote:
> On Thu, Oct 12, 2017 at 12:41:13PM +0200, Christoffer Dall wrote:
> > There is no need to figure out inside the world-switch if we should
> > save/restore the debug registers or not, we can might as well do that in
> > the higher level debug setup code, making it easier to optimize down the
> > line.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/debug.c        | 9 +++++++++
> >  arch/arm64/kvm/hyp/debug-sr.c | 6 ------
> >  2 files changed, 9 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > index dbadfaf..62550de19 100644
> > --- a/arch/arm64/kvm/debug.c
> > +++ b/arch/arm64/kvm/debug.c
> > @@ -193,6 +193,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> >  	if (trap_debug)
> >  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> >  
> > +	/*
> > +	 * If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
> > +	 * a full save/restore cycle.
> 
> The commit message implies testing KVM_ARM64_DEBUG_DIRTY, but it only
> tests KDE and MDE.
> 

You meant the comment, right?

> > +	 */
> > +	if ((vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_KDE) ||
> > +	    (vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_MDE))
> 
> nit: could also write as
> 
>  if (vcpu_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
> 

I actually prefer it the other way, and I think the compiler will figure
out what to do in terms of efficiency.

> > +		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
> > +
> 
> It looks like there's only one flag for debug_flags - this dirty flag,
> which I guess is also used to trigger trapping. So maybe this could be a
> second flag of a "lazy state" field, as I suggested earlier?
> 

I'm going to leave this one for now, but we can improve that later on if
we want to save a little space in the vcpu struct, or rather if we want
to rearrange things to make frequently accessed fields fit in the same
cache line.

Thanks,
-Christoffer
