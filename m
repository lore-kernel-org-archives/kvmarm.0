From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 46/54] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Tue, 3 May 2016 11:21:36 +0100
Message-ID: <57287BB0.7000709@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-47-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-47-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 28/04/16 17:46, Andre Przywara wrote:
> Using the VMCR accessors we provide access to GIC CPU interface state
> to userland by wiring it up to the existing userland interface.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 72 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 38260ae..eaf5c1d 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -17,8 +17,11 @@
>  #include <kvm/vgic/vgic.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm_mmu.h>
> +#include <linux/irqchip/arm-gic.h>
>  #include "vgic.h"
>  
> +#define GICC_ARCH_VERSION_V2		0x2
> +
>  /* common helpers */
>  
>  static int vgic_ioaddr_overlap(struct kvm *kvm)
> @@ -252,6 +255,69 @@ void kvm_register_vgic_device(unsigned long type)
>  	}
>  }
>  
> +static u32 vgic_read_vcpuif(struct kvm_vcpu *vcpu, int offset)
> +{
> +	struct vgic_vmcr vmcr;
> +	u32 *field;
> +
> +	switch (offset) {
> +	case GIC_CPU_CTRL:
> +		field = &vmcr.ctlr;
> +		break;
> +	case GIC_CPU_PRIMASK:
> +		field = &vmcr.pmr;
> +		break;
> +	case GIC_CPU_BINPOINT:
> +		field = &vmcr.bpr;
> +		break;
> +	case GIC_CPU_ALIAS_BINPOINT:
> +		field = &vmcr.abpr;
> +		break;
> +	case GIC_CPU_IDENT:
> +		return (PRODUCT_ID_KVM << 20) |
> +		       (GICC_ARCH_VERSION_V2 << 16) |
> +		       (IMPLEMENTER_ARM << 0);
> +	default:
> +		return 0;
> +	}
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +
> +	return *field;
> +}
> +
> +static bool vgic_write_vcpuif(struct kvm_vcpu *vcpu, int offset, u32 value)
> +{
> +	struct vgic_vmcr vmcr;
> +	u32 *field;
> +
> +	switch (offset) {
> +	case GIC_CPU_CTRL:
> +		field = &vmcr.ctlr;
> +		break;
> +	case GIC_CPU_PRIMASK:
> +		field = &vmcr.pmr;
> +		break;
> +	case GIC_CPU_BINPOINT:
> +		field = &vmcr.bpr;
> +		break;
> +	case GIC_CPU_ALIAS_BINPOINT:
> +		field = &vmcr.abpr;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (*field == value)
> +		return false;
> +
> +	*field = value;
> +	vgic_set_vmcr(vcpu, &vmcr);
> +
> +	return true;
> +}
> +
>  /** vgic_attr_regs_access: allows user space to read/write VGIC registers
>   *
>   * @dev: kvm device handle
> @@ -300,7 +366,11 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
>  
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
> -		ret = -EINVAL;
> +		ret = 0;
> +		if (is_write)
> +			vgic_write_vcpuif(vcpu, addr, *reg);
> +		else
> +			*reg = vgic_read_vcpuif(vcpu, addr);
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>  		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
> 

Shouldn't we have this implemented as an MMIO table, and moved to the
vgic-v2-mmio.c file?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
