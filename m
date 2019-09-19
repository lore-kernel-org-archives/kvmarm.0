Return-Path: <SRS0=pHiG=XO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B6BC4CEC4
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 01:32:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 877C821907
	for <kvmarm@archiver.kernel.org>; Thu, 19 Sep 2019 01:32:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 877C821907
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8E0A4A60A;
	Wed, 18 Sep 2019 21:32:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OeMaRNSh2F0u; Wed, 18 Sep 2019 21:32:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A15D4A688;
	Wed, 18 Sep 2019 21:32:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7F54A60A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Sep 2019 21:32:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6roZCWZiJRdx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Sep 2019 21:32:23 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35A104A5D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Sep 2019 21:32:23 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 3E865353E65584EF064B;
 Thu, 19 Sep 2019 09:32:20 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 09:32:12 +0800
Subject: Re: [Question-GIC-v4.1] Plan on GIC-v4.1 driver development
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>
References: <40d7276c-54a3-0cca-a207-217459850c21@hisilicon.com>
 <0501c049-67a6-9a63-e0d9-e043573e1211@kernel.org>
 <c9bdf5bc-4787-2f09-9e8b-60d69aa8754b@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <2d1b3d11-1f90-40c1-8f88-45532111c53c@hisilicon.com>
Date: Thu, 19 Sep 2019 09:32:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <c9bdf5bc-4787-2f09-9e8b-60d69aa8754b@kernel.org>
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
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

On 2019/9/18 17:58, Marc Zyngier wrote:
> On 17/09/2019 10:23, Marc Zyngier wrote:
>> On 17/09/2019 03:15, Shaokun Zhang wrote:
>>> Hi Marc,
>>>
>>> This is from Nianyao Tang.
>>>
>>> I'm planning to do some verification on our GIC-v4.1 implement. I would like some
>>> information about linux GIC-v4.1 driver. When will linux support GIC-v4.1 or what's
>>> the plan on developing GIC-v4.1 driver?
>>
>> The easy answer is that yes, there is a plan. There is some code, even,
>> just not quite in a usable state yet. I'll try to push something out
>> once I get a chance.
> 
> FWIW, I've pushed out a branch containing the current state of this work
> at [1]. It doesn't really work at the moment (Doorbells and SGIs are
> unreliable), but hopefully that will give you an idea of what is going on.
> 

Thank you, it is really helpful. I will check on this code first. If have any doubt,
I will 'noise' you again ;-)

Thanks in advance,
Shaokun

> Being a work in progress, it is unstable, subject to being changed,
> rebased and deleted without warning.
> 
> Thanks,
> 
> 	M.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/gic-v4.1-devel
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
