Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F41C936997B
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237203; cv=none; b=KAD4g1LMJCsxGxwiupdJJ6sOX1OA8b/vdaeCg3H4jNGSrXOrcFPwwCQLfgvkDQXdAYD8I5ea645vO5PL9SP0Frn8UD40gD8vNWQGYeCRM/Gdl3RkkVGvJOgcSiYz7dpuMX9D4RgCdhvZqbAWobYOW3jkYQ99Wl2Mx7PYb/7xEkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237203; c=relaxed/simple;
	bh=oj4fcTHoEXtPA7MG6nGH+9WSMY2ShQSL6A2VkyhxVJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awCokhAMk7AtRUSegK1D8m915rdaURrIjE5KT5DHJYFCZshDBsNbFNjwKfDUY9JgMHS08buduNe2C0Vk7TE2FSsuIjuWDtjewPK6JPXQwCgHmQut9kjXQELrq9nNAKXtYibwYUahWvE0fUtLavn9zwoeriuzQZa0d15fphBCBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC9E3153B;
	Mon, 12 Jan 2026 08:59:54 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5FFA33F694;
	Mon, 12 Jan 2026 08:59:56 -0800 (PST)
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
Subject: [PATCH v3 02/47] arm_mpam: Use non-atomic bitops when modifying feature bitmap
Date: Mon, 12 Jan 2026 16:58:29 +0000
Message-ID: <20260112165914.4086692-3-ben.horgan@arm.com>
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

In the test__props_mismatch() kunit test we rely on the struct mpam_props
being packed to ensure memcmp doesn't consider packing. Making it packed
reduces the alignment of the features bitmap and so breaks a requirement
for the use of atomics. As we don't rely on the set/clear of these bits
being atomic, just make them non-atomic.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v2:
Add comment (Jonathan)
---
 drivers/resctrl/mpam_internal.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index 17cdc3080d58..e8971842b124 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -200,8 +200,12 @@ struct mpam_props {
 } PACKED_FOR_KUNIT;
 
 #define mpam_has_feature(_feat, x)	test_bit(_feat, (x)->features)
-#define mpam_set_feature(_feat, x)	set_bit(_feat, (x)->features)
-#define mpam_clear_feature(_feat, x)	clear_bit(_feat, (x)->features)
+/*
+ * The non-atomic get/set operations are used because if struct mpam_props is
+ * packed, the alignment requirements for atomics aren't met.
+ */
+#define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
+#define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
 
 /* The values for MSMON_CFG_MBWU_FLT.RWBW */
 enum mon_filter_options {
-- 
2.43.0

