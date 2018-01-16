From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL v2 1/3] KVM: arm/arm64: Check pagesize when allocating a
 hugepage at Stage 2
Date: Tue, 16 Jan 2018 18:02:31 +0100
Message-ID: <20180116170233.7085-2-christoffer.dall@linaro.org>
References: <20180116170233.7085-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1745749DFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQOBLN1LnRQB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 11:57:38 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09B9249DF8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 11:57:38 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id v71so10106469wmv.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 09:02:39 -0800 (PST)
In-Reply-To: <20180116170233.7085-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Punit Agrawal <punit.agrawal@arm.com>

KVM only supports PMD hugepages at stage 2 but doesn't actually check
that the provided hugepage memory pagesize is PMD_SIZE before populating
stage 2 entries.

In cases where the backing hugepage size is smaller than PMD_SIZE (such
as when using contiguous hugepages), KVM can end up creating stage 2
mappings that extend beyond the supplied memory.

Fix this by checking for the pagesize of userspace vma before creating
PMD hugepage at stage 2.

Fixes: 66b3923a1a0f77a ("arm64: hugetlb: add support for PTE contiguous bit")
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b4b69c2d1012..9dea96380339 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1310,7 +1310,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (is_vm_hugetlb_page(vma) && !logging_active) {
+	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
 	} else {
-- 
2.14.2
