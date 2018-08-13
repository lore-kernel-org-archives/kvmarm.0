From: Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 1/5] KVM: arm64: Remove pgd_lock
Date: Mon, 13 Aug 2018 17:04:53 +0100
Message-ID: <20180813160453.38032-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6769E4A1FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 12:05:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vx4cooMNFBgX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 12:05:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5916F4A1DE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 12:05:11 -0400 (EDT)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The lock has never been used and the page tables are protected by
mmu_lock in struct kvm.

Signed-off-by: Steven Price <steven.price@arm.com>
CC: Marc Zyngier <marc.zyngier@arm.com>
CC: Christoffer Dall <christoffer.dall@arm.com>

 arch/arm64/include/asm/kvm_host.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe8777b12f86..8150a7f8a50f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -61,8 +61,7 @@ struct kvm_arch {
 	u64    vmid_gen;
 	u32    vmid;
 
-	/* 1-level 2nd stage table and lock */
-	spinlock_t pgd_lock;
+	/* 1-level 2nd stage table, protected by kvm->mmu_lock */
 	pgd_t *pgd;
 
 	/* VTTBR value associated with above pgd and vmid */
-- 
2.18.0
