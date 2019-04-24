Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8B7C10F11
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 06:39:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F183C218DA
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 06:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F183C218DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 734394A41C;
	Wed, 24 Apr 2019 02:39:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WppTRI-MJg69; Wed, 24 Apr 2019 02:39:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F258C4A4B0;
	Wed, 24 Apr 2019 02:39:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17DF94A41C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 02:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HA2pYVxqTbib for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 02:39:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3095E4A320
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 02:39:33 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5703FA78;
 Tue, 23 Apr 2019 23:39:32 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C54083F238;
 Tue, 23 Apr 2019 23:39:29 -0700 (PDT)
Subject: Re: [PATCH v10 3/5] KVM: arm64: Add userspace flag to enable pointer
 authentication
To: Dave Martin <Dave.Martin@arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-4-git-send-email-amit.kachhap@arm.com>
 <20190423154523.GN3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <5cdb3c42-028c-cfdd-a595-2c3f63f91dad@arm.com>
Date: Wed, 24 Apr 2019 12:09:27 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190423154523.GN3567@e103592.cambridge.arm.com>
Content-Language: en-US
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424063927.vvRagRbL9E0O_MngJPltnCYa0S7PnN2VOwQUYt94iq8@z>

Hi,

On 4/23/19 9:15 PM, Dave Martin wrote:
> On Tue, Apr 23, 2019 at 10:12:36AM +0530, Amit Daniel Kachhap wrote:
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
>> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>> Changed since v9:
>> * Fixed tab alignment at few places [Dave Martin].
>> * Split the system capability checks [Dave Martin].
>>
>>   Documentation/arm64/pointer-authentication.txt | 22 +++++++++++++++++----
>>   Documentation/virtual/kvm/api.txt              | 10 ++++++++++
>>   arch/arm64/include/asm/kvm_host.h              |  2 +-
>>   arch/arm64/include/uapi/asm/kvm.h              |  2 ++
>>   arch/arm64/kvm/reset.c                         | 27 ++++++++++++++++++++++++++
>>   5 files changed, 58 insertions(+), 5 deletions(-)
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
>> index e410a9f..32afe7f 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2761,6 +2761,16 @@ Possible features:
>>   	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
>>   	  Depends on KVM_CAP_ARM_PMU_V3.
>>   
>> +	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>> +	  for arm64 only.
>> +	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
>> +	  must be requested or neither must be requested.
>> +
>> +	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>> +	  for arm64 only.
>> +	  Both KVM_ARM_VCPU_PTRAUTH_ADDRESS and KVM_ARM_VCPU_PTRAUTH_GENERIC
>> +	  must be requested or neither must be requested.
>> +
> 
> This looks pretty clear now.
> 
>>   	- KVM_ARM_VCPU_SVE: Enables SVE for the CPU (arm64 only).
>>   	  Depends on KVM_CAP_ARM_SVE.
>>   	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_SVE):
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7eebea7..f772ac2 100644
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
>> index edd2db8..7b7ac0f 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -104,6 +104,8 @@ struct kvm_regs {
>>   #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>>   #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
>>   #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
>> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
>> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
>>   
>>   struct kvm_vcpu_init {
>>   	__u32 target;
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 3402543..028d0c6 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -221,6 +221,27 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>>   		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
>>   }
>>   
>> +static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>> +{
>> +	/* Support ptrauth only if the system supports these capabilities. */
>> +	if (!has_vhe())
>> +		return -EINVAL;
>> +
>> +	if (!system_supports_address_auth() ||
>> +	    !system_supports_generic_auth())
>> +		return -EINVAL;
> 
> Since pointer auth implies v8.3 and v8.3 implies v8.1 and v8.1 implies VHE:
> 
> ((system_supports_address_auth() || system_supports_generic_auth()) &&
> !has_vhe()) implies that the hardware is broken or the kernel is buggy.
> 
> So, it probably makes sense to write
> 
> 	if (!system_supports_address_auth() ||
> 	    !system_supports_generic_auth())
> 		return -EINVAL;
> 
> 	if (WARN_ON(!has_vhe()))
> 		return -EINVAL;

Yes agree with you. Now with config VHE restriction set it makes more 
sense that this situation will only occur now in buggy h/w case.
> 
> This is not essential, and doesn't affect the ABI -- so we could apply
> it on top later on.
> 
> [...]
> 
> FWIW:
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com> (for the updates)
Thanks for the review effort.

Thanks,
Amit D
> 
> Cheers
> ---Dave
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
