Return-Path: <SRS0=JhHZ=SS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3E7C10F13
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 16:31:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7718220821
	for <kvmarm@archiver.kernel.org>; Tue, 16 Apr 2019 16:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7718220821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 222164A4DE;
	Tue, 16 Apr 2019 12:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gu94WXMqBZ7S; Tue, 16 Apr 2019 12:31:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4EC14A4F3;
	Tue, 16 Apr 2019 12:31:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D484B4A4D4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 12:31:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5I-1rXp865w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Apr 2019 12:31:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E39E4A4CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Apr 2019 12:31:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C730880D;
 Tue, 16 Apr 2019 09:31:14 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2905E3F59C;
 Tue, 16 Apr 2019 09:31:13 -0700 (PDT)
Date: Tue, 16 Apr 2019 17:31:10 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v9 3/5] KVM: arm64: Add userspace flag to enable pointer
 authentication
Message-ID: <20190416163110.GW3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-4-git-send-email-amit.kachhap@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1555039236-10608-4-git-send-email-amit.kachhap@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190416163110.WIKp4teMsIRFErGVnPrbKI7T5KkhprcXhxDB0CF4cX0@z>

On Fri, Apr 12, 2019 at 08:50:34AM +0530, Amit Daniel Kachhap wrote:
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
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
> 
> Changes since v8:
> *  Update vcpu->arch.flags to final enable state. [Dave Martin]
> *  Change in Documentation to make clear the implementation of 2 vcpu
>    feature flags. [Dave Martin]
> 
>  Documentation/arm64/pointer-authentication.txt | 22 ++++++++++++++++++----
>  Documentation/virtual/kvm/api.txt              |  6 ++++++
>  arch/arm64/include/asm/kvm_host.h              |  2 +-
>  arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>  arch/arm64/kvm/reset.c                         | 24 ++++++++++++++++++++++++
>  5 files changed, 51 insertions(+), 5 deletions(-)
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
> index 68509de..9d202f4 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2753,6 +2753,12 @@ Possible features:
>  	  Depends on KVM_CAP_ARM_PSCI_0_2.
>  	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>  	  Depends on KVM_CAP_ARM_PMU_V3.
> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
> +	  for the CPU and supported only on arm64 architecture.

Nit: (arm64 only) would be less verbose.

> +	  Must be requested if KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
> +	  for the CPU and supported only on arm64 architecture.

Ditto.  (Not a big deal, though.)

> +	  Must be requested if KVM_ARM_VCPU_PTRAUTH_ADDRESS is also requested.
>  
>  	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>  	  Depends on KVM_CAP_ARM_SVE.
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a585d82..25f2598 100644
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
> index 6963b7e..fec2253 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -103,6 +103,8 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f13378d..d13406b 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -221,6 +221,24 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>  		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
>  }
>  
> +static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
> +{
> +	/* Support ptrauth only if the system supports these capabilities. */
> +	if (!has_vhe() || !system_supports_address_auth() ||
> +		!system_supports_generic_auth())
> +		return -EINVAL;

Nit: Funny indentation.  Please align with the "if (".  It's also
preferable to keep the two system_supports_xxx_auth() aligned or on the
same line, since they go together.  This might be clearer split up:

	if (!has_vhe())
		return -EINVAL;

	if (!system_supports_address_auth() ||
	    !system_supports_generic_auth())
		return -EINVAL;

> +	/*

I'd say "for now" here, since we might relax this rule later on.

> +	 * Make sure that both address/generic pointer authentication
> +	 * features are requested by the userspace together.
> +	 */
> +	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> +		!test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
> +		return -EINVAL;
> +
> +	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
> +	return 0;
> +}
> +
>  /**
>   * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>   * @vcpu: The VCPU pointer
> @@ -261,6 +279,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_reset_sve(vcpu);
>  	}
>  
> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {

Nit: funny indentation.

> +		if (kvm_vcpu_enable_ptrauth(vcpu))
> +			goto out;
> +	}
> +

[...]

With those fixed,

Reviewed-by: Dave Martin <Dave.Martin@arm.com>

Cheers
---Dave
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
