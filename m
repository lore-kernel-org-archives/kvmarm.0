Return-Path: <SRS0=hhnY=BX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F16C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 06:14:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B25D620656
	for <kvmarm@archiver.kernel.org>; Thu, 13 Aug 2020 06:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B25D620656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7E84B83A;
	Thu, 13 Aug 2020 02:14:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Prgz57LS6fQy; Thu, 13 Aug 2020 02:14:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F2D4B972;
	Thu, 13 Aug 2020 02:14:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC184B8DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 02:14:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QyNmWVGUoigF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Aug 2020 02:14:13 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D28614B7CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Aug 2020 02:14:12 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 544B24AC5B9D6D66A30A;
 Thu, 13 Aug 2020 14:14:09 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 13 Aug 2020 14:14:00 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC 0/4] kvm: arm64: emulate ID registers
Date: Thu, 13 Aug 2020 14:05:13 +0800
Message-ID: <20200813060517.2360048-1-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org
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

In AArch64, guest will read the same values of the ID regsiters with
host.  Both of them read the values from arm64_ftr_regs.  This patch
series add support to emulate and configure ID registers so that we can
control the value of ID registers that guest read.

Peng Liang (4):
  arm64: add a helper function to traverse arm64_ftr_regs
  kvm: arm64: emulate the ID registers
  kvm: arm64: make ID registers configurable
  kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension

 arch/arm64/include/asm/cpufeature.h |  2 ++
 arch/arm64/include/asm/kvm_host.h   |  2 ++
 arch/arm64/kernel/cpufeature.c      | 13 ++++++++
 arch/arm64/kvm/arm.c                | 21 ++++++++++++
 arch/arm64/kvm/sys_regs.c           | 50 ++++++++++++++++++++++-------
 include/uapi/linux/kvm.h            | 12 +++++++
 6 files changed, 89 insertions(+), 11 deletions(-)

-- 
2.18.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
