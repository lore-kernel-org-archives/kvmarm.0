Return-Path: <SRS0=Ct8k=AO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66271C433DF
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:42:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F1917207E8
	for <kvmarm@archiver.kernel.org>; Fri,  3 Jul 2020 03:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1917207E8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 652514B251;
	Thu,  2 Jul 2020 23:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hg4IMcnS0WM1; Thu,  2 Jul 2020 23:42:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ABFF4B232;
	Thu,  2 Jul 2020 23:42:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBB114B230
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y-2vrBvR3vEI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2020 23:42:32 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C9294B1FE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2020 23:42:32 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 48E51D56D85A85D98164;
 Fri,  3 Jul 2020 11:42:29 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 11:42:18 +0800
Subject: Re: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit
 for each individual test
To: Auger Eric <eric.auger@redhat.com>, <drjones@redhat.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-8-wangjingyi11@huawei.com>
 <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <9db9c741-8c1c-4c59-269e-9bb3c1a626f8@huawei.com>
Date: Fri, 3 Jul 2020 11:42:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
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

Hi Eric,

On 7/2/2020 9:23 PM, Auger Eric wrote:
> Hi Jingyi,
> 
> On 7/2/20 5:01 AM, Jingyi Wang wrote:
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
> you don't need the
> ticks_to_ns_time(total_ticks, &total_ns);
> 
> after the loop

Okay, I forgot to delete it here. Thanks for reviewing.

>> -	isb();
>> -	end = read_sysreg(cntpct_el0);
>>   
>> -	total_ticks = end - start;
>>   	ticks_to_ns_time(total_ticks, &total_ns);
>>   	avg_ns.ns = total_ns.ns / ntimes;
>>   	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>>
> 
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Thanks
> 
> Eric
> 
> 
> .
> 

Thanks,
Jingyi

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
