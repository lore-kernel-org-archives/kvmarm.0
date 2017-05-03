From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCHv2 0/2] kvm: arm/arm64: Fixes for race conditions
Date: Wed,  3 May 2017 15:17:50 +0100
Message-ID: <1493821072-29713-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9048B40AF9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 10:14:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0lDDmc4pVLJH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 10:14:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D6340960
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 10:14:56 -0400 (EDT)
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

These two patches fixes race conditions in the stage2 page table
handling of the KVM on arm/arm64.

Applies on next-20170503.

Changes since v1:
 http://lists.infradead.org/pipermail/linux-arm-kernel/2017-April/502867.html
 - Dropped patch for fixing mmu_notifier race condition, which couldn't be
   reproduced.
 - Added reviewed-by from Christoffer
 - Added new patch to fix another race condition

Suzuki K Poulose (2):
  kvm: arm/arm64: Fix race in resetting stage2 PGD
  kvm: arm/arm64: Fix use after free of stage2 page table

 arch/arm/kvm/mmu.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

-- 
2.7.4
