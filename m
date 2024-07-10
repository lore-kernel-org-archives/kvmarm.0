Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792CE1946AD;
	Wed, 10 Jul 2024 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720627496; cv=none; b=Wiv8XFhZUuh9yxARPK4hCGcdrMBXzxTYjAElatL5eO4HyV5vfynKcKuwVVLdWBqxmlvtxn8e6XuPGfCvCKEaEhEVW1zN6a9bNh9dT169RKPse1+jKEOycXSW5CISL4B4HgXOCYFRifLG2ZSG19nygicI0Y0gDZnXn1y9yIh+Z0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720627496; c=relaxed/simple;
	bh=ZT+vmHSzj0V3TRaEXdahnczrOE+RLfpcX61gANIuHEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxcNcdAnSCtceHY2gAYfnagUoA590x5O05KBCS+7RhD3CoSeSQBIeKJTvkyqJR6UQ6+7gS6MGm+flLFXXQ/f7Mxq/J3n2mlOUY65odc2BSf1qhCHgGa65uMYFDfpXX5r2y3PVOHFTzidHg6KaWqPgQvcnBp/h88y8I6E4aiSG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C43A367;
	Wed, 10 Jul 2024 09:05:19 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 548B43F762;
	Wed, 10 Jul 2024 09:04:50 -0700 (PDT)
Message-ID: <862c600c-6803-4c25-8234-c8d056e94f23@arm.com>
Date: Wed, 10 Jul 2024 17:04:48 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/15] arm64: mm: Avoid TLBI when marking pages as
 valid
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-9-steven.price@arm.com>
 <20240709115754.GD13242@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240709115754.GD13242@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/07/2024 12:57, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:58AM +0100, Steven Price wrote:
>> When __change_memory_common() is purely setting the valid bit on a PTE
>> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
>> either the entry isn't changing (the valid bit was already set) or the
>> entry was invalid and so should not have been cached in the TLB.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v4: New patch
>> ---
>>  arch/arm64/mm/pageattr.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index 0e270a1c51e6..547a9e0b46c2 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>>  	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>>  					&data);
>>  
>> -	flush_tlb_kernel_range(start, start + size);
>> +	/*
>> +	 * If the memory is being made valid without changing any other bits
>> +	 * then a TLBI isn't required as a non-valid entry cannot be cached in
>> +	 * the TLB.
>> +	 */
>> +	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
>> +		flush_tlb_kernel_range(start, start + size);
>>  	return ret;
> 
> Can you elaborate on when this actually happens, please? It feels like a
> case of "Doctor, it hurts when I do this" rather than something we should
> be trying to short-circuit in the low-level code.

This is for the benefit of the following patch. When transitioning a
page between shared and private we need to change the IPA (to set/clear
the top bit). This requires a break-before-make - see
__set_memory_enc_dec() in the following patch.

The easiest way of implementing the code was to just call
__change_memory_common() twice - once to make the entry invalid and then
again to make it valid with the new IPA. But that led to a double TLBI
which Catalin didn't like[1].

So this patch removes the unnecessary second TLBI by detecting that
we're just making the entry valid. Or at least it would if I hadn't
screwed up...

I should have changed the following patch to ensure that the second call
to __change_memory_common was only setting the PTE_VALID bit and not
changing anything else (so that the TLBI could be skipped) and forgot to
do that. So thanks for making me take a look at this again!

Thanks,
Steve

[1] https://lore.kernel.org/lkml/Zmc3euO2YGh-g9Th@arm.com/
