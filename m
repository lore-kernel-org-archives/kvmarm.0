From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH v2 10/23] KVM: arm64: Extend reset_unknown() to
 handle mixed RES0/UNKNOWN registers
Date: Thu, 15 Nov 2018 17:11:34 +0000
Message-ID: <20181115171134.GP3505@e103592.cambridge.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-11-git-send-email-Dave.Martin@arm.com>
 <20181102081119.GR12057@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F229D4A337
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:11:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OL9+wypGNx9n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 12:11:38 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D57214A32B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 12:11:38 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181102081119.GR12057@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 09:11:19AM +0100, Christoffer Dall wrote:
> On Fri, Sep 28, 2018 at 02:39:14PM +0100, Dave Martin wrote:
> > The reset_unknown() system register helper initialises a guest
> > register to a distinctive junk value on vcpu reset, to help expose
> > and debug deficient register initialisation within the guest.
> > 
> > Some registers such as the SVE control register ZCR_EL1 contain a
> > mixture of UNKNOWN fields and RES0 bits.  For these,
> > reset_unknown() does not work at present, since it sets all bits to
> > junk values instead of just the wanted bits.
> > 
> > There is no need to craft another special helper just for that,
> > since reset_unknown() almost does the appropriate thing anyway.
> > This patch takes advantage of the ununused val field in struct
> > sys_reg_desc to specify a mask of bits that should be initialised
> > to zero instead of junk.
> > 
> > All existing users of reset_unknown() do not (and should not)
> > define a value for val, so they will implicitly set it to zero,
> > resulting in all bits being made UNKNOWN by this function: thus,
> > this patch makes no functional change for currently defined
> > registers.
> > 
> > Future patches will make use of non-zero val.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/kvm/sys_regs.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index cd710f8..24bac06 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -89,7 +89,9 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
> >  {
> >  	BUG_ON(!r->reg);
> >  	BUG_ON(r->reg >= NR_SYS_REGS);
> > -	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
> > +
> > +	/* If non-zero, r->val specifies which register bits are RES0: */
> > +	__vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL & ~r->val;
> 
> nit: it would be nice to document this feature on the val field in the
> sys_reg_desc structure above as well.

Sure thing, I missed that, but we _do_ want this clearly documented.

I'll add that when I respin.

[...]

Cheers
---Dave
