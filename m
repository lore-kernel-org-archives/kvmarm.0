From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 16/55] KVM: arm/arm64: vgic-new: Add IRQ sorting
Date: Tue, 10 May 2016 10:48:16 +0100
Message-ID: <5731AE60.40905@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-17-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-17-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Adds the sorting function to cover the case where you have more IRQs
> to consider than you have LRs. We now consider priorities.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
