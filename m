Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065135672
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 23:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738108310; cv=none; b=MR7lNCMuAB/okApkn+z2UpYgyYhec6kOSqvusF7Ch8wt0fwVVxtrdDfpIXPMRwVLfFH6LbAr4uoq9o1L27PsLG0Q/8ayuufHafh50AKBR6R6hT0zSUu9S+ffe5xYqW9E1f0+2b2Ip/Jb9EZGsMAvhULMtYFX0LY00DqCJY8zRsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738108310; c=relaxed/simple;
	bh=A4jbdWMbW7MvVT/KBEfNr5R+mAmwla0vGhc+P+AhzF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dk6NVZWYHZAGCZJrO/glP/WOmnKurGDoJkb7jGELdcLSrL3VOqAFb7Jb3FpHVdd782gtSwj9ulasd1fW/sxe63XmuZfOa51ptaQUDLw/lsO2ryZjuPhx2aFKI1VyOljh7LK42+sC8Ts3Qq7rVim1Dsty3UMsues4SLECJ/cKwUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gNYc7Mdv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gNYc7Mdv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738108306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+plZfZMBTkpPOut6ehHxsbo4XAtVzSns554KZTqadOQ=;
	b=gNYc7Mdv9bSfqg+z7fKRHRqVaS9DbtjuJWv1dsZOMnDctWOp+0pNN0jQ1ra3xXzvTgN3Ac
	MHKydWAI5gN7PCtcAWGwkh/18OEc9OTCWqqiyemhpEu/Sji6XhfFZyQ5ysn+OvBXzfP2NM
	g/+0tRlR2V9W7Nk2ZlboJk4Mmlb3yns=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-o_KAVazHPJaKObos5B9uvA-1; Tue, 28 Jan 2025 18:51:45 -0500
X-MC-Unique: o_KAVazHPJaKObos5B9uvA-1
X-Mimecast-MFC-AGG-ID: o_KAVazHPJaKObos5B9uvA
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-216717543b7so163706215ad.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:51:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738108304; x=1738713104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+plZfZMBTkpPOut6ehHxsbo4XAtVzSns554KZTqadOQ=;
        b=Z+nG7qj1na3FOrjcAUUTpaO0EitHp3GR9nN9hRFljEiE/WLCbdDgMes5S9hu59i16z
         EwZ1ZJ+6zF+S/rUXlFOA9nADkm1Y4q5xvED7SSZIz2i8st2hTqyRQdVSswcnZHUGn4aL
         mFYEfNHh/NrWcsdcOFvwN0UdQudob6UfxBmGfvdIHFn8yUKIBQpGDC7QkV4+/flltsfN
         57l7pJWDHcr42/MlF8YE4HDcfQlNSLHzTgDt3thtUpf+x/PbTKX7R2mebbWi7lRvKrfD
         EzRKjLtEoQ9W2uW3Nm5fhcw6rnaXd4n6bZkrD3SicJZjkcn9Yo3ImJfLCjSkbrrWbao+
         z8ug==
X-Forwarded-Encrypted: i=1; AJvYcCX8pGc6/9dmgdvwBKVJ+9jwQU0PrGfewSCXYIbZK04qIyEpkTPpZJSGJEGcKBDIenJRmY3zhmg=@lists.linux.dev
X-Gm-Message-State: AOJu0YynCh4/rMnCfifSYA6rHtFwNV1OofBnoj82wxKIlcT3s/hhjjBN
	Go/4BYv2VWKzwCa9shApVi1ezZOOrd7eaSL10ZTPxpVWYuCjA+RGxUn0FTQ1keOCeP7GiMoUGGr
	gs/Yx4FLb9P8C54naeU64b4rovv0H8M2YHf7lk49thRwCuVNPRz97yQ==
X-Gm-Gg: ASbGncvvg10oDLG+lSPS0QFeyNcsfAylzt9p5kECd6pNa8DnvWdyYqtLJDR9Irqcz14
	ZYUM7Ut2hg7TIYcgmiJI0TRvyZJxU0+7eSG6qx0LINeHHwz2+sqa16G1ktcddM/yo3drsS2SKjE
	5vbqx0MEV7xIytvKy9FzTCcCHNyp51OecZaetYOtIU9/ZsBLYkZI7Cb1svQ4Z/chsn506pc4uHh
	RtMMIk6bigffAYHQfFOL0D1Ddi10VMSlJDNmhj/7YNVDTLuaG8vot1L7g+bMNBBfsh+AkUAPm4J
	cW2DUQ==
X-Received: by 2002:a17:902:cec2:b0:215:a57e:88e7 with SMTP id d9443c01a7336-21dd7c44fbemr14311195ad.3.1738108304634;
        Tue, 28 Jan 2025 15:51:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEisDusPXc7ABGNzSjvOH0bfbYE9rGUJagDAg44yLrrrIJdYRrgsxD0BPQEinR+S01/v+a6Rw==
X-Received: by 2002:a17:902:cec2:b0:215:a57e:88e7 with SMTP id d9443c01a7336-21dd7c44fbemr14310905ad.3.1738108304240;
        Tue, 28 Jan 2025 15:51:44 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414132asm86536785ad.138.2025.01.28.15.51.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 15:51:43 -0800 (PST)
