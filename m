From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 1/3] arm/arm64: KVM: vgic: Check for !irqchip_in_kernel()
 when mapping resources
Date: Thu, 24 Sep 2015 14:33:19 +0300
Message-ID: <169201d0f6bc$d03df3f0$70b9dbd0$@samsung.com>
References: <1442419087-24648-1-git-send-email-marc.zyngier@arm.com>
 <1442419087-24648-2-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1442419087-24648-2-git-send-email-marc.zyngier@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: 'Christoffer Dall' <christoffer.dall@linaro.org>, =?utf-8?Q?'Alex_Benn=C3=A9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Until b26e5fdac43c ("arm/arm64: KVM: introduce per-VM ops"),
> kvm_vgic_map_resources() used to include a check on irqchip_in_kernel(),
> and vgic_v2_map_resources() still has it.

 I'm back from vacation and very glad to see myself being useful :)
 What's with the rest of that patch set? Does it need rebase or what ?
 By the way, after this is applied, we can drop useless check inside vgic_v2_map_resources(). 

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


