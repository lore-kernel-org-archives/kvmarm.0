Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2616F33F8C7
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167928; cv=none; b=Sl7MhjK5h3i0Ljc/bHPX7fySqA8Fd0QIuO63QT29gSpjEqECDDFwLJb2BZvgn3CMtFX9N3hzglPb7e3jtLbkcIE6cq8X8vySVr3x3pPKSsXudgqH9FcF7HL6qprKzFAo9cFndxG64TMX85jdYpeb9UBRi7lHbAf9oswMPX3J1vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167928; c=relaxed/simple;
	bh=sRUIdkbJ2DfrewEwPwMZEUMfDZFTpz1JF+MvWipeHq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly1wr8dzlDo3pSf5GfitDQjo7lVtXFdc+RoPJdZsntSs6b/9HIyz3d/+hinn6YezCdwOZdCFJEqNLciebT/k/AbgluEv+7StIocmj6eFLwSIvY/F1jt4icq+7r8m6t6/lvoQAHPV+XCmC3apakaMNjrF4TQUd3hXpvKwGPh1UH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 484FA106F;
	Fri, 19 Dec 2025 10:11:59 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AFCF63F5CA;
	Fri, 19 Dec 2025 10:12:01 -0800 (PST)
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
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH v2 01/45] arm_mpam: Stop using uninitialized variables in __ris_msmon_read()
Date: Fri, 19 Dec 2025 18:11:03 +0000
Message-ID: <20251219181147.3404071-2-ben.horgan@arm.com>
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

Dan has reported two uses of uninitialized variables in __ris_msmon_read().
If an unknown monitor type is encountered then the local variable, now, is
used uninitialized. Fix this by returning early on error. If a non-mbwu
monitor is being read then the local variable, overflow, is not initialized
but still read. Initialize it to false as overflow is not relevant for csu
monitors.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512091519.RBwiJcSq-lkp@intel.com/
Closes: https://lore.kernel.org/r/202512100547.N7QPYgfb-lkp@intel.com/
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_devices.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 0b5b158e1aaf..b495d5291868 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1072,7 +1072,7 @@ static void __ris_msmon_read(void *arg)
 	u64 now;
 	bool nrdy = false;
 	bool config_mismatch;
-	bool overflow;
+	bool overflow = false;
 	struct mon_read *m = arg;
 	struct mon_cfg *ctx = m->ctx;
 	bool reset_on_next_read = false;
@@ -1176,10 +1176,11 @@ static void __ris_msmon_read(void *arg)
 	}
 	mpam_mon_sel_unlock(msc);
 
-	if (nrdy) {
+	if (nrdy)
 		m->err = -EBUSY;
+
+	if (m->err)
 		return;
-	}
 
 	*m->val += now;
 }
-- 
2.43.0

