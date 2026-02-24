Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0683AA1B5
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955897; cv=none; b=MwWu0TKPSFMGzYh3TPDlOkc9G1TeLof6uPRpJrk1PribZGMssomxdlm485PqHTFB/mATheBhBrqaA3F45m7RnzQPrU1LlSNLt3j36cY9iwnhxttAFBq9+zIMfYkX8ssr+aZ6nqUW2Ax9qnWpdJGF7L2fa0mn0E2DbmmIFDdgFQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955897; c=relaxed/simple;
	bh=jFdXe9TNxDV65CtBI3g4s77B3u+dB6FF4nhlglPNKi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3xhhwA/ur2ifSrGO4IXXxYQ9wFv6AV+vNc6xLlr0JVws7jr6TOopwVokYNxwaIS96F1MRSuarXS0Qzzq4YikOm5mtopKesTnkwNWVrrNryFrl6md5sJv03F4DktNEG5eINbwFtgfMHBbgUxcDPX1MbMYY5d0pX7BzQKdDxwYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB181497;
	Tue, 24 Feb 2026 09:58:08 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 458D43F59E;
	Tue, 24 Feb 2026 09:58:10 -0800 (PST)
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
Subject: [PATCH v5 08/41] arm64: mpam: Add cpu_pm notifier to restore MPAM sysregs
Date: Tue, 24 Feb 2026 17:56:47 +0000
Message-ID: <20260224175720.2663924-9-ben.horgan@arm.com>
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

The MPAM system registers will be lost if the CPU is reset during PSCI's
CPU_SUSPEND.

Add a PM notifier to restore them.

mpam_thread_switch(current) can't be used as this won't make any changes if
the in-memory copy says the register already has the correct value. In
reality the system register is UNKNOWN out of reset.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v3:
Always set MPAM1_EL1.MPAMEN rather than relying on it being read only
Bail out early if mpam not supported (Gavin)
---
 arch/arm64/kernel/mpam.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
index e6feff2324ac..48ec0ffd5999 100644
--- a/arch/arm64/kernel/mpam.c
+++ b/arch/arm64/kernel/mpam.c
@@ -4,6 +4,7 @@
 #include <asm/mpam.h>
 
 #include <linux/arm_mpam.h>
+#include <linux/cpu_pm.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 
@@ -13,12 +14,44 @@ DEFINE_PER_CPU(u64, arm64_mpam_current);
 
 u64 arm64_mpam_global_default;
 
+static int mpam_pm_notifier(struct notifier_block *self,
+			    unsigned long cmd, void *v)
+{
+	u64 regval;
+	int cpu = smp_processor_id();
+
+	switch (cmd) {
+	case CPU_PM_EXIT:
+		/*
+		 * Don't use mpam_thread_switch() as the system register
+		 * value has changed under our feet.
+		 */
+		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
+		write_sysreg_s(regval | MPAM1_EL1_MPAMEN, SYS_MPAM1_EL1);
+		isb();
+
+		write_sysreg_s(regval, SYS_MPAM0_EL1);
+
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static struct notifier_block mpam_pm_nb = {
+	.notifier_call = mpam_pm_notifier,
+};
+
 static int __init arm64_mpam_register_cpus(void)
 {
 	u64 mpamidr = read_sanitised_ftr_reg(SYS_MPAMIDR_EL1);
 	u16 partid_max = FIELD_GET(MPAMIDR_EL1_PARTID_MAX, mpamidr);
 	u8 pmg_max = FIELD_GET(MPAMIDR_EL1_PMG_MAX, mpamidr);
 
+	if (!system_supports_mpam())
+		return 0;
+
+	cpu_pm_register_notifier(&mpam_pm_nb);
 	return mpam_register_requestor(partid_max, pmg_max);
 }
 /* Must occur before mpam_msc_driver_init() from subsys_initcall() */
-- 
2.43.0

