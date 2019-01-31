From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 4/5] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Thu, 31 Jan 2019 16:27:23 +0000
Message-ID: <1e3f2a9a-e3f7-bb06-495a-24f77a73cae0@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548658727-14271-5-git-send-email-amit.kachhap@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
> This feature will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> supply this parameter instead of creating a new API.
> 
> A new register is not created to pass this parameter via
> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> supplied is enough to enable this feature.


> diff --git a/Documentation/arm64/pointer-authentication.txt
b/Documentation/arm64/pointer-authentication.txt
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

Isn't that a VCPU flag? Shouldn't this be when each VCPU is created?


> requesting this feature
> +to be enabled. Without this flag, pointer authentication is not enabled
> +in KVM guests and attempted use of the feature will result in an UNDEFINED
> +exception being injected into the guest.

... what happens if KVM's user-space enables ptrauth on some vcpus, but not on
others?

You removed the id-register suppression in the previous patch, but it doesn't
get hooked up to kvm_arm_vcpu_ptrauth_allowed() here. (you could add
kvm_arm_vcpu_ptrauth_allowed() earlier, and default it to true to make it easier).

Doesn't this mean that if the CPU supports pointer auth, but user-space doesn't
specify this flag, the guest gets mysterious undef's whenever it tries to use
the advertised feature?

(whether we support big/little virtual-machines is probably a separate issue,
but the id registers need to be consistent with our trap-and-undef behaviour)


> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c798d0c..4a6ec40 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -453,14 +453,15 @@ static inline bool kvm_arch_requires_vhe(void)
>  
>  void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
>  void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
> +bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu);
>  
>  static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
>  {
>  	/* Disable ptrauth and use it in a lazy context via traps */
> -	if (has_vhe() && kvm_supports_ptrauth())
> +	if (has_vhe() && kvm_supports_ptrauth()
> +			&& kvm_arm_vcpu_ptrauth_allowed(vcpu))
>  		kvm_arm_vcpu_ptrauth_disable(vcpu);
>  }
> -
>  void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>  

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 5b980e7..c0e5dcd 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -179,7 +179,8 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>   */
>  void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
>  {
> -	if (has_vhe() && kvm_supports_ptrauth())
> +	if (has_vhe() && kvm_supports_ptrauth()
> +			&& kvm_arm_vcpu_ptrauth_allowed(vcpu))

Duplication. If has_vhe() moved into kvm_supports_ptrauth(), and
kvm_supports_ptrauth() was called from kvm_arm_vcpu_ptrauth_allowed() it would
be clearer that use of this feature was becoming user-controlled policy.

(We don't need to list the dependencies at every call site)


> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> index 0576c01..369624f 100644
> --- a/arch/arm64/kvm/hyp/ptrauth-sr.c
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -42,3 +42,16 @@ void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
>  	ptrauth_keys_store((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
>  	ptrauth_keys_switch((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
>  }
> +
> +/**
> + * kvm_arm_vcpu_ptrauth_allowed - checks if ptrauth feature is present in vcpu

('enabled by KVM's user-space' may be clearer. 'Present in vcpu' could be down
to a cpufeature thing)


> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function will be used to enable/disable ptrauth in guest as configured

... but it just tests the bit ...

> + * by the KVM userspace API.
> + */
> +bool kvm_arm_vcpu_ptrauth_allowed(struct kvm_vcpu *vcpu)
> +{
> +	return test_bit(KVM_ARM_VCPU_PTRAUTH, vcpu->arch.features);
> +}


Thanks,

James
