Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBB2F2F
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 01:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718934204; cv=none; b=snJyBwMGJP7gfTI5hA6vyoz0LiDeFLQSnDxzmZSmt5o3qVxTRPyn7DMXA97+V8gUCIlunORg5YesxBCzh0DqzI28TWjOSs5arMExqUwXD8tzuAXtUwWhWWgvJhfgcGbk+ZL/1rjSnpQEeY1BWpxen56OB5iAMSTG3af3vUy6bb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718934204; c=relaxed/simple;
	bh=Yso09YocFp/iEQxeYoRtqU3nRj8rx+0usyGBg8Yuleo=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=U/mDQpyV2YPwMet7wgYvgzQKnwt5n8I1NJfk1ORTNX+dqyDGkz89aY8TLb7zToK+9GU7UZIraGO8m63SBf5sLcnoyKR3xCdeMBvLHtTmMgHKnP+5DRfBBGaQNnOgZDdhjcQiy5FX4Ov5/MWvWMj3b4HiEDDP0vSUSWZey2gk3y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W50Q01jSNzxRwb;
	Fri, 21 Jun 2024 09:39:04 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 21A1F18001C;
	Fri, 21 Jun 2024 09:43:18 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 21 Jun 2024 09:43:16 +0800
Subject: Re: [PATCH 1/3] KVM: arm64: vgic-its: Add a data length check in
 vgic_its_save_*
To: Oliver Upton <oliver.upton@linux.dev>
CC: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Randy
 Dunlap <rdunlap@infradead.org>, Eric Auger <eauger@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <lishusen2@huawei.com>
References: <20240620130650.1279-1-jiangkunkun@huawei.com>
 <20240620130650.1279-2-jiangkunkun@huawei.com> <ZnSsPmfBXMGRYPmL@linux.dev>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <50f18621-96a4-cf6e-9fc0-a4e69f77054c@huawei.com>
Date: Fri, 21 Jun 2024 09:43:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZnSsPmfBXMGRYPmL@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Oliver,

On 2024/6/21 6:25, Oliver Upton wrote:
> Hi,
>
> On Thu, Jun 20, 2024 at 09:06:48PM +0800, Kunkun Jiang wrote:
>> In all the vgic_its_save_*() functinos, it does not check
>> whether the data length is larger than 8 bytes before
>> calling vgic_write_guest_lock. This patch add the check.
>>
>> Link: https://lore.kernel.org/kvmarm/86v82ckimh.wl-maz@kernel.org/
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   arch/arm64/kvm/vgic/vgic-its.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 40bb43f20bf3..060605fba3b6 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -2094,6 +2094,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>>   	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>>   		ite->collection->collection_id;
>>   	val = cpu_to_le64(val);
>> +	BUG_ON(ite_esz > sizeof(val));
> Does it really make sense to blow up the kernel over this? (hint: no)
>
> What _might_ make sense if if you bugged the VM and failed the ioctl,
> i.e.
>
> 	if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
> 		return -EINVAL;
>
> Also, this isn't even asserting the right thing. You want to assert that
> the u64 being written to memory is *exactly* the size of a single ITE.
> No more, no less.
This makes sense. I will modify it in the next version.

> static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
> {
>         struct its_collection *collection;
>         struct kvm *kvm = its->dev->kvm;
>         u32 target_addr, coll_id;
>         u64 val;
>         int ret;
>
>         BUG_ON(esz > sizeof(val));
>         ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
It should also be modified synchronously, right?
>>   	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
>>   }
>>   
>> @@ -2246,6 +2247,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
>>   	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
>>   		(dev->num_eventid_bits - 1));
>>   	val = cpu_to_le64(val);
>> +	BUG_ON(dte_esz > sizeof(dte_esz));
> Did you even test this? A bit of substitution arrives at:
>
> 	BUG_ON(8 > sizeof(unsigned int));
>
> See the issue?
>
> Please do not test these sort of untested patches on the list, it is a
> waste of everyone's time.
Sorry, there is a problem here. I will pay attention to it in the future.
Thank you for your correction.

Thanks,
Kunkun Jiang
