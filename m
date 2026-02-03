Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BC536D518
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155076; cv=none; b=ihSmR9r0EYWaPqRPhTd5mYtpoT/IUUrWxU2dmA7mYjQjtvC25F9bJcgvlqhd7UqGBjGuZhQUGNB0XNjwAv+YpxTv4DS3Wt7o6G94+vlNxl7MmDdbXPiDq7R8EAGQUSsUiRC50tnygXvjsKiwqktUw/Z55bJLQXhkhgYuocV4HNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155076; c=relaxed/simple;
	bh=qVXZ8IPwjCLNQvIFn/HEbZfyufXOViVFni/vBmRPy8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ4W+a1U3nuAS0iID+j1Xto75zW8kDz0Di8Zka5gh8z/hOxGTtWdbQ45Rbr3QibsmGn6zNepuGMp+s9Qoj9FoGK3RY47wEhgGxtmcUpx5M1BencPrd6G73vnnoIUrALtEq8PNB3qzrz+eavvL/YN5ghb04pIdnfpEFj09/qdKII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B38E339;
	Tue,  3 Feb 2026 13:44:28 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3AE633F778;
	Tue,  3 Feb 2026 13:44:29 -0800 (PST)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v4 06/41] arm64: mpam: Drop the CONFIG_EXPERT restriction
Date: Tue,  3 Feb 2026 21:43:07 +0000
Message-ID: <20260203214342.584712-7-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203214342.584712-1-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/Kconfig      | 2 +-
 drivers/resctrl/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cdcc5b76a110..0e8fa195580b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2026,7 +2026,7 @@ config ARM64_TLB_RANGE
 
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

