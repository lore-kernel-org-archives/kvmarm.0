Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.223
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795757854;
	b=w/v5K2IdyDuX9QF9rdVJEV4eL6zwEvXU1FRMws6FXB5Ja+l42bUbo6AyUyJ75QHTubzG
	 46BLkr6w7x14imxpWVXgDickpXtZafQwfGf2KaVVUFhXZPmkhs1dsvtduZXfNaMF/GVbD
	 8TZF/gfdc354MM1C9j5UrgL6Olr6t/apvD7Xf2VwpV++i/rG5JPWKo60ExcAfmP7v+6+N
	 jCb3w6qfoIMIPM+6GpmWT4iEAHnhAlPMk0d5gtapF9C6Q7K1ybE9j0JVFR8LHs6tyXt/W
	 0l1wJRzxVESxUFvXrhjAGLD+MPj6IPE7uJpS4UE+eCPA2kwAaRghtry5lnh1gcqLk0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795757854;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=JPhQEI9frtB4q1Dy2GrCVUf3Smezhd3saqs/6akCHv4=;
	b=OG1oOLACVaSKAIkSu3AY9ezIPvxn+pGt6DmIFk9B6RK0YI/NFpzrYnGh1WL0qykAnr25
	 1E93pjPmrrpP58nUVudXoPJ7rBq2uKJWfmQL0f6wGJopN2W52XBrv+hHSAA0URtH498a3
	 N5iuuMVaPGsv43oFskbeUgUEoQazMkryzkqh1c92z59JJJAsewWufVW4vaLcESfZM6BAX
	 eJ4yDrcPsGWITIs5qX9Ts9UR+BTFkVEiTNolmbZsnVWEQ8oudWFr3IPELUpqCVwRUFcnR
	 /k745GGFNHElm5lerwTDdQhR8aSyxKoIa0n1mQ843rp/Jtv6hwwyUFf11YMCEnw6bLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=rPT9X2fF;
	arc=none smtp.remote-ip=139.138.36.223
Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E35606A332
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6E35606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=rPT9X2fF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795757854; x=1827293854;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=fzn0m2Y9zbD6PJz9nHijaT4lZZ91hzz4BOhR03gov3k=;
  b=rPT9X2fFPOHgD+PzGJXtzgA8H7NgoADHW8BIi4gMIuCKvGif9i4hka7o
   jnYKJVbaNKLgA7Jw/tgxJ6MN/HJE7BxgrFcNUiFAAALS/nJeHhwQ9oi7Z
   Epq42gCQ3dUKbgD/bCKo2ykpy2xX4XYpuRmDwynHfv9mXA2Tah5+JNewv
   BBhdACMtmTG7gKbDqdyC/D61bb0Lf84s2ySP5n/TD0VEhNQ8JBmXB2hxB
   ohl/Sl9cy3qkaOGKKvnHKpk+3J/b3seMXGe56akqY2SVfmfZ3PlcG5XBH
   02WAyhoVhNfhyDOmeNbu/iTaXaW8o3MC+8dQS6lqyqxU/SfGz+Y9lLQAk
   w==;
X-CSE-ConnectionGUID: WQ95D163RxuFHhH8dFHodg==
X-CSE-MsgGUID: DhTngBBTRg27gLxs6LilXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="250860252"
X-IronPort-AV: E=Sophos;i="6.27,236,1786978800"; 
   d="scan'208";a="250860252"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2026 14:37:32 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 768098317F8
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:32 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 2A4751400625
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 05:37:32 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id BA87D40262B;
	Fri, 27 Nov 2026 05:37:24 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Fri, 27 Nov 2026 14:36:32 +0900
Subject: [PATCH v4 3/5] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
 Erratum E#030002
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-monaka-fix-for-upstream-v4-3-3395c415bbe4@fujitsu.com>
References: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
In-Reply-To: <20261127-monaka-fix-for-upstream-v4-0-3395c415bbe4@fujitsu.com>
To: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Marc Zyngier <maz@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Kohei Enju <enju.kohei@fujitsu.com>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795757822; l=6405;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=fzn0m2Y9zbD6PJz9nHijaT4lZZ91hzz4BOhR03gov3k=;
 b=pQN0YRwT/DIz0WsXrZxlQA+PWskrISVPrV1qBaecvyNeOYSD+Emym9n9ZskRz7YIgWc/Y0sMV
 Q+tMiwNuX31AQS2D5fTL/D+clAQgrN7dHPYUQUVXZ5Dil1BrUaFFNTo
X-Developer-Key: i=misono.tomohiro@fujitsu.com; a=ed25519;
 pk=VLRxj5y4GJrHLmj3e2NBg30fX2U//ydi7c2G2qiNo10=

FUJITSU-MONAKA Erratum E#030002 affects FUJITSU-MONAKA CPU.

On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
stopped at a value just before overflow, an overflow might still
be incorrectly detected, resulting interrupt storm in some case.

