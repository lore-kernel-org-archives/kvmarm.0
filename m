Return-Path: <SRS0=ZPfy=BI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881A3C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 02:57:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FA452076E
	for <kvmarm@archiver.kernel.org>; Wed, 29 Jul 2020 02:57:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FA452076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C6B24BA80;
	Tue, 28 Jul 2020 22:57:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id shUE+zSlGT8C; Tue, 28 Jul 2020 22:57:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 371894BAD5;
	Tue, 28 Jul 2020 22:57:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE60E4BA81
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 22:57:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fvv31TgssXNE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 22:57:48 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C8074BA80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 22:57:44 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id DEDAF5C6B6236BE30C72;
 Wed, 29 Jul 2020 10:57:38 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Jul 2020 10:57:30 +0800
From: zhukeqian <zhukeqian1@huawei.com>
Subject: Re: [PATCH 0/9] arm64: Stolen time support
To: Steven Price <steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <1611996b-1ec1-dee7-ed61-b3b9df23f138@huawei.com>
 <25c7f2e2-e779-4e97-fdc5-0aba9fcf0fbc@arm.com>
Message-ID: <816e3b46-07fc-0274-deb2-0d026d50b989@huawei.com>
Date: Wed, 29 Jul 2020 10:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <25c7f2e2-e779-4e97-fdc5-0aba9fcf0fbc@arm.com>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 yebiaoxiang@huawei.com, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Steven,

On 2020/7/27 18:48, Steven Price wrote:
> On 21/07/2020 04:26, zhukeqian wrote:
>> Hi Steven,
> 
> Hi Keqian,
> 
>> On 2019/8/2 22:50, Steven Price wrote:
>>> This series add support for paravirtualized time for arm64 guests and
>>> KVM hosts following the specification in Arm's document DEN 0057A:
>>>
>>> https://developer.arm.com/docs/den0057/a
>>>
>>> It implements support for stolen time, allowing the guest to
>>> identify time when it is forcibly not executing.
>>>
>>> It doesn't implement support for Live Physical Time (LPT) as there are
>>> some concerns about the overheads and approach in the above
>> Do you plan to pick up LPT support? As there is demand of cross-frequency migration
>> (from older platform to newer platform).
> 
> I don't have any plans to pick up the LPT support at the moment - feel free to pick it up! ;)
> 
>> I am not clear about the overheads and approach problem here, could you please
>> give some detail information? Maybe we can work together to solve these concerns. :-)
> 
> Fundamentally the issue here is that LPT only solves one small part of migration between different hosts. To successfully migrate between hosts with different CPU implementations it is also necessary to be able to virtualise various ID registers (e.g. MIDR_EL1, REVIDR_EL1, AIDR_EL1) which we have no support for currently.
> 
Yeah, currently we are trying to do both timer freq virtualization and CPU feature virtualization.

> The problem with just virtualising the registers is how you handle errata. The guest will currently use those (and other) ID registers to decide whether to enable specific errata workarounds. But what errata should be enabled for a guest which might migrate to another host?
> 
Thanks for pointing this out.

I think the most important thing is that we should introduce a concept named CPU baseline which represents a standard platform.
If we bring up a guest with a specific CPU baseline, then this guest can only run on a platform that is compatible with this CPU baseline.
So "baseline" and "compatible" are the key point to promise successful cross-platform migration.


> What we ideally need is a mechanism to communicate to the guest what workarounds are required to successfully run on any of the hosts that the guest may be migrated to. You may also have the situation where the workarounds required for two hosts are mutually incompatible - something needs to understand this and do the "right thing" (most likely just reject this situation, i.e. prevent the migration).
> 
> There are various options here: e.g. a para-virtualised interface to describe the workarounds (but this is hard to do in an OS-agnostic way), or virtual-ID registers describing an idealised environment where no workarounds are required (and only hosts that have no errata affecting a guest would be able to provide this).
> 
My idea is similar with the "idealised environment", but errata workaround still exists.
We do not provide para-virtualised interface, and migration is restricted between platforms that are compatible with baseline.

Baseline should has two aspects: CPU feature and errata. These platforms that are compatible with a specific baseline should have the corresponding CPU feature and errata.

> Given the above complexity and the fact that Armv8.6-A standardises the frequency to 1GHz this didn't seem worth continuing with. So LPT was dropped from the spec and patches to avoid holding up the stolen time support.
> 
> However, if you have a use case which doesn't require such a generic migration (e.g. perhaps old and new platforms are based on the same IP) then it might be worth looking at bring this back. But to make the problem solvable it either needs to be restricted to platforms which are substantially the same (so the errata list will be identical), or there's work to be done in preparation to deal with migrating a guest successfully between hosts with potentially different errata requirements.
> 
> Can you share more details about the hosts that you are interested in migrating between?
Here we have new platform with 1GHz timer, and old platform is 100MHZ, so we want to solve the cross-platform migration firstly.

Thanks,
Keqian
> 
> Thanks,
> 
> Steve
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
