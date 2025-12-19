Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B063563C2
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168070; cv=none; b=l6N5T+O0gfpcHYGok64xr4vUowv2jTKkc9IRk4n692kzkbkOL88v5ux56J4N+Sd2me/fbNUMNaIDS0VzD/EFaelnHaQFwwF04ndKK/Ib6KD0w7uCRIwG2UwoafooI/rEcKfy38StoPi8Lvi1DQzwla2zLVWuUotI7rNWtXtj6jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168070; c=relaxed/simple;
	bh=eXNOes5bxOVhlbspr8qoOGHw59QgFXTwE67dLuK4svk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isvEeP9Dv8/bdGVrmNMpfq5IirXyDjXr+KN5oKFn+JDsy9At7hjWs4VjOibMBIc1DlZlPccL6pAb851wPUyownw2VMOnpnqwZj8Lte0aIKqqVGQjdKpbfk71cckalAlOAeHyAr+aienoGoMp6JJ0xvSVPRfS8Cutsk8Ao5rn0ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46E84FEC;
	Fri, 19 Dec 2025 10:14:14 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E956F3F5CA;
	Fri, 19 Dec 2025 10:14:16 -0800 (PST)
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
Subject: [PATCH v2 29/45] arm_mpam: resctrl: Pre-allocate free running monitors
Date: Fri, 19 Dec 2025 18:11:31 +0000
Message-ID: <20251219181147.3404071-30-ben.horgan@arm.com>
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

When there are enough monitors, the resctrl mbm local and total files can
be exposed. These need all the monitors that resctrl may use to be
allocated up front.

Add helpers to do this.

If a different candidate class is discovered, the old array should be
free'd and the allocated monitors returned to the driver.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_internal.h |  8 +++-
 drivers/resctrl/mpam_resctrl.c  | 84 ++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 6a2231b28cad..c25524f75c2e 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -356,7 +356,13 @@ struct mpam_resctrl_res {
 struct mpam_resctrl_mon {
 	struct mpam_class	*class;
 
-	/* per-class data that resctrl needs will live here */
+	/*
+	 * Array of allocated MBWU monitors, indexed by (closid, rmid).
+	 * When ABMC is not in use, this array directly maps (closid, rmid)
+	 * to the allocated monitor. Otherwise this array is sparse, and
+	 * un-assigned (closid, rmid) are -1.
+	 */
+	int			*mbwu_idx_to_mon;
 };
 
 static inline int mpam_alloc_csu_mon(struct mpam_class *class)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 51caf3b82392..bea16bc096f7 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -558,10 +558,58 @@ static void mpam_resctrl_pick_mba(void)
 	}
 }
 
+static void __free_mbwu_mon(struct mpam_class *class, int *array,
+			    u16 num_mbwu_mon)
+{
+	for (int i = 0; i < num_mbwu_mon; i++) {
+		if (array[i] < 0)
+			continue;
+
+		mpam_free_mbwu_mon(class, array[i]);
+		array[i] = ~0;
+	}
+}
+
+static int __alloc_mbwu_mon(struct mpam_class *class, int *array,
+			    u16 num_mbwu_mon)
+{
+	for (int i = 0; i < num_mbwu_mon; i++) {
+		int mbwu_mon = mpam_alloc_mbwu_mon(class);
+
+		if (mbwu_mon < 0) {
+			__free_mbwu_mon(class, array, num_mbwu_mon);
+			return mbwu_mon;
+		}
+		array[i] = mbwu_mon;
+	}
+
+	return 0;
+}
+
+static int *__alloc_mbwu_array(struct mpam_class *class, u16 num_mbwu_mon)
+{
+	int err;
+	size_t array_size = num_mbwu_mon * sizeof(int);
+	int *array __free(kfree) = kmalloc(array_size, GFP_KERNEL);
+
+	if (!array)
+		return ERR_PTR(-ENOMEM);
+
+	memset(array, -1, array_size);
+
+	err = __alloc_mbwu_mon(class, array, num_mbwu_mon);
+	if (err)
+		return ERR_PTR(err);
+	return_ptr(array);
+}
+
 static void counter_update_class(enum resctrl_event_id evt_id,
 				 struct mpam_class *class)
 {
-	struct mpam_class *existing_class = mpam_resctrl_counters[evt_id].class;
+	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[evt_id];
+	struct mpam_class *existing_class = mon->class;
+	u16 num_mbwu_mon = class->props.num_mbwu_mon;
+	int *existing_array = mon->mbwu_idx_to_mon;
 
 	if (existing_class) {
 		if (class->level == 3) {
@@ -576,8 +624,40 @@ static void counter_update_class(enum resctrl_event_id evt_id,
 		}
 	}
 
-	mpam_resctrl_counters[evt_id].class = class;
+	pr_debug("Updating event %u to use class %u\n", evt_id, class->level);
+	mon->class = class;
 	exposed_mon_capable = true;
+
+	if (evt_id == QOS_L3_OCCUP_EVENT_ID)
+		return;
+
+	/* Might not need all the monitors */
+	num_mbwu_mon = __mpam_monitors_free_running(num_mbwu_mon);
+	if (!num_mbwu_mon) {
+		pr_debug("Not pre-allocating free-running counters\n");
+		return;
+	}
+
+	/*
+	 * This is the pre-allocated free-running monitors path. It always
+	 * allocates one monitor per PARTID * PMG.
+	 */
+	WARN_ON_ONCE(num_mbwu_mon != resctrl_arch_system_num_rmid_idx());
+
+	mon->mbwu_idx_to_mon = __alloc_mbwu_array(class, num_mbwu_mon);
+	if (IS_ERR(mon->mbwu_idx_to_mon)) {
+		pr_debug("Failed to allocate MBWU array\n");
+		mon->class = existing_class;
+		mon->mbwu_idx_to_mon = existing_array;
+		return;
+	}
+
+	if (existing_array) {
+		pr_debug("Releasing previous class %u's monitors\n",
+			 existing_class->level);
+		__free_mbwu_mon(existing_class, existing_array, num_mbwu_mon);
+		kfree(existing_array);
+	}
 }
 
 static void mpam_resctrl_pick_counters(void)
-- 
2.43.0

