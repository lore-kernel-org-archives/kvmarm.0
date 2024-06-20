Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E311ABCD1
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 13:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888839; cv=none; b=lx+oRRYZf11uZhsHWn9o+/zauRaIBxIAythRA0iM5O/TmL4OO5CvfzjNoaSG9jQJ+Ynm9jFF1QXOca8M1Re2uz/vbJhFxDH9WIdapMkJ685HDwbNxkH8f58e+ZcMQp+apL7Kwa6pHVTWuihDlMAwasv5XGR+ryeJ8zyCWVNApIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888839; c=relaxed/simple;
	bh=qXgg4YnFscdDfM5Mc1C396w0pRm+/d+r1MBxx7Xl75c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6aApygG2CDDD1n5HrPEvZwyv4dJfpMbwzLR4QqToiOX5OcvL4POvDcjg355EX8cKea/cotU+3ZFjZrPnN4ONQDmIn6vMOIXxwuSS2V0SFYkBdIVVkE48oWLHt2f6l2OdPYrYhvhUVLCzzCEB9LdshexWBTnIBoqGiRrDiZ1mdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4W4gdX3y3MzwTtF;
	Thu, 20 Jun 2024 21:02:56 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 08B2C18007E;
	Thu, 20 Jun 2024 21:07:13 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 21:07:11 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*
Date: Thu, 20 Jun 2024 21:06:48 +0800
Message-ID: <20240620130650.1279-2-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20240620130650.1279-1-jiangkunkun@huawei.com>
References: <20240620130650.1279-1-jiangkunkun@huawei.com>
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

In all the vgic_its_save_*() functinos, it does not check
whether the data length is larger than 8 bytes before
calling vgic_write_guest_lock. This patch add the check.

Link: https://lore.kernel.org/kvmarm/86v82ckimh.wl-maz@kernel.org/
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40bb43f20bf3..060605fba3b6 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2094,6 +2094,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
+	BUG_ON(ite_esz > sizeof(val));
 	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
@@ -2246,6 +2247,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
+	BUG_ON(dte_esz > sizeof(dte_esz));
 	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
@@ -2433,6 +2435,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
+	BUG_ON(esz > sizeof(val));
 	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
-- 
2.33.0

