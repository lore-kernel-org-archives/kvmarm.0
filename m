From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v8 6/9] KVM: arm64: Add vcpu feature flags to control
 ptrauth accessibility
Date: Mon, 8 Apr 2019 10:42:33 +0530
Message-ID: <ff139c2b-61bc-d4dd-51af-d3c8b5c3ca2e@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-7-git-send-email-amit.kachhap@arm.com>
 <20190405110245.GT3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190405110245.GT3567@e103592.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 4/5/19 4:32 PM, Dave Martin wrote:
> On Tue, Apr 02, 2019 at 07:57:14AM +0530, Amit Daniel Kachhap wrote:
>> Since Pointer authentication will be enabled or disabled on a
>> per-vcpu basis, vcpu feature flags are added in order to know which
>> vcpus have it enabled from userspace.
>>
>> This features will allow the KVM guest to allow the handling of
>> pointer authentication instructions or to treat them as undefined
>> if not set.
>>
>> The helper macro added checks the feature flag along with other
>> conditions such as VHE mode present and system support for
>> pointer address/generic authentication.
> 
> Can this patch be put after the context switch patch instead?
> 
> Here, we accept a request from userspace to enable ptrauth, but it will
> mysteriously fail to work.  I worked around a similar issue by defining
> KVM_ARM64_GUEST_HAS_SVE early in the SVE series, but putting the logic
> to set this flag in vcpu->arch.flags later on (see also comments about
> this below).
> 
>> Necessary documentations are added to reflect the changes done.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v7:
>> * Moved the check for userspace features in this patch [James Morse].
>> * Moved the vcpu feature flags Documentation in this patch [James Morse].
>>
>>   Documentation/arm64/pointer-authentication.txt | 13 +++++++++----
>>   Documentation/virtual/kvm/api.txt              |  4 ++++
>>   arch/arm64/include/asm/kvm_host.h              |  8 +++++++-
>>   arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>>   arch/arm64/kvm/reset.c                         |  7 +++++++
>>   5 files changed, 29 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
>> index 5baca42..b164886 100644
>> --- a/Documentation/arm64/pointer-authentication.txt
>> +++ b/Documentation/arm64/pointer-authentication.txt
>> @@ -87,7 +87,12 @@ used to get and set the keys for a thread.
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
>> +guest implementation works by enabling both features together, so both these
>> +userspace flags are checked together before enabling pointer authentication.
>> +The separate userspace flag will allow to have no userspace ABI changes when
>> +both features are implemented in an isolated way in future.
> 
> Nit: we might make this change, but we don't promise that it will happsen.
> 
> So, maybe write:
> 
> "[...] have no userspace ABI changes if support is added in the future
> to allow these two features to be enabled independently of one another."
Ok. sounds good.
> 
>> +
>> +Pointer Authentication is supported in KVM guest only in VHE mode.
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 7de9eee..aaa048d 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2659,6 +2659,10 @@ Possible features:
>>   	  Depends on KVM_CAP_ARM_PSCI_0_2.
>>   	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>   	  Depends on KVM_CAP_ARM_PMU_V3.
>> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>> +	  for the CPU and supported only on arm64 architecture.
> 
> We should probably add:
> 
> 	Must be requested if KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> 
>> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>> +	  for the CPU and supported only on arm64 architecture.
> 
> Similarly:
> 
> 	Must be requested if KVM_ARM_VCPU_PTRAUTH_ADDRESS is also requested.
ok.
> 
> (Or otherwise explain that both features must enabled together or not at
> all.)
> 
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index e3ccd7b..9dd2918 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -45,7 +45,7 @@
>>   
>>   #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>>   
>> -#define KVM_VCPU_MAX_FEATURES 4
>> +#define KVM_VCPU_MAX_FEATURES 6
>>   
>>   #define KVM_REQ_SLEEP \
>>   	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>> @@ -491,6 +491,12 @@ static inline bool kvm_arch_requires_vhe(void)
>>   	return false;
>>   }
>>   
>> +#define vcpu_has_ptrauth(vcpu)	(has_vhe() && \
>> +		system_supports_address_auth() && \
>> +		system_supports_generic_auth() && \
>> +		test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) && \
>> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
> 
> We're checking 5 things here, which we don't necessarily want to do
> every time.
> 
> Is this used on any hot path?
These checks are used in vcpu_load level but not in vcpu_run level.
> 
> This kind of thing is one reason why I added vcpu->arch.flags: we can
> make the policy decision about whether to set the flag in
> kvm_reset_vcpu(), then afterwards we only need to check the flag.
Yes agree that deep checks can be avoided. Let me check your SVE series 
of using vcpu->arch.flags.
> 
>> +
>>   static inline void kvm_arch_hardware_unsetup(void) {}
>>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>   static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 97c3478..8806f71 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -102,6 +102,8 @@ struct kvm_regs {
>>   #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>>   #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>>   #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	4 /* VCPU uses address authentication */
>> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	5 /* VCPU uses generic authentication */
>>   
>>   struct kvm_vcpu_init {
>>   	__u32 target;
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index f16a5f8..717afed 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -128,6 +128,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>>   	if (loaded)
>>   		kvm_arch_vcpu_put(vcpu);
>>   
>> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
>> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
>> +		/* Verify that KVM startup matches the conditions for ptrauth */
>> +		if (!vcpu_has_ptrauth(vcpu))
>> +			goto out;
>> +	}
>> +
> 
> This looks like it works, but I find the way vcpu->arch.features is used
> in two different ways at the same time a bit confusing.
ok. Will check if some other way of placing the checks with vcpu->arch.flags

Thanks,
Amit D.
> 
> Cheers
> ---Dave
> 
