Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F041AEFF7
	for <kvmarm@lists.linux.dev>; Thu,  4 Jul 2024 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720103026; cv=none; b=HIkee/IPUR0FOEf6NczzMuTLv6n2wJeyDVEeoyk8FxRok0Uoqcw4OBjnU3l5p63sy8tvXjL4YwC5dsfvLYBofF9yZ5KdrEv7IGlytjLL1Xu5827ONPxASCi/VQAbSn2RTp9Rmgu0z8a/U2Uu90vQ98yDTxO88gVrQz4pjwcq9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720103026; c=relaxed/simple;
	bh=1adZSrEoBilGsOJm4ucZb0WooveMGQFq+58uaoAT7NQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuQKty6MHupVWD7RGO2HH+v7Tl2kRdEQWiWI5l18t+xL33syoVM5f8RC24ili9B8wiJ0Jms3cFcJp+1ChVaYX0mSR4WCbLURmUHuagGWQRH4H62nPkcFubHtIZ0PXW3FwbGxwy+iZ76kdnepBhCed+ggLeO2dZomG5WrI4nMHqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WFJlv0QPWznZCg;
	Thu,  4 Jul 2024 22:23:23 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id A4072180087;
	Thu,  4 Jul 2024 22:23:41 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 22:23:40 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Auger <eauger@redhat.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>,
	<lishusen2@huawei.com>, <tangnianyao@huawei.com>
Subject: [PATCH v2 2/3] KVM: arm64: vgic-its: Clear dte when mapd unmaps a device
Date: Thu, 4 Jul 2024 22:23:18 +0800
Message-ID: <20240704142319.728-3-jiangkunkun@huawei.com>
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

vgic_its_save_device_tables will traverse its->device_list to
save dte for each device. vgic_its_restore_device_tables will
traverse each entry of device table and check if it is valid.
Restore if valid.

But when mapd unmaps a devices, we do not invalidate the
corresponding dte. In the scenario of continuous save
and restore, there may be a situation where a device's dte
is not saved but is restored. This is unreasonable and may
cause restore to fail. This patch clears the corresponding
dte when mapd unmaps a device.

Co-developed-by: Shusen Li <lishusen2@huawei.com>
Singed-off-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 344bd8c20f67..223a5f1d6a3d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * The spec does not say whether unmapping a not-mapped device
 	 * is an error, so we are done in any case.
 	 */
-	if (!valid)
+	if (!valid) {
+		struct kvm *kvm = its->dev->kvm;
+		int dte_esz = vgic_its_get_abi(its)->dte_esz;
+		u64 val = 0;
+
+		if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+			return -EINVAL;
+
+		vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
 		return 0;
+	}
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
-- 
2.27.0

