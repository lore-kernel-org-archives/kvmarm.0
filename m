Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF35F390C81
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240131; cv=none; b=Ch/mutb/veevzkTVPX3wLjSPYmZYbOlM9CZxRfI1B+b+4LSrNg3b21KS3heXWRE2NRg5XwNdn9QmvPsF3Pw/oAHq3d7ibqK84koeMNhO6jBoHNMNt+bCLyDtiv6l2f2uH2ao8BqWQona2DcTGf/i14zaBww5TWdQ91NsybeeqvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240131; c=relaxed/simple;
	bh=H0xsbvRdh44QM8NB/bgA9dFHGHlM515GvOH3Ib2dvd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMkUxcVqXhoNvOdoRK3/95eFpkWJBCSkSyitX6i48PptNXRhkczp97CeP3LVF3l+VJD/4NPnKkzYWRpVh6viPOGCjg3kK3/IubcMocvDbCZ1+3Wi4iWUFTUSDJBAAb/SAOiCbKUcKjvb5+1MWh9OMeCjJTKl3yVydMpbOnhKxp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9CFvg0X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9CFvg0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B042C1F00A3F;
	Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240129;
	bh=q7V/mtvn9d0NAqnVsYyqz/4dGADUofLWGBH1gnnhy9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9CFvg0XphLBs6SDdA+fNpXoGYQea+sFxotrXHODwy1VqvsfGeWw5975SQfq/IoM4
	 CyILaoApK4YZF0AukjZ4BjCRnU3XJDM/nrqcaTlpMQKaS01H4Zm8PfhSXoMj3ZbsxE
	 pF+B7Ze7m9cfLYYkdwIvh1hrQQWSxfsI9KTJHlRQRI2G78YMK9s5F5zHJYbycBwwyn
	 hvIeD+VPhFzMWmD5qOKXuKj5IFx6E5ksPrQYjP7wBJWMUitoCCazpI8Qwp7VUOhHRa
	 sShVVroqtDSBzBN9eDbhPSj0xtHyLc5bgMyXvbl5C8Cw0bYDTGToGb3gfld9i7JOwr
	 OO1xFVOVfI0kQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 21/22] KVM: arm64: selftests: Test AT emulation for FEAT_HAFT
Date: Tue, 23 Jun 2026 11:42:00 -0700
Message-ID: <20260623184201.1518871-22-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that KVM's AT emulation sets the access flag on table descriptors
when FEAT_HAFT is enabled at stage-1. Additionally, add test coverage
that asserts the access flag is clear on table/page descriptors when the
AT instruction generates an access flag fault.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 tools/testing/selftests/kvm/arm64/at.c | 74 +++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index d7289f3df04f..fb7399736f44 100644
--- a/tools/testing/selftests/kvm/arm64/at.c
+++ b/tools/testing/selftests/kvm/arm64/at.c
@@ -13,10 +13,11 @@
 
 enum {
 	CLEAR_ACCESS_FLAG,
-	TEST_ACCESS_FLAG,
+	ASSERT_ACCESS_FLAG_SET,
+	ASSERT_ACCESS_FLAG_CLEAR,
 };
 
-static u64 *ptep_hva;
+static u64 *page_ptep, *table_ptep;
 
 #define copy_el2_to_el1(reg)						\
 	write_sysreg_s(read_sysreg_s(SYS_##reg##_EL1), SYS_##reg##_EL12)
@@ -45,11 +46,12 @@ do {											\
 		__GUEST_ASSERT(fsc == ESR_ELx_FSC_ACCESS_L(3),				\
 			       "AT "#op": expected access flag fault (par: %lx)",	\
 			       par);							\
+		GUEST_SYNC(ASSERT_ACCESS_FLAG_CLEAR);					\
 	} else {									\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
 		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
-		GUEST_SYNC(TEST_ACCESS_FLAG);						\
+		GUEST_SYNC(ASSERT_ACCESS_FLAG_SET);					\
 	}										\
 } while (0)
 
@@ -68,6 +70,14 @@ static void test_at(bool expect_fault)
 	isb();
 }
 
