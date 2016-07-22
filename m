From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 23/55] arm/arm64: KVM: Check that IDMAP doesn't intersect with VA range
Date: Fri, 22 Jul 2016 18:28:40 +0100
Message-ID: <1469208552-4155-24-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 0b36dd52..8a0aa37 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1709,6 +1709,21 @@ int kvm_mmu_init(void)
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
2.8.1

