Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30322566F9
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206424; cv=none; b=GhxlAH39wr6CV8eEFfufsba/dvgvTv53YjNQCjSvgQwcsf2CR1ZeB2VogBgl1WJTV4uBFClVTHP6/JBDxbONMy6nsdM6wITWK6QeAy7/8pccVXkkV9XH5AxQZs0SOgoYMkb/7l6Lt/lk4ZGZtvYNKOisXYagCUAfifpLiJS4Se4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206424; c=relaxed/simple;
	bh=82pQFF5TJWTGnuUtsQ9t/PIiYpetCGBPDoLe7JOXPO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DucIfF0h/oqjO9AGpUIfS3j1svbRw8BMhXuwUkrfGLJ9J5IQUiF1I18UTNncY5pDRyD1SaDsUFiH3AYIDFm9lrdUDqt+4MwAm3RE9pK+HWOHxIDEQ0SR7YCw/6JNyaDtSjCFKSmFu7qAlN/xcU/pSlrn212J2MBD5nDAonrTodI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BBrLbbi5; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BBrLbbi5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+69dsXa194Lbj7OuVGODh/C+nXkT1DCOFxIShuli7hw=;
	b=BBrLbbi5SmryGjedtHNKZjPmGNHNieIuBF/e4ufYwqwbc13QlAWi9ygpumye6NRbjVycaQ
	rZe/1pO1JG7el8o+nDW0nq2sEU6hPXKdYo38vEOdX9u8zqtaDGAOLsP2wmrInX0lhqb8ha
	2eehc4M5SRjonnP61pNgHWVH2gkJFdg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 02/14] drivers/perf: apple_m1: Support host/guest event filtering
Date: Wed,  5 Mar 2025 12:26:29 -0800
Message-Id: <20250305202641.428114-3-oliver.upton@linux.dev>
In-Reply-To: <20250305202641.428114-1-oliver.upton@linux.dev>
References: <20250305202641.428114-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The PMU appears to have a separate register for filtering 'guest'
exception levels (i.e. EL1 and !ELIsInHost(EL0)) which has the same
layout as PMCR1_EL1. Conveniently, there exists a VHE register alias
(PMCR1_EL12) that can be used to configure it.

Support guest events by programming the EL12 register with the intended
guest kernel/userspace filters. Limit support for guest events to VHE
(i.e. kernel running at EL2), as it avoids involving KVM to context
switch PMU registers. VHE is the only supported mode on M* parts anyway,
so this isn't an actual feature limitation.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/apple_m1_pmu.h |  1 +
 drivers/perf/apple_m1_cpu_pmu.c       | 20 ++++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/apple_m1_pmu.h b/arch/arm64/include/asm/apple_m1_pmu.h
index 99483b19b99f..02e05d05851f 100644
--- a/arch/arm64/include/asm/apple_m1_pmu.h
+++ b/arch/arm64/include/asm/apple_m1_pmu.h
@@ -37,6 +37,7 @@
 #define PMCR0_PMI_ENABLE_8_9	GENMASK(45, 44)
 
 #define SYS_IMP_APL_PMCR1_EL1	sys_reg(3, 1, 15, 1, 0)
+#define SYS_IMP_APL_PMCR1_EL12	sys_reg(3, 1, 15, 7, 2)
 #define PMCR1_COUNT_A64_EL0_0_7	GENMASK(15, 8)
 #define PMCR1_COUNT_A64_EL1_0_7	GENMASK(23, 16)
 #define PMCR1_COUNT_A64_EL0_8_9	GENMASK(41, 40)
diff --git a/drivers/perf/apple_m1_cpu_pmu.c b/drivers/perf/apple_m1_cpu_pmu.c
index cea80afd1253..d6d4ff6da862 100644
--- a/drivers/perf/apple_m1_cpu_pmu.c
+++ b/drivers/perf/apple_m1_cpu_pmu.c
@@ -120,6 +120,8 @@ enum m1_pmu_events {
 	 */
 	M1_PMU_CFG_COUNT_USER					= BIT(8),
 	M1_PMU_CFG_COUNT_KERNEL					= BIT(9),
+	M1_PMU_CFG_COUNT_HOST					= BIT(10),
+	M1_PMU_CFG_COUNT_GUEST					= BIT(11),
 };
 
 /*
@@ -328,7 +330,7 @@ static void m1_pmu_disable_counter_interrupt(unsigned int index)
 }
 
 static void __m1_pmu_configure_event_filter(unsigned int index, bool user,
-					    bool kernel)
+					    bool kernel, bool host)
 {
 	u64 clear, set, user_bit, kernel_bit;
 
@@ -356,7 +358,10 @@ static void __m1_pmu_configure_event_filter(unsigned int index, bool user,
 	else
 		clear |= kernel_bit;
 
-	sysreg_clear_set_s(SYS_IMP_APL_PMCR1_EL1, clear, set);
+	if (host)
+		sysreg_clear_set_s(SYS_IMP_APL_PMCR1_EL1, clear, set);
+	else if (is_kernel_in_hyp_mode())
+		sysreg_clear_set_s(SYS_IMP_APL_PMCR1_EL12, clear, set);
 }
 
 static void __m1_pmu_configure_eventsel(unsigned int index, u8 event)
@@ -391,10 +396,13 @@ static void __m1_pmu_configure_eventsel(unsigned int index, u8 event)
 static void m1_pmu_configure_counter(unsigned int index, unsigned long config_base)
 {
 	bool kernel = config_base & M1_PMU_CFG_COUNT_KERNEL;
+	bool guest = config_base & M1_PMU_CFG_COUNT_GUEST;
+	bool host = config_base & M1_PMU_CFG_COUNT_HOST;
 	bool user = config_base & M1_PMU_CFG_COUNT_USER;
 	u8 evt = config_base & M1_PMU_CFG_EVENT;
 
-	__m1_pmu_configure_event_filter(index, user, kernel);
+	__m1_pmu_configure_event_filter(index, user && host, kernel && host, true);
+	__m1_pmu_configure_event_filter(index, user && guest, kernel && guest, false);
 	__m1_pmu_configure_eventsel(index, evt);
 }
 
@@ -570,7 +578,7 @@ static int m1_pmu_set_event_filter(struct hw_perf_event *event,
 {
 	unsigned long config_base = 0;
 
-	if (!attr->exclude_guest) {
+	if (!attr->exclude_guest && !is_kernel_in_hyp_mode()) {
 		pr_debug("ARM performance counters do not support mode exclusion\n");
 		return -EOPNOTSUPP;
 	}
@@ -578,6 +586,10 @@ static int m1_pmu_set_event_filter(struct hw_perf_event *event,
 		config_base |= M1_PMU_CFG_COUNT_KERNEL;
 	if (!attr->exclude_user)
 		config_base |= M1_PMU_CFG_COUNT_USER;
+	if (!attr->exclude_host)
+		config_base |= M1_PMU_CFG_COUNT_HOST;
+	if (!attr->exclude_guest)
+		config_base |= M1_PMU_CFG_COUNT_GUEST;
 
 	event->config_base = config_base;
 
-- 
2.39.5

