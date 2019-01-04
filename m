From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 3/6] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Fri, 4 Jan 2019 17:57:54 +0000
Message-ID: <49474d5f-6f4e-b57d-4b45-94c16d85136c@arm.com>
References: <1545119810-12182-1-git-send-email-amit.kachhap@arm.com>
 <1545119810-12182-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545119810-12182-4-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 18/12/2018 07:56, Amit Daniel Kachhap wrote:
> This feature will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> supply this parameter instead of creating a new API.
> 
> A new register is not created to pass this parameter via
> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> supplied is enough to select this feature.

What is the motivation for doing this? Doesn't ptrauth 'just' need turning on?
It doesn't need additional setup to be useable, or rely on some qemu support to
work properly. There isn't any hidden state that can't be migrated in the usual way.
Is it just because we don't want to commit to the ABI?


> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
> index 5baca42..8c0f338 100644
> --- a/Documentation/arm64/pointer-authentication.txt
> +++ b/Documentation/arm64/pointer-authentication.txt
> @@ -87,7 +87,8 @@ used to get and set the keys for a thread.
>  Virtualization
>  --------------
>  
> -Pointer authentication is not currently supported in KVM guests. KVM
> -will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
> -the feature will result in an UNDEFINED exception being injected into
> -the guest.
> +Pointer authentication is enabled in KVM guest when virtual machine is
> +created by passing a flag (KVM_ARM_VCPU_PTRAUTH) requesting this feature
> +to be enabled. Without this flag, pointer authentication is not enabled
> +in KVM guests and attempted use of the feature will result in an UNDEFINED
> +exception being injected into the guest.

> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index cd209f7..e20583a 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2634,6 +2634,10 @@ Possible features:
>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>  	  Depends on KVM_CAP_ARM_PMU_V3.
> +	- KVM_ARM_VCPU_PTRAUTH: Emulate Pointer authentication for the CPU.
> +	  Depends on KVM_CAP_ARM_PTRAUTH and only on arm64 architecture. If
> +	  set, then the KVM guest allows the execution of pointer authentication
> +	  instructions or treats them as undefined if not set.

> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> index 1bfaf74..03999bb 100644
> --- a/arch/arm64/kvm/hyp/ptrauth-sr.c
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -71,3 +71,19 @@ void __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
>  	__ptrauth_save_state(guest_ctxt);
>  	__ptrauth_restore_state(host_ctxt);
>  }
> +
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
> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features))
> +		return true;
> +	else
> +		return false;
> +}

Can't you return the result of test_bit() directly?


Thanks,

James
