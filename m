Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99CA388E5A;
	Thu, 25 Jun 2026 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782404358; cv=none; b=OSPdUFbuRCFnBpZ1rIBxml0YpfYndWQ6yg3G4TawH1F8z3GSpZ2MqETaTtrHCAJwL7YPzQeu6P0NPAzdVIJ6j5Fmh0121HLVIKTYeO9iH3LHN6L6S37bDiysoihEbJ2EBrzqRmeDLyN/PwoD8y3HXE3FZaE0Sn2l/11lHfQNdGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782404358; c=relaxed/simple;
	bh=pPOtgiQ6nS0ClOv75U7F6NplWOi+LZM45knFOXi9OCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D+qZ1VaANOx51b3Gp2e/J3TdCRRPq8fftbyRU2Yu5MuohExRD6urzyZrNgxPpm/FIw4BDAU6UZoO1oRzoLheWMuOfpjl0u4XMwZqc/Vw33fdaKagEFeGemSPGbJUxCPUDc2nM7tQyLFv+Apbzim7ccN5kNFbWAVuxogXwVkITSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=R8ky6eK6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="R8ky6eK6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B2F23165;
	Thu, 25 Jun 2026 09:19:11 -0700 (PDT)
Received: from [10.57.25.211] (unknown [10.57.25.211])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08E4F3F836;
	Thu, 25 Jun 2026 09:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782404356; bh=pPOtgiQ6nS0ClOv75U7F6NplWOi+LZM45knFOXi9OCM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R8ky6eK6otniQz0tX4X2/mZe2xO749mYgapqpG/Kc2tR/D52NLVkJ8nvedfF1ilEa
	 r41ZER+aidvk8k3VGWcWbqqmOgGTTlmTkJ0kiy8eQ4jiaOZj/6H+/HCPCqBr1CUwgR
	 NjT4emEydoEvvFMq+0fmgSaxYNIhbdswRVJLBDjM=
Message-ID: <9b96068c-97d8-4093-a707-faf39e193857@arm.com>
Date: Thu, 25 Jun 2026 17:19:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-27-steven.price@arm.com>
 <ea4be6c5-9506-4253-80c5-c76c9ac3b77d@redhat.com>
 <0c71b4b8-ad0b-4a24-9f4a-180b2aaacdb6@arm.com>
 <ad45c64c-18ab-4d42-9813-0ac1704bb127@arm.com>
 <9631be66-c757-488d-bb66-a62698aa26b8@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <9631be66-c757-488d-bb66-a62698aa26b8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/06/2026 14:53, Steven Price wrote:
> On 08/06/2026 10:41, Suzuki K Poulose wrote:
>> On 08/06/2026 10:36, Steven Price wrote:
>>> On 28/05/2026 06:30, Gavin Shan wrote:
>>>> Hi Steve,
>>>>
>>>> On 5/13/26 11:17 PM, Steven Price wrote:
>>>>> The VMM needs to populate the realm with some data before starting
>>>>> (e.g.
>>>>> a kernel and initrd). This is measured by the RMM and used as part of
>>>>> the attestation later on.
>>>>>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>
>> ...
>>
>>>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>>>> index a89873a5eb77..209087bcf399 100644
>>>>> --- a/arch/arm64/kvm/rmi.c
>>>>> +++ b/arch/arm64/kvm/rmi.c
>>>>> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>>>> unsigned long start,
>>>>>             realm_unmap_private_range(kvm, start, end, may_block);
>>>>>     }
>>>>>     +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>>>>> +                   kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>>>>> +                   unsigned long flags)
>>>>> +{
>>>>> +    struct realm *realm = &kvm->arch.realm;
>>>>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>>>>> +    phys_addr_t dst_phys, src_phys;
>>>>> +    int ret;
>>>>> +
>>>>> +    dst_phys = __pfn_to_phys(dst_pfn);
>>>>> +    src_phys = __pfn_to_phys(src_pfn);
>>>>> +
>>>>> +    if (rmi_delegate_page(dst_phys))
>>>>> +        return -ENXIO;
>>>>> +
>>>>> +    ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>>>>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>>>> +        /* Create missing RTTs and retry */
>>>>> +        int level = RMI_RETURN_INDEX(ret);
>>>>> +
>>>>> +        KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);
>>>>
>>>>           KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
>>>
>>> Ack.
>>>
>>
>> Thinking more about this, I guess a buggy VMM can trigger this
>> by populating twice ? (level == KVM_PGTABLE_LAST_LEVEL). So, we should
>> return the error back, than warning here and suppressing the error ?
> 
> Populating twice causes rmi_delegate_page() to be run twice on the same
> page and the second one will then fail. So I don't think this is
> possible (please correct me if I've missed something!)

Good point, but I think this may not fail to allow the hugepages in the
future. The DELEGATE_RANGE would skip the granules in DELEGATED/DATA 
state. I am getting this clarified in the spec.


Suzuki

> 
> Thanks,
> Steve

