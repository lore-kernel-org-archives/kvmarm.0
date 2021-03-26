Return-Path: <SRS0=1o63=IY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD0AC433C1
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 03:17:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 22B0261A3F
	for <kvmarm@archiver.kernel.org>; Fri, 26 Mar 2021 03:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22B0261A3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 907E84B477;
	Thu, 25 Mar 2021 23:17:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5UVIOqiFFkAh; Thu, 25 Mar 2021 23:17:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F55E4B45B;
	Thu, 25 Mar 2021 23:17:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203694B44C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 23:17:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vLQVoik6DWpN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 23:17:37 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617C54B0E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 23:17:37 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F66Xg5MWCzPmsB;
 Fri, 26 Mar 2021 11:14:59 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 11:17:25 +0800
From: Yanan Wang <wangyanan55@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, "Alexandru
 Elisei" <alexandru.elisei@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 0/2] KVM: arm64: Improve efficiency of stage2 page table
Date: Fri, 26 Mar 2021 11:16:52 +0800
Message-ID: <20210326031654.3716-1-wangyanan55@huawei.com>
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

Hi,

This is a new version of the series [1] that I have posted before. It makes some
efficiency improvement of stage2 page table code and there are some test results
to quantify the benefit of each patch.
[1] v2: https://lore.kernel.org/lkml/20210310094319.18760-1-wangyanan55@huawei.com/

Although there hasn't been any feedback about v2, I am certain that there should
be a big change for the series after plenty of discussion with Alexandru Elisei.
A conclusion was drew that CMOs are still needed for the scenario of coalescing
tables, and as a result the benefit of patch #3 in v2 becomes rather little
judging from the test results. So drop this patch and keep the others which
still remain meaningful.

Changelogs:
v2->v3:
- drop patch #3 in v2
- retest v3 based on v5.12-rc2

v1->v2:
- rebased on top of mainline v5.12-rc2
- also move CMOs of I-cache to the fault handlers
- retest v2 based on v5.12-rc2
- v1: https://lore.kernel.org/lkml/20210208112250.163568-1-wangyanan55@huawei.com/

About this v3 series:
Patch #1:
We currently uniformly permorm CMOs of D-cache and I-cache in function
user_mem_abort before calling the fault handlers. If we get concurrent
guest faults(e.g. translation faults, permission faults) or some really
unnecessary guest faults caused by BBM, CMOs for the first vcpu are
necessary while the others later are not.

By moving CMOs to the fault handlers, we can easily identify conditions
where they are really needed and avoid the unnecessary ones. As it's a
time consuming process to perform CMOs especially when flushing a block
range, so this solution reduces much load of kvm and improve efficiency
of the page table code.

So let's move both clean of D-cache and invalidation of I-cache to the
map path and move only invalidation of I-cache to the permission path.
Since the original APIs for CMOs in mmu.c are only called in function
user_mem_abort, we now also move them to pgtable.c.

The following results represent the benefit of patch #1 alone, and they
were tested by [2] (kvm/selftest) that I have posted recently.
[2] https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/

When there are muitiple vcpus concurrently accessing the same memory region,
we can test the execution time of KVM creating new mappings, updating the
permissions of old mappings from RO to RW, and rebuilding the blocks after
they have been split.

hardware platform: HiSilicon Kunpeng920 Server
host kernel: Linux mainline v5.12-rc2

cmdline: ./kvm_page_table_test -m 4 -s anonymous -b 1G -v 80
           (80 vcpus, 1G memory, page mappings(normal 4K))
KVM_CREATE_MAPPINGS: before 104.35s -> after  90.42s  +13.35%
KVM_UPDATE_MAPPINGS: before  78.64s -> after  75.45s  + 4.06%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 40
           (40 vcpus, 20G memory, block mappings(THP 2M))
KVM_CREATE_MAPPINGS: before  15.66s -> after   6.92s  +55.80%
KVM_UPDATE_MAPPINGS: before 178.80s -> after 123.35s  +31.00%
KVM_REBUILD_BLOCKS:  before 187.34s -> after 131.76s  +30.65%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 40
           (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
KVM_CREATE_MAPPINGS: before 104.54s -> after   3.70s  +96.46%
KVM_UPDATE_MAPPINGS: before 174.20s -> after 115.94s  +33.44%
KVM_REBUILD_BLOCKS:  before 103.95s -> after   2.96s  +97.15%

Patch #2:
A new method to distinguish cases of memcache allocations is introduced.
By comparing fault_granule and vma_pagesize, cases that require allocations
from memcache and cases that don't can be distinguished completely.

Yanan Wang (2):
  KVM: arm64: Move CMOs from user_mem_abort to the fault handlers
  KVM: arm64: Distinguish cases of memcache allocations completely

 arch/arm64/include/asm/kvm_mmu.h | 31 ---------------
 arch/arm64/kvm/hyp/pgtable.c     | 68 +++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c             | 48 ++++++++--------------
 3 files changed, 69 insertions(+), 78 deletions(-)

-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
