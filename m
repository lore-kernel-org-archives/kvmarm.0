From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 53/55] KVM: arm/arm64: vgic-new: Wire up irqfd
 injection
Date: Thu, 12 May 2016 21:33:47 +0200
Message-ID: <20160512193347.GT27623@cbox>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
 <1462531568-9799-54-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462531568-9799-54-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 06, 2016 at 11:46:06AM +0100, Andre Przywara wrote:
> Connect to the new VGIC to the irqfd framework, so that we can
> inject IRQs.
> GSI routing and MSI routing is not yet implemented.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-irqfd.c | 52 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-irqfd.c
> 
> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
> new file mode 100644
> index 0000000..c675513
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
> @@ -0,0 +1,52 @@
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
> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip,
> +			 unsigned int pin)
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
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
