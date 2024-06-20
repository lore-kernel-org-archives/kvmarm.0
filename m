Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842841AB34A
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718888842; cv=none; b=JMF0DYDOFRA1F2p76J7/+4CzVJVrGU10BolY3rp5T/c3HEovAzYdJYwJYDNvy8XkCdJ8Vy2Pivvd1eEYJSzMZZzzcCWHegmpku+CAPYBXmueCTMgA/rgYYMFjfT3gJLUudHhXBh1mM0p9PukFNB8JBJC29J0ZX8MjzEwl+DT6q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718888842; c=relaxed/simple;
	bh=uTOnmFKGBe+ENXecNJrs8a/MI+HBrKpS9PjMKGzeiXc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nR8xQYyxFOpxP3SJlAi+6qG0NMa7hFynd4gPqpnLVdcn1vg1AwrQNiVAkDsCBHQFotNWlbKL7m4ArnE7krOzRY8mCFDf5M4Rf9Q2TMP4AG7mDQnWTusFOP/99X6YcHONkMRD29W9DtAXCeY+5RigRo3/ZbFNDY6xqAlkFU+b2Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4W4gfP4bL6z1ytV1;
	Thu, 20 Jun 2024 21:03:41 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 264821A016C;
	Thu, 20 Jun 2024 21:07:15 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 21:07:13 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: vgic-its: Clear ite when discard frees an ite
Date: Thu, 20 Jun 2024 21:06:50 +0800
Message-ID: <20240620130650.1279-4-jiangkunkun@huawei.com>
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

When discard frees an ite, we do not invalidate the
corresponding ite. In the scenario of continuous save and
restore, there may be a situation where an ite is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ite when discard
frees a ite.

Link: https://lore.kernel.org/kvmarm/8f9d74fc-f9d9-43ac-a387-91ff804cfaf1@redhat.com/
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 8e11859ff803..a10516ff760a 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -782,6 +782,10 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
+		u64 val = 0;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,6 +794,9 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
+
+		BUG_ON(ite_esz > sizeof(val));
+		vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 		return 0;
 	}
 
-- 
2.33.0

