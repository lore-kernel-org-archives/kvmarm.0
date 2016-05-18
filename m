From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 22/56] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Wed, 18 May 2016 19:08:49 +0200
Message-ID: <20160518170849.GN6666@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-23-git-send-email-andre.przywara@arm.com>
 <573B1DB0.7030901@arm.com>
 <20160518122521.GD3827@cbox>
 <573C9C7F.9020209@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <573C9C7F.9020209@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 18, 2016 at 05:46:55PM +0100, Andre Przywara wrote:
> Hi,
> 
> >>> +
> >>> +/* generate a mask that covers 1024 interrupts with <b> bits per IRQ */
> >>
> >> Hmmm. I'd appreciate some additional comments, specially when it comes
> >> to the various restrictions. May I'd suggest something like:
> >>
> >> /*
> >>  * Generate a mask that covers the number of bytes required to address
> >>  * up to 1024 interrupts, each represented by <b> bits. This assumes
> >>  * that <b> is a power of two.
> >>  *
> >>  * ilog2(b) + ilog2(1024) is the number of bits required to bit-address
> >>  * 1024 interrupts, each represented by b bits. Minus ilog2(8) converts
> >>  * this to a byte address.
> > 
> > So I'm guessting this is a rewrite of ilog2( (b * 1024) / 8), but I'm
> > stupid enough to not understand our use of logarithms here.  Can someone
> > remind me whatever I forgot at CS 101?
> 
> I guess it was more me not seeing the wood for the trees here:
> Indeed doing the multiplication first and then calling ilog2 seems to
> make more sense. Also I was thinking: Isn't
> "GENMASK_ULL(ilog2(n) - 1, 0)" the same as "n - 1"?

if there's no integer rounding taking place with ilog2 (iow. n is a
power of 2) then yes, I believe it is.

> 
> So can't we just write:
> 
> #define VGIC_ADDR_IRQ_MASK(bpi) (((bpi) * 1024 / 8) - 1)

that certianly all of the sudden feels intuitive.

> 
> Proven by enumeration - over the values we use ;-)
> 
> I'd keep the first paragraph of Marc's comment above then, but we can
> avoid mentioning Advanced Maths textbooks about binary logarithmic ;-)
> 

Haha, you saved my day with that comment.  I feel slightly less idiotic
now, yes, let's call it advanced quantum math or something instead of CS
101 :)

-Christoffer

> 
> >>  */
> >>
> >>> +#define VGIC_ADDR_IRQ_MASK(b) GENMASK_ULL(ilog2(b) + ilog2(1024) - \
> >>> +					  ilog2(BITS_PER_BYTE) - 1, 0)
> >>
> >> /*
> >>  * Convert a base address into a base interrupt (each interrupt
> >>  * represented by <bits> bits. This assumes that <bits> is a power
> >>  * of two, that <addr> both part of a memory region aligned on a
> > 
> > did you mean '<addr> *is* both part of' ?
> > 
> >>  * <b> bits boundary, and itself aligned on that same boundary
> >>  * (for regions that describe an interrupt with more than a single
> >>  * byte of data).
> >>  */
> >>
> > 
> > In any case, thanks for the commentary, I was faily lost here.
> > 
