Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB79B1E49E
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 13:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718889505; cv=none; b=o0foeYsGirn5ItMl5XWd46JApeR+gbK46q6pbIOmrJNNGqpcnO0tRoV7RlnywHQ/bYeurn/3i0ZlzmlvoosNwJJfs6ml8iEYYvAfY9MRWX8k6BFVkTXBtNZpDh5djb1ZGfbNyVP2OoAWpGKgy0cTTOdiEJX7H2cfmfCcaqbAtq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718889505; c=relaxed/simple;
	bh=MmfkCHH6aveXbJZTyXbt/djjYBat06YU0apaENdGPNk=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=STefG5hGKIo/VYqMlPhgAABpR9hn3wC0S4qwA3oNRbA+JqqoWEOruY5IylrlGELmVakDnu2KoHnxT/KW+aPbj/u+3S7No9DvRuyp75EpW9fa/UoSQdXt8MZ7ed8UhgsVBKT//gwqFGa41xObVuVAluDCEur5mGqJOTjBsKdDqIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W4gtM6wRRzwRqZ;
	Thu, 20 Jun 2024 21:14:03 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F8FE1800DD;
	Thu, 20 Jun 2024 21:18:20 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 21:18:19 +0800
Subject: Re: [PATCH] KVM: arm64: vgic-its: clear dte when mapd unmaps a device
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>,
	<lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>
References: <20240613093811.710-1-jiangkunkun@huawei.com>
 <86v82ckimh.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <98e8cd74-621f-a445-4c43-e6948e6c79d9@huawei.com>
Date: Thu, 20 Jun 2024 21:18:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86v82ckimh.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc，

Thank you very much for reviewing.

On 2024/6/13 22:44, Marc Zyngier wrote:
> On Thu, 13 Jun 2024 10:38:11 +0100,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> vgic_its_save_device_tables will traverse its->device_list to
>> save dte for each device. vgic_its_restore_device_tables will
>> traverse each entry of device table and check if it is valid.
>> Restore if valid.
>>
>> But when mapd unmaps a devices, we do not invalidate the
>> corresponding dte. In the scenario of continuous save
>> and restore, there may be a situation where a device's dte
>> is not saved but is restored. This is unreasonable and may
>> cause restore to fail. This patch clears the corresponding
>> dte when mapd unmaps a device.
>>
>> Singed-off-by: Shusen Li <lishusen2@huawei.com>
>    ^^^^^^^^^^^^^ This isn't a valid tag!
>
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
> Something is wrong. Either Shusen Li is the author and you are merely
> posting it, in which case there should be a 'From' line in the commit
> message, or you are co-authors and there should be a 'Co-developed-by'
> right after Shusen Li's SoB.
>
> Please read Documentation/process/submitting-patches.rst for the
> details.
The latest patch has been modified. See link below.
>> ---
>>   arch/arm64/kvm/vgic/vgic-its.c | 13 +++++++++++--
>>   1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 40bb43f20bf3..dd5fba1e8ba3 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -1140,8 +1140,12 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>   	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
>>   	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
>>   	struct its_device *device;
>> +	gpa_t gpa;
>> +	const struct vgic_its_abi *abi;
>> +	int dte_esz;
>> +	u64 val;
> Aside from 'gpa', all the extra variables should be moved into the
> !valid block. And it would be nicer if this variable was called
> something more descriptive.
>
>>   
>> -	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
>> +	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
>>   		return E_ITS_MAPD_DEVICE_OOR;
>>   
>>   	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
>> @@ -1161,8 +1165,13 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>>   	 * The spec does not say whether unmapping a not-mapped device
>>   	 * is an error, so we are done in any case.
>>   	 */
>> -	if (!valid)
>> +	if (!valid) {
>> +		abi = vgic_its_get_abi(its);
>> +		dte_esz = abi->dte_esz;
>> +		val = cpu_to_le64(0);
>> +		vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
> This is just a bit wrong:
>
> - you store 0 in a u64 after having (pointlessly) converted it to le64
>
> - you write 'dte_esz' bytes into guest memory, but you don't have any
>    check whether this is *larger* than the u64 you have passed
The latest patch has been modified. See link below.
> Similar issue exists in all the vgic_its_save_*() functions, calling
> for a generic fix, as we're just lucky to never have needed a new ABI
> so far. At the very least a check that we deal with data that is
> exactly 8 bytes.
A patch has been added to check it.
Link: 
https://lore.kernel.org/kvmarm/20240620130650.1279-1-jiangkunkun@huawei.com/

Thanks,
Kunkun Jiang
