From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: Create and use __tlbi_dsb() macros
Date: Fri, 13 Jan 2017 16:12:10 +0000
Message-ID: <20170113161209.GI3253@arm.com>
References: <20170111144118.17062-1-cov@codeaurora.org>
 <20170111144118.17062-3-cov@codeaurora.org>
 <20170112165852.GH13843@arm.com>
 <8f8057f5-d33f-15b3-de9f-6e718c23e97d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8f8057f5-d33f-15b3-de9f-6e718c23e97d@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org, Mark Langsdorf <mlangsdo@redhat.com>, Mark Salter <msalter@redhat.com>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 13, 2017 at 10:12:36AM -0500, Christopher Covington wrote:
> On 01/12/2017 11:58 AM, Will Deacon wrote:
> > On Wed, Jan 11, 2017 at 09:41:16AM -0500, Christopher Covington wrote:
> >> +#define __tlbi_asm_dsb(as, op, attr, ...) do {				       \
> >> +		__TLBI_FOR(op, ##__VA_ARGS__)				       \
> >> +			asm (__TLBI_INSTR(op, ##__VA_ARGS__)		       \
> >> +			__TLBI_IO(op, ##__VA_ARGS__));			       \
> >> +		asm volatile (	     as			"\ndsb " #attr "\n"    \
> >> +		: : : "memory"); } while (0)
> >> +
> >> +#define __tlbi_dsb(...)	__tlbi_asm_dsb("", ##__VA_ARGS__)
> > 
> > I can't deny that this is cool, but ultimately it's completely unreadable.
> > What I was thinking you'd do would be make __tlbi expand to:
> > 
> >   tlbi
> >   dsb
> >   tlbi
> >   dsb
> > 
> > for Falkor, and:
> > 
> >   tlbi
> >   nop
> >   nop
> >   nop
> > 
> > for everybody else.
> 
> Thanks for the suggestion. So would __tlbi take a dsb sharability argument in
> your proposal? Or would it be communicated in some other fashion, maybe inferred
> from the tlbi argument? Or would the workaround dsbs all be the worst/broadest
> case?

I think always using inner-shareable should be ok. If you wanted to optimise
this, you'd want to avoid the workaround altogether for non-shareable
invalidation, but that's fairly rare and I doubt you'd be able to measure
the impact.

> > Wouldn't that localise this change sufficiently that you wouldn't need
> > to change all the callers and encode the looping in your cpp macros?
> > 
> > I realise you get an extra dsb in some places with that change, but I'd
> > like to see numbers for the impact of that on top of the workaround. If
> > it's an issue, then an alternative sequence would be:
> > 
> >   tlbi
> >   dsb
> >   tlbi
> > 
> > and you'd rely on the existing dsb to complete that.
> > 
> > Having said that, I don't understand how your current loop code works
> > when the workaround is applied. AFAICT, you end up emitting something
> > like:
> > 
> > dsb ishst
> > for i in 0 to n
> > 	tlbi va+i
> > dsb
> > tlbi va+n
> > dsb
> > 
> > which looks wrong to me. Am I misreading something here?
> 
> You're right, I am off by 1 << (PAGE_SHIFT - 12) here. I would need to
> increment, compare, not take the loop branch (regular for loop stuff),
> then decrement (missing) and perform TLB invalidation again (present but
> using incorrect value).

It also strikes me as odd that you only need one extra TLBI after the loop
has finished, as opposed to a tlbi; dsb; tlbi loop body (which is what you'd
get if you modified __tlbi as I suggest).

Is it sufficient to have one extra TLBI after the loop and, if so, is the
performance impact of my suggestion therefore unacceptable?

Will
