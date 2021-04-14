Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA521C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 657586113B
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 06:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 657586113B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BDEB4B6AD;
	Wed, 14 Apr 2021 02:52:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Ch+wOKTMyWK; Wed, 14 Apr 2021 02:52:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E6704B71A;
	Wed, 14 Apr 2021 02:52:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EFCB4B6A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 83bTKHXL63pb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 02:52:08 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD7BC4B6A2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 02:52:08 -0400 (EDT)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKtNz5FMxzNw2w;
 Wed, 14 Apr 2021 14:49:07 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 14:51:53 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, Marc Zyngier
 <maz@kernel.org>
Subject: [PATCH v3 0/2] kvm/arm64: Try stage2 block mapping for host device
 MMIO
Date: Wed, 14 Apr 2021 14:51:07 +0800
Message-ID: <20210414065109.8616-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
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

Hi,

We have two pathes to build stage2 mapping for MMIO regions.

Create time's path and stage2 fault path.

Patch#1 removes the creation time's mapping of MMIO regions
Patch#2 tries stage2 block mapping for host device MMIO at fault path

Changelog:

v3:
 - Do not need to check memslot boundary in device_rough_page_shift(). (Marc)

Thanks,
Keqian

Keqian Zhu (2):
  kvm/arm64: Remove the creation time's mapping of MMIO regions
  kvm/arm64: Try stage2 block mapping for host device MMIO

 arch/arm64/kvm/mmu.c | 75 +++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
