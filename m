From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Mon, 12 Oct 2015 18:18:39 +0300
Message-ID: <00dc01d10501$46352810$d29f7830$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
 <20151010153744.GH29128@cbox> <561BBFC1.4070200@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <561BBFC1.4070200@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Andre Przywara' <andre.przywara@arm.com>, 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, eric.auger@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> Also what is the status of Eric's IRQ routing support? Should this go in
> first now?

 I'd say without vITS there's nothing to use IRQ routing with. It could go in and just lay around
silently, so that it's not forgotten, but for example current qemu just knows that with GICv2m it
should use hardcoded linear MSI->SPI mapping.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


