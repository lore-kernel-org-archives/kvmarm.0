Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAACF3A7588
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413199; cv=none; b=uD5EGsqacyXmB8a0HOhwbtY6/yDcMBdrA4FB81L+a7cZFXFpf7wrH6Zy8F+lB/1Vw5djT4SDGMoDeA+pxqA35J+ytDTcBKjkBTSIn54Eh/WxxWA4Wp3mXDg2a90NWvTiHSIxx18c1liIij5g7c2XRXPdFu+qAWMCtVlT+TmFA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413199; c=relaxed/simple;
	bh=xC0Yq1ZbdGjnBX5wivQCW4ujMMu9CmwEvYOnydNtC08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6N6Z9UpABnXqIwDFbBSlRiBaLbZjno1Cdc28UesImjzY+fMukyliftQyH7LK6e82mZXXdBSDp4QKKtmzhwlZFIUeMb3TQfdvebS+dIr6GLrTg41IOPlQLcNRge9OkrQxqyqcqo8cZN/2PWS4EAEx4N6mWtbPoUqTIvg7Mtwlrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B1D91E7D;
	Fri, 13 Mar 2026 07:46:30 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 861153F7BD;
	Fri, 13 Mar 2026 07:46:32 -0700 (PDT)
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
Subject: [PATCH v6 01/40] arm_mpam: Ensure in_reset_state is false after applying configuration
Date: Fri, 13 Mar 2026 14:45:38 +0000
Message-ID: <20260313144617.3420416-2-ben.horgan@arm.com>
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

From: Zeng Heng <zengheng4@huawei.com>

The per-RIS flag, in_reset_state, indicates whether or not the MSC
registers are in reset state, and allows avoiding resetting when they are
already in reset state. However, when mpam_apply_config() updates the
configuration it doesn't update the in_reset_state flag and so even after
the configuration update in_reset_state can be true and mpam_reset_ris()
will skip the actual register restoration on subsequent resets.

Once resctrl has a MPAM backend it will use resctrl_arch_reset_all_ctrls()
to reset the MSC configuration on unmount and, if the in_reset_state flag
is bogusly true, fail to reset the MSC configuration. The resulting
non-reset MSC configuration can lead to persistent performance restrictions
even after resctrl is unmounted.

Fix by clearing in_reset_state to false immediately after successful
configuration application, ensuring that the next reset operation
properly restores MSC register defaults.

Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Acked-by: Ben Horgan <ben.horgan@arm.com>
[Horgan: rewrite commit message to not be specific to resctrl unmount]
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Subject was originally:
arm_mpam: Fix MPAM reset on resctrl unmount by clearing in_reset_state
---
 drivers/resctrl/mpam_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 1eebc2602187..0fd6590a9b5c 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2692,6 +2692,7 @@ int mpam_apply_config(struct mpam_component *comp, u16 partid,
 					 srcu_read_lock_held(&mpam_srcu)) {
 			arg.ris = ris;
 			mpam_touch_msc(msc, __write_config, &arg);
+			ris->in_reset_state = false;
 		}
 		mutex_unlock(&msc->cfg_lock);
 	}
-- 
2.43.0

