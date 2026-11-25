Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795607525;
	b=hTPf8hsXws9PoUJRymCTNxcl7vvQjAlnNsaTQlatQ7XKVZ7qtpX+uf/zBPG0TIowAxXZ
	 lzPTDbt2ShsfUtv0lkR5qC1VUdzvK5JHeWyYrQjThBELEsTXIoB809oYq5WEYM6WKn5Lx
	 q0WEG3Amm3BKs7kbEC3NQP2bDvb5uvm13PYLnz+hGPMG2eMA1xupeGhj0IaG8px+Jw5jj
	 QO+GwoJ3N4vNL6glGNpHQUSXf0eNexjoaasK5FhLJ5WzJ2QkMe5FLu0UdfpO4Epp6qH+i
	 /tBd+xqlJnHO+rb4CijwUpp22Gjqj9wNaEt6ogbCWf+VMNXGAYh9SMNVq5UfDQy5vkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795607525;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=pyngxhF5ywjGl5pCP3xF9nB19G4JaIJHLtlc1kQ3Mwk=;
	b=a+yxIVQ6ZCCwDai1wDyHOhbghglTqzeup6bX+5G0GFbqBzs3L11badUqPVaE+CTnwfKA
	 7hvSFjqQmh2qlbxeeB5+lCr9HuMtm60N8denbEZCviZZNxggOg4MjXDgfqUlbHKPJEgDf
	 lIa+5l1Q2g2UsqcsLKb/kFmbQhDPu99Nrb5x0ORTf8QAHTtlrqm9hbF5CYkwcJOmDAIK7
	 0y7lgklhdbitu4JeHT/+c22NP6+fSnb3/aWX7ii19xjrf6Qb/w7HaJjyN0LNCBufbrKVT
	 rOF0uMScmFC2MeGb8PYl7fmiBNvbQ7bV0Ld7L+k85f+gsoAs56gwjCBiGRbTARJf8/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YGIGwb8+;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16F4606A33C;
	Wed, 25 Nov 2026 11:52:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E16F4606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YGIGwb8+
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 247C32F;
	Wed, 25 Nov 2026 03:52:00 -0800 (PST)
