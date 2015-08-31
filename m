From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm64: Decode basic HYP fault information
Date: Mon, 31 Aug 2015 12:59:31 +0300
Message-ID: <016901d0e3d3$bba98cc0$32fca640$@samsung.com>
References: <00aa01d0d408$1ba96ea0$52fc4be0$@samsung.com>
 <20150830174434.GG24113@cbox> <012d01d0e3b6$fa327c30$ee977490$@samsung.com>
 <20150831094927.GL24113@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150831094927.GL24113@cbox>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Fundamentally what's changed is that you now run more custom code in C
> code.

 Yes, but it doesn't do anything super-dupper, just decodes some values into a human-readable form.

 and i forgot this note...

>> -
>> -	.align	3
>> -2:	.quad	HYP_PAGE_OFFSET
>> -	.quad	PAGE_OFFSET

> why can you get rid of this?

 Because i was used only to translate base address of text message, which moved to C code.

> I'll think about it.

 Ok.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia

