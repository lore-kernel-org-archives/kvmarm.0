Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B4F378D8C
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237288; cv=none; b=lb2zt6KdSbp+S9WPdVI0LnQbNF+OC84iyKWm0XT2xK+w13DH57yP1rvFPNbH0TfToEpigiTKz9CQJi+oHtHA/X3/dlt1hLKdWrdww3k6XQiatJn2AEfxoxkTkXcfeNcDyJM+gicAaXNgE6TniPeWDLZYci+iSdecI9gi4C4xe0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237288; c=relaxed/simple;
	bh=Py/sYxDkA/fJ5baQpdFJ3JUYaM8/emboOVHIUPXdi4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE9/7b8KciLxXXKXLGgh6K/zN05ySrDKf5GDl6IToA3lZAJAMO25S6LeUDFeJA16INPxUuLx8iOrLxdxCHQCMoJsq0JzFpGC2D3v9Nkw5nIoTOzR7vTv9ovvPfx9QRArj2q8sR2uFDzCj6osmCTc9mMc2Hys61gHWp4yNJNCHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA1D51516;
	Mon, 12 Jan 2026 09:01:16 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5E6A33F694;
	Mon, 12 Jan 2026 09:01:18 -0800 (PST)
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
Subject: [PATCH v3 17/47] arm_mpam: resctrl: Implement resctrl_arch_reset_all_ctrls()
Date: Mon, 12 Jan 2026 16:58:44 +0000
Message-ID: <20260112165914.4086692-18-ben.horgan@arm.com>
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

We already have a helper for resetting an mpam class and component.  Hook
it up to resctrl_arch_reset_all_ctrls() and the domain offline path.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Don't expose unlocked reset
---
 drivers/resctrl/mpam_devices.c  |  4 ++--
 drivers/resctrl/mpam_internal.h |  6 ++++++
 drivers/resctrl/mpam_resctrl.c  | 15 +++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index b81d5c7f44ca..0dd7f613f7a3 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2544,7 +2544,7 @@ static void mpam_enable_once(void)
 	       mpam_partid_max + 1, mpam_pmg_max + 1);
 }
 
-static void mpam_reset_component_locked(struct mpam_component *comp)
+void mpam_reset_component_locked(struct mpam_component *comp)
 {
 	struct mpam_vmsc *vmsc;
 
@@ -2568,7 +2568,7 @@ static void mpam_reset_component_locked(struct mpam_component *comp)
 	}
 }
 
-static void mpam_reset_class_locked(struct mpam_class *class)
+void mpam_reset_class_locked(struct mpam_class *class)
 {
 	struct mpam_component *comp;
 
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index e394ee78918a..f89ceaf7623d 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -393,6 +393,12 @@ extern u8 mpam_pmg_max;
 void mpam_enable(struct work_struct *work);
 void mpam_disable(struct work_struct *work);
 
+/* Reset all the RIS in a class under cpus_read_lock() */
+void mpam_reset_class_locked(struct mpam_class *class);
+
+/* Reset all the RIS in a component under cpus_read_lock() */
+void mpam_reset_component_locked(struct mpam_component *comp);
+
 int mpam_apply_config(struct mpam_component *comp, u16 partid,
 		      struct mpam_config *cfg);
 
diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 1566d0c686e6..683bdd6989d4 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -169,6 +169,19 @@ static int mpam_resctrl_pick_domain_id(int cpu, struct mpam_component *comp)
 	return comp->comp_id;
 }
 
+void resctrl_arch_reset_all_ctrls(struct rdt_resource *r)
+{
+	struct mpam_resctrl_res *res;
+
+	lockdep_assert_cpus_held();
+
+	if (!mpam_is_enabled())
+		return;
+
+	res = container_of(r, struct mpam_resctrl_res, resctrl_res);
+	mpam_reset_class_locked(res->class);
+}
+
 static void mpam_resctrl_domain_hdr_init(int cpu, struct mpam_component *comp,
 					 struct rdt_domain_hdr *hdr)
 {
@@ -352,6 +365,8 @@ void mpam_resctrl_offline_cpu(unsigned int cpu)
 			continue;
 
 		if (exposed_alloc_capable) {
+			mpam_reset_component_locked(dom->ctrl_comp);
+
 			ctrl_d = &dom->resctrl_ctrl_dom;
 			ctrl_dom_empty = mpam_resctrl_offline_domain_hdr(cpu, &ctrl_d->hdr);
 			if (ctrl_dom_empty)
-- 
2.43.0

