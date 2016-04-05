From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 02/12] KVM: arm/arm64: extend arch CAP checks to allow
 per-VM capabilities
Date: Tue, 5 Apr 2016 14:48:02 +0200
Message-ID: <5703B402.5070409@linaro.org>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <1458958450-19662-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC4E40F90
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 08:47:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p86iOQWv1cuK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Apr 2016 08:47:58 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD35740402
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Apr 2016 08:47:58 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id u206so2762307wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Apr 2016 05:49:17 -0700 (PDT)
In-Reply-To: <1458958450-19662-3-git-send-email-andre.przywara@arm.com>
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

On 03/26/2016 03:14 AM, Andre Przywara wrote:
> KVM capabilities can be a per-VM property, though ARM/ARM64 currently
> does not pass on the VM pointer to the architecture specific
> capability handlers.
> Add a "struct kvm*" parameter to those function to later allow proper
> per-VM capability reporting.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h   | 2 +-
>  arch/arm/kvm/arm.c                | 2 +-
>  arch/arm64/include/asm/kvm_host.h | 2 +-
>  arch/arm64/kvm/reset.c            | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 3850701..494b004 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -265,7 +265,7 @@ static inline void __cpu_init_stage2(void)
>  	kvm_call_hyp(__init_stage2_translation);
>  }
>  
> -static inline int kvm_arch_dev_ioctl_check_extension(long ext)
> +static inline int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
>  	return 0;
>  }
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 5b9d9e3..e2e9be2 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -205,7 +205,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_MAX_VCPUS;
>  		break;
>  	default:
> -		r = kvm_arch_dev_ioctl_check_extension(ext);
> +		r = kvm_arch_dev_ioctl_check_extension(kvm, ext);
>  		break;
>  	}
>  	return r;
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 71fa6fe..2cdd7ae 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -46,7 +46,7 @@
>  
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> -int kvm_arch_dev_ioctl_check_extension(long ext);
> +int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext);
>  
>  struct kvm_arch {
>  	/* The VMID generation used for the virt. memory system */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 9677bf0..2ba7c8d 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -63,7 +63,7 @@ static bool cpu_has_32bit_el1(void)
>   * We currently assume that the number of HW registers is uniform
>   * across all CPUs (see cpuinfo_sanity_check).
>   */
> -int kvm_arch_dev_ioctl_check_extension(long ext)
> +int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
>  	int r;
>  
> 
