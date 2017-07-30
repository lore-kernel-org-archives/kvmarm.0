From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH v2 04/38] KVM: arm/arm64: Check if nested
 virtualization is in use
Date: Sun, 30 Jul 2017 21:59:49 +0200
Message-ID: <20170730195949.GF5176@cbox>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
 <1500397144-16232-5-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D64649C2F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:58:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p4ylPcrjHGFZ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jul 2017 15:58:39 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61AFD40FAE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 15:58:39 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id t201so163271963wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jul 2017 12:59:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1500397144-16232-5-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack.lim@linaro.org>
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, marc.zyngier@arm.com, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 11:58:30AM -0500, Jintack Lim wrote:
> Nested virtualizaion is in use only if all three conditions are met:
> - The architecture supports nested virtualization.
> - The kernel parameter is set.
> - The userspace uses nested virtualiztion feature.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> ---
>  arch/arm/include/asm/kvm_host.h   | 11 +++++++++++
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/nested.c           | 17 +++++++++++++++++
>  virt/kvm/arm/arm.c                |  4 ++++
>  4 files changed, 34 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 00b0f97..7e9e6c8 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -303,4 +303,15 @@ static inline int __init kvmarm_nested_cfg(char *buf)
>  {
>  	return 0;
>  }
> +
> +static inline int init_nested_virt(void)
> +{
> +	return 0;
> +}
> +
> +static inline bool nested_virt_in_use(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 6df0c7c..86d4b6c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -387,5 +387,7 @@ static inline void __cpu_init_stage2(void)
>  }
>  
>  int __init kvmarm_nested_cfg(char *buf);
> +int init_nested_virt(void);
> +bool nested_virt_in_use(struct kvm_vcpu *vcpu);
>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 79f38da..9a05c76 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -24,3 +24,20 @@ int __init kvmarm_nested_cfg(char *buf)
>  {
>  	return strtobool(buf, &nested_param);
>  }
> +
> +int init_nested_virt(void)
> +{
> +	if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT))
> +		kvm_info("Nested virtualization is supported\n");
> +
> +	return 0;
> +}
> +
> +bool nested_virt_in_use(struct kvm_vcpu *vcpu)
> +{
> +	if (nested_param && cpus_have_const_cap(ARM64_HAS_NESTED_VIRT)
> +	    && test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features))
> +		return true;

you could initialize a bool in init_nested_virt which you then check
here to avoid duplicating the logic.

> +
> +	return false;
> +}
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 1c1c772..36aae3a 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1478,6 +1478,10 @@ int kvm_arch_init(void *opaque)
>  	if (err)
>  		goto out_err;
>  
> +	err = init_nested_virt();
> +	if (err)
> +		return err;
> +
>  	err = init_subsystems();
>  	if (err)
>  		goto out_hyp;
> -- 
> 1.9.1
> 
