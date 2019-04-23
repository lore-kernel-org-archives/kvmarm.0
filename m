From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 4/5] KVM: arm64: Add capability to advertise ptrauth
 for guest
Date: Tue, 23 Apr 2019 16:45:33 +0100
Message-ID: <20190423154533.GO3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1555994558-26349-5-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 23, 2019 at 10:12:37AM +0530, Amit Daniel Kachhap wrote:
> This patch advertises the capability of two cpu feature called address
> pointer authentication and generic pointer authentication. These
> capabilities depend upon system support for pointer authentication and
> VHE mode.
> 
> The current arm64 KVM partially implements pointer authentication and
> support of address/generic authentication are tied together. However,
> separate ABI requirements for both of them is added so that any future
> isolated implementation will not require any ABI changes.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> Changes since v9:
> * Fixed tab alignment issues [Dave Martin].
> * Clarify the api documentation [Dave Martin].
> 
>  Documentation/virtual/kvm/api.txt | 14 ++++++++++----
>  arch/arm64/kvm/reset.c            |  5 +++++
>  include/uapi/linux/kvm.h          |  2 ++
>  3 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 32afe7f..fac1887 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2763,13 +2763,19 @@ Possible features:
>  
>  	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>  	  for arm64 only.
> -	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> -	  must be requested or neither must be requested.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> +	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
> +	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
> +	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
> +	  requested.
>  
>  	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>  	  for arm64 only.
> -	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> -	  must be requested or neither must be requested.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
> +	  If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
> +	  both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
> +	  KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
> +	  requested.

This looks clear now.

The description is quite heavyweight, but should be hard for people to
misunderstand.

>  	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>  	  Depends on KVM_CAP_ARM_SVE.
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 028d0c6..f0faf54 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -101,6 +101,11 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_SVE:
>  		r = system_supports_sve();
>  		break;
> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +		r = has_vhe() && system_supports_address_auth() &&
> +				 system_supports_generic_auth();
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 1d56444..4dc34f8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -989,6 +989,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
>  #define KVM_CAP_ARM_SVE 168
> +#define KVM_CAP_ARM_PTRAUTH_ADDRESS 169
> +#define KVM_CAP_ARM_PTRAUTH_GENERIC 170

[...]

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

Cheers
---Dave
