Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E35376BE7
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237274; cv=none; b=s83B2cOdnOq+wLJ66lDWfhb/LrdYZDpDHNglKtGVSSBs+6Hq/CJmsnN3c4qVlYHnERxTjO7nt7M3/FB3/8SOjiFXzZJOJwfyNmzZEVwkS6w1WAZ3nsS/aHPYw+8B2SNyoSj+VQnVbCifvmNRmmJ/v78DmgXp/kb9Pg9J2/yzpSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237274; c=relaxed/simple;
	bh=XgDK89hqWEfO/2PoYrBcNNldKaN3xMud0defVYyMoZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKLquv46sgyc+TkMBB2ZwGQx9jBvbwneQH55sQ/2zJLtm6qa41g95j9YrjdcB1BYaFine2r4Lbd3UNFl7y39GIOXdQZ87XI55LRcu7wYWi47W8Zf4OCSXbMaej2nXQ4vUk0fxUr6b9uUCNnxPRQxn7ExZvM5ylvAuMv22LE1I6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D605F1596;
	Mon, 12 Jan 2026 09:01:05 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7811A3F694;
	Mon, 12 Jan 2026 09:01:07 -0800 (PST)
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
Subject: [PATCH v3 15/47] arm_mpam: resctrl: Sort the order of the domain lists
Date: Mon, 12 Jan 2026 16:58:42 +0000
Message-ID: <20260112165914.4086692-16-ben.horgan@arm.com>
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

From: James Morse <james.morse@arm.com>

resctrl documents that the domains appear in numeric order in the schemata
file. This means a little more work is needed when bringing a domain
online.

Add the support for this, using resctrl_find_domain() to find the point to
insert in the list.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_resctrl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index cb29c05edfa8..4dba6f58f79c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -119,6 +119,21 @@ static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,
 	return false;
 }
 
+static void mpam_resctrl_domain_insert(struct list_head *list,
+				       struct rdt_domain_hdr *new)
+{
+	struct rdt_domain_hdr *err;
+	struct list_head *pos = NULL;
+
+	lockdep_assert_held(&domain_list_lock);
+
+	err = resctrl_find_domain(list, new->id, &pos);
+	if (WARN_ON_ONCE(err))
+		return;
+
+	list_add_tail_rcu(&new->list, pos);
+}
+
 static struct mpam_resctrl_dom *
 mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 {
@@ -156,8 +171,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		ctrl_d = &dom->resctrl_ctrl_dom;
 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &ctrl_d->hdr);
 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
-		/* TODO: this list should be sorted */
-		list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);
+		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
 		err = resctrl_online_ctrl_domain(r, ctrl_d);
 		if (err) {
 			dom = ERR_PTR(err);
@@ -171,8 +185,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		mon_d = &dom->resctrl_mon_dom;
 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, &mon_d->hdr);
 		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
-		/* TODO: this list should be sorted */
-		list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);
+		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
 		err = resctrl_online_mon_domain(r, mon_d);
 		if (err) {
 			dom = ERR_PTR(err);
-- 
2.43.0

