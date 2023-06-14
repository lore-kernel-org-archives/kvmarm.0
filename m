Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7156A7F
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 07:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686727605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Iem6/Y/G24M3j/w67JcmVGZ1CH55Q1aVX/29CD3WyXc=;
	b=K6CzzSb9cNLqEypLTsjzc4AGh49Fh5jyqqPtC7hcv8zxcT00X+XMdBjbT9/LEBmBG6IqP0
	f/1us/bGBMoB1TcpeUE9UeddkuBqorOpYCxy5REpDX06kleaRImIGU7zq23VsiTGQznweo
	KsWgj2Gy/cQqsfXjKOCqcE+F6MWocpI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-rluiv7jEMQWM1zL1glpaVQ-1; Wed, 14 Jun 2023 03:26:43 -0400
X-MC-Unique: rluiv7jEMQWM1zL1glpaVQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30fcdfacd19so205798f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 00:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686727602; x=1689319602;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Iem6/Y/G24M3j/w67JcmVGZ1CH55Q1aVX/29CD3WyXc=;
        b=JI7mkHVZ9EEEo92NdK3xTq0EnhyWXzypUuTRdKrer2MqYtfFzp8FW+aFq/K8aD36a7
         O/HTvORFSMVyhhM852J2Fp94Gm/qHB80NN5C8RGs2PsSQLZNbXzHaVj2TlhMiTaHYNmG
         wKaeYDCig4XTyFnalLiBZ2VZ8uF4FwWEa92GJcgyUOMRHUuKmgXhWAnP52dAhj29ccHL
         ZX68VQjEMQSz+F0rhA3cUrpsCRm9YWoy3CvYzBVeJHqGz3Jyxb/2zGUxQJrCorB70J2d
         pTVVDuS+LY7FSv/JWjpIkbwV267UxQmlmiWi7Latl8Yip5etqBRkZXLxrDtcMJ9zkbju
         w5nA==
X-Gm-Message-State: AC+VfDw83TOR4DpnccroUyuruDTHs6uxDUc0Rk9166/fqJjMvQGH6WWE
	66jbDr18mPfCrGhHmucQF7YDeWLp0Fxduh9ycqIm/34dxW53BMdRiiq5EO/e6R4VCahrZu7gYEE
	yUMI6E96mUXAPeTM0
X-Received: by 2002:a5d:5958:0:b0:30e:3d8d:723a with SMTP id e24-20020a5d5958000000b0030e3d8d723amr10078944wri.3.1686727602645;
        Wed, 14 Jun 2023 00:26:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5ZGjfYnwtC2uWfcM6lEVKN+Te0ghzhMrOwVxZtB133X5BaOxOgwzTr4k0gs2CjtqyNPE6iyg==
X-Received: by 2002:a5d:5958:0:b0:30e:3d8d:723a with SMTP id e24-20020a5d5958000000b0030e3d8d723amr10078922wri.3.1686727602327;
        Wed, 14 Jun 2023 00:26:42 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e8-20020adff348000000b00304adbeeabbsm17385675wrp.99.2023.06.14.00.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 00:26:41 -0700 (PDT)
Message-ID: <bdb7e94b-2145-5f74-fc44-0f5790562881@redhat.com>
Date: Wed, 14 Jun 2023 15:26:34 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 03/17] arm64: Turn kaslr_feature_override into a
 generic SW feature override
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>
References: <20230609162200.2024064-1-maz@kernel.org>
 <20230609162200.2024064-4-maz@kernel.org>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609162200.2024064-4-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/10/23 00:21, Marc Zyngier wrote:
