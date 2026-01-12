Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C8737A495
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237360; cv=none; b=VTWrdgA9kVgUouHL+V1dI4NzqJsPKq9WZXsLlCTaZSEtuVSMXnUESzZVPcVYRnqtVeDvRgEvbgWwayFS7kNGlccZ8mYXuTPct8WVFGBezAsaI8KfiSNimES1LbAhh0F3REdSZEN/nJb+CtAAL8F+zdOJCIHmLdYL1q8tkuAe3KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237360; c=relaxed/simple;
	bh=YF1N8QNBah5q0VUisLh+Qxtur/z56w0tnPVF76iL3so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdtBiONM6l7AgGGbUB51qI8ezSOKAz91KJLprrtx8MriiQFrR98ak0fpGGYtXsxnbw6v6EF29ssba7SHKuomtlm9gy8WEXwSmyW36sKii+CJxl1Ot+/YPVf+MqeJROJa5EHUNOKxHEz5BD87VaB4TODKNvBQ694VEOLMnUzbt7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0811596;
	Mon, 12 Jan 2026 09:02:28 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E8AF03F694;
	Mon, 12 Jan 2026 09:02:29 -0800 (PST)
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
Subject: [PATCH v3 30/47] arm_mpam: resctrl: Pre-allocate free running monitors
Date: Mon, 12 Jan 2026 16:58:57 +0000
Message-ID: <20260112165914.4086692-31-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
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
Changes since v2:
Code flow tidying (Jonathan)
---
 drivers/resctrl/mpam_internal.h |  8 +++-
 drivers/resctrl/mpam_resctrl.c  | 81 ++++++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 1c5492008fe8..89f9d374ded0 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -360,7 +360,13 @@ struct mpam_resctrl_res {
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
index 14a8dcaf1366..3af12ad77fba 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -572,10 +572,58 @@ static void mpam_resctrl_pick_mba(void)
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
+	int *new_array, *existing_array = mon->mbwu_idx_to_mon;
 
 	if (existing_class) {
 		if (class->level == 3) {
@@ -590,8 +638,37 @@ static void counter_update_class(enum resctrl_event_id evt_id,
 		}
 	}
 
-	mpam_resctrl_counters[evt_id].class = class;
+	pr_debug("Updating event %u to use class %u\n", evt_id, class->level);
+
+	/* Might not need all the monitors */
+	num_mbwu_mon = __mpam_monitors_free_running(num_mbwu_mon);
+
+	if ((evt_id != QOS_L3_OCCUP_EVENT_ID) && num_mbwu_mon) {
+		/*
+		 * This is the pre-allocated free-running monitors path. It always
+		 * allocates one monitor per PARTID * PMG.
+		 */
+		WARN_ON_ONCE(num_mbwu_mon != resctrl_arch_system_num_rmid_idx());
+
+		new_array = __alloc_mbwu_array(class, num_mbwu_mon);
+		if (IS_ERR(new_array)) {
+			pr_debug("Failed to allocate MBWU array\n");
+			return;
+		}
+		mon->mbwu_idx_to_mon = new_array;
+
+		if (existing_array) {
+			pr_debug("Releasing previous class %u's monitors\n",
+				 existing_class->level);
+			__free_mbwu_mon(existing_class, existing_array, num_mbwu_mon);
+			kfree(existing_array);
+		}
+	} else if (evt_id != QOS_L3_OCCUP_EVENT_ID) {
+		pr_debug("Not pre-allocating free-running counters\n");
+	}
+
 	exposed_mon_capable = true;
+	mon->class = class;
 }
 
 static void mpam_resctrl_pick_counters(void)
-- 
2.43.0

