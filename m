Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606374;
	b=xR6fjA+nv+1Dn6C8guSaCye/G2T9qPY7LemCLwKY0aOPp8QqWs9MrV6wcgS8S/HhJYj1
	 vT4w6bSuSBeuSNjDGRCXyrODuC30ZGIIQqvoyeXJUog2e43sHDh8btDRTfV+/rw3jWakC
	 fn4X/1GxT+RxgxV1ndtxwG/r4GyV5otFUsduH5X/9i7oiinUhqWITNmibjKmzprnGScQR
	 QHeKWUQyc6QI5H03XRo88AkzStXTg5jjrffFA+3uh6RGch1iclu3fFW1+vCM8hP+wybK5
	 WuulXr3RrlobzuJZsjA0XG1kliimyWgWNO8DorxLlMpJ6y1OCV/pFC/75q/r7UEb2VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606374;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ksJzZnRlzZFG+0L0HtrVowwMj9Uu8+WpRfdThQfAKGI=;
	b=M7d4xwX1jah40R3DqdZVqfCzDTkHIBFYqI2rIbCSoq9Kv0pcfg6d4PkMrgxqQQE4RBYA
	 2fKQteF+i9308zBJmUpyuDxkMiRqbQbteIwo6I0N2textxCIgZvLM1I5jmFtaj4QX4+We
	 L/doqJc7yZQjgAlVgbJZ0Qguhv/WKOpCh38u5OnDpHt2AJOskNaYaC1ILgGItC3HdbUWa
	 oSs0QhzvcnTzCmrrVDVdTGTlHbuqQ5Fa+4FyvC1k4caPZ8jyGy/Ra2fIE75higeiyChfk
	 PxOhzho6ISZ/iDptO/OYzb6GWHOxReqUWIrhbyXBOkM8FoX53x5MgoIWO4joKB2oYkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=szuKiBZe;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FFB606A338;
	Wed, 25 Nov 2026 11:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38FFB606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=szuKiBZe
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A33E814BF;
	Wed, 25 Nov 2026 03:32:49 -0800 (PST)
