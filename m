Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E34426E6EB
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136501; cv=none; b=KYEO0mClvNkSEjDS66Z1vqfqjs34PmVatx25+S5tUFrsiAqYqEglfIKquKWkw4uUXaWIlV0PA9ff3i98JihzHT33+r0ffUskeOZuQ6/JOa9teO+WJpNGuYrmPd27t/vrw6n/eC0DaRnVWYRBhOulBO+rU6+zw0EdvNYrYgqfXU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136501; c=relaxed/simple;
	bh=yVUY/24Vki8aqvCsuG3Nno96RSj69t8lmdedccD31+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsWrWeqHEi8ULFsq6RgU/D9qNeF4KPvfk6dq2EV2Bm9PuXKHqbCtU93fBC8t/M+XSPAFZzWLxQPyZZ/lg3rmuCwX2zP3PGZi7cXq25+pq6kuU8LvUgqQgyxt8TR9kAqUTtF2YkwAN7jJcU7WP2FtImWbwUolrn4hV9cRj2NTE2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FCE519F6;
	Fri, 14 Nov 2025 08:08:12 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7CFD3F5A1;
	Fri, 14 Nov 2025 08:08:17 -0800 (PST)
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
Subject: [RFC PATCH v6 18/35] perf: arm_spe_pmu: Add PMSIDR_EL1 to struct arm_spe_pmu
Date: Fri, 14 Nov 2025 16:06:59 +0000
Message-ID: <20251114160717.163230-19-alexandru.elisei@arm.com>
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

The host SPE driver might find itself lagging behind the architecture
when it comes to new features, so KVM cannot rely on the 'features'
field to completely describe the SPE implementation.

Some features are advertised in PMSIDR_EL1, so teach the driver to save a
copy of PMSIDR_EL1 in struct arm_spe_pmu, from where it will be consumed
directly by KVM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 drivers/perf/arm_spe_pmu.c       | 2 ++
 include/linux/perf/arm_spe_pmu.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index 2ca3377538aa..d79f4a47c6f9 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -1069,6 +1069,8 @@ static void __arm_spe_pmu_dev_probe(void *info)
 
 	/* It's now safe to read PMSIDR and figure out what we've got */
 	reg = read_sysreg_s(SYS_PMSIDR_EL1);
+	spe_pmu->pmsidr_el1 = reg;
+
 	if (FIELD_GET(PMSIDR_EL1_FE, reg))
 		spe_pmu->features |= SPE_PMU_FEAT_FILT_EVT;
 
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
index 25425249c193..7dd1f77040c2 100644
--- a/include/linux/perf/arm_spe_pmu.h
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -22,6 +22,7 @@ struct arm_spe_pmu {
 	struct hlist_node			hotplug_node;
 
 	u64					pmbidr_el1;
+	u64					pmsidr_el1;
 	int					irq; /* PPI */
 	u16					pmsver;
 	u16					min_period;
-- 
2.51.2

