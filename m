Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C4A53373
	for <kvmarm@lists.linux.dev>; Sat, 17 Aug 2024 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723889800; cv=none; b=a3fi/5RMJBhqBoSWRb3/ok+Dwk4zRN7dZ3tuprR48WEMVumzY2GyVmRzKpWX1OgKnFlskRAdQZiAfOAYOsr71LvYmhM49XLTVl/2enmxe74H/wkEZf85tWrENGZJsgO5YjpBsxfNpPLIoSKWuHh0/SfzYhFGD7qK4TxOXxCFg5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723889800; c=relaxed/simple;
	bh=iOtg+i5wMlWNqEwP42cHZN7C73ZQKag0NQLv+2KnlR8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p+208kZtZAth+jU1aykcEG/s607naw+8xMdRgFNUdcwLRL1IJyfpLyzwrlALsuD7ndHcbHKj0cIY5UkOmxtYxMJrDbiGY94wTYpkk4qoptKvFocwWidgPK/EMehi7ri2yRWXAPLFfjb+ulXK4vC++iwxaReYLhzGH+F7Cgz4BH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WmF545yYhz2CmfR;
	Sat, 17 Aug 2024 18:11:36 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id A7942180044;
	Sat, 17 Aug 2024 18:16:32 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 17 Aug 2024 18:16:31 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, Zenghui Yu
	<yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic-debug: Don't put unmarked LPIs
Date: Sat, 17 Aug 2024 18:15:41 +0800
Message-ID: <20240817101541.1664-1-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600007.china.huawei.com (7.193.23.208)

If there were LPIs being mapped behind our back (i.e., between .start() and
.stop()), we would put them at iter_unmark_lpis() without checking if they
were actually *marked*, which is obviously not good.

Switch to use the xa_for_each_marked() iterator to fix it.

Fixes: 85d3ccc8b75b ("KVM: arm64: vgic-debug: Use an xarray mark for debug iterator")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index bc74d06398ef..e1397ab2072a 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -85,7 +85,7 @@ static void iter_unmark_lpis(struct kvm *kvm)
 	struct vgic_irq *irq;
 	unsigned long intid;
 
-	xa_for_each(&dist->lpi_xa, intid, irq) {
+	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
 		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
 		vgic_put_irq(kvm, irq);
 	}
-- 
2.33.0

