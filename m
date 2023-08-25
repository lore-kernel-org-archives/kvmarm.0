Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8142AC2DA
	for <kvmarm@lists.linux.dev>; Fri, 25 Aug 2023 09:36:34 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXFDv3Mw3z6D8XF;
	Fri, 25 Aug 2023 17:35:43 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:24 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>, <will@kernel.org>,
	<catalin.marinas@arm.com>, <oliver.upton@linux.dev>
CC: <james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<zhukeqian1@huawei.com>, <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 2/8] KVM: arm64: Add KVM_PGTABLE_WALK_HW_DBM for HW DBM support
Date: Fri, 25 Aug 2023 10:35:22 +0100
Message-ID: <20230825093528.1637-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

KVM_PGTABLE_WALK_HW_DBM - Indicates page table walk is for HW DBM
 related updates.

No functional changes here. Only apply any HW DBM bit updates to last
level only. These will be used by a future commit where we will add
support for HW DBM.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d3e354bb8351..3f96bdd2086f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -219,6 +219,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
  *					without Cache maintenance
  *					operations required.
+ * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute update is
+ *					HW DBM related.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -228,6 +230,7 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
 	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
 	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
+	KVM_PGTABLE_WALK_HW_DBM			= BIT(7),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f155b8c9e98c..1e65b8c97059 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -67,6 +67,11 @@ struct kvm_pgtable_walk_data {
 	const u64			end;
 };
 
+static bool kvm_pgtable_walk_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_HW_DBM;
+}
+
 static bool kvm_pgtable_walk_skip_bbm_tlbi(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM_TLBI);
@@ -1164,6 +1169,11 @@ static int stage2_attr_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!kvm_pte_valid(ctx->old))
 		return -EAGAIN;
 
+	/* Only apply HW DBM for last level */
+	if (kvm_pgtable_walk_hw_dbm(ctx) &&
+	    ctx->level != (KVM_PGTABLE_MAX_LEVELS - 1))
+		return 0;
+
 	data->level = ctx->level;
 	data->pte = pte;
 	pte &= ~data->attr_clr;
-- 
2.34.1

