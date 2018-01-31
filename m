From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 19/28] KVM: arm/arm64: Only clean the dcache on translation fault
Date: Wed, 31 Jan 2018 10:34:58 +0100
Message-ID: <20180131093507.22219-20-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The only case where we actually need to perform a dcache maintenance
is when we map the page for the first time, and subsequent permission
faults do not require cache maintenance. Let's make it conditional
on not being a permission fault (and thus a translation fault).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0417c8e2a81c..f956efbd933d 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1400,7 +1400,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 			kvm_set_pfn_dirty(pfn);
 		}
-		clean_dcache_guest_page(vcpu, pfn, PMD_SIZE);
+
+		if (fault_status != FSC_PERM)
+			clean_dcache_guest_page(vcpu, pfn, PMD_SIZE);
 
 		if (exec_fault) {
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
@@ -1416,7 +1418,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
-		clean_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
+
+		if (fault_status != FSC_PERM)
+			clean_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
 
 		if (exec_fault) {
 			new_pte = kvm_s2pte_mkexec(new_pte);
-- 
2.14.2
