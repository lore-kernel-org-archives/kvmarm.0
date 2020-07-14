Return-Path: <SRS0=ASFk=AZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF47BC433E3
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 12:16:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 488DB2068F
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jul 2020 12:16:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 488DB2068F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A94264B1FB;
	Tue, 14 Jul 2020 08:16:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Cv9IQBPeujo; Tue, 14 Jul 2020 08:16:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B96F04B205;
	Tue, 14 Jul 2020 08:16:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFED4B1FA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2020 08:16:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wCJnUIUh6AZd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Jul 2020 08:16:13 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D30A4B197
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Jul 2020 08:16:12 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id D5E449E0DE64A63E461C;
 Tue, 14 Jul 2020 20:16:05 +0800 (CST)
Received: from [10.174.187.22] (10.174.187.22) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 14 Jul 2020 20:15:56 +0800
Subject: Re: [Question] About scaling factor of Enhanced Counter Virtualization
To: Marc Zyngier <maz@kernel.org>
References: <e435efd2-f894-ecbb-5eb4-abf446aa1e56@huawei.com>
 <ccc11488876b8222414389d0cbcead6b@kernel.org>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <0bbe0709-c055-2d97-9a88-814821dd9c2f@huawei.com>
Date: Tue, 14 Jul 2020 20:15:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ccc11488876b8222414389d0cbcead6b@kernel.org>
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Catalin Marinas <catalin.marinas@arm.com>, yebiaoxiang@huawei.com,
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

On 2020/7/14 19:34, Marc Zyngier wrote:
> Hi Keqian,
> 
> On 2020-07-14 03:20, zhukeqian wrote:
>> Hi all,
>>
>> We are studying Enhanced Counter Virtualization (introduced by ARMv8.6
>> extension), and here is a question
>> raised by Biaoxiang Ye <yebiaoxiang@huawei.com>:
>>
>> Described in the ARMv8.6 Extension Specification:
>> Note: the scaling factor CNTSCALE is designed as a 2.62 bit fixed
>> point number, so permitting a scaling up by
>> (nearly) a factor 4. The scaling factor CNTISCALE is signed as an 8.56
>> number for the scaling of the values
>> written into the timers for comparison with the actual count. This
>> implies that the greatest scaling down of the
>> counter supported in (nearly) a factor of *512*.
>>
>> We think the number "512" should be "256" (2^8), or do we miss something?
> 
> This register doesn't seem to be described in ARM DDI 0487F.b,
> which is the official documentation and does contain the ARMv8.6
> material, including ARMv8.6-ECV.
> 
> Either you are looking at confidential information (and nobody
> can answer you in public), or obsolete information (and nobody
> knows what this is about).
> 
Well, it's alpha release version :( . Many thanks!

Thanks,
Keqian
> In any case, this is most probably a question for ARM's support
> team, and not the kernel mailing lists.
> 
> Thanks,
> 
>         M.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
