From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v9 3/5] KVM: arm64: Add userspace flag to enable pointer
 authentication
Date: Wed, 17 Apr 2019 13:47:24 +0530
Message-ID: <d27e74e0-ad26-c47e-4998-fd1d854fef18@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-4-git-send-email-amit.kachhap@arm.com>
 <20190416163110.GW3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416163110.GW3567@e103592.cambridge.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu


Hi,
On 4/16/19 10:01 PM, Dave Martin wrote:
> On Fri, Apr 12, 2019 at 08:50:34AM +0530, Amit Daniel Kachhap wrote:
>> Now that the building blocks of pointer authentication are present, lets
>> add userspace flags KVM_ARM_VCPU_PTRAUTH_ADDRESS and
>> KVM_ARM_VCPU_PTRAUTH_GENERIC. These flags will enable pointer
>> authentication for the KVM guest on a per-vcpu basis through the ioctl
>> KVM_ARM_VCPU_INIT.
>>
>> This features will allow the KVM guest to allow the handling of
>> pointer authentication instructions or to treat them as undefined
>> if not set.
>>
>> Necessary documentations are added to reflect the changes done.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v8:
>> *  Update vcpu->arch.flags to final enable state. [Dave Martin]
>> *  Change in Documentation to make clear the implementation of 2 vcpu
>>     feature flags. [Dave Martin]
>>
>>   Documentation/arm64/pointer-authentication.txt | 22 ++++++++++++++++++----
>>   Documentation/virtual/kvm/api.txt              |  6 ++++++
>>   arch/arm64/include/asm/kvm_host.h              |  2 +-
>>   arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>>   arch/arm64/kvm/reset.c                         | 24 ++++++++++++++++++++++++
>>   5 files changed, 51 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
>> index 5baca42..fc71b33 100644
>> --- a/Documentation/arm64/pointer-authentication.txt
>> +++ b/Documentation/arm64/pointer-authentication.txt
>> @@ -87,7 +87,21 @@ used to get and set the keys for a thread.
>>   Virtualization
>>   --------------
>>   
>> -Pointer authentication is not currently supported in KVM guests. KVM
>> -will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
>> -the feature will result in an UNDEFINED exception being injected into
>> -the guest.
>> +Pointer authentication is enabled in KVM guest when each virtual cpu is
>> +initialised by passing flags KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] and
>> +requesting these two separate cpu features to be enabled. The current KVM
>> +guest implementation works by enabling both features together, so both
>> +these userspace flags are checked before enabling pointer authentication.
>> +The separate userspace flag will allow to have no userspace ABI changes
>> +if support is added in the future to allow these two features to be
>> +enabled independently of one another.
>> +
>> +As Arm Architecture specifies that Pointer Authentication feature is
>> +implemented along with the VHE feature so KVM arm64 ptrauth code relies
>> +on VHE mode to be present.
>> +
>> +Additionally, when these vcpu feature flags are not set then KVM will
>> +filter out the Pointer Authentication system key registers from
>> +KVM_GET/SET_REG_* ioctls and mask those features from cpufeature ID
>> +register. Any attempt to use the Pointer Authentication instructions will
>> +result in an UNDEFINED exception being injected into the guest.
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 68509de..9d202f4 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2753,6 +2753,12 @@ Possible features:
>>   	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>   	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>   	  Depends on KVM_CAP_ARM_PMU_V3.
>> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>> +	  for the CPU and supported only on arm64 architecture.
> 
> Nit: (arm64 only) would be less verbose.
ok.
> 
>> +	  Must be requested if KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
>> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>> +	  for the CPU and supported only on arm64 architecture.
> 
> Ditto.  (Not a big deal, though.)
> 
>> +	  Must be requested if KVM_ARM_VCPU_PTRAUTH_ADDRESS is also requested.
>>   
>>   	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>>   	  Depends on KVM_CAP_ARM_SVE.
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index a585d82..25f2598 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -49,7 +49,7 @@
>>   
>>   #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>   
>> -#define KVM_VCPU_MAX_FEATURES 5
>> +#define KVM_VCPU_MAX_FEATURES 7
>>   
>>   #define KVM_REQ_SLEEP \
>>   	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 6963b7e..fec2253 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -103,6 +103,8 @@ struct kvm_regs {
>>   #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>>   #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>>   #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>>   
>>   struct kvm_vcpu_init {
>>   	__u32 target;
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index f13378d..d13406b 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -221,6 +221,24 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>>   		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
>>   }
>>   
>> +static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>> +{
>> +	/* Support ptrauth only if the system supports these capabilities. */
>> +	if (!has_vhe() || !system_supports_address_auth() ||
>> +		!system_supports_generic_auth())
>> +		return -EINVAL;
> 
> Nit: Funny indentation.  Please align with the "if (".  It's also
> preferable to keep the two system_supports_xxx_auth() aligned or on the
> same line, since they go together.  This might be clearer split up:
> 
> 	if (!has_vhe())
> 		return -EINVAL;
> 
> 	if (!system_supports_address_auth() ||
> 	    !system_supports_generic_auth())
> 		return -EINVAL;
ok.
> 
>> +	/*
> 
> I'd say "for now" here, since we might relax this rule later on.
> 
>> +	 * Make sure that both address/generic pointer authentication
>> +	 * features are requested by the userspace together.
>> +	 */
>> +	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>> +		!test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
>> +		return -EINVAL;
>> +
>> +	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
>> +	return 0;
>> +}
>> +
>>   /**
>>    * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>>    * @vcpu: The VCPU pointer
>> @@ -261,6 +279,12 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>   		kvm_vcpu_reset_sve(vcpu);
>>   	}
>>   
>> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
> 
> Nit: funny indentation.
> 
>> +		if (kvm_vcpu_enable_ptrauth(vcpu))
>> +			goto out;
>> +	}
>> +
> 
> [...]
> 
> With those fixed,
sure.
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Thanks,
Amit
> 
> Cheers
> ---Dave
> 
