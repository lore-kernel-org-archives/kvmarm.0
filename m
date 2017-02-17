From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/20] arm/arm64: KVM: Remove kvm_get_idmap_start
Date: Fri, 17 Feb 2017 15:44:28 +0000
Message-ID: <20170217154429.5000-20-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88C3640FAE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eq72jeTOJD2y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 10:44:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DBBC40FAF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:50 -0500 (EST)
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@arm.linux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

With __cpu_reset_hyp_mode having become fairly dumb, there is no
need for kvm_get_idmap_start anymore.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 1 -
 arch/arm/kvm/mmu.c               | 5 -----
 arch/arm64/include/asm/kvm_mmu.h | 1 -
 3 files changed, 7 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 74a44727f8e1..646a4d4236ba 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -56,7 +56,6 @@ void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
-phys_addr_t kvm_get_idmap_start(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a5265edbeeab..12ab3372f240 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1677,11 +1677,6 @@ phys_addr_t kvm_get_idmap_vector(void)
 	return hyp_idmap_vector;
 }
 
-phys_addr_t kvm_get_idmap_start(void)
-{
-	return hyp_idmap_start;
-}
-
 static int kvm_map_idmap_text(pgd_t *pgd)
 {
 	int err;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f72fe8b0e3e..ff1282344ece 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -155,7 +155,6 @@ void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
 phys_addr_t kvm_get_idmap_vector(void);
-phys_addr_t kvm_get_idmap_start(void);
 int kvm_mmu_init(void);
 void kvm_clear_hyp_idmap(void);
 
-- 
2.11.0
