Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204DE137E
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 117E51007;
	Mon, 30 Oct 2023 04:02:29 -0700 (PDT)
Received: from [10.57.71.117] (unknown [10.57.71.117])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 337623F67D;
	Mon, 30 Oct 2023 04:01:45 -0700 (PDT)
Message-ID: <187c74b3-c9a1-4a92-957d-58cf2b0ed290@arm.com>
Date: Mon, 30 Oct 2023 11:01:43 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
Content-Language: en-GB
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 will@kernel.org, willy@infradead.org
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <20230928173205.2826598-3-vdonnefort@google.com>
 <418313c5-2094-4aaf-ae43-a1f3bf8e936f@arm.com> <ZT-Jw4SVJ6C1E6sc@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <ZT-Jw4SVJ6C1E6sc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/10/2023 10:47, Vincent Donnefort wrote:
> [...]
> 
>>>  static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
>>>  	.zalloc_page		= stage2_memcache_zalloc_page,
>>>  	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
>>> @@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
>>>   *
>>>   * Returns the size of the mapping.
>>>   */
>>> -static long
>>> +static unsigned long
>>>  transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>>>  			    unsigned long hva, kvm_pfn_t *pfnp,
>>>  			    phys_addr_t *ipap)
>>> @@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>>>  	 * block map is contained within the memslot.
>>>  	 */
>>>  	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
>>> -		int sz = get_user_mapping_size(kvm, hva);
>>> -
>>> -		if (sz < 0)
>>> -			return sz;
>>> +		size_t sz = folio_size(pfn_folio(pfn));
>>
>> Hi,
>>
>> Sorry this is an extremely late reply - I just noticed this because Marc
>> mentioned it in another thread.
>>
>> This doesn't look quite right to me; just because you have a folio of a given
>> size, that doesn't mean the whole thing is mapped into this particular address
>> space. For example, you could have a (PMD-sized) THP that gets partially
>> munmapped - the folio is still PMD-sized but only some of it is mapped and
>> should be accessible to the process. Or you could have a large file-backed folio
>> (from a filesystem that supports large folios - e.g. XFS) but the application
>> only mapped part of the file.
> 
> I thought originally this would break the block and the folio with it, but a
> quick expriment showed it's not the case.

That's not how it works unfortunately. Even if we wanted to do this in the
common case (which we might in future for anon memory) there are edge cases
where splitting the folio can fail (GUP). And it wouldn't make sense to split
for file-backed case since those folios may be mapped into other processes.

> 
>>
>> Perhaps I've misunderstood and those edge cases can't happen here for some reason?
> 
> And fault_supports_stage2_huge_mapping() would probably not be enough. we might
> end-up with a portion unmapped at stage-1 but mapped at stage-2. :-( 

Yes. Or even remapped if you consider mremapping a portion of the THP.

> 
>>
>> Thanks,
>> Ryan
>>
>>

