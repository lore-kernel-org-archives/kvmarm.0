From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: move GICv2 emulation defines into
 arm-gic-v3.h
Date: Wed, 4 May 2016 15:28:25 +0100
Message-ID: <572A0709.9070000@arm.com>
References: <5729FF19.3030205@arm.com>
 <1462371689-26046-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462371689-26046-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/05/16 15:21, Andre Przywara wrote:
> As (some) GICv3 hosts can emulate a GICv2, some GICv2 specific masks
> for the list register definition also apply to GICv3 LRs.
> At the moment we have those definitions in the KVM VGICv3
> implementation, so let's move them into the GICv3 header file to
> have them automatically defined.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.

> ---
> ... and then just remove the #include <arm-gic.h> from vgic/vgic-v3.c.
> 
> Does that make sense?

Definitely.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
