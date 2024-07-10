Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF2E1946DC;
	Wed, 10 Jul 2024 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625679; cv=none; b=pCdDjKZS3HMq7VHxRmBarHLHFxfpLtAV175zWRkd/BLme/nMdpO4reBCIUyE3mzp2NWL17/IfQ3CY5uXmiNIBDK8LWjZtsBzlwJTzRYToZ6J6PxyZa7W9a7yz5b06QdagTYMXYVoGJ/rsf5BfR6EqkFwodQW3y+5NEtEtn9+2L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625679; c=relaxed/simple;
	bh=bLjriFoMARhnDgEhXPye8f2db2fF12WTehS44IJTXZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XVypSWDIMf0DHzds/dYk/K7gnyVSgKJY52BMsBCUWj2ic66Hf2AZwMsROsENqESbhtAmRbXUkpomZN84Pib+Xcq6CwAptJK5cTtXxhY6qLq9Z1uHU16W3wqmjuLiHKk7Gvvgoi95PSzyOWqCXNvbqHSU930jo+r7niqw3RtSVy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65615106F;
	Wed, 10 Jul 2024 08:35:01 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4DCC3F766;
	Wed, 10 Jul 2024 08:34:29 -0700 (PDT)
Message-ID: <ba83b54a-f780-44bc-af11-94c6c05b825f@arm.com>
Date: Wed, 10 Jul 2024 16:34:17 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
 <20240709113925.GA13242@willie-the-truck>
 <f8dca28c-e5d6-4a1b-8bd3-6a711dae7078@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <f8dca28c-e5d6-4a1b-8bd3-6a711dae7078@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/07/2024 13:54, Suzuki K Poulose wrote:
> Hi Will
> 
> On 09/07/2024 12:39, Will Deacon wrote:
>> On Mon, Jul 01, 2024 at 10:54:55AM +0100, Steven Price wrote:
>>> All I/O is by default considered non-secure for realms. As such
>>> mark them as shared with the host.
>>>
>>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v3:
>>>   * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
>>>     set_fixmap_io() with a custom function.
>>>   * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
>>> ---
>>>   arch/arm64/include/asm/fixmap.h | 2 +-
>>>   arch/arm64/include/asm/io.h     | 8 ++++----
>>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/fixmap.h
>>> b/arch/arm64/include/asm/fixmap.h
>>> index 87e307804b99..f2c5e653562e 100644
>>> --- a/arch/arm64/include/asm/fixmap.h
>>> +++ b/arch/arm64/include/asm/fixmap.h
>>> @@ -98,7 +98,7 @@ enum fixed_addresses {
>>>   #define FIXADDR_TOT_SIZE    (__end_of_fixed_addresses << PAGE_SHIFT)
>>>   #define FIXADDR_TOT_START    (FIXADDR_TOP - FIXADDR_TOT_SIZE)
>>>   -#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
>>> +#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>>     void __init early_fixmap_init(void);
>>>   diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>>> index 4ff0ae3f6d66..07fc1801c6ad 100644
>>> --- a/arch/arm64/include/asm/io.h
>>> +++ b/arch/arm64/include/asm/io.h
>>> @@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void
>>> __iomem *to, const void *from,
>>>     #define ioremap_prot ioremap_prot
>>>   -#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
>>> +#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>>     #define ioremap_wc(addr, size)    \
>>> -    ioremap_prot((addr), (size), PROT_NORMAL_NC)
>>> +    ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
>>>   #define ioremap_np(addr, size)    \
>>> -    ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
>>> +    ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
>>
>> Hmm. I do wonder whether you've pushed the PROT_NS_SHARED too far here.
>>
>> There's nothing _architecturally_ special about the top address bit.
>> Even if the RSI divides the IPA space in half, the CPU doesn't give two
>> hoots about it in the hardware. In which case, it feels wrong to bake
>> PROT_NS_SHARED into ioremap_prot -- it feels much better to me if the
>> ioremap() code OR'd that into the physical address when passing it down

This is really just a simplification given we don't (yet) have device
assignment.

> Actually we would like to push the decision of applying the
> "pgprot_decrypted" vs pgprot_encrypted into ioremap_prot(), rather
> than sprinkling every user of ioremap_prot().
> 
> This could be made depending on the address that is passed on to the
> ioremap_prot(). I guess we would need explicit requests from the callers
> to add "encrypted vs decrypted". Is that what you guys are looking at ?

There's a missing piece at the moment in terms of how the guest is going
to identify whether a particular device is protected or shared (i.e. a
real assigned device, or emulated by the VMM). When that's added then I
was expecting ioremap_prot() to provide that flag based on discovering
whether the address range passed in is for an assigned device or not.

>>
>> There's a selfish side of that argument, in that we need to hook
>> ioremap() for pKVM protected guests, but I do genuinely feel that
>> treating address bits as protection bits is arbitrary and doesn't belong
>> in these low-level definitions. In a similar vein, AMD has its

I'd be interested to see how pKVM will handle both protected and
emulated (by the VMM) devices. Although we have the 'top bit' flag it's
actually a pain to pass that down to the guest as a flag to use for this
purpose (e.g. 32 bit PCI BARs are too small). So our current thought is
an out-of-band request to identify whether a particular address
corresponds to a protected device or not. We'd then set the top bit
appropriately.

>> sme_{set,clr}() macros that operate on the PA (e.g. via dma_to_phys()),
>> which feels like a more accurate abstraction to me.
> 
> I believe that doesn't solve all the problems. They do have a hook in
> __ioremap_caller() that implicitly applies pgprot_{en,de}crypted
> depending on other info.

This is the other option - which pushes the knowledge down to the
individual drivers to decide whether a region is 'encrypted' (i.e.
protected) or not. It's more flexible, but potentially requires 'fixing'
many drivers to understand this.

Thanks,
Steve

> Cheers
> Suzuki
> 
>>
>> Will
> 

