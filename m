Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E7D3DD86A
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787692739; cv=none; b=PHzf9XqEGlJqu828EC8H0DpiqfOhfl9VaNTBzrzV0Edk4sMRMqNx1Durm0gmH9Wq1zDL/CPEfnz1HMDrrHly2AnT1r8/IFJ5d1BgvWdPkVNny6oo8+dTyapI4ySR8TNXssalc1zHgMD9IA2OgZUO4J4RLJnfzbCvkIeYnoG5MFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787692739; c=relaxed/simple;
	bh=j6Asuk1cnBvinvk3JEqecrbzglvqkmx5gA73gonKR8E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i5GbemRocKXU6ZJAAlY8dsGSYvsh26WV309C4rjOJr1zpYs7Pltg+hdWg5KYS4W7+6JrcnfPX+lBKq60gYst04muMhtuisiUT2b9M0qlKZdEWqJFInDJvLDhvEGDEBF4Vd0aW37WP1CE4mw4gxxbGDlVUXPTBrXEthRKfvUHAfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=ZBdl8Rpx; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="ZBdl8Rpx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787692736; x=1819228736;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=j6Asuk1cnBvinvk3JEqecrbzglvqkmx5gA73gonKR8E=;
  b=ZBdl8RpxTifXuBL2HhxK+TB79ovs/qIY0/0rzsvIvGnbBrfYudFS2m9l
   NB/DDbb8zjd8gsLITa5HBbMf5ptFsHVhdIX9diTOh14w8Hi2oBIgkb+dr
   fmPQkNKfOyaaGN2cFKCDLzVrnl8qMhU/q7tOK4jT62m/Oh7gftnoS1LoG
   CJR78VBIQAGUDtVvlrJml0kxDV+tXBOA/WxhAnr7A3mKUI0Lsx4Wuo5Ti
   Jsou9oMCqiLT9818z5CGLDUe8nZDDjA8qROWPuLGQNswJb80xA06rvC1v
   BNlmN3DnqyCqgNiljpWr57pfITJRW1mWJuNA18F/SAVlBkJVRNhiPAI6A
   Q==;
X-CSE-ConnectionGUID: Ck4WyawMT0CJSjmDl/nBDA==
X-CSE-MsgGUID: QvFoc8uaRy6zsW+9XJC28A==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="240056787"
X-IronPort-AV: E=Sophos;i="6.25,243,1779116400"; 
   d="scan'208";a="240056787"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 06:18:49 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id C9066C00542
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:48 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 83AD2C01817
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 21:18:48 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with ESMTP id B7D8D1801127;
	Tue, 25 Aug 2026 21:18:43 +0000 (UTC)
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Date: Wed, 26 Aug 2026 06:18:34 +0900
Subject: [PATCH 1/2] KVM: selftest: arm64: Support 5-level paging in stage
 1 translation table
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-arm64-52bit-va-v1-1-14ec98211363@fujitsu.com>
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
In-Reply-To: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
 Takayuki Okamoto <tokamoto@fujitsu.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787692718; l=7169;
 i=itaru.kitayama@fujitsu.com; s=20260825; h=from:subject:message-id;
 bh=j6Asuk1cnBvinvk3JEqecrbzglvqkmx5gA73gonKR8E=;
 b=6T4a5KAqdlBssANDbaEO8tnHAZpKT80qJ+CiRvnlccosN/JQ7RnXybQTuU1Lj3I1glKWbng5R
 v+ctyoyhppqDVTJrhBt32hdWL9u8NACxpgs82TvetXzsX5OahtXaLtn
X-Developer-Key: i=itaru.kitayama@fujitsu.com; a=ed25519;
 pk=g9bTnr9giRP7JwNSZHy+OMLQZBEUtSE9tUnXso0hH1Y=

Add p4d_index() for when 5-level paging required, i.e., V52 guest mode
IDs. With the index helper function, _virt_pg_map() handles 5-level
paging case, and aarch64_vcpu_setup() now is aware of the new V52 guest
mode IDs.

Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Reviewed-by: Takayuki Okamoto <tokamoto@fujitsu.com>
---
 .../selftests/kvm/include/arm64/processor.h        |  2 +
 tools/testing/selftests/kvm/lib/arm64/processor.c  | 87 ++++++++++++++++++++--
 2 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index b8a902ba8573..a6fd7a9b379e 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -113,6 +113,7 @@
 
 #define PTE_VALID		BIT(0)
 #define PGD_TYPE_TABLE		BIT(1)
+#define P4D_TYPE_TABLE		BIT(1)
 #define PUD_TYPE_TABLE		BIT(1)
 #define PMD_TYPE_TABLE		BIT(1)
 #define PTE_TYPE_PAGE		BIT(1)
@@ -167,6 +168,7 @@ enum {
 			   (v) == VECTOR_SYNC_LOWER_64    || \
 			   (v) == VECTOR_SYNC_LOWER_32)
 
+u32 aarch64_get_supported_va_size(void);
 void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
 				      u32 *ipa16k, u32 *ipa64k);
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 01325bf4d36f..9108e14a9b5b 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -29,13 +29,25 @@ static u64 pgd_index(struct kvm_vm *vm, gva_t gva)
 	return (gva >> shift) & mask;
 }
 
