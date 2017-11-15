From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 33/37] KVM: arm/arm64: Move arm64-only vgic-v2-sr.c file
 to arm64
Date: Wed, 15 Nov 2017 17:52:06 +0000
Message-ID: <4da8d7ff-28ac-2945-7376-7d0b91e0a018@arm.com>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-34-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BA6049D1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 12:49:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MRzkgJZKWTpa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Nov 2017 12:49:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6698740795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Nov 2017 12:49:54 -0500 (EST)
In-Reply-To: <20171012104141.26902-34-christoffer.dall@linaro.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 12/10/17 11:41, Christoffer Dall wrote:
> The vgic-v2-sr.c file now only contains the logic to replay unaligned
> accesses to the virtual CPU interface on 16K and 64K page systems, which
> is only relevant on 64-bit platforms.  Therefore move this file to the
> arm64 KVM tree, remove the compile directive from the 32-bit side
> makefile, and remove the ifdef in the C file.

I like that one!

> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  arch/arm/kvm/hyp/Makefile                         | 1 -
>  arch/arm64/kvm/hyp/Makefile                       | 2 +-
>  {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c | 2 --
>  3 files changed, 1 insertion(+), 4 deletions(-)
>  rename {virt/kvm/arm => arch/arm64/kvm}/hyp/vgic-v2-sr.c (98%)
> 
> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
> index 8679405..4be5061 100644
> --- a/arch/arm/kvm/hyp/Makefile
> +++ b/arch/arm/kvm/hyp/Makefile
> @@ -6,7 +6,6 @@ ccflags-y += -fno-stack-protector
>  
>  KVM=../../../../virt/kvm
>  
> -obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
>  
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 14c4e3b..b746fa5 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -6,10 +6,10 @@ ccflags-y += -fno-stack-protector
>  
>  KVM=../../../../virt/kvm
>  
> -obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
>  
> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += entry.o
> diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> similarity index 98%
> rename from virt/kvm/arm/hyp/vgic-v2-sr.c
> rename to arch/arm64/kvm/hyp/vgic-v2-sr.c
> index b433257..fcd7b4e 100644
> --- a/virt/kvm/arm/hyp/vgic-v2-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> @@ -22,7 +22,6 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
> -#ifdef CONFIG_ARM64
>  /*
>   * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
>   *				     guest.
> @@ -76,4 +75,3 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
>  
>  	return 1;
>  }
> -#endif
> 
