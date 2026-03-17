Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746BA3CBE82
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773753384; cv=none; b=cZQTAtddc/OVGHMz6EAkIdTd4eiz0QvUx65czXeIyfzycuYFuArvZdF77fnCXX3ImQyYiB+YC+QdcBiKBuV66Dle4twJuN4yOywxWmQumdtJ5xZlqN2CWrxsCKsitvhaGzl1wEeGd07/87BNee/6qnYe358/WDSMFwpKhq1jto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773753384; c=relaxed/simple;
	bh=smfiajjb19NeBIh75ht9LTElolmSzi3K6Y95Ae5Bx2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BZZ83I+im/eJE66jDbAy5QmcHG8Dvl5HmobyRLtA3ch/2tfWVtEkQO1nLBZP+g38gSx6xXH0+2naT++GBZy7yGVaf9qNKkKjpcabs98nfvj/KnEFmm5zY/WY6apt9iV6V8zepL25uSOgRmFxfDhR++poNYrxU+Y8O5QLPSKkggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vmq4KMb4; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vmq4KMb4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773753380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9oQqV+RX8x9mTT15DeOPQvLmrB9KGgQzFv8SO038oUc=;
	b=vmq4KMb4KSzFmj/OfzyizXiwqJq2DLV0RQJwJ/B/p2gFvajS76MJbamDhUTWIut9Wso1b/
	J0W2633uPICOl+Nx+imbwysMvlLot9bQS7bZO37W2koMM3P8+CUvKcywmeKhsEgfK36//5
	9sGRcnSHtHi7z9NXPasv8MmDdSTM3U4=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: selftests: Avoid testing the IMPDEF behavior
Date: Tue, 17 Mar 2026 21:15:58 +0800
Message-ID: <20260317131558.52751-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

It turned out that we can't really force KVM to use the "slow" path when
emulating AT instructions [1]. We should therefore avoid testing the IMPDEF
behavior (i.e., TEST_ACCESS_FLAG - address translation instructions are
permitted to update AF but not required).

Remove it and improve the comment a bit.

[1] https://lore.kernel.org/r/b951dcfb-0ad1-4d7b-b6ce-d54b272dd9be@linux.dev

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/kvm/arm64/at.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index c8ee6f520734..ce5d312ef6ba 100644
--- a/tools/testing/selftests/kvm/arm64/at.c
+++ b/tools/testing/selftests/kvm/arm64/at.c
@@ -13,7 +13,6 @@
 
 enum {
 	CLEAR_ACCESS_FLAG,
-	TEST_ACCESS_FLAG,
 };
 
 static u64 *ptep_hva;
@@ -49,7 +48,6 @@ do {											\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_ATTR, par), MAIR_ATTR_NORMAL);	\
 		GUEST_ASSERT_EQ(FIELD_GET(SYS_PAR_EL1_SH, par), PTE_SHARED >> 8);	\
 		GUEST_ASSERT_EQ(par & SYS_PAR_EL1_PA, TEST_ADDR);			\
-		GUEST_SYNC(TEST_ACCESS_FLAG);						\
 	}										\
 } while (0)
 
@@ -85,10 +83,6 @@ static void guest_code(void)
 	if (!SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, read_sysreg(id_aa64mmfr1_el1)))
 		GUEST_DONE();
 
-	/*
-	 * KVM's software PTW makes the implementation choice that the AT
-	 * instruction sets the access flag.
-	 */
 	sysreg_clear_set(tcr_el1, 0, TCR_HA);
 	isb();
 	test_at(false);
@@ -102,8 +96,8 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 	case CLEAR_ACCESS_FLAG:
 		/*
 		 * Delete + reinstall the memslot to invalidate stage-2
-		 * mappings of the stage-1 page tables, forcing KVM to
-		 * use the 'slow' AT emulation path.
+		 * mappings of the stage-1 page tables, allowing KVM to
+		 * potentially use the 'slow' AT emulation path.
 		 *
 		 * This and clearing the access flag from host userspace
 		 * ensures that the access flag cannot be set speculatively
@@ -112,10 +106,6 @@ static void handle_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
 		clear_bit(__ffs(PTE_AF), ptep_hva);
 		vm_mem_region_reload(vcpu->vm, vcpu->vm->memslots[MEM_REGION_PT]);
 		break;
-	case TEST_ACCESS_FLAG:
-		TEST_ASSERT(test_bit(__ffs(PTE_AF), ptep_hva),
-			    "Expected access flag to be set (desc: %lu)", *ptep_hva);
-		break;
 	default:
 		TEST_FAIL("Unexpected SYNC arg: %lu", uc->args[1]);
 	}
-- 
2.53.0

