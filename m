Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCA7C433C1
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:17:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C29FD20793
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 14:17:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C29FD20793
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A484B1DA;
	Thu,  3 Dec 2020 09:17:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CdghbsxbOXuu; Thu,  3 Dec 2020 09:17:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B92E4B190;
	Thu,  3 Dec 2020 09:17:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F98F4B196
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:17:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QCLw7chc+Qea for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 09:16:59 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7106F4B190
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 09:16:59 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CmyZ16TdSzhm1Q;
 Thu,  3 Dec 2020 22:16:25 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Dec 2020 22:16:43 +0800
Subject: Re: [PATCH v2 0/2] KVM: arm64: Some fixes and code adjustments for
 pvtime ST
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <a87412a0-e0ca-d344-550a-91690ce3a612@huawei.com>
Date: Thu, 3 Dec 2020 22:16:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Found that this series is not applied for now.
Does it need some modification? Wish you can pick it up :-)

Thanks,
Keqian

On 2020/8/17 19:07, Keqian Zhu wrote:
> During picking up pvtime LPT support for arm64, I do some trivial fixes for
> pvtime ST.
> 
> change log:
> 
> v2:
>  - Add Andrew's and Steven's R-b.
>  - Correct commit message of the first patch.
>  - Drop the second patch.
> 
> Keqian Zhu (2):
>   KVM: arm64: Some fixes of PV-time interface document
>   KVM: arm64: Use kvm_write_guest_lock when init stolen time
> 
>  Documentation/virt/kvm/arm/pvtime.rst | 6 +++---
>  arch/arm64/kvm/pvtime.c               | 6 +-----
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
