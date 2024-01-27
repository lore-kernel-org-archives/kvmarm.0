Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10DA11702
	for <kvmarm@lists.linux.dev>; Sat, 27 Jan 2024 02:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706324360; cv=none; b=AY0JyljWMZn3RaJS+fbi3X3yb8FWne2tZXDyWlqbQtc4URkahdLfNhZsSaHRbdXA+H2qk2Fqcy26TfNlZfikhqyn5+/4QRFyhzEm4D503M5dD6XlqtKepty2XWXeKhNLxTd8T7cuV+ULgnGAZ+msasVdJZJGsRRV7kho34JJhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706324360; c=relaxed/simple;
	bh=Hp0CYqoo5qTLY3dJfk3gzdYjEnX11hpy6Y1cPwy8pok=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=luWbrhbpsTwj+WnZOVA8T8kb3b1T900gJ9Hivz5UjkVy2vyj+eSExHfa9JGN+6uCEIbMT5q25tl8/d3NDHuDPxJp9HHys94dYeXgl7WfvSltk0peiwMnofvMK5ybIpgmAfOW9jLeB7Qc1s0w6+C6cT0BARuaXMM1U4gD93a3IiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TMK4c6v7kz18MJ2;
	Sat, 27 Jan 2024 10:58:08 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 2512A1404FC;
	Sat, 27 Jan 2024 10:59:15 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Jan 2024 10:59:14 +0800
Subject: Re: [PATCH v2 2/2] irqchip/gic-v4.1: Fix skipping VMOVP in cpu
 offline scenario
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>
References: <20240126103012.1020-1-jiangkunkun@huawei.com>
 <20240126103012.1020-3-jiangkunkun@huawei.com> <86sf2k74dy.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <58a27892-d2c4-886e-905a-9b991c1c7941@huawei.com>
Date: Sat, 27 Jan 2024 10:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86sf2k74dy.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/1/26 18:52, Marc Zyngier wrote:
> On Fri, 26 Jan 2024 10:30:12 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> commit dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour
>> of VMOVP") make an optimization, VMOVP can be skipped if moving
>> VPE to a cpu whose RD is sharing its VPE table with the current one.
>>
>> In the cpu offline scenario, the mask_val is the entire cpu range,
>> except for the offline cpu. Therefore, the first cpu is CPU0. In
>> corner case, this may result in lost interrupts:
>> 0. Each cpu die shares a VPE table and contains 32 CPUs
>>     die0(CPU0-31) die1(CPU32-63)...
>> 1. VPE resides on CPU32, doorbell affinity to CPU32.
>> 2. Move VPE to CPU16, doorbell affinity to CPU16.
>> 3. Manually offline CPU16 on the host side:
>>     'echo 0 > /sys/devices/system/cpu/cpu16/online'
>> 4. VMOVP will be skipped.
>> 5. Subsequent doorbell interrupts will be lost.
>>
>> So VMOVP cannot be skipped when the affinity CPU is not in mask_val.
>>
>> Fixes: dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP")
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 4b1dbb697959..bfb922f16bc6 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3817,7 +3817,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>   				bool force)
>>   {
>>   	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> -	int from, cpu = cpumask_first(mask_val);
>> +	int cur, from, cpu = cpumask_first(mask_val);
>>   	unsigned long flags;
>>   
>>   	/*
>> @@ -3839,11 +3839,13 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>   
>>   	vpe->col_idx = cpu;
>>   
>> +	cur = cpumask_first(irq_data_get_effective_affinity_mask(d));
> When is this not equal to 'from'?
It's based on my last patch. When skipping VMOVP, it is not equal to 'from'.
>>   	/*
>>   	 * GICv4.1 allows us to skip VMOVP if moving to a cpu whose RD
>>   	 * is sharing its VPE table with the current one.
>>   	 */
>>   	if (gic_data_rdist_cpu(cpu)->vpe_table_mask &&
>> +	    cpumask_test_cpu(cur, mask_val) &&
>>   	    cpumask_test_cpu(from, gic_data_rdist_cpu(cpu)->vpe_table_mask))
>>   		goto out;
> This looks utterly pointless to me.
Yes, there are some problems here. I'll think about it more carefully.

Kunkun Jiang
