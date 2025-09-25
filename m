Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F712D0601
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810320; cv=none; b=to2WRlkgMpiEWb0naujHu+GPIvMs1LjoDMA1vmVo1T64AU292/IC/1WqhEd1N+2Wu4QuxpLn9u+MqYW4LdvFld3NiF2UApPqGq07MLWjb6KMJ9zkqvUCgs3p7i9ZXh8aSeWWUdrIgqTgF++o+HKHFLLk1V/X0YOyrmoPJa4qosM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810320; c=relaxed/simple;
	bh=qIXLdy/UPD7nprbob3ifjb7b9Hg7GZgPkfWiXSOlIq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EO9DCmoRFAvN1UwXbQ1ebahQnAGKL1OmrZABBZ4MhAMuHaDXL/HGCCud7dlSKfmIUC3RbUuPmr8BQFckZ+To0y4VekCcmdVM8jFOmDY13SImVyX40C8AnPivx3xC16bu6jqtTSUWx6kXxad6GRAzFYsvqcwNhI3n/adu6YOfIiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CF3C1E5E;
	Thu, 25 Sep 2025 07:25:10 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DF2B3F694;
	Thu, 25 Sep 2025 07:25:17 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	andrew.jones@linux.dev,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v3 07/10] arm64: selftest: update test for running at EL2
Date: Thu, 25 Sep 2025 15:19:55 +0100
Message-Id: <20250925141958.468311-8-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925141958.468311-1-joey.gouly@arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexandru Elisei <alexandru.elisei@arm.com>

Remove some hard-coded assumptions that this test is running at EL1.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/selftest.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..01691389 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
 	__user_psci_system_off();
 }
 #elif defined(__aarch64__)
+static unsigned long expected_level;
 
 /*
  * Capture the current register state and execute an instruction
@@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
+	if (current_level() != expected_level)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
@@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
 		return EL0_SYNC_64;
 
 	asm volatile("mrs %0, daif" : "=r" (daif) ::);
-	expected_regs.pstate = daif | PSR_MODE_EL1h;
+	expected_regs.pstate = daif;
+	if (current_level() == CurrentEL_EL1)
+		expected_regs.pstate |= PSR_MODE_EL1h;
+	else
+		expected_regs.pstate |= PSR_MODE_EL2h;
 	return EL1H_SYNC;
 }
 
@@ -317,8 +321,8 @@ static bool check_und(void)
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
-	/* try to read an el2 sysreg from el0/1 */
-	test_exception("", "mrs x0, sctlr_el2", "", "x0");
+	/* try to read an el3 sysreg from el0/1/2 */
+	test_exception("", "mrs x0, sctlr_el3", "", "x0");
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
 
@@ -429,6 +433,10 @@ int main(int argc, char **argv)
 	if (argc < 2)
 		report_abort("no test specified");
 
+#if defined(__aarch64__)
+	expected_level = current_level();
+#endif
+
 	report_prefix_push(argv[1]);
 
 	if (strcmp(argv[1], "setup") == 0) {
-- 
2.25.1

