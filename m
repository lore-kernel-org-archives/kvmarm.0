From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 21/54] KVM: arm/arm64: vgic-new: Add GICv2 MMIO
 handling framework
Date: Tue, 3 May 2016 16:32:51 +0100
Message-ID: <5728C4A3.10708@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-22-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-22-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:45, Andre Przywara wrote:
> Create vgic-mmio-v2.c to describe GICv2 emulation specific handlers
> using the initializer macros provided by the VGIC MMIO framework.
> Provide a function to register the GICv2 distributor registers to
> the kvm_io_bus framework.
> The actual handler functions are still stubs in this patch.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
> Changelog v1 .. v2:
> - new patch, split out from the generic MMIO framework patch
> - use a separate file to hold GICv2 emulation specific handlers
> - replace _nyi stub functions with raz/wi versions
> 
>  virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.c    | 26 +++++++++++++++++
>  virt/kvm/arm/vgic/vgic-mmio.h    |  2 ++
>  3 files changed, 90 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v2.c
> 
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> new file mode 100644
> index 0000000..afee778
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -0,0 +1,62 @@
> +/*
> + * VGICv2 MMIO handling functions
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
> +#include <linux/irqchip/arm-gic.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/iodev.h>
> +#include <kvm/vgic/vgic.h>

Please use kvm/arm_vgic.h so that it doesn't break once we rename
kvm/vgic/vgic.h.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
