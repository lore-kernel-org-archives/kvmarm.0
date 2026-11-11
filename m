Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794388106;
	b=cDK2fFHapXY+UC1wnMdz72zs3U76Pzf7FBqFnExDqe/U71VZXxjkwZiqlPW7J6IFBETi
	 ugkg0RvgNAsTQEzg0R9btV1ZIfChMYpMxOSkZXtvgPPMNbdyHYBDTmX4fKtzIVotpzKK9
	 jjvi7eRsSnbSEtt7pgt2nkObUl9iVbguFNeUO4OMznUyfokItUNSSHpGqRfW1aE8x5/NJ
	 QHVeoZAzlE52e9N6E5aKfl2XmQTIq/MPdV9D2aeSKaSXolhWbwaZmWxaiR83heFTgd3W9
	 HxPSDm4gWDNS+fLKymepUiKk093p34Yw9de36677lJleD2Z8F2hltD7SE44nmFlDT4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794388106;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=411x4IUu5f63wpL/igqSv/CLQ5Z6cNypZUlf1yFV00w=;
	b=aLPRgyCcTeYwWOqFpQoXXLDgv7NL4ar+t1zRleJiaVSvXafhp8ZAfZVujR3x3N1l92oo
	 I/JE/5VJETOMsCWpHOpm+xbQBsysBrxM6LVjssJm33DriABKsMaHC7S/TQnz21Xg52aQj
	 5exDavjuwz7resMZJ/rEKQYicsqgubT26BPkZOV2mQRIwu8eSc0VQz+g4BqYbg1/kv2M4
	 VuUCMKFcfGPaZ4iCeLQMtEy+bjNakOiXrX/ddtYw/SfTRXhscih7UIfot23g0Tqttd6oE
	 28+yekEqNg4oKGb62F7wlQGzq2e72n1dO6yaTHLxInc1F7FEmzoEbM6dtq/QEDlOAkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HXqCwPK6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C0F606A33C;
	Wed, 11 Nov 2026 09:08:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5C0F606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HXqCwPK6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BADC1576;
	Wed, 11 Nov 2026 01:08:20 -0800 (PST)
Received: from [10.0.128.239] (Suzukis-MBP.cambridge.arm.com [10.0.128.239])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7216E3F673;
	Wed, 11 Nov 2026 01:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794388103; bh=nSaH8ajMJJME+6Ks3xnSitadsLP4ZRVuIcCsdKoA3qA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HXqCwPK6XA6YFtPLkolK5F9poJFn8YqHan7BIIVpk9L0jQy1AAjBhpENzctGIYJWl
	 tkA/irUhDCLtTR+BG9LjZF6RdW+xZP7x9b82BUD8Zbtes3/2hBiKngUrV++kNfZ3qa
	 VeVNBW10FPqQgr98xdcciLotqwK5aP458TqJDa+E=
Message-ID: <9dc56bf6-b417-4000-b49b-037bee250dba@arm.com>
Date: Wed, 11 Nov 2026 09:08:19 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] KVM: arm64: CCA: Introduce Realms
To: Kohei Enju <enju.kohei@fujitsu.com>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-3-steven.price@arm.com>
 <avL9kNR2mGmqmcA9@FCCLS0092175.localdomain>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <avL9kNR2mGmqmcA9@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Kohei

