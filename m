Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0110B46F48F;
	Mon, 28 Sep 2026 08:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583196; cv=none; b=YbWd6CzQxrCJa9yTkLSiGU0qRcjvTQErYFLQ8Kxb9pzs5XNEWMcMFN8+R7bkBovMI9XRrqVhCxknAKolBkZQegEh7kdLlF0FnRNFnw8JZCI9UlNUEN1w46v9me8e8MW0EPZonom0UZfUTGmJ7BOHqkEKUXkzqBbahREf5qkHUpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583196; c=relaxed/simple;
	bh=WPsNvAvqg8vhI8zzc//qW9WbhUe4lVNYZ4Eno5ypewM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JWE3HZUpjtCHaHLuwG/y3I8so+8tyyh91JhiIukvcWpo7EzWoVccMAV6o6qLcNlItb6/PsrTOdQK2X31XEhM8f6qYj1WW40tc09fU+4eiPfTu97nWY9sIi4Sy5X1hRGCG4nVCTz2pg02BIPPiqreswe64FRwMq4sruOA/A18ELM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iOZvP4NM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iOZvP4NM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF46B1692;
	Mon, 28 Sep 2026 01:13:10 -0700 (PDT)
Received: from [10.57.12.79] (unknown [10.57.12.79])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EE4C3F86F;
	Mon, 28 Sep 2026 01:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790583194; bh=WPsNvAvqg8vhI8zzc//qW9WbhUe4lVNYZ4Eno5ypewM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iOZvP4NMl30vWU5Lqmr7s+xMn1mwl56R/TOdnVKw8skmeTKUUs/4iTPO6zUeezNuh
	 XXNrVLaKC9r6XO1DXTxyxf09PwHbXMzYRHE7a5vCAj38rwWFunIuBYTvnOy+264YZA
	 2ACgAlSG9yCd0UTWaM9fHAUo4RIvzG5gDxgUrkVo=
Message-ID: <3bd74dc2-d057-4f63-8a3d-b6337953c047@arm.com>
Date: Mon, 28 Sep 2026 09:13:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 09/20] KVM: arm64: Add VM specific callback for S2 MMU
 operations
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-10-suzuki.poulose@arm.com>
 <647ae455-4175-4070-a40e-d2d89f18971f@redhat.com>
 <df7e9870-1176-4679-bd79-807c0d87a4f2@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <df7e9870-1176-4679-bd79-807c0d87a4f2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 28/09/2026 02:25, Gavin Shan wrote:
> On 9/28/26 11:09 AM, Gavin Shan wrote:
>> On 9/21/26 7:28 AM, Suzuki K Poulose wrote:
>>> Add VM type specific S2 MMU operation backends which can be 
>>> initialized per
>>> VM flavor, to keep the handling cleaner.
>>>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> ---
>>>   arch/arm64/include/asm/kvm_host.h |  15 ++++
>>>   arch/arm64/kvm/mmu.c              | 137 +++++++++++++++++++++++++-----
>>>   2 files changed, 131 insertions(+), 21 deletions(-)

...

>>> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
>>> +                     gfn_t gfn, u64 nr_pages)
>>> +{
>>> +    if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)
>>> +        return 1;
>>> +
>>
>> Realm would the only case where vm_s2_ops->vm_flush_remote_{tlbs, 
>> tlbs_range)
>> are NULL. On request to flush remote TLBs by 
>> kvm_flush_remote_tlbs_range(), it
>> ends up with event KVM_REQ_TLB_FLUSH queued for each vCPU. How this 
>> queued event
>> is linked to a remote TLB flush for realm? The problem is TLBs are 
>> owned by EL2
>> realm and there are no RMI calls for the management. So I'm wandering 
>> we should
>> return 0 here?
>>
> 
> vm_s2_ops->vm_flush_remote_{tlbs, tlbs_range} are added in PATCH[14] 
> where 0 is
> returned for both function. So I guess needn't this check at all?
> 
>       if (!kvm->arch.vm_s2_ops->vm_flush_remote_tlbs_range)

I would leave that check as they are. The only callback that
is mandatory is the vm_mem_abort and we do enforce it at init.

Cheers
Suzuki

