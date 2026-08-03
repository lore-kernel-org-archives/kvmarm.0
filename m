Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7523B312815;
	Mon,  3 Aug 2026 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785771009; cv=none; b=s26laiCRxV7HwFhdyO/k8p9e9PrUWalQqkIyaUfdYcUZPe0gJNI4PEsfx/SFsjr+kwMI0OfkQ4VDmvZ2jC3PwOvDNM2fKeJyP5znIXMf/g9sNagpefXaLr4iBfTUQqfQgYpMK/wnqSaGPSsVRsf/AOnTkiNlgs9zElPC1MZzqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785771009; c=relaxed/simple;
	bh=PBiq1BJGOyxAnrDb4iLnJzH9V5hipyTxzZgMUSlKBws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bBBPersgWAMX5Us0gqPXDfkEqOTW3MdbhSF1/i6LQ0ZTMzWwKl2R0nVESMSNsAFQLK55qKpokxIpafdlhbFxs7aMcXOxEeOE0Bwm01zl77UDCVvXWrSC3nhPqlOEO9erw3MvoBDlvkEUZI51I9ARLA0HX1qJXOxY0ZNzWWUskNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ISlaxO69; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ISlaxO69"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE7F0143D;
	Mon,  3 Aug 2026 08:30:03 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0BC643F66F;
	Mon,  3 Aug 2026 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785771007; bh=PBiq1BJGOyxAnrDb4iLnJzH9V5hipyTxzZgMUSlKBws=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ISlaxO69AKS+iL1eqL42p5aCnEVhBsvBUMQS7cxndVDTvEhVptluyOBzMnDUKAZBN
	 Ge3PibxaqDSMMl2h9qSV6mpdSuQRPw/gWTnFTjh1/lss3w9cIm1g4qM6lSakSLSUOm
	 p4YZujFysuZyumIOjBiird/EE64/49BSmwfpJPMA=
Message-ID: <7beafe29-0c5e-418b-8797-190f1850b18a@arm.com>
Date: Mon, 3 Aug 2026 16:30:02 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 15/37] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
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
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-16-steven.price@arm.com> <865x1rcvfw.wl-maz@kernel.org>
 <f971d029-84d9-4c66-9875-36fa8f1a2a1b@arm.com> <86zez3b6ps.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86zez3b6ps.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/08/2026 15:48, Marc Zyngier wrote:
> On Mon, 03 Aug 2026 15:04:32 +0100,
> Steven Price <steven.price@arm.com> wrote:
> 
> [...]
> 
>>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>>> index cd06881c1497..dcc2ab08d0e4 100644
>>>> --- a/arch/arm64/kvm/mmu.c
>>>> +++ b/arch/arm64/kvm/mmu.c
>>>> @@ -319,6 +319,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>>>>    * @start: The intermediate physical base address of the range to unmap
>>>>    * @size:  The size of the area to unmap
>>>>    * @may_block: Whether or not we are permitted to block
>>>> + * @only_shared: If true then protected mappings should not be unmapped
>>>>    *
>>>
>>> I don't understand the need for this additional argument. Given that
>>> CCA imposes that shared and private are in non-overlapping ranges, why
>>> is it necessary to introduce this at the core of the S2 management
>>> code?
>>>
>>> I'd expect that the CCA code could simply work out what range it needs
>>> to run on and keep the API intact.
>>>
>>>>    * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
>>>>    * be called while holding mmu_lock (unless for freeing the stage2 pgd before
>>>> @@ -326,7 +327,7 @@ static void invalidate_icache_guest_page(void *va, size_t size)
>>>>    * with things behind our backs.
>>>>    */
>>>>   static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
>>>> -				 bool may_block)
>>>> +				 bool may_block, bool only_shared)
>>>>   {
>>>>   	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>>>>   	phys_addr_t end = start + size;
>>>
>>> So what is the *actual* change?
>>
>> It looks like I've screwed up what goes in which patch. The real change
>> is in patch 22 where this 'only_shared' property gets passed down to
>> kvm_realm_unmap_range(). There it's used to decide whether the private
>> range should be unmapped or not.
>>
>> The reason for this is kvm_unmap_gfn_range() which has a 'attr_filter'
>> member of 'kvm_gfn_range' which can specify KVM_FILTER_PRIVATE. Which is
>> used in __kvm_gmem_set_attributes() so choose whether to invalidate the
>> private or shared part of a gmem range.
> 
> But you can readily distinguish the private/shared part of the address
> range by looking at the top IPA bit, right? And from there, you should
> be in a position to decide whether to call __unmap_stage2_range() on a
> per IPA range, rather than making this information trickle all over
> the place.

Yes, we can for an "IPA". However there are two different things
at play here. There is KVM generic "GPA" (as manitained by the slot)
and where the backend maps it in stage2 "IPA". For Arm CCA, for shared
GPAs, the "IPA" is an alias of the GPA. But, here we get the GPA from
the core layer.

There is a shared/private state associated with each "GPA" (GFN) as
maintained by the Guest_memfd for each GPA in a memslot backed by it.
When a change occurs in the backing store (e.g. set GPA to private,
punch a hole in GPA, destroy a given range of GPAs), an invalidation
needs to be triggered in the Stage2. Now, given different architectures
have different ways to deal with private vs shared GPAs, (e.g.,
on CCA, shared GPAs are mapped in an aliased IPA) and the private GPAs
are special, Guest_memfd tells you which ones need invalidation, using
the filter. This filter then gets handled by the backends (CCA unmaps
aliased address for Shared filter). Ideally this filter should be passed
down to the core routine, so that it can be handled by the backends
appropriately (similar to the range->mayblock).

> 
> I.e don't hack into the API. Use the information you already have to
> decide whether you need to use the existing API at all.
> 
> If that cannot be done for whatever reason, then you need to indirect
> the call with a set of operations that leave the existing code
> untouched.

Please let us know if you think we need to explore this ^ ?

Cheers
Suzuki

> 
> 	M.
> 

