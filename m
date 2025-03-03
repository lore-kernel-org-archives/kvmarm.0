Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA15212B0A;
	Mon,  3 Mar 2025 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741014331; cv=none; b=geyXXnAzBUPhOAcJke1wPxoVPoOzUNJuzeRIZzOv6reAQqNXqTPy6YwdQ4oQxDPbKcgQW9zyHthteMnf9g8oNI6FsfdPbZxaHhR/OYbJdF7qLAbg8546WnYjmo27v0hAwVda4Zd4YeFIP9who347sm4xLElffTMeyxLWwz17YNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741014331; c=relaxed/simple;
	bh=FAfxwdkJdI2ka4k/gWKw/rIYeoMTctGSdN1ZWB+qzBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6yhaQMsRE0aJuqH+RPOXpaAr7wNK6RFX3l3X+SUvCEkeM6whHyXEKIj53ykRGXnZ+zu50SCpEp2Xh/26FUp1lmeHLljk9BetHiY9ZNkufpzi2f77juDPZMbaH+Y4fg/jJC5gNQ7asvVXZFHJY8/osZuyqpDaVG+6ux4J7AyU0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B0B6113E;
	Mon,  3 Mar 2025 07:05:43 -0800 (PST)
Received: from [10.1.39.33] (e122027.cambridge.arm.com [10.1.39.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD6FE3F5A1;
	Mon,  3 Mar 2025 07:05:25 -0800 (PST)
Message-ID: <762524e0-d54f-4026-8a1d-732a7cfc6a1a@arm.com>
Date: Mon, 3 Mar 2025 15:05:24 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/45] KVM: Prepare for handling only shared mappings
 in mmu_notifier events
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-2-steven.price@arm.com>
 <8bf9ba6c-a8b2-42aa-9802-8e968bec1cd5@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8bf9ba6c-a8b2-42aa-9802-8e968bec1cd5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/03/2025 23:36, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add flags to "struct kvm_gfn_range" to let notifier events target only
>> shared and only private mappings, and write up the existing mmu_notifier
>> events to be shared-only (private memory is never associated with a
>> userspace virtual address, i.e. can't be reached via mmu_notifiers).
>>
>> Add two flags so that KVM can handle the three possibilities (shared,
>> private, and shared+private) without needing something like a tri-state
>> enum.
>>
>> Link: https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   include/linux/kvm_host.h | 2 ++
>>   virt/kvm/kvm_main.c      | 7 +++++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 3cb9a32a6330..0de1e485452c 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -266,6 +266,8 @@ struct kvm_gfn_range {
>>       gfn_t end;
>>       union kvm_mmu_notifier_arg arg;
>>       enum kvm_gfn_range_filter attr_filter;
>> +    bool only_private;
>> +    bool only_shared;
>>       bool may_block;
>>   };
> 
> The added members (only_private and only_shared) looks duplicated to the
> member of attr_filter, which can be set to KVM_FILTER_SHARED,
> KVM_FILTER_PRIVATE,
> or both of them. More details can be found from the following commit where
> attr_filter was by dca6c88532322 ("KVM: Add member to struct kvm_gfn_range
> to indicate private/shared").
> 
> I'm guessing Sean's suggestion was given before dca6c88532322 showed up.

Thanks for pointing this out - you are absolutely right. I need to
switch the code in the following patches over to use attr_filter
instead. I hadn't realised when rebasing that attr_filter is the
replacement.

Thanks,
Steve

>>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index faf10671eed2..4f0136094fac 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -593,6 +593,13 @@ static __always_inline kvm_mn_ret_t
>> __kvm_handle_hva_range(struct kvm *kvm,
>>                * the second or later invocation of the handler).
>>                */
>>               gfn_range.arg = range->arg;
>> +
>> +            /*
>> +             * HVA-based notifications aren't relevant to private
>> +             * mappings as they don't have a userspace mapping.
>> +             */
>> +            gfn_range.only_private = false;
>> +            gfn_range.only_shared = true;
>>               gfn_range.may_block = range->may_block;
>>               /*
>>                * HVA-based notifications aren't relevant to private
> 
> Thanks,
> Gavin
> 

