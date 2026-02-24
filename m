Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC7E3ACA73
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956043; cv=none; b=WqzILnYj3oAUCL0fdlO1erVNzmgK2qc+b7T4Jj2FHcRoGd+zN/f/mbtq0vD9uxrP8iv2ychpzUGJwAP5mRJanhaNpTOFns1B+d3PL/IY2HHERJzEURQ1ai/VJcbQZZrdFXZBizJX21vpWhVUIuXp01wcuUzgt+eR0hG8GCAIJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956043; c=relaxed/simple;
	bh=aeoayjhR4Env2BNgftLhVVIzl3HS70cLB7bRb+1LXBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS1otvmJHCwYdeWlLTxdjqZwvHZIBSaTQzanA5nK5rq8tMPIr2S6qpkeROB7c83HUQSOGFCMymxh0X2kcbKSPwpWCAl++mffhSAU4fGw6HOoBupMCeolDRGfYtP7gw73bMAXuSDecqnj4mGN1U0gU5Bj2WIjP3jIBoOBIJMht/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A61BC1595;
	Tue, 24 Feb 2026 10:00:35 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 40D733F59E;
	Tue, 24 Feb 2026 10:00:36 -0800 (PST)
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
Subject: [PATCH v5 34/41] arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
Date: Tue, 24 Feb 2026 17:57:13 +0000
Message-ID: <20260224175720.2663924-35-ben.horgan@arm.com>
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

From: James Morse <james.morse@arm.com>

Enough MPAM support is present to enable ARCH_HAS_CPU_RESCTRL.  Let it
rip^Wlink!

ARCH_HAS_CPU_RESCTRL indicates resctrl can be enabled. It is enabled by the
arch code simply because it has 'arch' in its name.

This removes ARM_CPU_RESCTRL as a mimic of X86_CPU_RESCTRL.  While here,
move the ACPI dependency to the driver's Kconfig file.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/Kconfig               | 2 +-
 arch/arm64/include/asm/resctrl.h | 2 ++
 drivers/resctrl/Kconfig          | 7 +++++++
 drivers/resctrl/Makefile         | 2 +-
 4 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/resctrl.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3170c67464fb..41a5b4ef86b4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2017,7 +2017,7 @@ config ARM64_TLB_RANGE
 config ARM64_MPAM
 	bool "Enable support for MPAM"
 	select ARM64_MPAM_DRIVER
-	select ACPI_MPAM if ACPI
+	select ARCH_HAS_CPU_RESCTRL
 	help
 	  Memory System Resource Partitioning and Monitoring (MPAM) is an
 	  optional extension to the Arm architecture that allows each
diff --git a/arch/arm64/include/asm/resctrl.h b/arch/arm64/include/asm/resctrl.h
new file mode 100644
index 000000000000..b506e95cf6e3
--- /dev/null
+++ b/arch/arm64/include/asm/resctrl.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/arm_mpam.h>
diff --git a/drivers/resctrl/Kconfig b/drivers/resctrl/Kconfig
index c34e059c6e41..672abea3b03c 100644
--- a/drivers/resctrl/Kconfig
+++ b/drivers/resctrl/Kconfig
@@ -1,6 +1,7 @@
 menuconfig ARM64_MPAM_DRIVER
 	bool "MPAM driver"
 	depends on ARM64 && ARM64_MPAM
+	select ACPI_MPAM if ACPI
 	help
 	  Memory System Resource Partitioning and Monitoring (MPAM) driver for
 	  System IP, e.g. caches and memory controllers.
@@ -22,3 +23,9 @@ config MPAM_KUNIT_TEST
 	  If unsure, say N.
 
 endif
+
+config ARM64_MPAM_RESCTRL_FS
+	bool
+	default y if ARM64_MPAM_DRIVER && RESCTRL_FS
+	select RESCTRL_RMID_DEPENDS_ON_CLOSID
+	select RESCTRL_ASSIGN_FIXED
diff --git a/drivers/resctrl/Makefile b/drivers/resctrl/Makefile
index 40beaf999582..4f6d0e81f9b8 100644
--- a/drivers/resctrl/Makefile
+++ b/drivers/resctrl/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_ARM64_MPAM_DRIVER)			+= mpam.o
 mpam-y						+= mpam_devices.o
-mpam-$(CONFIG_ARM_CPU_RESCTRL)			+= mpam_resctrl.o
+mpam-$(CONFIG_ARM64_MPAM_RESCTRL_FS)		+= mpam_resctrl.o
 
 ccflags-$(CONFIG_ARM64_MPAM_DRIVER_DEBUG)	+= -DDEBUG
-- 
2.43.0

