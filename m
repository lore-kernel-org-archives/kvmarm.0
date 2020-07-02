Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0ACC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9CF7D20884
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CF7D20884
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5D594B5C7;
	Thu,  2 Jul 2020 04:46:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQCZSQtHsfij; Thu,  2 Jul 2020 04:46:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA9F14B5AA;
	Thu,  2 Jul 2020 04:46:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DA794B5B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:46:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LKVcWa7dqAWt for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 04:46:39 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B19F4B5A2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:46:39 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id CB791E8580BA167F2405;
 Thu,  2 Jul 2020 16:46:35 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 16:46:26 +0800
Subject: Re: [kvm-unit-tests PATCH v2 6/8] arm64: microbench: Allow each test
 to specify its running times
To: Andrew Jones <drjones@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-7-wangjingyi11@huawei.com>
 <20200702052942.laodlgq2yrlxwsh4@kamzik.brq.redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <c30baed6-2ff3-7d9d-64e1-0ff2bdf2697b@huawei.com>
Date: Thu, 2 Jul 2020 16:46:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200702052942.laodlgq2yrlxwsh4@kamzik.brq.redhat.com>
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



On 7/2/2020 1:29 PM, Andrew Jones wrote:
> On Thu, Jul 02, 2020 at 11:01:30AM +0800, Jingyi Wang wrote:
>> For some test in micro-bench can be time consuming, we add a
>> micro-bench test parameter to allow each individual test to specify
>> its running times.
>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 25 ++++++++++++++-----------
>>   1 file changed, 14 insertions(+), 11 deletions(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index aeb60a7..506d2f9 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -223,17 +223,18 @@ struct exit_test {
>>   	const char *name;
>>   	bool (*prep)(void);
>>   	void (*exec)(void);
>> +	u32 times;
>>   	bool run;
>>   };
>>   
>>   static struct exit_test tests[] = {
>> -	{"hvc",			NULL,		hvc_exec,		true},
>> -	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
>> -	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
>> -	{"eoi",			NULL,		eoi_exec,		true},
>> -	{"ipi",			ipi_prep,	ipi_exec,		true},
>> -	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
>> -	{"lpi",			lpi_prep,	lpi_exec,		true},
>> +	{"hvc",			NULL,		hvc_exec,		NTIMES,		true},
>> +	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NTIMES,		true},
>> +	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NTIMES,		true},
>> +	{"eoi",			NULL,		eoi_exec,		NTIMES,		true},
>> +	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
>> +	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
>> +	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
> 
> Now that we no longer use 'NTIMES' in functions we don't really need the
> define at all. We can just put 65536 directly into the table here for
> each test that needs 65536 times.
> 
> Thanks,
> drew
> 

Done, thanks for reviewing.

>>   };
>>   
>>   struct ns_time {
>> @@ -254,7 +255,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
>>   
>>   static void loop_test(struct exit_test *test)
>>   {
>> -	uint64_t start, end, total_ticks, ntimes = NTIMES;
>> +	uint64_t start, end, total_ticks, ntimes = 0;
>>   	struct ns_time total_ns, avg_ns;
>>   
>>   	if (test->prep) {
>> @@ -265,15 +266,17 @@ static void loop_test(struct exit_test *test)
>>   	}
>>   	isb();
>>   	start = read_sysreg(cntpct_el0);
>> -	while (ntimes--)
>> +	while (ntimes < test->times) {
>>   		test->exec();
>> +		ntimes++;
>> +	}
>>   	isb();
>>   	end = read_sysreg(cntpct_el0);
>>   
>>   	total_ticks = end - start;
>>   	ticks_to_ns_time(total_ticks, &total_ns);
>> -	avg_ns.ns = total_ns.ns / NTIMES;
>> -	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
>> +	avg_ns.ns = total_ns.ns / ntimes;
>> +	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>>   
>>   	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
>>   		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
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
