Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58A5B673
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040273; cv=none; b=bzuSqnssRxPsd9M2MTYvaryqTDg24EBIVhc/5pgxHgfAA3I3VP0v0ofbwArKPq9iWePAbEiKeQ4YHrZz2vSvJ4xcGPJZHJh4nkL2660k/+LEEuKdfSDOOQKo5kVsoSSJOW4Tu353L/bIE5qD3FtA4bokFh/JUZpPQWlSdirjZi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040273; c=relaxed/simple;
	bh=EHrZkg10MMHPYaq1grC9whC7VlGrUN7i3Zm83YMFwvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mhsk2A936YKwvjZYcWPNpBi+AH/VIVeUqEUgWr5yUsZzRZpAipxmj22xY3UPOh7Na+QdT1uL0ad//MN1OzRu8AytvOE81TLKjbNXg72OSpmePaPSKnYOvTms5esDUP4Yg87zYN2tjVnVrvDaJrcb046BlGJGnTsDfP5bTpgpS0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6468F1063;
	Thu, 21 Mar 2024 09:58:25 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C83883F67D;
	Thu, 21 Mar 2024 09:57:49 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 5/6] KVM: arm64: selftests: Move the bulky macro invocation to a helper
Date: Thu, 21 Mar 2024 16:57:27 +0000
Message-Id: <20240321165728.31907-6-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240321165728.31907-1-james.morse@arm.com>
References: <20240321165728.31907-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_ARM_FEATURE_ID_RANGE_IDX() takes a whole bunch of arguments, that
are typically going to be extracted from a single value.

Before adding a second copy of this, pull it out into a helper.

Signed-off-by: James Morse <james.morse@arm.com>
---
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 16e2338686c1..b42a0dc19852 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -374,6 +374,13 @@ static void test_reg_set_fail(struct kvm_vcpu *vcpu, uint64_t reg,
 	TEST_ASSERT_EQ(val, old_val);
 }
 
+static int sys_reg_to_idx(uint32_t reg_id)
+{
+	return KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(reg_id), sys_reg_Op1(reg_id),
+					    sys_reg_CRn(reg_id), sys_reg_CRm(reg_id),
+					    sys_reg_Op2(reg_id));
+}
+
 static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
 {
 	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
@@ -398,9 +405,7 @@ static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
 		int idx;
 
 		/* Get the index to masks array for the idreg */
-		idx = KVM_ARM_FEATURE_ID_RANGE_IDX(sys_reg_Op0(reg_id), sys_reg_Op1(reg_id),
-						   sys_reg_CRn(reg_id), sys_reg_CRm(reg_id),
-						   sys_reg_Op2(reg_id));
+		idx = sys_reg_to_idx(reg_id);
 
 		for (int j = 0;  ftr_bits[j].type != FTR_END; j++) {
 			/* Skip aarch32 reg on aarch64 only system, since they are RAZ/WI. */
-- 
2.39.2

