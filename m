Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B713AA1AD
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955886; cv=none; b=RWGKzUNMUF74Ya/4i+LMNfkhX6+6EftjU/ONprVobFi+fPRgQJuiM0GT4Y2RFpv9cpXDZEn/phQNzDMHTzHucgUQCxS3JySQ8onzcIHuw/ZqX9tvGCvVBUHVKTjFwIM6MIAZdTruoSJnPeOOOQwWWUqP0yV7RYRHIHHWh/5MAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955886; c=relaxed/simple;
	bh=TSjndDpoF8sLCKLSYo5FA8bPbJoFsrV4EPhrhOB2BDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBi6DA5RunesGXtkd2nqFRVDnR702q7fM8igkTsQleCMWrVli5AY4FyGnxU0cgV/KtYZc0UELl0xIgWWC7Rg4J7emkAItiQBwmX4vVV9FvJmugPMoASV/AmGjlffasBSUUHVrqXhyVxaR7Su8vRaz1nCfHkU8pZUCZ4a+fh0xLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAB25339;
	Tue, 24 Feb 2026 09:57:58 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 347473F59E;
	Tue, 24 Feb 2026 09:58:00 -0800 (PST)
From: Ben Horgan <ben.horgan@arm.com>
To: ben.horgan@arm.com
Cc: amitsinght@marvell.com,
	baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com,
	carl@os.amperecomputing.com,
	dave.martin@arm.com,
	david@kernel.org,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	gshan@redhat.com,
	james.morse@arm.com,
	jonathan.cameron@huawei.com,
	kobak@nvidia.com,
	lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peternewman@google.com,
	punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com,
	reinette.chatre@intel.com,
	rohit.mathew@arm.com,
	scott@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	zengheng4@huawei.com,
	linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v5 06/41] arm64: mpam: Drop the CONFIG_EXPERT restriction
Date: Tue, 24 Feb 2026 17:56:45 +0000
Message-ID: <20260224175720.2663924-7-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224175720.2663924-1-ben.horgan@arm.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.

Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/Kconfig      | 2 +-
 drivers/resctrl/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ecaaca13a969..3170c67464fb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2016,7 +2016,7 @@ config ARM64_TLB_RANGE
 
 config ARM64_MPAM
 	bool "Enable support for MPAM"
-	select ARM64_MPAM_DRIVER if EXPERT	# does nothing yet
+	select ARM64_MPAM_DRIVER
 	select ACPI_MPAM if ACPI
 	help
 	  Memory System Resource Partitioning and Monitoring (MPAM) is an
diff --git a/drivers/resctrl/Kconfig b/drivers/resctrl/Kconfig
index c808e0470394..c34e059c6e41 100644
--- a/drivers/resctrl/Kconfig
+++ b/drivers/resctrl/Kconfig
@@ -1,6 +1,6 @@
 menuconfig ARM64_MPAM_DRIVER
 	bool "MPAM driver"
-	depends on ARM64 && ARM64_MPAM && EXPERT
+	depends on ARM64 && ARM64_MPAM
 	help
 	  Memory System Resource Partitioning and Monitoring (MPAM) driver for
 	  System IP, e.g. caches and memory controllers.
-- 
2.43.0

