Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DF4672601;
	Fri, 16 May 2025 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747403439; cv=none; b=Il2Xcpg+BVAh5kK+FiJT7vvDU13rcINtINhLHOZ6iWXxdJp/so5SZ/xwnCMSTosrd2oyIpsGvidO1WrZWf+aJPOD1ZjF3jx6sx00Td2LGyMlOfKI4ArJlNiW1JzHdsf6bz3lHWRY0O2lguJTorIsMy+C8q9F9iQF7ToXW4z2T70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747403439; c=relaxed/simple;
	bh=0THkZyxxSuZVTH5og5hjwibotSM4qUDA6bNyzgM51BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkuQxKhV3o2zyVK7eiaP52H2tYDamsOZAv5lf/eC/1DDyH815+jIbHqMq6l96YGx3pFlgTUf3x7FOJ18NDH9/d7IGrnAE3XRw8ZjJnDMXoY/BIv5DzkN2DS3tmCmzfF5rXdWxw/02/vmVYrY/w3hYfVmtB1gAhUrish4ZBsXqyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C511169C;
	Fri, 16 May 2025 06:50:23 -0700 (PDT)
Received: from [10.1.27.17] (e122027.cambridge.arm.com [10.1.27.17])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAE733F673;
	Fri, 16 May 2025 06:50:30 -0700 (PDT)
Message-ID: <c4c2d45a-0c9f-41ee-8659-d119edda457b@arm.com>
Date: Fri, 16 May 2025 14:50:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/43] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
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
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-18-steven.price@arm.com>
 <54a21b12-2b17-4e0a-9cbf-f68406fb003a@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <54a21b12-2b17-4e0a-9cbf-f68406fb003a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 07/05/2025 11:42, Suzuki K Poulose wrote:
> On 16/04/2025 14:41, Steven Price wrote:
>> The guest can request that a region of it's protected address space is
>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>> RSI_IPA_STATE_SET. This causes a guest exit with the
>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>> protected region to unprotected (or back), exiting to the VMM to make
>> the necessary changes to the guest_memfd and memslot mappings. On the
>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>> calls.
>>
>> The VMM may wish to reject the RIPAS change requested by the guest. For
>> now it can only do with by no longer scheduling the VCPU as we don't
>> currently have a usecase for returning that rejection to the guest, but
>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>> open for adding a new ioctl in the future for this purpose.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v7:
>>   * Rework the loop in realm_set_ipa_state() to make it clear when the
>>     'next' output value of rmi_rtt_set_ripas() is used.
>> New patch for v7: The code was previously split awkwardly between two
>> other patches.
>> ---
>>   arch/arm64/kvm/rme.c | 88 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 88 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index bee9dfe12e03..fe0d5b8703d2 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -624,6 +624,65 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start,
>>           realm_unmap_private_range(kvm, start, end);
>>   }
>>   +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +                   unsigned long start,
>> +                   unsigned long end,
>> +                   unsigned long ripas,
>> +                   unsigned long *top_ipa)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +    unsigned long ipa = start;
>> +    int ret = 0;
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_SUCCESS) {
>> +            ipa = next;
>> +        } else if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            int walk_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
>> +
>> +            /*
>> +             * If the RMM walk ended early then more tables are
>> +             * needed to reach the required depth to set the RIPAS.
>> +             */
>> +            if (walk_level < level) {
>> +                ret = realm_create_rtt_levels(realm, ipa,
>> +                                  walk_level,
>> +                                  level,
>> +                                  memcache);
>> +                /* Retry with RTTs created */
> 
> minor nit: Do we need to add a comment here, saying, we stop processing
> the request if we run out of RTT pages in this go and Realm could retry
> it.

I'm not really sure this is the right place, and following Gavin's
comment I've combined this with the INIT_RIPAS code.

Also the situation at the moment isn't that we return to the guest -
kvm_complete_ripas_change() will topup the memory cache and retry until
the whole region is covered. There is an argument that perhaps it
shouldn't, but I'm not sure what a guest can usefully do beyond retry in
the case of a partial RIPAS change. In which case why have the overhead
of returning to the guest?

>> +                if (!ret)
>> +                    continue;
>> +            } else {
>> +                ret = -EINVAL;
>> +            }
>> +
>> +            break;
>> +        } else {
>> +            WARN(1, "Unexpected error in %s: %#x\n", __func__,
>> +                 ret);
>> +            ret = -ENXIO;
>> +            break;
>> +        }
> 
> minor nit: Following from Gavin's comment on another patch, could
> switch() make the above code more readable and remove the continue; ?
> 
>         switch (RMI_RETURN_STATUS(ret)) {
>         case RMI_SUCCESS:
>             ipa = next;
>             break;
>         case RMI_ERROR_RTT: {
> 
>        
>         }
>             break;
>         default:
>             WARN(..);
>             ret = -ENXIO;
>             goto out;
>         }
> 
> I am fine either way.

Since I'm combining the two functions, I've kept just the switch()
version of the code.

>> +    }
>> +
> 
> out:
> 
>> +    *top_ipa = ipa;
>> +
>> +    if (ripas == RMI_EMPTY && ipa != start)
>> +        realm_unmap_private_range(kvm, start, ipa);
>> +
>> +    return ret;
>> +}
>> +
>>   static int realm_init_ipa_state(struct realm *realm,
>>                   unsigned long ipa,
>>                   unsigned long end)
>> @@ -863,6 +922,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>>       kvm_free_stage2_pgd(&kvm->arch.mmu);
>>   }
>>   +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +    unsigned long top_ipa;
>> +    int ret;
>> +
>> +    do {
>> +        kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>> +                       kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +        write_lock(&kvm->mmu_lock);
>> +        ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>> +        write_unlock(&kvm->mmu_lock);
>> +
>> +        if (WARN_RATELIMIT(ret && ret != -ENOMEM,
>> +                   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx,
>> ripas: %#lx\n",
>> +                   base, top, ripas))
>> +            break;
>> +
>> +        base = top_ipa;
>> +    } while (top_ipa < top);
>> +}
>> +
> 
> Rest looks good to me.

Thanks,
Steve


