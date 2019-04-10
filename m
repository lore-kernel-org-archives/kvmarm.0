From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/2] kvm: arm: Clean up the checking for huge mapping
Date: Wed, 10 Apr 2019 16:23:51 +0100
Message-ID: <1554909832-7169-2-git-send-email-suzuki.poulose@arm.com>
References: <1554909297-6753-1-git-send-email-suzuki.poulose@arm.com>
 <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554909832-7169-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, julien.thierry@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com, andrew.murray@arm.com, eric.auger@redhat.com, zhengxiang9@huawei.com, yuzenghui@huawei.com, wanghaibin.wang@huawei.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

If we are checking whether the stage2 can map PAGE_SIZE,
we don't have to do the boundary checks as both the host
VMA and the guest memslots are page aligned. Bail the case
easily.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index a39dcfd..6d73322 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1624,6 +1624,10 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 	hva_t uaddr_start, uaddr_end;
 	size_t size;
 
+	/* The memslot and the VMA are guaranteed to be aligned to PAGE_SIZE */
+	if (map_size == PAGE_SIZE)
+		return true;
+
 	size = memslot->npages * PAGE_SIZE;
 
 	gpa_start = memslot->base_gfn << PAGE_SHIFT;
-- 
2.7.4
