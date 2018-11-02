From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH v2 18/23] KVM: arm64: Add arch vcpu ioctl hook
Date: Fri, 2 Nov 2018 09:30:39 +0100
Message-ID: <20181102083039.GT12057@e113682-lin.lund.arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
 <1538141967-15375-19-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E138B4A2EC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 04:30:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E2KP8bPuu9og for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Nov 2018 04:30:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 458814A262
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 04:30:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1538141967-15375-19-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 28, 2018 at 02:39:22PM +0100, Dave Martin wrote:
> To enable arm64-specific vcpu ioctls to be added cleanly, this
> patch adds a kvm_arm_arch_vcpu_ioctl() hook so that these don't
> pollute the common code.
> 
> No functional change: the -EINVAL return for unknown ioctls is
> retained, though it may or may not be intentional (KVM returns
> -ENXIO in various other similar contexts).
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 7 +++++++
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/guest.c            | 6 ++++++
>  virt/kvm/arm/arm.c                | 2 +-
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index c36760b..df2659d 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -19,6 +19,7 @@
>  #ifndef __ARM_KVM_HOST_H__
>  #define __ARM_KVM_HOST_H__
>  
> +#include <linux/errno.h>
>  #include <linux/types.h>
>  #include <linux/kvm_types.h>
>  #include <asm/cputype.h>
> @@ -278,6 +279,12 @@ static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	return 0;
>  }
>  
> +static inline int kvm_arm_arch_vcpu_ioctl(struct vcpu *vcpu,
> +	unsigned int ioctl, unsigned long arg)
> +{
> +	return -EINVAL;
> +}
> +
>  int kvm_perf_init(void);
>  int kvm_perf_teardown(void);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8e9cd43..bbde597 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -55,6 +55,8 @@ DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>  int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
> +int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
> +			    unsigned int ioctl, unsigned long arg);
>  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 89eab68..331b85e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -546,6 +546,12 @@ int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
>  	return 0;
>  }
>  
> +int kvm_arm_arch_vcpu_ioctl(struct kvm_vcpu *vcpu,
> +			    unsigned int ioctl, unsigned long arg)
> +{
> +	return -EINVAL;
> +}
> +
>  int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>  {
>  	return -EINVAL;
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 1418af9..6e894a8 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1181,7 +1181,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		return kvm_arm_vcpu_set_events(vcpu, &events);
>  	}
>  	default:
> -		r = -EINVAL;
> +		r = kvm_arm_arch_vcpu_ioctl(vcpu, ioctl, arg);

I don't like this additional indirection.  Is it just to avoid defining
the SVE ioctl value on 32-bit ARM?

I think you should just handle the ioctl here and return an error on the
32-bit side, like we do for other things.

Am I missing something?


Thanks,

    Christoffer

>  	}
>  
>  	return r;
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
