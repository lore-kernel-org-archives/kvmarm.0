From: Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH] KVM: arm/arm64: Remove unused gpa_end variable
Date: Tue, 19 Feb 2019 17:22:21 +0800
Message-ID: <1550568141-22796-1-git-send-email-zhangshaokun@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The 'gpa_end' local variable is never used and let's remove it.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 virt/kvm/arm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 30251e288629..eac6ff15bd3a 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1598,14 +1598,13 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
 					       unsigned long hva)
 {
-	gpa_t gpa_start, gpa_end;
+	gpa_t gpa_start;
 	hva_t uaddr_start, uaddr_end;
 	size_t size;
 
 	size = memslot->npages * PAGE_SIZE;
 
 	gpa_start = memslot->base_gfn << PAGE_SHIFT;
-	gpa_end = gpa_start + size;
 
 	uaddr_start = memslot->userspace_addr;
 	uaddr_end = uaddr_start + size;
-- 
2.7.4
