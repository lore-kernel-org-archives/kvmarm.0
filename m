From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 16/28] arm: KVM: Add optimized PIPT icache flushing
Date: Wed, 31 Jan 2018 10:34:55 +0100
Message-ID: <20180131093507.22219-17-christoffer.dall@linaro.org>
References: <20180131093507.22219-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180131093507.22219-1-christoffer.dall@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Calling __cpuc_coherent_user_range to invalidate the icache on
a PIPT icache machine has some pointless overhead, as it starts
by cleaning the dcache to the PoU, while we're guaranteed to
have already cleaned it to the PoC.

As KVM is the only user of such a feature, let's implement some
ad-hoc cache flushing in kvm_mmu.h. Should it become useful to
other subsystems, it can be moved to a more global location.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_hyp.h |  2 ++
 arch/arm/include/asm/kvm_mmu.h | 32 +++++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 76368de7237b..1ab8329e9ff7 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -68,6 +68,8 @@
 #define HIFAR		__ACCESS_CP15(c6, 4, c0, 2)
 #define HPFAR		__ACCESS_CP15(c6, 4, c0, 4)
 #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
+#define BPIALLIS	__ACCESS_CP15(c7, 0, c1, 6)
+#define ICIMVAU		__ACCESS_CP15(c7, 0, c5, 1)
 #define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
 #define TLBIALL		__ACCESS_CP15(c8, 0, c7, 0)
diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 9fa4b2520974..bc8d21e76637 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -37,6 +37,8 @@
 
 #include <linux/highmem.h>
 #include <asm/cacheflush.h>
+#include <asm/cputype.h>
+#include <asm/kvm_hyp.h>
 #include <asm/pgalloc.h>
 #include <asm/stage2_pgtable.h>
 
@@ -157,6 +159,8 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
 						  kvm_pfn_t pfn,
 						  unsigned long size)
 {
+	u32 iclsz;
+
 	/*
 	 * If we are going to insert an instruction page and the icache is
 	 * either VIPT or PIPT, there is a potential problem where the host
@@ -181,18 +185,40 @@ static inline void __invalidate_icache_guest_page(struct kvm_vcpu *vcpu,
 		return;
 	}
 
-	/* PIPT cache. As for the d-side, use a temporary kernel mapping. */
+	/*
+	 * CTR IminLine contains Log2 of the number of words in the
+	 * cache line, so we can get the number of words as
+	 * 2 << (IminLine - 1).  To get the number of bytes, we
+	 * multiply by 4 (the number of bytes in a 32-bit word), and
+	 * get 4 << (IminLine).
+	 */
+	iclsz = 4 << (read_cpuid(CPUID_CACHETYPE) & 0xf);
+
 	while (size) {
 		void *va = kmap_atomic_pfn(pfn);
+		void *end = va + PAGE_SIZE;
+		void *addr = va;
 
-		__cpuc_coherent_user_range((unsigned long)va,
-					   (unsigned long)va + PAGE_SIZE);
+		do {
+			write_sysreg(addr, ICIMVAU);
+			addr += iclsz;
+		} while (addr < end);
+
+		dsb(ishst);
+		isb();
 
 		size -= PAGE_SIZE;
 		pfn++;
 
 		kunmap_atomic(va);
 	}
+
+	/* Check if we need to invalidate the BTB */
+	if ((read_cpuid_ext(CPUID_EXT_MMFR1) >> 28) != 4) {
+		write_sysreg(0, BPIALLIS);
+		dsb(ishst);
+		isb();
+	}
 }
 
 static inline void __kvm_flush_dcache_pte(pte_t pte)
-- 
2.14.2
