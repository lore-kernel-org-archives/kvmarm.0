From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/11] KVM: arm64: Relax the restriction on using stage2 PUD
 huge mapping
Date: Thu,  7 Feb 2019 13:18:42 +0000
Message-ID: <20190207131843.157210-11-marc.zyngier@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90BD84A42D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W6lsHkOABKj9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Feb 2019 08:19:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 861F04A44B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:23 -0500 (EST)
In-Reply-To: <20190207131843.157210-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

We restrict mapping the PUD huge pages in stage2 to only when the
stage2 has 4 level page table, leaving the feature unused with
the default IPA size. But we could use it even with a 3
level page table, i.e, when the PUD level is folded into PGD,
just like the stage1. Relax the condition to allow using the
PUD huge page mappings at stage2 when it is possible.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fbdf3ac2f001..30251e288629 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1695,11 +1695,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	vma_pagesize = vma_kernel_pagesize(vma);
 	/*
-	 * PUD level may not exist for a VM but PMD is guaranteed to
-	 * exist.
+	 * The stage2 has a minimum of 2 level table (For arm64 see
+	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
+	 * use PMD_SIZE huge mappings (even when the PMD is folded into PGD).
+	 * As for PUD huge maps, we must make sure that we have at least
+	 * 3 levels, i.e, PMD is not folded.
 	 */
 	if ((vma_pagesize == PMD_SIZE ||
-	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pud(kvm))) &&
+	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
 	    !force_pte) {
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
 	}
-- 
2.20.1