For example, if the following conditions are met:
  1) Running perf to count an event in user space only
  2) The event can also occur in kernel space
  3) The counter value is set just before the overflow
     (when using the -F option, initial counter value is -1)

when the kernel is about to return to user space after enabling
the count, an overflow interrupt is incorrectly triggered by an
event that occurred in kernel space. Since the counter value is
not updated (correctly), the interrupt handler does nothing and
returns with the same condition. This leads to another wrong interrupt
and results in an interrupt storm and eventually a softlockup.

Work around the erratum by avoiding programming PMU event counters
with values within 7 counts of overflow because the counter
can increase up to 7 at a time.

Signed-off-by: Tomohiro Misono <misono.tomohiro@fujitsu.com>

---
Changes in v4:
 - Update minor wording. No code change
Changes in v3:
 - Use ERRATA_MIDR_ALL_VERSIONS macro
 - Correct the maximum number of increments at a time from 5 to 7,
   since it was found that micro-op fusion can increase the number
   of evetns counted at a time for certain events.
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 arch/arm64/Kconfig                          | 18 ++++++++++++++++++
 arch/arm64/include/asm/cpucaps.h            |  2 ++
 arch/arm64/kernel/cpu_errata.c              |  7 +++++++
 arch/arm64/tools/cpucaps                    |  1 +
 drivers/perf/arm_pmu.c                      | 13 +++++++++++++
 6 files changed, 43 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 751f478a71b7..01db1b906ba4 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -401,6 +401,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | MONAKA          | E#030001        | FUJITSU_ERRATUM_030001      |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA          | E#030002        | FUJITSU_ERRATUM_030002      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8a0c94a0c879..2f195da6dd1c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1402,6 +1402,24 @@ config FUJITSU_ERRATUM_030001
 
 	  If unsure, say Y.
 
+config FUJITSU_ERRATUM_030002
+	bool "FUJITSU-MONAKA erratum E#030002: PMU overflow may be incorrectly detected"
+	depends on ARM_PMUV3
+	default y
+	help
+	  This option adds a workaround for FUJITSU-MONAKA erratum E#030002.
+	  On affected FUJITSU-MONAKA CPUs, after a PMU event counter is
+	  stopped at a value just before overflow, an overflow might still
+	  be incorrectly detected, resulting interrupt storm in some case.
+
+	  Work around the erratum by avoiding programming PMU event counters
+	  with values within 7 counts of overflow because the counter
+	  can increase up to 7 at a time.
+
+	  The workaround only affects the FUJITSU-MONAKA.
+
+	  If unsure, say Y.
+
 config HISILICON_ERRATUM_161600802
 	bool "Hip07 161600802: Erroneous redistributor VLPI base"
 	default y
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 7c73a739eee1..f4aa6bd257c5 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -70,6 +70,8 @@ cpucap_is_possible(const unsigned int cap)
 		return IS_ENABLED(CONFIG_NXP_IMX8QM_ERRATUM_ERR050104);
 	case ARM64_WORKAROUND_FUJITSU_030001:
 		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030001);
+	case ARM64_WORKAROUND_FUJITSU_030002:
+		return IS_ENABLED(CONFIG_FUJITSU_ERRATUM_030002);
 	case ARM64_MPAM:
 		/*
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index c8a0ea73ec1a..37bbe8268499 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -1102,6 +1102,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.capability = ARM64_WORKAROUND_FUJITSU_030001,
 		ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
 	},
+#endif
+#ifdef CONFIG_FUJITSU_ERRATUM_030002
+	{
+		.desc = "FUJITSU-MONAKA Erratum E#030002",
+		.capability = ARM64_WORKAROUND_FUJITSU_030002,
+		ERRATA_MIDR_ALL_VERSIONS(MIDR_FUJITSU_MONAKA),
+	},
 #endif
 	{
 		.desc = "Known broken GICv3 SEIS implementation",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1a199502614d..73a4aeb535a0 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -135,3 +135,4 @@ WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 WORKAROUND_BROKEN_AMU_CONSTCNT
 WORKAROUND_BROKEN_AMU_CORECNT
 WORKAROUND_FUJITSU_030001
+WORKAROUND_FUJITSU_030002
diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 115069565389..bbf9f3a52adf 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -234,6 +234,19 @@ int armpmu_event_set_period(struct perf_event *event)
 	if (left > (max_period >> 1))
 		left = (max_period >> 1);
 
+#if IS_ENABLED(CONFIG_ARM64)
+	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_FUJITSU_030002)) {
+		/*
+		 * Due to the errata, overflow might be incorrectly detected in the handler
+		 * when the counter is about to overflow in a single increment, resulting
+		 * interrupt storm in some case. As the counter can increase by up to
+		 * 7 at a time, set 8 here to prevent the condition.
+		 */
+		if (left > 0 && left < 8)
+			left = 8;
+	}
+#endif
+
 	local64_set(&hwc->prev_count, (u64)-left);
 
 	armpmu->write_counter(event, (u64)(-left) & max_period);

-- 
2.43.0