Received: from [10.57.32.107] (unknown [10.57.32.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92EB63F86F;
	Wed, 25 Nov 2026 03:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795607523; bh=Ky0ia3RoP0lZSwtUHnykl7ja3klJL/AUXyrmxC1Uxt8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YGIGwb8+M1YWzwa2GPwckpYmt12oYgiDZ4NlXX3ndUSnApVNdWKSGOgeendRJZn4I
	 5+YueUlcnRfkRH5F9McOJtag0mU942zIvAkMMB/Z+Ca8sKkCeijfV3V4GEYM9y/zCe
	 IkCidiOxb9VSAdLJhUujjEP6pVu9Wv1HFAqnvl+U=
Message-ID: <ef814939-d07d-4b3d-9812-57fb243a14e8@arm.com>
Date: Wed, 25 Nov 2026 11:51:56 +0000
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
Subject: Re: [PATCH v4 05/11] KVM: arm64: CCA: Add basic infrastructure for
 creating a realm
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-6-steven.price@arm.com>
 <882a401c-c701-4770-bb7b-970d8869ae61@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <882a401c-c701-4770-bb7b-970d8869ae61@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/11/2026 11:35, Suzuki K Poulose wrote:
> On 23/11/2026 10:42, Steven Price wrote:
>> Introduce the skeleton functions for creating and destroying a realm.
>> The requested IPA size is checked against both the KVM and RMM limits.
>>
>> The actual work of constructing the realm will be added in future
>> patches.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ---
>> Changes since v3:
>> - Use the preceding destruction dispatch instead of a temporary
>>    Realm-specific check in kvm_stage2_destroy().
>>
>> Changes since v2:
>> - Move ARM_RMM_RMI selection and rmi.o build registration here.
>>    Store the RD physical address from the outset and free SRO state
>>    on Realm teardown errors.
>>
>> Changes since v1:
>> - Cap the Realm IPA size at the smaller KVM and RMM limit, and record
>>    the selected IPA size when initializing Realm state.
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h | 23 ++++++++++++
>>   arch/arm64/kvm/Kconfig           |  1 +
>>   arch/arm64/kvm/Makefile          |  2 +-
>>   arch/arm64/kvm/arm.c             |  9 +++++
>>   arch/arm64/kvm/mmu.c             |  7 +++-
>>   arch/arm64/kvm/rmi.c             | 63 ++++++++++++++++++++++++++++++++
>>   6 files changed, 103 insertions(+), 2 deletions(-)
>>   create mode 100644 arch/arm64/kvm/rmi.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/
>> asm/kvm_rmi.h
>> index 67f16793b4d0..4ac1af622872 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -6,6 +6,9 @@
>>   #ifndef __ASM_KVM_RMI_H
>>   #define __ASM_KVM_RMI_H
>>   +#include <linux/arm-smccc-rmi.h>
>> +#include <linux/kvm.h>
>> +
>>   /**
>>    * enum realm_state - State of a Realm
>>    *
>> @@ -50,10 +53,30 @@ enum realm_state {
>>   /**
>>    * struct realm - Additional per VM data for a Realm
>>    *
>> + * @rd_phys: Physical address of the RMM-managed Realm Descriptor
>> (RD) granule
>> + * @sro: Preallocated SRO state context for Realm MMU operations
>>    * @state: The lifetime state machine for the realm
>> + * @ia_bits: Number of valid Input Address bits in the IPA
>> + * @start_level: Starting level of the Realm Translation Table
>>    */
>>   struct realm {
>> +    phys_addr_t rd_phys;
>> +    /*
>> +     * Reused by RTT map/unmap SRO commands. Those commands are only
>> +     * issued from Realm stage-2 map/unmap paths while kvm->mmu_lock is
>> +     * held for write, including Realm fault handling where
>> +     * kvm_fault_lock() takes the write side, so concurrent use is
>> +     * serialized.
>> +     */
>> +    struct rmi_sro_state *sro;
>>       enum realm_state state;
>> +    unsigned int ia_bits;
>> +    int start_level;
>>   };
>>   +u32 kvm_rmm_ipa_limit(void);
>> +
>> +int kvm_init_realm(struct kvm *kvm);
>> +void kvm_destroy_realm(struct kvm *kvm);
>> +
>>   #endif /* __ASM_KVM_RMI_H */
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index cecea0820e52..d067063a3686 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -34,6 +34,7 @@ menuconfig KVM
>>       select GUEST_PERF_EVENTS if PERF_EVENTS
>>       select KVM_GUEST_MEMFD
>>       select KVM_GENERIC_PRE_FAULT_MEMORY
>> +    select ARM_RMM_RMI
>>       help
>>         Support hosting virtualized guest machines.
>>   diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 7aaeeb84e788..66a719ab5b6b 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -16,7 +16,7 @@ CFLAGS_handle_exit.o += -Wno-override-init
>>   kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>        inject_fault.o va_layout.o handle_exit.o config.o \
>>        guest.o debug.o reset.o sys_regs.o stacktrace.o \
>> -     vgic-sys-reg-v3.o fpsimd.o pkvm.o \
>> +     vgic-sys-reg-v3.o fpsimd.o pkvm.o rmi.o \
>>        arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>>        vgic/vgic.o vgic/vgic-init.o \
>>        vgic/vgic-irqfd.o vgic/vgic-v2.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index d79e5451923d..7c22d9474a38 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -300,6 +300,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
>> long type)
>>         bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
>>   +    /* Initialise the realm bits after the generic bits are enabled */
>> +    if (kvm_vm_is_realm(kvm)) {
>> +        ret = kvm_init_realm(kvm);
>> +        if (ret)
>> +            goto err_uninit_mmu;
>> +    }
>> +
>>       return 0;
>>     err_uninit_mmu:
>> @@ -364,6 +371,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>         kvm_destroy_nested(kvm);
>>       kvm_arm_teardown_hypercalls(kvm);
>> +    if (kvm_vm_is_realm(kvm))
>> +        kvm_destroy_realm(kvm);
>>   }
>>     static bool kvm_has_full_ptr_auth(void)
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index fab915ddeaab..84b02699f103 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -981,10 +981,14 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>     static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned
>> long type)
>>   {
>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>       u32 kvm_ipa_limit = get_kvm_ipa_limit();
>>       u64 mmfr0, mmfr1;
>>       u32 phys_shift;
>>   +    if (kvm_vm_is_realm(kvm))
>> +        kvm_ipa_limit = min(kvm_ipa_limit, kvm_rmm_ipa_limit());
>> +
>>       phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>>       if (is_protected_kvm_enabled()) {
>>           phys_shift = kvm_ipa_limit;
>> @@ -1097,6 +1101,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
>> kvm_s2_mmu *mmu, unsigned long t
>>           return -EINVAL;
>>       }
>>   +    mmu->arch = &kvm->arch;
>> +
>>       err = kvm_init_ipa_range(mmu, type);
>>       if (err)
>>           return err;
>> @@ -1105,7 +1111,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct
>> kvm_s2_mmu *mmu, unsigned long t
>>       if (!pgt)
>>           return -ENOMEM;
>>   -    mmu->arch = &kvm->arch;
>>       err = KVM_PGT_FN(kvm_pgtable_stage2_init)(pgt, mmu,
>> &kvm_s2_mm_ops);
>>       if (err)
>>           goto out_free_pgtable;
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> new file mode 100644
>> index 000000000000..fafca2439c46
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -0,0 +1,63 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/arm-rmi-cmds.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_emulate.h>
>> +#include <asm/kvm_mmu.h>
>> +#include <asm/kvm_pgtable.h>
>> +#include <asm/virt.h>
>> +
>> +u32 kvm_rmm_ipa_limit(void)
>> +{
>> +    return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
>> +}
>> +
>> +void kvm_destroy_realm(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +    size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
>> +
>> +    if (!kvm_realm_is_created(kvm))
>> +        goto out_free_sro;
>> +
>> +    kvm_set_realm_state(kvm, REALM_STATE_DYING);
>> +
>> +    if (realm->rd_phys) {
> 
> Do we expect this to be otherwise ? Or do we get called twice
> on this function ?

You're right, this is redundant (and confusing). rd_phys should never be
zero here. I'll drop this - thanks!

>> +        phys_addr_t rd_phys = realm->rd_phys;
>> +
>> +        if (WARN_ON(rmi_realm_terminate(rd_phys, realm->sro)))
>> +            goto out_free_sro;
>> +
>> +        if (WARN_ON(rmi_realm_destroy(rd_phys, realm->sro)))
>> +            goto out_free_sro;
>> +        rmi_free_delegated_page(rd_phys);
>> +        realm->rd_phys = 0;
>> +    }
>> +
>> +    if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys,
>> +                     pgd_size)))
>> +        goto out_free_sro;
> 
> In the integration branch, we undelegate the Stage2 root RTTs, if the
> Realm create fails. Is there a particular reason why we may have the
> delegated S2 RTTs with realm->rd_phys = 0 ?

As above, we don't expect to get here with realm->rd_phys == 0 (it might
have been the case in a previous version of the series - I haven't check
that). As you say during realm creation any undelegation required if it
fails is handled in realm_create_rd().

Thanks,
Steve

> Suzuki
> 
> 
>> +
>> +    kvm_set_realm_state(kvm, REALM_STATE_DEAD);
>> +
>> +out_free_sro:
>> +    kfree(realm->sro);
>> +    realm->sro = NULL;
>> +}
>> +
>> +int kvm_init_realm(struct kvm *kvm)
>> +{
>> +    struct realm *realm = &kvm->arch.realm;
>> +
>> +    realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
>> +    realm->start_level = 4 - VTCR_EL2_LVLS(kvm->arch.mmu.vtcr);
>> +    realm->sro = kmalloc_obj(*realm->sro);
>> +    if (!realm->sro)
>> +        return -ENOMEM;
>> +
>> +    return 0;
>> +}
> 

