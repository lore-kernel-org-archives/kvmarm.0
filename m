Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DE7EC0
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 04:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691641679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=odv73Gc//K7rmG9F8pZUrpTryABTVCVHaAjU+YhM5+s=;
	b=B0AW5nJ7wZqMMFW+Fi7eQVJ18gb5pcakfe6c3Np4HNe4HKhzwq71CZG5gpxPSLuXfrgVxq
	ScUJJG84z0G1NVMEyDQIGR1E+k1Q2OGKjTEvQWV6FS9hxwnX4qgy9VOjDf+Oc02BYSthGu
	jE+HrVPU8EqpBjImONcokbRsqCB1n0A=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-NohkjVdlNsiiUtJdpWZuMQ-1; Thu, 10 Aug 2023 00:27:56 -0400
X-MC-Unique: NohkjVdlNsiiUtJdpWZuMQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bc75f1b42cso1548305ad.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Aug 2023 21:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691641675; x=1692246475;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=odv73Gc//K7rmG9F8pZUrpTryABTVCVHaAjU+YhM5+s=;
        b=U1ww5lNRGPh7YqXeVTNNxC9NoOcB6J9cUdiXjy+52kH8L4ZYd6AExogUNk/i4PCXfu
         R8DPDG633b6C7gdC5Do7pNmqym5DxgZumGoIDXPxWnN+svkCUGcyoG86yb7ku/VDNqmn
         af5ZcsNPETpirirg+Yb7xDQ2mTAJ88f3/nnd3zfvSfsl9Lj8tmb3ui+PH5fUmsIxPW/g
         bfUaSHi/ic0E6EJgbnQKDBwmYUyvwUoLnAlVC49igdqcRmpgSFpX3p5XI/DGW5LqtE7L
         Ynu2Rc/mHpFpHolxZaBbwC5kWRLlUlWxKMrJ7boiQm38J9sEY75iom2n+HsOzpfBH1iS
         8G0w==
X-Gm-Message-State: AOJu0Ywl1Ti/5W0EfEfK6ENY1PuBR04Z1VIfkrLy+TF6ehpUBEZ0FSbq
	kJ8RrVnWI9kpeMJNft9x1w5eRZipCI/T/XJ4Mvpm+uH8mDTUd+XerSW7DFZnhViE1b6J8yOMKoJ
	GBqtlKeuA+W7s4Ayv
X-Received: by 2002:a17:902:ce86:b0:1b8:a27d:f591 with SMTP id f6-20020a170902ce8600b001b8a27df591mr1442511plg.5.1691641674967;
        Wed, 09 Aug 2023 21:27:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtjlPAqn1TSf3Z+4sVZYgxgiwoQ95xHHFL5mJCU+Ve3rWbK+Mo/S7KF4S/sCOssgSNSFjC3A==
X-Received: by 2002:a17:902:ce86:b0:1b8:a27d:f591 with SMTP id f6-20020a170902ce8600b001b8a27df591mr1442480plg.5.1691641674616;
        Wed, 09 Aug 2023 21:27:54 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ji22-20020a170903325600b001b830d8bc40sm448153plb.74.2023.08.09.21.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 21:27:54 -0700 (PDT)
Message-ID: <f3853532-a449-fb62-5366-3d3ce689c3ff@redhat.com>
Date: Thu, 10 Aug 2023 12:27:49 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
To: Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.linux.dev>,
 ARMLinux <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>,
 Reiji Watanabe <reijiw@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230801152007.337272-2-jingzhangos@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jing,

