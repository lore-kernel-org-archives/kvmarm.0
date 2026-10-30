Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336233;
	b=LcqFJjzmQNvb5tL6Bhj957frKbsWktvaHn/Qt/u+W4ZEL5qVn/PHViPYoAh8wjTAqS7a
	 Ou+YIyeMlOUaLa5/uw44c7ZLRoKXAo/yH3UznOe3I27dHpBN8dQP4WwNey/i6r2L+WLWZ
	 5m7oW7DZNpi9s7CSGamgXGXdNNo24UXIj6gDmeOYSHLU+5RrEuFnMCokjBAn0EYvL1ZAX
	 3uTzAHnXuxNhVd8fTO0yTfJSleTkl/nFWhsif9WSfk25v+AndvvMZbkcMGogiSVDc+ZZq
	 vZ5s4mZ60O26cWquN1SWDvlp9EbJejWC6HovXLOt8BvMMJFq4wIO6OtIZvV+LfkJAuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336233;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=LkSAHBtoPgrkAY7QvIyWogTu4sDPqd80TrYA0xZEnEk=;
	b=PBOEOphgSsSwFar9UFi15CpmlQgehOp3rNeBX0E2Tsd0k7KcJmsTzOM8zLi/bX5sguWv
	 tceHU6GIoqi8uCS1sAi8dmyBppzL6x2PSGJDN3aDXreNxCX/zjB23u3gGlQb/Byp7l2z/
	 YX5DTYLVGGqplLTWHeNhpr6vt4LmKbkvylwgXnRsiQG0VdWC21BWbwy/dTKSiRPs7n3fB
	 swd5XNRq0ALgSZy6FYUltcS6hAVAmzKt5G84vFBcmk8gjzDfAHjkXOqx2pATGEg1lp2Gy
	 dFbGz/lvDvMmSmospSzxx2P07S3szG9tP4sbUduIoJBlXrWsnc+qgkPOswLJH3IWhMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=dlXIONyU;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E61606A31A
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 04:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09E61606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=dlXIONyU
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LkSAHBtoPgrkAY7QvIyWogTu4sDPqd80TrYA0xZEnEk=;
	b=dlXIONyUPuQhZmuhCVJ9Kxz1cWOkRyM210Hdd3g7CpRzTkcjoW5dcIT/e1AqdzHD3yxjPUBGt
	Kg8d91FT+/NcevLnn1rbWOV1WdTucGPMfWiKtOzXUsxtufmrvYHEX7AYgpa/mxbe4KxKSlvkh9H
	+8bUTXdstDRfB7W/SMYTv44=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jG82p6qyjzcZyh;
	Fri, 30 Oct 2026 12:56:50 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 24DA740579;
	Fri, 30 Oct 2026 12:57:08 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 30 Oct 2026 12:57:06 +0800
Message-ID: <5bbd0d3b-1026-43f3-bc45-245472603144@huawei.com>
Date: Fri, 30 Oct 2026 12:57:06 +0800
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
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auDpyRNpeDNzIk3W@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 10/28/2026 2:13 AM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:48PM +0800, Tian Zheng wrote:
>> From: Eillon <yezhenyu2@huawei.com>
>>
>> HDBSS entries accumulate in the per-vCPU buffer while the guest runs,
>> and must be drained into the dirty bitmap or dirty ring before
>> userspace can observe them.
>>
>> Drain the buffer at a single point: kvm_arch_vcpu_ioctl_run() flushes
>> it on every VM exit, before the exit reason is handled. Flushing
>> inside the run loop keeps the dirty-ring feedback timely: when a flush
>> pushes the ring past its soft limit, kvm_dirty_ring_push() raises
>> KVM_REQ_DIRTY_RING_SOFT_FULL, which check_vcpu_requests() observes at
>> the top of the next loop iteration, so the vCPU exits to userspace for
>> the harvest before re-entering the guest.
>>
>> kvm_arch_sync_dirty_log() relies on the exit path to flush: it kicks
>> vCPUs out of guest mode, and the GET/CLEAR protocol tolerates
>> concurrent bitmap writes, so the snapshot is complete without extra
>> synchronization.
>>
>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_dirty_bit.h | 15 +++++++++
>>   arch/arm64/kvm/arm.c                   | 20 ++++++++++++
>>   arch/arm64/kvm/dirty_bit.c             | 45 ++++++++++++++++++++++++++
>>   3 files changed, 80 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
>> index fe703f02626b..d828e6b43fe9 100644
>> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
>> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
>> @@ -13,6 +13,9 @@
>>   #include <asm/sysreg.h>
>>   #include <linux/sizes.h>
>>
>> +#define HDBSS_ENTRY_VALID	BIT(0)
>> +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
>> +
>>   #define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
>>   #define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
>>
>> @@ -22,7 +25,19 @@ static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
>>   	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
>>   }
>>
>> +static inline bool kvm_hdbss_enabled(struct kvm *kvm)
>> +{
>> +	return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
>> +}
>> +
>> +static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
>> +{
>> +	return vcpu->arch.hw_mmu &&
>> +		(vcpu->arch.hw_mmu->vtcr & VTCR_EL2_HDBSS);
>> +}
>> +
> 
> IIUC, arch.mmu is always the canonical s2_mmu, while hw_mmu can be the
> nested s2_mmu, if enabled.
> 
> Was that your intend here?
> If not, we could use only kvm* version, which can be called with vcpu->kvm.
> 
> If it was, then I would like to understand the logic here, as IIUC the
> buffer is accessible only for the non-nested guest, as it's
> allocated in a per-vcpu structure. (vcpu->arch)
> 

