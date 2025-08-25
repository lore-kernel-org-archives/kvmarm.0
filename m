Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B4418FC91
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756090055; cv=none; b=POh2WxDk06xqstY+gKartDcjefikQVb/hMg7mdFESOIMKgWLh492/Hh4etQv5OkeQlZMdwJJbgz9jw4vKngNwnEYlFgMze1Eth4TC1C1zi/FwFiYKACsufeH71j761SOWAU1720Bi/zFmAbGbKxj7ilrfbSDWFhlgmT2xZ28OfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756090055; c=relaxed/simple;
	bh=buT62QEK5O6uKshC//NhVeb15meow7iSinylZM3sB5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYS5lqN16+L+j5c001iorwDkJ9nVsg0E/yLzWCXblJeNga2hnUuej66cNr9cK/DPseEbYzjU4PxbRZijge7huwgmVU4SUTpESUIs1b356TSuLU8D81WDsggXTnk88VasJMuudT47MnsEmJuxfAUUPJZAxD/tAegKUhnKHbjiKLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9FW60gDVz2VRKL;
	Mon, 25 Aug 2025 10:44:34 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2995B14027A;
	Mon, 25 Aug 2025 10:47:29 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 10:47:29 +0800
Received: from huawei.com (10.90.31.46) by kwepemq200004.china.huawei.com
 (7.202.195.237) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 10:47:28 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <tangnianyao@huawei.com>,
	<wangwudi@hisilicon.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 1/4] KVM: arm64: Allow userspace to write GICD_TYPER.num_LPIs
Date: Mon, 25 Aug 2025 10:39:51 +0800
Message-ID: <20250825023954.3516381-2-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
References: <20250825023954.3516381-1-wangzhou1@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Allow userspace to write GICD_TYPER.num_LPIs. If GICD_TYPER.num_LPIs is
0, number of LPIs is indicated by GICD_TYPER.IDbits, so the default
value of GICD_TYPER.num_LPIs is still set as 0.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  2 ++
 arch/arm64/kvm/vgic/vgic-its.c        |  9 +++++++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  1 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 16 ++++++++++++++++
 include/kvm/arm_vgic.h                |  1 +
 include/linux/irqchip/arm-gic-v3.h    |  1 +
 6 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1e680ad6e863..46468cb97536 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -389,6 +389,7 @@ int vgic_init(struct kvm *kvm)
 	/* freeze the number of spis */
 	if (!dist->nr_spis)
 		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+	dist->nr_lpis = 0;
 
 	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
 	if (ret)
@@ -428,6 +429,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	kfree(dist->spis);
 	dist->spis = NULL;
 	dist->nr_spis = 0;
+	dist->nr_lpis = 0;
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7368c13f16b7..d8ee617cfa6f 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -377,9 +377,14 @@ static void update_affinity_collection(struct kvm *kvm, struct vgic_its *its,
 	}
 }
 
-static u32 max_lpis_propbaser(u64 propbaser)
+static u32 max_lpis_propbaser(struct vgic_dist *dist)
 {
+	u64 propbaser = dist->propbaser;
 	int nr_idbits = (propbaser & 0x1f) + 1;
+	int nr_lpis = dist->nr_lpis;
+
+	if (nr_lpis)
+		return min(8192 + nr_lpis, 1 << nr_idbits);
 
 	return 1U << min(nr_idbits, INTERRUPT_ID_BITS_ITS);
 }
@@ -1047,7 +1052,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	else
 		lpi_nr = event_id;
 	if (lpi_nr < GIC_LPI_OFFSET ||
-	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
+	    lpi_nr >= max_lpis_propbaser(&kvm->arch.vgic))
 		return E_ITS_MAPTI_PHYSICALID_OOR;
 
 	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 3d1a776b716d..f4268b60c4dd 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -514,6 +514,7 @@ static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
 		return false;
 
 	switch (attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK) {
+	case GICD_TYPER:
 	case GICD_IIDR:
 	case GICD_TYPER2:
 		return true;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a3ef185209e9..3a53b63f7b20 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -90,6 +90,8 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		if (vgic_has_its(vcpu->kvm)) {
 			value |= (INTERRUPT_ID_BITS_ITS - 1) << 19;
 			value |= GICD_TYPER_LPIS;
+			if (vgic->nr_lpis)
+				value |= (ilog2(vgic->nr_lpis) - 1) << 11;
 		} else {
 			value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
 		}
@@ -167,6 +169,20 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 	u32 reg;
 
 	switch (addr & 0x0c) {
+	case GICD_TYPER:
+		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
+
+		if (reg == val)
+			return 0;
+		if (vgic_initialized(vcpu->kvm))
+			return -EBUSY;
+		if ((reg ^ val) & ~GICD_TYPER_NUM_LPIS_MASK)
+			return -EINVAL;
+		if (GICD_TYPER_NUM_LPIS(val) > INTERRUPT_ID_BITS_ITS)
+			return -EINVAL;
+
+		dist->nr_lpis = 2 ^ GICD_TYPER_NUM_LPIS(val);
+		return 0;
 	case GICD_TYPER2:
 		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 404883c7af6e..774bfd008230 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -303,6 +303,7 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+	int			nr_lpis;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 70c0948f978e..517d9f2edc44 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -85,6 +85,7 @@
 #define GICD_TYPER_ESPI			(1U << 8)
 
 #define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
+#define GICD_TYPER_NUM_LPIS_MASK	GENMASK(15, 11)
 #define GICD_TYPER_NUM_LPIS(typer)	((((typer) >> 11) & 0x1f) + 1)
 #define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
 #define GICD_TYPER_ESPIS(typer)						\
-- 
2.33.0

