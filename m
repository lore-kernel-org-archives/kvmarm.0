From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v8 8/9] KVM: arm64: Add capability to advertise ptrauth
 for guest
Date: Fri, 5 Apr 2019 12:03:39 +0100
Message-ID: <20190405110339.GU3567@e103592.cambridge.arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-9-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1554172037-4516-9-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 07:57:16AM +0530, Amit Daniel Kachhap wrote:
> This patch advertises the capability of two cpu feature called address
> pointer authentication and generic pointer authentication. These
> capabilities depend upon system support for pointer authentication and
> VHE mode.
> 
> The current arm64 KVM partially implements pointer authentication and
> support of address/generic authentication are tied together. However,
> separate ABI requirements for both of them is added so that the future
> isolated implementation will not require any ABI changes.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> 
> Changes since v7:
> * Created 2 capabilities KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC
>   instead of one KVM_CAP_ARM_PTRAUTH [Kristina Martsenko].
> * Added documentation here itself instead of in a new patch.
> 
>  Documentation/virtual/kvm/api.txt | 3 +++
>  arch/arm64/kvm/reset.c            | 6 ++++++
>  include/uapi/linux/kvm.h          | 2 ++
>  3 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index aaa048d..9b56892 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2661,8 +2661,11 @@ Possible features:
>  	  Depends on KVM_CAP_ARM_PMU_V3.
>  	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>  	  for the CPU and supported only on arm64 architecture.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>  	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>  	  for the CPU and supported only on arm64 architecture.
> +	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>  
>  
>  4.83 KVM_ARM_PREFERRED_TARGET
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 717afed..8aa8982 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -92,6 +92,12 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  		r = kvm_ipa_limit;
>  		break;
> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
> +		r = has_vhe() && system_supports_address_auth();
> +		break;
> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +		r = has_vhe() && system_supports_generic_auth();
> +		break;

If some hardware supports just one auth type, we would report just one
of these caps.  Although we have the rule that userspace is not allowed
to request these independently in KVM_ARM_VCPU_INIT anyway, I think it
would be easier for userspace if we suppress both caps if either auth
type isn't available on the host.  e.g.:

	case KVM_ARM_ARM_PTRAUTH_ADDRESS:
	case KVM_ARM_ARM_PTRAUTH_GENERIC:
		r = has_vhe() && system_supports_address_auth() &&
			system_supports_generic_auth();

We could revert back to the above code later on, and apply the ABI
relaxations described in my response to the vcpu features patch, if
someday we add support to KVM for coping with host hardware that
supports just one auth type.


I'd like Mark to comment on this, since he's more aware of the
architectural situation than I am.

Cheers
---Dave
