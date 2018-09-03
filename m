From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL 4/4] arm64: KVM: Remove pgd_lock
Date: Mon,  3 Sep 2018 15:45:16 +0200
Message-ID: <20180903134516.17796-5-christoffer.dall@arm.com>
References: <20180903134516.17796-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85B584A215
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOBs6UEeswxx for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 09:45:33 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8100B4A220
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 09:45:31 -0400 (EDT)
In-Reply-To: <20180903134516.17796-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Steven Price <steven.price@arm.com>

The lock has never been used and the page tables are protected by
mmu_lock in struct kvm.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8e6d46df38aa..3d6d7336f871 100644
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
