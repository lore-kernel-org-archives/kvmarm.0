Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794501343;
	b=v4fSihiPgXi36aONuDIs580s1dv8fXyj+mXXzWc2uya29HyUhyhR7rN3y20qaJKtIzqY
	 VEd1Cljvz5SN+700Bx4TJnrriVP5QlTeYfhFEZW28IeoUaWmWDz0dhhiy1yLnNg9BmrUO
	 QeYS4EprtbrMEZdr4M47XZesmzIvG2SlPN0pHNKe6PF0Yri6kn+DMgDC2PvHXXwXG+sy0
	 Mvs3zZ5r+XWy4vomprZE/wodwpl+S3VjW0rq+yXbJi8XMPLHi2HHKRUtwP8mVATvCAnBq
	 odGobG0vZM9jIG+aBClA5yhVu9rPAa0wkMd+Av4bFkK8XWasHI1ki8zeY5U99AlXTHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794501343;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=wWL8E9/FzqN09J68Lnx5883U9S+W8XARlqWFahZqWE8=;
	b=YJp5rRsoEuYbcTSp1hZpWRn8O2xnzggdKaQ9FYMNfvh3MPDYwDxD9Rhp5USMgZMR5KDM
	 SZQnZsDcjYLesWYRIW+rLh/jKmhDwzlaPWkoBLH+hu2cDdu9VjJPJFjHRB02EMGqWLsuW
	 t0WMJvzlzTv6B9bLcEHYb4NtIRbd0HqserF3mIZ7WCC+ffnYMCftApnnb9QPIyX4CK5Xh
	 wCvUTjhqFWV4+vRvRpKv3+4bQ4bN00OdR4RkcP8JapCzBeHf+Ug4MkcDaKILGFQXlRupn
	 iqnAnDSEaT0ckbNLVSdH6r3MrePsKwLNIW3dDCKQX+ghNNmYChAg+Wv3WpafB99X/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="e8p0n/4q";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE7D606AB01;
	Thu, 12 Nov 2026 16:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EE7D606AB01
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=e8p0n/4q
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BCBC1516;
	Thu, 12 Nov 2026 08:35:38 -0800 (PST)
Received: from [10.57.67.215] (unknown [10.57.67.215])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 740E93F673;
	Thu, 12 Nov 2026 08:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794501341; bh=vTYfjBdjeqxRbi+MJ2rG5iyba+KEUTEpSaYPJP9Bu+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e8p0n/4q9s8RBofHWjQWNiYG1+QrvR3aODbKwPBwYIpdLJjzLHXx7WnElo/f9a5eR
	 ttF4y1qTnBH3ytKlJM2/Ac7bDbdglxlicr1DogG70oCm3NDLdzVCm2opITWZY+4BEv
	 WNvpixt1WR4JCSqd1HrwvzWh311YVhWC70r5sfw8=
Message-ID: <26a29420-8d27-4069-bbd5-28692c9e8542@arm.com>
Date: Thu, 12 Nov 2026 16:35:35 +0000
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
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
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
 <1e02dfff-c1ad-46bb-9834-fd4bbaa46179@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <1e02dfff-c1ad-46bb-9834-fd4bbaa46179@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/11/2026 10:43, Steven Price wrote:
> On 11/11/2026 15:21, Suzuki K Poulose wrote:
>> On 11/11/2026 14:57, Steven Price wrote:
>>> Check the guest_memfd backing file when deciding whether an arm64
>>> memslot has mappable memory rather than checking whether the slot is
>>> gmem only. A public helper function is added to be able to reuse the
>>> static kvm_gmem_supports_mmap() function.
>>>
>>
>> Please could you explain why we need this ? Why not rely on
>> kvm_memslot_is_gmem_only(), which already tells
>> kvm_gmem_supports_mmap() ? With inplace conversion support gmem supports
>> mmap.
> 
> Unless I'm missing something it's still possible to create a guest_memfd
> that doesn't support mmap() by not passing the GUEST_MEMFD_FLAG_MMAP
> flag. So kvm_memslot_is_gmem_only() doesn't actually guarantee that it's
> a guest_memfd that supports mmap().

I see, while the KVM decides that, with inplace conversion shared pages
come from gmem, we do allow creation of gmem without MMAP set, implying
we would fail the mmap request from VMM, which is pretty pointless. But
should the KVM fail this when VMM is shooting on its foot ? Only makes
sense if there are no untrusted device DMA for the CoCo Guest.

Am I missing something ?

Cheers
Suzuki




> 
>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>
>>> ---
>>> Changes since v1:
>>> - New patch in v2. Check the guest_memfd backing file rather than the
>>>     memslot flag when deciding whether arm64 can map the backing memory.
>>> ---
>>>    arch/arm64/kvm/mmu.c     | 7 ++++---
>>>    include/linux/kvm_host.h | 1 +
>>>    virt/kvm/guest_memfd.c   | 6 ++++++
>>>    3 files changed, 11 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 1db10d8d6db7..a146f6cde3d0 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -2839,10 +2839,11 @@ int kvm_arch_prepare_memory_region(struct kvm
>>> *kvm,
>>>            return -EFAULT;
>>>          /*
>>> -     * Only support guest_memfd backed memslots with mappable memory,
>>> since
>>> -     * there aren't any CoCo VMs that support only private memory on
>>> arm64.
>>> +     * Protected VMs currently require guest_memfd backed memslots with
>>> +     * mappable memory to support shared mappings.
>>>         */
>>> -    if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
>>> +    if (kvm_arch_has_private_mem(kvm) && kvm_slot_has_gmem(new) &&
>>> +        !kvm_gmem_slot_supports_mmap(new))
> 
> Sashiko has identified I've screwed up this condition though.
> kvm_arch_has_private_mem(kvm) shouldn't be in there as that allows a
> non-private VM to bind a non-mmappable gmem.
> 
>>>            return -EINVAL;
>>>          /* guest_memfd is incompatible with MTE. */
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index e7fc94e2910a..f65728a713ec 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2614,6 +2614,7 @@ static inline bool kvm_is_private_gfn(struct kvm
>>> *kvm, gfn_t gfn)
>>>      #ifdef CONFIG_KVM_GUEST_MEMFD
>>>    bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
>>> +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot);
>>>    bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
>>>      static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index 8c97a69b16dc..3dd8d227bebb 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -442,6 +442,12 @@ static bool kvm_gmem_supports_mmap(struct inode
>>> *inode)
>>>        return GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_MMAP;
>>>    }
>>>    +bool kvm_gmem_slot_supports_mmap(const struct kvm_memory_slot *slot)
>>> +{
>>> +    /* The guest_memfd file is pinned while preparing a new memslot. */
>>
>> We should gate this on kvm_slot_has_gmem() and how do we ensure that the
>> call comes after it is prepared ?
> 
> I'm not sure what you mean by "gate this on kvm_slot_has_gmem()" - yes
> this function only makes sense on a gmem slot - the user above checks
> that first. I'm not sure what value the function should call if you call
> it on a non-gmem slot?
> 
> Thanks,
> Steve
> 
>>> +    return kvm_gmem_supports_mmap(file_inode(slot->gmem.file));
>>> +}
>>> +
>>>    static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>    {
>>>        struct inode *inode = file_inode(vmf->vma->vm_file);
>>
>>
>> Cheers
>> Suzuki
> 

