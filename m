Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795079131;
	b=XCDgCUF0lL1qZD02bq2mUGpa5vZMUKbLYheV/EeQAiG4q2qU/1XiLWJoyWEr0cX/f1pk
	 VICupQHXevoTNPd0m9COzECr85KaYKgI3oUN/23CgxlXuq0yaLWrNZfe0UCA6vx/ZUHkx
	 kLoHAT8VRF33ZI60NUmxj6F1FgMOTg2Xan+4o/iDug5Gd6NXjXG/lK+6Vmt4vdOZk8W6r
	 rSlrfKI7IyGP4VN/z8yS617+8xQQxhsZGWbY78j/L1KQ0DrDY9jYyoSLtkElofuhDYfiB
	 jxMwHsP01S627reSw6jwuNLIu9CSADunCd+VWnpmAsKsGNM/RkJEiNaHqiEa3Z8IOew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795079131;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:From:
	 Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=ZTL5VkhPoyVk3mZ3/GPqSwkMSimHGe71UsARQyK9mcY=;
	b=h4KF8x36Rby97JeAgPbqEvWTsBFvqquvFMuh1el0sksVdcmSc1oMTFjHf7Am1aAPA+5i
	 aWvCz24YEA+N4GR/+LCN6Bb0ew1SaDCLGPt2wLSTQzRLvLumcSF87O5E2fWtCBIs95H1y
	 RYS7rbB83eNCU+NWQ3K/ddRBtQY2RLuLqURlsPNoRhsGnos4OOFHQLIZUxFy+0FkvgQNR
	 fszU5sdJGYhO2tHrRwX+RwLeNAbajc6SkXPHqx1dKWENACf4eBBFqEcvWF9JNH8jqsiRh
	 2yop+Bq3UFZHFCteSGaZqYiUsPdspFQS2hCxJEIQGOV7IOMYdK30SwZSCaAoQYnbvJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="b9v9lH/v";
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED460A3802
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36ED460A3802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=b9v9lH/v
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1795079131; x=1826615131;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=jFDxjvm3K1YG8M5GQ76UzOvveXVTuRpVj2YMsjekiQY=;
  b=b9v9lH/vcvEiLm9x4/GXu/btEyT7iBUCT88hXJ7A1QjyGqNr9exxN5Z3
   QeRLloU9jm0xUqVC19gNKYWyyUTJ/HpbJQD1P4B9Yk4aXVZuz1g/Hob8m
   ZEiwVqh73DbwBVHWI/Apa75x3wHAcLCf/Hgd8VAhKm0ZYh+XmRXmaNh6E
   s9IVv4spD7DIKP3SLJV2C9gx8MIsdTsGW5zZoDflkPik6bzxwZiDzIXjT
   IxZW7Cn+84Yy/EaOEPRgkKk2JhDsaM8WxIjiUKuxELtglJGBKcsM89oj8
   JKuBlnmdBUiDEbUXU/WeOImovfMdsJnvWNlQ6bPKJsWhXekjQSva5Dr5E
   Q==;
X-CSE-ConnectionGUID: Dq9704xRRfCgpK4h+fimFA==
X-CSE-MsgGUID: CevooTNCQyy3XZokVxIgFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="262388447"
X-IronPort-AV: E=Sophos;i="6.27,220,1786978800"; 
   d="scan'208";a="262388447"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 18:05:24 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 38B824258
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:23 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id DCDFE1004176
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 09:05:22 +0000 (UTC)
Received: from [127.0.1.1] (unknown [10.124.178.20])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTP id 3E8C2100116D;
	Thu, 19 Nov 2026 09:05:14 +0000 (UTC)
From: Tomohiro Misono <misono.tomohiro@fujitsu.com>
Date: Thu, 19 Nov 2026 18:04:35 +0900
Subject: [PATCH v3 3/5] perf: arm_pmu: Add workaround for FUJITSU-MONAKA
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
Message-Id: <20261119-monaka-fix-for-upstream-v3-3-057df4d2ca3c@fujitsu.com>
References: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
In-Reply-To: <20261119-monaka-fix-for-upstream-v3-0-057df4d2ca3c@fujitsu.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795079092; l=6352;
 i=misono.tomohiro@fujitsu.com; s=20261002; h=from:subject:message-id;
 bh=jFDxjvm3K1YG8M5GQ76UzOvveXVTuRpVj2YMsjekiQY=;
 b=coHoGdg0t9qW32zRwEHR2mehgz0v+WAgvTiqgINAm73DA8nQnkiQxh+k4LjIcVvvbYC+OFU9D
 ZGtg+J6VkmmAdhHWshuZe92icEJf2taSZWkyvqG/pLBbSaLsKAs4uG+
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
Changes in v3:
 - use ERRATA_MIDR_ALL_VERSIONS macro
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
index bd9ac993495b..65bbdaf1f925 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -395,6 +395,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | MONAKA          | E#030001        | FUJITSU_ERRATUM_030001      |
 +----------------+-----------------+-----------------+-----------------------------+
+| Fujitsu        | MONAKA          | E#030002        | FUJITSU_ERRATUM_030002      |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | ASR            | ASR8601         | #8601001        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8a0c94a0c879..5a2758ad3ab0 100644
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
+	  with values within seven counts of overflow because the counter
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