Message-ID: <f6668e66-313a-4c56-92ba-08855878ebf9@redhat.com>
Date: Wed, 29 Jan 2025 09:51:34 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/43] arm64: RME: Define the user ABI
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-8-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-8-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CNRQ_ULiFfY142EjBJrscZ-VUHSKPj7iXgA8tmr9Af8_1738108305
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> There is one (multiplexed) CAP which can be used to create, populate and
> then activate the realm.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
>     KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
> ---
>   Documentation/virt/kvm/api.rst    |  1 +
>   arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h          | 12 ++++++++
>   3 files changed, 62 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 454c2aaa155e..df4679415a4c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5088,6 +5088,7 @@ Recognised values for feature:
>   
>     =====      ===========================================
>     arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
>     =====      ===========================================
>   
>   Finalizes the configuration of the specified vcpu feature.
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 66736ff04011..8810719523ec 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -108,6 +108,7 @@ struct kvm_regs {
>   #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>   #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>   #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
> +#define KVM_ARM_VCPU_REC		8 /* VCPU REC state as part of Realm */
>   
>   struct kvm_vcpu_init {
>   	__u32 target;
> @@ -418,6 +419,54 @@ enum {
>   #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
>   #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
>   
> +/* KVM_CAP_ARM_RME on VM fd */
> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
> +#define KVM_CAP_ARM_RME_CREATE_RD		1
> +#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
> +

I guess it would be nice to rename KVM_CAP_ARM_RME_CREATE_RD to KVM_CAP_ARM_RME_CREATE_REALM
since it's to create a realm. All other macros have suffix "_REALM". Besides, KVM_CAP_ARM_RME_INIT_IPA_REALM
would be KVM_CAP_ARM_RME_INIT_REALM_IPA, and KVM_CAP_ARM_RME_POPULATE_REALM would be
KVM_CAP_ARM_RME_POPULATE_REALM_IPA. Something like below.

/* KVM_CAP_ARM_RME on VM fd */
#define KVM_CAP_ARM_RME_CONFIG_REALM		0
#define KVM_CAP_ARM_RME_CREATE_RD		1
#define KVM_CAP_ARM_RME_INIT_REALM_IPA		2
#define KVM_CAP_ARM_RME_POPULATE_REALM_IPA	3
#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4

> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256		0
> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512		1
> +
> +#define KVM_CAP_ARM_RME_RPV_SIZE 64
> +
> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
> +#define KVM_CAP_ARM_RME_CFG_RPV			0
> +#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
> +

The comments for the list of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM,
it shall be moved before KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256 to cover all the definitions
applied to KVM_CAP_ARM_RME_CONFIG_REALM.

Besides, the prefix "KVM_CAP_" in those definitions, except the first 5 definitions like
KVM_CAP_ARM_RME_CONFIG_REALM, are confusing. The macros with "KVM_CAP_" prefix are usually
indicating capabilities. In this specific case, they're applied to the argument (struct),
carried by the corresponding sub-command. So I would suggest to eleminate the prefix,
something like below:

/* List of configurations accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
#define ARM_RME_CONFIG_RPV		0
#define ARM_RME_CONFIG_HASH_ALGO	1

#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA256	0
#define ARM_RME_CONFIG_MEASUREMENT_ALGO_SHA512	1

#define ARM_RME_CONFIG_RPV_SIZE	64

struct arm_rme_config {
         :
};


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
> +		/* Fix the size of the union */
> +		__u8	reserved[256];
> +	};
> +};
> +
> +#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE	BIT(0)
> +struct kvm_cap_arm_rme_populate_realm_args {
> +	__u64 populate_ipa_base;
> +	__u64 populate_ipa_size;
> +	__u32 flags;
> +	__u32 reserved[3];
> +};
> +

BIT(0) has type of 'unsigned long', inconsistent to '__u32 flags'. So it would
be something like below.

#define ARM_RME_POPULATE_REALM_IPA_FLAG_MEASURE		(1 << 0)
struct arm_rme_populate_realm_ipa {
	__u64 base;
	__u64 size;
	__u32 flags;
	__u32 reserved[3];
};

> +struct kvm_cap_arm_rme_init_ipa_args {
> +	__u64 init_ipa_base;
> +	__u64 init_ipa_size;
> +	__u32 reserved[4];
> +};
> +

Similiarly, it would be something like below:

struct arm_rme_init_realm_ipa {
	__u64 base;
	__u64 size;
	__u64 reserved[2];
};

>   /* Device Control API on vcpu fd */
>   #define KVM_ARM_VCPU_PMU_V3_CTRL	0
>   #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 502ea63b5d2e..f448198838cf 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -934,6 +934,8 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   
> +#define KVM_CAP_ARM_RME 300 /* FIXME: Large number to prevent conflicts */
> +
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;
>   	__u32 pin;
> @@ -1581,4 +1583,14 @@ struct kvm_pre_fault_memory {
>   	__u64 padding[5];
>   };
>   
> +/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
> +struct kvm_arm_rmm_psci_complete {
> +	__u64 target_mpidr;
> +	__u32 psci_status;
> +	__u32 padding[3];
> +};
> +
> +/* FIXME: Update nr (0xd2) when merging */
> +#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd2, struct kvm_arm_rmm_psci_complete)
> +
>   #endif /* __LINUX_KVM_H */

Thanks,
Gavin

