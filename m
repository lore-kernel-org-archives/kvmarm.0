Return-Path: <SRS0=cLXx=CZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A05C43461
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 01:52:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D3EF2078D
	for <kvmarm@archiver.kernel.org>; Wed, 16 Sep 2020 01:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D3EF2078D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6264B300;
	Tue, 15 Sep 2020 21:52:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9dF0mKK0RXWk; Tue, 15 Sep 2020 21:52:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9214B2EA;
	Tue, 15 Sep 2020 21:52:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B425F4B2E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 21:51:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i1s2RCwqPhAZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 21:51:58 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB8224B2E0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 21:51:57 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 8B4CFF0684C28E4090F6;
 Wed, 16 Sep 2020 09:51:53 +0800 (CST)
Received: from [127.0.0.1] (10.74.185.4) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Wed, 16 Sep 2020
 09:51:42 +0800
Subject: Re: [PATCH] KVM: arm64: fix doc warnings in mmu code
To: Marc Zyngier <maz@kernel.org>
References: <1600175890-7435-1-git-send-email-tanxiaofei@huawei.com>
 <7bcb5fd9b6490e98cfa8aa22496a8a71@kernel.org>
From: Xiaofei Tan <tanxiaofei@huawei.com>
Message-ID: <5F616FAE.4030006@huawei.com>
Date: Wed, 16 Sep 2020 09:51:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <7bcb5fd9b6490e98cfa8aa22496a8a71@kernel.org>
X-Originating-IP: [10.74.185.4]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linuxarm@huawei.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

OK, I will send v2 patch based on kvmarm-next branch. thanks.

On 2020/9/15 21:47, Marc Zyngier wrote:
> Hi Xiaofei,
> 
> On 2020-09-15 14:18, Xiaofei Tan wrote:
>> Fix following warnings caused by mismatch bewteen function parameters
>> and comments.
>> arch/arm64/kvm/mmu.c:119: warning: Function parameter or member
>> 'pudp'not described in 'stage2_dissolve_pud'
>> arch/arm64/kvm/mmu.c:119: warning: Excess function parameter 'pud'
>> description in 'stage2_dissolve_pud'
> 
> [...]
> 
> Most of this code is being deleted. If you want to fix comments,
> please look at what is in -next.
> 
> Thanks,
> 
>         M.

-- 
 thanks
tanxiaofei

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
