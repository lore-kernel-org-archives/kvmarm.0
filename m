Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1FDC433E0
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 07:41:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3B92206B6
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 07:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3B92206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2204B286;
	Fri,  3 Jul 2020 03:41:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nzDlaAAVBZBS; Fri,  3 Jul 2020 03:41:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C67334B28B;
	Fri,  3 Jul 2020 03:41:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F984B292
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 03:41:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wDR6sCDhlZQm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2020 03:41:50 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F423D4B28B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2020 03:41:49 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 832375305EE57D5560E9;
 Fri,  3 Jul 2020 15:41:44 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 15:41:37 +0800
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To: Auger Eric <eric.auger@redhat.com>, <drjones@redhat.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
 <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <5a43242d-2c0b-d8d1-b12d-7436e7d03e52@huawei.com>
Date: Fri, 3 Jul 2020 15:41:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <88eacd00-1951-f6de-aa7c-bda48ece4fde@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
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

Hi Eric, Drew,

On 7/2/2020 9:36 PM, Auger Eric wrote:
> Hi Jingyi,
> 
> On 7/2/20 5:01 AM, Jingyi Wang wrote:
>> Trigger PPIs by setting up a 10msec timer and test the latency.
> 
> so for each iteration the accumulated valued is 10 ms + latency, right?
> and what is printed at the end does include the accumulated periods.
> Wouldn't it make sense to have a test->post() that substract this value.
> You would need to store the actual number of iterations.
> 
> Thanks
> 
> Eric

That's right, the result indicates 10ms + latency, which is a 10msec
timer actually costs. I think using the difference instead of the total
time cost can be a little confusing here. Maybe we can use test->post()
to get the latency and print an extra result in logs? Do you have any
opinions on that?

Thanks,
Jingyi

>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 4c962b7..6822084 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -23,8 +23,13 @@
>>   #include <asm/gic-v3-its.h>
>>   
>>   #define NTIMES (1U << 16)
>> +#define NTIMES_MINOR (1U << 8)
>>   #define MAX_NS (5 * 1000 * 1000 * 1000UL)
>>   
>> +#define IRQ_VTIMER		27
>> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
>> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)
>> +
>>   static u32 cntfrq;
>>   
>>   static volatile bool irq_ready, irq_received;
>> @@ -33,9 +38,16 @@ static void (*write_eoir)(u32 irqstat);
>>   
>>   static void gic_irq_handler(struct pt_regs *regs)
>>   {
>> +	u32 irqstat = gic_read_iar();
>>   	irq_ready = false;
>>   	irq_received = true;
>> -	gic_write_eoir(gic_read_iar());
>> +	gic_write_eoir(irqstat);
>> +
>> +	if (irqstat == IRQ_VTIMER) {
>> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
>> +			     cntv_ctl_el0);
>> +		isb();
>> +	}
>>   	irq_ready = true;
>>   }
>>   
>> @@ -189,6 +201,47 @@ static void lpi_exec(void)
>>   	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>>   }
>>   
>> +static bool timer_prep(void)
>> +{
>> +	static void *gic_isenabler;
>> +
>> +	gic_enable_defaults();
>> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>> +	local_irq_enable();
>> +
>> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
>> +	writel(1 << 27, gic_isenabler);
>> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>> +	isb();
>> +
>> +	gic_prep_common();
>> +	return true;
>> +}
>> +
>> +static void timer_exec(void)
>> +{
>> +	u64 before_timer;
>> +	u64 timer_10ms;
>> +	unsigned tries = 1 << 28;
>> +	static int received = 0;
>> +
>> +	irq_received = false;
>> +
>> +	before_timer = read_sysreg(cntvct_el0);
>> +	timer_10ms = cntfrq / 100;
>> +	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
>> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>> +	isb();
>> +
>> +	while (!irq_received && tries--)
>> +		cpu_relax();
>> +
>> +	if (irq_received)
>> +		++received;
>> +
>> +	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
>> +}
>> +
>>   static void hvc_exec(void)
>>   {
>>   	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
>> @@ -236,6 +289,7 @@ static struct exit_test tests[] = {
>>   	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
>>   	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
>>   	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
>> +	{"timer_10ms",		timer_prep,	timer_exec,		NTIMES_MINOR,	true},
>>   };
>>   
>>   struct ns_time {
>>
> 
> 
> .
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
