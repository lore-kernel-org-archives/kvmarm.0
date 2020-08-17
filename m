Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6596BC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:03:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 034AF2072E
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 12:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 034AF2072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F424C000;
	Mon, 17 Aug 2020 08:03:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YPxe4xWnAATG; Mon, 17 Aug 2020 08:03:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB4F4C007;
	Mon, 17 Aug 2020 08:03:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A3EE4C000
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:03:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5-zdq3b4ZfvT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 08:03:26 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71D1D4BFD8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 08:03:26 -0400 (EDT)
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.55])
 by Forcepoint Email with ESMTP id ADE95C4E4428103920DA;
 Mon, 17 Aug 2020 20:03:21 +0800 (CST)
Received: from [10.174.186.8] (10.174.186.8) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Mon, 17
 Aug 2020 20:03:21 +0800
Subject: Re: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "will@kernel.org"
 <will@kernel.org>, "maz@kernel.org" <maz@kernel.org>
References: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
 <20200817020310.GA1210848@jagdpanzerIV.localdomain>
From: yezengruan <yezengruan@huawei.com>
Message-ID: <fe72592c-c721-bece-1469-95eebf931299@huawei.com>
Date: Mon, 17 Aug 2020 20:03:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200817020310.GA1210848@jagdpanzerIV.localdomain>
Content-Language: en-US
X-Originating-IP: [10.174.186.8]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Cc: joelaf@google.com,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 suleiman@google.com,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

On 2020/8/17 10:03, Sergey Senozhatsky wrote:
> On (20/07/21 13:17), Sergey Senozhatsky wrote:
>> Hello,
>>
>> 	RFC
>>
>> 	We noticed that in a number of cases when we wake_up_process()
>> on arm64 guest we end up enqueuing that task on a preempted VCPU. The culprit
>> appears to be the fact that arm64 guests are not aware of VCPU preemption
>> as such, so when sched picks up an idle VCPU it always assumes that VCPU
>> is available:
>>
>>       wake_up_process()
>>        try_to_wake_up()
>>         select_task_rq_fair()
>>          available_idle_cpu()
>>           vcpu_is_preempted()    // return false;
>>
>> Which is, obviously, not the case.
>>
>> This RFC patch set adds a simple vcpu_is_preempted() implementation so
>> that scheduler can make better decisions when it search for the idle
>> (v)CPU.
> Hi,
>
> A gentle ping.
>
> 	-ss
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> .

Hi Sergey,

I have a set of patches similar to yours.

https://lore.kernel.org/lkml/20191226135833.1052-1-yezengruan@huawei.com/

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
