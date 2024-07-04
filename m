Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6A41AEFF1
	for <kvmarm@lists.linux.dev>; Thu,  4 Jul 2024 14:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720103024; cv=none; b=h1teEjmpFGcRdyHqumm+g3f38OESX9/+xnNP7YNTZObAFCp4nGlTnqWgNHD+ug88GETk11hC3ht8NpeqZDDjDl9W9q9mc56cV//5Mh1d7q61jrDuUsqZ6l2y+CVmXtrjOzA+kZps84C3SwT+b7mI+FvIEcKCy/EV4H70VgCxzII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720103024; c=relaxed/simple;
	bh=KrZe2caXFpNZ5bhpo5GktpUmX4hydQh14ub+3FEpYqk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OttBuetSijy8mYOXBQ4FUSbSE+gQMs53dWzd4TYl0ErrTcNGj4TrH4zZdsAMwlz5IfrCt33ezVg14OWvhLzh/THvMqTqJ1u4IdUnJhJ+xe4MSHylKSaktsnOGZj+wiqTFWMCEUMNQaZ+PGEiqyFkieBpPCUUcp/zz+DNjqAgi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WFJgp29t7zQjy2;
	Thu,  4 Jul 2024 22:19:50 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id AC83814011A;
	Thu,  4 Jul 2024 22:23:39 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 22:23:38 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>, <tangnianyao@huawei.com>
Subject: [PATCH v2 1/3] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
Date: Thu, 4 Jul 2024 22:23:17 +0800
Message-ID: <20240704142319.728-2-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20240704142319.728-1-jiangkunkun@huawei.com>
References: <20240704142319.728-1-jiangkunkun@huawei.com>
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

In all the vgic_its_save_*() functinos, it does not check whether
the data length is 8 bytes before calling vgic_write_guest_lock.
This patch add the check. To prevent the kernel from being blown up
when the fault occurs, KVM_BUG_ON() is used. And the other BUG_ON()'s
are replaced together.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40bb43f20bf3..344bd8c20f67 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2094,6 +2094,10 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
@@ -2246,6 +2250,10 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
@@ -2427,12 +2435,17 @@ static int vgic_its_save_cte(struct vgic_its *its,
 			     struct its_collection *collection,
 			     gpa_t gpa, int esz)
 {
+	struct kvm *kvm = its->dev->kvm;
 	u64 val;
 
 	val = (1ULL << KVM_ITS_CTE_VALID_SHIFT |
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
+
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
@@ -2449,7 +2462,9 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	u64 val;
 	int ret;
 
-	BUG_ON(esz > sizeof(val));
+	if (KVM_BUG_ON(esz != sizeof(val), kvm))
+		return -EINVAL;
+
 	ret = kvm_read_guest_lock(kvm, gpa, &val, esz);
 	if (ret)
 		return ret;
@@ -2513,7 +2528,9 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 * with valid bit unset
 	 */
 	val = 0;
-	BUG_ON(cte_esz > sizeof(val));
+	if (KVM_BUG_ON(cte_esz != sizeof(val), its->dev->kvm))
+		return -EINVAL;
+
 	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
-- 
2.27.0

