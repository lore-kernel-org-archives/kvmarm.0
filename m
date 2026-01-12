Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CCF3644C1
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237198; cv=none; b=oOofRlmiqYU/OZQA7kpAff9SAvpN/mtviYpeCqkSEUNfMj5eh5aiU8794R99FFc7rfDunQ3rO0NLWrNCoKcPECcAcUasn9fZsJtIhLmfMzsPvQvIESkGiVK74z3VH8VoPCRox9tTgjKUl9ij8agu+MlAhqJt6g2L8WKe0KwxY3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237198; c=relaxed/simple;
	bh=QfwhqVTlOw0+rN66pc9fTV3/5ynC59P3wyYCu+l4kf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOinwZf4dr1qMQ93+qLQCw/OXubG/7G1YjRVMd5jx8hoPXNEDWE5t70g1mppjCvnlEfftz/MwN0mLvdQK8Mb0wtR5MIBfp2gtIfY+wOP/DfA5eAqtLp67vcO2Yar7Fn+o7EhRDwaOZkaidWujEYXp04esucUfZO4R4vCQVY/T2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D8641516;
	Mon, 12 Jan 2026 08:59:49 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 96F8D3F694;
	Mon, 12 Jan 2026 08:59:50 -0800 (PST)
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
Subject: [PATCH v3 01/47] arm_mpam: Remove duplicate linux/srcu.h header
Date: Mon, 12 Jan 2026 16:58:28 +0000
Message-ID: <20260112165914.4086692-2-ben.horgan@arm.com>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

./drivers/resctrl/mpam_internal.h: linux/srcu.h is included more than once.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
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

