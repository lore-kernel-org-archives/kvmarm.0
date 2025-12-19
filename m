Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2927233D6CA
	for <kvmarm@lists.linux.dev>; Fri, 19 Dec 2025 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766167938; cv=none; b=SWjij7BF52dy0n+pHWgHZpZ+m4txNSDevBHmy4ZWaEMp6uPrjWegULLIAf5SK6jnsc6/ewBPTsGA2QVEsQiTUYFkE5ExRw1WD6oLXP+7iWi3UCnzjoqWSaSWIuXigPb2H324MeUQxbE+DUAkZeK/04625fW1GORIPAEcD0hfmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766167938; c=relaxed/simple;
	bh=8wtfK08/dTkFpjZ8uWAVaOKtU1VDlpzYmZSO+iT/+MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKDCIAsad7lO4AXQXrNM6qf4zkF0KWPp0Iz+0pnghwHVCmajLmLgciDmIEZsAqu1RCRhHp+Wzz386vbmB1xH2mw/Ahz4v8E1WelwoMXuPUQdkPCI66KlqBdfGcAvkAHlEucy5qjgUy0PJ/E/xL4ZNq4KtM+SdetrkzaOH40VwmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60426106F;
	Fri, 19 Dec 2025 10:12:09 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08C563F5CA;
	Fri, 19 Dec 2025 10:12:11 -0800 (PST)
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
Subject: [PATCH v2 03/45] arm_mpam: Use non-atomic bitops when modifying feature bitmap
Date: Fri, 19 Dec 2025 18:11:05 +0000
Message-ID: <20251219181147.3404071-4-ben.horgan@arm.com>
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

In the test__props_mismatch() kunit test we rely on the struct mpam_props
being packed to ensure memcmp doesn't consider packing. Making it packed
reduces the alignment of the features bitmap and so breaks a requirement
for the use of atomics. As we don't rely on the set/clear of these bits
being atomic, just make them non-atomic.

Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 17cdc3080d58..aaaf31ca9210 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -200,8 +200,8 @@ struct mpam_props {
 } PACKED_FOR_KUNIT;
 
 #define mpam_has_feature(_feat, x)	test_bit(_feat, (x)->features)
-#define mpam_set_feature(_feat, x)	set_bit(_feat, (x)->features)
-#define mpam_clear_feature(_feat, x)	clear_bit(_feat, (x)->features)
+#define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
+#define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
 
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
-- 
2.43.0

