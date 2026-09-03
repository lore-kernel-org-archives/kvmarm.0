Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9644AE13B
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788451608; cv=none; b=k5w5jzORIO6tnGiabLGcrTSdL7GgROdAdBfc8PAMmTE5/L5dtomuivtcbmp8slgN7KSj/wCi6+lSzzSLwsKMTY4DmT7XndIgaeDdMYlxV8YvkrHaBbf+PbbvLbKNOekRJQFKxFOUhngLtbClZuOP8xi+6y4iHqHMXB/jfrh4ajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788451608; c=relaxed/simple;
	bh=D1SNoxNQ49XH9vVUtOiaYFLz5tFeBptGMBLD6AA4NL4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qImzOGhAWh7tydKiLfSFqtgZv2kDuvCFp+3lsXskcnPcF8tYbZNWqtnuk8gJ7GvcTP0QwY5f5AuWe8j+O2I/w4f9Zvp4W5SV6RgqvIwt+DnvBnI3sSW5m3ddd2hJb3zqCwMX/qwlEjaIIIVVxGAWAtzEAw7xlzNVxKRa91dFQbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kPEAUmEG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kPEAUmEG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D3501596;
	Thu,  3 Sep 2026 09:06:42 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14BBC3F673;
	Thu,  3 Sep 2026 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788451605; bh=D1SNoxNQ49XH9vVUtOiaYFLz5tFeBptGMBLD6AA4NL4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kPEAUmEG3AvDAM9qEfSpylO1EBCElN4tIojMd57cDqlzChLwStpJ9ChIzMUbjEJbU
	 H7kO1p/3TnGBAANnNiFga5gnyxv73nWHucThTEMJVvHi1XLuX6hVfsf77H1nkNlSWQ
	 64ofGs1hKuv5qEF8vlH+Iya4rt/Fc8RpwhYx5nd8=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org,
	catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: [RFC PATCH v7 05/28] perf: arm_spe_pmu: Add PMBIDR_EL1 and PMSIDR_EL1 to struct arm_spe_pmu
Date: Thu,  3 Sep 2026 17:06:00 +0100
Message-ID: <20260903160623.315525-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260903160623.315525-1-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 drivers/perf/arm_spe_pmu.c       | 3 +++
 include/linux/perf/arm_spe_pmu.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 79c571a649d5..42ba0924bd02 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1095,6 +1095,7 @@ static void __arm_spe_pmu_dev_probe(void *info)
 			"profiling buffer owned by higher exception level\n");
 		return;
 	}
+	spe_pmu->pmbidr_el1 = reg;
 
 	/* Minimum alignment. If it's out-of-range, then fail the probe */
 	fld = FIELD_GET(PMBIDR_EL1_ALIGN, reg);
@@ -1107,6 +1108,8 @@ static void __arm_spe_pmu_dev_probe(void *info)
 
 	/* It's now safe to read PMSIDR and figure out what we've got */
 	reg = read_sysreg_s(SYS_PMSIDR_EL1);
+	spe_pmu->pmsidr_el1 = reg;
+
 	if (FIELD_GET(PMSIDR_EL1_FE, reg))
 		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
 
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index af86fd184050..97b14e236fcd 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -21,6 +21,8 @@ struct arm_spe_pmu {
 	cpumask_t				supported_cpus;
 	struct hlist_node			hotplug_node;
 
+	u64					pmbidr_el1;
+	u64					pmsidr_el1;
 	int					irq; /* PPI */
 	u16					pmsver;
 	u16					min_period;
-- 
2.43.0

