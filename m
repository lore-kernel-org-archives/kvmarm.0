Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794300880;
	b=HwVw7JnIJiB4v1KeWIfvpnXgTVjdiXya2N/JMOW08EjkAMOnVQZXpt3Z0OSq7GZeUtAs
	 lF0hYvsbt91y8+5UgcT8MCALbBxYTbQLZqotC3SJVihTmHNB7k0EDaxyA+wbSB8Yk/y7a
	 V+/xTZiQyE+Ugc21eGOHAr1h58jFb9TqMzQ4YJGxIu/N1SocoV8kT8Dqmc++5ILugrRrX
	 9dt1105K98R70nu/u1ibdbBWdNtgFn/0EQaumTJJa3HQiE2BaLqb4tRs0L3EqwWykGbP2
	 kAIzas2RjHMQj6YBYk+mY5VZER79wze2aQ3GFbpQE9y886bUyPUsZ+cLnRW3XxoJU+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794300880;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=UzctcF3RMQ+98Eh9MsTnvbxr6SfXwpv8K4a5+Fko6XM=;
	b=fqtHg1K5tMvRRE9UcV0Z/yI6ub5YTePUE6lcom5OIGP899lTtHNbdPrLORpK+hdi4Sf/
	 bbSo6O8hmEK1YQFyGgg0+ilFBB44GDw3OZzIf0YeNNZ171ZHbKkNqlzoGCA4vqlzyW89y
	 MZE6Zd+4Uh3sh0ZvSn7BlCXDw1vOwTfUCAN5RRzBHhXX8JrzRKCuTT4Q6/BYzXj6/o4De
	 XjFoUI0itPeSZndCmVqDCaH78/SSp+7osLO+M7QnHXvRkJr6ufZFcVqHI0eT1C7iwb7zd
	 O32jAPAb8VKUwULkp/BvwJqjtBrzaIFiUlxiiPvmXyymJXtF1c1Z5Lm5xIBIZSU5LVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=IKzCvlF+;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EF3606A325
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 08:54:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4EF3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=IKzCvlF+
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UzctcF3RMQ+98Eh9MsTnvbxr6SfXwpv8K4a5+Fko6XM=;
	b=IKzCvlF+ykTmyRaBGt754Lvu0hmrcnRYx6wf48T3kREASWA5l0X4C0QzOmo7voJ/n9MB2pHy/
	5rMn/RDNQF8i7RZNyNg955atSJZYfXu+SSAVuJyawKp7O11CQmW5x/HiEPXwZ/QPzGT3XxAkVYI
	IxLLoOoZQ4D/bm5oeL3VRWs=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jP0nK0klfzpTK7;
	Tue, 10 Nov 2026 16:53:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id B766E40575;
	Tue, 10 Nov 2026 16:54:32 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 10 Nov 2026 16:54:31 +0800
Message-ID: <90775cb3-84ab-4690-a252-1ac41488118f@huawei.com>
Date: Tue, 10 Nov 2026 16:54:30 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the
 HDBSS buffer
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-12-zhengtian10@huawei.com> <auikG0clmr19sAjh@LeoBrasDK>
 <afcbf19b-bd13-4afc-ab56-8bc50c793e50@huawei.com>
 <au30DqzWIFny1tpr@LeoBrasDK>
 <d81243e3-d790-4ee8-9b28-36d35591ee77@huawei.com>
 <avIOZTvQF-1sxs2p@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <avIOZTvQF-1sxs2p@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/10/2026 2:18 AM, Leonardo Bras wrote:
