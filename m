Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18406748D
	for <kvmarm@lists.linux.dev>; Thu,  3 Nov 2022 15:05:17 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 434E623A;
	Thu,  3 Nov 2022 08:05:22 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40C143F5A1;
	Thu,  3 Nov 2022 08:05:14 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 1/2] KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
Date: Thu,  3 Nov 2022 15:05:06 +0000
Message-ID: <20221103150507.32948-2-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221103150507.32948-1-ryan.roberts@arm.com>
References: <20221103150507.32948-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Message-ID: <20221103150506.yV8sJ7DYmeKh4ssjjY_3pVy57ll5UYrQOrqlNYEdbTM@z>

For nvhe and protected modes, the hyp stage 1 page-table was previously
configured to have the same number of VA bits as the kernel's idmap.
However, for kernel configs with VA_BITS=52 and where the kernel is
loaded in physical memory below 48 bits, the idmap VA bits is actually
smaller than the kernel's normal stage 1 VA bits. This can lead to
kernel addresses that can't be mapped into the hypervisor, leading to
kvm initialization failure during boot:

  kvm [1]: IPA Size Limit: 48 bits
  kvm [1]: Cannot map world-switch code
  kvm [1]: error initializing Hyp mode: -34

Fix this by ensuring that the hyp stage 1 VA size is the maximum of
what's used for the idmap and the regular kernel stage 1. At the same
time, refactor the code so that the hyp VA bits is only calculated in
one place.

Fixes: 7ba8f2b2d652 ("arm64: mm: use a 48-bit ID map when possible on
52-bit VA builds")

Prior to the above mentioned change, the idmap was always 52 bits for a
52 VA bits kernel and therefore the hyp stage1 was also always 52 bits.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/arm.c | 20 +++-----------------
 arch/arm64/kvm/mmu.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..803055da3ee3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1518,7 +1518,7 @@ static int kvm_init_vector_slots(void)
 	return 0;
 }
 
-static void cpu_prepare_hyp_mode(int cpu)
+static void cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
@@ -1534,23 +1534,9 @@ static void cpu_prepare_hyp_mode(int cpu)
 
 	params->mair_el2 = read_sysreg(mair_el1);
 
-	/*
-	 * The ID map may be configured to use an extended virtual address
-	 * range. This is only the case if system RAM is out of range for the
-	 * currently configured page size and VA_BITS, in which case we will
-	 * also need the extended virtual range for the HYP ID map, or we won't
-	 * be able to enable the EL2 MMU.
-	 *
-	 * However, at EL2, there is only one TTBR register, and we can't switch
-	 * between translation tables *and* update TCR_EL2.T0SZ at the same
-	 * time. Bottom line: we need to use the extended range with *both* our
-	 * translation tables.
-	 *
-	 * So use the same T0SZ value we use for the ID map.
-	 */
 	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
 	tcr &= ~TCR_T0SZ_MASK;
-	tcr |= (idmap_t0sz & GENMASK(TCR_TxSZ_WIDTH - 1, 0)) << TCR_T0SZ_OFFSET;
+	tcr |= TCR_T0SZ(hyp_va_bits);
 	params->tcr_el2 = tcr;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
@@ -2054,7 +2040,7 @@ static int init_hyp_mode(void)
 		}
 
 		/* Prepare the CPU initialization parameters */
-		cpu_prepare_hyp_mode(cpu);
+		cpu_prepare_hyp_mode(cpu, hyp_va_bits);
 	}
 
 	if (is_protected_kvm_enabled()) {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..4efb983cff43 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1618,6 +1618,8 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
 int kvm_mmu_init(u32 *hyp_va_bits)
 {
 	int err;
+	u32 idmap_bits;
+	u32 kernel_bits;
 
 	hyp_idmap_start = __pa_symbol(__hyp_idmap_text_start);
 	hyp_idmap_start = ALIGN_DOWN(hyp_idmap_start, PAGE_SIZE);
@@ -1631,7 +1633,31 @@ int kvm_mmu_init(u32 *hyp_va_bits)
 	 */
 	BUG_ON((hyp_idmap_start ^ (hyp_idmap_end - 1)) & PAGE_MASK);
 
-	*hyp_va_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
+	/*
+	 * The ID map may be configured to use an extended virtual address
+	 * range. This is only the case if system RAM is out of range for the
+	 * currently configured page size and VA_BITS_MIN, in which case we will
+	 * also need the extended virtual range for the HYP ID map, or we won't
+	 * be able to enable the EL2 MMU.
+	 *
+	 * However, in some cases the ID map may be configured for fewer than
+	 * the number of VA bits used by the regular kernel stage 1. This
+	 * happens when VA_BITS=52 and the kernel image is placed in PA space
+	 * below 48 bits.
+	 *
+	 * At EL2, there is only one TTBR register, and we can't switch between
+	 * translation tables *and* update TCR_EL2.T0SZ at the same time. Bottom
+	 * line: we need to use the extended range with *both* our translation
+	 * tables.
+	 *
+	 * So use the maximum of the idmap VA bits and the regular kernel stage
+	 * 1 VA bits to assure that the hypervisor can both ID map its code page
+	 * and map any kernel memory.
+	 */
+	idmap_bits = 64 - ((idmap_t0sz & TCR_T0SZ_MASK) >> TCR_T0SZ_OFFSET);
+	kernel_bits = vabits_actual;
+	*hyp_va_bits = max(idmap_bits, kernel_bits);
+
 	kvm_debug("Using %u-bit virtual addresses at EL2\n", *hyp_va_bits);
 	kvm_debug("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_debug("HYP VA range: %lx:%lx\n",
-- 
2.17.1

