Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D171946A4;
	Wed, 26 Jun 2024 22:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441162; cv=none; b=WyPwzIoP9qmAMpv0hEdQ6Y28C2hD1NIAWSz6fE0VxB5eibNdiF3wteOrZw0+6uOUnJ7jicDuzrUz2dj2FAFf9bzb//4UVZQ184UksMSHVx/KxwNN25aXPhgLonCl2/ilJNDNIxOQmruFGrXo5Yt1eEnP8ln1BkcGOCt8Nb9shro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441162; c=relaxed/simple;
	bh=UXu/vYT7z9xueyiMh9oVfGVDaCYh7CYZteWRCP/n2vw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O4BAEFxzcPR5BvV3eHbgc223MzKHUQzNr10q3IN8MfDAyW5aw2vKftfGr6c4HFBh8DjMjGq0RP91l1Y8sIJremxdfIgiUeK0wnBcd9sIka7u9yIMoQdLU2iXyGYvTvPWk4xMfXskWEGifLin88h2nyUIRUJRfAXCq/eAl8aDpAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7A8KtU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7A8KtU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD2AC116B1;
	Wed, 26 Jun 2024 22:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441162;
	bh=UXu/vYT7z9xueyiMh9oVfGVDaCYh7CYZteWRCP/n2vw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Y7A8KtU3icL5K+CqxnTpfga9PToceSLSRlHeYiuez22VIG2THH6IZBsL4zncldrgH
	 V3fiyEYZsIDKLDnLWD7w2WSznTttuCquhxJnh6/Prt0Prehg+VLopjIHYWV/UXGrth
	 POIKJXUOlr0gCwxUuqj9cmhk2uaWqapW4eWWRNG75sc/QgHJj4sm3yNpzEMeQIsAeT
	 aRu0R6pZbHmXmGiBxe+PegdczKon/MU/jKuWvzICnLhA7WmgexgDEJYfoXwDqe1HlL
	 4HY3zqY76HPJ2g/rh0CaCGCua1Foi4WBuAA/+mwI8lK/r7Tpm+tBjA3wokmDBTl3yy
	 bXONyZNqEdULw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:27 -0600
Subject: [PATCH v2 03/12] perf/arm: Move 32-bit PMU drivers to
 drivers/perf/
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-3-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

It is preferred to put drivers under drivers/ rather than under arch/.
The PMU drivers also depend on arm_pmu.c, so it's better to place them
all together.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm/kernel/Makefile                                     |  2 --
 drivers/perf/Kconfig                                         | 12 ++++++++++++
 drivers/perf/Makefile                                        |  3 +++
 arch/arm/kernel/perf_event_v6.c => drivers/perf/arm_v6_pmu.c |  3 ---
 arch/arm/kernel/perf_event_v7.c => drivers/perf/arm_v7_pmu.c |  3 ---
 .../perf_event_xscale.c => drivers/perf/arm_xscale_pmu.c     |  3 ---
 6 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 89a77e3f51d2..aaae31b8c4a5 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -78,8 +78,6 @@ obj-$(CONFIG_CPU_XSC3)		+= xscale-cp0.o
 obj-$(CONFIG_CPU_MOHAWK)	+= xscale-cp0.o
 obj-$(CONFIG_IWMMXT)		+= iwmmxt.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_regs.o perf_callchain.o
-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event_xscale.o perf_event_v6.o \
-				   perf_event_v7.o
 AFLAGS_iwmmxt.o			:= -Wa,-mcpu=iwmmxt
 obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
 obj-$(CONFIG_VDSO)		+= vdso.o
diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
index 7526a9e714fa..aa9530b4064f 100644
--- a/drivers/perf/Kconfig
+++ b/drivers/perf/Kconfig
@@ -56,6 +56,18 @@ config ARM_PMU
 	  Say y if you want to use CPU performance monitors on ARM-based
 	  systems.
 
