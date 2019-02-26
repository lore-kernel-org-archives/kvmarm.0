From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 4/6] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Tue, 26 Feb 2019 18:33:15 +0000
Message-ID: <f7e4156e-c9aa-0356-d9a4-6b01ff23c5c0@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/02/2019 09:24, Amit Daniel Kachhap wrote:
> This feature will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> supply this parameter instead of creating a new API.
> 
> A new register is not created to pass this parameter via
> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> supplied is enough to enable this feature.

and an attempt to restore the id register with the other version would fail.


> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
> index a25cd21..0529a7d 100644
> --- a/Documentation/arm64/pointer-authentication.txt
> +++ b/Documentation/arm64/pointer-authentication.txt
> @@ -82,7 +82,8 @@ pointers).
>  Virtualization
>  --------------
>  
> -Pointer authentication is not currently supported in KVM guests. KVM
> -will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
> -the feature will result in an UNDEFINED exception being injected into
> -the guest.

> +Pointer authentication is enabled in KVM guest when virtual machine is
> +created by passing a flag (KVM_ARM_VCPU_PTRAUTH)

(This is still mixing VM and VCPU)


> + requesting this feature to be enabled.

.. on each vcpu?


> +Without this flag, pointer authentication is not enabled
> +in KVM guests and attempted use of the feature will result in an UNDEFINED
> +exception being injected into the guest.

'guests' here suggests its a VM property. If you set it on some VCPU but not others KVM
will generate undefs instead of enabling the feature. (which is the right thing to do)

I think it needs to be clear this is a per-vcpu property.


> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 97c3478..5f82ca1 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -102,6 +102,7 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */

> +#define KVM_ARM_VCPU_PTRAUTH		4 /* VCPU uses address authentication */

Just address authentication? I agree with Mark we should have two bits to match what gets
exposed to EL0. One would then be address, the other generic.


> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> index 528ee6e..6846a23 100644
> --- a/arch/arm64/kvm/hyp/ptrauth-sr.c
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -93,9 +93,23 @@ void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)

> +/**
> + * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is allowed by user
> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function will be used to check userspace option to have ptrauth or not
> + * in the guest kernel.
> + */
> +bool kvm_arm_vcpu_ptrauth_allowed(const struct kvm_vcpu *vcpu)
> +{
> +	return kvm_supports_ptrauth() &&
> +		test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
> +}

This isn't used from world-switch, could it be moved to guest.c?


> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 12529df..f7bcc60 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1055,7 +1055,7 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
> -static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
> +static u64 read_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_desc const *r, bool raz)

(It might be easier on the reviewer to move these mechanical changes to an earlier patch)


Looks good,

Thanks,

James
