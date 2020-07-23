Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76510C433E1
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 08:57:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 08A0A2071A
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 08:57:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A0A2071A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C2F94B334;
	Thu, 23 Jul 2020 04:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id T5qfWkOA+7Ld; Thu, 23 Jul 2020 04:57:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808434B30C;
	Thu, 23 Jul 2020 04:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0911E4B2BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 04:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CoOd8DhGhOLJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 04:57:05 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FF3F4B1A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 04:57:05 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 43C37B386A8CE420A927;
 Thu, 23 Jul 2020 16:56:59 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 16:56:47 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: kvm-unit-tests: Question about the "no interrupt when timer is
 disabled" case
Message-ID: <fd421647-6526-41dd-ef3a-c714f9d513d6@huawei.com>
Date: Thu, 23 Jul 2020 16:56:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Alexandru,

I've noticed that the timer case will fail in the -stable 4.19 kernel.
The log is as follows:

FAIL: vtimer-busy-loop: no interrupt when timer is disabled
FAIL: vtimer-busy-loop: interrupt signal no longer pending

And it's because the related fix [16e604a437c8, "KVM: arm/arm64: vgic:
Reevaluate level sensitive interrupts on enable"] hasn't been backported
to the stable tree.

Just out of curiosity, _without_ this fix, had you actually seen the
guest getting into trouble due to an un-retired level-sensitive
interrupt and your patch fixed it? Or this was found by code inspection?

Take the exact vtimer case as an example, is it possible that the Linux
guest would disable the vtimer (the input interrupt line is driven to 0
but the old KVM doesn't take this into account) and potentially hit this
issue? I'm not familiar with it.

One of our internal tree is based on the stable 4.19 and I'm sure this
fix is not included. But I havn't received any bad reports from our
users yet. But if there's any potential problem without this fix, it'd
good to get it properly backported. I can help to send a backport
request if so.


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