+config ARM_V6_PMU
+	depends on ARM_PMU && (CPU_V6 || CPU_V6K)
+	def_bool y
+
+config ARM_V7_PMU
+	depends on ARM_PMU && CPU_V7
+	def_bool y
+
+config ARM_XSCALE_PMU
+	depends on ARM_PMU && CPU_XSCALE
+	def_bool y
+
 config RISCV_PMU
 	depends on RISCV
 	bool "RISC-V PMU framework"
diff --git a/drivers/perf/Makefile b/drivers/perf/Makefile
index 29b1c28203ef..d43df81d52f7 100644
--- a/drivers/perf/Makefile
+++ b/drivers/perf/Makefile
@@ -6,6 +6,9 @@ obj-$(CONFIG_ARM_DSU_PMU) += arm_dsu_pmu.o
 obj-$(CONFIG_ARM_PMU) += arm_pmu.o arm_pmu_platform.o
 obj-$(CONFIG_ARM_PMU_ACPI) += arm_pmu_acpi.o
 obj-$(CONFIG_ARM_PMUV3) += arm_pmuv3.o
+obj-$(CONFIG_ARM_V6_PMU) += arm_v6_pmu.o
+obj-$(CONFIG_ARM_V7_PMU) += arm_v7_pmu.o
+obj-$(CONFIG_ARM_XSCALE_PMU) += arm_xscale_pmu.o
 obj-$(CONFIG_ARM_SMMU_V3_PMU) += arm_smmuv3_pmu.o
 obj-$(CONFIG_FSL_IMX8_DDR_PMU) += fsl_imx8_ddr_perf.o
 obj-$(CONFIG_FSL_IMX9_DDR_PMU) += fsl_imx9_ddr_perf.o
diff --git a/arch/arm/kernel/perf_event_v6.c b/drivers/perf/arm_v6_pmu.c
similarity index 99%
rename from arch/arm/kernel/perf_event_v6.c
rename to drivers/perf/arm_v6_pmu.c
index d9fd53841591..f7593843bb85 100644
--- a/arch/arm/kernel/perf_event_v6.c
+++ b/drivers/perf/arm_v6_pmu.c
@@ -31,8 +31,6 @@
  * enable the interrupt.
  */
 
-#if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V6K)
-
 #include <asm/cputype.h>
 #include <asm/irq_regs.h>
 
@@ -445,4 +443,3 @@ static struct platform_driver armv6_pmu_driver = {
 };
 
 builtin_platform_driver(armv6_pmu_driver);
-#endif	/* CONFIG_CPU_V6 || CONFIG_CPU_V6K */
diff --git a/arch/arm/kernel/perf_event_v7.c b/drivers/perf/arm_v7_pmu.c
similarity index 99%
rename from arch/arm/kernel/perf_event_v7.c
rename to drivers/perf/arm_v7_pmu.c
index a3322e2b3ea4..fdd936fbd188 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/drivers/perf/arm_v7_pmu.c
@@ -17,8 +17,6 @@
  *  counter and all 4 performance counters together can be reset separately.
  */
 
-#ifdef CONFIG_CPU_V7
-
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 #include <asm/irq_regs.h>
@@ -2002,4 +2000,3 @@ static struct platform_driver armv7_pmu_driver = {
 };
 
 builtin_platform_driver(armv7_pmu_driver);
-#endif	/* CONFIG_CPU_V7 */
diff --git a/arch/arm/kernel/perf_event_xscale.c b/drivers/perf/arm_xscale_pmu.c
similarity index 99%
rename from arch/arm/kernel/perf_event_xscale.c
rename to drivers/perf/arm_xscale_pmu.c
index 7a2ba1c689a7..3d8b72d6b37f 100644
--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/drivers/perf/arm_xscale_pmu.c
@@ -13,8 +13,6 @@
  * PMU structures.
  */
 
-#ifdef CONFIG_CPU_XSCALE
-
 #include <asm/cputype.h>
 #include <asm/irq_regs.h>
 
@@ -745,4 +743,3 @@ static struct platform_driver xscale_pmu_driver = {
 };
 
 builtin_platform_driver(xscale_pmu_driver);
-#endif	/* CONFIG_CPU_XSCALE */

-- 
2.43.0

