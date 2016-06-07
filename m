From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/15] arm/arm64: KVM: Check that IDMAP doesn't intersect with
 VA range
Date: Tue,  7 Jun 2016 11:58:35 +0100
Message-ID: <1465297115-13091-16-git-send-email-marc.zyngier@arm.com>
References: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B347249B95
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2016 06:54:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rh+U4-GJQiJH for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2016 06:54:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2FEA49B7F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2016 06:54:48 -0400 (EDT)
In-Reply-To: <1465297115-13091-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This is more of a safety measure than anything else: If we end-up
with an idmap page that intersect with the range picked for the
the HYP VA space, abort the KVM setup, as it is unsafe to go
further.

I cannot imagine it happening on 64bit (we have a mechanism to
work around it), but could potentially occur on a 32bit system with
the kernel loaded high enough in memory so that in conflicts with
the kernel VA.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 46b8604..819517d 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1708,6 +1708,21 @@ int kvm_mmu_init(void)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
+	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
+	kvm_info("HYP VA range: %lx:%lx\n",
+		 KERN_TO_HYP(PAGE_OFFSET), KERN_TO_HYP(~0UL));
+
+	if (hyp_idmap_start >= KERN_TO_HYP(PAGE_OFFSET) &&
+	    hyp_idmap_start <  KERN_TO_HYP(~0UL)) {
+		/*
+		 * The idmap page is intersecting with the VA space,
+		 * it is not safe to continue further.
+		 */
+		kvm_err("IDMAP intersecting with HYP VA, unable to continue\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, hyp_pgd_order);
 	if (!hyp_pgd) {
 		kvm_err("Hyp mode PGD not allocated\n");
-- 
2.1.4
