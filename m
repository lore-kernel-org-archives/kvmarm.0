From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 05/12] KVM: arm64: Implement PV_FEATURES call
Date: Mon, 10 Dec 2018 10:39:44 +0000
Message-ID: <20181210103943.g5txylpjvfxdolpi@lakrids.cambridge.arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-6-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB09B4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:39:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7fxjjY9pRjSz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:39:48 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB244A2BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:39:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181128144527.44710-6-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 28, 2018 at 02:45:20PM +0000, Steven Price wrote:
> This provides a mechanism for querying which paravirtualized features
> are available in this hypervisor.
> 
> Also add the header file which defines the ABI for the paravirtualized
> clock features we're about to add.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/pvclock-abi.h | 32 ++++++++++++++++++++++++++++
>  include/kvm/arm_pv.h                 | 28 ++++++++++++++++++++++++
>  include/linux/arm-smccc.h            |  1 +
>  virt/kvm/arm/hypercalls.c            |  9 ++++++++
>  4 files changed, 70 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pvclock-abi.h
>  create mode 100644 include/kvm/arm_pv.h
> 
> diff --git a/arch/arm64/include/asm/pvclock-abi.h b/arch/arm64/include/asm/pvclock-abi.h
> new file mode 100644
> index 000000000000..64ce041c8922
> --- /dev/null
> +++ b/arch/arm64/include/asm/pvclock-abi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2018 Arm Ltd. */
> +
> +#ifndef __ASM_PVCLOCK_ABI_H
> +#define __ASM_PVCLOCK_ABI_H
> +
> +#include <kvm/arm_pv.h>
> +
> +struct pvclock_vm_time_info {
> +	__le32 revision;
> +	__le32 attributes;
> +	__le64 sequence_number;
> +	__le64 scale_mult;
> +	__le32 shift;
> +	__le32 reserved;
> +	__le64 native_freq;
> +	__le64 pv_freq;
> +	__le64 div_by_pv_freq_mult;
> +} __packed;
> +
> +struct pvclock_vcpu_stolen_time_info {
> +	__le32 revision;
> +	__le32 attributes;
> +	__le64 stolen_time;
> +	/* Structure must be 64 byte aligned, pad to that size */
> +	u8 padding[48];
> +} __packed;
> +
> +#define PV_VM_TIME_NOT_SUPPORTED	-1
> +#define PV_VM_TIME_INVALID_PARAMETERS	-2

Could you please add a comment describing that these are defined in ARM
DEN0057A?

> +
> +#endif
> diff --git a/include/kvm/arm_pv.h b/include/kvm/arm_pv.h
> new file mode 100644
> index 000000000000..19d2dafff31a
> --- /dev/null
> +++ b/include/kvm/arm_pv.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * Copyright (C) 2018 Arm Ltd.
> + */
> +
> +#ifndef __KVM_ARM_PV_H
> +#define __KVM_ARM_PV_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#define ARM_SMCCC_HV_PV_FEATURES					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_HYP_STANDARD,	\
> +			   0x20)
> +
> +#define ARM_SMCCC_HV_PV_TIME_LPT					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_HYP_STANDARD,	\
> +			   0x21)
> +
> +#define ARM_SMCCC_HV_PV_TIME_ST					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
> +			   ARM_SMCCC_SMC_64,			\
> +			   ARM_SMCCC_OWNER_HYP_STANDARD,	\
> +			   0x22)
> +
> +#endif /* __KVM_ARM_PV_H */

Do these need to live in a separate header, away from the struct
definitions?

I'd be happy for these to live in <linux/arm-smccc.h>, given they're
standard calls.

As before, a comment referring to ARM DEN0057A would be nice.


> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index b047009e7a0a..4e0866cc48c0 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -54,6 +54,7 @@
>  #define ARM_SMCCC_OWNER_SIP		2
>  #define ARM_SMCCC_OWNER_OEM		3
>  #define ARM_SMCCC_OWNER_STANDARD	4
> +#define ARM_SMCCC_OWNER_HYP_STANDARD	5

Minor nit, but could we make that STANDARD_HYP?

>  #define ARM_SMCCC_OWNER_TRUSTED_APP	48
>  #define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
>  #define ARM_SMCCC_OWNER_TRUSTED_OS	50
> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
> index 153aa7642100..ba13b798f0f8 100644
> --- a/virt/kvm/arm/hypercalls.c
> +++ b/virt/kvm/arm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/pvclock-abi.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -40,6 +41,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  				break;
>  			}
>  			break;
> +		case ARM_SMCCC_HV_PV_FEATURES:
> +			val = SMCCC_RET_SUCCESS;
> +			break;
> +		}
> +		break;
> +	case ARM_SMCCC_HV_PV_FEATURES:
> +		feature = smccc_get_arg1(vcpu);
> +		switch (feature) {
>  		}

IIUC, at this point in time, this happens to always return
SMCCC_RET_NOT_SUPPORTED.

If you leave this part out of the patch, and add it as required, this
patch is purely adding definitions, which would be a bit nicer for
review.

Thanks,
Mark.
