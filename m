From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 09/11] KVM: arm/arm64: vgic: Prevent userspace
 injection of a mapped interrupt
Date: Tue, 11 Aug 2015 00:44:40 -0700
Message-ID: <20150811074440.GD5007@lvm>
References: <1438962347-17541-1-git-send-email-marc.zyngier@arm.com>
 <1438962347-17541-10-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438962347-17541-10-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@linaro.org>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 07, 2015 at 04:45:45PM +0100, Marc Zyngier wrote:
> Virtual interrupts mapped to a HW interrupt should only be triggered
> from inside the kernel. Otherwise, you could end up confusing the
> kernel (and the GIC's) state machine.
> 
> Rearrange the injection path so that kvm_vgic_inject_irq is
> used for non-mapped interrupts, and kvm_vgic_inject_mapped_irq is
> used for mapped interrupts. The latter should only be called from
> inside the kernel (timer, irqfd).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
