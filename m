Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617CB374175
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155270; cv=none; b=mqzh2cw4dzykkPJbLk7s/j57Gmp5j3E/fFQ4xb/wrru32LTFyyaKNrHjPs0H5OFkkmOHrL5nY17v9evYBlXVBQRBsvM4QETX5m35dyW73gJRC4WT1uXF1WSbyEQOho2BylMQa/1uCc2ushlb4ENC/Ie1qebHQNXGbXgnkvPXmVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155270; c=relaxed/simple;
	bh=+tnFIg/3bAx2eeHPY04XMT7SNmLtNoyIBbc+mYgHMfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjyBd0sP21gxve6yvDtjSja5MrrH/UI6GBj00Q0xkL6uAm0REjNOJ3laTUwM4jT3al68BDlBn+xSM5x9Id5v8Cis2NFgJVy4XtqmL4wTwR377uIXFtJJ4RBEkaZttnlrq3H8kXxBoEJPPdmfmttNu86328e3vcKwylakn3DwjkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3B661063;
	Tue,  3 Feb 2026 13:47:42 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7D63B3F778;
	Tue,  3 Feb 2026 13:47:43 -0800 (PST)
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
Subject: [PATCH v4 39/41] arm_mpam: Add workaround for T241-MPAM-6
Date: Tue,  3 Feb 2026 21:43:40 +0000
Message-ID: <20260203214342.584712-40-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203214342.584712-1-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shanker Donthineni <sdonthineni@nvidia.com>

The registers MSMON_MBWU_L and MSMON_MBWU return the number of requests
rather than the number of bytes transferred.

Bandwidth resource monitoring is performed at the last level cache, where
each request arrive in 64Byte granularity. The current implementation
returns the number of transactions received at the last level cache but
does not provide the value in bytes. Scaling by 64 gives an accurate byte
count to match the MPAM specification for the MSMON_MBWU and MSMON_MBWU_L
registers. This patch fixes the issue by reporting the actual number of
bytes instead of the number of transactions from __ris_msmon_read().

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since rfc:
MPAM_IIDR_NVIDIA_T421 -> MPAM_IIDR_NVIDIA_T241
Don't apply workaround to MSMON_MBWU_LWD
---
 Documentation/arch/arm64/silicon-errata.rst |  2 ++
 drivers/resctrl/mpam_devices.c              | 26 +++++++++++++++++++--
 drivers/resctrl/mpam_internal.h             |  1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index b18bc704d4a1..e810b2a8f40e 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -250,6 +250,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | NVIDIA         | T241 MPAM       | T241-MPAM-4     | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| NVIDIA         | T241 MPAM       | T241-MPAM-6     | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
 +----------------+-----------------+-----------------+-----------------------------+
diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 37a105d95d66..51cf29bda66e 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -685,6 +685,12 @@ static const struct mpam_quirk mpam_quirks[] = {
 	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
 	.workaround = T241_FORCE_MBW_MIN_TO_ONE,
 	},
+	{
+	/* NVIDIA t241 erratum T241-MPAM-6 */
+	.iidr       = MPAM_IIDR_NVIDIA_T241,
+	.iidr_mask  = MPAM_IIDR_MATCH_ONE,
+	.workaround = T241_MBW_COUNTER_SCALE_64,
+	},
 	{ NULL } /* Sentinel */
 };
 
@@ -1146,7 +1152,7 @@ static void write_msmon_ctl_flt_vals(struct mon_read *m, u32 ctl_val,
 	}
 }
 
-static u64 mpam_msmon_overflow_val(enum mpam_device_features type)
+static u64 __mpam_msmon_overflow_val(enum mpam_device_features type)
 {
 	/* TODO: implement scaling counters */
 	switch (type) {
@@ -1161,6 +1167,18 @@ static u64 mpam_msmon_overflow_val(enum mpam_device_features type)
 	}
 }
 
+static u64 mpam_msmon_overflow_val(enum mpam_device_features type,
+				   struct mpam_msc *msc)
+{
+	u64 overflow_val = __mpam_msmon_overflow_val(type);
+
+	if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc) &&
+	    type != mpam_feat_msmon_mbwu_63counter)
+		overflow_val *= 64;
+
+	return overflow_val;
+}
+
 static void __ris_msmon_read(void *arg)
 {
 	u64 now;
@@ -1251,13 +1269,17 @@ static void __ris_msmon_read(void *arg)
 			now = FIELD_GET(MSMON___VALUE, now);
 		}
 
+		if (mpam_has_quirk(T241_MBW_COUNTER_SCALE_64, msc) &&
+		    m->type != mpam_feat_msmon_mbwu_63counter)
+			now *= 64;
+
 		if (nrdy)
 			break;
 
 		mbwu_state = &ris->mbwu_state[ctx->mon];
 
 		if (overflow)
-			mbwu_state->correction += mpam_msmon_overflow_val(m->type);
+			mbwu_state->correction += mpam_msmon_overflow_val(m->type, msc);
 
 		/*
 		 * Include bandwidth consumed before the last hardware reset and
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index f6bf462058d9..7a3a46b94913 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -221,6 +221,7 @@ struct mpam_props {
 enum mpam_device_quirks {
 	T241_SCRUB_SHADOW_REGS,
 	T241_FORCE_MBW_MIN_TO_ONE,
+	T241_MBW_COUNTER_SCALE_64,
 	MPAM_QUIRK_LAST
 };
 
-- 
2.43.0

