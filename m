Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8248D182B6
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689081773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1QwGt+Nkd+H1KNl32OQWIM9oAQmPpFQieK/lI73Qio=;
	b=eaaBH1bIBoL1FoZhsC8XIFazOYkyVkCfNEY1rqYl083ZeDYmObehj6mGwUbnl1XR0c6Zro
	kIW12g0M9E06wSoNT9uCJkUrhjvjWm00XeUOaUrM5r6+hRUnJsLSsakkaYW1wiQcRgidix
	Pik7RVfviKf7dQPsWW0jd9rVRDV/wtA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-CPxgXzS-Oa-omAhaectZeQ-1; Tue, 11 Jul 2023 09:22:52 -0400
X-MC-Unique: CPxgXzS-Oa-omAhaectZeQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1b86c700cc5so12560145ad.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 06:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689081771; x=1689686571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c1QwGt+Nkd+H1KNl32OQWIM9oAQmPpFQieK/lI73Qio=;
        b=JIzkEQ75P0pbHRW5MJO3IvKkQtTkHXkdFJfvr41Bo8vBklYitmljnmo9pEWOKiS3FH
         ZjvaZeoa059Hu9KuHTgnDJSWSsUuIr1Xf/6/00rXE527QRu7Jcwa69ifzOK6+Xx7ChAq
         WadeUF2AdXo5OkQRuPOuwMFOc1WX6qLW3sQT7Z/gYkaleFm0CMM2DR69Z0iUNv2vzKHX
         MywSxF5O1lCXkiuXz+ZOnPh2eF75EiJJjXVYLJaD1qtzkGtDIXqmSv9EVHMrvMZCqUhE
         zzqhiSWPU0dQ9C6Yzs8WLoBZeoW/WvzDggjRo4NY2JDjksm0PiOmLjtnf6DYY34Hm6Cv
         +jhw==
X-Gm-Message-State: ABy/qLbFdb5wp1UEiZJ/HLc+OI8F9wluN3OWsHrheF/X3Rzw8dxrMmGa
	XV0f7AU8ML9sWDhEy2d5CfpArbNRK6JK+OXkzp444mfLruKqa8M9sLVay+4w720+++VDnqZSVcB
	KElfaXq1CZFcs4VFN
X-Received: by 2002:a17:902:ec88:b0:1ae:4567:2737 with SMTP id x8-20020a170902ec8800b001ae45672737mr19779689plg.2.1689081771117;
        Tue, 11 Jul 2023 06:22:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGGP+ZfSAo+cEHJci/YRuYrcJuz9UljIq+dsR5/DcUBBfmwtgSo6TCSQPXewRdLfwY3KLo+hQ==
X-Received: by 2002:a17:902:ec88:b0:1ae:4567:2737 with SMTP id x8-20020a170902ec8800b001ae45672737mr19779664plg.2.1689081770787;
        Tue, 11 Jul 2023 06:22:50 -0700 (PDT)
Received: from [10.72.12.150] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902b68c00b001b87c1c762fsm1687348pls.123.2023.07.11.06.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 06:22:50 -0700 (PDT)
Message-ID: <96a337e4-ff12-a7e6-4394-4227b3ff0ce1@redhat.com>
Date: Tue, 11 Jul 2023 21:22:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 4/4] KVM: arm64: Always return generic v8 as the
 preferred target
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
 <20230710193140.1706399-5-oliver.upton@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230710193140.1706399-5-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/11/23 03:31, Oliver Upton wrote:
> Userspace selecting an implementation-specific vCPU target has been
> completely useless for a very long time. Let's go whole hog and start
> returning the generic v8 target across all implementations as the
> preferred target.
> 
> Uphold the pre-existing behavior by tolerating either the generic target
> or an implementation-specific target if the vCPU happens to be running
> on one of the lucky few parts.
> 
> Acked-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  1 -
>   arch/arm64/kvm/arm.c              |  9 +++++----
>   arch/arm64/kvm/guest.c            | 15 ---------------
>   3 files changed, 5 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b53105bccff9..ed60277e834a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -898,7 +898,6 @@ struct kvm_vcpu_stat {
>   	u64 exits;
>   };
>   
> -void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
>   unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
>   int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
>   int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 13f1bde0bc2d..9ab17ecd76bb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1250,7 +1250,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
>   {
>   	int ret;
>   
> -	if (init->target != kvm_target_cpu())
> +	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
> +	    init->target != kvm_target_cpu())
>   		return -EINVAL;
>   
>   	ret = kvm_vcpu_init_check_features(vcpu, init);
> @@ -1585,9 +1586,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   		return kvm_vm_ioctl_set_device_addr(kvm, &dev_addr);
>   	}
>   	case KVM_ARM_PREFERRED_TARGET: {
> -		struct kvm_vcpu_init init;
> -
> -		kvm_vcpu_preferred_target(&init);
> +		struct kvm_vcpu_init init = {
> +			.target = KVM_ARM_TARGET_GENERIC_V8,
> +		};
>   
>   		if (copy_to_user(argp, &init, sizeof(init)))
>   			return -EFAULT;
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 20280a5233f6..95f6945c4432 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -884,21 +884,6 @@ u32 __attribute_const__ kvm_target_cpu(void)
>   	return KVM_ARM_TARGET_GENERIC_V8;
>   }
>   
> -void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
> -{
> -	u32 target = kvm_target_cpu();
> -
> -	memset(init, 0, sizeof(*init));
> -
> -	/*
> -	 * For now, we don't return any features.
> -	 * In future, we might use features to return target
> -	 * specific features available for the preferred
> -	 * target type.
> -	 */
> -	init->target = (__u32)target;
> -}
> -
>   int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
>   {
>   	return -EINVAL;

-- 
Shaoqin

