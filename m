Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801461E377E;
	Tue, 18 Feb 2025 20:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911244; cv=none; b=VLXgEW36ct1hJpu75L5ZQaBF1bDMl9x8CfvNHdT/1nGoc8CnDxsuFPRPNRERPMh4IagP5NyYdMjvz9VByytlDwbBEu4EqJMyH+U56SPEATroklHG/jRq2ucEvb+mq692OwbaT06dG7co1L5z9Ep9JDvART/eE1hst+Mkf7h/MGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911244; c=relaxed/simple;
	bh=l6TTrVAgzqUCeVudDTOcJhYY3xkL2GqGc4nae9UBVn8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A0yRNcvnjf3ksXXlxogpeSx0fIXAfVK4R7/dthaUPA8GZ86t2NmL3RKHoSs4E1lLNjBdvE2xkYsvlYiHzsSvf6R98T4dkbrNRbThnwD80yI2MtA4UP+HHYM8SmoN97Sj+tz+xx/ZD8+PBCPhHkosWsOGs8jq3j2SUxJQTtVyM8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qf7iMy0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qf7iMy0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D650C4CEE2;
	Tue, 18 Feb 2025 20:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911244;
	bh=l6TTrVAgzqUCeVudDTOcJhYY3xkL2GqGc4nae9UBVn8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Qf7iMy0vDS+qxidBsKJcljNyFXb88kz5QMvFqbsqT1WD/RiGeUuOZa5Ove2PuESRK
	 mlcYsYog+JhpZXH49tQqxM2++Qsb4s0BU0bLne4Iw7R3mxoinuG0DUvA7CckFaDqu/
	 6MqMARhiOhKpVlED2vF5kJoraRV+KZTdjpIOH70AzJid/MOQNkSIALRoFY8p1PpZLA
	 bJJnnEoTxXO3e27OJv3NtsywrktuZ5M5z/JyvuqKkNmEM3I6aHsOF7oOPQBqlKDtnF
	 YxP+c3fL+6Yy9AWV+rLLTUbBaoFqAVTvRSDAvgzASCW785vtG3qIW4Xpf3p1iTX3Gx
	 CCJ3kjaiPz3Ig==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:40:02 -0600
Subject: [PATCH v20 07/11] perf: arm_pmu: Move PMUv3-specific data
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-7-4e9922fc2e8e@kernel.org>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
In-Reply-To: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

From: Mark Rutland <mark.rutland@arm.com>

A few fields in struct arm_pmu are only used with PMUv3, and soon we
will need to add more for BRBE. Group the fields together so that we
have a logical place to add more data in future.

At the same time, remove the comment for reg_pmmir as it doesn't convey
anything useful.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/perf/arm_pmu.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 4b5b83677e3f..c70d528594f2 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -84,7 +84,6 @@ struct arm_pmu {
 	struct pmu	pmu;
 	cpumask_t	supported_cpus;
 	char		*name;
-	int		pmuver;
 	irqreturn_t	(*handle_irq)(struct arm_pmu *pmu);
 	void		(*enable)(struct perf_event *event);
 	void		(*disable)(struct perf_event *event);
@@ -102,18 +101,20 @@ struct arm_pmu {
 	int		(*map_event)(struct perf_event *event);
 	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
 	bool		secure_access; /* 32-bit ARM only */
-#define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
-	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
-#define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
-	DECLARE_BITMAP(pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
 	struct platform_device	*plat_device;
 	struct pmu_hw_events	__percpu *hw_events;
 	struct hlist_node	node;
 	struct notifier_block	cpu_pm_nb;
 	/* the attr_groups array must be NULL-terminated */
 	const struct attribute_group *attr_groups[ARMPMU_NR_ATTR_GROUPS + 1];
-	/* store the PMMIR_EL1 to expose slots */
+
+	/* PMUv3 only */
+	int		pmuver;
 	u64		reg_pmmir;
+#define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
+	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+#define ARMV8_PMUV3_EXT_COMMON_EVENT_BASE	0x4000
+	DECLARE_BITMAP(pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
 
 	/* Only to be used by ACPI probing code */
 	unsigned long acpi_cpuid;

-- 
2.47.2