+static u64 p4d_index(struct kvm_vm *vm, gva_t gva)
+{
+	unsigned int shift = 3 * (vm->page_shift - 3) + vm->page_shift;
+	u64 mask = (1UL << (vm->page_shift - 3)) - 1;
+
+	TEST_ASSERT(vm->mmu.pgtable_levels == 5,
+		    "Mode %d does not have 5 page table levels", vm->mode);
+
+	return (gva >> shift) & mask;
+}
+
 static u64 pud_index(struct kvm_vm *vm, gva_t gva)
 {
 	unsigned int shift = 2 * (vm->page_shift - 3) + vm->page_shift;
 	u64 mask = (1UL << (vm->page_shift - 3)) - 1;
 
-	TEST_ASSERT(vm->mmu.pgtable_levels == 4,
-		"Mode %d does not have 4 page table levels", vm->mode);
+	TEST_ASSERT(vm->mmu.pgtable_levels >= 4,
+		    "Mode %d does not have at least 4 page table levels",
+		    vm->mode);
 
 	return (gva >> shift) & mask;
 }
@@ -147,6 +159,12 @@ static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 				 PGD_TYPE_TABLE | PTE_VALID);
 
 	switch (vm->mmu.pgtable_levels) {
+	case 5:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + p4d_index(vm, gva) * 8;
+		if (!*ptep)
+			*ptep = addr_pte(vm, vm_alloc_page_table(vm),
+					 P4D_TYPE_TABLE | PTE_VALID);
+		/* fall through */
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!*ptep)
@@ -163,7 +181,7 @@ static void _virt_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pte_index(vm, gva) * 8;
 		break;
 	default:
-		TEST_FAIL("Page table levels must be 2, 3, or 4");
+		TEST_FAIL("Page table levels must be 2, 3, 4, or 5");
 	}
 
 	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
@@ -182,18 +200,35 @@ void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 
 u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
 {
+	int start_level = 4 - vm->mmu.pgtable_levels;
 	u64 *ptep;
 
+	TEST_ASSERT(level >= start_level && level <= 3,
+		    "Invalid translation level %d, valid range is %d-3",
+		    level, start_level);
+
 	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
 
 	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
 	if (!ptep)
 		goto unmapped_gva;
-	if (level == 0)
+	/*
+	 * Stage-1 translation starts at level -1 for a five-level page
+	 * table, and at levels 0, 1, or 2 for four-, three-, or two-level
+	 * page tables, respectively.
+	 */
+	if (level == start_level)
 		return ptep;
 
 	switch (vm->mmu.pgtable_levels) {
+	case 5:
+		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + p4d_index(vm, gva) * 8;
+		if (!ptep)
+			goto unmapped_gva;
+		if (level == 0)
+			break;
+		/* fall through */
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!ptep)
@@ -214,7 +249,7 @@ u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva_t gva, int level)
 			goto unmapped_gva;
 		break;
 	default:
-		TEST_FAIL("Page table levels must be 2, 3, or 4");
+		TEST_FAIL("Page table levels must be 2, 3, 4, or 5");
 	}
 
 	return ptep;
@@ -321,12 +356,14 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_PXXVYY_4K:
 		TEST_FAIL("AArch64 does not support 4K sized pages "
 			  "with ANY-bit physical address ranges");
+	case VM_MODE_P52V52_64K:
 	case VM_MODE_P52V48_64K:
 	case VM_MODE_P48V48_64K:
 	case VM_MODE_P40V48_64K:
 	case VM_MODE_P36V48_64K:
 		tcr_el1 |= TCR_TG0_64K;
 		break;
+	case VM_MODE_P52V52_16K:
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
@@ -334,6 +371,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P36V47_16K:
 		tcr_el1 |= TCR_TG0_16K;
 		break;
+	case VM_MODE_P52V52_4K:
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P40V48_4K:
@@ -348,6 +386,9 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	/* Configure output size */
 	switch (vm->mode) {
+	case VM_MODE_P52V52_4K:
+	case VM_MODE_P52V52_16K:
+	case VM_MODE_P52V52_64K:
 	case VM_MODE_P52V48_4K:
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P52V48_64K:
@@ -578,6 +619,42 @@ static u32 max_ipa_for_page_size(u32 vm_ipa, u32 gran,
 		return min(vm_ipa, 48U);
 }
 
+u32 aarch64_get_supported_va_size(void)
+{
+	struct kvm_vcpu_init preferred_init = {};
+	int kvm_fd, vm_fd, vcpu_fd, err;
+	u64 val;
+	u32 va_range;
+	struct kvm_one_reg reg = {
+		.id	= KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR2_EL1),
+		.addr	= (u64)&val,
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
+	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
+
+	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
+	TEST_ASSERT(vcpu_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu_fd));
+
+	err = ioctl(vm_fd, KVM_ARM_PREFERRED_TARGET, &preferred_init);
+	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_PREFERRED_TARGET, err));
+
+	err = ioctl(vcpu_fd, KVM_ARM_VCPU_INIT, &preferred_init);
+	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_ARM_VCPU_INIT, err));
+
+	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
+	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, err));
+
+	va_range = FIELD_GET(ID_AA64MMFR2_EL1_VARange, val);
+
+	close(vcpu_fd);
+	close(vm_fd);
+	close(kvm_fd);
+
+	return va_range >= ID_AA64MMFR2_EL1_VARange_52 ? 52 : 48;
+}
+
 void aarch64_get_supported_page_sizes(u32 ipa, u32 *ipa4k,
 				      u32 *ipa16k, u32 *ipa64k)
 {

-- 
2.43.0

