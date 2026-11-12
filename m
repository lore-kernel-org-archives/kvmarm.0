Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794480199;
	b=cjdPq9oQIk5K56+U74s2rDclb3fkXEiLcNfJyGKx/7jVEx4RPzAKgHsYFp1rLmKJfZwC
	 s+WLW/Oi/gpceDp/hmH1BZxKTiVAAGV944c5LdYNMbDT7vGSz0OnSvScjaySQm1x87Bv1
	 m8vvHO53Byr9ynDJcl8f9q7isWfOemZ+Hxq3tTzJPO4glvLQgCVnQohO70qCiLaDF9THs
	 YpoALuLo74O3grZCMZp7Gy5JysG7RQoVUIoWjImGdYCYmxwqZmLeNw+ONVxe8QizHfFgi
	 GqvIie1UQU4eVHkX4y961fGcB7NekYO3pnvMz0/L/kqvE+dPFraDC5nXP2Pc+MQnU4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480199;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=X2j4x6ETnjsd3Kk7UiXLGfpl+QRCIcV4hL4S2HQyUOs=;
	b=MzejDdPRvwXxd679rBbS9hZhH1PLzvsgiRDYnhTh2+UJlCg0RIN3I3dugNSM5dxhFyR/
	 BLEE97nc8M/ADjLAx85nb19nMhxnOOEtw6RKKI8nFSkk042im3rJJJ/8jhMWCdAQfKsH1
	 CMSlIN5jfjcSL6qspndvNuJeOxIe0wwHr0U5rR+9zx1sNLbIvAgZaa0t3a6vOCc/ObShl
	 ezygRY5EsVcLVOX0Vfl7ug8zsMLTwy1cCB9A3zoxCdOPllOd4c60uH35N3zfWxQJ8Za7M
	 kLsybJHORsYlAfirtvh7wFYxbSXOJLxV45eVKcwoaNULSSktBcGuYEiBpME/RoOfVjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="sz/bRcPX";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A51606A337;
	Thu, 12 Nov 2026 10:43:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78A51606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sz/bRcPX
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9CC8C153B;
	Thu, 12 Nov 2026 02:43:14 -0800 (PST)
Received: from [10.0.129.47] (e122027.cambridge.arm.com [10.0.129.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76C8C3F673;
	Thu, 12 Nov 2026 02:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794480197; bh=xDR73f4nxpZk5DSaOewf66eooDmTQ5dy0pwmOSiLIuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sz/bRcPXFEyNa7belfSW5kTpVnMxp65VhQF1lieCCf0rIAi0oiwk3xn+JZFcig9CD
	 1gcmn08lsRczfyJ6K8ZbBvOpIDzJ9EnXmgUZqfKoqEarzelQvs12nZW7bi6qrs3iCC
	 KiUIJYqG1GFIcWLl7RHP5oXDUOBXgOfs70RBQC7E=
Message-ID: <1e02dfff-c1ad-46bb-9834-fd4bbaa46179@arm.com>
Date: Thu, 12 Nov 2026 10:43:13 +0000
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
Subject: Re: [PATCH v2 02/12] KVM: arm64: guest_memfd: Check mmap support when
 preparing memslot
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
References: <20261111145758.217946-1-steven.price@arm.com>
 <20261111145758.217946-3-steven.price@arm.com>
 <fbc33983-cb8a-48e4-854f-ce009cc5668f@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <fbc33983-cb8a-48e4-854f-ce009cc5668f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/11/2026 15:21, Suzuki K Poulose wrote:
> On 11/11/2026 14:57, Steven Price wrote:
>> Check the guest_memfd backing file when deciding whether an arm64
>> memslot has mappable memory rather than checking whether the slot is
>> gmem only. A public helper function is added to be able to reuse the
>> static kvm_gmem_supports_mmap() function.
>>
> 
> Please could you explain why we need this ? Why not rely on
> kvm_memslot_is_gmem_only(), which already tells
> kvm_gmem_supports_mmap() ? With inplace conversion support gmem supports
> mmap.

Unless I'm missing something it's still possible to create a guest_memfd
that doesn't support mmap() by not passing the GUEST_MEMFD_FLAG_MMAP
flag. So kvm_memslot_is_gmem_only() doesn't actually guarantee that it's
a guest_memfd that supports mmap().

> 
>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ---
>> Changes since v1:
>> - New patch in v2. Check the guest_memfd backing file rather than the
>>    memslot flag when deciding whether arm64 can map the backing memory.
>> ---
>>   arch/arm64/kvm/mmu.c     | 7 ++++---
>>   include/linux/kvm_host.h | 1 +
>>   virt/kvm/guest_memfd.c   | 6 ++++++
>>   3 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 1db10d8d6db7..a146f6cde3d0 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -2839,10 +2839,11 @@ int kvm_arch_prepare_memory_region(struct kvm
>> *kvm,
>>           return -EFAULT;
>>         /*
>> -     * Only support guest_memfd backed memslots with mappable memory,
>> since
>> -     * there aren't any CoCo VMs that support only private memory on
>> arm64.
>> +     * Protected VMs currently require guest_memfd backed memslots with
>> +     * mappable memory to support shared mappings.
>>        */
>> -    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>> +    if (kvm_arch_has_private_mem(kvm) && kvm_slot_has_gmem(new) &&
>> +        !kvm_gmem_slot_supports_mmap(new))

Sashiko has identified I've screwed up this condition though.
kvm_arch_has_private_mem(kvm) shouldn't be in there as that allows a
non-private VM to bind a non-mmappable gmem.

>>           return -EINVAL;
>>         /* guest_memfd is incompatible with MTE. */
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index e7fc94e2910a..f65728a713ec 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -2614,6 +2614,7 @@ static inline bool kvm_is_private_gfn(struct kvm
>> *kvm, gfn_t gfn)
>>     #ifdef CONFIG_KVM_GUEST_MEMFD
>>   bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
>> +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot);
>>   bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
>>     static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 8c97a69b16dc..3dd8d227bebb 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -442,6 +442,12 @@ static bool kvm_gmem_supports_mmap(struct inode
>> *inode)
>>       return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
>>   }
>>   +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot)
>> +{
>> +    /* The guest_memfd file is pinned while preparing a new memslot. */
> 
> We should gate this on kvm_slot_has_gmem() and how do we ensure that the
> call comes after it is prepared ?

I'm not sure what you mean by "gate this on kvm_slot_has_gmem()" - yes
this function only makes sense on a gmem slot - the user above checks
that first. I'm not sure what value the function should call if you call
it on a non-gmem slot?

Thanks,
Steve

>> +    return kvm_gmem_supports_mmap(file_inode(slot->gmem.file));
>> +}
>> +
>>   static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>   {
>>       struct inode *inode = file_inode(vmf->vma->vm_file);
> 
> 
> Cheers
> Suzuki

