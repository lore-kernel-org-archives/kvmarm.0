Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C292F5A17
	for <kvmarm@lists.linux.dev>; Tue, 14 Oct 2025 10:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760437287; cv=none; b=Qpd/8YbZqQ3ZX7BfEyaiqGlVal2dG33UypKDU6y/ERBXcdnagLT8dnBNTyjjggTMPnpqtss4Fus5FZm7weceLVWIjycJpb3PlvFlvdAjPaNc6gi8UcqLAD12xWGL4XXT/PjWRGDt7Darr1HQaBlD3T4ot6FbTp/fsN0mAQOOsXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760437287; c=relaxed/simple;
	bh=NkupKOVbo7cjNjVqst9xNEad9gQmRx/G5Y2VJNMv9pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDmy3x2jgZeHPAQ33/dFh6TAYjbQBI8tput+TNF9XV0XAHVHIdCAS+vPb9LsxMO7tCVRrqRxHkF2Wv3hLzJxdkEonZnXqEBdikYo1ZNBelFXDjCn9OcPv8Hn700yHgiPVMn1UEdUkPnyw7F5y/DTe4OFWcckBWJ+G/rl8skH6MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3A6D1BB2;
	Tue, 14 Oct 2025 03:21:17 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EC99C3F6A8;
	Tue, 14 Oct 2025 03:21:23 -0700 (PDT)
From: Ben Horgan <ben.horgan@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	shuah@kernel.org
Cc: Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH 2/3] KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user
Date: Tue, 14 Oct 2025 11:21:07 +0100
Message-ID: <20251014102108.2442391-3-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014102108.2442391-1-ben.horgan@arm.com>
References: <20251014102108.2442391-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ARM64_FEATURE_FIELD_BITS is set to 4 but not all ID register fields are 4
bits. See for instance ID_AA64SMFR0_EL1. The last user of this define,
ARM64_FEATURE_FIELD_BITS, is the set_id_regs selftest. Its logic assumes
the fields aren't a single bits; assert that's the case and stop using the
define. As there are no more users, ARM64_FEATURE_FIELD_BITS is removed.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/include/asm/sysreg.h                 | 2 --
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6455db1b54fd..d9aa76d08e13 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1129,8 +1129,6 @@
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
 
-#define ARM64_FEATURE_FIELD_BITS	4
-
 #ifdef __ASSEMBLY__
 
 	.macro	mrs_s, rt, sreg
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 6878ee23310e..a0b81b627037 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -268,7 +268,9 @@ static void guest_code(void)
 /* Return a safe value to a given ftr_bits an ftr value */
 uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
-	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
+	uint64_t ftr_max = ftr_bits->mask >> ftr_bits->shift;
+
+	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
@@ -320,7 +322,9 @@ uint64_t get_safe_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 /* Return an invalid value to a given ftr_bits an ftr value */
 uint64_t get_invalid_value(const struct reg_ftr_bits *ftr_bits, uint64_t ftr)
 {
-	uint64_t ftr_max = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
+	uint64_t ftr_max = ftr_bits->mask >> ftr_bits->shift;
+
+	TEST_ASSERT(ftr_max > 1, "This test doesn't support single bit features");
 
 	if (ftr_bits->sign == FTR_UNSIGNED) {
 		switch (ftr_bits->type) {
-- 
2.43.0

