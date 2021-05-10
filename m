Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED9DC433ED
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 01:12:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D17A613DB
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 01:12:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D17A613DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9734B580;
	Sun,  9 May 2021 21:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hG66nPDqLABI; Sun,  9 May 2021 21:12:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB9E4B4EB;
	Sun,  9 May 2021 21:12:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D87CF4B4EB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 21:12:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7DWA3aBG7bNH for <kvmarm@lists.cs.columbia.edu>;
 Sun,  9 May 2021 21:12:30 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A109F4B4CB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  9 May 2021 21:12:30 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fdjdz0tPBzlcpf;
 Mon, 10 May 2021 09:10:15 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0;
 Mon, 10 May 2021 09:12:22 +0800
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed
 connect"
To: Marc Zyngier <maz@kernel.org>, Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
 <8735uxvajh.wl-maz@kernel.org>
From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <cfb68374-a7bf-1eb4-86cf-77c57f7fe9e5@hisilicon.com>
Date: Mon, 10 May 2021 09:12:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8735uxvajh.wl-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.67.77.175]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
 stable@vger.kernel.org, alex.williamson@redhat.com,
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

Hi Marc,

On 2021/5/8 17:29, Marc Zyngier wrote:
> On Sat, 08 May 2021 08:11:52 +0100,
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>>
>> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
>>
>> The reverted commit may cause VM freeze on arm64 platform.
>> Because on arm64 platform, stop a consumer will suspend the VM,
>> the VM will freeze without a start consumer
> 
> It also unconditionally calls del_consumer on the producer, which
> isn't exactly expected.
> 
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> 
> Reported-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Thanks for the tag, it works with this patch, So:
Tested-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

I shall invite you to have a drink for the quick debug.
Anyway, thank you again.

Shaokun

> Suggested-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Fixes: a979a6aa009f ("irqbypass: do not start cons/prod when failed connect")
> Link: https://lore.kernel.org/r/3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com
> Cc: stable@vger.kernel.org
> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
