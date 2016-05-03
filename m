From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 32/54] KVM: arm/arm64: vgic-new: Add GICv3 MMIO
 handling framework
Date: Tue, 3 May 2016 16:34:32 +0100
Message-ID: <5728C508.7060406@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-33-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-33-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:45, Andre Przywara wrote:
> Create a new file called vgic-mmio-v3.c and describe the GICv3
> distributor and redistributor registers there.
> This adds a special macro to deal with the split of SGI/PPI in the
> redistributor and SPIs in the distributor, which allows us to reuse
> the existing GICv2 handlers for those registers which are compatible.
> Also we provide a function to deal with the registration of the two
> separate redistributor frames per VCPU.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - adapt to new MMIO registration approach:
>   register one device for the distributor and two for each VCPU
> - implement special handling for private interrupts
> - remove empty stub functions
> - make IGROUPR return RAO
> 
> Changelog v1 .. v2:
> - adapt to new framework, introduce vgic-mmio-v3.c
> - remove userland register access functions (for now)
> - precompute .len when describing a VGIC register
> - add missed pointer incrementation on registering redist regions
> - replace _nyi stub functions with raz/wi versions
> 
>  virt/kvm/arm/vgic/vgic-mmio-v3.c | 191 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c    |   5 +
>  virt/kvm/arm/vgic/vgic-mmio.h    |   2 +
>  virt/kvm/arm/vgic/vgic.h         |   3 +
>  4 files changed, 201 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> new file mode 100644
> index 0000000..c6765d4
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -0,0 +1,191 @@
> +/*
> + * VGICv3 MMIO handling functions
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/iodev.h>
> +#include <kvm/vgic/vgic.h>

Same remark about the use of this include file instead of kvm/arm_vgic.h.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
