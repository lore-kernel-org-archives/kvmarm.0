From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 03/12] KVM: arm64: Introduce new MMIO region for the
 ITS base address
Date: Thu, 7 Apr 2016 14:44:45 +0100
Message-ID: <5706644D.5020703@arm.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-4-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E6540F90
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 09:43:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cnpk0yspEGUy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 09:43:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B12D40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 09:43:25 -0400 (EDT)
In-Reply-To: <1458958450-19662-4-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 26/03/16 02:14, Andre Przywara wrote:
> The ARM GICv3 ITS controller requires a separate register frame to
> cover ITS specific registers. Add a new VGIC address type and store
> the address in a field in the vgic_dist structure.
> Provide a function to check whether userland has provided the address,
> so ITS functionality can be guarded by that check.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/devices/arm-vgic.txt |  9 +++++++++
>  arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>  include/kvm/vgic/vgic.h                        |  5 +++++
>  virt/kvm/arm/vgic/vgic.c                       | 10 ++++++++++
>  virt/kvm/arm/vgic/vgic_init.c                  |  1 +
>  virt/kvm/arm/vgic/vgic_kvm_device.c            |  7 +++++++
>  6 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> index 59541d4..087e2d9 100644
> --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> @@ -39,6 +39,15 @@ Groups:
>        Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
>        This address needs to be 64K aligned.
>  
> +    KVM_VGIC_V3_ADDR_TYPE_ITS (rw, 64-bit)
> +      Base address in the guest physical address space of the GICv3 ITS
> +      control register frame. The ITS allows MSI(-X) interrupts to be
> +      injected into guests. This extension is optional, if the kernel
> +      does not support the ITS, the call returns -ENODEV.
> +      This memory is solely for the guest to access the ITS control
> +      registers and does not cover the ITS translation register.
> +      Only valid for KVM_DEV_TYPE_ARM_VGIC_V3.
> +      This address needs to be 64K aligned and the region covers 64 KByte.
>  
>    KVM_DEV_ARM_VGIC_GRP_DIST_REGS
>    Attributes:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f209ea1..c2b257d 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -87,9 +87,11 @@ struct kvm_regs {
>  /* Supported VGICv3 address types  */
>  #define KVM_VGIC_V3_ADDR_TYPE_DIST	2
>  #define KVM_VGIC_V3_ADDR_TYPE_REDIST	3
> +#define KVM_VGIC_V3_ADDR_TYPE_ITS	4
>  
>  #define KVM_VGIC_V3_DIST_SIZE		SZ_64K
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
> +#define KVM_VGIC_V3_ITS_SIZE		SZ_64K
>  
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 7c1d145..11344e6 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -135,6 +135,9 @@ struct vgic_dist {
>  		gpa_t			vgic_redist_base;
>  	};
>  
> +	/* The base address of the ITS control register frame */
> +	gpa_t			vgic_its_base;
> +

This makes me cringe a bit. The ITS is not part of the distributor, so
having it in vgic_dist is a bit weird. But maybe it is vgic_dist that
has the wrong name, and it is really a bag of vgic-related information.

But my real worry is that this (and the code below) only allows a single
ITS per VM. Is it really what we want? I would have thought that using
the KVM IO bus abstraction would have given us the flexibility of adding
ITSs at will (all sharing the same LPI space).

The reason this is important is that we could want an ITS serving
emulated devices, and one doing direct interrupt injection (once we have
GICv4 support).

Thoughts?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
