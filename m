Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E02D34AAF9
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413231; cv=none; b=Dg7mBeyGBW9dyP+e6HmPz4exH2Y/h6OE7qGuKgQg1awRXHSXdtR5A0cQn6hNn6FZV41vfkBg797j+BHp3YCWUFS0RVg3uiXMmQiG9/HM0UCigDGZiVqhgwP019jR+FgMldBRIbOo+zR0i02hrDsHGc2PIVf16UT7axaJAMh3AEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413231; c=relaxed/simple;
	bh=b7cfoAfMyZkkrwp7W2dcYMqW5fMaNrAEN8FQQTZTtZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScLPaVTw9jA3wezj2RyE4nExx6rdiVD7/KU1BuFxd4Isi+qkjltIxZJLnTnWswl/goXzRgU2JwA/1peY4WLbNv5D9MQHVhVnUtZwzMC0amAKQ7y2NiUWb27/W+UylmGUqLeL4G8BHxX9SE60Av768XwVMGNFOTyYw4f0T+yrNmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD59F244B;
	Fri, 13 Mar 2026 07:47:03 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A94D3F7BD;
	Fri, 13 Mar 2026 07:47:05 -0700 (PDT)
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
Subject: [PATCH v6 09/40] arm64: mpam: Advertise the CPUs MPAM limits to the driver
Date: Fri, 13 Mar 2026 14:45:46 +0000
Message-ID: <20260313144617.3420416-10-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260313144617.3420416-1-ben.horgan@arm.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
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
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
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

