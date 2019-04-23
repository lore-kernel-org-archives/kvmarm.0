From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 1/5] KVM: arm64: Add a vcpu flag to control ptrauth
 for guest
Date: Tue, 23 Apr 2019 16:44:19 +0100
Message-ID: <20190423154419.GL3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-2-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1555994558-26349-2-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 23, 2019 at 10:12:34AM +0530, Amit Daniel Kachhap wrote:
> A per vcpu flag is added to check if pointer authentication is
> enabled for the vcpu or not. This flag may be enabled according to
> the necessary user policies and host capabilities.
> 
> This patch also adds a helper to check the flag.
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> Changes since v9:
> 
> * Added ptrauth cpufeature static check in vcpu_has_ptrauth [Marc Zyngier].
> 
>  arch/arm64/include/asm/kvm_host.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7a096fd..7ccac42 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -355,10 +355,15 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>  #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>  #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>  
> +#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
> +				  system_supports_generic_auth()) && \

Come to think of it, should this be
system_supports_address_auth() _&&_ system_supports_generic_auth()?

It won't make a functional difference today though, since today
kvm_vcpu_enable_ptrauth() won't set KVM_ARM64_GUEST_HAS_PTRAUTH without
system_supports_address_auth() and system_supports_generic_auth() both
true.

With || here, we won't have to change this if supporting the two auth
types independently in the future though.

Either way, my Reviewed-by stands.

Cheers
---Dave
