From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 13/55] KVM: arm/arm64: vgic-new: Add data structure
 definitions
Date: Tue, 10 May 2016 10:05:30 +0100
Message-ID: <5731A45A.7040309@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-14-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-14-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06/05/16 11:45, Andre Przywara wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Add a new header file for the new and improved GIC implementation.
> The big change is that we now have a struct vgic_irq per IRQ instead
> of spreading all the information over various bitmaps.
> 
> We include this new header conditionally from within the old header
> file for the time being to avoid touching all the users.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