> Disabling KASLR from the command line is implemented as a feature
> override. Repaint it slightly so that it can further be used as
> more generic infrastructure for SW override purposes.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/cpufeature.h |  4 ++++
>   arch/arm64/kernel/cpufeature.c      |  2 ++
>   arch/arm64/kernel/idreg-override.c  | 16 ++++++----------
>   arch/arm64/kernel/kaslr.c           |  6 +++---
>   4 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 6bf013fb110d..bc1009890180 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -15,6 +15,8 @@
>   #define MAX_CPU_FEATURES	128
>   #define cpu_feature(x)		KERNEL_HWCAP_ ## x
>   
> +#define ARM64_SW_FEATURE_OVERRIDE_NOKASLR	0
> +
>   #ifndef __ASSEMBLY__
>   
>   #include <linux/bug.h>
> @@ -925,6 +927,8 @@ extern struct arm64_ftr_override id_aa64smfr0_override;
>   extern struct arm64_ftr_override id_aa64isar1_override;
>   extern struct arm64_ftr_override id_aa64isar2_override;
>   
> +extern struct arm64_ftr_override arm64_sw_feature_override;
> +
>   u32 get_kvm_ipa_limit(void);
>   void dump_cpu_features(void);
>   
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7d7128c65161..2d2b7bb5fa0c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -664,6 +664,8 @@ struct arm64_ftr_override __ro_after_init id_aa64smfr0_override;
>   struct arm64_ftr_override __ro_after_init id_aa64isar1_override;
>   struct arm64_ftr_override __ro_after_init id_aa64isar2_override;
>   
> +struct arm64_ftr_override arm64_sw_feature_override;
> +
>   static const struct __ftr_reg_entry {
>   	u32			sys_id;
>   	struct arm64_ftr_reg 	*reg;
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> index 370ab84fd06e..8c93b6198bf5 100644
> --- a/arch/arm64/kernel/idreg-override.c
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -138,15 +138,11 @@ static const struct ftr_set_desc smfr0 __initconst = {
>   	},
>   };
>   
> -extern struct arm64_ftr_override kaslr_feature_override;
> -
> -static const struct ftr_set_desc kaslr __initconst = {
> -	.name		= "kaslr",
> -#ifdef CONFIG_RANDOMIZE_BASE
> -	.override	= &kaslr_feature_override,
> -#endif
> +static const struct ftr_set_desc sw_features __initconst = {
> +	.name		= "arm64_sw",
> +	.override	= &arm64_sw_feature_override,
>   	.fields		= {
> -		FIELD("disabled", 0, NULL),
> +		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
>   		{}
>   	},
>   };
> @@ -158,7 +154,7 @@ static const struct ftr_set_desc * const regs[] __initconst = {
>   	&isar1,
>   	&isar2,
>   	&smfr0,
> -	&kaslr,
> +	&sw_features,
>   };
>   
>   static const struct {
> @@ -175,7 +171,7 @@ static const struct {
>   	  "id_aa64isar1.api=0 id_aa64isar1.apa=0 "
>   	  "id_aa64isar2.gpa3=0 id_aa64isar2.apa3=0"	   },
>   	{ "arm64.nomte",		"id_aa64pfr1.mte=0" },
> -	{ "nokaslr",			"kaslr.disabled=1" },
> +	{ "nokaslr",			"arm64_sw.nokaslr=1" },
>   };
>   
>   static int __init parse_nokaslr(char *unused)
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index e7477f21a4c9..5d4ce7f5f157 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -23,8 +23,6 @@
>   u64 __ro_after_init module_alloc_base;
>   u16 __initdata memstart_offset_seed;
>   
> -struct arm64_ftr_override kaslr_feature_override __initdata;
> -
>   static int __init kaslr_init(void)
>   {
>   	u64 module_range;
> @@ -36,7 +34,9 @@ static int __init kaslr_init(void)
>   	 */
>   	module_alloc_base = (u64)_etext - MODULES_VSIZE;
>   
> -	if (kaslr_feature_override.val & kaslr_feature_override.mask & 0xf) {
> +	if (cpuid_feature_extract_unsigned_field(arm64_sw_feature_override.val &
> +						 arm64_sw_feature_override.mask,
> +						 ARM64_SW_FEATURE_OVERRIDE_NOKASLR)) {
>   		pr_info("KASLR disabled on command line\n");
>   		return 0;
>   	}

-- 
Shaoqin

