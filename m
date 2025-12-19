Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6864D320CD6
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168025; cv=none; b=hGylTiJZaQamThht4grAQkhxOAUTA36rE5DzV5E53ih7kpj1F6f9CdskuwWcMxdPe2tAQXPMPTHiQkiVM+b2lIpozA0t73h/RVxUTanWRP+lts4AErvp7LJMrtUKZ8yunjJIoKswWMNTBJxcuNLA72oIV0thgPv5w/PsR/DUNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168025; c=relaxed/simple;
	bh=5qgiac4d5iP9l6HhKhN2bcEqBUzkBpqBJEJSMssA6Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb8gH+mCSU2lG30vhasHpGydaFzaQYHwdP/6fHVgs5ge5pMRNAoLUoek+X9wzcrgT4TnYqjLffBVa3Dxw4AYRO1nzfdfqDqWA5QPzohcBLdFh1JULHjQhWJis/n/NseJfHh3zHl6wDoEVHOEablsjjSOGN8pqgyiogrZkBHOQH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D85F3106F;
	Fri, 19 Dec 2025 10:13:35 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 35D6D3F5CA;
	Fri, 19 Dec 2025 10:13:38 -0800 (PST)
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
Subject: [PATCH v2 21/45] arm_mpam: resctrl: Add plumbing against arm64 task and cpu hooks
Date: Fri, 19 Dec 2025 18:11:23 +0000
Message-ID: <20251219181147.3404071-22-ben.horgan@arm.com>
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

arm64 provides helpers for changing a tasks and a cpus mpam partid/pmg
values.

These are used to back a number of resctrl_arch_ functions. Connect them
up.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_resctrl.c | 58 ++++++++++++++++++++++++++++++++++
 include/linux/arm_mpam.h       |  5 +++
 2 files changed, 63 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index e5ec5438eca8..2f72ca66fb8c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
 #include <linux/errno.h>
+#include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/printk.h>
 #include <linux/rculist.h>
@@ -32,6 +33,8 @@ static DEFINE_MUTEX(domain_list_lock);
 static bool exposed_alloc_capable;
 static bool exposed_mon_capable;
 
+static bool cdp_enabled;
+
 bool resctrl_arch_alloc_capable(void)
 {
 	return exposed_alloc_capable;
@@ -52,6 +55,61 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
 	return mpam_partid_max + 1;
 }
 
+void resctrl_arch_sched_in(struct task_struct *tsk)
+{
+	lockdep_assert_preemption_disabled();
+
+	mpam_thread_switch(tsk);
+}
+
+void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid)
+{
+	WARN_ON_ONCE(closid > U16_MAX);
+	WARN_ON_ONCE(rmid > U8_MAX);
+
+	if (!cdp_enabled) {
+		mpam_set_cpu_defaults(cpu, closid, closid, rmid, rmid);
+	} else {
+		/*
+		 * When CDP is enabled, resctrl halves the closid range and we
+		 * use odd/even partid for one closid.
+		 */
+		u32 partid_d = resctrl_get_config_index(closid, CDP_DATA);
+		u32 partid_i = resctrl_get_config_index(closid, CDP_CODE);
+
+		mpam_set_cpu_defaults(cpu, partid_d, partid_i, rmid, rmid);
+	}
+}
+
+void resctrl_arch_sync_cpu_closid_rmid(void *info)
+{
+	struct resctrl_cpu_defaults *r = info;
+
+	lockdep_assert_preemption_disabled();
+
+	if (r) {
+		resctrl_arch_set_cpu_default_closid_rmid(smp_processor_id(),
+							 r->closid, r->rmid);
+	}
+
+	resctrl_arch_sched_in(current);
+}
+
+void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
+{
+	WARN_ON_ONCE(closid > U16_MAX);
+	WARN_ON_ONCE(rmid > U8_MAX);
+
+	if (!cdp_enabled) {
+		mpam_set_task_partid_pmg(tsk, closid, closid, rmid, rmid);
+	} else {
+		u32 partid_d = resctrl_get_config_index(closid, CDP_DATA);
+		u32 partid_i = resctrl_get_config_index(closid, CDP_CODE);
+
+		mpam_set_task_partid_pmg(tsk, partid_d, partid_i, rmid, rmid);
+	}
+}
+
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
 	if (l >= RDT_NUM_RESOURCES)
diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
index 2c7d1413a401..5a78299ec464 100644
--- a/include/linux/arm_mpam.h
+++ b/include/linux/arm_mpam.h
@@ -52,6 +52,11 @@ static inline int mpam_ris_create(struct mpam_msc *msc, u8 ris_idx,
 bool resctrl_arch_alloc_capable(void);
 bool resctrl_arch_mon_capable(void);
 
+void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
+void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
+void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
+void resctrl_arch_sched_in(struct task_struct *tsk);
+
 /**
  * mpam_register_requestor() - Register a requestor with the MPAM driver
  * @partid_max:		The maximum PARTID value the requestor can generate.
-- 
2.43.0

