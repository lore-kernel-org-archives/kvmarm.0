Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4C51FDA61
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769187078; cv=none; b=vE8e2YsnMgmHhQqE47hbTnWSnqwXIpPPumzLHoePukXOM+YT5xbFf1Vv0J0CHNC8PRm7R3BpQwYG6lWGUs0ijTwvSAxThHzV2HfnidueRMxgoUPgh5fmrp5LVVFyLwoVK1Lv1YQICs9q+BWJmsMRA4jLgLl+2Vdw30hQgSGEeZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769187078; c=relaxed/simple;
	bh=04bo2mqx0IPIuW/8xnTmj89YcFmkr2YUjTNj3D3TnR8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cbBZ6zerf9JKL1LjF+CUfFoSGzpYJ2SIy2xS/8iBJu5zCPNUCNLeaOSP+fO3FZSac2edy26RZzgl7B1xwR9s7YAs0vDJlVSNvh43kj1OqI603aIq2yZyrzJCfWna+szLZI94XvAqFojdLIQtqZXW6wzL80YbD3I0APKAa0Zm74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54824165C;
	Fri, 23 Jan 2026 08:51:09 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9481D3F694;
	Fri, 23 Jan 2026 08:51:14 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: alexandru.elisei@arm.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [kvm-unit-tests PATCH v6 08/14] arm64: micro-bench: use smc when at EL2
Date: Fri, 23 Jan 2026 16:50:47 +0000
Message-Id: <20260123165053.2250754-9-joey.gouly@arm.com>
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

At EL2, hvc would target the current EL, use smc so that it targets EL3.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index f47c5fc1..a6a78f20 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -282,6 +282,11 @@ static bool mmio_read_user_prep(void)
 	return true;
 }
 
+static void smc_exec(void)
+{
+	asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
+}
+
 static void mmio_read_user_exec(void)
 {
 	readl(userspace_emulated_addr);
@@ -300,6 +305,8 @@ static void eoi_exec(void)
 	write_eoir(spurious_id);
 }
 
+static bool exec_select(void);
+
 struct exit_test {
 	const char *name;
 	bool (*prep)(void);
@@ -310,7 +317,7 @@ struct exit_test {
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,			hvc_exec,		NULL,		65536,		true},
+	{"hyp_call",		exec_select,		hvc_exec,		NULL,		65536,		true},
 	{"mmio_read_user",	mmio_read_user_prep,	mmio_read_user_exec,	NULL,		65536,		true},
 	{"mmio_read_vgic",	NULL,			mmio_read_vgic_exec,	NULL,		65536,		true},
 	{"eoi",			NULL,			eoi_exec,		NULL,		65536,		true},
@@ -320,6 +327,15 @@ static struct exit_test tests[] = {
 	{"timer_10ms",		timer_prep,		timer_exec,		timer_post,	256,		true},
 };
 
+static bool exec_select(void)
+{
+	if (current_level() == CurrentEL_EL2)
+		tests[0].exec = &smc_exec;
+	else
+		tests[0].exec = &hvc_exec;
+	return true;
+}
+
 struct ns_time {
 	uint64_t ns;
 	uint64_t ns_frac;
-- 
2.25.1

