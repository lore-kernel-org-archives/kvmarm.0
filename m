Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D11B59A
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706260692; cv=none; b=mWwgAqBbFKnqMdWfLY/F2qfGBhs+2m05CMpU3735AmauZlcduCaN1D8UU23cavSpNauutUvYNEoVB0Lwq4+5AyO6sIGhG30vHj9p8Ssm/Yl0IB9ONfSl56JBPH6/0M6A0C725PsYQVcYpVJOoJscPpODp1WZcgZ1hv50c9ngGDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706260692; c=relaxed/simple;
	bh=4CIRkOMDtaRMqY+44dvSqf3umOCfrEUF1UOULw83lUM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LwkH1bNnX4dZaYg9ZKiOVWGmA+BVS/UPPuSrW3LmSoNCMkt9MtapvB0xO734m98pgy35iHrJAeqkY8HYJUn7KPRZgu6rysds0Qvwnq9CXppXsDsMXlK+03W4woazQuFZLvYGnfghFiD+H4+sxrpj+08LrjUNlOJ8HWtT89KfTVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TLsWS2S9gz1gxyG;
	Fri, 26 Jan 2024 17:16:20 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 20A67140416;
	Fri, 26 Jan 2024 17:18:06 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 17:18:05 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [PATCH] irqchip/gic-v4.1: Fix GICv4.1 doorbell affinity
Date: Fri, 26 Jan 2024 17:17:52 +0800
Message-ID: <20240126091752.1102-1-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)

commit dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour
of VMOVP") make an optimization, VMOVP can be skipped if moving
VPE to a cpu whose RD is sharing its VPE table with the current one.
But when skipping VMOVP, the affinity recorded in irq_data is still
updated. This causes the doorbell affinity recorfed in the irq_data
to be inconsistent with the actual.

In corner case, this may result in lost interrupts:
0. Each cpu die shares a VPE table and contains 32 CPUs
   die0(CPU0-31) die1(CPU32-63)...
1. VPE resides on CPU32, doorbell affinity to CPU32.
2. Move VPE to CPU33, skip VMOVP, doorbell still affinity to CPU32.
   The affinity recorded in irq_data is CPU33.
3. Manually offline CPU32 on the host side:
   'echo 0 > /sys/devices/system/cpu/cpu32/online'
4. Core code cannot move the doorbell affinity to CPU32, since the
   record in irq_data is CPU33.
5. Subsequent doorbell interrupts will be lost.

So affinity recoreded in irq_data should not be updated when skipping
VMOVP.

Fixes: dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d097001c1e3e..4b1dbb697959 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3850,8 +3850,9 @@ static int its_vpe_set_affinity(struct irq_data *d,
 	its_send_vmovp(vpe);
 	its_vpe_db_proxy_move(vpe, from, cpu);
 
-out:
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
+
+out:
 	vpe_to_cpuid_unlock(vpe, flags);
 
 	return IRQ_SET_MASK_OK_DONE;
-- 
2.33.0

