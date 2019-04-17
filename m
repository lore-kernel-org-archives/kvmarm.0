From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth for
 guest
Date: Wed, 17 Apr 2019 09:35:34 +0100
Message-ID: <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
> A per vcpu flag is added to check if pointer authentication is
> enabled for the vcpu or not. This flag may be enabled according to
> the necessary user policies and host capabilities.
> 
> This patch also adds a helper to check the flag.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> 
> Changes since v8:
> * Added a new per vcpu flag which will store Pointer Authentication enable
>   status instead of checking them again. [Dave Martin]
> 
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9d57cf8..31dbc7c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>  #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>  #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  
> +#define vcpu_has_ptrauth(vcpu)	\
> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +

Just as for SVE, please first check that the system has PTRAUTH.
Something like:

		(cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_ARCH) && \
		 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))

This will save an extra load on unsuspecting CPUs thanks to the static
key embedded in the capability structure.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
