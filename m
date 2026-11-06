Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955740;
	b=22h6gZFwMjwJPnDDKNsVrtG+HiMSm5tMnPdadZaU8mzA3JNvrKIEmpHBzUcvrD6oqDeb
	 YRKoLASo7i39oQVUtRsDvoaex/hrBV7PjjnaCgYK+/bsuycPSbp5Nve8AtCho2vQHNGAc
	 OeVh1ASXMff40waVBlG0bOO1Kz9K2f5XpNikjuiZhRwaXWhOb3qlOwHrp1HAjGKnt9+7H
	 ha9nAjeIIJ6fdIKD/Cc8SrIDwUdMQGcPYbObFYDtO4RlXPzAsu6wGqSP1dDSH+YjXOj4D
	 enBuupCOnFeOlu6d2p6L6y0HjQXZMsaNI45MGfUlPIP1OuHOf7tIm7a5rdlS39I7UdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955740;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=IZO9hHewpI1vF88rTpwvcS4eIwOhB3E4KR10OH18Zcs=;
	b=0W2gQXw6z/dWqripaYPmrpRmzKKEqbOPSlKU7RU3/cyLY1rhmvlu1RuvOG6OfoZuW5Ie
	 0fLCfz1San62uSbGomEGoEtxA9RVS6QS8OVZLRd94JoTg8eIDC4duVSUKunu8Cp9ldRWD
	 C3AQNCeNZWXSYdpGV8jBpAjh2qKt+m3+FQeXAAtFyRSWkTs7sJSH6qmfJNwOJc9f0hvbl
	 Rrn/3DztmGBKCnpRcz7KsVZyzw1mgeOz34B2flxe7NOQM2VwrG55ZZg4Q+Ugx4jf7QhNF
	 biuvFtPGWy9ts+1WRQ4trMa5CmtcK8rJq/nX0RbbzcH0QeAyXz/8vkhYSeWmIGJPM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hjRU7vzd;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E519606A328
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 09:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E519606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hjRU7vzd
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IZO9hHewpI1vF88rTpwvcS4eIwOhB3E4KR10OH18Zcs=;
	b=hjRU7vzdg/I2Nu9I0mN5sdbYT0kFey2K901ZDMBOjEImYw2ZNl0YCPz2n08l6gN5gzgjTEDT3
	UiWdRSGdcbRhhJ9fuEMPeptb2aUqQ3ozspnVmQbHxAY4Ba+SCZepn1a1YX+RspQ6suiHa9Yi8uf
	CMPGrMQwBtz8FudL0/tAjF4=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jLY843ZlNzcb3y;
	Fri,  6 Nov 2026 17:01:40 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id D977A40561;
	Fri,  6 Nov 2026 17:02:10 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 17:02:09 +0800
Message-ID: <75b0ebcb-023a-4889-98b1-bf1d8b6327dd@huawei.com>
Date: Fri, 6 Nov 2026 17:02:09 +0800
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
Subject: Re: [PATCH v5 08/15] KVM: arm64: Flush the HDBSS buffer on VM exit
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
 <20260929103655.85107-9-zhengtian10@huawei.com> <auDpyRNpeDNzIk3W@LeoBrasDK>
 <5bbd0d3b-1026-43f3-bc45-245472603144@huawei.com>
 <auTLOIafIq4cjRho@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auTLOIafIq4cjRho@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/31/2026 12:52 AM, Leonardo Bras wrote:
