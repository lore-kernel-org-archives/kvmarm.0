From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 24/56] KVM: arm/arm64: vgic-new: Add CTLR, TYPER and
 IIDR handlers
Date: Wed, 18 May 2016 14:33:37 +0200
Message-ID: <20160518123337.GF3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-25-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463392481-26583-25-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:12AM +0100, Andre Przywara wrote:
> From: Marc Zyngier <marc.zyngier@arm.com>
> 
> Those three registers are v2 emulation specific, so their implementation
> lives entirely in vgic-mmio-v2.c. Also they are handled in one function,
> as their implementation is pretty simple.
> When the guest enables the distributor, we kick all VCPUs to get
> potentially pending interrupts serviced.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
