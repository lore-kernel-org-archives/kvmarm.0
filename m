From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 05/12] KVM: arm64: introduce ITS emulation file with
 stub functions
Date: Tue, 5 Apr 2016 18:03:52 +0200
Message-ID: <5703E1E8.6000307@linaro.org>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-6-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF9F407A0
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 12:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LYnqirXuzdtj for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Apr 2016 12:03:48 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E806B4053F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 12:03:47 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id l6so30087112wml.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Apr 2016 09:05:06 -0700 (PDT)
In-Reply-To: <1458958450-19662-6-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 03/26/2016 03:14 AM, Andre Przywara wrote:
> The ARM GICv3 ITS emulation code goes into a separate file, but
> needs to be connected to the GICv3 emulation, of which it is an
> option.
> Introduce the skeleton with function stubs to be filled later.
> Introduce the basic ITS data structure and initialize it, but don't
> return any success yet, as we are not yet ready for the show.
This patch also partially implements GICR_CTLR.Enable LPI
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm64/kvm/Makefile            |  1 +
>  include/kvm/vgic/vgic.h            |  6 +++
>  include/linux/irqchip/arm-gic-v3.h |  1 +
>  virt/kvm/arm/vgic/its-emul.c       | 84 ++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h           | 14 +++++++
>  virt/kvm/arm/vgic/vgic_init.c      |  6 +++
>  virt/kvm/arm/vgic/vgic_mmio.c      | 18 ++++++--
>  7 files changed, 126 insertions(+), 4 deletions(-)
>  create mode 100644 virt/kvm/arm/vgic/its-emul.c
> 
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 2f5d431..3bec10e 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -28,6 +28,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_mmio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_kvm_device.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/its-emul.o
>  else
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 8ea5dd7..c79bed5 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -112,6 +112,11 @@ struct vgic_io_device {
>  	struct kvm_io_device dev;
>  };
>  
> +struct vgic_its {
> +	bool			enabled;
> +	spinlock_t		lock;
> +};
> +
>  struct vgic_dist {
>  	bool			in_kernel;
>  	bool			ready;
> @@ -153,6 +158,7 @@ struct vgic_dist {
>  	u64			*pendbaser;
>  
>  	bool			lpis_enabled;
> +	struct vgic_its		its;
>  };
>  
>  struct vgic_v2_cpu_if {
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index d5d798b..a813c3e 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -177,6 +177,7 @@
>  #define GITS_CWRITER			0x0088
>  #define GITS_CREADR			0x0090
>  #define GITS_BASER			0x0100
> +#define GITS_IDREGS_BASE		0xffd0
>  #define GITS_PIDR2			GICR_PIDR2
>  
>  #define GITS_TRANSLATER			0x10040
> diff --git a/virt/kvm/arm/vgic/its-emul.c b/virt/kvm/arm/vgic/its-emul.c
> new file mode 100644
> index 0000000..49dd5e4
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/its-emul.c
> @@ -0,0 +1,84 @@
> +/*
> + * GICv3 ITS emulation
> + *
> + * Copyright (C) 2015 ARM Ltd.
> + * Author: Andre Przywara <andre.przywara@arm.com>
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
> +#include <linux/cpu.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/interrupt.h>
> +
> +#include <linux/irqchip/arm-gic-v3.h>
> +
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_mmu.h>
> +
> +#include "vgic.h"
> +#include "vgic_mmio.h"
> +
> +struct vgic_register_region its_registers[] = {
> +	REGISTER_DESC_WITH_LENGTH(GITS_CTLR,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +	REGISTER_DESC_WITH_LENGTH(GITS_IIDR,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
> +	REGISTER_DESC_WITH_LENGTH(GITS_TYPER,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
64bit register with upper 32b reserved. confusing at first sight ;-)
> +	REGISTER_DESC_WITH_LENGTH(GITS_CBASER,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +	REGISTER_DESC_WITH_LENGTH(GITS_CWRITER,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +	REGISTER_DESC_WITH_LENGTH(GITS_CREADR,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
> +	REGISTER_DESC_WITH_LENGTH(GITS_BASER,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x40),
> +	REGISTER_DESC_WITH_LENGTH(GITS_IDREGS_BASE,
> +		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x30),
> +};
> +
> +/* This is called on setting the LPI enable bit in the redistributor. */
> +void vgic_enable_lpis(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +int vits_init(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_its *its = &dist->its;
> +	struct vgic_io_device *regions;
> +	int ret, i;
> +
> +	spin_lock_init(&its->lock);
> +
> +	regions = kmalloc_array(ARRAY_SIZE(its_registers),
> +				sizeof(struct vgic_io_device), GFP_KERNEL);
need to handle ENOMEM case
> +
> +	for (i = 0; i < ARRAY_SIZE(its_registers); i++) {
> +		regions[i].base_addr = dist->vgic_its_base;
> +
> +		ret = kvm_vgic_register_mmio_region(kvm, NULL,
> +						    &its_registers[i],
> +						    &regions[i], 0, false);
shouldn't we stop on the first fail and unregister what was previously
registered?
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	its->enabled = false;
> +
> +	return -ENXIO;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index db9dfd7..4e7dcb8 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -60,6 +60,9 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
>  int vgic_v3_probe(struct device_node *vgic_node);
>  int vgic_v3_map_resources(struct kvm *kvm);
>  int vgic_register_redist_regions(struct kvm *kvm, gpa_t dist_base_address);
> +
> +int vits_init(struct kvm *kvm);
> +void vgic_enable_lpis(struct kvm_vcpu *vcpu);
>  #else
>  static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
>  					       u64 mpidr)
> @@ -124,6 +127,16 @@ static inline int vgic_register_redist_regions(struct kvm *kvm,
>  {
>  	return -ENODEV;
>  }
> +
> +int vits_init(struct kvm *kvm)
> +{
> +	return 0;
> +}
> +
> +static inline void vgic_enable_lpis(struct kvm_vcpu *vcpu)
> +{
> +	return;
> +}
>  #endif
>  
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> @@ -131,6 +144,7 @@ void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
> +int vits_init(struct kvm *kvm);
>  void kvm_register_vgic_device(unsigned long type);
>  
>  #endif
> diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
> index 2301e03..dcfb93d 100644
> --- a/virt/kvm/arm/vgic/vgic_init.c
> +++ b/virt/kvm/arm/vgic/vgic_init.c
> @@ -252,6 +252,12 @@ int vgic_init(struct kvm *kvm)
>  	if (ret)
>  		goto out;
>  
> +	if (vgic_has_its(kvm)) {
> +		ret = vits_init(kvm);
> +		if (ret)
> +			goto out;
> +	}
> +
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		kvm_vgic_vcpu_init(vcpu);
>  
> diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
> index 252b9aff..086555e 100644
> --- a/virt/kvm/arm/vgic/vgic_mmio.c
> +++ b/virt/kvm/arm/vgic/vgic_mmio.c
> @@ -726,16 +726,26 @@ static int vgic_mmio_read_v3r_misc(struct kvm_vcpu *vcpu,
>  				   struct kvm_io_device *this,
>  				   gpa_t addr, int len, void *val)
>  {
> -	/* TODO: implement for ITS support */
> -	return vgic_mmio_read_raz(vcpu, this, addr, len, val);
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u32 reg = dist->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
> +
> +	write_mask32(reg, addr & 3, len, val);
> +	return 0;
>  }
>  
>  static int vgic_mmio_write_v3r_misc(struct kvm_vcpu *vcpu,
>  				    struct kvm_io_device *this,
>  				    gpa_t addr, int len, const void *val)
>  {
> -	/* TODO: implement for ITS support */
> -	return vgic_mmio_write_wi(vcpu, this, addr, len, val);
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +	u32 reg = mask32(!!dist->lpis_enabled, addr & 3, len, val);
lpis_enabled is a bool
> +
> +	if (vgic_has_its(vcpu->kvm) && !dist->lpis_enabled &&
> +	    (reg & GICR_CTLR_ENABLE_LPIS)) {
> +		/* Eventually do something */
Looks strange to me to not set/reset dist->lpis_enabled according to the
write val at least, to make things symetrical.

Cheers

Eric
> +	}
> +
> +	return 0;
>  }
>  
>  static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
> 
