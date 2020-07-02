Return-Path: <SRS0=CSPl=AN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35EEC433DF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:47:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 819C820884
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jul 2020 08:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 819C820884
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 16D8D4B5D1;
	Thu,  2 Jul 2020 04:47:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i4uQwounQcbw; Thu,  2 Jul 2020 04:47:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0987C4B5C6;
	Thu,  2 Jul 2020 04:47:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 977BD4B5C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:47:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D4sGKvSoTiD6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 04:47:17 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C4DA4B5BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 04:47:17 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 4D8B7D733B65A62050CE;
 Thu,  2 Jul 2020 16:47:15 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 16:47:09 +0800
Subject: Re: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit
 for each individual test
To: Andrew Jones <drjones@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-8-wangjingyi11@huawei.com>
 <20200702054857.qcmaaproewgzzljf@kamzik.brq.redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <88f2e5a2-def5-81f1-eb3c-b6a12b9ea64d@huawei.com>
Date: Thu, 2 Jul 2020 16:47:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200702054857.qcmaaproewgzzljf@kamzik.brq.redhat.com>
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



On 7/2/2020 1:48 PM, Andrew Jones wrote:
> On Thu, Jul 02, 2020 at 11:01:31AM +0800, Jingyi Wang wrote:
>> Besides using separate running times parameter, we add time limit
>> for loop_test to make sure each test should be done in a certain
>> time(5 sec here).
>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 506d2f9..4c962b7 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -23,6 +23,7 @@
>>   #include <asm/gic-v3-its.h>
>>   
>>   #define NTIMES (1U << 16)
>> +#define MAX_NS (5 * 1000 * 1000 * 1000UL)
> 
> How about naming this something like "NS_5_SECONDS"?
> 

Done, thanks for reviewing.

>>   
>>   static u32 cntfrq;
>>   
>> @@ -258,22 +259,26 @@ static void loop_test(struct exit_test *test)
>>   	uint64_t start, end, total_ticks, ntimes = 0;
>>   	struct ns_time total_ns, avg_ns;
>>   
>> +	total_ticks = 0;
>>   	if (test->prep) {
>>   		if(!test->prep()) {
>>   			printf("%s test skipped\n", test->name);
>>   			return;
>>   		}
>>   	}
>> -	isb();
>> -	start = read_sysreg(cntpct_el0);
>> -	while (ntimes < test->times) {
>> +
>> +	while (ntimes < test->times && total_ns.ns < MAX_NS) {
>> +		isb();
>> +		start = read_sysreg(cntpct_el0);
>>   		test->exec();
>> +		isb();
>> +		end = read_sysreg(cntpct_el0);
>> +
>>   		ntimes++;
>> +		total_ticks += (end - start);
>> +		ticks_to_ns_time(total_ticks, &total_ns);
>>   	}
>> -	isb();
>> -	end = read_sysreg(cntpct_el0);
>>   
>> -	total_ticks = end - start;
>>   	ticks_to_ns_time(total_ticks, &total_ns);
>>   	avg_ns.ns = total_ns.ns / ntimes;
>>   	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>> -- 
>> 2.19.1
>>
>>
> 
> Thanks,
> drew
> 
> 
> .
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
