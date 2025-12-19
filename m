Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62776341AD0
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168036; cv=none; b=IlmkjPUhBBNp3c1W2Atb1Zbnb7DZ2LFC9H8IksEwbRv5sR2LfGVCO83WzhLDMH1YsOpCQJypOPH4aihgPBCk5y86PoPLppzeK3UByGavbMPjZpvwb1ki0fRrjC05OMucr7XR9dfbhjmVB2O8t11R5eYoypDPgCflcIc7AbN6PTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168036; c=relaxed/simple;
	bh=Wz8CY6LWhiynM5nYw7Gcs1mVlND/Xtp5akkzbnTEd7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfFDUKGgM+JglNQDeRzOGLukUhIZ1P+es9pYMnaZ86hAZuWp+EuQ8hv2JRV3ts6mPA8oR76OqaTK7xOjDJhdvV+tGB+6xThDMcUSyixDWe1z3d8VUjZKy9CGJXaU645UwzevDcCmxhDAk7cilVYHKHXlsIO74ytG4tEpyMK6ob4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FE29106F;
	Fri, 19 Dec 2025 10:13:45 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E9123F5CA;
	Fri, 19 Dec 2025 10:13:47 -0800 (PST)
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
	kvmarm@lists.linux.dev
Subject: [PATCH v2 23/45] arm_mpam: resctrl: Add rmid index helpers
Date: Fri, 19 Dec 2025 18:11:25 +0000
Message-ID: <20251219181147.3404071-24-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219181147.3404071-1-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
data structures by index. This allows x86 to map indexes to RMID, and MPAM
to map them to partid-and-pmg.

Add the helpers to do this.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
Use ~0U instead of ~0 in lhs of left shift
---
 drivers/resctrl/mpam_resctrl.c | 28 ++++++++++++++++++++++++++++
 include/linux/arm_mpam.h       |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 4275b1a85887..bdbc5504964b 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -120,6 +120,34 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+u32 resctrl_arch_system_num_rmid_idx(void)
+{
+	u8 closid_shift = fls(mpam_pmg_max);
+	u32 num_partid = resctrl_arch_get_num_closid(NULL);
+
+	return num_partid << closid_shift;
+}
+
+u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
+{
+	u8 closid_shift = fls(mpam_pmg_max);
+
+	WARN_ON_ONCE(closid_shift > 8);
+
+	return (closid << closid_shift) | rmid;
+}
+
+void resctrl_arch_rmid_idx_decode(u32 idx, u32 *closid, u32 *rmid)
+{
+	u8 closid_shift = fls(mpam_pmg_max);
+	u32 pmg_mask = ~(~0U << closid_shift);
+
+	WARN_ON_ONCE(closid_shift > 8);
+
+	*closid = idx >> closid_shift;
+	*rmid = idx & pmg_mask;
+}
+
 void resctrl_arch_sched_in(struct task_struct *tsk)
 {
 	lockdep_assert_preemption_disabled();
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index ba0312b55d9f..385554ceb452 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -59,6 +59,9 @@ void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
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

