From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 1/3] arm64: kvm: support user space to detect RAS
 extension feature
Date: Mon, 3 Jul 2017 10:21:26 +0200
Message-ID: <20170703082126.GC4066@cbox>
References: <1498481143-23183-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EFB240A86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:21:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJvTvmBBBPnG for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 04:21:11 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAC7840190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 04:21:11 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id 62so160892959wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 01:21:30 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1498481143-23183-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: corbet@lwn.net, wuquanming@huawei.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, linux@armlinux.org.uk, huangshaoyu@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 26, 2017 at 08:45:43PM +0800, Dongjiu Geng wrote:
> Handle userspace's detection for RAS extension, because sometimes
> the userspace needs to know the CPU's capacity

Why?  Can you please provide some more rationale.

> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  arch/arm64/kvm/reset.c   | 11 +++++++++++
>  include/uapi/linux/kvm.h |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index d9e9697..1004039 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -64,6 +64,14 @@ static bool cpu_has_32bit_el1(void)
>  	return !!(pfr0 & 0x20);
>  }
>  
> +static bool kvm_arm_support_ras_extension(void)
> +{
> +	u64 pfr0;
> +
> +	pfr0 = read_system_reg(SYS_ID_AA64PFR0_EL1);
> +	return !!(pfr0 & 0x10000000);
> +}

Why is this specific to KVM?  This seems to reveal information about the
underlying physical CPU, not specific to KVM at all, surely if userspace
is really supposed to be able to figure this out, it should not be KVM
specific.

Thanks,
-Christoffer

> +
>  /**
>   * kvm_arch_dev_ioctl_check_extension
>   *
> @@ -87,6 +95,9 @@ int kvm_arch_dev_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_PMU_V3:
>  		r = kvm_arm_support_pmu_v3();
>  		break;
> +	case KVM_CAP_ARM_RAS_EXTENSION:
> +		r = kvm_arm_support_ras_extension();
> +		break;
>  	case KVM_CAP_SET_GUEST_DEBUG:
>  	case KVM_CAP_VCPU_ATTRIBUTES:
>  		r = 1;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f51d508..27fe556 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -883,6 +883,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_MMU_RADIX 134
>  #define KVM_CAP_PPC_MMU_HASH_V3 135
>  #define KVM_CAP_IMMEDIATE_EXIT 136
> +#define KVM_CAP_ARM_RAS_EXTENSION 137
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.10.1
> 
