Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CDDC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 01:19:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 59399207AE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 01:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59399207AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF70F4B26C;
	Sun, 17 Jan 2021 20:19:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S1c5-CfgTEdU; Sun, 17 Jan 2021 20:19:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AE374B25B;
	Sun, 17 Jan 2021 20:19:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 414444B256
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jan 2021 20:19:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JfjiCZIni-jJ for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Jan 2021 20:19:06 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E7D94B254
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jan 2021 20:19:05 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DJv6X6JWVzj3w7;
 Mon, 18 Jan 2021 09:17:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 09:18:52 +0800
Subject: Re: [PATCH] kvm: arm64: Properly align the end address of table walk
To: Will Deacon <will@kernel.org>
References: <20210115095307.12912-1-zhukeqian1@huawei.com>
 <20210115102334.GA14167@willie-the-truck>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <a184c21f-2b1f-bd00-5ca9-be7649b33ccd@huawei.com>
Date: Mon, 18 Jan 2021 09:18:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115102334.GA14167@willie-the-truck>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>, Marc Zyngier <maz@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Robin Murphy <robin.murphy@arm.com>,
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



On 2021/1/15 18:23, Will Deacon wrote:
> On Fri, Jan 15, 2021 at 05:53:07PM +0800, Keqian Zhu wrote:
>> When align the end address, ought to use its original value.
>>
>> Fixes: b1e57de62cfb ("KVM: arm64: Add stand-alone page-table walker infrastructure")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  arch/arm64/kvm/hyp/pgtable.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> index bdf8e55ed308..670b0ef12440 100644
>> --- a/arch/arm64/kvm/hyp/pgtable.c
>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> @@ -296,7 +296,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>>  	struct kvm_pgtable_walk_data walk_data = {
>>  		.pgt	= pgt,
>>  		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
>> -		.end	= PAGE_ALIGN(walk_data.addr + size),
>> +		.end	= PAGE_ALIGN(addr + size),
>>  		.walker	= walker,
> 
> Hmm, this is a change in behaviour, no (consider the case where both 'addr'
> and 'size' are misaligned)? The current code is consistent with the
> kerneldoc in asm/kvm_pgtable.h, so I don't see the motivation to change it.
> 
> Did you hit a bug somewhere?
> 
> Will
> .
>
Not hit a bug, I just read the code to implement a new idea of stage2 DBM
support [1]. Yes, according to doc, this is not an issue ("The offset of
@addr within a page is ignored."). Sorry to disturb ;-).

[1] https://lore.kernel.org/kvmarm/fd26654b-8258-061c-2a69-90b961c1c71b@huawei.com/

Thanks,
Keqian





_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
