From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 11/19] KVM: arm/arm64: Demote HYP VA range display to being a debug feature
Date: Thu,  4 Jan 2018 18:43:26 +0000
Message-ID: <20180104184334.16571-12-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Displaying the HYP VA information is slightly counterproductive when
using VA randomization. Turn it into a debug feature only, and adjust
the last displayed value to reflect the top of RAM instead of ~0.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b4b69c2d1012..84d09f1a44d4 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1760,9 +1760,10 @@ int kvm_mmu_init(void)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
-	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
-	kvm_info("HYP VA range: %lx:%lx\n",
-		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
+	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
+	kvm_debug("HYP VA range: %lx:%lx\n",
+		  kern_hyp_va(PAGE_OFFSET),
+		  kern_hyp_va((unsigned long)high_memory - 1));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
 	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
-- 
2.14.2
