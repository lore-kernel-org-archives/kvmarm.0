From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 16:11:33 +0300
Message-ID: <011d01d0e000$bbbd94d0$3338be70$@samsung.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
 <20150826092721.43e8cbfd@arm.com>
 <00d701d0dfee$2f464810$8dd2d830$@samsung.com> <55DD9F5B.4080602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <55DD9F5B.4080602@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>, =?ISO-8859-1?Q?'Alex_Benn=E9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Sorry, but I don't really want to introduce another bug
> in the VGIC code (we have too many already). And what you're suggesting
> is to actually introduce a bug.

 Another, alternate idea...
 So far, we have a situation when empty LR, containing only LR_INT_EOI bit, is queued. Can we say
that this is wrong?
 If you agree, may be do something else instead? May be we should cancel such "ghost" interrupts
early, avoiding immediate and completely unnecessary maintenance interrupts upon guest entry?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


