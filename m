Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078320;
	b=5FffHfmNcFVzhQyHaPsjF0keQwrCtuZ88lGs0n/DpGUKmsAyujy+1xgEqySCgJf//D54
	 k4QoZ7l0leBYk7eE1zamXJF7wX2VjhWb1n9yqU4Bptmo2V70wHiKhOhHJjKj8Ko6LMx0D
	 Roju4mDdrCa7XPodN1SZ02Sosqs542WjlhtfNRANdd4kQ0T5jX5x77PZtYIkSquA4JDk6
	 BGpcFIuR/cOb/Ys28DHmOQNXjhmR4MFLzpVA2Z0Ci4Mi5ORBQ1tfJ4+y36bCrHy/tEHZK
	 l4P46Ho1kt30MFsotrkzI/4eTt5J4UuUWicU5MBcrV35IJnBALmABhSiVdi6xx2mMnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078320;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=qcrZquMGO9Oe3bvoYqFJ9rEHpqjyAmB4jkDBwjeQK8A=;
	b=sh0DS0+y9epHnDxeOUCiBTAtMo2SxbO2DoUSu7nth4sN063azXVQdZDdm4LdtGO1c2Q0
	 wNOwWEAxbnLtYbdn8U1jUrqgFWDFZcdYhOZTPVN+pO2XFVNpJvCIW/pybAPXcswb27JCm
	 TY4ZwlwPQ0Rm+C4Tc00anIAhLMzpDnzg2bcf61UfoTEtS/ZQVhd+p21WGn/0VNdNWKsBC
	 qI8GlKmxX/VMhn3gG7bMx0fv8d5eLLAxGvAotOEk0paqkRSsp5c2IslvEmxIGAOVkEKvq
	 TnX8ymbnVkQe10OIfBNyB1DZKclstekZZa8yQHO2PQOdEvD+PzwI9sXMo0fwEipQUow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ZCVd2VJ4;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70A7606A320
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 08:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E70A7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ZCVd2VJ4
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qcrZquMGO9Oe3bvoYqFJ9rEHpqjyAmB4jkDBwjeQK8A=;
	b=ZCVd2VJ4c728oydAQ/VNIBifPlROZo86otwPwWkYSWITlxFGEpSafATOyJFyGzch4sJGGiz4Z
	UbOMKymEDGckZ/tiEwDiMiTHdWhdRe6wWS8EUlv0IJO5DOIMHbHFDXC+yUbYHaGlEgQhCY20KHt
	aRFK5GvP/1pPPg52lAnbf70=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jVXJQ2lvYz1cyQ2;
	Thu, 19 Nov 2026 16:51:34 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id CF6504056C;
	Thu, 19 Nov 2026 16:51:54 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 16:51:53 +0800
Message-ID: <ce87daaa-4af4-4e9c-a09a-0532b9297b0b@huawei.com>
Date: Thu, 19 Nov 2026 16:51:54 +0800
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
 <90775cb3-84ab-4690-a252-1ac41488118f@huawei.com>
 <avMSw3LLDIFT3kSR@LeoBrasDK>
 <fee835a5-a027-4b68-b933-6f8e81987bce@huawei.com>
 <avXak02I6i0tLLN9@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <avXak02I6i0tLLN9@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/12/2026 11:26 PM, Leonardo Bras wrote:
