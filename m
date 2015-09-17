From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/8] arm: KVM: Fix incorrect device to IPA mapping
Date: Thu, 17 Sep 2015 15:46:06 +0100
Message-ID: <1442501171-24484-4-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Marek Majtyka <marek.majtyka@tieto.com>, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marek Majtyka <marek.majtyka@tieto.com>

A critical bug has been found in device memory stage1 translation for
VMs with more then 4GB of address space. Once vm_pgoff size is smaller
then pa (which is true for LPAE case, u32 and u64 respectively) some
more significant bits of pa may be lost as a shift operation is performed
on u32 and later cast onto u64.

Example: vm_pgoff(u32)=0x00210030, PAGE_SHIFT=12
        expected pa(u64):   0x0000002010030000
        produced pa(u64):   0x0000000010030000

The fix is to change the order of operations (casting first onto phys_addr_t
and then shifting).

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
[maz: fixed changelog and patch formatting]
Cc: stable@vger.kernel.org
Signed-off-by: Marek Majtyka <marek.majtyka@tieto.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 7b42012..6984342 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1792,8 +1792,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		if (vma->vm_flags & VM_PFNMAP) {
 			gpa_t gpa = mem->guest_phys_addr +
 				    (vm_start - mem->userspace_addr);
-			phys_addr_t pa = (vma->vm_pgoff << PAGE_SHIFT) +
-					 vm_start - vma->vm_start;
+			phys_addr_t pa;
+
+			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+			pa += vm_start - vma->vm_start;
 
 			/* IO region dirty page logging not allowed */
 			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES)
-- 
2.1.4

