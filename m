Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E2314A4F0;
	Mon,  8 Jun 2026 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780926844; cv=none; b=Uto/d1jDi63ZqMBDZUtR2XiIkrXoTYQGqsQ3P7kFNbQHYJg9amWSzSbD7s5qLAOLf+tjrtfIS1PJ8ydSxQwPspC1hIoPd0ryfGmGX00CFh5YfMi28zcYaV0DTraLdAgFeWD9NXvWmJjXPGjusnQxjCvcxYk+nAqSiYlUiDcARik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780926844; c=relaxed/simple;
	bh=zyFb9/SAECng/VTwTudQLxjUQyq0g0AZM0OK2JIT8NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNwy33/GQF9mqxdbkSOyouaWaFUiae6p3KHhQYPr2xjjh3WTrnZLtbw6ZSKpAShEuH+3215xNyZ5bY5aP/3zi+7nUDnL4k86KIyEX7PzWi/zVbdhZAnHWN6dfGp4RLHuk1jGpESPh45WVOkbgXOEtsQlmzby9THkU+uIfUx8upo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Am229Gtp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Am229Gtp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FD22244B;
	Mon,  8 Jun 2026 06:53:57 -0700 (PDT)
Received: from [10.57.28.93] (unknown [10.57.28.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B1E43F86F;
	Mon,  8 Jun 2026 06:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780926842; bh=zyFb9/SAECng/VTwTudQLxjUQyq0g0AZM0OK2JIT8NA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Am229GtpwnsAOTgPNgH0rKMU0izNXaGe3sEaiDNq7CSGq+5bEqKfsCQAYLrBmWu9g
	 R3SFvmmvI0pML1LYEXP6f3iuiDl8j4v8RrDvp7FFT4rwKDMIrcT7jYncMiFsWKki02
	 FZWtyD5eqhQTmw5GvKPFroyhVAwfW/ZXzGJk0H/A=
Message-ID: <9631be66-c757-488d-bb66-a62698aa26b8@arm.com>
Date: Mon, 8 Jun 2026 14:53:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 26/44] arm64: RMI: Allow populating initial contents
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Gavin Shan <gshan@redhat.com>,
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
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ad45c64c-18ab-4d42-9813-0ac1704bb127@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 08/06/2026 10:41, Suzuki K Poulose wrote:
> On 08/06/2026 10:36, Steven Price wrote:
>> On 28/05/2026 06:30, Gavin Shan wrote:
>>> Hi Steve,
>>>
>>> On 5/13/26 11:17 PM, Steven Price wrote:
>>>> The VMM needs to populate the realm with some data before starting
>>>> (e.g.
>>>> a kernel and initrd). This is measured by the RMM and used as part of
>>>> the attestation later on.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
> 
> ...
> 
>>>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>>>> index a89873a5eb77..209087bcf399 100644
>>>> --- a/arch/arm64/kvm/rmi.c
>>>> +++ b/arch/arm64/kvm/rmi.c
>>>> @@ -486,6 +486,75 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>>>> unsigned long start,
>>>>            realm_unmap_private_range(kvm, start, end, may_block);
>>>>    }
>>>>    +static int realm_data_map_init(struct kvm *kvm, unsigned long ipa,
>>>> +                   kvm_pfn_t dst_pfn, kvm_pfn_t src_pfn,
>>>> +                   unsigned long flags)
>>>> +{
>>>> +    struct realm *realm = &kvm->arch.realm;
>>>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>>>> +    phys_addr_t dst_phys, src_phys;
>>>> +    int ret;
>>>> +
>>>> +    dst_phys = __pfn_to_phys(dst_pfn);
>>>> +    src_phys = __pfn_to_phys(src_pfn);
>>>> +
>>>> +    if (rmi_delegate_page(dst_phys))
>>>> +        return -ENXIO;
>>>> +
>>>> +    ret = rmi_rtt_data_map_init(rd, dst_phys, ipa, src_phys, flags);
>>>> +    if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>>> +        /* Create missing RTTs and retry */
>>>> +        int level = RMI_RETURN_INDEX(ret);
>>>> +
>>>> +        KVM_BUG_ON(level == KVM_PGTABLE_LAST_LEVEL, kvm);
>>>
>>>          KVM_BUG_ON(level >= KVM_PGTABLE_LAST_LEVEL, kvm);
>>
>> Ack.
>>
> 
> Thinking more about this, I guess a buggy VMM can trigger this
> by populating twice ? (level == KVM_PGTABLE_LAST_LEVEL). So, we should
> return the error back, than warning here and suppressing the error ?

Populating twice causes rmi_delegate_page() to be run twice on the same
page and the second one will then fail. So I don't think this is
possible (please correct me if I've missed something!)

Thanks,
Steve
