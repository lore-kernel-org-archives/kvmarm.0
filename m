Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792789042;
	b=eWOFQgREv37YMaGW9baH3NRMscSxjnDCCtkIpJUZylFPs5w7c03UeVnmjCL2GLUKhEqj
	 TYk05Orf3At1WdniucqNF+R/eRKl6b6ynqIQqlPIgOShHquk4/+vglTx1avzhFlV2o3Vo
	 Mu7FO3mKcWyLyEpdZ/OW2ahQgqMvlU499xj6KlC3sTiB2jr8QKdSyBnYp7FDSlxKfYaN8
	 SPlTBs8cApuVOpJTw7mScB6h5Wqg617/FGZIYq2EgsLLZ1cWtR93DqKzGkY9SoEQ9ceWc
	 4XZKbJ8YobuIIeWiZdsy8OagGYy2m2D8a8eTQ8JH9Zh7DCu1sJzvBh8zsIum17EJ6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792789042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yT3bXLCpyMWL0Ot0Aqoq/p9nO5QsuDwZXMW1738njy0=;
	b=02epRIpZNLHiMYMpD9DGF9E4+jUZEpaXyWLeMgBQQxAQXJ/jlkMylFS9Pn5CKGJcoJr9
	 SWp0XJohW1oCaNTU+pom2VtmxROPHcZxTPHiTo2VTHnGrBC8+zdHwNpkf+nTYBr7V014Y
	 Ep/VF4YlN4ff9HGsxKLgO5bjveTAzaE0sqg03/ukSXiSmHrLRiOgiwpRDrfAK+LCQz5Ub
	 09V4vrFDt4Idu+KKgV3g6AidoYmPrPJ2Z/DyCZfbJ3t2S/ceNDi6WORPZiHoYL1bkWIVo
	 L8Odb5xpSz+B+B0aV2eIWBVGK97a5eSD6QpbM7HhhSog190CA8wNyp0NSfRaAnJmDMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oalrzfR+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F939606A321
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oalrzfR+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375261F031E2;
	Fri, 23 Oct 2026 20:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792789042;
	bh=yT3bXLCpyMWL0Ot0Aqoq/p9nO5QsuDwZXMW1738njy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oalrzfR+wK9ruag96oR53ipbwUCHyYbxRv/rzQ6tuApsaZbgwp9F00bohYU2FgNOB
	 yTanddynN++XHEhVLV2+YycXsPUQ8HEqGGUEUzVg368ofdrJdGU/DJSa5vtjWyyUnr
	 Nce+rzXO7jYeAHVfekUzF7WoQXGry1wYD0fZqujePzfnoecVPr7hn2DQaPNPd/i9jm
	 dj/VyPMQR3m3WcdGaPEj1ZdbGsTH+oZT1rljl7SKn9wesW6Lgft7+0WSVGS/LJ+SBG
	 nnjLkNwH0Lavvt5k2xYn9tMwLrB4a4Hcxpv5fkJO38ndFz98omx2Ea4UOpZ9q/JjLE
	 l1tvC2PJshH5g==
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
Subject: [PATCH v2 25/28] KVM: arm64: selftests: Only test AF behavior for emulated AT insns
Date: Fri, 23 Oct 2026 13:56:07 -0700
Message-ID: <20261023205610.1044532-26-oupton@kernel.org>
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

The original intent of the test was to test KVM's slowpath AT emulation,
specifically including a test for KVM's IMP DEF choice that AT
instructions set the access flag.

While it is possible to force AT instructions to take the slow path in
KVM, this is only effective for an out-of-context regime wherein the
stage-2 translations are guaranteed to be invalid. As such, the
inclusion of AT S1E2* instructions muddied this a bit, as they operate
on the in-context EL2&0 regime.

Restore the original intent of the test and get rid of the AT S1E2* test
cases entirely.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 tools/testing/selftests/kvm/arm64/at.c | 38 ++++++++++++++++----------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index ce5d312ef6ba..d7289f3df04f 100644
--- a/tools/testing/selftests/kvm/arm64/at.c
+++ b/tools/testing/selftests/kvm/arm64/at.c
@@ -13,6 +13,7 @@
 
 enum {
 	CLEAR_ACCESS_FLAG,
+	TEST_ACCESS_FLAG,
 };
 
 static u64 *ptep_hva;
@@ -48,21 +49,12 @@ do {											\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
 		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
+		GUEST_SYNC(TEST_ACCESS_FLAG);						\
 	}										\
 } while (0)
 
 static void test_at(bool expect_fault)
 {
-	test_at_insn(S1E2R, expect_fault);
-	test_at_insn(S1E2W, expect_fault);
-
-	/* Reuse the stage-1 MMU context from EL2 at EL1 */
-	copy_el2_to_el1(SCTLR);
-	copy_el2_to_el1(MAIR);
-	copy_el2_to_el1(TCR);
-	copy_el2_to_el1(TTBR0);
-	copy_el2_to_el1(TTBR1);
-
 	/* Disable stage-2 translation and enter a non-host context */
 	write_sysreg(0, vtcr_el2);
 	write_sysreg(0, vttbr_el2);
@@ -71,11 +63,21 @@ static void test_at(bool expect_fault)
 
 	test_at_insn(S1E1R, expect_fault);
 	test_at_insn(S1E1W, expect_fault);
+
+	sysreg_clear_set(hcr_el2, 0, HCR_EL2_TGE | HCR_EL2_VM);
+	isb();
 }
 
 static void guest_code(void)
 {
-	sysreg_clear_set(tcr_el1, TCR_HA, 0);
+	/* Reuse the stage-1 MMU context from EL2 at EL1 */
+	copy_el2_to_el1(SCTLR);
+	copy_el2_to_el1(MAIR);
+	copy_el2_to_el1(TCR);
+	copy_el2_to_el1(TTBR0);
+	copy_el2_to_el1(TTBR1);
+
+	sysreg_clear_set_s(SYS_TCR_EL12, TCR_HA, 0);
 	isb();
 
 	test_at(true);
@@ -83,7 +85,11 @@ static void guest_code(void)
 	if (!SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, read_sysreg(id_aa64mmfr1_el1)))
 		GUEST_DONE();
 
-	sysreg_clear_set(tcr_el1, 0, TCR_HA);
+	/*
+	 * KVM's software PTW makes the implementation choice that the AT
+	 * instruction sets the access flag.
+	 */
+	sysreg_clear_set_s(SYS_TCR_EL12, 0, TCR_HA);
 	isb();
 	test_at(false);
 
@@ -96,8 +102,8 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 	case CLEAR_ACCESS_FLAG:
 		/*
 		 * Delete + reinstall the memslot to invalidate stage-2
-		 * mappings of the stage-1 page tables, allowing KVM to
-		 * potentially use the 'slow' AT emulation path.
+		 * mappings of the stage-1 page tables, forcing KVM to
+		 * use the 'slow' AT emulation path.
 		 *
 		 * This and clearing the access flag from host userspace
 		 * ensures that the access flag cannot be set speculatively
@@ -106,6 +112,10 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 		clear_bit(__ffs(PTE_AF), ptep_hva);
 		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
 		break;
+	case TEST_ACCESS_FLAG:
+		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
+			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
+		break;
 	default:
 		TEST_FAIL("Unexpected SYNC arg: %lu", uc->args[1]);
 	}
-- 
2.47.3

