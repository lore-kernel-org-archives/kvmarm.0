Return-Path: <SRS0=KyyX=BN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7269C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 02:15:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F4842075B
	for <kvmarm@archiver.kernel.org>; Mon,  3 Aug 2020 02:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F4842075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C604B63D;
	Sun,  2 Aug 2020 22:15:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oGfrO7kxtmEL; Sun,  2 Aug 2020 22:15:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9CB4B640;
	Sun,  2 Aug 2020 22:15:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C9804B63D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2020 22:15:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TwpPSPEYhrmF for <kvmarm@lists.cs.columbia.edu>;
 Sun,  2 Aug 2020 22:15:21 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 721624B63C
 for <kvmarm@lists.cs.columbia.edu>; Sun,  2 Aug 2020 22:15:21 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 66B73CAFDBFEB9A71E88;
 Mon,  3 Aug 2020 10:15:17 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 3 Aug 2020
 10:15:06 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To: Andrew Jones <drjones@redhat.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
From: Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <b5263ff5-385f-cf03-33bd-3d4efd3bcdab@huawei.com>
Date: Mon, 3 Aug 2020 10:15:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200731120117.5kk22hx2wpbt6kpz@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, prime.zeng@hisilicon.com,
 kvmarm@lists.cs.columbia.edu
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



On 7/31/2020 8:01 PM, Andrew Jones wrote:
> On Fri, Jul 31, 2020 at 03:42:34PM +0800, Jingyi Wang wrote:
>> With the development of arm gic architecture, we think it will be useful
>> to add some performance test in kut to measure the cost of interrupts.
>> In this series, we add GICv4.1 support for ipi latency test and
>> implement LPI/vtimer latency test.
>>
>> This series of patches has been tested on GICv4.1 supported hardware.
>>
>> Note:
>> Based on patch "arm/arm64: timer: Extract irqs at setup time",
>> https://www.spinics.net/lists/kvm-arm/msg41425.html
>>
>> * From v2:
>>    - Code and commit message cleanup
>>    - Clear nr_ipi_received before ipi_exec() thanks for Tao Zeng's review
>>    - rebase the patch "Add vtimer latency test" on Andrew's patch
> 
> It'd be good if you'd reposted my patch along with this series, since we
> didn't merge mine yet either. Don't worry about now, though, I'll pick it
> up the same time I pick up this series, which I plan to do later today
> or tomorrow.
> 
> Getting this series applied will allow me to try out our new and shiny
> gitlab repo :-)
> 
> Thanks,
> drew
> 

Thanks for your reviewing and fix.

>>    - Add test->post() to get actual PPI latency
>>
>> * From v1:
>>    - Fix spelling mistake
>>    - Use the existing interface to inject hw sgi to simply the logic
>>    - Add two separate patches to limit the running times and time cost
>>      of each individual micro-bench test
>>
>> Jingyi Wang (10):
>>    arm64: microbench: get correct ipi received num
>>    arm64: microbench: Generalize ipi test names
>>    arm64: microbench: gic: Add ipi latency test for gicv4.1 support kvm
>>    arm64: its: Handle its command queue wrapping
>>    arm64: microbench: its: Add LPI latency test
>>    arm64: microbench: Allow each test to specify its running times
>>    arm64: microbench: Add time limit for each individual test
>>    arm64: microbench: Add vtimer latency test
>>    arm64: microbench: Add test->post() to further process test results
>>    arm64: microbench: Add timer_post() to get actual PPI latency
>>
>>   arm/micro-bench.c          | 256 ++++++++++++++++++++++++++++++-------
>>   lib/arm/asm/gic-v3.h       |   3 +
>>   lib/arm/asm/gic.h          |   1 +
>>   lib/arm64/gic-v3-its-cmd.c |   3 +-
>>   4 files changed, 219 insertions(+), 44 deletions(-)
>>
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
