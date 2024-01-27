Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C6AB67F
	for <kvmarm@lists.linux.dev>; Sat, 27 Jan 2024 02:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323334; cv=none; b=YMEavTPCVB4REPcij7k+cna80e7uZ/yovJOwNBMICmK9+Xo+HIR5QaoxySoCk9uCfkcmQIHSPWDaDMizamOusnNDAE680ku4xD+E3Dls04KutgU9Zlpo3V08Am46X+r0quZ9Ezllqi2wom//dKzkecYcHkWWgSrPl1wHryXwv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323334; c=relaxed/simple;
	bh=fo7bzt3IKqefdd+Y7nnGddXTNh8ZGPn0tL7e6x9bJlM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oDqwjiPbVG2t5ptYkHSisVucCjagKQZXVV1kORHotb3jsOoJsT/d6cxbfLmsJPzlRhxaaLJDLCCgI1vjTc19h6+juZsYblND9xynAwzMcz2DW3Dt133vfsDh+zw962O8tpv+oixwLTrF31uc8sJ54lGos09coGAULOjkeoeP5bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TMJhs5vnLz18MHs;
	Sat, 27 Jan 2024 10:41:01 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id EFD9518007D;
	Sat, 27 Jan 2024 10:42:07 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Jan 2024 10:42:06 +0800
Subject: Re: [PATCH v2 1/2] irqchip/gic-v4.1: Fix GICv4.1 doorbell affinity
To: Marc Zyngier <maz@kernel.org>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>
References: <20240126103012.1020-1-jiangkunkun@huawei.com>
 <20240126103012.1020-2-jiangkunkun@huawei.com> <86ttn074ev.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <44051a41-f82e-57d9-001a-d4d195d59f2e@huawei.com>
Date: Sat, 27 Jan 2024 10:41:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86ttn074ev.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Marc,

On 2024/1/26 18:52, Marc Zyngier wrote:
> On Fri, 26 Jan 2024 10:30:11 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> dd3f050a216e make an optimization, VMOVP can be skipped if moving
>> VPE to a cpu whose RD is sharing its VPE table with the current one.
>> But when skipping VMOVP, the affinity recorded in irq_data is still
>> updated. This causes the doorbell affinity recorfed in the irq_data
>> to be inconsistent with the actual.
>>
>> In corner case, this may result in lost interrupts:
>> 0. Each cpu die shares a VPE table and contains 32 CPUs
>>     die0(CPU0-31) die1(CPU32-63)...
>> 1. VPE resides on CPU32, doorbell affinity to CPU32.
>> 2. Move VPE to CPU33, skip VMOVP, doorbell still affinity to CPU32.
>>     The affinity recorded in irq_data is CPU33.
>> 3. Manually offline CPU32 on the host side:
>>     'echo 0 > /sys/devices/system/cpu/cpu32/online'
>> 4. Core code cannot move the doorbell affinity to CPU32, since the
>>     record in irq_data is CPU33.
>> 5. Subsequent doorbell interrupts will be lost.
>>
>> So affinity recoreded in irq_data should not be updated when skipping
>> VMOVP.
>>
>> Fixes: dd3f050a216e (irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP)
>> Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
>> ---
>>   drivers/irqchip/irq-gic-v3-its.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index d097001c1e3e..4b1dbb697959 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3850,8 +3850,9 @@ static int its_vpe_set_affinity(struct irq_data *d,
>>   	its_send_vmovp(vpe);
>>   	its_vpe_db_proxy_move(vpe, from, cpu);
>>   
>> -out:
>>   	irq_data_update_effective_affinity(d, cpumask_of(cpu));
>> +
>> +out:
>>   	vpe_to_cpuid_unlock(vpe, flags);
>>   
>>   	return IRQ_SET_MASK_OK_DONE;
> This is becoming *very* annoying. I've already told you this patch was
> wrong, yet you keep sending it (twice in just over an hour).
Sorry, I didn't see that you had replied to me, when I sent it for
the second time.I have no intention of doing this.Sincerely apologize
for you.

Please allow me to put your previous reply here for discussion:
> That looks wrong. You are lying to the core code by saying that it's
> all OK, and yet haven't done*anything*. This stuff is obviously
> buggy, but I don't think this is right.
Make scene. I understand that the root cause of this problem is that
there is a difference between the doorbell affinity recorded in the
kernel and the actual hardware. So I'm just thinking about keeping
both consistent.
> In your example, you don't even solve the problem: if CPUs 32 and 33
> are part of the same ITS affinity group, you won't issue a VMOVP
> either, so this doesn't fix anything.
No VMOVP is sent. But the affinity recorded in irq_data is correct.
So when offline CPU32, core code can move doorbell to CPU0.The
mask_val is the entire cpu range, except for the offline cpu.
> At this stage, I think the VMOVP optimisation is wrong and that we
> should drop it.
This is the last resort. Maybe we can think of another way.

Kunkun Jiang

