Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F5B3B3BE5
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773413297; cv=none; b=Wqr5gulCAckhW2j1iOPgDYArOuaxyDjAmjya5DsKV3kAYfCrtI/J0HzReQC4NOcIDFkdEDrfgLqJGQsa0xFnC0u+tXr7hmJvygvLhBr/dxZGBom7r8CLhgh1aCUlPaTF9nPKYxigcguvSk7wzjTQCRPwDKL01aeaAOBLZ2cLOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773413297; c=relaxed/simple;
	bh=8yZMv2aBuiNZxeLtLWo/CDd2K4CMwg23KgP5rMMEeWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NStuk2141C5ZYA0hPJiE18DLWzDadkewxEgHi97MHjjfhANeiaP/5QKVxAu8IwIEzzN4QVDwhrRR3qBB7Qd4R6IvnF8styuQiAM1FH36A3EAQefxxiAEOXalvKAqE3rjbfKBomsUEOjMiqI+ApNvoklNx9b5c2sSI6/PwVoOJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E5E21CC4;
	Fri, 13 Mar 2026 07:48:07 -0700 (PDT)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4D9503F7BD;
	Fri, 13 Mar 2026 07:48:09 -0700 (PDT)
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
Subject: [PATCH v6 24/40] arm_mpam: resctrl: Wait for cacheinfo to be ready
Date: Fri, 13 Mar 2026 14:46:01 +0000
Message-ID: <20260313144617.3420416-25-ben.horgan@arm.com>
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

In order to calculate the rmid realloc threshold the size of the cache
needs to be known. Cache domains will also be named after the cache id. So
that this information can be extracted from cacheinfo we need to wait for
it to be ready. The cacheinfo information is populated in device_initcall()
so we wait for that.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Tested-by: Zeng Heng <zengheng4@huawei.com>
Tested-by: Punit Agrawal <punit.agrawal@oss.qualcomm.com>
Reviewed-by: Zeng Heng <zengheng4@huawei.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
[horgan: split out from another patch]
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
This is moved into it's own patch to allow all uses of cacheinfo to be
valid when they are introduced.
---
 drivers/resctrl/mpam_resctrl.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 940446395ae1..93c8a9608ed4 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -16,6 +16,7 @@
 #include <linux/resctrl.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/wait.h>
 
 #include <asm/mpam.h>
 
@@ -42,6 +43,13 @@ static DEFINE_MUTEX(domain_list_lock);
  */
 static bool cdp_enabled;
 
+/*
+ * We use cacheinfo to discover the size of the caches and their id. cacheinfo
+ * populates this from a device_initcall(). mpam_resctrl_setup() must wait.
+ */
+static bool cacheinfo_ready;
+static DECLARE_WAIT_QUEUE_HEAD(wait_cacheinfo_ready);
+
 bool resctrl_arch_alloc_capable(void)
 {
 	struct mpam_resctrl_res *res;
@@ -757,6 +765,8 @@ int mpam_resctrl_setup(void)
 	struct mpam_resctrl_res *res;
 	enum resctrl_res_level rid;
 
+	wait_event(wait_cacheinfo_ready, cacheinfo_ready);
+
 	cpus_read_lock();
 	for_each_mpam_resctrl_control(res, rid) {
 		INIT_LIST_HEAD_RCU(&res->resctrl_res.ctrl_domains);
@@ -794,3 +804,12 @@ int mpam_resctrl_setup(void)
 
 	return 0;
 }
+
+static int __init __cacheinfo_ready(void)
+{
+	cacheinfo_ready = true;
+	wake_up(&wait_cacheinfo_ready);
+
+	return 0;
+}
+device_initcall_sync(__cacheinfo_ready);
-- 
2.43.0