Hi leo,

Yes, that was the intent. The shadow MMU never carries VTCR_EL2.HDBSS,
so the flush is naturally skipped when running nested.

>>   int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
>>   void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
>>
>>   #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 5ea4ac26995e..9d7bdece149a 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1430,6 +1430,14 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>
>>   		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
>>
>> +		/*
>> +		 * Drain the HDBSS buffer before the exit is handled, so
>> +		 * entries pushed to the dirty ring are accounted for by
>> +		 * dirty_ring_check_request() on the next iteration.
>> +		 */
>> +		if (vcpu_hdbss_enabled(vcpu))
>> +			kvm_flush_hdbss_buffer(vcpu);
>> +
>>   		/* Exit types that need handling before we can be preempted */
>>   		handle_exit_early(vcpu, ret);
>>
> 
> 
> looks the correct place, haven't looked too much on that, though.
> 

Thanks!

> 
>> @@ -2017,7 +2025,19 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
>>
>>   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>>   {
>> +	unsigned long i;
>> +	struct kvm_vcpu *vcpu;
>>
>> +	if (!kvm_hdbss_enabled(kvm))
>> +		return;
>> +
>> +	/*
>> +	 * The buffer is drained on every VM exit, so kicking running
>> +	 * vCPUs is enough to flush them; the dirty-log GET/CLEAR
>> +	 * protocol tolerates bits set concurrently with the snapshot.
>> +	 */
>> +	kvm_for_each_vcpu(i, vcpu, kvm)
>> +		kvm_vcpu_kick(vcpu);
>>   }
>>
>>   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> index f9aeb9f34ad0..be0d12555c84 100644
>> --- a/arch/arm64/kvm/dirty_bit.c
>> +++ b/arch/arm64/kvm/dirty_bit.c
>> @@ -13,6 +13,7 @@
>>   #include <linux/kconfig.h>
>>   #include <linux/log2.h>
>>   #include <linux/mm.h>
>> +#include <linux/srcu.h>
>>
> 
> Out of curiosity, could you please explain you reasoning on selecting srcu
> as locking here?
> 
> (Like, what are you protecting against, and why srcu is a good choice)
> 

kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU
(kvm_vcpu_gfn_to_memslot), and the flush loop calls it for each entry,
so the whole loop needs the read lock held.

>>   int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu)
>>   {
>> @@ -53,3 +54,47 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>>   	vcpu->arch.hdbss.hdbss_pg = NULL;
>>   	vcpu->arch.hdbss.hdbssbr_el2 = 0;
>>   }
>> +
>> +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
>> +{
>> +	int idx, curr_idx;
>> +	u64 prod;
>> +	u32 entries;
>> +	u64 *hdbss_buf;
>> +	struct kvm *kvm = vcpu->kvm;
>> +	int srcu_idx;
>> +
>> +	if (!vcpu_hdbss_enabled(vcpu))
>> +		return;
> 
> You test this before calling, is it really necessary to test it again, just
> after calling?
> 

You're right, I've removed it.

Thanks,
Tian

>> +
>> +	prod = read_sysreg_s(SYS_HDBSSPROD_EL2);
>> +	curr_idx = HDBSSPROD_IDX(prod);
>> +
>> +	if (curr_idx == 0 || !vcpu->arch.hdbss.hdbss_pg)
>> +		return;
>> +
>> +	hdbss_buf = page_address(vcpu->arch.hdbss.hdbss_pg);
>> +	if (!hdbss_buf)
>> +		return;
>> +
>> +	entries = kvm_hdbss_buffer_size(kvm) / sizeof(u64);
>> +
>> +	/* kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU. */
>> +	srcu_idx = srcu_read_lock(&kvm->srcu);
>> +	for (idx = 0; idx < min_t(u32, curr_idx, entries); idx++) {
>> +		u64 gpa;
>> +
>> +		gpa = hdbss_buf[idx];
>> +		if (!(gpa & HDBSS_ENTRY_VALID))
>> +			continue;
>> +
>> +		gpa &= HDBSS_ENTRY_IPA;
>> +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
>> +	}
>> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
>> +
>> +	prod &= ~HDBSSPROD_EL2_INDEX_MASK;
>> +	write_sysreg_s(prod, SYS_HDBSSPROD_EL2);
>> +	vcpu->arch.hdbss.hdbssprod_el2 = prod;
>> +	isb();
>> +}
>> --
>> 2.43.0
>>
> 
> 
> Thanks!
> Leo

