Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DDF03B531D
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771955971; cv=none; b=G7mul4WuuTUMick4cHXaHFC9qrMdOl0RQ4WPETvCHaKufLe+PlrUXcZuWDzc3yVOYHbPTAs1ifXMThVTPbbJwIvDDledBT9w7ukmJecwZTTodFoTRPUHeDG7uQkdgKRxArLyw0SJ1/wP+gKmJP95KOKowdHseGLCC8Id4Vd7kGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771955971; c=relaxed/simple;
	bh=R2xBk9dp3RAsHolZotQZ/loxsDB/JsrZLyypX3amti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOjJwxRrwfzbLBXtTarKelIX/oz9ZKRRZQEF+jE8vEYPTuq1P7N9abs8c2VqVdc9wM9LFu7iP7bTowVRNNC04GVQilkETjt0Y1QQJGCnNEBSYH4cuUviWq21htSrWDwWTVcz47vSa1Y5EUOF7VFbybzrUFltz1sxf+8eTJMQUBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94BFC339;
	Tue, 24 Feb 2026 09:59:22 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 01ABA3F59E;
	Tue, 24 Feb 2026 09:59:23 -0800 (PST)
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
Subject: [PATCH v5 22/41] arm_mpam: resctrl: Add rmid index helpers
Date: Tue, 24 Feb 2026 17:57:01 +0000
Message-ID: <20260224175720.2663924-23-ben.horgan@arm.com>
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

Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
data structures by index. This allows x86 to map indexes to RMID, and MPAM
to map them to partid-and-pmg.

Add the helpers to do this.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Suggested-by: James Morse <james.morse@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Use ~0U instead of ~0 in lhs of left shift

Changes since v2:
Drop changes signed-off-by as reworked patch
Use multiply and add rather than shift to avoid holes
---
 drivers/resctrl/mpam_resctrl.c | 16 ++++++++++++++++
 include/linux/arm_mpam.h       |  3 +++
 2 files changed, 19 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index ded18a9d4cd4..48f96d7f9109 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -130,6 +130,22 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+u32 resctrl_arch_system_num_rmid_idx(void)
+{
+	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
+}
+
+u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
+{
+	return closid * (mpam_pmg_max + 1) + rmid;
+}
+
+void resctrl_arch_rmid_idx_decode(u32 idx, u32 *closid, u32 *rmid)
+{
+	*closid = idx / (mpam_pmg_max + 1);
+	*rmid = idx % (mpam_pmg_max + 1);
+}
+
 void resctrl_arch_sched_in(struct task_struct *tsk)
 {
 	lockdep_assert_preemption_disabled();
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index d329b1dc148b..7d23c90f077d 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -58,6 +58,9 @@ void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
 void resctrl_arch_sched_in(struct task_struct *tsk);
 bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
 bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
+u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid);
+void resctrl_arch_rmid_idx_decode(u32 idx, u32 *closid, u32 *rmid);
+u32 resctrl_arch_system_num_rmid_idx(void);
 
 /**
  * mpam_register_requestor() - Register a requestor with the MPAM driver
-- 
2.43.0

