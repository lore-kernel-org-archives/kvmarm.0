From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 01/18] kvm: arm/arm64: Fix stage2_flush_memslot for 4 level page table
Date: Wed, 26 Sep 2018 17:32:37 +0100
Message-ID: <20180926163258.20218-2-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

So far we have only supported 3 level page table with fixed IPA of
40bits, where PUD is folded. With 4 level page tables, we need
to check if the PUD entry is valid or not. Fix stage2_flush_memslot()
to do this check, before walking down the table.

Acked-by: Christoffer Dall <cdall@kernel.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed162a6c57c5..ee7ce8fa4a12 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -412,7 +412,8 @@ static void stage2_flush_memslot(struct kvm *kvm,
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
 	do {
 		next = stage2_pgd_addr_end(addr, end);
-		stage2_flush_puds(kvm, pgd, addr, next);
+		if (!stage2_pgd_none(*pgd))
+			stage2_flush_puds(kvm, pgd, addr, next);
 	} while (pgd++, addr = next, addr != end);
 }
 
-- 
2.19.0
