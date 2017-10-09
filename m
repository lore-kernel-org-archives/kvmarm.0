From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/10] KVM: arm/arm64: Only clean the dcache on translation
 fault
Date: Mon,  9 Oct 2017 16:20:28 +0100
Message-ID: <20171009152032.27804-7-marc.zyngier@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27C1E49D34
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 11:20:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJYg0eA5KhEf for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Oct 2017 11:20:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5912949D52
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 11:20:29 -0400 (EDT)
In-Reply-To: <20171009152032.27804-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The only case where we actually need to perform a dache maintenance
is when we map the page for the first time, and subsequent permission
faults do not require cache maintenance. Let's make it conditional
on not being a permission fault (and thus a translation fault).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1d47da22f75c..1911fadde88b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1400,7 +1400,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 			kvm_set_pfn_dirty(pfn);
 		}
-		coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
+
+		if (fault_status != FSC_PERM)
+			coherent_dcache_guest_page(vcpu, pfn, PMD_SIZE);
 
 		if (exec_fault) {
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
@@ -1416,7 +1418,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			kvm_set_pfn_dirty(pfn);
 			mark_page_dirty(kvm, gfn);
 		}
-		coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
+
+		if (fault_status != FSC_PERM)
+			coherent_dcache_guest_page(vcpu, pfn, PAGE_SIZE);
 
 		if (exec_fault) {
 			new_pte = kvm_s2pte_mkexec(new_pte);
-- 
2.14.1
