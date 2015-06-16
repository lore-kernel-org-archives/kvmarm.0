From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/2] arm64: KVM: Add VCPU support for Qualcomm Technologies
 Kryo ARMv8 CPU
Date: Tue, 16 Jun 2015 14:32:03 +0100
Message-ID: <55802553.4020600@arm.com>
References: <1434146263-30972-1-git-send-email-timur@codeaurora.org> <1434146263-30972-2-git-send-email-timur@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1434146263-30972-2-git-send-email-timur@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>, Vipul Gandhi <vgandhi@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>, linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, kvm@vger.kernel.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

In the future, please add the KVM/ARM maintainers on Cc.

On 12/06/15 22:57, Timur Tabi wrote:
> From: Shanker Donthineni <shankerd@codeaurora.org>
> 
> This patch enables assignment of 32/64bit guest VCPU to
> Qualcomm Technologies ARMv8 CPU. Added KVM_ARM_TARGET_QCOM_KRYO
> to the KVM target list and modified vm_target_cpu() to return
> KVM_ARM_TARGET_QCOM_KRYO when CPU running in AArch64 mode.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> Signed-off-by: Timur Tabi <timur@codeaurora.org>
> ---
>  arch/arm64/include/uapi/asm/kvm.h    | 3 ++-
>  arch/arm64/kvm/guest.c               | 6 ++++++
>  arch/arm64/kvm/sys_regs_generic_v8.c | 2 ++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index d268320..426933e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -59,8 +59,9 @@ struct kvm_regs {
>  #define KVM_ARM_TARGET_CORTEX_A57	2
>  #define KVM_ARM_TARGET_XGENE_POTENZA	3
>  #define KVM_ARM_TARGET_CORTEX_A53	4
> +#define KVM_ARM_TARGET_QCOM_KRYO	5
>  
> -#define KVM_ARM_NUM_TARGETS		5
> +#define KVM_ARM_NUM_TARGETS		6
>  
>  /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
>  #define KVM_ARM_DEVICE_TYPE_SHIFT	0
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 9535bd5..836cf16 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -291,6 +291,12 @@ int __attribute_const__ kvm_target_cpu(void)
>  			return KVM_ARM_TARGET_XGENE_POTENZA;
>  		};
>  		break;
> +	case ARM_CPU_IMP_QCOM:
> +		switch (part_number & QCOM_CPU_PART_MASK) {
> +		case QCOM_CPU_PART_KRYO:
> +			return KVM_ARM_TARGET_QCOM_KRYO;
> +		}
> +		break;
>  	};
>  
>  	return -EINVAL;
> diff --git a/arch/arm64/kvm/sys_regs_generic_v8.c b/arch/arm64/kvm/sys_regs_generic_v8.c
> index 475fd29..3712ea8 100644
> --- a/arch/arm64/kvm/sys_regs_generic_v8.c
> +++ b/arch/arm64/kvm/sys_regs_generic_v8.c
> @@ -94,6 +94,8 @@ static int __init sys_reg_genericv8_init(void)
>  					  &genericv8_target_table);
>  	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_XGENE_POTENZA,
>  					  &genericv8_target_table);
> +	kvm_register_target_sys_reg_table(KVM_ARM_TARGET_QCOM_KRYO,
> +					  &genericv8_target_table);
>  
>  	return 0;
>  }
> 

That's getting slightly out of hand and I think we need to stop being
paranoid.

All our target CPUs are using the generic tables, and this looks like an
unnecessary complexity as long as we choose to ignore
cross-microarchitecture migration (things like big-little or live
migration from one CPU type to another).

Let's just implement a default target that works for everything. Should
we support some CPUs in a more specific manner, it will then be worth
adding to that list. I believe Suzuki (cc-ed) has something brewing.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
