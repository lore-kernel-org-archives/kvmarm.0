Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711676;
	b=3aLD03M7NemOa/FWWDZ5SKydD9ggYDMA890Ca1bXVh3cd4cmBORp3qkQycrHw/PQ2MeP
	 tNn+byhMXTgWw5FVVTV0bMAfs6TMWjEqOlKDHH+LzKsYilB9NPCdFHir9m/e9Cnc0YD7y
	 mGXYrvhWgwCPDt70KaBSG9x+2i8pptbTD3OvIl2OyFyl1ftEO0OrTR+dTeg/RNhroG33H
	 9fLP8ePFni/4hRvh96GdMti8NdMd8230Y/GXhCoREX7y9g+ntNvC4XGy9+bBpjHEetgYD
	 yd7INg7uWCziPslcfWZHXa6njC0ooBjUcCqofKjn312gfC/ffhd4SKZLacLn4jNqNCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711676;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Reb0A+vj4WxFhlRPeF5XMU0Gq5g9HJZmhJB2qXFsVXs=;
	b=CfPZ1+X/w6CXzc8LVsFNjEemqA5EpD/gbXCj+oKM7814VViQyO0EukwrCRrR9FOAzKyT
	 eG+tayH+S0HGPAqQAn8qXxaGGVYxiAPQVZSQ7s1+9E5vJjxp/agFRANlPrRrvLNWSDYnJ
	 k9uSoz10UI+lRvUqbjpNm4bx6tlCCqUTL4shTDN9bCIQ1KC9sTnXRGGs/Cv6vsb9hLEnY
	 244AXUSBnL+QnbhuWKN/VNHEsRf1cMvQNq/NYLWDmabT69QKm02EZj/8qtfgVLlz+KPfW
	 ZduPDkeKR3wiFX7WT6Wz4J/0A5yIVpw8m0yX7WfIXTkJkNk39aM1MqNN8d/+PtG621A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LPUTBtrn;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E65606A32C;
	Thu, 26 Nov 2026 16:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89E65606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=LPUTBtrn
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10F161BA8;
	Thu, 26 Nov 2026 08:47:52 -0800 (PST)
Received: from [10.0.129.128] (e122027.cambridge.arm.com [10.0.129.128])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94E293F86F;
	Thu, 26 Nov 2026 08:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795711674; bh=wD4nn625t5o2j8O8VCNI52IkSmZmyk+WOropi/y+JW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LPUTBtrnXanBCrATApbdjyPmJJS0xq86yxfvxWyiGzKa6XUMGIcOrSHyF9nZDjSsL
	 v0Dt2TBLZ9XTGwTuBVXQ+cCmNd3PJj8enKmDKt35de75keVcWu173jhvW5BormtSZ5
	 cThoprWY3F0kLdK5qLp++ArCYttwh43Yv3912ARM=
