From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 07/17] kvm: arm/arm64: Remove spurious WARN_ON
Date: Tue, 27 Mar 2018 14:15:17 +0100
Message-ID: <1522156531-28348-8-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, peter.maydell@linaro.org, ard.biesheuvel@linaro.org, cdall@kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On a 4-level page table pgd entry can be empty, unlike a 3-level
page table. Remove the spurious WARN_ON() in stage_get_pud().

Cc: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 16a19fb..9cba334 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -862,7 +862,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pud_t *pud;
 
 	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
-	if (WARN_ON(stage2_pgd_none(*pgd))) {
+	if (stage2_pgd_none(*pgd)) {
 		if (!cache)
 			return NULL;
 		pud = mmu_memory_cache_alloc(cache);
-- 
2.7.4
