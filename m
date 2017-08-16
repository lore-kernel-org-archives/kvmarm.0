From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 21/27] arm64/sve: KVM: Prevent guests from using SVE
Date: Wed, 16 Aug 2017 11:50:14 +0100
Message-ID: <20170816105013.GZ6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-22-git-send-email-Dave.Martin@arm.com>
 <0f5b14a8-4d04-61e4-05e8-92cd55c8bee9@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0f5b14a8-4d04-61e4-05e8-92cd55c8bee9@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, g@e103592.cambridge.arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 15, 2017 at 05:33:15PM +0100, Marc Zyngier wrote:
> On 09/08/17 13:05, Dave Martin wrote:
> > Until KVM has full SVE support, guests must not be allowed to
> > execute SVE instructions.
> > 
> > This patch enables the necessary traps, and also ensures that the
> > traps are disabled again on exit from the guest so that the host
> > can still use SVE if it wants to.
> > 
> > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 3 ++-
> >  arch/arm64/kvm/hyp/switch.c      | 6 +++---
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index dbf0537..8a19651 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -186,7 +186,7 @@
> >  #define CPTR_EL2_TTA	(1 << 20)
> >  #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
> >  #define CPTR_EL2_TZ	(1 << 8)
> > -#define CPTR_EL2_DEFAULT	0x000033ff
> > +#define CPTR_EL2_DEFAULT	(0x000033ff & ~CPTR_EL2_TZ)
> 
> I must say I'm not overly fond of this construct. I'd rather introduce a
> RES1 field that matches the v8.2 description, instead of this ugly
> constant and something that clears it.

Sorry, I don't get your meaning here.  v8.2 neither immediately predates
or postdates SVE.  What are you propsing?

I guess we could just write 0x000032ff now that the only meaning the
architecture can ever assign to bit 8 is known.

[...]

Cheers
---Dave