Message-ID: <78665c8c-2c10-410e-9bd2-b62c91c0de2a@arm.com>
Date: Thu, 26 Nov 2026 16:47:46 +0000
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
Subject: Re: [PATCH v4 09/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Kohei Enju <enju.kohei@fujitsu.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-10-steven.price@arm.com>
 <CAEvNRgFQ5BXqU3KfPFT8bfZTW=RyvBw25z3GZtr3JA=Wv3Yqfw@mail.gmail.com>
 <e4108d4f-e84c-444c-aa7a-18e823816eae@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <e4108d4f-e84c-444c-aa7a-18e823816eae@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 25/11/2026 14:58, Suzuki K Poulose wrote:
> Hi Ackerley
> 
> On 25/11/2026 00:09, Ackerley Tng wrote:
>> Steven Price <steven.price@arm.com> writes:
>>
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> Once the Realm is created, prevent changes to guest_memfd backed
>>> memslots, which can provide private memory. Validate these changes
>>> before KVM invalidates the old memslot, so a rejected deletion leaves
>>> its stage-2 mappings intact. Realm stage-2 faults will also validate
>>> the private memory backing in a later commit.
>>>
>>> Require Realm memslots to lie in the lower half of the IPA space, as the
>>> upper, shared half aliases the lower, protected half.
>>>
>>> Define kvm_arch_has_private_mem() so generic KVM recognizes Realm VMs
>>> as supporting private memory. Defining the macro also makes
>>> gmem_in_place_conversion true for every arm64 VM, so guest_memfd
>>> memslots are marked gmem-only even for non-Realm VMs. A well-formed
>>> KVM_SET_MEMORY_ATTRIBUTES2 request on a non-Realm guest_memfd now
>>> reaches the VM check and returns -EINVAL instead of -ENOTTY.
>>>
>>> Additionally, similar to pKVM, do not support dirty logging or
>>> read-only memslots.
>>>
>>
>> Imo this could be split into a few patches
>>
>> 1. Add the constraints wrt realm memslots and being in the lower half of
>>     the IPA space
>> 2. Defining arm's support for private mem
>> 3. Imposing rules on memslot changes
>> 4. Maybe some others, maybe I'm misunderstanding the patch
> 
> Agree

Yes, although as discussed below, I think we probably don't need to have
as much restriction on memslots as this currently adds.

>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>
>>> ---
>>> Changes since v3:
>>> - Explain the arm64-wide in-place conversion effect and keep the
>>>    general IPA limit comment.
>>>
>>> Changes since v1:
>>> - Preserve private mappings if KVM invalidates a Realm guest_memfd
>>>    slot before the prepare hook rejects its deletion.
>>> ---
>>>   arch/arm64/include/asm/kvm_host.h |  2 ++
>>>   arch/arm64/kvm/mmu.c              | 37 ++++++++++++++++++++++++-------
>>>   2 files changed, 31 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/
>>> asm/kvm_host.h
>>> index 3ddeddfacd06..55673d08e3eb 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -1607,6 +1607,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>>>
>>>   #define kvm_vm_is_realm(kvm)        ((kvm)->arch.vm_flavor ==
>>> VM_REALM)
>>>
>>> +#define kvm_arch_has_private_mem(kvm) kvm_vm_is_realm(kvm)
>>> +
>>>   #define kvm_has_mte(kvm)                    \
>>>       (system_supports_mte() &&                \
>>>        test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 800333a345cd..9af5fe6d87f0 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -2861,17 +2861,32 @@ int kvm_arch_validate_memory_region(struct
>>> kvm *kvm,
>>>   {
>>>       lockdep_assert_held(&kvm->slots_lock);
>>>
>>> -    if (kvm_vm_is_protected(kvm)) {
>>> +    if (kvm_vm_is_protected(kvm) && new &&
>>> +        (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
>>> +        return -EPERM;
>>
>> gmem is already generically mutually exclusive with
>> KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY, so before this change,
>> pKVM is saying no to KVM_MEM_LOG_DIRTY_PAGES and KVM_MEM_READONLY for
>> all memslots, gmem or not, so this check makes sense.
>>
>>> +
>>> +    switch (kvm->arch.vm_flavor) {
>>> +    case VM_PROTECTED_PKVM:
>>>           /* Cannot modify memslots once a pVM has run. */
>>>           if (pkvm_hyp_vm_is_created(kvm) &&
>>> -            (change == KVM_MR_DELETE || change == KVM_MR_MOVE)) {
>>> +            (change == KVM_MR_DELETE || change == KVM_MR_MOVE))
>>>               return -EPERM;
>>> -        }
>>> +        break;
>>
>> Not sure why pKVM doesn't allow deleting a memslot after the vm is
>> created, but this is no change from before this patch, the removal of {}
>> here is mixed in with the other changes in this patch.
> 
> IIRC, pKVM relies on pinning the stage2 until the teardown ?
> ed
> from the Stage2 unless we d
> 
>>
>>> +    case VM_REALM:
>>> +        /*
>>> +         * Once the Realm is created, we cannot modify any slots that
>>> +         * could be providing private memory. i.e., guest_memfd backed
>>> +         * slots.
>>> +         * TODO: Handle trusted device private memory slots
>>> +         */
>>> +        if (!kvm_realm_is_created(kvm))
>>> +            break;
>>>
>>> -        if (new &&
>>> -            new->flags & (KVM_MEM_LOG_DIRTY_PAGES |
>>> KVM_MEM_READONLY)) {
>>> +        if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
>>>               return -EPERM;
>>> -        }
>>> +        break;
>>
>> Imo this should be written the same way as the pKVM branch for clarity,
>> like
>>
>> if (kvm_realm_is_created() &&
>>      (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new)))
>>          return -EPERM;
>>
>> but that aside,
>>
>> 1. Why block creating memslots after realm is created?
>>
>> Does ARM CCA have no way to add pages after a VM starts? This isn't
>> blocked for TDX and SNP so I think this constraint seems unnecessary.
> 
> This and (2) was triggered by the following thread, raised by Catalin.
> 
> https://lore.kernel.org/all/aqrGPK0lFBFXL2qY@arm.com
> 
> But having said that, since then, we now have :
> 
> 1) All private faults must be serviced by realm_gmem_abort(), which
> mandates Guest memfd slot. (See Patch 11, realm_mem_abort())
> 
> 2) realm_gmem_abort() matches the "private" attribute for a "protected"
> fault, failing which causes a memory fault exit.
> 
> So I think we can remove these memslot restrictions.

Agreed. We originally had memslots backed by user space memory. That
meant adding or removing a memslot had to deal with all the messiness of
dealing this that. As an initial step it was easier to just prevent
memslot changes. guest_memfd simplifies things so I don't think this
restriction is actually necessary - and I think it will actually
simplify the code to not restrict it.

>>
>> 2. Why block deleting memslots after realm is created?
>>
>> This also seems like an artificial constraint, and it constrains the way
>> the userspace VMM operates when stopping a VM, like the memslots can't
>> be removed ever, the VM just has to be closed? (something like that)
> 
> As mentioned above, I think we are good to remove the restrictions.

Agreed.

Thanks,
Steve

> Suzuki
> 
> 
>>
>>> +    default:
>>> +        break;
>>>       }
>>>
>>>       return 0;
>>> @@ -2883,6 +2898,7 @@ int kvm_arch_prepare_memory_region(struct kvm
>>> *kvm,
>>>                      enum kvm_mr_change change)
>>>   {
>>>       hva_t hva, reg_end;
>>> +    gfn_t ipa_limit;
>>>       int ret = 0;
>>>
>>>       if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>>> @@ -2891,9 +2907,14 @@ int kvm_arch_prepare_memory_region(struct kvm
>>> *kvm,
>>>
>>>       /*
>>>        * Prevent userspace from creating a memory region outside of
>>> the IPA
>>> -     * space addressable by the KVM guest IPA space.
>>> +     * space addressable by the KVM guest IPA space. Realm shared
>>> IPAs alias
>>> +     * the corresponding private IPAs, so Realm memslots must reside
>>> entirely
>>> +     * in the lower half of that space.
>>>        */
>>> -    if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm-
>>> >arch.mmu) >> PAGE_SHIFT))
>>> +    ipa_limit = kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT;
>>> +    if (kvm_vm_is_realm(kvm))
>>> +        ipa_limit >>= 1;
>>> +    if (new->base_gfn + new->npages > ipa_limit)
>>>           return -EFAULT;
>>>
>>>       /*
>>> -- 
>>> 2.43.0
> 

