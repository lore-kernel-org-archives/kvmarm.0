From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v5 11/26] KVM: arm64: Extend reset_unknown() to handle
 mixed RES0/UNKNOWN registers
Date: Tue, 26 Feb 2019 12:07:26 +0000
Message-ID: <20190226120726.GM3567@e103592.cambridge.arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-12-git-send-email-Dave.Martin@arm.com>
 <602da3aa-f473-7a35-1b59-31af8a162ccc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C2F4A3BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:07:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d6G5ikK91Ehu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Feb 2019 07:07:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DAF04A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Feb 2019 07:07:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <602da3aa-f473-7a35-1b59-31af8a162ccc@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Feb 20, 2019 at 01:33:28PM +0000, Julien Thierry wrote:
> Hi Dave,
> 
> On 18/02/2019 19:52, Dave Martin wrote:
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
> > This patch takes advantage of the unused val field in struct
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
> >  arch/arm64/kvm/sys_regs.h | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 3b1bc7f..174ffc0 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -56,7 +56,12 @@ struct sys_reg_desc {
> >  	/* Index into sys_reg[], or 0 if we don't need to save it. */
> >  	int reg;
> >  
> > -	/* Value (usually reset value) */
> > +	/*
> > +	 * Value (usually reset value)
> > +	 * For reset_unknown, each bit set to 1 in val is treated as
> > +	 * RES0 in the register: the corresponding register bit is
> > +	 * reset to 0 instead of "unknown".
> > +	 */
> 
> Seeing there are users of this field, I find this a bit fragile. Is

In fact, I only see reset_val(), and the reset_val workalikes
reset_bcr(), reset_bvr() etc., using this field.

So, when used, this is always the reset value right now.

We could water the comment down to "data used by the reset method."


> there a reason not to add a separate "u64 res0_mask;" ?
> 
> The sys_reg_desc structures are instantiated once as constants for the
> whole system rather than per VM/VCPU. Would it be really bad to add a
> 64bit field there?

Not really.  I was trying to avoid overengineering something that will
probably only ever be used in one or two places.

With that in mind, I'm feeling this patch may be premature factoring
and can be dropped.  Initialising ZCR_EL1 with 0, or a fixed value
based on 0x1de7ec7edbadc0deULL would be good enough for this currently
unique case.  

Thoughts?

[...]

Cheers
---Dave
