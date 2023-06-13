Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843982915
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 09:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686650259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d24qNgsK4YI73pNJSGPXOXGrlkTr7CIQRglIpszf5fE=;
	b=D2zsPIKRl4u7tgWbYHj+a2KXtaYwpushvvRgzGKz99AFUxoCWreYcUIdZNrtviANt9vMq4
	JO9M2Suq0euWX+JnV4HaVCmyuSKafcjQlJPI89tpb3C+J2z3m9V/oy+o6KW2LReBtnOzpn
	Sw3xW0POMfyqBcHeTzoo5F+oWF7tcpE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-f1FL6ds_NkW24F471tEJGw-1; Tue, 13 Jun 2023 05:57:30 -0400
X-MC-Unique: f1FL6ds_NkW24F471tEJGw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f73936c258so7043935e9.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 02:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686650249; x=1689242249;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d24qNgsK4YI73pNJSGPXOXGrlkTr7CIQRglIpszf5fE=;
        b=Yq2f9L8+v9IctBhv1efV/a9T+pwteXqp+6sSKnUC4I+5kF1luTipsO5eKEPzSR+DJg
         VRoajulk5RCn1Xw+tiAI6OHLBBWbAJoSNEOJW0MNVIl8dcEenKC89zOdLFxPtnIPNI93
         N2e/T7dy/vBETEiW+J023RHTegzMWPxvAF96O6ebrl9iLwDeIN7s6/Q/oIV7vnc25/TM
         XNiliqPr8F79sURWp9G7SHpLzu+oDBGadLjRFWw2PejMojQh52JdbFjO8roP5FjlBklG
         iPra7aVab5iindM9ApHuRpjEQbnZVugLpIMfUjVbyG7NTn/z24pgJXYNcSWoCOHuxjbU
         CA+g==
X-Gm-Message-State: AC+VfDyl2jdMPomyj5VLl/8jbSB8VEvyE/P0J4h5c0H2cJw+GF8QoKxd
	2RkHSMwTmMMLudU3ht19TpgYsUfs96ckSz/6UMkFR5LcZOV+88mOpxzxsKF3wZJnru8r4gmgJML
	hMpgf+Gy0GpFV/mHr
X-Received: by 2002:a05:600c:3843:b0:3f7:1483:b229 with SMTP id s3-20020a05600c384300b003f71483b229mr9712647wmr.3.1686650249190;
        Tue, 13 Jun 2023 02:57:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5DWlGtfOHfyQjcabrgMLJ7MLmCh6LzHVrUWcE9P78XidO1dSdo0iXISnggfacCEipbLVgi+A==
X-Received: by 2002:a05:600c:3843:b0:3f7:1483:b229 with SMTP id s3-20020a05600c384300b003f71483b229mr9712637wmr.3.1686650248918;
        Tue, 13 Jun 2023 02:57:28 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c114a00b003f7e60622f0sm13922898wmz.6.2023.06.13.02.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 02:57:28 -0700 (PDT)
Message-ID: <92b65190-b39b-e410-1831-31d63a6aa129@redhat.com>
Date: Tue, 13 Jun 2023 17:57:21 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 09/17] KVM: arm64: Key use of VHE instructions in nVHE
 code off ARM64_KVM_HVHE
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-10-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-10-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

On 6/10/23 00:21, Marc Zyngier wrote:
> We can now start with the fun stuff: if we enable VHE *only* for
> the hypervisor, we need to generate the VHE instructions when
> accessing the system registers.
> 
> For this, reporpose the alternative sequence to be keyed off
s/reporpose/repropose or s/reporpose/repurpose ?
> ARM64_KVM_HVHE in the nVHE hypervisor code, and only there.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_hyp.h | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index fea04eb25cb4..b7238c72a04c 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -33,12 +33,18 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>   
>   #else // !__KVM_VHE_HYPERVISOR__
>   
> +#if defined(__KVM_NVHE_HYPERVISOR__)
> +#define VHE_ALT_KEY	ARM64_KVM_HVHE
> +#else
> +#define VHE_ALT_KEY	ARM64_HAS_VIRT_HOST_EXTN
> +#endif
> +
>   #define read_sysreg_elx(r,nvh,vh)					\
>   	({								\
>   		u64 reg;						\
> -		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),	\
> +		asm volatile(ALTERNATIVE(__mrs_s("%0", r##nvh),		\
>   					 __mrs_s("%0", r##vh),		\
> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
> +					 VHE_ALT_KEY)			\
>   			     : "=r" (reg));				\
>   		reg;							\
>   	})
> @@ -48,7 +54,7 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
>   		u64 __val = (u64)(v);					\
>   		asm volatile(ALTERNATIVE(__msr_s(r##nvh, "%x0"),	\
>   					 __msr_s(r##vh, "%x0"),		\
> -					 ARM64_HAS_VIRT_HOST_EXTN)	\
> +					 VHE_ALT_KEY)			\
>   					 : : "rZ" (__val));		\
>   	} while (0)
>   

-- 
Shaoqin

