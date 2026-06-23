Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93B338B7BA
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240130; cv=none; b=PrviBqq73s3sHjJ8oiVqvOZGCKCKRwF+pmEbTFXjaMH64/ft5j6nyN/7kjJrimngwSCySD4kLix1cjc3xi5fqDSFR+GTvDubE/PZ6WiWyneODa6pBVwV8WqXDz/SfNik6XbI8xe67YBuwwUJiuMfOf2Y3w9TZ/Nmgj+i2dbnW4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240130; c=relaxed/simple;
	bh=6IGdf4O8qZQmuIpZzuZzP1446rK8lNe3+knOwhmcPtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8p2ng3/VgrOXoLTwaKFSEadunAUJ7C36TW19+iYkdH6xDaN2wMZYJchOi+84jo1AEo8iSjzZMtzWeZSCNLBthBEa8tir9mRp3L5hCZe3F75sFDsCLsNYkjbYj7elfQ6ETQLTJsb0xFzeZbMuGVpy06yhAvMYO10Pt5FrMeRfGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CjzGz/gb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CjzGz/gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEAF1F000E9;
	Tue, 23 Jun 2026 18:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240129;
	bh=9kNj1w1a848zWPyV9kLjNUZa4bpIOgZTQtiEsy3PaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjzGz/gb6gNM4ix+MJxREcuz3fKrAaUHDxliKbkSgSquPYjZrf2ZlhmKCutIe/kPQ
	 G4oFciQj++Je1fmRnOVoWoxsp7aM+CvMCoeUJOC3v8ivfW6S21TJ3pM2lbpOicg93N
	 rZHZ6ByarC3iagz77Mf6FRKnWIs7nDwN46RWMK4cAV08aW2cb0f9jkcpfTHPrmUWNl
	 bYCt0IvbxuE3kQpOJ9z9+9nlG/elzBxq5UXfqzd4WSJFmEgG1VEnqIX5MjmkeCPGXV
	 aE/I5ehsoDJDxaN9iABVkPotH5QQAFpv+UM/W5adLuWfI1j/NVFStZY5SvATxJY+Xg
	 H3j4pdALzM0PA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 20/22] KVM: arm64: selftests: Only test AF behavior for emulated AT insns
Date: Tue, 23 Jun 2026 11:41:59 -0700
Message-ID: <20260623184201.1518871-21-oupton@kernel.org>
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