+static bool guest_has_haft(void)
+{
+	u64 mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+
+	return SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1) >=
+		ID_AA64MMFR1_EL1_HAFDBS_HAFT;
+}
+
 static void guest_code(void)
 {
 	/* Reuse the stage-1 MMU context from EL2 at EL1 */
@@ -93,9 +103,43 @@ static void guest_code(void)
 	isb();
 	test_at(false);
 
+	if (!guest_has_haft())
+		GUEST_DONE();
+
+	sysrec_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TCR2En);
+	sysreg_clear_set_s(SYS_TCR2_EL12, 0, TCR2_EL1_HAFT);
+	isb();
+	test_at(false);
+
+	/* The effective value of HAFT is 0 if HA is 0 */
+	sysreg_clear_set_s(SYS_TCR_EL12, TCR_HA, 0);
+	isb();
+	test_at(true);
+
+	/* The effective value of HAFT is 0 if HCRX_EL2.TCR2En is 0 */
+	sysreg_clear_set_s(SYS_HCRX_EL2, HCRX_EL2_TCR2En, 0);
+	sysreg_clear_set_s(SYS_TCR_EL12, 0, TCR_HA);
+	isb();
+	test_at(false);
+
 	GUEST_DONE();
 }
 
+static bool vcpu_haft_enabled(struct kvm_vcpu *vcpu)
+{
+	u64 mmfr1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1));
+	u8 hafdbs = SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1);
+	u64 tcr2, hcrx;
+
+	/* FEAT_HAFT implies FEAT_TCRX, FEAT_HCX */
+	if (hafdbs < ID_AA64MMFR1_EL1_HAFDBS_HAFT)
+		return false;
+
+	hcrx = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCRX_EL2));
+	tcr2 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR2_EL1));
+	return hcrx & HCRX_EL2_TCR2En && tcr2 & TCR2_EL1_HAFT;
+}
+
 static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 {
 	switch (uc->args[1]) {
@@ -109,12 +153,25 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 		 * ensures that the access flag cannot be set speculatively
 		 * and is reliably cleared at the time of the AT instruction.
 		 */
-		clear_bit(__ffs(PTE_AF), ptep_hva);
+		clear_bit(__ffs(PTE_AF), page_ptep);
+		clear_bit(__ffs(PTE_AF), table_ptep);
 		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
 		break;
-	case TEST_ACCESS_FLAG:
-		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
-			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
+	case ASSERT_ACCESS_FLAG_SET:
+		TEST_ASSERT(test_bit(__ffs(PTE_AF), page_ptep),
+			    "Expected access flag to be set (desc: %lu)", *page_ptep);
+		if (!vcpu_haft_enabled(vcpu))
+			TEST_ASSERT(!test_bit(__ffs(PTE_AF), table_ptep),
+				    "Expected access flag to be clear (desc: %lu)", *table_ptep);
+		else
+			TEST_ASSERT(test_bit(__ffs(PTE_AF), table_ptep),
+				    "Expected access flag to be set (desc: %lu)", *table_ptep);
+		break;
+	case ASSERT_ACCESS_FLAG_CLEAR:
+		TEST_ASSERT(!test_bit(__ffs(PTE_AF), page_ptep),
+			    "Expected access flag to be clear (desc: %lu)", *page_ptep);
+		TEST_ASSERT(!test_bit(__ffs(PTE_AF), table_ptep),
+			    "Expected access flag to be clear (desc: %lu)", *table_ptep);
 		break;
 	default:
 		TEST_FAIL("Unexpected SYNC arg: %lu", uc->args[1]);
@@ -158,7 +215,8 @@ int main(void)
 	kvm_arch_vm_finalize_vcpus(vm);
 
 	virt_map(vm, TEST_ADDR, TEST_ADDR, 1);
-	ptep_hva = virt_get_pte_hva_at_level(vm, TEST_ADDR, 3);
+	page_ptep = virt_get_pte_hva_at_level(vm, TEST_ADDR, 3);
+	table_ptep = virt_get_pte_hva_at_level(vm, TEST_ADDR, 2);
 	run_test(vcpu);
 
 	kvm_vm_free(vm);
-- 
2.47.3

