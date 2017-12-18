From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/5] KVM: arm/arm64: Fix HYP unmapping going off limits
Date: Mon, 18 Dec 2017 11:00:54 +0100
Message-ID: <20171218100057.7839-3-christoffer.dall@linaro.org>
References: <20171218100057.7839-1-christoffer.dall@linaro.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171218100057.7839-1-christoffer.dall@linaro.org>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

When we unmap the HYP memory, we try to be clever and unmap one
PGD at a time. If we start with a non-PGD aligned address and try
to unmap a whole PGD, things go horribly wrong in unmap_hyp_range
(addr and end can never match, and it all goes really badly as we
keep incrementing pgd and parse random memory as page tables...).

The obvious fix is to let unmap_hyp_range do what it does best,
which is to iterate over a range.

The size of the linear mapping, which begins at PAGE_OFFSET, can be
easily calculated by subtracting PAGE_OFFSET form high_memory, because
high_memory is defined as the linear map address of the last byte of
DRAM, plus one.

The size of the vmalloc region is given trivially by VMALLOC_END -
VMALLOC_START.

Cc: stable@vger.kernel.org
Reported-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d49986..b4b69c2d1012 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -509,8 +509,6 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
  */
 void free_hyp_pgds(void)
 {
-	unsigned long addr;
-
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	if (boot_hyp_pgd) {
@@ -521,10 +519,10 @@ void free_hyp_pgds(void)
 
 	if (hyp_pgd) {
 		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
-		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
-		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
-			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
+		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
+				(uintptr_t)high_memory - PAGE_OFFSET);
+		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
+				VMALLOC_END - VMALLOC_START);
 
 		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
 		hyp_pgd = NULL;
-- 
2.14.2
