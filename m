Return-Path: <SRS0=ijLG=C2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3583BC433E2
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 12:09:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 711152087D
	for <kvmarm@archiver.kernel.org>; Thu, 17 Sep 2020 12:09:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 711152087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBDE24B3D7;
	Thu, 17 Sep 2020 08:09:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pmub+29Oqeop; Thu, 17 Sep 2020 08:09:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C15214B36B;
	Thu, 17 Sep 2020 08:09:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C69414B2F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 08:09:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AVg0f52jKb0G for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2020 08:09:23 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A62E14B1C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2020 08:09:23 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 61C231A20D53158B4E33;
 Thu, 17 Sep 2020 20:09:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.175) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:09:10 +0800
From: Peng Liang <liangpeng10@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
Subject: [RFC v2 0/7] kvm: arm64: emulate ID registers
Date: Thu, 17 Sep 2020 20:00:54 +0800
Message-ID: <20200917120101.3438389-1-liangpeng10@huawei.com>
X-Mailer: git-send-email 2.26.2
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

v1 -> v2:
 - save the ID registers in sysreg file instead of a new struct
 - apply a checker before setting the value to the register
 - add doc for new KVM_CAP_ARM_CPU_FEATURE

Peng Liang (7):
  arm64: add a helper function to traverse arm64_ftr_regs
  arm64: introduce check_features
  kvm: arm64: save ID registers to sys_regs file
  kvm: arm64: introduce check_user
  kvm: arm64: implement check_user for ID registers
  kvm: arm64: make ID registers configurable
  kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension

 Documentation/virt/kvm/api.rst      |   8 +
 arch/arm64/include/asm/cpufeature.h |   4 +
 arch/arm64/include/asm/kvm_coproc.h |   2 +
 arch/arm64/include/asm/kvm_host.h   |   3 +
 arch/arm64/kernel/cpufeature.c      |  36 +++
 arch/arm64/kvm/arm.c                |   3 +
 arch/arm64/kvm/sys_regs.c           | 481 +++++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.h           |   6 +
 include/uapi/linux/kvm.h            |   1 +
 9 files changed, 532 insertions(+), 12 deletions(-)

-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
