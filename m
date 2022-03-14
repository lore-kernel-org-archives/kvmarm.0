Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF133C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 19:45:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5589E40C67;
	Mon, 14 Mar 2022 15:45:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mhY6k-6CPyWz; Mon, 14 Mar 2022 15:45:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B3843479;
	Mon, 14 Mar 2022 15:45:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0F740D01
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 15:45:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJgQI5mI3LA1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 15:45:29 -0400 (EDT)
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com
 [209.85.166.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CFEE40C67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 15:45:29 -0400 (EDT)
Received: by mail-il1-f176.google.com with SMTP id b14so11816625ilf.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 12:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BWFI5h416BXkQSSoLp6it0M+QIIpZiht4kihVcXhZts=;
 b=VZ2cAUX8Ar0g9XwlSwMUsAJFJ+x9WoBP8ZUB6v4eL265wgG+R7Yg+AHG6eBB9s36q+
 acas52nuQwIOC2kAnffOOIPVbaZ9CsbEUqvZ9ubN/y27tiGvuGx7f55KXJCuPs5g4L0B
 Zvb0HwQblFcZjAHSFwulEWa84Nh7s+o1qSje5u9ZWBlI29Mxdd/h0T5AVmH3Ip/J/cEy
 Xo+rB9DWuAhQkC1vuQA0G75aFWpioKs+9NpJ380LPswDKkyS1ZPp/ovsKyUcA4nK5OHs
 6A0Q1xlpuoF+4ZuF3LvkEBES9Z4bFPvPSacHgcHRgM4y8kaKq1fjZcfltW/52aCw2zLF
 tzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BWFI5h416BXkQSSoLp6it0M+QIIpZiht4kihVcXhZts=;
 b=3J2Ij3h4rtEUDDDhXcOpz82qsXLyWnkq8uZCzNaVc7vYlCJCoi2UjlFaF5QUUYexyx
 D2/c26dxD7k9VL7Q90J2ClwqQXctUhzZp/Sg3NE7WivXlmnIZ44RmkLLHMSaRB+v9k0C
 X1LKkZMwkceYRCh6n3aIIhC0HGRTXkf4C0S75RX+XjtPbrGrhsfkygUGvsJWK7Ip0B/W
 ixEqGi/79pr7b5O0n7GLeAYDb4WQ7JkFS5XMKpmzuzddCdB7UHezCkjUUD2HK/vTFLF5
 m/4iyNQarV/2InMLipgHjVbTQcMr2mYjmcB1FV0zqW2/XbL7UC8yAkqe5pQXm3W7KTqZ
 GAPg==
X-Gm-Message-State: AOAM532I/YpjT2GLcFZ/N8TUHyOP+eddlG3jj6UfFCibrD5YEv1f87vR
 oRep1NcbbZHBxJWTRBmX9Ie0KA==
X-Google-Smtp-Source: ABdhPJwQ3i+7pigTCE79ECMNKcgYpSK4txWbWXeonLwGpNYGsyXDVr849fLZJT/ZuycgWpgB3cB76g==
X-Received: by 2002:a05:6e02:1a2c:b0:2c7:89cb:6bc8 with SMTP id
 g12-20020a056e021a2c00b002c789cb6bc8mr11174471ile.236.1647287128338; 
 Mon, 14 Mar 2022 12:45:28 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 c6-20020a056e020bc600b002c6731e7cb8sm9091010ilu.31.2022.03.14.12.45.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 14 Mar 2022 12:45:27 -0700 (PDT)
Date: Mon, 14 Mar 2022 19:45:24 +0000
From: Oliver Upton <oupton@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v4 06/13] KVM: arm64: Add standard hypervisor firmware
 register
Message-ID: <Yi+bVM742+9W4TYj@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-7-rananta@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-7-rananta@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Feb 24, 2022 at 05:25:52PM +0000, Raghavendra Rao Ananta wrote:
> Introduce the firmware register to hold the standard hypervisor
> service calls (owner value 5) as a bitmap. The bitmap represents
> the features that'll be enabled for the guest, as configured by
> the user-space. Currently, this includes support only for
> Paravirtualized time, represented by bit-0.
> 
> The register is also added to the kvm_arm_vm_scope_fw_regs[] list
> as it maintains its state per-VM.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
>  arch/arm64/kvm/guest.c            |  1 +
>  arch/arm64/kvm/hypercalls.c       | 20 +++++++++++++++++++-
>  include/kvm/arm_hypercalls.h      |  3 +++
>  5 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1909ced3208f..318148b69279 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
>   * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
>   *
>   * @hvc_std_bmap: Bitmap of standard secure service calls
> + * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
>   */
>  struct kvm_hvc_desc {
>  	u64 hvc_std_bmap;
> +	u64 hvc_std_hyp_bmap;
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 2decc30d6b84..9a2caead7359 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -295,6 +295,10 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
>  #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
>  
> +#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_BMAP_REG(1)
> +#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
> +#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
> +
>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d66e6c742bbe..c42426d6137e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -66,6 +66,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
> +	KVM_REG_ARM_STD_HYP_BMAP,
>  };
>  
>  /**
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 48c126c3da72..ebc0cc26cf2e 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -75,6 +75,10 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
>  	case ARM_SMCCC_TRNG_RND64:
>  		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
>  						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> +	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
>  	default:
>  		/* By default, allow the services that aren't listed here */
>  		return true;
> @@ -83,6 +87,7 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
>  
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
>  	u32 func_id = smccc_get_function(vcpu);
>  	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>  	u32 feature;
> @@ -134,7 +139,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			}
>  			break;
>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -			val[0] = SMCCC_RET_SUCCESS;
> +			if (kvm_arm_fw_reg_feat_enabled(
> +					hvc_desc->hvc_std_hyp_bmap,

It is probably OK to keep this parameter on the line above (just stay
under 100 characters a line).

> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
> +				val[0] = SMCCC_RET_SUCCESS;
>  			break;
>  		}
>  		break;
> @@ -179,6 +187,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
> +	KVM_REG_ARM_STD_HYP_BMAP,
>  };
>  
>  void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -186,6 +195,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>  	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
>  
>  	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> +	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
>  }
>  
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -272,6 +282,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	case KVM_REG_ARM_STD_BMAP:
>  		val = READ_ONCE(hvc_desc->hvc_std_bmap);
>  		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -294,6 +307,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>  		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
>  		fw_reg_features = ARM_SMCCC_STD_FEATURES;
>  		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
> +		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -398,6 +415,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  
>  		return 0;
>  	case KVM_REG_ARM_STD_BMAP:
> +	case KVM_REG_ARM_STD_HYP_BMAP:
>  		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
>  	default:
>  		return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 64d30b452809..a1cb6e839c74 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -9,6 +9,9 @@
>  #define ARM_SMCCC_STD_FEATURES \
>  	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
>  
> +#define ARM_SMCCC_STD_HYP_FEATURES \
> +	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
