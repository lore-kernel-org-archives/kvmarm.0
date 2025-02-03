Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126EB1552E0;
	Mon,  3 Feb 2025 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543408; cv=none; b=P0cC8+O6W0bkRBdWU4tzouGVvk4rBYC3ViMBG0n7eBlrhQ0/HuCY1tAAk3tjimlXli7UGl6kXjkF8Emosu41Z9BVtU0jqlHFxmoalS4agOrPUxe1Fhes8R/BzjiqaisO4aGiT7GNGPfrjBOqlM5Wm2iN3a1dRhJY87YwEBzq98c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543408; c=relaxed/simple;
	bh=YMoiz1IwW30xuvS/3gbiYu27fbDSzCf+Hk+27MpZh5k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HRfiOVRICS0Nu76e9NAZbbpLXd3KDLs5iyVqdKdU7h4C/aZ/isIMCFvadKTu5ecRlEqTp8moE/TZCWMmBIdfiZ5GmhB1XaFn+satrzvqMQ+ybuC1ym70Rkx8CDrw+HXbphRTebfsCB8DB8ha/ucbHxbRShEOUtfZJ28BI+JN+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dqILbKnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dqILbKnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B930FC4CED1;
	Mon,  3 Feb 2025 00:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543407;
	bh=YMoiz1IwW30xuvS/3gbiYu27fbDSzCf+Hk+27MpZh5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dqILbKnX9RcTtbghAlRcQhrJ00+LHmmLHnq0/inKrExKlyxXPoBKKT+HV/rTQu4he
	 z5mlKFr/eCAlN7di3QorUcd3Ob9Hgsu9rmG2bQmMvmkdY1+91muZz2lo9bNxiQOZUI
	 gJj+zuVyCqJZJUYTdzGWUufs1eXPNkakE0kyX6gmfpwPOHbAjmH+sSxFklkbsFPO+f
	 /Z6BmQr76S2OCFaANBwT6yoRpaCI8N3Dzeac172BMPuVwjTDi00oDDW8OeZL/y7wD0
	 UD3y2MS7CxHcc/d1pvX60pMfkkWc3lX3zUeEMIGBtfj9lOq+xEuGJlg9SOglpugQiJ
	 rnl7ridn+FQyw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:43:01 -0600
Subject: [PATCH v19 07/11] perf: arm_pmu: Move PMUv3-specific data
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-7-1c1300802385@kernel.org>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
In-Reply-To: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
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
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

