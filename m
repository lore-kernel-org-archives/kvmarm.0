From: "marek.majtyka" <marek.majtyka@tieto.com>
Subject: [PATCH] kvm: arm: LPAE: Incorrect device to IPA mapping
Date: Wed, 16 Sep 2015 12:04:55 +0200
Message-ID: <1442397895-2124-1-git-send-email-marek.majtyka@tieto.com>
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
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: Marek Majtyka <marek.majtyka@tieto.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marek Majtyka <marek.majtyka@tieto.com>

A critical bug has been found in device memory stage1 translation for machines
with more then 4GB of RAM. Once vm_pgoff size is smaller then pa (which is true
for LPAE case, u32 and u64 respectively) some more significant bits of pa may
be lost as a shift operation is performed on u32 and later cast onto u64.

Example: vm_pgoff(u32)=0x00210030, PAGE_SHIFT=12
        expected pa(u64):   0x0000002010030000
        produced pa(u64):   0x0000000010030000

A suggested fix is changing the order of operations (casting first onto
phys_addr_t and then shifting), which works for both alternatives
(with and without LPAE).

A bug has been found, fixed and tested on kernel v3.19. However, it seems to be
valid for most, if not all, newer version starting from v3.18.

Signed-off-by: Marek Majtyka <marek.majtyka@tieto.com>
---
 arch/arm/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 1366625..602bc63 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1408,7 +1408,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (vma->vm_flags & VM_PFNMAP) {
 			gpa_t gpa = mem->guest_phys_addr +
 				    (vm_start - mem->userspace_addr);
-			phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) +
+			phys_addr_t pa =
+				((phys_addr_t) vma->vm_pgoff << PAGE_SHIFT) +
 					 vm_start - vma->vm_start;
 
 			ret = kvm_phys_addr_ioremap(kvm, gpa, pa,
-- 
1.9.1
