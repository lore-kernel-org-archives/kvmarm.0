From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v5 6/7] KVM: arm64: Allow get exception information from
 userspace
Date: Tue, 22 Aug 2017 08:57:23 +0100
Message-ID: <20170822085723.0000670e@huawei.com>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
 <1503065517-7920-7-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503065517-7920-7-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongjiu Geng <gengdongjiu@huawei.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 18 Aug 2017 22:11:56 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> when userspace gets SIGBUS signal, it does not know whether
> this is a synchronous external abort or SError, so needs
> to get the exception syndrome. so this patch allows userspace
> can get this values. For syndrome, only give userspace
> syndrome EC and ISS.
> 
> Now we move the synchronous external abort injection logic to
> userspace, when userspace injects the SEA exception to guest
> OS, it needs to specify the far_el1 value, so this patch give
> the exception virtual address to user space.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Quanming Wu <wuquanming@huawei.com>

A couple of really trivial formatting points inline.

> ---
>  arch/arm64/include/uapi/asm/kvm.h |  5 +++++
>  arch/arm64/kvm/guest.c            | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9f3ca24bbcc6..514261f682b8 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -181,6 +181,11 @@ struct kvm_arch_memory_slot {
>  #define KVM_REG_ARM64_SYSREG_OP2_MASK	0x0000000000000007
>  #define KVM_REG_ARM64_SYSREG_OP2_SHIFT	0
>  
> +/* AArch64 fault registers */
> +#define KVM_REG_ARM64_FAULT		(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM64_FAULT_ESR_EC_ISS	(0)
> +#define KVM_REG_ARM64_FAULT_FAR		(1)
> +
>  #define ARM64_SYS_REG_SHIFT_MASK(x,n) \
>  	(((x) << KVM_REG_ARM64_SYSREG_ ## n ## _SHIFT) & \
>  	KVM_REG_ARM64_SYSREG_ ## n ## _MASK)
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5c7f657dd207..cb383c310f18 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -128,6 +128,38 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  out:
>  	return err;
>  }
> +static int get_fault_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
> +	u32 ec, value;
> +	u32 id = reg->id & ~(KVM_REG_ARCH_MASK |
> +			KVM_REG_SIZE_MASK | KVM_REG_ARM64_FAULT);
> +
> +	switch (id) {
> +	case KVM_REG_ARM64_FAULT_ESR_EC_ISS:
> +		/* The user space needs to know the fault exception
> +		 * class field
> +		 */

The rest of this file uses the multiline comment syntax
/*
 * The user...
 */

> +		ec = kvm_vcpu_get_hsr(vcpu) & ESR_ELx_EC_MASK;
> +		value = ec | (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_ISS_MASK);
Same as

value = kvm_vpcu_get_hsr(vcpu) & (ESR_ELx_EC_MASK | ESR_ELx_ISS_MASK);

?

> +
> +		if (copy_to_user(uaddr, &value, KVM_REG_SIZE(reg->id)) != 0)
> +			return -EFAULT;
> +		break;
> +	case KVM_REG_ARM64_FAULT_FAR:
> +		/* when user space injects synchronized abort, it needs
> +		 * to inject the fault address.
> +		 */

Again, multiline comment syntax.

> +		if (copy_to_user(uaddr, &(vcpu->arch.fault.far_el2),
> +				KVM_REG_SIZE(reg->id)) != 0)
> +			return -EFAULT;
> +		break;
> +	default:
> +		return -ENOENT;
> +	}
> +	return 0;
> +}
> +
>  
>  int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  {
> @@ -243,6 +275,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE)
>  		return get_core_reg(vcpu, reg);
>  
> +	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM64_FAULT)
> +		return get_fault_reg(vcpu, reg);
> +
>  	if (is_timer_reg(reg->id))
>  		return get_timer_reg(vcpu, reg);
>  
