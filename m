From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/27] KVM: arm/arm64: Remove unused gpa_end variable
Date: Fri, 22 Feb 2019 16:26:03 +0000
Message-ID: <20190222162605.5054-26-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB3334A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eufVmFuG6Ksu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:29:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8DD4A3FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:06 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

The 'gpa_end' local variable is never used and let's remove it.

Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index e3e5a26b4845..aae68da2717f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1597,14 +1597,13 @@ static void kvm_send_hwpoison_signal(unsigned long address,
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
2.20.1
