From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v4 22/56] KVM: arm/arm64: vgic-new: Add MMIO handling
 framework
Date: Wed, 18 May 2016 16:55:45 +0100
Message-ID: <573C9081.6080500@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-23-git-send-email-andre.przywara@arm.com>
 <20160518123115.GE3827@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3152440FA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 11:52:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Y3-Fitaa0Zc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 May 2016 11:51:56 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8281340F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 May 2016 11:51:56 -0400 (EDT)
In-Reply-To: <20160518123115.GE3827@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

....

>> +
>> +/* generate a mask that covers 1024 interrupts with <b> bits per IRQ */
>> +#define VGIC_ADDR_IRQ_MASK(b) GENMASK_ULL(ilog2(b) + ilog2(1024) - \
>> +					  ilog2(BITS_PER_BYTE) - 1, 0)
>> +#define VGIC_ADDR_TO_INTID(addr, bits)  (((addr) & VGIC_ADDR_IRQ_MASK(bits)) * \
>> +					64 / (bits) / 8)
> 
> In the comment we end up adding here, can we also describe why
> (addr & <magic mask>) * <magic 64> / (bits) / <BITS_PER_BYTE OR BYTES_PER_ULL>
> gives us what we need, because I don't get it.

The reason is: we deal with 8 bits per byte, but have
bits-per-interrupts values bigger than 8. Doing the maths in floating
point arithmetic would work fine:

(float)(addr & mask) * (8.0 / bits_per_IRQ)

So would this comment make sense?

/*
 * Since we can have more than 8 bits per interrupt, we can't use
 * "8 / bpi" as a multiplicand directly, so we use a
 * fixed-point-arithmetic version of it tailored to cover at most 64
 * bits per IRQ.
 */

Cheers,
Andre.
