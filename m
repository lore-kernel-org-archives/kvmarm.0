Return-Path: <SRS0=JN4F=7B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E70C433DF
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 09:43:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60E70207D3
	for <kvmarm@archiver.kernel.org>; Tue, 19 May 2020 09:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60E70207D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD8E4B085;
	Tue, 19 May 2020 05:43:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5N-52I6BbxJN; Tue, 19 May 2020 05:43:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F0B4B109;
	Tue, 19 May 2020 05:43:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A474B0E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 05:43:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WAfuKS-SmOEt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 May 2020 05:43:15 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 583784B085
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 May 2020 05:43:15 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id E2957992080CA34DBE1F;
 Tue, 19 May 2020 17:43:11 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.213) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0;
 Tue, 19 May 2020 17:43:01 +0800
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>
From: Xiang Zheng <zhengxiang9@huawei.com>
Subject: [RFC] Use SMMU HTTU for DMA dirty page tracking
Message-ID: <b926ec0b-fe87-0792-c41d-acad56c656a4@huawei.com>
Date: Tue, 19 May 2020 17:42:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Language: en-US
X-Originating-IP: [10.173.221.213]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, wangzhou1@hisilicon.com,
 prime.zeng@hisilicon.com, Will Deacon <will@kernel.org>
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

Hi all,

Is there any plan for enabling SMMU HTTU?

I have seen the patch locates in the SVA series patch, which adds
support for HTTU:
    https://www.spinics.net/lists/arm-kernel/msg798694.html

HTTU reduces the number of access faults on SMMU fault queue
(permission faults also benifit from it).

Besides reducing the faults, HTTU also helps to track dirty pages for
device DMA. Is it feasible to utilize HTTU to get dirty pages on device
DMA during VFIO live migration?

If SMMU can track dirty pages, devices are not required to implement
additional dirty pages tracking to support VFIO live migration.

-- 
Thanks,
Xiang

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
