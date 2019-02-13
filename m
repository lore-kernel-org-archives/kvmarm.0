From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v5 4/5] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Wed, 13 Feb 2019 17:35:22 +0000
Message-ID: <a9b22dcf-2238-344f-0b7b-b4a9de7c562c@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
> This feature will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> supply this parameter instead of creating a new API.
> 
> A new register is not created to pass this parameter via
> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> supplied is enough to enable this feature.

[...]

> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index b200c14..b6950df 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -346,6 +346,10 @@ static inline int kvm_arm_have_ssbd(void)
>  static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu) {}
> +static inline bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}

It seems like this is only ever called from arm64 code, so do we need an
arch/arm/ definition?

> +/**
> + * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is present in vcpu
> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function will be used to enable/disable ptrauth in guest as configured
> + * by the KVM userspace API.
> + */
> +bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
> +}

I'm not sure, but should there also be something like

if (test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features) &&
    !kvm_supports_ptrauth())
	return -EINVAL;

in kvm_reset_vcpu?

Thanks,
Kristina
