Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16892566CF
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206420; cv=none; b=h8dQRNa56JSFiEYmmWm5UgHuuQtAoFEAnyM1yFrF7a+n1nSpMqEAEQbbUHYF11EBOtLv90E7DlhuBswZCxUGO0Cyk+KYzUPUE0WEIO4nwcpywbzOnPkoMETC+dvM2i5Wa+2GwbCxmVhPdfcFtWcTtCkQawGo+IcGRSSafGhetE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206420; c=relaxed/simple;
	bh=0gFKGEvvARi/SRn906LX2/zMenWv1MDQ4Q1ZjYbkFo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SBVqdRHlq1hMQl9a9Wkj7Rq7hXMXFb9Z/P01HTA5q+k9utfgqTyR3XDi7RrzHBL2PQL8EPpMcON6jxXpFHGyDID4/O740RAatHloyrIwVuzw/NGnVCwRQGJ1leR7HvBk5oQ8AtdvX8vMH9wgohBS1AyjIo+F8fC/ahafSWIjlZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ES663g1d; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ES663g1d"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4XWVS9/h7eUhXMxOax2+CnPIZod/3R8T0gLmA/LtLm8=;
	b=ES663g1dDnkMivbNztk2hVTJxrnDvBc8jnOjIiMy2ncZEhv+/00XeFJ9Ani/p0B738uY6s
	+fHq/x/R/6eYwaPqLdrVsjPoXyz6+XO9ScS2h9F7B+6bTZMfsN3mnkD88cb+uYXiCwqW+C
	1O3IfEuOkTwOR3KQUfJ9pwcZokfdfQ4=
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
Subject: [PATCH v3 01/14] drivers/perf: apple_m1: Refactor event select/filter configuration
Date: Wed,  5 Mar 2025 12:26:28 -0800
Message-Id: <20250305202641.428114-2-oliver.upton@linux.dev>
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

Supporting guest mode events will necessitate programming two event
filters. Prepare by splitting up the programming of the event selector +
event filter into separate headers.

Opportunistically replace RMW patterns with sysreg_clear_set_s().

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 drivers/perf/apple_m1_cpu_pmu.c | 52 ++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/perf/apple_m1_cpu_pmu.c b/drivers/perf/apple_m1_cpu_pmu.c
index 06fd317529fc..cea80afd1253 100644
--- a/drivers/perf/apple_m1_cpu_pmu.c
+++ b/drivers/perf/apple_m1_cpu_pmu.c
@@ -327,11 +327,10 @@ static void m1_pmu_disable_counter_interrupt(unsigned int index)
 	__m1_pmu_enable_counter_interrupt(index, false);
 }
 
-static void m1_pmu_configure_counter(unsigned int index, u8 event,
-				     bool user, bool kernel)
+static void __m1_pmu_configure_event_filter(unsigned int index, bool user,
+					    bool kernel)
 {
-	u64 val, user_bit, kernel_bit;
-	int shift;
+	u64 clear, set, user_bit, kernel_bit;
 
 	switch (index) {
 	case 0 ... 7:
@@ -346,19 +345,24 @@ static void m1_pmu_configure_counter(unsigned int index, u8 event,
 		BUG();
 	}
 
-	val = read_sysreg_s(SYS_IMP_APL_PMCR1_EL1);
-
+	clear = set = 0;
 	if (user)
-		val |= user_bit;
+		set |= user_bit;
 	else
-		val &= ~user_bit;
+		clear |= user_bit;
 
 	if (kernel)
-		val |= kernel_bit;
+		set |= kernel_bit;
 	else
-		val &= ~kernel_bit;
+		clear |= kernel_bit;
 
-	write_sysreg_s(val, SYS_IMP_APL_PMCR1_EL1);
+	sysreg_clear_set_s(SYS_IMP_APL_PMCR1_EL1, clear, set);
+}
+
+static void __m1_pmu_configure_eventsel(unsigned int index, u8 event)
+{
+	u64 clear = 0, set = 0;
+	int shift;
 
 	/*
 	 * Counters 0 and 1 have fixed events. For anything else,
@@ -371,21 +375,29 @@ static void m1_pmu_configure_counter(unsigned int index, u8 event,
 		break;
 	case 2 ... 5:
 		shift = (index - 2) * 8;
-		val = read_sysreg_s(SYS_IMP_APL_PMESR0_EL1);
-		val &= ~((u64)0xff << shift);
-		val |= (u64)event << shift;
-		write_sysreg_s(val, SYS_IMP_APL_PMESR0_EL1);
+		clear |= (u64)0xff << shift;
+		set |= (u64)event << shift;
+		sysreg_clear_set_s(SYS_IMP_APL_PMESR0_EL1, clear, set);
 		break;
 	case 6 ... 9:
 		shift = (index - 6) * 8;
-		val = read_sysreg_s(SYS_IMP_APL_PMESR1_EL1);
-		val &= ~((u64)0xff << shift);
-		val |= (u64)event << shift;
-		write_sysreg_s(val, SYS_IMP_APL_PMESR1_EL1);
+		clear |= (u64)0xff << shift;
+		set |= (u64)event << shift;
+		sysreg_clear_set_s(SYS_IMP_APL_PMESR1_EL1, clear, set);
 		break;
 	}
 }
 
+static void m1_pmu_configure_counter(unsigned int index, unsigned long config_base)
+{
+	bool kernel = config_base & M1_PMU_CFG_COUNT_KERNEL;
+	bool user = config_base & M1_PMU_CFG_COUNT_USER;
+	u8 evt = config_base & M1_PMU_CFG_EVENT;
+
+	__m1_pmu_configure_event_filter(index, user, kernel);
+	__m1_pmu_configure_eventsel(index, evt);
+}
+
 /* arm_pmu backend */
 static void m1_pmu_enable_event(struct perf_event *event)
 {
@@ -400,7 +412,7 @@ static void m1_pmu_enable_event(struct perf_event *event)
 	m1_pmu_disable_counter(event->hw.idx);
 	isb();
 
-	m1_pmu_configure_counter(event->hw.idx, evt, user, kernel);
+	m1_pmu_configure_counter(event->hw.idx, event->hw.config_base);
 	m1_pmu_enable_counter(event->hw.idx);
 	m1_pmu_enable_counter_interrupt(event->hw.idx);
 	isb();
-- 
2.39.5

