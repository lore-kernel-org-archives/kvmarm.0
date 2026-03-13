Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292233AC0D2
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413284; cv=none; b=iNq45pnJQdRnnAg4JWrjuAWI8Vx2HxY3vSKv84T6gMTihcIMhi8r0a1GZkvx5r7jVEfu8LhF5hbWf7kQtQ5TqxTKucTglUCjFuhTU5VU+rbPHWUJfRkOmZIQCMb+K5Vs2Rv0MpG5eQN5PV8AWfCY7ewsBPUvLMi/wzYB2bLa1fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413284; c=relaxed/simple;
	bh=xl4VKzlCqaYsEzZcwZF3Z0Mq6i0OlJzFlqYJJLr30Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nInbH4HoV8Slq2Ppt9ZitikxHG9Oemj4sR25BdYDsbp5wOWesgeSlBYtOtyPKjuobjNzYn3jlsNvgzbfjJObbj2B8asC0dD36NvNPkbDZdsDv6vet/TfOHCFsZJ/kBrSlsye/F3xysHs68MljRn3PN/8rE1JCAqu8cz1piUP3gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AB3822C7;
	Fri, 13 Mar 2026 07:47:54 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A88F33F7BD;
	Fri, 13 Mar 2026 07:47:56 -0700 (PDT)
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
Subject: [PATCH v6 21/40] arm_mpam: resctrl: Hide CDP emulation behind CONFIG_EXPERT
Date: Fri, 13 Mar 2026 14:45:58 +0000
Message-ID: <20260313144617.3420416-22-ben.horgan@arm.com>
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

When CDP is not enabled, the 'rmid_entry's in the limbo list,
rmid_busy_llc, map directly to a (PARTID,PMG) pair and when CDP is enabled
the mapping is to two different pairs. As the limbo list is reused between
mounts and CDP disabled on unmount this can lead to stale mapping and the
limbo handler will then make monitor reads with potentially out of range
PARTID. This may then cause an MPAM error interrupt and the driver will
disable MPAM.

No problems are expected if you just mount the resctrl file system
once with CDP enabled and never unmount it. Hide CDP emulation behind
CONFIG_EXPERT to protect the unwary.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Adding this ugliness in the hope of avoiding patch churn and extra
reviewer work. I am looking into the resctrl changes needed to fix this.
---
 drivers/resctrl/mpam_resctrl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 903d1a0f564f..cab3e9ccb5c7 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -82,6 +82,18 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level rid, bool enable)
 	u32 partid_i = RESCTRL_RESERVED_CLOSID, partid_d = RESCTRL_RESERVED_CLOSID;
 	int cpu;
 
+	if (!IS_ENABLED(CONFIG_EXPERT) && enable) {
+		/*
+		 * If the resctrl fs is mounted more than once, sequentially,
+		 * then CDP can lead to the use of out of range PARTIDs.
+		 */
+		pr_warn("CDP not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enable)
+		pr_warn("CDP is an expert feature and may cause MPAM to malfunction.\n");
+
 	/*
 	 * resctrl_arch_set_cdp_enabled() is only called with enable set to
 	 * false on error and unmount.
-- 
2.43.0

