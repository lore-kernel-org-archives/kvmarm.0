Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB1F3A875F
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413244; cv=none; b=f2o1ASR3Q+Yy3LffKB40i/GWqmB5QrjtMGamMoQ2o6O8PCiCfbMaxYmmRHU0tVDCXzRThWQfxwSLsOTv9ll5QhlFyU6KH+bp4JBRw3W418V79fugyFZShS1l8b/wSd7BB1odvt59Z5C97WfaumATCcuHnf+JBRIUjm3yYPCe7aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413244; c=relaxed/simple;
	bh=M2zEaXmf7MAEoSwHu0M+QohjDnM51bK+2sk19iwWi8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsFEoPy/pS/bK/c4UzTM6461WZafVw686zDzbbewuq8hI8DpotpFwHN2U3yONO9aThY5Rgf36aY4Ek/bdYx9ESvV+900J0r9RdppHpFdFDYXhHHXb9CTq6Zot7LVT59qc+DkE/W4prZYLL+sJkcCYsyW/wB/my7zcOp/ixrFsms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88F531CC4;
	Fri, 13 Mar 2026 07:47:16 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9FED73F7BD;
	Fri, 13 Mar 2026 07:47:18 -0700 (PDT)
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
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 12/40] arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG values
Date: Fri, 13 Mar 2026 14:45:49 +0000
Message-ID: <20260313144617.3420416-13-ben.horgan@arm.com>
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

Care must be taken when modifying the PARTID and PMG of a task in any
per-task structure as writing these values may race with the task being
scheduled in, and reading the modified values.

Add helpers to set the task properties, and the CPU default value.  These
use WRITE_ONCE() that pairs with the READ_ONCE() in mpam_get_regval() to
avoid causing torn values.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Keep comment attached to mpam_get_regval()
Add internal helper, __mpam_regval() (Jonathan)

Changes since v3:
Remove extra CONFIG_ARM64_MPAM guarding
Extend CONFIG_ARM64_MPAM guarding
---
 arch/arm64/include/asm/mpam.h | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
index 6bccbfdccb87..05aa71200f61 100644
--- a/arch/arm64/include/asm/mpam.h
+++ b/arch/arm64/include/asm/mpam.h
@@ -4,6 +4,7 @@
 #ifndef __ASM__MPAM_H
 #define __ASM__MPAM_H
 
+#include <linux/bitfield.h>
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
@@ -22,6 +23,23 @@ DECLARE_PER_CPU(u64, arm64_mpam_current);
  */
 extern u64 arm64_mpam_global_default;
 
+#ifdef CONFIG_ARM64_MPAM
+static inline u64 __mpam_regval(u16 partid_d, u16 partid_i, u8 pmg_d, u8 pmg_i)
+{
+	return FIELD_PREP(MPAM0_EL1_PARTID_D, partid_d) |
+	       FIELD_PREP(MPAM0_EL1_PARTID_I, partid_i) |
+	       FIELD_PREP(MPAM0_EL1_PMG_D, pmg_d) |
+	       FIELD_PREP(MPAM0_EL1_PMG_I, pmg_i);
+}
+
+static inline void mpam_set_cpu_defaults(int cpu, u16 partid_d, u16 partid_i,
+					 u8 pmg_d, u8 pmg_i)
+{
+	u64 default_val = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
+
+	WRITE_ONCE(per_cpu(arm64_mpam_default, cpu), default_val);
+}
+
 /*
  * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
  * which may race with reads in mpam_thread_switch(). Ensure only one of the old
@@ -30,12 +48,20 @@ extern u64 arm64_mpam_global_default;
  * value to be stored with cache allocations, despite being considered 'free' by
  * resctrl.
  */
-#ifdef CONFIG_ARM64_MPAM
 static inline u64 mpam_get_regval(struct task_struct *tsk)
 {
 	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
 }
 
+static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
+					    u16 partid_d, u16 partid_i,
+					    u8 pmg_d, u8 pmg_i)
+{
+	u64 regval = __mpam_regval(partid_d, partid_i, pmg_d, pmg_i);
+
+	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
+}
+
 static inline void mpam_thread_switch(struct task_struct *tsk)
 {
 	u64 oldregval;
-- 
2.43.0