On 10/11/2026 11:42, Kohei Enju wrote:
> Hi Steve,
> 
> On 11/02 14:12, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Add foundational work for supporting Realms.
>>   - Add a new VM flavor.
>>   - At KVM init, check if the KVM can support Realms (though not functional
>>     yet) and will be advertised by static key kvm_rmi_is_available. This
>>     will be turned on in a later patch, once we have all the bits and
>>     pieces ready. For now check if we are blessed with KVM_MODE_RMM.
>>   - Add realm specific tracking in kvm_arch. Since Realm and protected pKVM
>>     states are mutually exclusive, move them into a union.
>>   - Also adjust the memslot preparation checks to reflect the changes.
>>
>> Please note that we cannot create Realm VMs yet. This requires further
>> changes to the UABI and core RMI driver support, which will come later.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h   | 16 +++++++
>>   arch/arm64/include/asm/kvm_host.h      | 57 +++++++++++++++++-------
>>   arch/arm64/include/asm/kvm_rmi.h       | 61 ++++++++++++++++++++++++++
>>   arch/arm64/include/asm/virt.h          |  1 +
>>   arch/arm64/kvm/Makefile                |  2 +-
>>   arch/arm64/kvm/arm.c                   | 24 ++++++++--
>>   arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  2 +-
>>   arch/arm64/kvm/hyp/nvhe/switch.c       |  4 +-
>>   arch/arm64/kvm/hyp/nvhe/timer-sr.c     |  2 +-
>>   arch/arm64/kvm/mmu.c                   | 13 +++---
>>   arch/arm64/kvm/rmi.c                   | 18 ++++++++
>>   11 files changed, 169 insertions(+), 31 deletions(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>>   create mode 100644 arch/arm64/kvm/rmi.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index 334211b8b2ee..32021bdf2610 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -831,4 +831,20 @@ static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
>>   	vcpu_set_reg(vcpu, 0, reset_state->r0);
>>   }
>>   
>> +static inline enum realm_state kvm_realm_state(struct kvm *kvm)
>> +{
>> +	return READ_ONCE(kvm->arch.realm.state);
>> +}
>> +
>> +static inline void kvm_set_realm_state(struct kvm *kvm,
>> +				       enum realm_state new_state)
>> +{
>> +	WRITE_ONCE(kvm->arch.realm.state, new_state);
>> +}
>> +
>> +static inline bool kvm_realm_is_created(struct kvm *kvm)
>> +{
>> +	return kvm_vm_is_realm(kvm) && kvm_realm_state(kvm) != REALM_STATE_NONE;
>> +}
>> +
>>   #endif /* __ARM64_KVM_EMULATE_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index ccd2dc8f73c3..7d0222047ca1 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -29,6 +29,7 @@
>>   #include <asm/kvm.h>
>>   #include <asm/kvm_asm.h>
>>   #include <asm/kvm_hcall.h>
>> +#include <asm/kvm_rmi.h>
>>   #include <asm/vncr_mapping.h>
>>   
>>   #define __KVM_HAVE_ARCH_INTC_INITIALIZED
>> @@ -48,6 +49,13 @@
>>   #define KVM_VCPU_MAX_FEATURES 10
>>   #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
>>   
>> +#define KVM_REALM_VCPU_VALID_FEATURES			\
>> +	(BIT(KVM_ARM_VCPU_POWER_OFF)		|	\
>> +	 BIT(KVM_ARM_VCPU_PSCI_0_2)		|	\
>> +	 BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS)	|	\
>> +	 BIT(KVM_ARM_VCPU_SVE)			|	\
>> +	 BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC))
>> +
>>   #define KVM_REQ_SLEEP \
>>   	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
>> @@ -409,6 +417,7 @@ enum kvm_arm_vm_flavor {
>>   	VM_PKVM,		/* Normal guests on pKVM */
>>   	MARKER(__VM_PROTECTED),
>>   	VM_PROTECTED_PKVM,	/* Protected VM */
>> +	VM_REALM,		/* CCA */
>>   	VM_FLAVOR_MAX
>>   };
>>   
>> @@ -502,11 +511,14 @@ struct kvm_arch {
>>   	/* Count the number of VNCR_EL2 TLBs */
>>   	atomic_t vncr_tlb_count;
>>   
>> -	/*
>> -	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>> -	 * the associated pKVM instance in the hypervisor.
>> -	 */
>> -	struct kvm_protected_vm pkvm;
>> +	union {
>> +		/*
>> +		 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>> +		 * the associated pKVM instance in the hypervisor.
>> +		 */
>> +		struct kvm_protected_vm pkvm;
>> +		struct realm realm;
>> +	};
>>   
>>   #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>>   	/* Nested virtualization info */
>> @@ -1572,30 +1584,43 @@ struct kvm *kvm_arch_alloc_vm(void);
>>   
>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>>   
>> -#ifdef __KVM_NVHE_HYPERVISOR__
>> +#define kvm_vm_is_protected(kvm)	((kvm)->arch.vm_flavor >= __VM_PROTECTED)
>>   
>> -#define kvm_vm_is_protected(kvm)			\
>> -	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>> +#ifdef __KVM_NVHE_HYPERVISOR__
>>   /*
>>    * Accessing vcpu->kvm from nVHE hyp stub is tricky, as we need to convert the
>>    * pointer to the hyp VA. With pKVM, the nVHE code runs with the hyp_vcpu,
>> - * which is populated correctly and is gated on is_protected_kvm_enabled().
>> + * which is populated correctly. Always vcpu_is_protected_pkvm(), which is
>> + * gated on is_protected_kvm_enabled().
>> + */
>> +#define vcpu_is_protected(vcpu)		BUILD_BUG_ON(1)
>> +#else
>> +#define vcpu_is_protected(vcpu)		kvm_vm_is_protected((vcpu)->kvm)
>> +#endif
>> +
>> +#define kvm_vm_is_protected_pkvm(kvm)					\
>> +	(is_protected_kvm_enabled() && ((kvm)->arch.vm_flavor == VM_PROTECTED_PKVM))
>> +
>> +/*
>> + * Rely on is_protected_kvm_enabled() check in kvm_vm_is_protected_pkvm() to
>> + * make sure the vcpu->kvm is always valid VA in the context
>>    */
>> -#define vcpu_is_protected(vcpu)						\
>> +#define vcpu_is_protected_pkvm(vcpu)					\
>>   	({								\
>>   		struct kvm *__kvm = READ_ONCE((vcpu)->kvm);		\
>>   									\
>> -		(__kvm && kvm_vm_is_protected(__kvm));			\
>> +		(__kvm && kvm_vm_is_protected_pkvm(__kvm));		\
>>   	})
> 
> I've tested the integration branch and found that the secondary CPU
> bring-up fails:
>      [    1.426502] smp: Bringing up secondary CPUs ...
>      [    9.194442] CPU1: failed to come online
>      [    9.194558] CPU1: failed in unknown state : 0x0
>      [    9.197714] smp: Brought up 1 node, 1 CPU
>      [    9.197775] SMP: Total of 1 processors activated.

I can reproduce this and can confirm that your patch below fixes the
problem. I need to check if we can make the same restrictions for
Realms. The restrictions applied by the pKVM applies to the Realms
too. i.e., A REC cannot be made active before the Guest issues a
PSCI CPU_ON.


Cheers
Suzuki

> 
> It seems that this patch missed replacing a use of
> vcpu_is_protected() introduced by the following commit:
> 
>      25d726dddc23 ("KVM: arm64: Reject host power-on of a vCPU that EL2 holds powered off")
> 
> The following diff fixes the issue for me. Also, though not included in
> the diff, I think vcpu_is_protected() in __pkvm_create_hyp_vcpu() should
> be replaced with vcpu_is_protected_pkvm() as well.
> 
> Thanks,
> Kohei
> 
> ---8<---
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 522a837637fe..be676c13e219 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -960,7 +960,8 @@ static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu, u32 mp_state)
>   /* The guest's own CPU_OFF: EL2 has already powered the vCPU off. */
>   void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
>   {
> -       u32 mp_state = vcpu_is_protected(vcpu) ? KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
> +       u32 mp_state = vcpu_is_protected_pkvm(vcpu) ?
> +                      KVM_MP_STATE_UNINITIALIZED : KVM_MP_STATE_STOPPED;
> 
>          spin_lock(&vcpu->arch.mp_state_lock);
>          __kvm_arm_vcpu_power_off(vcpu, mp_state);
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index b01f8d44033f..6674e8d6ff4c 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -68,7 +68,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>           * STOPPED before that is the VMM's pause.
>           */
>          if (!kvm_arm_vcpu_stopped(vcpu) ||
> -           (vcpu_is_protected(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
> +           (vcpu_is_protected_pkvm(vcpu) && !kvm_pkvm_vcpu_is_powered_off(vcpu))) {
>                  if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
>                          ret = PSCI_RET_ALREADY_ON;
>                  else
> 



