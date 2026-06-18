Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34153B3888;
	Thu, 18 Jun 2026 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782000; cv=none; b=nnNSnslL09ruMaiiFoamWokkEN0CdVaIM8uLSa8p6pRMm+Y88gBkFNxG5F36G4NgGthG8AceTLF0Vybf7Cg+Y6UmtYbeTkEzaF59jUjHkhJnqxtELxna0EPZajxHDCIjk7SnEoZAx4ZV0pT0fUfxeRo2tQeIcLE1MEqAHhFm+cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782000; c=relaxed/simple;
	bh=LcakeM4oMQyutQUdWBwBM3Vm2qpN4Zfb8HX1pR6lHsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WnsTomaa6GmpYH1s6JJqzgz9EzwdifP3c9ptk1gCOeQuhfyz5WS0tItJgzcUO23CxEB5O7QxHRqlGan+6cCU6x8efuYuNtNQF3twHAigjKfOdc8d4jj9IREf5dlazyX5jTZTy2MDave2KFRjP8/yDdJ2X6h/KjjvW+JdZImIlu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWOiyur8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWOiyur8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D071F000E9;
	Thu, 18 Jun 2026 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781781999;
	bh=4QDK2jCIWPvZ2ONcm4xowx5WtNzU5+JH9ZsV8OFhnKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RWOiyur8C67wNqTpbgGN5qR7NuPJMtmXK7V875vdMJCXviAl5Uy50Hnd659YniuF6
	 YaveuThHh+nqLCw1lkNT7muJ8bSgMVTqtLKlA8b+MiM6XRtmCl2/BTEdx0/XJ6dPXx
	 t9Nicf1spXrdiKz5258cvn1Yxfxp3/utXhjtM8lak9smXtSLTRztDJXOxoBa868Yq2
	 KqS9/xXeIMIMDHV2N3n4ki5J+TCpg8jAC+Y9+yJv2Ky29w7PuZaT9K53yT7eRx2RPd
	 s1NypOU+Qxtp00E/WYoxwQbSO1W1GXyycjPuS9+FDmMkmXpWwR9SJkL/ulWU70uHQV
	 pM2WziKqY2frw==
Message-ID: <499650f7-8c9c-4e58-83d1-0bc26e23b949@kernel.org>
Date: Thu, 18 Jun 2026 13:26:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
To: Sean Christopherson <seanjc@google.com>, sashiko-reviews@lists.linux.dev
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Marc Zyngier
 <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Oliver Upton <oupton@kernel.org>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org> <ajA6ogaNiI3KDv5i@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajA6ogaNiI3KDv5i@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/26 19:47, Sean Christopherson wrote:
> On Mon, Jun 15, 2026, sashiko-bot@kernel.org wrote:
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>> [ ... ]
>>> @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
>>>  			unsigned long hva_start, hva_end;
>>>  
>>>  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
>>> +
>>> +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
>>> +				continue;
>>> +
>>
>> [Severity: Critical]
>> Does this change inadvertently introduce a regression in the pfncache retry
>> protocol?
>>
>> Looking at the pfncache framework, it maps guest memory into kernel space and
>> explicitly drops the page reference after mapping it:
>>
>> virt/kvm/pfncache.c:hva_to_pfn_retry() {
>>     ...
>>     kvm_release_page_clean(page);
>>     ...
>> }
>>
>> It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_seq)
>> to invalidate the cache when the page is unmapped by the host.
>>
>> If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
>> but still provides a valid anonymous user mapping as its userspace_addr,
>> could this regression lead to a use-after-free?
> 
> Sadly, yes.  To land this, we would need to first teach the gfn_to_pfn_cache code
> to be able to pull directly from guest_memfd.  I forget if anyone is working on
> that.

For completeness, I think this is what you are looking for:

https://lore.kernel.org/r/20260420154720.29012-1-itazur@amazon.com

-- 
Cheers,

David
