Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712731F4CBE
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 23:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754350850; cv=none; b=RVngZbzsZOpcqdXGEbB0ARI5GWpuUCIEq2U2nUol4kWl5NNmikul6e7AXSNuZfYU8RF0Fzfx3CZrbddA/+KCW4Gr+cFyhBACWPw6jgwpgEUUDmeaBcqqOmid+/4GY3VRdZ+bhQ9GVgqiIx0e9029qbMRMW9YJdxPt7thoFc34wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754350850; c=relaxed/simple;
	bh=RrBJt+AVeLPiAADHpNjz8/IMst9IHat9YZhQfzdTQo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XC3IuFnGqRgpBVKo1G7zC4AxurNUqnITOGXbJGs6pRrRIitDJwEzGR07YkOdSEncv8/lxMmM7Wr6xWd6Jl4kF7IyJT2WVhzNnTnDCFXDOigw5gocY5STBNUUG09J3tr4nC1yFw2Najpr0wXnXPLjEzSIHqPZxPG7rOwVgMJjADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 968431E4D;
	Mon,  4 Aug 2025 16:40:39 -0700 (PDT)
Received: from [10.163.95.192] (unknown [10.163.95.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4F13F5A1;
	Mon,  4 Aug 2025 16:40:42 -0700 (PDT)
Message-ID: <261de805-2914-4172-85b4-69b5a5b1edf6@arm.com>
Date: Tue, 5 Aug 2025 05:10:39 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: ptdump: Fix exec attribute printing
To: Mark Rutland <mark.rutland@arm.com>,
 Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 Sebastian Ene <sebastianene@google.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20250802104021.3076621-1-r09922117@csie.ntu.edu.tw>
 <d72b7928-8646-4616-a8f0-96b9d9bbaf09@arm.com>
 <z2hmwwmtgbrio2wv3sj2pc4zhxdjioorlhnm45o2arcsjahjni@xod435q26jqq>
 <aJDQHMbiNVToTbum@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aJDQHMbiNVToTbum@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 04/08/25 8:52 PM, Mark Rutland wrote:
> On Mon, Aug 04, 2025 at 08:41:35PM +0800, Wei-Lin Chang wrote:
>> Hi Anshuman,
>>
>> On Sun, Aug 03, 2025 at 07:33:04PM +0530, Anshuman Khandual wrote:
>>>
>>>
>>> On 02/08/25 4:10 PM, Wei-Lin Chang wrote:
>>>> Currently the guest stage-2 page table dump has the executable attribute
>>>> printed in reverse, showing "X" for a non-executable region and showing
>>>> " " for an executable one. This is caused by misjudgement of which
>>>> string gets printed for the executable and non-executable case. Fix it
>>>> by swapping the two strings.
>>>>
>>>> Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
>>>> ---
>>>>  arch/arm64/kvm/ptdump.c | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
>>>> index 098416d7e5c25..99fc13f1c11fb 100644
>>>> --- a/arch/arm64/kvm/ptdump.c
>>>> +++ b/arch/arm64/kvm/ptdump.c
>>>> @@ -44,8 +44,8 @@ static const struct ptdump_prot_bits stage2_pte_bits[] = {
>>>>  	}, {
>>>>  		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID,
>>>>  		.val	= PTE_VALID,
>>>> -		.set	= " ",
>>>> -		.clear	= "X",
>>>> +		.set	= "X",
>>>> +		.clear	= " ",
>>>>  	}, {
> 
> I think the big problem here is that we've included the 'PTE_VALID' bit
> in the mask. We don't bother with that for the Stage-1 ptdump code, e.g.
> 
>         {
>                 .mask   = PTE_PXN,
>                 .val    = PTE_PXN,
>                 .set    = "NX",
>                 .clear  = "x ",
>         },
> 
> .... so do we actually need to take the PTE_VALID bit into account here? Do
> invalid Stage-2 entries have anything we don't want to report?
> 
> ... or can we change the Stage-2 ptdump code to have:
> 
> 	{
> 		.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> 		.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
> 		.set	= "NX",
> 		.clear	= "x ",
> 	},
> 
> ... and match the Stage-1 code?
> 
> Otherwise, maybe we can add a separate valid-only filter.

Agreed.

PTE_VALID should be removed from all these existing filters here
and then add it back as a separate filter like Stage-1. Ohh, but
it is already in there. Checking for PTE_VALID along with other
intended filter masks does not make sense.

> 
>>>>  		.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
>>>>  		.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF | PTE_VALID,
>>>
>>> Is not KVM_PTE_LEAF_ATTR_HI_S2_XN already in the reverse semantics aka
>>> XN (Execute Never). Hence when KVM_PTE_LEAF_ATTR_HI_S2_XN macro is set
>>> that means the entry is not executable and vice versa.
>>
>> Yes you are correct. However in dump_prot() we have:
>>
>> if ((st->current_prot & bits->mask) == bits->val)
>> 	s = bits->set;
>> else
>> 	s = bits->clear;
>>
>> Analysis:
>>
>> 1. region is executable:
>>     - st->current_prot == PTE_VALID (ignore other bits)
>>     - st->current_prot & bits->mask gets PTE_VALID
>>     - if condition is true (.val is PTE_VALID)
>>     - prints bits->set
>>
>> 2. region is not executable:
>>     - st->current_prot == KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID
>>     - st->current_prot & bits->mask gets (KVM_PTE_LEAF_ATTR_HI_S2_XN | PTE_VALID)
>>     - if condition is false
>>     - prints bits->clear
> 
> As above, this is because the PTE_VALID bit has been placed into the
> mask, and that's not how the ptdump code was intended to be used.
> 
>> Therefore we want .set = "X", and .clear = " ".
> 
> That'll work around the problem, but I'm not sure that's the right fix.
> If nothing else, it's *very* confusing.
> 
> Mark.
