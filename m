Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A1234A773
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413203; cv=none; b=F1K1yIz0e3d1t7Ruj8IDuxM9GmZbHdf5AAzV9fi6BrF7R/Bql0jlEEevKnaY4OITN3hmnoQGQcF7wnBOpd4yt3Pu0EYwoBUHZfWcqsFWOhD/oacXXMRNvQTwK5f1iQk5FRpx51JbzJF5+BAP4oRzROXpejdIRLeGkXJU9Pg5Qv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413203; c=relaxed/simple;
	bh=agju/eznKMh6NRaeD+38Lp19KkC9FTgpdK+vUuBGC18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsIPZlsi5+F2tbgxYBmqeFOlBKgBbZaTUl3YZfFZYtyWYRF0EVkzun8xn3qT8xj73Jy3+gGtflkgVz5QrssO4tqFJzqf3F/lWnLAU75dL44T2pUwjG71B54R2SZX99FPBGEzHDa/KwOEqqk7tyWMPibg5TVOKu1F1GhulaXOS+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 534C522C7;
	Fri, 13 Mar 2026 07:46:34 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9F6D73F7BD;
	Fri, 13 Mar 2026 07:46:36 -0700 (PDT)
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
	linux-doc@vger.kernel.org
Subject: [PATCH v6 02/40] arm_mpam: Reset when feature configuration bit unset
Date: Fri, 13 Mar 2026 14:45:39 +0000
Message-ID: <20260313144617.3420416-3-ben.horgan@arm.com>
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

To indicate that the configuration, of the controls used by resctrl, in a
RIS need resetting to driver defaults the reset flags in mpam_config are
set. However, these flags are only ever set temporarily at RIS scope in
mpam_reset_ris() and hence mpam_cpu_online() will never reset these
controls to default. As the hardware reset is unknown this leads to unknown
configuration when the control values haven't been configured away from the
defaults.

Use the policy that an unset feature configuration bit means reset. In this
way the mpam_config in the component can encode that it should be in reset
state and mpam_reprogram_msc() will reset controls as needed.

Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
This goes back to the initial feature configuration policy that James
used in the MPAM base driver rfc but I unfortunately
suggested him to change it.
---
 drivers/resctrl/mpam_devices.c | 40 ++++++++++------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 0fd6590a9b5c..ff861291bd4e 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1364,17 +1364,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 		__mpam_intpart_sel(ris->ris_idx, partid, msc);
 	}
 
-	if (mpam_has_feature(mpam_feat_cpor_part, rprops) &&
-	    mpam_has_feature(mpam_feat_cpor_part, cfg)) {
-		if (cfg->reset_cpbm)
-			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
-		else
+	if (mpam_has_feature(mpam_feat_cpor_part, rprops)) {
+		if (mpam_has_feature(mpam_feat_cpor_part, cfg))
 			mpam_write_partsel_reg(msc, CPBM, cfg->cpbm);
+		else
+			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
 	}
 
-	if (mpam_has_feature(mpam_feat_mbw_part, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_part, cfg)) {
-		if (cfg->reset_mbw_pbm)
+	if (mpam_has_feature(mpam_feat_mbw_part, rprops)) {
+		if (mpam_has_feature(mpam_feat_mbw_part, cfg))
 			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);
 		else
 			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
@@ -1384,16 +1382,14 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 	    mpam_has_feature(mpam_feat_mbw_min, cfg))
 		mpam_write_partsel_reg(msc, MBW_MIN, 0);
 
-	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
-		if (cfg->reset_mbw_max)
-			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
-		else
+	if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
+		if (mpam_has_feature(mpam_feat_mbw_max, cfg))
 			mpam_write_partsel_reg(msc, MBW_MAX, cfg->mbw_max);
+		else
+			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
 	}
 
-	if (mpam_has_feature(mpam_feat_mbw_prop, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_prop, cfg))
+	if (mpam_has_feature(mpam_feat_mbw_prop, rprops))
 		mpam_write_partsel_reg(msc, MBW_PROP, 0);
 
 	if (mpam_has_feature(mpam_feat_cmax_cmax, rprops))
@@ -1491,16 +1487,6 @@ static int mpam_save_mbwu_state(void *arg)
 	return 0;
 }
 
-static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
-{
-	*reset_cfg = (struct mpam_config) {
-		.reset_cpbm = true,
-		.reset_mbw_pbm = true,
-		.reset_mbw_max = true,
-	};
-	bitmap_fill(reset_cfg->features, MPAM_FEATURE_LAST);
-}
-
 /*
  * Called via smp_call_on_cpu() to prevent migration, while still being
  * pre-emptible. Caller must hold mpam_srcu.
@@ -1508,14 +1494,12 @@ static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
 static int mpam_reset_ris(void *arg)
 {
 	u16 partid, partid_max;
-	struct mpam_config reset_cfg;
+	struct mpam_config reset_cfg = {};
 	struct mpam_msc_ris *ris = arg;
 
 	if (ris->in_reset_state)
 		return 0;
 
-	mpam_init_reset_cfg(&reset_cfg);
-
 	spin_lock(&partid_max_lock);
 	partid_max = mpam_partid_max;
 	spin_unlock(&partid_max_lock);
-- 
2.43.0

