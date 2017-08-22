From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 11/27] arm64/sve: Core task context handling
Date: Tue, 22 Aug 2017 18:19:59 +0100
Message-ID: <20170822171959.GX6321@e103592.cambridge.arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-12-git-send-email-Dave.Martin@arm.com>
 <87378jbmkg.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87378jbmkg.fsf@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 22, 2017 at 05:21:19PM +0100, Alex Bennée wrote:
> 
> Dave Martin <Dave.Martin@arm.com> writes:

[...]

> > --- a/arch/arm64/include/asm/processor.h
> > +++ b/arch/arm64/include/asm/processor.h
> > @@ -85,6 +85,8 @@ struct thread_struct {
> >  	unsigned long		tp2_value;
> >  #endif
> >  	struct fpsimd_state	fpsimd_state;
> > +	void			*sve_state;	/* SVE registers, if any */
> > +	u16			sve_vl;		/* SVE vector length */
> 
> sve_vl is implicitly cast to unsigned int bellow - it should be
> consistent.

Agreed -- I think this can just be unsigned int here, which is the type
I use everywhere except when encoding the vector length in the signal
frame and ptrace data.

During development, there was an additional flags field here (now
merged into the thread_info flags).  u16 was big enough for the largest
architectural vector length, so it seemed "tidy" to make both u16s.
Elsewhere, this created a risk of overflow if you try to compute say
the size of the whole register file from a u16, so I generally used
unsigned int for local variables in functions that handle the vl.

> Given the allocation functions rely on sve_vl being valid it might be
> worth noting where this is set/live from?

Agreed, I need to look more closely at exactly how to justify the
soundness of this in order to thin out BUG_ONs.

If you need any pointers, please ping me.  In the meantime, I would
rather not colour your judgement by infecting you with my assumptions ;)

> >  	unsigned long		fault_address;	/* fault info */
> >  	unsigned long		fault_code;	/* ESR_EL1 value */
> >  	struct debug_info	debug;		/* debugging */
> > diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> > index 46c3b93..1a4b30b 100644
> > --- a/arch/arm64/include/asm/thread_info.h
> > +++ b/arch/arm64/include/asm/thread_info.h
> <snip>
> 
> And I see there are other comments from Ard.

Yup, I've already picked those up.

I'll be posting a v2 with feedback applied once I've reviewed the
existing BUG_ON()s -- should happen sometime this week.

Cheers
---Dave
