From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 1/4] KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq
Date: Sat, 02 Sep 2017 12:13:30 +0100
Message-ID: <863785uzdx.fsf@arm.com>
References: <20170829093902.15379-1-cdall@linaro.org>
        <20170829093902.15379-2-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170829093902.15379-2-cdall@linaro.org> (Christoffer Dall's
        message of "Tue, 29 Aug 2017 11:38:59 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 29 2017 at 11:38:59 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> We want to reuse the core of the map/unmap functions for IRQ forwarding.
> Let's move the computation of the hwirq in kvm_vgic_map_phys_irq and
> pass the linux IRQ as parameter.
>
> The host_irq is added to struct vgic_irq because it is needed in later
> patches which manipulate the physical GIC state to support forwarded
> IRQs.
>
> We introduce kvm_vgic_map/unmap_irq which take a struct vgic_irq handle
> as a parameter.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
