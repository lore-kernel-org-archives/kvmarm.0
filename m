Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960612BF001
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764065545; cv=none; b=JurtOzWWKsKcwmhka0dyRwnKB1qxACwhMRFgXIkAof/RLQ+G2R3rBNrZvThxwWbUohhmggGvxO/+oWMsoXZxStro1iyJBiNE27mgKS69+w8u0xRsLWsGDYhMLHPQ2ppdcmgl++oo1++GfSpWcm3UJ940Ms/5Sn6evvtuFfqeZPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764065545; c=relaxed/simple;
	bh=PHTNPToCewqYjcqm+0nHxCmf071DNPYGr6VAKge5J8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lcf13QzNUxZ2vcM3EKpRfmU4st9m0sql1cQy0PYDHhUtEFE5AWpDjx/qVk5laJ7wC+uIk8l3JrjJMhy5MrzkB2M+G5o+ZqAg1VT9IdS7awevCKL6/K4YAC9z2vFAZqRLLm5jzHRzBYmxsBLKGWZOdQAFAs1/cXlGVdkAiRYbmSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 380C714BF;
	Tue, 25 Nov 2025 02:12:15 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 173B53F86F;
	Tue, 25 Nov 2025 02:12:20 -0800 (PST)
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
Subject: [PATCH v2 1/2] KVM: arm64: selftests: Remove ARM64_FEATURE_FIELD_BITS and its last user
Date: Tue, 25 Nov 2025 10:12:06 +0000
Message-ID: <20251125101207.1492580-2-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251125101207.1492580-1-ben.horgan@arm.com>
References: <20251125101207.1492580-1-ben.horgan@arm.com>
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
define. As there are no more users, ARM64_FEATURE_FIELD_BITS is removed
from the arm64 tools sysreg.h header. A separate commit removes this from
the kernel version of the header.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
Remove ARM64_FEATURE_FIELD_BITS from tools header instead of the kernel
header
---
 tools/arch/arm64/include/asm/sysreg.h           | 2 --
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index 65f2759ea27a..0f60b68eac1b 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -1078,8 +1078,6 @@
 #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
 					       GCS_CAP_VALID_TOKEN)
 
-#define ARM64_FEATURE_FIELD_BITS	4
-
 #ifdef __ASSEMBLY__
 
 	.macro	mrs_s, rt, sreg
diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 5e24f77868b5..5fbcf5d1f168 100644
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

