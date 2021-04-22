Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45D9C433B4
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 07:41:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 36544613D5
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 07:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36544613D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB724B4AA;
	Thu, 22 Apr 2021 03:41:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K6bDQlGhJKiY; Thu, 22 Apr 2021 03:41:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B98E4B4B4;
	Thu, 22 Apr 2021 03:41:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 184764B3E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YpZJqye70xOK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 03:41:46 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BE334B4AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 03:41:46 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FQq7g5J1TzjbVK;
 Thu, 22 Apr 2021 15:39:43 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 22 Apr 2021 15:41:34 +0800
Subject: Re: [PATCH v4 1/2] kvm/arm64: Remove the creation time's mapping of
 MMIO regions
To: Gavin Shan <gshan@redhat.com>
References: <20210415140328.24200-1-zhukeqian1@huawei.com>
 <20210415140328.24200-2-zhukeqian1@huawei.com>
 <ad39c796-2778-df26-b0c6-231e7626a747@redhat.com>
 <bd4d2cfc-37b9-f20a-5a5c-ed352d1a46dc@huawei.com>
 <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <9eb47a6c-3c5c-cb4a-d1de-1a3ce1b60a87@huawei.com>
Date: Thu, 22 Apr 2021 15:41:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f13bfc39-bee6-4562-fefc-76051bbf9735@redhat.com>
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Santosh Shukla <sashukla@nvidia.com>,
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

Hi Gavin,

On 2021/4/22 10:12, Gavin Shan wrote:
> Hi Keqian,
> 
> On 4/21/21 4:28 PM, Keqian Zhu wrote:
>> On 2021/4/21 14:38, Gavin Shan wrote:
>>> On 4/16/21 12:03 AM, Keqian Zhu wrote:
>>>> The MMIO regions may be unmapped for many reasons and can be remapped
>>>> by stage2 fault path. Map MMIO regions at creation time becomes a
>>>> minor optimization and makes these two mapping path hard to sync.
>>>>
>>>> Remove the mapping code while keep the useful sanity check.
>>>>
>>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>> ---
>>>>    arch/arm64/kvm/mmu.c | 38 +++-----------------------------------
>>>>    1 file changed, 3 insertions(+), 35 deletions(-)
>>>>
>>>
>>> After removing the logic to create stage2 mapping for VM_PFNMAP region,
>>> I think the "do { } while" loop becomes unnecessary and can be dropped
>>> completely. It means the only sanity check is to see if the memory slot
>>> overflows IPA space or not. In that case, KVM_MR_FLAGS_ONLY can be
>>> ignored because the memory slot's base address and length aren't changed
>>> when we have KVM_MR_FLAGS_ONLY.
>> Maybe not exactly. Here we do an important sanity check that we shouldn't
>> log dirty for memslots with VM_PFNMAP.
>>
> 
> Yeah, Sorry that I missed that part. Something associated with Santosh's
> patch. The flag can be not existing until the page fault happened on
> the vma. In this case, the check could be not working properly.
> 
>   [PATCH] KVM: arm64: Correctly handle the mmio faulting
Yeah, you are right.

If that happens, we won't try to use block mapping for memslot with VM_PFNMAP.
But it keeps a same logic with old code.

1. When without dirty-logging, we won't try block mapping for it, and we'll
finally know that it's device, so won't try to do adjust THP (Transparent Huge Page)
for it.
2. If userspace wrongly enables dirty logging for this memslot, we'll force_pte for it.

Thanks,
Keqian
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
