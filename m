From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 10/12] KVM: arm/arm64: Add
 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION
Date: Tue, 24 Apr 2018 23:08:21 +0200
Message-ID: <20180424210821.GK4533@C02W217FHV2R.local>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
 <1523607658-9166-11-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523607658-9166-11-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org, andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 13, 2018 at 10:20:56AM +0200, Eric Auger wrote:
> This new attribute allows the userspace to set the base address
> of a reditributor region, relaxing the constraint of having all
> consecutive redistibutor frames contiguous.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h   | 7 ++++---
>  arch/arm64/include/uapi/asm/kvm.h | 7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 2ba95d6..11725bb 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -88,9 +88,10 @@ struct kvm_regs {
>  #define KVM_VGIC_V2_CPU_SIZE		0x2000
>  
>  /* Supported VGICv3 address types  */
> -#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
> -#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> -#define KVM_VGIC_ITS_ADDR_TYPE		4
> +#define KVM_VGIC_V3_ADDR_TYPE_DIST		2
> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST		3
> +#define KVM_VGIC_ITS_ADDR_TYPE			4

I think I'd prefer that we just leave these lines above as it's only and
indentation thing, and this is an exported header so will propagate into
userspace updates, but I don't have a strong feeling about it, nor do I
know if there's a general policy.

> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9abbf30..ef8ad3b 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -88,9 +88,10 @@ struct kvm_regs {
>  #define KVM_VGIC_V2_CPU_SIZE		0x2000
>  
>  /* Supported VGICv3 address types  */
> -#define KVM_VGIC_V3_ADDR_TYPE_DIST	2
> -#define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> -#define KVM_VGIC_ITS_ADDR_TYPE		4
> +#define KVM_VGIC_V3_ADDR_TYPE_DIST		2
> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST		3
> +#define KVM_VGIC_ITS_ADDR_TYPE			4
> +#define KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION	5
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> -- 
> 2.5.5
> 

Otherwise:

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
