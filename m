From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 10/18] arm/arm64: KVM: Turn kvm_psci_version into a
 static inline
Date: Sun, 4 Feb 2018 19:38:54 +0100
Message-ID: <20180204183854.GN21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-11-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Robin Murphy <robin.murphy@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:49AM +0000, Marc Zyngier wrote:
> We're about to need kvm_psci_version in HYP too. So let's turn it
> into a static inline, and pass the kvm structure as a second
> parameter (so that HYP can do a kern_hyp_va on it).
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 20 ++++++++++++--------
>  include/kvm/arm_psci.h      | 26 +++++++++++++++++++++++++-
>  virt/kvm/arm/psci.c         | 25 +++----------------------
>  3 files changed, 40 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 036e1f3d77a6..408c04d789a5 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -19,6 +19,8 @@
>  #include <linux/jump_label.h>
>  #include <uapi/linux/psci.h>
>  
> +#include <kvm/arm_psci.h>
> +
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
> @@ -350,14 +352,16 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	if (exit_code == ARM_EXCEPTION_TRAP &&
>  	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC64 ||
> -	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC32) &&
> -	    vcpu_get_reg(vcpu, 0) == PSCI_0_2_FN_PSCI_VERSION) {
> -		u64 val = PSCI_RET_NOT_SUPPORTED;
> -		if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features))
> -			val = 2;
> -
> -		vcpu_set_reg(vcpu, 0, val);
> -		goto again;
> +	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_HVC32)) {
> +		u32 val = vcpu_get_reg(vcpu, 0);
> +
> +		if (val == PSCI_0_2_FN_PSCI_VERSION) {
> +			val = kvm_psci_version(vcpu, kern_hyp_va(vcpu->kvm));
> +			if (unlikely(val == KVM_ARM_PSCI_0_1))
> +				val = PSCI_RET_NOT_SUPPORTED;
> +			vcpu_set_reg(vcpu, 0, val);
> +			goto again;
> +		}
>  	}
>  
>  	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 7b2e12697d4f..9b699f91171f 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -18,6 +18,7 @@
>  #ifndef __KVM_ARM_PSCI_H__
>  #define __KVM_ARM_PSCI_H__
>  
> +#include <linux/kvm_host.h>
>  #include <uapi/linux/psci.h>
>  
>  #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
> @@ -26,7 +27,30 @@
>  
>  #define KVM_ARM_PSCI_LATEST	KVM_ARM_PSCI_1_0
>  
> -int kvm_psci_version(struct kvm_vcpu *vcpu);
> +/*
> + * We need the KVM pointer independently from the vcpu as we can call
> + * this from HYP, and need to apply kern_hyp_va on it...
> + */
> +static inline int kvm_psci_version(struct kvm_vcpu *vcpu, struct kvm *kvm)
> +{
> +	/*
> +	 * Our PSCI implementation stays the same across versions from
> +	 * v0.2 onward, only adding the few mandatory functions (such
> +	 * as FEATURES with 1.0) that are required by newer
> +	 * revisions. It is thus safe to return the latest, unless
> +	 * userspace has instructed us otherwise.
> +	 */
> +	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
> +		if (kvm->arch.psci_version)
> +			return kvm->arch.psci_version;
> +
> +		return KVM_ARM_PSCI_LATEST;
> +	}
> +
> +	return KVM_ARM_PSCI_0_1;
> +}
> +
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  struct kvm_one_reg;
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 53272e8e0d37..2efacbe7b1a2 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -124,7 +124,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>  	if (!vcpu)
>  		return PSCI_RET_INVALID_PARAMS;
>  	if (!vcpu->arch.power_off) {
> -		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
> +		if (kvm_psci_version(source_vcpu, kvm) != KVM_ARM_PSCI_0_1)
>  			return PSCI_RET_ALREADY_ON;
>  		else
>  			return PSCI_RET_INVALID_PARAMS;
> @@ -233,25 +233,6 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
>  	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
>  }
>  
> -int kvm_psci_version(struct kvm_vcpu *vcpu)
> -{
> -	/*
> -	 * Our PSCI implementation stays the same across versions from
> -	 * v0.2 onward, only adding the few mandatory functions (such
> -	 * as FEATURES with 1.0) that are required by newer
> -	 * revisions. It is thus safe to return the latest, unless
> -	 * userspace has instructed us otherwise.
> -	 */
> -	if (test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features)) {
> -		if (vcpu->kvm->arch.psci_version)
> -			return vcpu->kvm->arch.psci_version;
> -
> -		return KVM_ARM_PSCI_LATEST;
> -	}
> -
> -	return KVM_ARM_PSCI_0_1;
> -}
> -
>  static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -409,7 +390,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>   */
>  static int kvm_psci_call(struct kvm_vcpu *vcpu)
>  {
> -	switch (kvm_psci_version(vcpu)) {
> +	switch (kvm_psci_version(vcpu, vcpu->kvm)) {
>  	case KVM_ARM_PSCI_1_0:
>  		return kvm_psci_1_0_call(vcpu);
>  	case KVM_ARM_PSCI_0_2:
> @@ -460,7 +441,7 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		void __user *uaddr = (void __user *)(long)reg->addr;
>  		u64 val;
>  
> -		val = kvm_psci_version(vcpu);
> +		val = kvm_psci_version(vcpu, vcpu->kvm);
>  		if (val == KVM_ARM_PSCI_0_1)
>  			return -EINVAL;
>  		if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
> -- 
> 2.14.2
> 
