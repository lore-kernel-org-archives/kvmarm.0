Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EDF341AC0
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167933; cv=none; b=fWLwLTahyVpfeZ1d/vHQwxKZAX5A8ULDRL8esGOlUnzupUDlCCKK6NpbVgWrGpOaTvHVjO0zfVfsK+gVV1tUmKirHk1159OgAsgdEg+N3c2vYo9B8spq2f6rImjOLb/RhGnS/lCrQT8Y4ko+MovSTf3WBkSN50Yas/uyyD2HvI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167933; c=relaxed/simple;
	bh=UkaD1JsQUwZoaJqi84VfDa7Sm0Ylmx909NI9FicWQ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pi5ClOru1Jqm+RJ1Xj00z9JEgr2NEiY0FnNgIW1QrulS/K14rIRC9kEctAhEHbFy47VrfQK1EHKb3vLHcPUywhD4kiVJHDC8GSJZRMvaulHk/wN91i9LoLrmaVJsR60dDLUEws3/TsLxPPFyo0wUVZyN/44m61GzIF3UBWwxz18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E413FEC;
	Fri, 19 Dec 2025 10:12:04 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A80D93F5CA;
	Fri, 19 Dec 2025 10:12:06 -0800 (PST)
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
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2 02/45] arm_mpam: Remove duplicate linux/srcu.h header
Date: Fri, 19 Dec 2025 18:11:04 +0000
Message-ID: <20251219181147.3404071-3-ben.horgan@arm.com>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

./drivers/resctrl/mpam_internal.h: linux/srcu.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=27328
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Acked-by: James Morse <james.morse@arm.com>
[BH: Keep alphabetical order]
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index e79c3c47259c..17cdc3080d58 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -12,7 +12,6 @@
 #include <linux/jump_label.h>
 #include <linux/llist.h>
 #include <linux/mutex.h>
-#include <linux/srcu.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
 #include <linux/types.h>
-- 
2.43.0

