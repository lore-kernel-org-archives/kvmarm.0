Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF1C3ACA5F
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955892; cv=none; b=FXfaJIk3iOIrZHSV/o9G+xHg9XtGfhYqVRXCiwasYI6QCgczD2RtJ3Y71FM3flaf06PUiWK0UOzGNcwYQ8eJjYQDoaVmF09AQ66d+ToAhHhlIrZGWoCKmxbKxrGY1wIJeHYIFfG16SgGlAfYnxpoaVDd3HjCUjFWyWucSD4xdBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955892; c=relaxed/simple;
	bh=4UUUARrDkFWzmwzsVjvKwoVpCCi6oZGVbPhZNyr5L+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj0/cxpQdtJgKylETgTpqo1wWzETuvjzf61GDUXUtrnWuw90KbzB/6OdXXvNiGr7vXJtzd6xdYJsnipO8vi53FjeanQK2rgMhjCrzsHSo/UnCiFv8hpyI7MZe1nZL5TdbdgNNKti9XYbij99MkBh7kSzoYUj6l4fsZ9La5lyJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D32D2339;
	Tue, 24 Feb 2026 09:58:03 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3CFE63F59E;
	Tue, 24 Feb 2026 09:58:05 -0800 (PST)
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
Subject: [PATCH v5 07/41] arm64: mpam: Advertise the CPUs MPAM limits to the driver
Date: Tue, 24 Feb 2026 17:56:46 +0000
Message-ID: <20260224175720.2663924-8-ben.horgan@arm.com>
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

Requestors need to populate the MPAM fields for any traffic they send on
the interconnect. For the CPUs these values are taken from the
corresponding MPAMy_ELx register. Each requestor may have a limit on the
largest PARTID or PMG value that can be used. The MPAM driver has to
determine the system-wide minimum supported PARTID and PMG values.

To do this, the driver needs to be told what each requestor's limit is.

CPUs are special, but this infrastructure is also needed for the SMMU and
GIC ITS. Call the helper to tell the MPAM driver what the CPUs can do.

The return value can be ignored by the arch code as it runs well before the
MPAM driver starts probing.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/kernel/mpam.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
index 9866d2ca0faa..e6feff2324ac 100644
--- a/arch/arm64/kernel/mpam.c
+++ b/arch/arm64/kernel/mpam.c
@@ -3,6 +3,7 @@
 
 #include <asm/mpam.h>
 
+#include <linux/arm_mpam.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 
@@ -11,3 +12,14 @@ DEFINE_PER_CPU(u64, arm64_mpam_default);
 DEFINE_PER_CPU(u64, arm64_mpam_current);
 
 u64 arm64_mpam_global_default;
+
+static int __init arm64_mpam_register_cpus(void)
+{
+	u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
+	u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
+	u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
+
+	return mpam_register_requestor(partid_max, pmg_max);
+}
+/* Must occur before mpam_msc_driver_init() from subsys_initcall() */
+arch_initcall(arm64_mpam_register_cpus)
-- 
2.43.0

