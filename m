Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C89377548
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155100; cv=none; b=OlhTRf5bwZlzmNE4UgTQbkKO/b8+1gQied2rQjuiHVmomuwdlPzm9cvWwETX2ZwjNwp+s0vEjTm+H601U5SEwhPCaNbh0G/axMvlC9/hGrBn4q6WTiGjl/NAD9iVjG3qyVysf4csTYyG3KnUQ7Tl6nY9g6SjpIIENoFbDV2R2l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155100; c=relaxed/simple;
	bh=hs1jUmDeR2GINsCfZrORHJhqm5TNJrRB4Ho79kBKgpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAUe/TrgmwEP/9/jAeHPZ8gJW6ya5mPRb+9yx++mjPy8ja7v9a97AsLi3YCnuU2NLWf+Fk+aZAYW8vtJ6FTddj/5DlaEH6sjgkpEg2WkYvNwGv0z/gwJyT/NXZGZ6X2J5TWbPCbJ3BQ72pMUoErMCnpcJL0CHdpzarrDNdsBE6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F0D98497;
	Tue,  3 Feb 2026 13:44:51 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A31B73F778;
	Tue,  3 Feb 2026 13:44:52 -0800 (PST)
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
Subject: [PATCH v4 10/41] arm64: mpam: Add helpers to change a task or cpu's MPAM PARTID/PMG values
Date: Tue,  3 Feb 2026 21:43:11 +0000
Message-ID: <20260203214342.584712-11-ben.horgan@arm.com>
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
CC: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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

