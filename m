Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789043;
	b=dHLMoF64j7qpU/bExGCsWWEY5Zx+o5zbEHMGPqHAUJlNsPFfUSMQwsJUZg2atcWQtaJh
	 O+WtafUMz5Sond7E0RSB8B/hIP2zhvdmFGRRR22N1zWqvma4g//f1VmFhQy7kKDovn/vR
	 BWuLQ/IPNvRn4IUb6/ClmJ5PbGVs41NbRKIyEeaoGtqiovNF99G6af9Er/Y3sL+NsJfrl
	 x6K18nT2rIHvwwwF89N6TLPJyJEElnfTFca8xWVBsayXffSTgrEV19LtgN0u84GflJ1qE
	 ujEq7mlJfL0RZ6ZmxJZ7NSLZ6zpdIcb0xiW86gHOBrQPxBHSlb1VHagm7263rwGSQiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zWdN1r3rL5JNvmzHVrSqFXFVmqeqFuGMV/IrQ6Nf5YM=;
	b=4yxxmQRW8ENNoDCaBrCC4b9zTGIwhdbEk4MDoBE6CmMRRe8wPP1w8KIcOdBLathEGrWO
	 7CiLM3immOk9jMX64WrmcO0WTCD1Xu/o+lmXdYOJR1XPmjW2OdVJOBeTrAsMjVUvOvaIf
	 yQihmdjSxxEoyzPL2aIgFx17MByZs7Q5s1yL61A27i+yDX5PmnPGvCxmUcRT2AYOEuhQI
	 aZ5qXINpdDqKg+6Upjy5c394U+uKkiIlglXsX3WKOMoWLc/f67rxRcwLRU5xgU1+uBwG4
	 u0SRvfouayjO0Vlu8neU9uLlYs/utgqsrVc+Dae3fYctn3gj+8TtoAauVeoqOWSBPYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=decyhCkL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FF4606A322
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=decyhCkL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762F81F031E6;
	Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789042;
	bh=zWdN1r3rL5JNvmzHVrSqFXFVmqeqFuGMV/IrQ6Nf5YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=decyhCkL5N6aTtExU3oh4nKHC0yr6HaHsPVaUetSwGz/mo+dmvg8g5QecCegrmyii
	 HDzI41DCphkhese4ijZdxTl1QTaAp1vWNtUPPHydNHR6FVxUTww56kwWDFLOPqum1W
	 vnxBAJWrWm6rRmJ01NbjRUHYZqgmdiAwfkhseJ9ZvTRUXl/XWvs+6vO5LBl6BKDytQ
	 /fQV8ZAeaXbVg5g1hMH+mXiglFgVZOWxN+IfH9m5wqGFw15X8uqqg92ufWnlzTJ9aI
	 K0Ou3SOKsYXh3Mr8V+44EzlAgkHF1OCP9RHPrsLJolJ+II2xuLx+7P/M+LZwUp2eae
	 m/N/LJDGMiXfg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 26/28] KVM: arm64: selftests: Test AT emulation for FEAT_HAFT
Date: Fri, 23 Oct 2026 13:56:08 -0700
Message-ID: <20261023205610.1044532-27-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that KVM's AT emulation sets the access flag on table descriptors
when FEAT_HAFT is enabled at stage-1. Additionally, add test coverage
that asserts the access flag is clear on table/page descriptors when the
AT instruction generates an access flag fault.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 tools/testing/selftests/kvm/arm64/at.c | 74 +++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index d7289f3df04f..3212b18bd309 100644
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
+	sysreg_clear_set_s(SYS_HCRX_EL2, 0, HCRX_EL2_TCR2En);
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

