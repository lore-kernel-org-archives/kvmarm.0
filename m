From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: Re: [PATCH v7 8/10] KVM: arm64: Add capability to advertise ptrauth
 for guest
Date: Mon, 25 Mar 2019 20:05:30 +0000
Message-ID: <1ea6ab95-a52e-3f14-a514-b0b747b85f3a@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-9-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-9-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
> This patch advertises the capability of pointer authentication
> when system supports pointer authentication and VHE mode present.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/kvm/reset.c   | 4 ++++
>  include/uapi/linux/kvm.h | 1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 00f0639..a3b269e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -92,6 +92,10 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  		r = kvm_ipa_limit;
>  		break;
> +	case KVM_CAP_ARM_PTRAUTH:
> +		r = has_vhe() && system_supports_address_auth() &&
> +			system_supports_generic_auth();
> +		break;
>  	default:
>  		r = 0;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6d4ea4b..a553477 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -988,6 +988,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_VM_IPA_SIZE 165
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
> +#define KVM_CAP_ARM_PTRAUTH 168

Since we now have two separate vcpu flags, then I think we also need two
capabilities here (one for address auth and one for generic auth). This
will allow us to support the features separately in the future if we
need to.

Thanks,
Kristina