Received: from [10.57.32.107] (unknown [10.57.32.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C86FA3F86F;
	Wed, 25 Nov 2026 03:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795606372; bh=qbHqyTNnWLNOTc00I4CKxD9wPZ5SwAvyohqcO63rleg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=szuKiBZefxrXLITi7F/BtWnWCMmSSJ8eLaNdaeL9KzYCLZa6WKUoAgn86sC0E/54J
	 CNj2pUjlBDOuClnSbnoIso25v9NAL0kFkb32fa8/Z6MK1KiVqw1oG6eXP3NTCVgH1j
	 msYmDvDId5dj2TAsEjj4yh/XakAspLYTUQTgX1rk=
Message-ID: <7bd5427d-9078-4b79-bce6-3bbf801ec766@arm.com>
Date: Wed, 25 Nov 2026 11:32:46 +0000
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
Subject: Re: [PATCH v4 04/11] KVM: arm64: Dispatch stage-2 destruction by VM
 flavor
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
 <20261123104233.95710-5-steven.price@arm.com>
 <0d031484-d394-47e3-be49-7c85004dbb83@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <0d031484-d394-47e3-be49-7c85004dbb83@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/11/2026 11:23, Suzuki K Poulose wrote:
> On 23/11/2026 10:42, Steven Price wrote:
>> Select the stage-2 destruction functions through the VM's stage-2
>> operations. This keeps the native and pKVM paths explicit and lets a
>> Realm provide its own destruction callback when Realm stage-2
>> operations are registered.
>>
>> The Realm callback will only free the root RTT pages, because RMI
>> teardown destroys the non-root RTTs separately.
>>
> 
> minor nit: The second paragraph may be omitted as we introduce the
> Realm stuff in a later patch.

Ack

> 
>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> 
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thanks!
Steve

> 
>>
>> ---
>> Changes since v3:
>> - Move before basic Realm infrastructure and declare the page-table
>>    type for the new callback.
>>
>> Changes since v2:
>> - New patch in v3; split stage-2 destruction dispatch out of the
>>    Realm stage-2 MMU operations patch.
>> ---
>>   arch/arm64/include/asm/kvm_host.h |  2 ++
>>   arch/arm64/kvm/mmu.c              | 30 +++++++++++++++++++++++-------
>>   2 files changed, 25 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/
>> asm/kvm_host.h
>> index 9d6258b213d1..3ddeddfacd06 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -234,6 +234,7 @@ struct kvm_vcpu_ops {
>>     struct kvm_gfn_range;
>>   enum kvm_gfn_range_filter;
>> +struct kvm_pgtable;
>>   struct kvm_s2_fault_desc;
>>     struct kvm_vm_s2_ops {
>> @@ -242,6 +243,7 @@ struct kvm_vm_s2_ops {
>>       int (*vm_flush_remote_tlbs)(struct kvm *kvm);
>>       int (*vm_flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
>>                         u64 nr_pages);
>> +    void (*vm_stage2_destroy)(struct kvm_pgtable *pgt);
>>       void (*vm_stage2_unmap_range)(struct kvm_s2_mmu *mmu,
>>                         phys_addr_t start, u64 size,
>>                         bool may_block,
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 8a9a80c7cfab..fab915ddeaab 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1018,26 +1018,39 @@ static int kvm_init_ipa_range(struct
>> kvm_s2_mmu *mmu, unsigned long type)
>>    * cond_resched() periodically to prevent hogging the CPU for a long
>> time
>>    * and schedule something else, if required.
>>    */
>> -static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t
>> addr,
>> -                   phys_addr_t end)
>> +static void stage2_destroy_range(struct kvm_pgtable *pgt,
>> +                 void (*destroy_range)(struct kvm_pgtable *pgt,
>> +                               u64 addr, u64 size))
>>   {
>> +    u64 addr = 0;
>> +    u64 end = BIT(VTCR_EL2_IPA(pgt->mmu->vtcr));
>>       u64 next;
>>         do {
>>           next = stage2_range_addr_end(addr, end);
>> -        KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr,
>> -                                 next - addr);
>> +        destroy_range(pgt, addr, next - addr);
>>           if (next != end)
>>               cond_resched();
>>       } while (addr = next, addr != end);
>>   }
>>   +static void kvm_vm_stage2_destroy(struct kvm_pgtable *pgt)
>> +{
>> +    stage2_destroy_range(pgt, kvm_pgtable_stage2_destroy_range);
>> +    kvm_pgtable_stage2_destroy_pgd(pgt);
>> +}
>> +
>> +static void pkvm_stage2_destroy(struct kvm_pgtable *pgt)
>> +{
>> +    stage2_destroy_range(pgt, pkvm_pgtable_stage2_destroy_range);
>> +    pkvm_pgtable_stage2_destroy_pgd(pgt);
>> +}
>> +
>>   static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
>>   {
>> -    unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
>> +    struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
>>   -    stage2_destroy_range(pgt, 0, BIT(ia_bits));
>> -    KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
>> +    kvm->arch.vm_s2_ops->vm_stage2_destroy(pgt);
>>   }
>>     /**
>> @@ -3146,6 +3159,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct
>> kvm_vcpu *vcpu,
>>   }
>>     static const struct kvm_vm_s2_ops protected_pkvm_vm_s2_ops = {
>> +    .vm_stage2_destroy        = pkvm_stage2_destroy,
>>       .vm_flush_remote_tlbs        = pkvm_flush_remote_tlbs,
>>       .vm_flush_remote_tlbs_range    = pkvm_flush_remote_tlbs_range,
>>       .vm_age_gfn            = no_age_gfn,
>> @@ -3155,6 +3169,7 @@ static const struct kvm_vm_s2_ops
>> protected_pkvm_vm_s2_ops = {
>>   };
>>     static const struct kvm_vm_s2_ops pkvm_vm_s2_ops = {
>> +    .vm_stage2_destroy        = pkvm_stage2_destroy,
>>       .vm_flush_remote_tlbs        = pkvm_flush_remote_tlbs,
>>       .vm_flush_remote_tlbs_range    = pkvm_flush_remote_tlbs_range,
>>       .vm_age_gfn            = pkvm_age_gfn,
>> @@ -3164,6 +3179,7 @@ static const struct kvm_vm_s2_ops pkvm_vm_s2_ops
>> = {
>>   };
>>     static const struct kvm_vm_s2_ops kvm_default_vm_s2_ops = {
>> +    .vm_stage2_destroy        = kvm_vm_stage2_destroy,
>>       .vm_flush_remote_tlbs        = kvm_vm_flush_remote_tlbs,
>>       .vm_flush_remote_tlbs_range    = kvm_vm_flush_remote_tlbs_range,
>>       .vm_age_gfn            = kvm_vm_age_gfn,
> 

