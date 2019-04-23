From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 3/5] KVM: arm64: Add userspace flag to enable pointer
 authentication
Date: Tue, 23 Apr 2019 16:45:23 +0100
Message-ID: <20190423154523.GN3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1555994558-26349-4-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 23, 2019 at 10:12:36AM +0530, Amit Daniel Kachhap wrote:
> Now that the building blocks of pointer authentication are present, lets
> add userspace flags KVM_ARM_VCPU_PTRAUTH_ADDRESS and
> KVM_ARM_VCPU_PTRAUTH_GENERIC. These flags will enable pointer
> authentication for the KVM guest on a per-vcpu basis through the ioctl
> KVM_ARM_VCPU_INIT.
> 
> This features will allow the KVM guest to allow the handling of
> pointer authentication instructions or to treat them as undefined
> if not set.
> 
> Necessary documentations are added to reflect the changes done.
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> Changed since v9:
> * Fixed tab alignment at few places [Dave Martin].
> * Split the system capability checks [Dave Martin].
> 
>  Documentation/arm64/pointer-authentication.txt | 22 +++++++++++++++++----
>  Documentation/virtual/kvm/api.txt              | 10 ++++++++++
>  arch/arm64/include/asm/kvm_host.h              |  2 +-
>  arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>  arch/arm64/kvm/reset.c                         | 27 ++++++++++++++++++++++++++
>  5 files changed, 58 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
> index 5baca42..fc71b33 100644
> --- a/Documentation/arm64/pointer-authentication.txt
> +++ b/Documentation/arm64/pointer-authentication.txt
> @@ -87,7 +87,21 @@ used to get and set the keys for a thread.
>  Virtualization
>  --------------
>  
> -Pointer authentication is not currently supported in KVM guests. KVM
> -will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
> -the feature will result in an UNDEFINED exception being injected into
> -the guest.
> +Pointer authentication is enabled in KVM guest when each virtual cpu is
> +initialised by passing flags KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] and
> +requesting these two separate cpu features to be enabled. The current KVM
> +guest implementation works by enabling both features together, so both
> +these userspace flags are checked before enabling pointer authentication.
> +The separate userspace flag will allow to have no userspace ABI changes
> +if support is added in the future to allow these two features to be
> +enabled independently of one another.
> +
> +As Arm Architecture specifies that Pointer Authentication feature is
> +implemented along with the VHE feature so KVM arm64 ptrauth code relies
> +on VHE mode to be present.
> +
> +Additionally, when these vcpu feature flags are not set then KVM will
> +filter out the Pointer Authentication system key registers from
> +KVM_GET/SET_REG_* ioctls and mask those features from cpufeature ID
> +register. Any attempt to use the Pointer Authentication instructions will
> +result in an UNDEFINED exception being injected into the guest.
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index e410a9f..32afe7f 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2761,6 +2761,16 @@ Possible features:
>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>  	  Depends on KVM_CAP_ARM_PMU_V3.
>  
> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
> +	  for arm64 only.
> +	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> +	  must be requested or neither must be requested.
> +
> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
> +	  for arm64 only.
> +	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
> +	  must be requested or neither must be requested.
> +

This looks pretty clear now.

>  	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>  	  Depends on KVM_CAP_ARM_SVE.
>  	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7eebea7..f772ac2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -49,7 +49,7 @@
>  
>  #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>  
> -#define KVM_VCPU_MAX_FEATURES 5
> +#define KVM_VCPU_MAX_FEATURES 7
>  
>  #define KVM_REQ_SLEEP \
>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index edd2db8..7b7ac0f 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -104,6 +104,8 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 3402543..028d0c6 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -221,6 +221,27 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
>  }
>  
> +static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> +{
> +	/* Support ptrauth only if the system supports these capabilities. */
> +	if (!has_vhe())
> +		return -EINVAL;
> +
> +	if (!system_supports_address_auth() ||
> +	    !system_supports_generic_auth())
> +		return -EINVAL;

Since pointer auth implies v8.3 and v8.3 implies v8.1 and v8.1 implies VHE:

((system_supports_address_auth() || system_supports_generic_auth()) &&
!has_vhe()) implies that the hardware is broken or the kernel is buggy.

So, it probably makes sense to write

	if (!system_supports_address_auth() ||
	    !system_supports_generic_auth())
		return -EINVAL;

	if (WARN_ON(!has_vhe()))
		return -EINVAL;

This is not essential, and doesn't affect the ABI -- so we could apply
it on top later on.

[...]

FWIW:

Reviewed-by: Dave Martin <Dave.Martin@arm.com> (for the updates)

Cheers
---Dave
