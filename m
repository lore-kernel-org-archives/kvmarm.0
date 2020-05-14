Return-Path: <SRS0=MYlw=64=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FF4C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 09:17:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FAE320675
	for <kvmarm@archiver.kernel.org>; Thu, 14 May 2020 09:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FAE320675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665C74B287;
	Thu, 14 May 2020 05:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5BQQ56hSerlo; Thu, 14 May 2020 05:17:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66E5A4B289;
	Thu, 14 May 2020 05:17:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AE8C4B286
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 05:17:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x23DPUyrp8y7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2020 05:17:13 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE6444B287
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2020 05:17:12 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id ABBD6B17E2B7EA933AF5;
 Thu, 14 May 2020 17:17:09 +0800 (CST)
Received: from [10.173.221.230] (10.173.221.230) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 14 May 2020 17:17:04 +0800
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
From: zhukeqian <zhukeqian1@huawei.com>
Subject: [Question] Hardware management of stage2 page dirty state
Message-ID: <0767678d-d580-eb02-c2f0-423b16526736@huawei.com>
Date: Thu, 14 May 2020 17:16:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Marc Zyngier <maz@kernel.org>
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

Hi Catalin,

I have some questions after deep reading your patch
https://patchwork.kernel.org/patch/8824261/ which enables hardware updates
of the Access Flag for Stage 2 page tables.

I notice that at the bottom of commit message, you said the following words:
"After some digging through the KVM code, I concluded that hardware DBM
(dirty bit management) support is not feasible for Stage 2. A potential
user would be dirty logging but this requires a different bitmap exposed
to Qemu and, to avoid races, the stage 2 mappings need to be mapped
read-only on clean, writable on fault. This assumption simplifies the
hardware Stage 2 AF support."

I have three questions here.

1. I do not understand the reason well about "not feasible". Does the main reason
   for this is the "races" you referred?

2. What does the "races" refer to? Do you mean the races between [hardware S2 DBM]
   and [dirty information collection that executed by KVM]?

   During VM live migration, Qemu will send dirty page iteratively and finally stop
   VM when dirty pages is not too much. We may miss dirty pages during each iteration
   before VM stop, but there are no races after VM stop, so we won't miss dirty pages
   finally. It seems that "races" is not a convinced reason for "not feasible".

3. You said that disable hardware S2 DBM support can simplify the hardware S2 AF support.
   Could you please explain the reason in detail?



Expect your reply. Many Thanks!

Thanks,
Keqian.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
