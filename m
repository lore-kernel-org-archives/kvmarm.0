From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 44/45] KVM: arm/arm64: vgic-new: Add dummy MSI
 implementation
Date: Thu, 31 Mar 2016 20:16:56 +0200
Message-ID: <20160331181656.GH4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-45-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-45-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:05:07AM +0000, Andre Przywara wrote:
> Although we don't provide any virtual MSI functionality yet, we
> need to implement the functions required by the KVM interface.

I don't feel like this commit text accurately describes what's happening
in the code?

This seems to be about irqfds which work just fine on a GICv2m guest?

Thanks,
-Christoffer

> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic_irqfd.c | 51 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic_irqfd.c
> 
> diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
> new file mode 100644
> index 0000000..3eee1bd
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic_irqfd.c
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <trace/events/kvm.h>
> +
> +int kvm_irq_map_gsi(struct kvm *kvm,
> +		    struct kvm_kernel_irq_routing_entry *entries,
> +		    int gsi)
> +{
> +	return 0;
> +}
> +
> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
> +{
> +	return pin;
> +}
> +
> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
> +		u32 irq, int level, bool line_status)
> +{
> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
> +
> +	trace_kvm_set_irq(irq, level, irq_source_id);
> +
> +	BUG_ON(!vgic_initialized(kvm));
> +
> +	return kvm_vgic_inject_irq(kvm, 0, spi, level);
> +}
> +
> +/* MSI not implemented yet */
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +		struct kvm *kvm, int irq_source_id,
> +		int level, bool line_status)
> +{
> +	return 0;
> +}
> -- 
> 2.7.3
> 
