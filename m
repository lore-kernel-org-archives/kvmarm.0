Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6530FC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5FB5613DF
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5FB5613DF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FFD34B648;
	Wed, 14 Apr 2021 07:24:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2lESdRtCCYQm; Wed, 14 Apr 2021 07:24:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A83A4B5CE;
	Wed, 14 Apr 2021 07:24:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 562BC4B5CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m0oTFZ54irwP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:24:18 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D78E4B504
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:18 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FL0Rm4gxQztVy2;
 Wed, 14 Apr 2021 19:21:56 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:03 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 00/16] kvm/arm: Align the VMID allocation with the arm64
 ASID one
Date: Wed, 14 Apr 2021 12:22:56 +0100
Message-ID: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.47.82.32]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, julien@xen.org, maz@kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, will@kernel.org
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

This is an attempt to revive this series originally posted by
Julien Grall[1]. The main motive to work on this now is because
of the requirement to have Pinned KVM VMIDs and the RFC discussion
for the same basically suggested[2] to have a common/better vmid
allocator for KVM which this series provides.
 
Major Changes from v3:

-Changes related to Pinned ASID support.
-Changes to take care KPTI related bits reservation.
-Dropped support for 32 bit KVM.
-Rebase to 5.12-rc7

Individual patches have change history for any major changes
from v3.

Tests were performed on a HiSilicon D06 platform and so far not observed
any regressions.

For ASID allocation,

Avg of 10 runs(hackbench -s 512 -l 200 -g 300 -f 25 -P),
5.12-rc7: Time:18.8119
5.12-rc7+v4: Time: 18.459

~1.8% improvement.

For KVM VMID,

The measurement was made with maxcpus set to 8 and with the
number of VMID limited to 4-bit. The test involves running
concurrently 40 guests with 2 vCPUs. Each guest will then
execute hackbench 5 times before exiting.

The performance difference between the current algo and the
new one are(ag. of 10 runs):
    - 1.9% less exit from the guest
    - 0.7% faster

For complete series, please see,
 https://github.com/hisilicon/kernel-dev/tree/private-v5.12-rc7-asid-v4

Please take a look and let me know your feedback.

Thanks,
Shameer
[1].https://patchwork.kernel.org/project/linux-arm-kernel/cover/20190724162534.7390-1-julien.grall@arm.com/
[2].https://lore.kernel.org/linux-arm-kernel/20210222155338.26132-6-shameerali.kolothum.thodi@huawei.com/T/#mff3129997739e2747172f4a2e81fd66be91ffea4
--------
From V3:
--------
Hi all,

This patch series is moving out the ASID allocator in a separate file in order
to re-use it for the VMID. The benefits are:
    - CPUs are not forced to exit on a roll-over.
    - Context invalidation is now per-CPU rather than
      broadcasted.

There are no performance regression on the fastpath for ASID allocation.
Actually on the hackbench measurement (300 hackbench) it was .7% faster.

The measurement was made on a Seattle based SoC (8 CPUs), with the
number of VMID limited to 4-bit. The test involves running concurrently 40
guests with 2 vCPUs. Each guest will then execute hackbench 5 times
before exiting.

The performance difference (on 5.1-rc1) between the current algo and the
new one are:
    - 2.5% less exit from the guest
    - 22.4% more flush, although they are now local rather than broadcasted
    - 0.11% faster (just for the record)

The ASID allocator rework to make it generic has been divided in multiple
patches to make the review easier.

A branch with the patch based on 5.3-rc1 can be found:

http://xenbits.xen.org/gitweb/?p=people/julieng/linux-arm.git;a=shortlog;h=refs/heads/vmid-rework/v3

For all the changes see in each patch.

Best regards,

Julien Grall (13):
  arm64/mm: Introduce asid_info structure and move
    asid_generation/asid_map to it
  arm64/mm: Move active_asids and reserved_asids to asid_info
  arm64/mm: Move bits to asid_info
  arm64/mm: Move the variable lock and tlb_flush_pending to asid_info
  arm64/mm: Remove dependency on MM in new_context
  arm64/mm: Introduce NUM_CTXT_ASIDS
  arm64/mm: Split asid_inits in 2 parts
  arm64/mm: Split the function check_and_switch_context in 3 parts
  arm64/mm: Introduce a callback to flush the local context
  arm64: Move the ASID allocator code in a separate file
  arm64/lib: Add an helper to free memory allocated by the ASID
    allocator
  arch/arm64: Introduce a capability to tell whether 16-bit VMID is
    available
  kvm/arm: Align the VMID allocation with the arm64 ASID one

Shameer Kolothum (3):
  arm64/mm: Move Pinned ASID related variables to asid_info
  arm64/mm: Split the arm64_mm_context_get/put
  arm64/mm: Introduce a callback to set reserved bits

 arch/arm64/include/asm/cpucaps.h   |   3 +-
 arch/arm64/include/asm/kvm_asm.h   |   4 +-
 arch/arm64/include/asm/kvm_host.h  |   5 +-
 arch/arm64/include/asm/kvm_mmu.h   |   7 +-
 arch/arm64/include/asm/lib_asid.h  |  87 +++++++++
 arch/arm64/kernel/cpufeature.c     |   9 +
 arch/arm64/kvm/arm.c               | 124 +++++--------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |   6 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  10 +-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  10 +-
 arch/arm64/kvm/mmu.c               |   1 -
 arch/arm64/lib/Makefile            |   2 +
 arch/arm64/lib/asid.c              | 264 +++++++++++++++++++++++++++
 arch/arm64/mm/context.c            | 283 ++++-------------------------
 14 files changed, 469 insertions(+), 346 deletions(-)
 create mode 100644 arch/arm64/include/asm/lib_asid.h
 create mode 100644 arch/arm64/lib/asid.c

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
