Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A04EB647
	for <kvmarm@lists.linux.dev>; Wed,  7 Aug 2024 05:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723008043; cv=none; b=UnX9jfuT+4QHxhyPyCZ8QAitdGK/EpcSAVJarDXXfEE+Dlm9XqtnB8fuwJXZGGGPToqX8pHztgfgs4gxe/v0hvfZMcn6VdzBcSyAz8FCrRCQCDUXOUrtsqOsKAQmcwlsiZGVIdWn5g21+CLKure7+htqo76ADdNgKJUNS5Vj0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723008043; c=relaxed/simple;
	bh=eAjnjLN2kEwwn1ed4YJtCh+QGXISOV0u10dHbHXDnBc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NkgOqUa6kVWr+pKTb8f++XWuzmbc/Xl1DuUstihu5/Xg5/pyh0gOtu2+z8thLfd/Lqk/mqClsfYxsuVj347HcNu1XlirA1ye50g/gGOmpz8i1wvwi9IA1KqDKiaIb3Xk5k7K94XqfycZDXU1+eRyaL2xQ58Nrm9Oxtgp8lgqqX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wdz0p6BZ3zQp8P;
	Wed,  7 Aug 2024 13:16:10 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 50915180102;
	Wed,  7 Aug 2024 13:20:37 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.174.178.219) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 13:20:36 +0800
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <wanghaibin.wang@huawei.com>, Zenghui Yu
	<yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: vgic-debug: Exit the iterator properly w/o LPI
Date: Wed, 7 Aug 2024 13:20:24 +0800
Message-ID: <20240807052024.2084-1-yuzenghui@huawei.com>
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

In case the guest doesn't have any LPI, we previously relied on the
iterator setting

	'intid = nr_spis + VGIC_NR_PRIVATE_IRQS' && 'lpi_idx = 1'

to exit the iterator. But it was broken with commit 85d3ccc8b75b ("KVM:
arm64: vgic-debug: Use an xarray mark for debug iterator") -- the intid
remains at 'nr_spis + VGIC_NR_PRIVATE_IRQS - 1', and we end up endlessly
printing the last SPI's state.

Consider that it's meaningless to search the LPI xarray and populate
lpi_idx when there is no LPI, let's just skip the process for that case.

The result is that

* If there's no LPI, we focus on the intid and exit the iterator when it
  runs out of the valid SPI range.
* Otherwise we keep the current logic and let the xarray drive the
  iterator.

Fixes: 85d3ccc8b75b ("KVM: arm64: vgic-debug: Use an xarray mark for debug iterator")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index bcbc8c986b1d..bc74d06398ef 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -45,7 +45,8 @@ static void iter_next(struct kvm *kvm, struct vgic_state_iter *iter)
 	 * Let the xarray drive the iterator after the last SPI, as the iterator
 	 * has exhausted the sequentially-allocated INTID space.
 	 */
-	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1)) {
+	if (iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS - 1) &&
+	    iter->nr_lpis) {
 		if (iter->lpi_idx < iter->nr_lpis)
 			xa_find_after(&dist->lpi_xa, &iter->intid,
 				      VGIC_LPI_MAX_INTID,
@@ -112,7 +113,7 @@ static bool end_of_vgic(struct vgic_state_iter *iter)
 	return iter->dist_id > 0 &&
 		iter->vcpu_id == iter->nr_cpus &&
 		iter->intid >= (iter->nr_spis + VGIC_NR_PRIVATE_IRQS) &&
-		iter->lpi_idx > iter->nr_lpis;
+		(!iter->nr_lpis || iter->lpi_idx > iter->nr_lpis);
 }
 
 static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
-- 
2.33.0

