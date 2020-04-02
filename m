Return-Path: <SRS0=xSqk=5S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48D3C43331
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 11:53:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D14D6206D3
	for <kvmarm@archiver.kernel.org>; Thu,  2 Apr 2020 11:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D14D6206D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48FD34B0B4;
	Thu,  2 Apr 2020 07:53:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vQrX0G2OdlZM; Thu,  2 Apr 2020 07:53:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09B3E4B159;
	Thu,  2 Apr 2020 07:53:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8969F4B141
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 07:53:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGVPNkbTMZYO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2020 07:53:02 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E24B4B140
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2020 07:53:00 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 39F40EDE49B3907DBDD7;
 Thu,  2 Apr 2020 19:52:54 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 19:52:44 +0800
Subject: Re: [kvm-unit-tests PATCH 0/2] arm/arm64: Add IPI/vtimer latency
To: Andrew Jones <drjones@redhat.com>, Jingyi Wang <wangjingyi11@huawei.com>
References: <20200401100812.27616-1-wangjingyi11@huawei.com>
 <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <bbcd3dc4-79c1-7ba2-ea54-96d083dfcef9@huawei.com>
Date: Thu, 2 Apr 2020 19:52:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200401122445.exyobwo3a3agnuhk@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Hi Drew, Jingyi,

On 2020/4/1 20:24, Andrew Jones wrote:
> On Wed, Apr 01, 2020 at 06:08:10PM +0800, Jingyi Wang wrote:
>> With the development of arm gic architecture, we think it will be useful
>> to add some simple performance test in kut to measure the cost of
>> interrupts. X86 arch has implemented similar test.
>>
>> Jingyi Wang (2):
>>    arm/arm64: gic: Add IPI latency test
>>    arm/arm64: Add vtimer latency test
>>
>>   arm/gic.c   | 27 +++++++++++++++++++++++++++
>>   arm/timer.c | 11 +++++++++++
>>   2 files changed, 38 insertions(+)
>>
>> -- 
>> 2.19.1
>>
>>
> 
> Hi Jingyi,
> 
> We already have an IPI latency test in arm/micro-bench.c I'd prefer that
> one be used, if possible, rather than conflating the gic functional tests
> with latency tests. Can you take a look at it and see if it satisfies
> your needs, extending it if necessary?

I think it'd be good to have these interrupt latency measurements in
kvm-unit-tests, and we can take the following interrupt types into
account:

- IPI
   As Drew pointed out, we already have one in the micro-bench group.
   But what I'm actually interested in is the latency of the new GICv4.1
   vSGIs (which will be directly injected through ITS).  To measure it,
   we should first make KUT be GICv4.1-awareness, see [1] for details.
   (This way, we can even have a look at the interrupt latency in HW
   level. Is it possible to have this in kvm-unit-tests, Drew?)

- PPI
   Like what has been done in patch #2, you can choose the vtimer
   interrupt as an example.

- LPI
   I think we can easily build a LPI latency test based on Eric's "ITS
   tests" series [2], which should be upstreamed soon.

- if you want to add more...

What do you think? I'd like to see a V2 of this series :-).


[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0b04758b002bde9434053be2fff8064ac3d9d8bb
[2] 
https://lore.kernel.org/kvm/20200320092428.20880-1-eric.auger@redhat.com/


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