> On Thu, Nov 12, 2026 at 09:15:02PM +0800, Tian Zheng wrote:
>>
>>
>> On 11/10/2026 8:49 PM, Leonardo Bras wrote:
>>> On Tue, Nov 10, 2026 at 04:54:30PM +0800, Tian Zheng wrote:
>>>>
>>>>
>>>> On 11/10/2026 2:18 AM, Leonardo Bras wrote:
>>>>> On Mon, Nov 09, 2026 at 12:00:52PM +0800, Tian Zheng wrote:
>>>>>>
>>>>>>
>>>>>> On 11/6/2026 11:36 PM, Leonardo Bras wrote:
>>>>>>> On Fri, Nov 06, 2026 at 06:36:04PM +0800, Tian Zheng wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 11/2/2026 10:54 PM, Leonardo Bras wrote:
>>>>>>>>> On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
>>>>>>>>>> The dirty ring reserves room for CPU-side dirty buffers via
>>>>>>>>>> kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
>>>>>>>>>> through it, so a full buffer flush always fits in the ring.
>>>>>>>>>>
>>>>>>>>>> Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
>>>>>>>>>> via kvm_arch_dirty_ring_size_updated(): a larger buffer only
>>>>>>>>>> shrinks the soft_limit and forces more frequent userspace drains.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>>>>>>>> ---
>>>>>>>>>>       arch/arm64/kvm/arm.c | 8 ++++++++
>>>>>>>>>>       arch/arm64/kvm/mmu.c | 8 ++++++++
>>>>>>>>>>       2 files changed, 16 insertions(+)
>>>>>>>>>>
>>>>>>>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>>>>>>>> index 9d7bdece149a..5a7046acb62e 100644
>>>>>>>>>> --- a/arch/arm64/kvm/arm.c
>>>>>>>>>> +++ b/arch/arm64/kvm/arm.c
>>>>>>>>>> @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
>>>>>>>>>>       	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>>>>>>>>>       }
>>>>>>>>>>
>>>>>>>>>> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
>>>>>>>>>> +{
>>>>>>>>>> +	if (!system_supports_hdbss())
>>>>>>>>>> +		return;
>>>>>>>>>> +
>>>>>>>>>> +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
>>>>>>>>>> +}
>>>>>>>>>> +
>>>>>>>>>
>>>>>>>>> On the same subject as a previous patch:
>>>>>>>>> I don't think this is the best approach, on top of adding a new weak
>>>>>>>>> function to take care.
>>>>>>>>>
>>>>>>>>> Maybe during the dirty-ring allocation, on vcpu creation, we could take
>>>>>>>>> into account the requested dirty-ring size, and just allocate the HDBSS
>>>>>>>>> buffer taking that into account. That would make it simpler, don't you
>>>>>>>>> agree?
>>>>>>>>>
>>>>>>>>> Thanks!
>>>>>>>>> Leo
>>>>>>>>
>>>>>>>> Hi Leo,
>>>>>>>>
>>>>>>>> The "set once" guard we're discussing comes from the patch that adds the
>>>>>>>> ioctl, and it isn't really needed. We discussed this earlier [1]: we can
>>>>>>>> just initialize hdbss_buffer_size to PAGE_SIZE at VM creation and let
>>>>>>>> the ring reservation use it directly. **That also means
>>>>>>>> kvm_arch_dirty_ring_size_updated() can be removed.** Thanks for your
>>>>>>>> suggestion.
>>>>>>>
>>>>>>> :)
>>>>>>>
>>>>>>>>
>>>>>>>> As for why PAGE_SIZE is the right value in ring mode: the HDBSS buffer
>>>>>>>> is flushed on every VM exit, so a larger buffer doesn't reduce the flush
>>>>>>>> frequency. It only inflates the ring reservation (64 + size/
>>>>>>>> sizeof(u64)), which shrinks the soft_limit and forces more frequent
>>>>>>>> exits to userspace for the ring to be drained. Draining the dirty ring
>>>>>>>> from QEMU is more expensive than draining the HDBSS buffer from the
>>>>>>>> kernel, so the smallest buffer gives the best performance. In this mode,
>>>>>>>> a larger buffer provides no benefit to users.
>>>>>>>
>>>>>>> Humm, if properly dimensioned larger buffers would be benefitial for
>>>>>>> memory-intensive workloads, unless they are guest_exiting for other
>>>>>>> reasons in the meantime.
>>>>>>>
>>>>>>
>>>>>> Agreed, and the workload I tested is on the "unless" side. The guest
>>>>>> exits constantly for other reasons, so the larger buffer never got a
>>>>>> chance to pay off, and only cost ring capacity.
>>>>>>
>>>>>>>>
>>>>>>>> In my tests, I also saw performance degrade when more space is reserved.
>>>>>>>>
>>>>>>>
>>>>>>> Humm, what kind of workloads did you test?
>>>>>>> Did you have the chance to monitor what were the reasons for VM exiting?
>>>>>>>
>>>>>>
>>>>>> For the workload question, it's a Redis server in the guest under redis-
>>>>>> benchmark (SET-only, 2KB values, 1M keys, 100M requests). The traffic is
>>>>>> network-driven, so the guest exits constantly to service requests. The
>>>>>> HDBSS buffer only accumulates entries between two exits and is flushed
>>>>>> on every exit, so it rarely fills regardless of size. A larger buffer
>>>>>> only inflated the ring reservation, which shrinks the soft_limit and
>>>>>> makes the ring-full exit and userspace drain fire more often.
>>>>>>
>>>>>>> I am not saying this is mandatory for the HDBSS implementation, but the
>>>>>>> whole idea of letting the user choose their own HDBSS buffer size is
>>>>>>> because different workloads may benefit from different buffer sizes: if a
>>>>>>> VM writes a lot to new memory, and exits very little for other reasons,
>>>>>>> then a larger buffer will cause the VM to guest_exit much less often.
>>>>>>>
>>>>>>> Does that make sense?
>>>>>>>
>>>>>>> Thanks!
>>>>>>> Leo
>>>>>>
>>>>>> It does make sense. That's exactly the workload where a larger buffer
>>>>>> pays off, and the next version no longer gets in its way. The two ioctls
>>>>>> are no longer mutually exclusive.
>>>>>>
>>>>>> The only coupling left is the reservation. hdbss_buffer_size starts at
>>>>>> SZ_4K at VM creation, so a ring enabled right away reserves for the
>>>>>> default buffer (64 + 512 entries), and the minimum ring size accepted is
>>>>>> unchanged from v5. KVM_CAP_ARM_HDBSS_BUFFER_SIZE is the gate. When the
>>>>>> ring is already enabled, a size is accepted only if its reservation
>>>>>> still fits in the ring, otherwise -EINVAL. In the other order, ring-
>>>>>> enable validation rejects a ring too small for the configured size.
>>>>>
>>>>> I don't think this is needed. If using dirtyring, we don't need to allow
>>>>> user to set hdbss size: HDBSS size should be sized according to the
>>>>> dirty-ring dimensions, that are set by userspace before the first vcpu is
>>>>> created.
>>>>>
>>>>>
>>>>>> So SZ_4K is just the conservative default for guests that exit often.
>>>>>> Anything larger, within what the ring can reserve, is up to the user.
>>>>>>
>>>>>> Does this work for you?
>>>>>
>>>>> I still think we should do PAGE_SIZE for dirty-bitmap. Dirty ring should do
>>>>> based on the dirty-ring size, and maybe review the use of reserved
>>>>> entries, or it's accounting.
>>>>>
>>>>> What do you think?
>>>>>
>>>>> Thanks!
>>>>> Leo
>>>>
>>>> Hi Leo,
>>>>
>>>> Thanks for your review. It does make sense!
>>>>
>>>> I agree that dirty-bitmap mode will keep PAGE_SIZE as the default, and
>>>> in that mode the ioctl stays available for a larger buffer.
>>>>
>>>> In ring mode we will drop the ioctl, the two remain mutually exclusive,
>>>> and the buffer will be derived from the ring size userspace configured
>>>> before the first vCPU is created:
>>>>
>>>> ```
>>>> hdbss_buffer = clamp_t(unsigned long,
>>>>                          rounddown_pow_of_two(ring_size / 16),
>>>>                          SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
>>>> ```
>>>>
>>>
>>> Are you allocating 1/16th of the ring size in bytes as an hdbss buffer?
>>> That's confusing. I recommend we rather have something like:
>>>
>>> ring_entries = ring_size / sizeof(struct kvm_dirty_gfn);
>>> hdbss_entries = ring_entries / 2; // Or any number we decide to use here.
>>> hdbss_buf_size = hdbss_entries * sizeof(hdbss_buf_entry);
>>>
>>> Then we do
>>> hdbss_buf_size = clamp_t(unsigned long,
>>>                            rounddown_pow_of_two(hdbss_buf_size),
>>>                            SZ_4K, KVM_ARM_HDBSS_MAX_SIZE);
>>>
>>> So it's clear what is what here.
>>> Just dividing by 16 above can be confusing to whoever is reading the code.
>>>
>>>
>>>> A buffer entry is 8 bytes and a ring entry is 16 bytes, so:
>>>>
>>>> ```
>>>> buffer entries = buffer_size / 8
>>>> ring entries   = ring_size / 16
>>>> ```
>>>
>>> Remember to use the sizeof instead of fixed numbers.
>>>
>>>>
>>>> This means ring_size / 16 reserves at most one eighth of the ring
>>>> entries for the HDBSS buffer. That keeps the usable ring above 85% while
>>>> the buffer still grows with the configured ring size, and the result is
>>>> independent of the kernel page size, with SZ_4K as the only minimum.
>>>
>>> Yeah, remember that if you are dealing with the ringbuffer like this, an
>>> user can request a 4k ringbuffer and we just won't be able to use hdbss, as
>>> it means 4k/16 entries, and hdbss has the minimum of 4k/8.
>>>
>>> As I mentioned, maybe this approach of reserved entries is not the right
>>> way of dealing with it in arm64.
>>>
>>>>
>>>> One eighth is the ratio that looks reasonable to me so far. What do you
>>>> think?
>>>>
>>>
>>> I see no reason why it could not be higher than that. It all depends on how
>>> you want to deal with the full buffer in the future patchset. If hdbss
>>> buffer is full, it has to exit and drain to the dirtyring. The guarantee
>>> you seek with reserved entries is that all hdbss entries fit in the
>>> dirty-ring.
>>>
>>> As long as the user is required to drain entries until the dirty-ring is
>>> not 'full' anymore, we could easily work with dirty-ring having twice as
>>> many entries as the hdbss buffer.
>>>
>>> How does it sound?
>>>
>>> Thanks!
>>> Leo
>>
>> Hi Leo,
>>
>> Thanks for the suggestion.
>>
>> For the next version I'll still go with the reservation scheme. It's the
>> safest approach I can think of. The guarantee I want is that a full
>> buffer flush always fits in the ring by construction, without depending
>> on how quickly userspace drains it.
> 
> Of course, it should never depend on how quickly userspace drains the ring.
> My point is that reserved entries is not the only option that satisfies
> that.
>   
>>
>> I'll also switch to sizeof(struct kvm_dirty_gfn) and
>> sizeof(hdbss_buf_entry) instead of the hardcoded 16 and 8, and size the
>> HDBSS buffer at half the ring entries as you suggested.
>>
>> On the 4K ring case: HDBSS can't fit there. One option is to just not
>> enable HDBSS in that scenario, but I'll start with returning -EINVAL for
>> now. I'm happy to switch to the other option if you think that's better.
>>
> 
> Return -EINVAL meaning what? userspace can't set the dirty-ring to 4k? that
> could break a lot of users.
> 
> Disabling HDBSS for that range could be the solution, but then we
> would have HDBSS being used for dirty-rings above some size, which could be
> kind of odd in the code, and possibly lead to trouble in the future.
> 
> That's one of the reasons I mentioned reserved entries may not be the best
> solution for us.
> 
> Thanks!
> Leo

Hi Leo,

I understand reserved entries aren't the only way to get that guarantee.
I looked at the alternatives I could think of and none of them seemed
clearly safer, so for the next version I'd like to stick with the
reservation and revisit if something better comes up.

On the 4K and 8K ring case, I agree rejecting the ring is not
acceptable. I'll go with not enabling HDBSS instead, so every ring size
upstream accepts keeps working. I share your concern about HDBSS being
conditionally enabled by ring size; for now it stays confined to the
kvm_supports_hdbss() check, and if it turns out to be a maintenance
problem we can revisit.

Thanks,
Tian
