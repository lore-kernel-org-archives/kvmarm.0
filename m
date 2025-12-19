Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F2835CB90
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168122; cv=none; b=HpPTkfjD+r5kT1vRvvKUAm/ush1QQ3s72FhV6WJOCm81FbGTESgdHLDg4dMUk1Elj7hvQ2rSluqA0aLca48VPN5aX+++PrXtir4pOKJ3GMQJhVYXnOgplpKs+vj4extZwK0kCrvUld2NrdXapBB4yYHQrVfi26BL1WM4DE5vsOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168122; c=relaxed/simple;
	bh=Vs4yojyhYsOw9QoWyKS26tGnH5yr+mS/gBFAMDh45zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdFQoZz1f3X2snP9KUCVOokK8ElBaZfnj0+kP7klf29ChP0fI6+dcbUyBO7P0kQXTT7YA19dGxMl8ilVRvgCc4uB4ntOF0eLT/sUxjm5KLx6czh5P5ruHg8+ICILPeBc2B7gSeqJ6tVTAnyAlKFQ9ztYBlOgajCkqpxGhEXxG28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E060816F2;
	Fri, 19 Dec 2025 10:15:10 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 947D83F5CA;
	Fri, 19 Dec 2025 10:15:13 -0800 (PST)
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
Subject: [PATCH v2 41/45] arm_mpam: Add quirk framework
Date: Fri, 19 Dec 2025 18:11:43 +0000
Message-ID: <20251219181147.3404071-42-ben.horgan@arm.com>
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

From: Shanker Donthineni <sdonthineni@nvidia.com>

The MPAM specification includes the MPAMF_IIDR, which serves to uniquely
identify the MSC implementation through a combination of implementer
details, product ID, variant, and revision. Certain hardware issues/errata
can be resolved using software workarounds.

Introduce a quirk framework to allow workarounds to be enabled based on the
MPAMF_IIDR value.

[ morse: Stash the IIDR so this doesn't need an IPI, enable quirks only
once, move the description to the callback so it can be pr_once()d, add an
enum of workarounds for popular errata. Add macros for making lists of
product/revision/vendor half readable ]

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
remove trailing commas in last element of enums
Make mpam_enable_quirks() in charge of mpam_set_quirk() even if there
is an enable.
---
 drivers/resctrl/mpam_devices.c  | 32 ++++++++++++++++++++++++++++++++
 drivers/resctrl/mpam_internal.h | 25 +++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index deea46c2a6c3..1c574b5710d8 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -630,6 +630,30 @@ static struct mpam_msc_ris *mpam_get_or_create_ris(struct mpam_msc *msc,
 	return ERR_PTR(-ENOENT);
 }
 
+static const struct mpam_quirk mpam_quirks[] = {
+	{ NULL } /* Sentinel */
+};
+
+static void mpam_enable_quirks(struct mpam_msc *msc)
+{
+	const struct mpam_quirk *quirk;
+
+	for (quirk = &mpam_quirks[0]; quirk->iidr_mask; quirk++) {
+		int err = 0;
+
+		if (quirk->iidr != (msc->iidr & quirk->iidr_mask))
+			continue;
+
+		if (quirk->init)
+			err = quirk->init(msc, quirk);
+
+		if (err)
+			continue;
+
+		mpam_set_quirk(quirk->workaround, msc);
+	}
+}
+
 /*
  * IHI009A.a has this nugget: "If a monitor does not support automatic behaviour
  * of NRDY, software can use this bit for any purpose" - so hardware might not
@@ -864,8 +888,11 @@ static int mpam_msc_hw_probe(struct mpam_msc *msc)
 	/* Grab an IDR value to find out how many RIS there are */
 	mutex_lock(&msc->part_sel_lock);
 	idr = mpam_msc_read_idr(msc);
+	msc->iidr = mpam_read_partsel_reg(msc, IIDR);
 	mutex_unlock(&msc->part_sel_lock);
 
+	mpam_enable_quirks(msc);
+
 	msc->ris_max = FIELD_GET(MPAMF_IDR_RIS_MAX, idr);
 
 	/* Use these values so partid/pmg always starts with a valid value */
@@ -1993,6 +2020,7 @@ static bool mpam_has_cmax_wd_feature(struct mpam_props *props)
  * resulting safe value must be compatible with both. When merging values in
  * the tree, all the aliasing resources must be handled first.
  * On mismatch, parent is modified.
+ * Quirks on an MSC will apply to all MSC in that class.
  */
 static void __props_mismatch(struct mpam_props *parent,
 			     struct mpam_props *child, bool alias)
@@ -2112,6 +2140,7 @@ static void __props_mismatch(struct mpam_props *parent,
  * nobble the class feature, as we can't configure all the resources.
  * e.g. The L3 cache is composed of two resources with 13 and 17 portion
  * bitmaps respectively.
+ * Quirks on an MSC will apply to all MSC in that class.
  */
 static void
 __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
@@ -2125,6 +2154,9 @@ __class_props_mismatch(struct mpam_class *class, struct mpam_vmsc *vmsc)
 	dev_dbg(dev, "Merging features for class:0x%lx &= vmsc:0x%lx\n",
 		(long)cprops->features, (long)vprops->features);
 
+	/* Merge quirks */
+	class->quirks |= vmsc->msc->quirks;
+
 	/* Take the safe value for any common features */
 	__props_mismatch(cprops, vprops, false);
 }
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index cc580dea9430..5989f3670af3 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -85,6 +85,8 @@ struct mpam_msc {
 	u8			pmg_max;
 	unsigned long		ris_idxs;
 	u32			ris_max;
+	u32			iidr;
+	u16			quirks;
 
 	/*
 	 * error_irq_lock is taken when registering/unregistering the error
@@ -212,6 +214,28 @@ struct mpam_props {
 #define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
 #define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
 
+/* Workaround bits for msc->quirks */
+enum mpam_device_quirks {
+	MPAM_QUIRK_LAST
+};
+
+#define mpam_has_quirk(_quirk, x)	((1 << (_quirk) & (x)->quirks))
+#define mpam_set_quirk(_quirk, x)	((x)->quirks |= (1 << (_quirk)))
+
+struct mpam_quirk {
+	int (*init)(struct mpam_msc *msc, const struct mpam_quirk *quirk);
+
+	u32 iidr;
+	u32 iidr_mask;
+
+	enum mpam_device_quirks workaround;
+};
+
+#define MPAM_IIDR_MATCH_ONE	FIELD_PREP_CONST(MPAMF_IIDR_PRODUCTID,   0xfff)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_VARIANT,     0xf)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_REVISION,    0xf)	| \
+				FIELD_PREP_CONST(MPAMF_IIDR_IMPLEMENTER, 0xfff)
+
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
 	COUNT_BOTH	= 0,
@@ -255,6 +279,7 @@ struct mpam_class {
 
 	struct mpam_props	props;
 	u32			nrdy_usec;
+	u16			quirks;
 	u8			level;
 	enum mpam_class_types	type;
 
-- 
2.43.0

