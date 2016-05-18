From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 25/56] KVM: arm/arm64: vgic-new: Add ENABLE registers
 handlers
Date: Wed, 18 May 2016 16:14:44 +0200
Message-ID: <20160518141444.GC6666@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-26-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463392481-26583-26-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:13AM +0100, Andre Przywara wrote:
> As the enable register handlers are shared between the v2 and v3
> emulation, their implementation goes into vgic-mmio.c, to be easily
> referenced from the v3 emulation as well later.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
