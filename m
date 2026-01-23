Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25A4F285CBA
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187079; cv=none; b=dfeecJT7hsI60p0tUv6urHmacHabZXX28npw5qEWzpTStxeVALlYiiVNukhKcfH0mnlt9aOZUPs9xIOdRj+Nb63R2W/OnP+r3BmU88Gm8ZSaKsWGUEsHcidrYC5kMCmsjv/mynkcY4d8qVR6JrGpP9nEIG2khS+5iEav+hhFJTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187079; c=relaxed/simple;
	bh=8/5lADa9rJezdsohxT7wJlEG5NWEkbPeJiQJa1AUzkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mGyD9XmvKDYJUJ4fmr65zhmbKrKuLTmQ5xuVV3VzkyN1FLUOaDSyc2rUO8niFL4AzcmweDFY1P+rgXr2ESJK+0GHPzyxYdslQfRZqXVpQdNexKSq6SFgAhNuqQHGAp9e+ROoWZohQZYO1o/TX+7IT02CaSya3XH2irHgpDQHUYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08D911688;
	Fri, 23 Jan 2026 08:51:11 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34A5F3F694;
	Fri, 23 Jan 2026 08:51:16 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 09/14] arm64: selftest: update test for running at EL2
Date: Fri, 23 Jan 2026 16:50:48 +0000
Message-Id: <20260123165053.2250754-10-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
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
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/selftest.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 1553ed8e..33f4cf42 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -106,6 +106,8 @@ static bool und_works;
 static bool svc_works;
 static bool pabt_works;
 #if defined(__arm__)
+static void test_exception_prep(void) { }
+
 /*
  * Capture the current register state and execute an instruction
  * that causes an exception. The test handler will check that its
@@ -232,6 +234,12 @@ static void user_psci_system_off(struct pt_regs *regs)
 	__user_psci_system_off();
 }
 #elif defined(__aarch64__)
+static unsigned long expected_level;
+
+static void test_exception_prep(void)
+{
+	expected_level = current_level();
+}
 
 /*
  * Capture the current register state and execute an instruction
@@ -276,8 +284,7 @@ static bool check_regs(struct pt_regs *regs)
 {
 	unsigned i;
 
-	/* exception handlers should always run in EL1 */
-	if (current_level() != CurrentEL_EL1)
+	if (current_level() != expected_level)
 		return false;
 
 	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
@@ -301,7 +308,11 @@ static enum vector check_vector_prep(void)
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
 
@@ -317,8 +328,8 @@ static bool check_und(void)
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
 
-	/* try to read an el2 sysreg from el0/1 */
-	test_exception("", "mrs x0, sctlr_el2", "", "x0");
+	/* try to read an el3 sysreg from el0/1/2 */
+	test_exception("", "mrs x0, sctlr_el3", "", "x0");
 
 	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
 
@@ -426,6 +437,8 @@ int main(int argc, char **argv)
 {
 	report_prefix_push("selftest");
 
+	test_exception_prep();
+
 	if (argc < 2)
 		report_abort("no test specified");
 
-- 
2.25.1

