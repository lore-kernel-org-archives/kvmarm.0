From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 09/37] KVM: arm64: Move debug dirty flag calculation out
 of world switch
Date: Sun, 3 Dec 2017 14:17:13 +0100
Message-ID: <20171203131713.auwmzt3iwxxg2n4w@hawk.localdomain>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-10-christoffer.dall@linaro.org>
 <20171107140919.p6act55ubmzlv66b@kamzik.brq.redhat.com>
 <20171201172546.GB6615@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E85A849D66
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 08:14:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PEUHsfSqprj for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Dec 2017 08:14:31 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E95EF40D25
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Dec 2017 08:14:30 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20171201172546.GB6615@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 01, 2017 at 06:25:46PM +0100, Christoffer Dall wrote:
> On Tue, Nov 07, 2017 at 03:09:19PM +0100, Andrew Jones wrote:
> > On Thu, Oct 12, 2017 at 12:41:13PM +0200, Christoffer Dall wrote:
> > > There is no need to figure out inside the world-switch if we should
> > > save/restore the debug registers or not, we can might as well do that in
> > > the higher level debug setup code, making it easier to optimize down the
> > > line.
> > > 
> > > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > > ---
> > >  arch/arm64/kvm/debug.c        | 9 +++++++++
> > >  arch/arm64/kvm/hyp/debug-sr.c | 6 ------
> > >  2 files changed, 9 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> > > index dbadfaf..62550de19 100644
> > > --- a/arch/arm64/kvm/debug.c
> > > +++ b/arch/arm64/kvm/debug.c
> > > @@ -193,6 +193,15 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
> > >  	if (trap_debug)
> > >  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> > >  
> > > +	/*
> > > +	 * If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY is set, perform
> > > +	 * a full save/restore cycle.
> > 
> > The commit message implies testing KVM_ARM64_DEBUG_DIRTY, but it only
> > tests KDE and MDE.
> > 
> 
> You meant the comment, right?

yup

> 
> > > +	 */
> > > +	if ((vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_KDE) ||
> > > +	    (vcpu_sys_reg(vcpu, MDSCR_EL1) & DBG_MDSCR_MDE))
> > 
> > nit: could also write as
> > 
> >  if (vcpu_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
> > 
> 
> I actually prefer it the other way, and I think the compiler will figure
> out what to do in terms of efficiency.

I won't argue about code aesthetics (although I disagree here :-). I will
point out that in this case the compiler will no doubt do the right thing,
as vcpu_sys_reg() is just a macro, but for a pointer taking function in
general there would be potential to get both calls emitted, as the
compiler wouldn't be sure there would be no side effect.

> 
> > > +		vcpu->arch.debug_flags |= KVM_ARM64_DEBUG_DIRTY;
> > > +
> > 
> > It looks like there's only one flag for debug_flags - this dirty flag,
> > which I guess is also used to trigger trapping. So maybe this could be a
> > second flag of a "lazy state" field, as I suggested earlier?
> > 
> 
> I'm going to leave this one for now, but we can improve that later on if
> we want to save a little space in the vcpu struct, or rather if we want
> to rearrange things to make frequently accessed fields fit in the same
> cache line.
>

OK

Thanks,
drew
