Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436DE36D4FA
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155123; cv=none; b=WbeH+8JeVPfMJuCTCMNY9NZkYvLR6+4SEXAvTB7mdJT/h4Af7N3WqZalvbN6v72dMuIumdTpc+28rLMJAyfjq8qAv4U9fkMDJRBvkfRCypRpUzEAKvrXjGU5kkfD9Pa/pr5yo9254+DjTWBsETOBd5EtzeBr3U0edH9d6bTXNM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155123; c=relaxed/simple;
	bh=4Yk01KWSnNOo2sWrqodR58bKoWkmJ10ODL+nhGPYxCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8kDCCHeTN0zJSB8wCVO6TFGnIW3KO0EU1yAJ2nk+6hJbQT8S1/XANtZtlGgWFgx6LL+7Gv0lnjDT+F80GK4EVsfhVLNAkv0kEisr5NbnY2RnW7yVYLIX+zPg9AeKw2wo2s3d/301ehNwfJmRDp/o9s8l+i4p1JtIApbsamm1M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A7E8497;
	Tue,  3 Feb 2026 13:45:15 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 52E343F778;
	Tue,  3 Feb 2026 13:45:16 -0800 (PST)
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
Subject: [PATCH v4 14/41] arm_mpam: resctrl: Sort the order of the domain lists
Date: Tue,  3 Feb 2026 21:43:15 +0000
Message-ID: <20260203214342.584712-15-ben.horgan@arm.com>
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

From: James Morse <james.morse@arm.com>

resctrl documents that the domains appear in numeric order in the schemata
file. This means a little more work is needed when bringing a domain
online.

Add the support for this, using resctrl_find_domain() to find the point to
insert in the list.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 drivers/resctrl/mpam_resctrl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 4c2248c92955..90cdb5fdd3d6 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -127,6 +127,21 @@ static bool mpam_resctrl_offline_domain_hdr(unsigned int cpu,
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
@@ -168,8 +183,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		if (err)
 			goto free_domain;
 
-		/* TODO: this list should be sorted */
-		list_add_tail_rcu(&ctrl_d->hdr.list, &r->ctrl_domains);
+		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
 	} else {
 		pr_debug("Skipped control domain online - no controls\n");
 	}
@@ -182,8 +196,7 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 		if (err)
 			goto offline_ctrl_domain;
 
-		/* TODO: this list should be sorted */
-		list_add_tail_rcu(&mon_d->hdr.list, &r->mon_domains);
+		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
 	} else {
 		pr_debug("Skipped monitor domain online - no monitors\n");
 	}
-- 
2.43.0

