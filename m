Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046243590A3
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168091; cv=none; b=E7vcxrwjzry3x1kau0PWOyaFzKTTBFJAyTfl4zu7nAOH/K4lFAP2HTeokmidGRH6S/My21ZoRmTcL6eW80f4opCCP1jjhD1b6oBMC2a7ro9dl6ZWn/FMDsMyveVKP0kSvZMNsj3P9SES2kt8u32cDmZB6cBWxu1qM1Xdf2+jtHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168091; c=relaxed/simple;
	bh=0RVsNG1IdvDiX2XG57WUm//SVaio5ZakHup31zHaYjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSzGImq9fTdMeHdbztmMq/M74vmP1UKpKtVOLd7pNaM84J+exwxilI2fYW8NyVeV1SEWfsNXDxSgXIeZiq12pMkerzWEKhfuXMEgc7s0hBWR8KeglFiYJSD1lqY3JfDD+DtfaufMVmHe4WMd9luCZwv2HQb7S+1lKqC1gr/vqU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83FA91688;
	Fri, 19 Dec 2025 10:14:42 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3A5133F5CA;
	Fri, 19 Dec 2025 10:14:45 -0800 (PST)
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
Subject: [PATCH v2 35/45] arm_mpam: resctrl: Add resctrl_arch_cntr_read() & resctrl_arch_reset_cntr()
Date: Fri, 19 Dec 2025 18:11:37 +0000
Message-ID: <20251219181147.3404071-36-ben.horgan@arm.com>
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

When used in ABMC mode, resctrl uses a different set of helpers to read and
reset the counters.

Add these.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_resctrl.c | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 8a1263986145..ef60bc0c7bd8 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -458,6 +458,28 @@ int resctrl_arch_rmid_read(struct rdt_resource	*r, struct rdt_mon_domain *d,
 				 closid, rmid, val);
 }
 
+/* MBWU counters when in ABMC mode */
+int resctrl_arch_cntr_read(struct rdt_resource *r, struct rdt_mon_domain *d,
+			   u32 closid, u32 rmid, int mon_idx,
+			   enum resctrl_event_id eventid, u64 *val)
+{
+	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
+	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_component *mon_comp;
+
+	if (!mpam_is_enabled())
+		return -EINVAL;
+
+	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
+		return -EINVAL;
+
+	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+	mon_comp = l3_dom->mon_comp[eventid];
+
+	return read_mon_cdp_safe(mon, mon_comp, mpam_feat_msmon_mbwu, mon_idx,
+				 closid, rmid, val);
+}
+
 static void __reset_mon(struct mpam_resctrl_mon *mon, struct mpam_component *mon_comp,
 			int mon_idx,
 			enum resctrl_conf_type cdp_type, u32 closid, u32 rmid)
@@ -513,6 +535,27 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
 }
 
+/* Reset an assigned counter */
+void resctrl_arch_reset_cntr(struct rdt_resource *r, struct rdt_mon_domain *d,
+			     u32 closid, u32 rmid, int cntr_id,
+			     enum resctrl_event_id eventid)
+{
+	struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
+	struct mpam_resctrl_dom *l3_dom;
+	struct mpam_component *mon_comp;
+
+	if (!mpam_is_enabled())
+		return;
+
+	if (eventid == QOS_L3_OCCUP_EVENT_ID || !mon->class)
+		return;
+
+	l3_dom = container_of(d, struct mpam_resctrl_dom, resctrl_mon_dom);
+	mon_comp = l3_dom->mon_comp[eventid];
+
+	reset_mon_cdp_safe(mon, mon_comp, USE_PRE_ALLOCATED, closid, rmid);
+}
+
 static bool cache_has_usable_cpor(struct mpam_class *class)
 {
 	struct mpam_props *cprops = &class->props;
-- 
2.43.0

