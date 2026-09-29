Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DAA5172E8
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 11:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790681468; cv=none; b=G4U4yGm96zFV4QX/0beDHTGtL1cWr5sLSSg/KheoDQl/MLuxd2oJgUaCsPgEUKT06bKFc04EZB5JCJnYsg5ShP92GrFxVDm5s2RrxXOjpTMb8VDxE37kba+dc3mZNbAbT5zC39Wbai9KVrJuqKAGmsF6SNmUfHTC5ssIH2Zu6f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790681468; c=relaxed/simple;
	bh=wqs3vpKaDCWtWgprbaqXrOrXrz0kKNMOWmvho3fZQ3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mltsji7RN0lHTlNeKkr9CjKE2Glh/TVcRxzSn2pmHI3r5KMBsTInaSLwHb2xB73rk0E88+i6tmfCoGijL/zjWSM0V940n732OBppNOkuCYrnm/YF70MrWqDFUGa0IH1rw+jXFIj1la7IvWftYUURV5gcELMv/V5/hAn5twoZrB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=IS67ruVh; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="IS67ruVh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=i999MGH5SdNPcu4Q8VB0Q3AdAc6DTMs0HY0/qk7ot9g=;
	b=IS67ruVhdS/g2OwlEG9o0G9CqS+WcM/qqKiiXSqtCwqQ0In275KUqJnyy6fjdepPQnCc+cdiE
	EXSs8oNfsVBWwoCv7CrDKzK4diJNMtcNdqxQZ8m/uUaCQRv5yoC6O+fYDu8VbMT+mcjhwfo1eOc
	n8cXeuqeY5dDOZAdlOzHBC4=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hvG146RK8z1cyPY;
	Tue, 29 Sep 2026 19:19:52 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 05A164057C;
	Tue, 29 Sep 2026 19:30:59 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 29 Sep 2026 19:30:58 +0800
Message-ID: <3e23f91a-38d0-486a-b3f8-d94bd24d377f@huawei.com>
Date: Tue, 29 Sep 2026 19:30:58 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
To: Leonardo Bras <leo.bras@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-6-leo.bras@arm.com>
 <497c6239-a75f-4087-83c8-efface3fe3d7@huawei.com>
 <arE_Jh4UHiUdjrSi@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <arE_Jh4UHiUdjrSi@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/21/2026 10:28 PM, Leonardo Bras wrote:
> On Fri, Sep 18, 2026 at 07:58:43PM +0800, Tian Zheng wrote:
>>
>>
>> On 9/2/2026 1:15 AM, Leonardo Bras wrote:
>>> @@ -2570,53 +2571,76 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
>>>    out_destroy_pgtable:
>>>    	kvm_pgtable_hyp_destroy(hyp_pgtable);
>>>    out_free_pgtable:
>>>    	kfree(hyp_pgtable);
>>>    	hyp_pgtable = NULL;
>>>    out:
>>>    	return err;
>>>    }
>>> +static void kvm_set_hafdbs(struct kvm *kvm, bool set)
>>> +{
>>> +	/* Check if no action required */
>>> +	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) == set)
>>> +		return;
>>> +
>>> +	if (set)
>>> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
>>> +	else
>>> +		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
>>> +
>>> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
>>> +}
>>> +
>>
>> Hi Leo,
>>
>> HD alone is architecturally a no-op. According to the Arm spec, the
>> VTCR_EL2.HD field description reads: "When the Effective value of
>> VTCR_EL2.HA is 0, this field behaves as 0 for all purposes other than a
>> direct read of the value of this bit." So patch 5 as it stands never
>> actually enables stage-2 dirty management.
> 
> Oh, right, I missed that. :/
> 
> For the above to work it would need to have the HA bit:
> 
> +	if (set)
> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HA | VTCR_EL2_HD;
> +	else
> +		kvm->arch.mmu.vtcr &= ~(VTCR_EL2_HA |VTCR_EL2_HD);
> 

Hi Leo,

Yep, I've already fixed this in v5.

>>
>> In the combined series, I'm planning to replace both kvm_set_hafdbs()
>> and our earlier enable/disable hooks with a single derived mode:
>>
>> ```
>> /*
>>   *   logging && HDBSS-capable  ->  HDBSS  (HD|HA|HDBSS)
>>   *   logging, no HDBSS         ->  off
>>   *   !logging, HAFDBS-capable  ->  HAFDBS (HD|HA)
>>   */
> 
> Yes, seems correct, if the performance numbers can show patch 5 provides
> performance improvements.
> 

Right, I've added this function in patch 12 of the HDBSS v5 series.
Performance numbers look good so far.

>> void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
>> {
>> 	bool logging = atomic_read(&kvm->nr_memslots_dirty_logging) != 0;
>> 	unsigned long target;
>>
>> 	if (logging && kvm_supports_hdbss(kvm))
>> 		target = VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS;
>> 	else if (logging || !kvm_supports_hafdbs(kvm))
>> 		target = 0;
>> 	else
>> 		target = VTCR_EL2_HD | VTCR_EL2_HA;
>> 	...
>> }
>> ```
> 
> Humm, do we actually need the atomic_read being ran when we are enabling
> dirty_logging? Maybe we can restrain it only to the disabling part.
> 

True, but it's just a plain load. Keeping it unconditional avoids
tracking the transition direction, so I'd prefer to keep it. Looking
forward to your further review.

>>
>> HA is always set alongside HD by construction, so the no-op issue goes
>> away.
> 
> Right.
> 
>>
>> I'll fold this into the HDBSS v5 series when I send it out. Let me know
>> if you'd rather keep it in your v2 instead.
>>
> 
> Feel free to merge your part on top of that, I will work on collecting the
> numbers, though.
> 
> Thanks!
> Leo
> 

Sorry for the late reply. I was running HDBSS+DBM tests over the past
few days. The HDBSS v5 series with your DBM code merged is now sent out
to the community. Feedback welcome:

https://lore.kernel.org/all/20260929103655.85107-1-zhengtian10@huawei.com/

Thanks!
Tian

