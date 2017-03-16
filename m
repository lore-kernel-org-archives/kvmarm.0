From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] kvm: arm/arm64: Simplify lock relaxation in stage2_wp_range
Date: Thu, 16 Mar 2017 18:24:34 +0000
Message-ID: <1489688674-17692-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DECF40187
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 14:25:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mgs3Zop-vJye for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Mar 2017 14:25:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 671D940017
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Mar 2017 14:25:27 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Add checks to make sure that kvm->mmu_lock is held while calling
stage2_wp_range. Also avoid explicit checks already done by cond_resched_lock().

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
[ Added assert_spin_locked check ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7628ef1..37e67f5 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1162,6 +1162,8 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	pgd_t *pgd;
 	phys_addr_t next;
 
+	assert_spin_locked(&kvm->mmu_lock);
+
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		/*
@@ -1171,8 +1173,7 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
 		 * will also starve other vCPUs.
 		 */
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock))
-			cond_resched_lock(&kvm->mmu_lock);
+		cond_resched_lock(&kvm->mmu_lock);
 
 		next = stage2_pgd_addr_end(addr, end);
 		if (stage2_pgd_present(*pgd))
-- 
2.7.4
