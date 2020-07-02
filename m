Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23D1C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3D0A820720
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D0A820720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4D64B5C6;
	Thu,  2 Jul 2020 04:21:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7HjsSc2ikpg5; Thu,  2 Jul 2020 04:21:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 755944B5AA;
	Thu,  2 Jul 2020 04:21:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F574B5AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:21:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RhqfRK5Uhr-W for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 04:21:46 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21DC94B5A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:21:46 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id D805C79AD0AFC2793C26;
 Thu,  2 Jul 2020 16:21:42 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 16:21:32 +0800
Subject: Re: [kvm-unit-tests PATCH v2 2/8] arm64: microbench: Use the funcions
 for ipi test as the general functions for gic(ipi/lpi/timer) test
To: Andrew Jones <drjones@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-3-wangjingyi11@huawei.com>
 <20200702052554.2be22pr3wa2nximf@kamzik.brq.redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <cb92098b-5b0a-bc11-0a6a-2d4b34442b89@huawei.com>
Date: Thu, 2 Jul 2020 16:21:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200702052554.2be22pr3wa2nximf@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Drew,

On 7/2/2020 1:25 PM, Andrew Jones wrote:
> 
> Hi Jingyi,
> 
> This patch has quite a long summary. How about instead of
> 
>   arm64: microbench: Use the funcions for ipi test as the general functions for gic(ipi/lpi/timer) test
> 
> we use
> 
>   arm64: microbench: Generalize ipi test names
> 
> and then in the commit message, instead of
> 
>   The following patches will use that.
> 
> we use
> 
>   Later patches will use these functions for gic(ipi/lpi/timer) tests.
> 
> Thanks,
> drew
> 

This looks more concise, thanks for reviewing

Thanks,
Jingyi

> On Thu, Jul 02, 2020 at 11:01:26AM +0800, Jingyi Wang wrote:
>> The following patches will use that.
>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 39 ++++++++++++++++++++++-----------------
>>   1 file changed, 22 insertions(+), 17 deletions(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 794dfac..fc4d356 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -25,24 +25,24 @@
>>   
>>   static u32 cntfrq;
>>   
>> -static volatile bool ipi_ready, ipi_received;
>> +static volatile bool irq_ready, irq_received;
>>   static void *vgic_dist_base;
>>   static void (*write_eoir)(u32 irqstat);
>>   
>> -static void ipi_irq_handler(struct pt_regs *regs)
>> +static void gic_irq_handler(struct pt_regs *regs)
>>   {
>> -	ipi_ready = false;
>> -	ipi_received = true;
>> +	irq_ready = false;
>> +	irq_received = true;
>>   	gic_write_eoir(gic_read_iar());
>> -	ipi_ready = true;
>> +	irq_ready = true;
>>   }
>>   
>> -static void ipi_secondary_entry(void *data)
>> +static void gic_secondary_entry(void *data)
>>   {
>> -	install_irq_handler(EL1H_IRQ, ipi_irq_handler);
>> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>>   	gic_enable_defaults();
>>   	local_irq_enable();
>> -	ipi_ready = true;
>> +	irq_ready = true;
>>   	while (true)
>>   		cpu_relax();
>>   }
>> @@ -72,9 +72,9 @@ static bool test_init(void)
>>   		break;
>>   	}
>>   
>> -	ipi_ready = false;
>> +	irq_ready = false;
>>   	gic_enable_defaults();
>> -	on_cpu_async(1, ipi_secondary_entry, NULL);
>> +	on_cpu_async(1, gic_secondary_entry, NULL);
>>   
>>   	cntfrq = get_cntfrq();
>>   	printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
>> @@ -82,13 +82,18 @@ static bool test_init(void)
>>   	return true;
>>   }
>>   
>> -static void ipi_prep(void)
>> +static void gic_prep_common(void)
>>   {
>>   	unsigned tries = 1 << 28;
>>   
>> -	while (!ipi_ready && tries--)
>> +	while (!irq_ready && tries--)
>>   		cpu_relax();
>> -	assert(ipi_ready);
>> +	assert(irq_ready);
>> +}
>> +
>> +static void ipi_prep(void)
>> +{
>> +	gic_prep_common();
>>   }
>>   
>>   static void ipi_exec(void)
>> @@ -96,17 +101,17 @@ static void ipi_exec(void)
>>   	unsigned tries = 1 << 28;
>>   	static int received = 0;
>>   
>> -	ipi_received = false;
>> +	irq_received = false;
>>   
>>   	gic_ipi_send_single(1, 1);
>>   
>> -	while (!ipi_received && tries--)
>> +	while (!irq_received && tries--)
>>   		cpu_relax();
>>   
>> -	if (ipi_received)
>> +	if (irq_received)
>>   		++received;
>>   
>> -	assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
>> +	assert_msg(irq_received, "failed to receive IPI in time, but received %d successfully\n", received);
>>   }
>>   
>>   static void hvc_exec(void)
>> -- 
>> 2.19.1
>>
>>
> 
> 
> .
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
