Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238132874E6
	for <kvmarm@lists.linux.dev>; Tue, 24 Feb 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771956014; cv=none; b=KDrTBi6t0BSk2ZVPZbBUvZwM/d8z88q5bsGTwUoo1cDY6pgBkkc7xKOCkpO41fTIVteWBNHQPxF6hrGJzlrVISMSs/J1GhmuwPnZqtwO17GXEPiVefJizduAzkXFfiSu0QdCAAekPztMALgNqfb7z9q+GK/UiwGT9E5l/hiYIQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771956014; c=relaxed/simple;
	bh=/1lpOHkO60J7UZEpsWYrit5WdtfXpvtKwBJQhmELMjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abNoBpcrw4i/VrC4sENlqnKbnSbEb5xrZkmt6JwUcs5Y7+5B4XeauZfT4sfnKwHG65u7czRDAlRfQpN7G8xah4DIXTcK2SveZE6Lg0+Sil4CFZjGAFUfkd9+IeE94uO+9d7I8rtngFOrxFXmXZmXq5OOTNsrfy7IEnXMLHwsmqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 494EA1595;
	Tue, 24 Feb 2026 10:00:06 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DB5CF3F59E;
	Tue, 24 Feb 2026 10:00:06 -0800 (PST)
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
Subject: [PATCH v5 29/41] arm_mpam: resctrl: Pre-allocate free running monitors
Date: Tue, 24 Feb 2026 17:57:08 +0000
Message-ID: <20260224175720.2663924-30-ben.horgan@arm.com>
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

When there are enough monitors, the resctrl mbm local and total files can
be exposed. These need all the monitors that resctrl may use to be
allocated up front.

Add helpers to do this.

If a different candidate class is discovered, the old array should be
free'd and the allocated monitors returned to the driver.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Code flow tidying (Jonathan)
---
 drivers/resctrl/mpam_internal.h |  3 +-
 drivers/resctrl/mpam_resctrl.c  | 81 ++++++++++++++++++++++++++++++++-
 2 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index d58428ba2005..f278fa7307af 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -361,7 +361,8 @@ struct mpam_resctrl_res {
 struct mpam_resctrl_mon {
 	struct mpam_class	*class;
 
-	/* per-class data that resctrl needs will live here */
+	/* Array of allocated MBWU monitors, indexed by (closid, rmid). */
+	int			*mbwu_idx_to_mon;
 };
 
 static inline int mpam_alloc_csu_mon(struct mpam_class *class)
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index ddcf73567723..c07f0304fae6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -654,10 +654,58 @@ static void mpam_resctrl_pick_mba(void)
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
@@ -672,7 +720,36 @@ static void counter_update_class(enum resctrl_event_id evt_id,
 		}
 	}
 
-	mpam_resctrl_counters[evt_id].class = class;
+	pr_debug("Updating event %u to use class %u\n", evt_id, class->level);
+
+	/* Might not need all the monitors */
+	num_mbwu_mon = __mpam_monitors_free_running(num_mbwu_mon);
+
+	if (evt_id != QOS_L3_OCCUP_EVENT_ID && num_mbwu_mon) {
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
+	mon->class = class;
 }
 
 static void mpam_resctrl_pick_counters(void)
-- 
2.43.0

