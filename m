Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA586FBE3
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49505143D;
	Mon,  9 Oct 2023 11:51:19 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 063DA3F5A1;
	Mon,  9 Oct 2023 11:50:36 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v4 12/12] KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes
Date: Mon,  9 Oct 2023 19:50:08 +0100
Message-Id: <20231009185008.3803879-13-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009185008.3803879-1-ryan.roberts@arm.com>
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for VM_MODE_P52V48_4K and VM_MODE_P52V48_16K guest modes by
using the FEAT_LPA2 pte format for stage1, when FEAT_LPA2 is available.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/lib/aarch64/processor.c     | 39 ++++++++++++++-----
 tools/testing/selftests/kvm/lib/guest_modes.c |  2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  3 ++
 4 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..406500fb6e28 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -171,6 +171,7 @@ static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
 
 enum vm_guest_mode {
 	VM_MODE_P52V48_4K,
+	VM_MODE_P52V48_16K,
 	VM_MODE_P52V48_64K,
 	VM_MODE_P48V48_4K,
 	VM_MODE_P48V48_16K,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index e50dad81e956..7137222d7bcb 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -12,6 +12,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include <linux/bitfield.h>
+#include <linux/sizes.h>
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
 
@@ -58,13 +59,25 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	return (gva >> vm->page_shift) & mask;
 }
 
+static inline bool use_lpa2_pte_format(struct kvm_vm *vm)
+{
+	return (vm->page_size == SZ_4K || vm->page_size == SZ_16K) &&
+	    (vm->pa_bits > 48 || vm->va_bits > 48);
+}
+
 static uint64_t addr_pte(struct kvm_vm *vm, uint64_t pa, uint64_t attrs)
 {
 	uint64_t pte;
 
-	pte = pa & GENMASK(47, vm->page_shift);
-	if (vm->page_shift == 16)
-		pte |= FIELD_GET(GENMASK(51, 48), pa) << 12;
+	if (use_lpa2_pte_format(vm)) {
+		pte = pa & GENMASK(49, vm->page_shift);
+		pte |= FIELD_GET(GENMASK(51, 50), pa) << 8;
+		attrs &= ~GENMASK(9, 8);
+	} else {
+		pte = pa & GENMASK(47, vm->page_shift);
+		if (vm->page_shift == 16)
+			pte |= FIELD_GET(GENMASK(51, 48), pa) << 12;
+	}
 	pte |= attrs;
 
 	return pte;
@@ -74,9 +87,14 @@ static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
 {
 	uint64_t pa;
 
-	pa = pte & GENMASK(47, vm->page_shift);
-	if (vm->page_shift == 16)
-		pa |= FIELD_GET(GENMASK(15, 12), pte) << 48;
+	if (use_lpa2_pte_format(vm)) {
+		pa = pte & GENMASK(49, vm->page_shift);
+		pa |= FIELD_GET(GENMASK(9, 8), pte) << 50;
+	} else {
+		pa = pte & GENMASK(47, vm->page_shift);
+		if (vm->page_shift == 16)
+			pa |= FIELD_GET(GENMASK(15, 12), pte) << 48;
+	}
 
 	return pa;
 }
@@ -266,9 +284,6 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	/* Configure base granule size */
 	switch (vm->mode) {
-	case VM_MODE_P52V48_4K:
-		TEST_FAIL("AArch64 does not support 4K sized pages "
-			  "with 52-bit physical address ranges");
 	case VM_MODE_PXXV48_4K:
 		TEST_FAIL("AArch64 does not support 4K sized pages "
 			  "with ANY-bit physical address ranges");
@@ -278,12 +293,14 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P36V48_64K:
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		break;
+	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P36V48_16K:
 	case VM_MODE_P36V47_16K:
 		tcr_el1 |= 2ul << 14; /* TG0 = 16KB */
 		break;
+	case VM_MODE_P52V48_4K:
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P40V48_4K:
 	case VM_MODE_P36V48_4K:
@@ -297,6 +314,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	/* Configure output size */
 	switch (vm->mode) {
+	case VM_MODE_P52V48_4K:
+	case VM_MODE_P52V48_16K:
 	case VM_MODE_P52V48_64K:
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
 		ttbr0_el1 |= FIELD_GET(GENMASK(51, 48), vm->pgd) << 2;
@@ -325,6 +344,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	/* TCR_EL1 |= IRGN0:WBWA | ORGN0:WBWA | SH0:Inner-Shareable */;
 	tcr_el1 |= (1 << 8) | (1 << 10) | (3 << 12);
 	tcr_el1 |= (64 - vm->va_bits) /* T0SZ */;
+	if (use_lpa2_pte_format(vm))
+		tcr_el1 |= (1ul << 59) /* DS */;
 
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index c64c5cf49942..6634afc22137 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -23,6 +23,8 @@ void guest_modes_append_default(void)
 
 		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
 
+		guest_mode_append(VM_MODE_P52V48_4K, ipa4k >= 52, ipa4k >= 52);
+		guest_mode_append(VM_MODE_P52V48_16K, ipa16k >= 52, ipa16k >= 52);
 		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >= 52, ipa64k >= 52);
 
 		guest_mode_append(VM_MODE_P48V48_4K, ipa4k >= 48, ipa4k >= 48);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..aeba7a23105c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -148,6 +148,7 @@ const char *vm_guest_mode_string(uint32_t i)
 {
 	static const char * const strings[] = {
 		[VM_MODE_P52V48_4K]	= "PA-bits:52,  VA-bits:48,  4K pages",
+		[VM_MODE_P52V48_16K]	= "PA-bits:52,  VA-bits:48, 16K pages",
 		[VM_MODE_P52V48_64K]	= "PA-bits:52,  VA-bits:48, 64K pages",
 		[VM_MODE_P48V48_4K]	= "PA-bits:48,  VA-bits:48,  4K pages",
 		[VM_MODE_P48V48_16K]	= "PA-bits:48,  VA-bits:48, 16K pages",
@@ -173,6 +174,7 @@ const char *vm_guest_mode_string(uint32_t i)
 
 const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_P52V48_4K]	= { 52, 48,  0x1000, 12 },
+	[VM_MODE_P52V48_16K]	= { 52, 48,  0x4000, 14 },
 	[VM_MODE_P52V48_64K]	= { 52, 48, 0x10000, 16 },
 	[VM_MODE_P48V48_4K]	= { 48, 48,  0x1000, 12 },
 	[VM_MODE_P48V48_16K]	= { 48, 48,  0x4000, 14 },
@@ -251,6 +253,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 	case VM_MODE_P36V48_64K:
 		vm->pgtable_levels = 3;
 		break;
+	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P36V48_16K:
-- 
2.25.1

