Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D313B315D2F
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136489; cv=none; b=dFqhVegyXnUesWSjG8sX58iROWTJEGBIoHQ2W7z8pVWsfxanOYUop+iXODOd27tDR1X0BNH+QDx6xA5w1rNM+V9AQ/440qdgPF5asOXxSTHjlAJrDGnZVOcNQ0n1KHiNbc7xee7V1Y1LtduRuezGEu7TgsHfPkuZ6qgkBP0oRos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136489; c=relaxed/simple;
	bh=+Lxb31ZmPz8/hCUTC1OecaIetyCSifr4zv1ioHvk3XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPfvFtvlf3SI8TXIzFze6FRXStN+DxU9KhV27D960Ga+LJPJAUi100XXYqe7WmFSTYRmVLXcKfMPzN5L2Yr4rW+Ez/pin7nNJKH91wVhtznP4HMjYWk67NzvCmGEE8HeMF1/lmHqU38z6axts1nEGr8OUgGHgQaZm3Xk3SUdZQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F96619F6;
	Fri, 14 Nov 2025 08:07:59 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 112363F5A1;
	Fri, 14 Nov 2025 08:08:04 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 13/35] perf: arm_spe_pmu: Add PMBIDR_EL1 to struct arm_spe_pmu
Date: Fri, 14 Nov 2025 16:06:54 +0000
Message-ID: <20251114160717.163230-14-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the read-only register PMBIDR_EL1 to struct arm_spe_pmu, as KVM will
need it to virtualize SPE and it saves KVM having to read the hardware
register each time a guest accesses it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 drivers/perf/arm_spe_pmu.c       | 1 +
 include/linux/perf/arm_spe_pmu.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 66ae36d4d32e..2ca3377538aa 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1056,6 +1056,7 @@ static void __arm_spe_pmu_dev_probe(void *info)
 			"profiling buffer owned by higher exception level\n");
 		return;
 	}
+	spe_pmu->pmbidr_el1 = reg;
 
 	/* Minimum alignment. If it's out-of-range, then fail the probe */
 	fld = FIELD_GET(PMBIDR_EL1_ALIGN, reg);
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index 8a2db0e03e45..25425249c193 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -21,6 +21,7 @@ struct arm_spe_pmu {
 	cpumask_t				supported_cpus;
 	struct hlist_node			hotplug_node;
 
+	u64					pmbidr_el1;
 	int					irq; /* PPI */
 	u16					pmsver;
 	u16					min_period;
-- 
2.51.2

