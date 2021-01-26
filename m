Return-Path: <SRS0=hkx2=G5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B86C433E6
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:43:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B823B229C9
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jan 2021 13:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B823B229C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437034B17D;
	Tue, 26 Jan 2021 08:43:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4n6Ca9FaAk31; Tue, 26 Jan 2021 08:43:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 366A44B2AB;
	Tue, 26 Jan 2021 08:43:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C4424B297
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:43:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZHnVavRXdK8O for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2021 08:43:29 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE9434B147
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2021 08:43:28 -0500 (EST)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DT5ZtPzjCXP;
 Tue, 26 Jan 2021 21:41:13 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:04 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [RFC PATCH v1 0/5] Enable CPU TTRem feature for stage-2
Date: Tue, 26 Jan 2021 21:41:57 +0800
Message-ID: <20210126134202.381996-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.128]
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

Hi all,
This series enable CPU TTRem feature for stage-2 page table and a RFC is sent
for some comments, thanks.

The ARMv8.4 TTRem feature offers 3 levels of support when changing block
size without changing any other parameters that are listed as requiring use
of break-before-make. And I found that maybe we can use this feature to make
some improvement for stage-2 page table and the following explains what
TTRem exactly does for the improvement.

If migration of a VM with hugepages is canceled midway, KVM will adjust the
stage-2 table mappings back to block mappings. We currently use BBM to replace
the table entry with a block entry. Take adjustment of 1G block mapping as an
example, with BBM procedures, we have to invalidate the old table entry first,
flush TLB and unmap the old table mappings, right before installing the new
block entry.

So there will be a bit long period when the old table entry is invalid before
installation of the new block entry, if other vCPUs access any guest page within
the 1G range during this period and find the table entry invalid, they will all
exit from guest with a translation fault. Actually, these translation faults
are not necessary, because the block mapping will be built later. Besides, KVM
will still try to build 1G block mappings for these spurious translation faults,
and will perform cache maintenance operations, page table walk, etc.

In summary, the spurious faults are caused by invalidation in BBM procedures.
Approaches of TTRem level 1,2 ensure that there will not be a moment when the
old table entry is invalid before installation of the new block entry. However,
level-2 method will possibly lead to a TLB conflict which is bothering, so we
use nT both at level-1 and level-2 case to avoid handling TLB conflict aborts.

For an implementation which meets level 1 or level 2, the CPU has two responses
to choose when accessing a block table entry with nT bit set: Firstly, CPU will
generate a translation fault, the effect of this response is simier to BBM.
Secondly, CPU can use the block entry for translation. So with the second kind
of implementation, the above described spurious translations can be prevented.

Yanan Wang (5):
  KVM: arm64: Detect the ARMv8.4 TTRem feature
  KVM: arm64: Add an API to get level of TTRem supported by hardware
  KVM: arm64: Support usage of TTRem in guest stage-2 translation
  KVM: arm64: Add handling of coalescing tables into a block mapping
  KVM: arm64: Adapt page-table code to new handling of coalescing tables

 arch/arm64/include/asm/cpucaps.h    |  3 +-
 arch/arm64/include/asm/cpufeature.h | 13 ++++++
 arch/arm64/kernel/cpufeature.c      | 10 +++++
 arch/arm64/kvm/hyp/pgtable.c        | 62 +++++++++++++++++++++++------
 4 files changed, 74 insertions(+), 14 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
