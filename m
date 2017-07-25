From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC 7/9] arm64: expose PAC bit positions via ptrace
Date: Tue, 25 Jul 2017 16:06:15 +0100
Message-ID: <20170725150612.GD6321@e103592.cambridge.arm.com>
References: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
 <1491232765-32501-8-git-send-email-mark.rutland@arm.com>
 <20170725121145.GB6321@e103592.cambridge.arm.com>
 <20170725145903.GA20857@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725145903.GA20857@leverpostej>
Sender: linux-arch-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 25, 2017 at 03:59:04PM +0100, Mark Rutland wrote:
> On Tue, Jul 25, 2017 at 01:11:48PM +0100, Dave Martin wrote:
> > On Mon, Apr 03, 2017 at 04:19:23PM +0100, Mark Rutland wrote:
> > > +/*
> > > + * The pointer bits used by a pointer authentication code.
> > > + * If we were to use tagged pointers, bits 63:56 would also apply.
> > > + */
> > > +#define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)
> > 
> > Tagged pointers _are_ enabled for userspace by default, no?
> 
> Yes; I'd meant s/tagged/untagged/.
> 
> I've corrected this to:
> 
> /*
>  * The EL0 pointer bits used by a pointer authentication code.
>  * This is dependent on TBI0 being enabled, or bits 63:56 would also apply.
>  */

Yes, that's better.  If we do enable untagged pointers for userspace at
some point though, this is likely to be missed.

I don't have a good answer to this.

> > > diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> > > index b59ee07..cae3d1e 100644
> > > --- a/include/uapi/linux/elf.h
> > > +++ b/include/uapi/linux/elf.h
> > > @@ -414,6 +414,7 @@
> > >  #define NT_ARM_HW_BREAK	0x402		/* ARM hardware breakpoint registers */
> > >  #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
> > >  #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
> > > +#define NT_ARM_PAC_MASK		0x405	/* ARM pointer authentication code masks */
> > 
> > The is the value tentatively assigned to NT_ARM_SVE.
> 
> I must've generated this patch before I corrected this; my local branch
> (and kernel.org) have 0x406 here.
> 
> Sorry about that.

Shame, I had a rant about pragmatism prepped and ready ;)

Cheers
---Dave