> On Fri, Oct 30, 2026 at 12:57:06PM +0800, Tian Zheng wrote:
>>
>>
>> On 10/28/2026 2:13 AM, Leonardo Bras wrote:
>>> On Tue, Sep 29, 2026 at 06:36:48PM +0800, Tian Zheng wrote:
>>>> From: Eillon <yezhenyu2@huawei.com>
>>>>
>>>> HDBSS entries accumulate in the per-vCPU buffer while the guest runs,
>>>> and must be drained into the dirty bitmap or dirty ring before
>>>> userspace can observe them.
>>>>
>>>> Drain the buffer at a single point: kvm_arch_vcpu_ioctl_run() flushes
>>>> it on every VM exit, before the exit reason is handled. Flushing
>>>> inside the run loop keeps the dirty-ring feedback timely: when a flush
>>>> pushes the ring past its soft limit, kvm_dirty_ring_push() raises
>>>> KVM_REQ_DIRTY_RING_SOFT_FULL, which check_vcpu_requests() observes at
>>>> the top of the next loop iteration, so the vCPU exits to userspace for
>>>> the harvest before re-entering the guest.
>>>>
>>>> kvm_arch_sync_dirty_log() relies on the exit path to flush: it kicks
>>>> vCPUs out of guest mode, and the GET/CLEAR protocol tolerates
>>>> concurrent bitmap writes, so the snapshot is complete without extra
>>>> synchronization.
>>>>
>>>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>> ---
>>>>    arch/arm64/include/asm/kvm_dirty_bit.h | 15 +++++++++
>>>>    arch/arm64/kvm/arm.c                   | 20 ++++++++++++
>>>>    arch/arm64/kvm/dirty_bit.c             | 45 ++++++++++++++++++++++++++
>>>>    3 files changed, 80 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
>>>> index fe703f02626b..d828e6b43fe9 100644
>>>> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
>>>> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
>>>> @@ -13,6 +13,9 @@
>>>>    #include <asm/sysreg.h>
>>>>    #include <linux/sizes.h>
>>>>
>>>> +#define HDBSS_ENTRY_VALID	BIT(0)
>>>> +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
>>>> +
>>>>    #define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
>>>>    #define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
>>>>
>>>> @@ -22,7 +25,19 @@ static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
>>>>    	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
>>>>    }
>>>>
>>>> +static inline bool kvm_hdbss_enabled(struct kvm *kvm)
>>>> +{
>>>> +	return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
>>>> +}
>>>> +
>>>> +static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	return vcpu->arch.hw_mmu &&
>>>> +		(vcpu->arch.hw_mmu->vtcr & VTCR_EL2_HDBSS);
>>>> +}
>>>> +
>>>
>>> IIUC, arch.mmu is always the canonical s2_mmu, while hw_mmu can be the
>>> nested s2_mmu, if enabled.
>>>
>>> Was that your intend here?
>>> If not, we could use only kvm* version, which can be called with vcpu->kvm.
>>>
>>> If it was, then I would like to understand the logic here, as IIUC the
>>> buffer is accessible only for the non-nested guest, as it's
>>> allocated in a per-vcpu structure. (vcpu->arch)
>>>
>>
>> Hi leo,
>>
>> Yes, that was the intent. The shadow MMU never carries VTCR_EL2.HDBSS,
>> so the flush is naturally skipped when running nested.
> 
> Ah, right. If we always test the kvm one, we may enable it for the nested
> guest, which is undesired.
> 
> [...]
>>
>>>
>>>> @@ -2017,7 +2025,19 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
>>>>
>>>>    void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>>>>    {
>>>> +	unsigned long i;
>>>> +	struct kvm_vcpu *vcpu;
>>>>
>>>> +	if (!kvm_hdbss_enabled(kvm))
>>>> +		return;
>>>> +
> 
> And then here you check for the L1 VM because during migration the host
> could have dirtied memory, and you want to track that as well.
> 
> Makes sense
> 
>>>> +	/*
>>>> +	 * The buffer is drained on every VM exit, so kicking running
>>>> +	 * vCPUs is enough to flush them; the dirty-log GET/CLEAR
>>>> +	 * protocol tolerates bits set concurrently with the snapshot.
>>>> +	 */
>>>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>>>> +		kvm_vcpu_kick(vcpu);
>>>>    }
>>>>
>>>>    static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>>>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>>>> index f9aeb9f34ad0..be0d12555c84 100644
>>>> --- a/arch/arm64/kvm/dirty_bit.c
>>>> +++ b/arch/arm64/kvm/dirty_bit.c
>>>> @@ -13,6 +13,7 @@
>>>>    #include <linux/kconfig.h>
>>>>    #include <linux/log2.h>
>>>>    #include <linux/mm.h>
>>>> +#include <linux/srcu.h>
>>>>
>>>
>>> Out of curiosity, could you please explain you reasoning on selecting srcu
>>> as locking here?
>>>
>>> (Like, what are you protecting against, and why srcu is a good choice)
>>>
>>
>> kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU
>> (kvm_vcpu_gfn_to_memslot), and the flush loop calls it for each entry,
>> so the whole loop needs the read lock held.
> 
> Oh, right, it's just about getting the memslot... now I see it :)
> 
> Thanks!
> Leo

Awesome!

