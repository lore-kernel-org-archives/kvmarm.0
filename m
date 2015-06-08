From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 00/13] arm64: KVM: GICv3 ITS emulation
Date: Mon, 08 Jun 2015 13:54:09 +0300
Message-ID: <02ae01d0a1d9$732d2ce0$598786a0$@samsung.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
 <01ad01d0a1b7$d4d4fe40$7e7efac0$@samsung.com> <557550F0.5070106@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <557550F0.5070106@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <Andre.Przywara@arm.com>, christoffer.dall@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hi!

> I'm afraid this is not enough. A write to GICR_TRANSLATER (DID+EID)
> results in a (LPI,CPU) pair. Can you easily express the CPU part in
> irqfd (this is a genuine question, I'm not familiar enough with that
> part of the core)?

 But... As far as i could understand, LPI is added to a collection as a part of setup. And
collection actually represents a destination CPU, doesn't it? And we can't have multiple
LPIs sharing the same number and going to different CPUs. Or am i wrong? Unfortunately i
don't have GICv3 arch reference manual.

> Another concern
> would be the support of GICv4, which relies on the command queue
> handling to be handled in the kernel

 Wow, i didn't know about GICv4.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


