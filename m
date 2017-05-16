From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 0/2] kvm: arm/arm64: Fixes for race conditions
Date: Tue, 16 May 2017 10:34:53 +0100
Message-ID: <1494927295-29369-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D4D040187
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:31:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HT0M3kuUVo+x for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 05:31:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1138B400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 05:31:43 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, andreyknvl@google.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The patches fixes race conditions in stage2 pgd accesses.

Patch 1 is a fix up for the patch which has already been pushed to
kvmarm/master.

Patch 2 fixes a case where stage2 PGD could be free'd when we release
the kvm->mmu_lock to prevent VCPU starvation.

Applies on kvmarm/master tree

Changes since V2:
http://lists.infradead.org/pipermail/linux-arm-kernel/2017-May/504401.html

 - Patch 1 in V2 has been pushed to kvmarm/master. Added a fixup to the
   original patch to make sure we don't use cached stage2 pgd.
 - Patch 2: Handle cases where unmap_stage2_range may be called without
   checking the validity of stage2 pgd.


Changes since v1:
 http://lists.infradead.org/pipermail/linux-arm-kernel/2017-April/502867.html

 - Dropped patch for fixing mmu_notifier race condition, which couldn't be
   reproduced.
 - Added reviewed-by from Christoffer
 - Added new patch to fix another race condition

Suzuki K Poulose (2):
  kvm: arm/arm64: Force reading uncached stage2 PGD
  kvm: arm/arm64: Fix use after free of stage2 page table

 virt/kvm/arm/mmu.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

-- 
2.7.4