> On Mon, Nov 09, 2026 at 12:00:52PM +0800, Tian Zheng wrote:
>>
>>
>> On 11/6/2026 11:36 PM, Leonardo Bras wrote:
>>> On Fri, Nov 06, 2026 at 06:36:04PM +0800, Tian Zheng wrote:
>>>>
>>>>
>>>> On 11/2/2026 10:54 PM, Leonardo Bras wrote:
>>>>> On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
>>>>>> The dirty ring reserves room for CPU-side dirty buffers via
>>>>>> kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
>>>>>> through it, so a full buffer flush always fits in the ring.
>>>>>>
>>>>>> Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
>>>>>> via kvm_arch_dirty_ring_size_updated(): a larger buffer only
>>>>>> shrinks the soft_limit and forces more frequent userspace drains.
>>>>>>
>>>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>>>> ---
>>>>>>     arch/arm64/kvm/arm.c | 8 ++++++++
>>>>>>     arch/arm64/kvm/mmu.c | 8 ++++++++
>>>>>>     2 files changed, 16 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>>>> index 9d7bdece149a..5a7046acb62e 100644
>>>>>> --- a/arch/arm64/kvm/arm.c
>>>>>> +++ b/arch/arm64/kvm/arm.c
>>>>>> @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
>>>>>>     	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>>>>>     }
>>>>>>
>>>>>> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
>>>>>> +{
>>>>>> +	if (!system_supports_hdbss())
>>>>>> +		return;
>>>>>> +
>>>>>> +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
>>>>>> +}
>>>>>> +
>>>>>
>>>>> On the same subject as a previous patch:
>>>>> I don't think this is the best approach, on top of adding a new weak
>>>>> function to take care.
>>>>>
>>>>> Maybe during the dirty-ring allocation, on vcpu creation, we could take
>>>>> into account the requested dirty-ring size, and just allocate the HDBSS
>>>>> buffer taking that into account. That would make it simpler, don't you
>>>>> agree?
>>>>>
>>>>> Thanks!
>>>>> Leo
>>>>
>>>> Hi Leo,
>>>>
>>>> The "set once" guard we're discussing comes from the patch that adds the
>>>> ioctl, and it isn't really needed. We discussed this earlier [1]: we can
>>>> just initialize hdbss_buffer_size to PAGE_SIZE at VM creation and let
>>>> the ring reservation use it directly. **That also means
>>>> kvm_arch_dirty_ring_size_updated() can be removed.** Thanks for your
>>>> suggestion.
>>>
>>> :)
>>>
>>>>
>>>> As for why PAGE_SIZE is the right value in ring mode: the HDBSS buffer
>>>> is flushed on every VM exit, so a larger buffer doesn't reduce the flush
>>>> frequency. It only inflates the ring reservation (64 + size/
>>>> sizeof(u64)), which shrinks the soft_limit and forces more frequent
>>>> exits to userspace for the ring to be drained. Draining the dirty ring
>>>> from QEMU is more expensive than draining the HDBSS buffer from the
>>>> kernel, so the smallest buffer gives the best performance. In this mode,
>>>> a larger buffer provides no benefit to users.
>>>
>>> Humm, if properly dimensioned larger buffers would be benefitial for
>>> memory-intensive workloads, unless they are guest_exiting for other
>>> reasons in the meantime.
>>>
>>
>> Agreed, and the workload I tested is on the "unless" side. The guest
>> exits constantly for other reasons, so the larger buffer never got a
>> chance to pay off, and only cost ring capacity.
>>
>>>>
>>>> In my tests, I also saw performance degrade when more space is reserved.
>>>>
>>>
>>> Humm, what kind of workloads did you test?
>>> Did you have the chance to monitor what were the reasons for VM exiting?
>>>
>>
>> For the workload question, it's a Redis server in the guest under redis-
>> benchmark (SET-only, 2KB values, 1M keys, 100M requests). The traffic is
>> network-driven, so the guest exits constantly to service requests. The
>> HDBSS buffer only accumulates entries between two exits and is flushed
>> on every exit, so it rarely fills regardless of size. A larger buffer
>> only inflated the ring reservation, which shrinks the soft_limit and
>> makes the ring-full exit and userspace drain fire more often.
>>
>>> I am not saying this is mandatory for the HDBSS implementation, but the
>>> whole idea of letting the user choose their own HDBSS buffer size is
>>> because different workloads may benefit from different buffer sizes: if a
>>> VM writes a lot to new memory, and exits very little for other reasons,
>>> then a larger buffer will cause the VM to guest_exit much less often.
>>>
>>> Does that make sense?
>>>
>>> Thanks!
>>> Leo
>>
>> It does make sense. That's exactly the workload where a larger buffer
>> pays off, and the next version no longer gets in its way. The two ioctls
>> are no longer mutually exclusive.
>>
>> The only coupling left is the reservation. hdbss_buffer_size starts at
>> SZ_4K at VM creation, so a ring enabled right away reserves for the
>> default buffer (64 + 512 entries), and the minimum ring size accepted is
>> unchanged from v5. KVM_CAP_ARM_HDBSS_BUFFER_SIZE is the gate. When the
>> ring is already enabled, a size is accepted only if its reservation
>> still fits in the ring, otherwise -EINVAL. In the other order, ring-
>> enable validation rejects a ring too small for the configured size.
> 
> I don't think this is needed. If using dirtyring, we don't need to allow
> user to set hdbss size: HDBSS size should be sized according to the
> dirty-ring dimensions, that are set by userspace before the first vcpu is
> created.
> 
> 
>> So SZ_4K is just the conservative default for guests that exit often.
>> Anything larger, within what the ring can reserve, is up to the user.
>>
>> Does this work for you?
> 
> I still think we should do PAGE_SIZE for dirty-bitmap. Dirty ring should do
> based on the dirty-ring size, and maybe review the use of reserved
> entries, or it's accounting.
> 
> What do you think?
> 
> Thanks!
> Leo

Hi Leo,

Thanks for your review. It does make sense!

I agree that dirty-bitmap mode will keep PAGE_SIZE as the default, and
in that mode the ioctl stays available for a larger buffer.

In ring mode we will drop the ioctl, the two remain mutually exclusive,
and the buffer will be derived from the ring size userspace configured
before the first vCPU is created:

```
hdbss_buffer = clamp_t(unsigned long,
                        rounddown_pow_of_two(ring_size / 16),
                        SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
```

A buffer entry is 8 bytes and a ring entry is 16 bytes, so:

```
buffer entries = buffer_size / 8
ring entries   = ring_size / 16
```

This means ring_size / 16 reserves at most one eighth of the ring
entries for the HDBSS buffer. That keeps the usable ring above 85% while
the buffer still grows with the configured ring size, and the result is
independent of the kernel page size, with SZ_4K as the only minimum.

One eighth is the ratio that looks reasonable to me so far. What do you
think?

Thanks,
Tian
