From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Fri, 09 Oct 2015 09:29:35 +0100
Message-ID: <56177AEF.50304@arm.com>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org> <00e601d10264$61cdafb0$25690f10$@samsung.com> <56177592.2080702@arm.com> <00ec01d10269$f6c82af0$e45880d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00ec01d10269$f6c82af0$e45880d0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, 'Andre Przywara' <andre.przywara@arm.com>, 'Peter Maydell' <peter.maydell@linaro.org>, 'Eric Auger' <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/10/15 09:10, Pavel Fedin wrote:
>  Hello!
> 
>> How do you reconcile the two? What's the point of trying to shoehorn a
>> different concept into the existing API?
> 
>  Keeping amount of #define's as small as possible, and try to reuse everything that can be reused.

Reusing existing code is a noble goal, but I think that having clear
abstractions and following the architecture trumps it completely.

Experience has shown that trying to be clever with userspace interfaces
comes and bites us in the rear sooner or later. Not enough bits, being
unable to represent valid architecture features, pointlessly complicated
code that is hard to maintain. Those are the things I care about today.

So a #define is completely free, additional code is still very cheap. My
brain cells are few, and I like to look at the code and get this warm
fuzzy feeling that it is doing the right thing.

Having separate interfaces for different devices is a very good way to
ensure the above.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
