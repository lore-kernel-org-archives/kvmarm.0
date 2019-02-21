From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 4/6] arm64/kvm: add a userspace option to enable
 pointer authentication
Date: Thu, 21 Feb 2019 15:53:50 +0000
Message-ID: <20190221155350.GY3567@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550568271-5319-5-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 19, 2019 at 02:54:29PM +0530, Amit Daniel Kachhap wrote:
> This feature will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set. It uses the existing vcpu API KVM_ARM_VCPU_INIT to
> supply this parameter instead of creating a new API.
> 
> A new register is not created to pass this parameter via
> SET/GET_ONE_REG interface as just a flag (KVM_ARM_VCPU_PTRAUTH)
> supplied is enough to enable this feature.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  Documentation/arm64/pointer-authentication.txt |  9 +++++----
>  Documentation/virtual/kvm/api.txt              |  4 ++++
>  arch/arm64/include/asm/kvm_host.h              |  3 ++-
>  arch/arm64/include/uapi/asm/kvm.h              |  1 +
>  arch/arm64/kvm/handle_exit.c                   |  2 +-
>  arch/arm64/kvm/hyp/ptrauth-sr.c                | 16 +++++++++++++++-
>  arch/arm64/kvm/reset.c                         |  3 +++
>  arch/arm64/kvm/sys_regs.c                      | 26 +++++++++++++-------------
>  include/uapi/linux/kvm.h                       |  1 +
>  9 files changed, 45 insertions(+), 20 deletions(-)
> 

[...]

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1bacf78..2768a53 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -43,7 +43,7 @@
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> -#define KVM_VCPU_MAX_FEATURES 4
> +#define KVM_VCPU_MAX_FEATURES 5
>  
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> @@ -451,6 +451,7 @@ static inline bool kvm_arch_requires_vhe(void)
>  	return false;
>  }
>  
> +bool kvm_arm_vcpu_ptrauth_allowed(const struct kvm_vcpu *vcpu);
>  static inline bool kvm_supports_ptrauth(void)
>  {
>  	return has_vhe() && system_supports_address_auth() &&

[...]

> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> index 528ee6e..6846a23 100644
> --- a/arch/arm64/kvm/hyp/ptrauth-sr.c
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -93,9 +93,23 @@ void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)

[...]

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

Nit: for SVE is called the equivalent helper vcpu_has_sve(vcpu).

Neither naming is more correct, but it would make sense to be
consistent.  We will likely accumulate more of these vcpu feature
predicates over time.

Given that this is trivial and will be used all over the place, it
probably makes sense to define it in kvm_host.h rather than having it
out of line in a separate C file.

> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index b72a3dd..987e0c3c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -91,6 +91,9 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  		r = kvm_ipa_limit;
>  		break;
> +	case KVM_CAP_ARM_PTRAUTH:
> +		r = kvm_supports_ptrauth();
> +		break;
>  	default:
>  		r = 0;
>  	}
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
>  {
>  	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
>  			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> @@ -1071,7 +1071,7 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> -		if (!kvm_supports_ptrauth()) {
> +		if (!kvm_arm_vcpu_ptrauth_allowed(vcpu)) {
>  			kvm_debug("ptrauth unsupported for guests, suppressing\n");
>  			val &= ~ptrauth_mask;
>  		}
> @@ -1095,7 +1095,7 @@ static bool __access_id_reg(struct kvm_vcpu *vcpu,
>  	if (p->is_write)
>  		return write_to_read_only(vcpu, p, r);
>  
> -	p->regval = read_id_reg(r, raz);
> +	p->regval = read_id_reg(vcpu, r, raz);
>  	return true;
>  }

The SVE KVM series makes various overlapping changes to propagate vcpuo
into the relevant places, but hopefully the rebase is not too painful.
Many of the changes are probably virtually identical between the two
series.

See for example [1].  Maybe you could cherry-pick and drop the
equivalent changes here (though if your series is picked up first, I
will live with it ;)

[...]

Cheers
---Dave


[1] [PATCH v5 10/26] KVM: arm64: Propagate vcpu into read_id_reg()
https://lists.cs.columbia.edu/pipermail/kvmarm/2019-February/034687.html
