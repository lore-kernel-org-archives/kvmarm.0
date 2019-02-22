From: Leo Yan <leo.yan@linaro.org>
Subject: [PATCH v1 4/4] KVM: arm/arm64: Fix comment on create_hyp_mappings()
Date: Fri, 22 Feb 2019 16:23:26 +0800
Message-ID: <20190222082327.3312-5-leo.yan@linaro.org>
References: <20190222082327.3312-1-leo.yan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222082327.3312-1-leo.yan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Andre Przywara <andre.przywara@arm.com>, Jun Yao <yaojun8558363@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: Leo Yan <leo.yan@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Since commit f7bec68d2fae ("arm/arm64: KVM: Prune unused #defines"), the
macro HYP_PAGE_OFFSET has been removed, but it's kept in the comment for
the function create_hyp_mappings().

This patch uses PAGE_OFFSET to replace HYP_PAGE_OFFSET and this is
consistent with what is doing in the function.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5eca48bdb1a6..9634f47c2c8b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -734,7 +734,7 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
  * @prot:	The protection to be applied to this range
  *
  * The same virtual address as the kernel virtual address is also used
- * in Hyp-mode mapping (modulo HYP_PAGE_OFFSET) to the same underlying
+ * in Hyp-mode mapping (modulo PAGE_OFFSET) to the same underlying
  * physical pages.
  */
 int create_hyp_mappings(void *from, void *to, pgprot_t prot)
-- 
2.17.1
