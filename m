Return-Path: <SRS0=TLTx=B3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E71C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:41:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C77B72072D
	for <kvmarm@archiver.kernel.org>; Mon, 17 Aug 2020 08:41:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C77B72072D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D66B4BF7D;
	Mon, 17 Aug 2020 04:41:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i9ZLCkEvH++S; Mon, 17 Aug 2020 04:41:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7360B4BF7A;
	Mon, 17 Aug 2020 04:41:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C4804BF91
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:41:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9LItYpOiU9g0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2020 04:41:29 -0400 (EDT)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A6D44BF6E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2020 04:41:29 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 724AC236C0FF1FBF5E6D;
 Mon, 17 Aug 2020 16:41:22 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 16:41:12 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
Date: Mon, 17 Aug 2020 16:41:05 +0800
Message-ID: <20200817084110.2672-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
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

Hi all,

This patch series picks up the LPT pvtime feature originally developed
by Steven Price: https://patchwork.kernel.org/cover/10726499/

Backgroud:

There is demand for cross-platform migration, which means we have to
solve different CPU features and arch counter frequency between hosts.
This patch series can solve the latter problem.

About LPT:

This implements support for Live Physical Time (LPT) which provides the
guest with a method to derive a stable counter of time during which the
guest is executing even when the guest is being migrated between hosts
with different physical counter frequencies.

Changes on Steven Price's work:
1. LPT structure: use symmatical semantics of scale multiplier, and use
   fraction bits instead of "shift" to make everything clear.
2. Structure allocation: host kernel does not allocates the LPT structure,
   instead it is allocated by userspace through VM attributes. The save/restore
   functionality can be removed.
3. Since LPT structure just need update once for each guest run, add a flag to
   indicate the update status. This has two benifits: 1) avoid multiple update
   by each vCPUs. 2) If the update flag is not set, then return NOT SUPPORT for
   coressponding guest HVC call.
4. Add VM device attributes interface for userspace configuration.
5. Add a base LPT read/write layer to reduce code.
6. Support ptimer scaling.
7. Support timer event stream translation.

Things need concern:
1. https://developer.arm.com/docs/den0057/a needs update.
2. If a guest fails to initialize and use LPT, when it migrates to a host with
   different native frequency, it will see the virtual counter jump. However
   this concern is not a problem.
   1) Guest does not support LPT or host does not enable LPT: we won't migrate
      guest to a host with different frequency.
   2) Guest kernel faces problem when initilize LPT: guest can not boot up, so
      counter jump is not a problem at this situation.


Patch 2 and 3 implement host KVM part.
Patch 4 and 5 implement guest driver part.

Keqian Zhu (5):
  KVM: arm64: Document pvtime LPT interface
  KVM: arm64: Support Live Physical Time reporting
  KVM: arm64: Provide VM device attributes for LPT time
  clocksource: arm_arch_timer: Add pvtime LPT initialization
  clocksource: arm_arch_timer: Use pvtime LPT

 Documentation/virt/kvm/arm/pvtime.rst |  78 +++++++++++--
 Documentation/virt/kvm/devices/vm.rst |  30 +++++
 arch/arm64/include/asm/arch_timer.h   | 179 ++++++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h     |  14 +++
 arch/arm64/include/uapi/asm/kvm.h     |   5 +
 arch/arm64/kvm/arm.c                  |  71 ++++++++++++
 arch/arm64/kvm/hypercalls.c           |   5 +
 arch/arm64/kvm/pvtime.c               | 212 +++++++++++++++++++++++++++++++++-
 drivers/clocksource/arm_arch_timer.c  | 120 +++++++++++++++----
 9 files changed, 669 insertions(+), 45 deletions(-)

-- 
1.8.3.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