On 8/1/23 23:19, Jing Zhang wrote:
> Add a VM ioctl to allow userspace to get writable masks for feature ID
> registers in below system register space:
> op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
> This is used to support mix-and-match userspace and kernels for writable
> ID registers, where userspace may want to know upfront whether it can
> actually tweak the contents of an idreg or not.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h |  2 ++
>   arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
>   arch/arm64/kvm/arm.c              |  3 ++
>   arch/arm64/kvm/sys_regs.c         | 51 +++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h          |  2 ++
>   5 files changed, 83 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d3dd05bbfe23..3996a3707f4e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>   			       struct kvm_arm_copy_mte_tags *copy_tags);
>   int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>   				    struct kvm_arm_counter_offset *offset);
> +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
> +					       u64 __user *masks);
>   
>   /* Guest/host FPSIMD coordination helpers */
>   int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f7ddd73a8c0f..2970c0d792ee 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -505,6 +505,31 @@ struct kvm_smccc_filter {
>   #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
>   #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
>   
> +/* Get feature ID registers userspace writable mask. */
> +/*
> + * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
> + * Feature Register 2"):
> + *
> + * "The Feature ID space is defined as the System register space in
> + * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
> + * op2=={0-7}."
> + *
> + * This covers all R/O registers that indicate anything useful feature
> + * wise, including the ID registers.
> + */
> +#define ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)		\
> +	({								\
> +		__u64 __op1 = (op1) & 3;				\
> +		__op1 -= (__op1 == 3);					\
> +		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
> +	})
> +
> +#define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
> +
> +struct feature_id_writable_masks {
> +	__u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
> +};
> +
>   #endif
>   
>   #endif /* __ARM_KVM_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..c9cd14057c58 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1630,6 +1630,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   
>   		return kvm_vm_set_attr(kvm, &attr);
>   	}
> +	case KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS: {
> +		return kvm_vm_ioctl_get_feature_id_writable_masks(kvm, argp);
> +	}
>   	default:
>   		return -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2ca2973abe66..d9317b640ba5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3560,6 +3560,57 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   	return write_demux_regids(uindices);
>   }
>   
> +#define ARM64_FEATURE_ID_SPACE_INDEX(r)			\
> +	ARM64_FEATURE_ID_SPACE_IDX(sys_reg_Op0(r),	\
> +		sys_reg_Op1(r),				\
> +		sys_reg_CRn(r),				\
> +		sys_reg_CRm(r),				\
> +		sys_reg_Op2(r))
> +
> +static bool is_feature_id_reg(u32 encoding)
> +{
> +	return (sys_reg_Op0(encoding) == 3 &&
> +		(sys_reg_Op1(encoding) < 2 || sys_reg_Op1(encoding) == 3) &&
> +		sys_reg_CRn(encoding) == 0 &&
> +		sys_reg_CRm(encoding) <= 7);
> +}

A fool question.

In the code base, there is a function is_id_reg() to check if it's a 
id_reg, what's the difference between the is_feature_id_reg() and the 
is_id_reg()?

/*
  * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
  * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
  */
static inline bool is_id_reg(u32 id)
{
	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
		sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
		sys_reg_CRm(id) < 8);
}

Thanks,
Shaoqin

> +
> +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __user *masks)
> +{
> +	/* Wipe the whole thing first */
> +	for (int i = 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
> +		if (put_user(0, masks + i))
> +			return -EFAULT;
> +
> +	for (int i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> +		const struct sys_reg_desc *reg = &sys_reg_descs[i];
> +		u32 encoding = reg_to_encoding(reg);
> +		u64 val;
> +
> +		if (!is_feature_id_reg(encoding) || !reg->set_user)
> +			continue;
> +
> +		/*
> +		 * For ID registers, we return the writable mask. Other feature
> +		 * registers return a full 64bit mask. That's not necessary
> +		 * compliant with a given revision of the architecture, but the
> +		 * RES0/RES1 definitions allow us to do that.
> +		 */
> +		if (is_id_reg(encoding)) {
> +			if (!reg->val)
> +				continue;
> +			val = reg->val;
> +		} else {
> +			val = ~0UL;
> +		}
> +
> +		if (put_user(val, (masks + ARM64_FEATURE_ID_SPACE_INDEX(encoding))))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
>   int __init kvm_sys_reg_table_init(void)
>   {
>   	struct sys_reg_params params;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index f089ab290978..86ffdf134eb8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1555,6 +1555,8 @@ struct kvm_s390_ucas_mapping {
>   #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
>   /* Available with KVM_CAP_COUNTER_OFFSET */
>   #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
> +#define KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS \
> +			_IOR(KVMIO,  0xb6, struct feature_id_writable_masks)
>   
>   /* ioctl for vm fd */
>   #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)

-- 
Shaoqin

