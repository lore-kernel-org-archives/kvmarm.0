Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D94CC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:26:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1DB0D64E7A
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 13:26:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DB0D64E7A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8030C4B2D9;
	Mon,  1 Feb 2021 08:26:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2zJ4ImSOD9NR; Mon,  1 Feb 2021 08:26:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B934B3C3;
	Mon,  1 Feb 2021 08:26:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A4604B3C3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:26:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImUFu2Gr6hHt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 08:26:15 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10C9E4B2D9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 08:26:15 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DTpZT24CpzMTCD;
 Mon,  1 Feb 2021 21:24:33 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Feb 2021 21:26:00 +0800
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
To: Marc Zyngier <maz@kernel.org>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
 <f68d12f2-fa98-ebdd-3075-bfdcd690ee51@huawei.com>
 <9a64d4acd8e8b0b8c86143752b8c856d@kernel.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <3493e144-805a-033d-f90b-556a6d0d4bff@huawei.com>
Date: Mon, 1 Feb 2021 21:25:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <9a64d4acd8e8b0b8c86143752b8c856d@kernel.org>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: yubihong@huawei.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
 zhengchuan@huawei.com, Alex Williamson <alex.williamson@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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



On 2021/2/1 21:17, Marc Zyngier wrote:
> On 2021-02-01 13:12, Keqian Zhu wrote:
>> Hi Marc,
>>
>> Do you have time to have a look at this? Thanks ;-)
> 
> Not immediately. I'm busy with stuff that is planned to go
> in 5.12, which isn't the case for this series. I'll get to
> it eventually.
> 
> Thanks,
> 
>         M.
Sure, I am not eager. Please concentrate on your urgent work firstly. ;-) Thanks.

Keqian.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
