Return-Path: <SRS0=T6xz=FI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3BAC4361A
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 07:03:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8DC6224DF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Dec 2020 07:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8DC6224DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 132C84B235;
	Fri,  4 Dec 2020 02:03:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eOZfe5E0eYyX; Fri,  4 Dec 2020 02:03:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19ACB4B249;
	Fri,  4 Dec 2020 02:03:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD70F4B22D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 02:02:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6q2HvCaTL7UE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Dec 2020 02:02:56 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4F614B224
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Dec 2020 02:02:56 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnNtc3WcLzklD0;
 Fri,  4 Dec 2020 15:02:16 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Dec 2020 15:02:43 +0800
Subject: Re: [PATCH v2 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To: Marc Zyngier <maz@kernel.org>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
 <20200818032814.15968-3-zhukeqian1@huawei.com>
 <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <c41a32f6-e671-4c69-cbbc-57c11d35112f@huawei.com>
Date: Fri, 4 Dec 2020 15:02:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <b232d02b2d9c3e29898914bd9bbb8dc5@kernel.org>
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 2020/12/3 22:57, Marc Zyngier wrote:
> On 2020-08-18 04:28, Keqian Zhu wrote:
>> ARM virtual counter supports event stream, it can only trigger an event
>> when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 changes,
>> so the actual period of event stream is 2^(cntkctl_evnti + 1). For example,
>> when the trigger bit is 0, then virtual counter trigger an event for every
>> two cycles.
>>
>> Fixes: 037f637767a8 ("drivers: clocksource: add support for
>>        ARM architected timer event stream")
> 
> Fixes: tags should on a single line.
Will do.

> 
>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/clocksource/arm_arch_timer.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/clocksource/arm_arch_timer.c
>> b/drivers/clocksource/arm_arch_timer.c
>> index 777d38c..e3b2ee0 100644
>> --- a/drivers/clocksource/arm_arch_timer.c
>> +++ b/drivers/clocksource/arm_arch_timer.c
>> @@ -824,10 +824,14 @@ static void arch_timer_configure_evtstream(void)
>>  {
>>      int evt_stream_div, pos;
>>
>> -    /* Find the closest power of two to the divisor */
>> -    evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
>> +    /*
>> +     * Find the closest power of two to the divisor. As the event
>> +     * stream can at most be generated at half the frequency of the
>> +     * counter, use half the frequency when computing the divider.
>> +     */
>> +    evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ / 2;
>>      pos = fls(evt_stream_div);
>> -    if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
>> +    if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
>>          pos--;
> 
> You don't explain why you are special-casing pos == 1.
The logic is not clear here, I will try to reform it.

> 
>>      /* enable event stream */
>>      arch_timer_evtstrm_enable(min(pos, 15));
> 
> Also, please Cc the subsystem maintainers:
> 
> CLOCKSOURCE, CLOCKEVENT DRIVERS
> M:      Daniel Lezcano <daniel.lezcano@linaro.org>
> M:      Thomas Gleixner <tglx@linutronix.de>
> L:      linux-kernel@vger.kernel.org
> S:      Supported
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> F:      Documentation/devicetree/bindings/timer/
> F:      drivers/clocksource/
> 
Will do.

> Thanks,
> 
>         M.

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
