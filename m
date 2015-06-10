From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 03/10] KVM: arm/arm64: vgic: Convert struct vgic_lr to
 use bitfields
Date: Wed, 10 Jun 2015 19:04:16 +0100
Message-ID: <55787C20.9070404@arm.com>
References: <1433783045-8002-1-git-send-email-marc.zyngier@arm.com> <1433783045-8002-4-git-send-email-marc.zyngier@arm.com> <557872A3.8070302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <557872A3.8070302@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/06/15 18:23, Andre Przywara wrote:
> Hi Marc,
> 
> On 06/08/2015 06:03 PM, Marc Zyngier wrote:
>> As we're about to cram more information in the vgic_lr structure
>> (HW interrupt number and additional state information), we switch
>> to a layout similar to the HW's:
>>
>> - use bitfields to save space (we don't need more than 10 bits
>>   to represent the irq numbers)
> 
> But that will not be true for LPIs later, right? Before that I was lucky
> with the irq field being 16 bits wide ;-)
> So can we increase that to be at least 14 bits (8192 LPI offset + 8192
> LPIs) here? The structure would still fit in 32 bits, then.

Yes, that's true. An oversight on my part.

> I guess guests should get away with only supporting 8K of LPIs, but if
> we map hardware LPIs to guest IRQs I guess we may exceed 14 bits here.
> Not sure if we could extend this further for ARM64 only, as we have more
> room there and also need it only here.

Mapping LPIs to IRQs is not a problem, as LPIs don't have an active
state, so you never have to deactivate it, and you never put them in an
LR. Problem solved! ;-)

Alternative layout proposal for the ITS emulation case:

#define LR_IS_LPI	(1 << 4)

struct vgic_lr {
	union {
		unsigned lpi:24;
		unsigned spi:10;
		union {
			unsigned hwirq:10;
			unsigned source:8;
		};
	};
	unsigned state:5;
};

That gives you even more space than you had before.

Now, this is absolutely disgusting, of course. This whole intermediate
structure crap is completely getting out of control, and we should get
rid of it before we merge the ITS.

/me goes looking for a chainsaw...

	M.
-- 
Jazz is not dead. It just smells funny...
