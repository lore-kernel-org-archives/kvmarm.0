From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 22/56] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Wed, 18 May 2016 17:46:55 +0100
Message-ID: <573C9C7F.9020209@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-23-git-send-email-andre.przywara@arm.com>
 <573B1DB0.7030901@arm.com> <20160518122521.GD3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 047AB412A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 12:43:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 03DEYlqgLNo6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 12:43:06 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C87641145
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 12:43:06 -0400 (EDT)
In-Reply-To: <20160518122521.GD3827@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

>>> +
>>> +/* generate a mask that covers 1024 interrupts with <b> bits per IRQ */
>>
>> Hmmm. I'd appreciate some additional comments, specially when it comes
>> to the various restrictions. May I'd suggest something like:
>>
>> /*
>>  * Generate a mask that covers the number of bytes required to address
>>  * up to 1024 interrupts, each represented by <b> bits. This assumes
>>  * that <b> is a power of two.
>>  *
>>  * ilog2(b) + ilog2(1024) is the number of bits required to bit-address
>>  * 1024 interrupts, each represented by b bits. Minus ilog2(8) converts
>>  * this to a byte address.
> 
> So I'm guessting this is a rewrite of ilog2( (b * 1024) / 8), but I'm
> stupid enough to not understand our use of logarithms here.  Can someone
> remind me whatever I forgot at CS 101?

I guess it was more me not seeing the wood for the trees here:
Indeed doing the multiplication first and then calling ilog2 seems to
make more sense. Also I was thinking: Isn't
"GENMASK_ULL(ilog2(n) - 1, 0)" the same as "n - 1"?

So can't we just write:

#define VGIC_ADDR_IRQ_MASK(bpi) (((bpi) * 1024 / 8) - 1)

Proven by enumeration - over the values we use ;-)

I'd keep the first paragraph of Marc's comment above then, but we can
avoid mentioning Advanced Maths textbooks about binary logarithmic ;-)

Cheers,
Andre.

>>  */
>>
>>> +#define VGIC_ADDR_IRQ_MASK(b) GENMASK_ULL(ilog2(b) + ilog2(1024) - \
>>> +					  ilog2(BITS_PER_BYTE) - 1, 0)
>>
>> /*
>>  * Convert a base address into a base interrupt (each interrupt
>>  * represented by <bits> bits. This assumes that <bits> is a power
>>  * of two, that <addr> both part of a memory region aligned on a
> 
> did you mean '<addr> *is* both part of' ?
> 
>>  * <b> bits boundary, and itself aligned on that same boundary
>>  * (for regions that describe an interrupt with more than a single
>>  * byte of data).
>>  */
>>
> 
> In any case, thanks for the commentary, I was faily lost here.
> 
