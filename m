Received: from out-73.mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FF17F
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 00:04:53 +0000 (UTC)
Date: Wed, 2 Aug 2023 00:04:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690934692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=26qSacuL0lICDBEf7YFF7T5Q6WzFo+qYPN2JykShS/o=;
	b=PDCJcZoXfOvTGnKPyf7CjSQfENjjsPZUiSmvcn8KXPU+zxxqDFzbTiUyLXIYuMhOZUq3tv
	cjd76jHgj2LBTWdzKdZnQ9vq4Sis2kZvTnejovGjAPYkZSNkgwSBGnYF25xI0z7WKPUTn5
	OUe1k22KHT9d2IBdPIVLb+EsELDm194=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH v7 01/10] KVM: arm64: Allow userspace to get the writable
 masks for feature ID registers
Message-ID: <ZMmdnou5Pk/9V1Gs@linux.dev>
References: <20230801152007.337272-1-jingzhangos@google.com>
 <20230801152007.337272-2-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801152007.337272-2-jingzhangos@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Jing,

On Tue, Aug 01, 2023 at 08:19:57AM -0700, Jing Zhang wrote:
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
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h | 25 +++++++++++++++
>  arch/arm64/kvm/arm.c              |  3 ++
>  arch/arm64/kvm/sys_regs.c         | 51 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h          |  2 ++
>  5 files changed, 83 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d3dd05bbfe23..3996a3707f4e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1074,6 +1074,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  			       struct kvm_arm_copy_mte_tags *copy_tags);
>  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>  				    struct kvm_arm_counter_offset *offset);
> +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm,
> +					       u64 __user *masks);
>  
>  /* Guest/host FPSIMD coordination helpers */
>  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index f7ddd73a8c0f..2970c0d792ee 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -505,6 +505,31 @@ struct kvm_smccc_filter {
>  #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
>  #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
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

This UAPI is rather difficult to extend in the future. We may need to
support describing the masks of multiple ranges of registers in the
future. I was thinking something along the lines of:

	enum reg_mask_range_idx {
		FEATURE_ID,
	};

	struct reg_mask_range {
		__u64 idx;
		__u64 *masks;
		__u64 rsvd[6];
	};

>  #endif
>  
>  #endif /* __ARM_KVM_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..c9cd14057c58 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1630,6 +1630,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  
>  		return kvm_vm_set_attr(kvm, &attr);
>  	}
> +	case KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS: {
> +		return kvm_vm_ioctl_get_feature_id_writable_masks(kvm, argp);
> +	}
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 2ca2973abe66..d9317b640ba5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3560,6 +3560,57 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
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
> +
> +int kvm_vm_ioctl_get_feature_id_writable_masks(struct kvm *kvm, u64 __user *masks)
> +{

Use the correct type for the user pointer (it's a struct pointer).

> +	/* Wipe the whole thing first */
> +	for (int i = 0; i < ARM64_FEATURE_ID_SPACE_SIZE; i++)
> +		if (put_user(0, masks + i))
> +			return -EFAULT;

Why not:

	if (clear_user(masks, ARM64_FEATURE_ID_SPACE_SIZE * sizeof(__u64)))
		return -EFAULT;

Of course, this may need to be adapted if the UAPI struct changes.

-- 
Thanks,
Oliver
