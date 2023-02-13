Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3178F5F;
	Mon, 13 Feb 2023 16:04:20 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id h4so1950753ile.5;
        Mon, 13 Feb 2023 08:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676304259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqDYG1HQsanaYHBVxFBRuCH5DheOkEu9TeGl3/Ddq7Q=;
        b=afONKsgbdi3KwIs4EedRq2qbreVbE8uxI7D2Pc3wqRgODgNXgOpOkInLyJrDR29XFB
         NccqEqDigwkzv7/CLb0JLmr2qQ0ZjxPg9GODMmlYa7+ykl8Z+emK737D/V+PxCO2g7f8
         jc1cU9j+1XW4/tVlLMHDgsG8/8C8KvMjegPKTqB2CSnrG3BZIP+PQAcQS4Hci5k5UA4a
         wqADlJuvL7y9QS+pEZEEJx5n2Drk0waQMEV0q0Pyjp6+X28J4vtFOyyPKmSN+rVlY0Vb
         UezyNZCcDlp/RCMMoWGV0HVKvX9ygUmMlIv+RBqnSngJ4Vf/xS7eRu3kxIKhQEvIrYxJ
         yhBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676304259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqDYG1HQsanaYHBVxFBRuCH5DheOkEu9TeGl3/Ddq7Q=;
        b=VRunYGmuUatj/jTb6XHUPZCFS6skYr6uBR77jS/vdwmrlnCmsApHT/jGWaqn7y9Gg9
         l8nQ4qcUzznpZRFkcNmVfcJJYJf9batClPxDF+Tm11MMt/mp6mESV/PgIK6NjsQWYWQy
         xoFpy7l9+9xI/hCpEMPYOBUZJcm303m/CI2EA/4XzqO4Z+9j9iJHu7/xXoAw6hHsdYQN
         HAcUBSVkeyecQQyPm6J/p/A08hAiWHtCbVR3S5/DMFqU8SM5vAGpoXqYZFJxgIVgTJCP
         rj5Ysv3NzrjgV/Z9AcOn/IP0Sbfzz2WGvIynJE7iOLwb/JzuQbNk7wjrBU9+gi+6/Er7
         +1UA==
X-Gm-Message-State: AO0yUKXFbSt6wjGkg0SK0Y5gD6iwK3kQY3Gqv8o8Ik5Meu9ZQcNHl4Mp
	FjY++gUqapOa9bEHptq7EQI=
X-Google-Smtp-Source: AK7set/6PScffJ7w+oMo65G5e41ypk8lLhhClh94EFjhQWApYrG1Hcvs3gbSbnei1vZ76SuskHIR7g==
X-Received: by 2002:a05:6e02:ee3:b0:315:363e:b140 with SMTP id j3-20020a056e020ee300b00315363eb140mr4801191ilk.1.1676304259347;
        Mon, 13 Feb 2023 08:04:19 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id k2-20020a02ccc2000000b0035a40af60fcsm4067532jaq.86.2023.02.13.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:04:19 -0800 (PST)
Date: Mon, 13 Feb 2023 18:04:13 +0200
From: Zhi Wang <zhi.wang.linux@gmail.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Catalin Marinas
 <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
 <will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, Alexandru
 Elisei <alexandru.elisei@arm.com>, Christoffer Dall
 <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 05/28] arm64: RME: Define the user ABI
Message-ID: <20230213180413.00000392@gmail.com>
In-Reply-To: <20230127112932.38045-6-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-6-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Jan 2023 11:29:09 +0000
Steven Price <steven.price@arm.com> wrote:

> There is one (multiplexed) CAP which can be used to create, populate and
> then activate the realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  Documentation/virt/kvm/api.rst    |  1 +
>  arch/arm64/include/uapi/asm/kvm.h | 63 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 +
>  3 files changed, 66 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0dd5d8733dd5..f1a59d6fb7fc 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -4965,6 +4965,7 @@ Recognised values for feature:
>  
>    =====      ===========================================
>    arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>    =====      ===========================================
>  
>  Finalizes the configuration of the specified vcpu feature.
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index a7a857f1784d..fcc0b8dce29b 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -109,6 +109,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
> +#define KVM_ARM_VCPU_REC		7 /* VCPU REC state as part of Realm */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> @@ -401,6 +402,68 @@ enum {
>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>  #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>  
> +/* KVM_CAP_ARM_RME on VM fd */
> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
> +#define KVM_CAP_ARM_RME_CREATE_RD		1
> +#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
> +

It is a little bit confusing here. These seems more like 'commands' not caps.
Will leave more comments after reviewing the later patches.
 
> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256		0
> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512		1
> +
> +#define KVM_CAP_ARM_RME_RPV_SIZE 64
> +
> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
> +#define KVM_CAP_ARM_RME_CFG_RPV			0
> +#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
> +#define KVM_CAP_ARM_RME_CFG_SVE			2
> +#define KVM_CAP_ARM_RME_CFG_DBG			3
> +#define KVM_CAP_ARM_RME_CFG_PMU			4
> +
> +struct kvm_cap_arm_rme_config_item {
> +	__u32 cfg;
> +	union {
> +		/* cfg == KVM_CAP_ARM_RME_CFG_RPV */
> +		struct {
> +			__u8	rpv[KVM_CAP_ARM_RME_RPV_SIZE];
> +		};
> +
> +		/* cfg == KVM_CAP_ARM_RME_CFG_HASH_ALGO */
> +		struct {
> +			__u32	hash_algo;
> +		};
> +
> +		/* cfg == KVM_CAP_ARM_RME_CFG_SVE */
> +		struct {
> +			__u32	sve_vq;
> +		};
> +
> +		/* cfg == KVM_CAP_ARM_RME_CFG_DBG */
> +		struct {
> +			__u32	num_brps;
> +			__u32	num_wrps;
> +		};
> +
> +		/* cfg == KVM_CAP_ARM_RME_CFG_PMU */
> +		struct {
> +			__u32	num_pmu_cntrs;
> +		};
> +		/* Fix the size of the union */
> +		__u8	reserved[256];
> +	};
> +};
> +
> +struct kvm_cap_arm_rme_populate_realm_args {
> +	__u64 populate_ipa_base;
> +	__u64 populate_ipa_size;
> +};
> +
> +struct kvm_cap_arm_rme_init_ipa_args {
> +	__u64 init_ipa_base;
> +	__u64 init_ipa_size;
> +};
> +
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 20522d4ba1e0..fec1909e8b73 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1176,6 +1176,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
>  
> +#define KVM_CAP_ARM_RME 300 // FIXME: Large number to prevent conflicts
> +
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
>  struct kvm_irq_routing_irqchip {

