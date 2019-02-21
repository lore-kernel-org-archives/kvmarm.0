From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 2/6] arm64/kvm: preserve host MDCR_EL2 value
Date: Thu, 21 Feb 2019 15:51:01 +0000
Message-ID: <20190221155101.GV3567@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-3-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550568271-5319-3-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 19, 2019 at 02:54:27PM +0530, Amit Daniel Kachhap wrote:
> Save host MDCR_EL2 value during kvm HYP initialisation and restore
> after every switch from host to guest. There should not be any
> change in functionality due to this.
> 
> The value of mdcr_el2 is now stored in struct kvm_cpu_context as
> both host and guest can now use this field in a common way.

Is MDCR_EL2 somehow relevant to pointer auth?

It's not entirely clear why this patch is here.

If this is a cleanup to align the handling of this register with
how HCR_EL2 is handled, it would be good to explain that in the commit
message.

> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm/include/asm/kvm_host.h   |  1 -
>  arch/arm64/include/asm/kvm_host.h |  6 ++----
>  arch/arm64/kvm/debug.c            | 28 ++++++----------------------
>  arch/arm64/kvm/hyp/switch.c       | 17 ++++-------------
>  arch/arm64/kvm/hyp/sysreg-sr.c    |  6 ++++++
>  virt/kvm/arm/arm.c                |  1 -
>  6 files changed, 18 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 05706b4..704667e 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -294,7 +294,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>  
> -static inline void kvm_arm_init_debug(void) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1b2e05b..2f1bb86 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -205,6 +205,8 @@ struct kvm_cpu_context {
>  
>  	/* HYP host/guest configuration */
>  	u64 hcr_el2;
> +	u32 mdcr_el2;
> +

ARMv8-A says MDCR_EL2 is a 64-bit register.

Bits [63:20] are currently RES0, so this is probably not a big deal.
But it would be better to make this 64-bit to prevent future accidents.
It may be better to make that change in a separate patch.

This is probably non-urgent, since this is clearly not causing problems
for anyone today.

[...]

Cheers
---Dave
