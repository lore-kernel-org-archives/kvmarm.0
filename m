From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 12/55] KVM: arm/arm64: move GICv2 emulation defines
 into arm-gic-v3.h
Date: Tue, 10 May 2016 10:02:50 +0100
Message-ID: <5731A3B9.4090505@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-13-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-13-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> As (some) GICv3 hosts can emulate a GICv2, some GICv2 specific masks
> for the list register definition also apply to GICv3 LRs.
> At the moment we have those definitions in the KVM VGICv3
> implementation, so let's move them into the GICv3 header file to
> have them automatically defined.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
