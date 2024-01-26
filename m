Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3E17582
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 10:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706265046; cv=none; b=q4iSA6Z36EoW9wq+NoYvi1YQqqI+0lCSuok9LDuTwmpwbp6SS6dX0lMVq+XHeBVKvbf+pEXk30NiduYV8de/pTi4bq9usJobDGWYsNlF0TH0b41Nuf/bL74RVl1DT9sx5EkfxYrNdVmoyt7o0Zb9zDS3eCabOCMTj1BPiL+MSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706265046; c=relaxed/simple;
	bh=kvyZvQJT9YqRB6mfGc1avhq4hI6j5j1DpZ/v++2h/FU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sg2nBhcdnnjlwn4BQRgeQnuOMDiUTPy62RVYcdU3bnBRKWtrVZd555QOE9yTR/xww/dJgFn71hi+OZ6oD/p5MvIDazeGhAx6SHEzziNw94Ft7J/HEawLatYNDe6Etm22Cg8Vz+3O2Y02X4k80eEa36xHu0SRidELyp4DoqGJP4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TLv812XGrz18LjV;
	Fri, 26 Jan 2024 18:29:37 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AC3B180073;
	Fri, 26 Jan 2024 18:30:42 +0800 (CST)
Received: from DESKTOP-6NKE0BC.china.huawei.com (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 18:30:41 +0800
From: Kunkun Jiang <jiangkunkun@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [PATCH v2 2/2] irqchip/gic-v4.1: Fix skipping VMOVP in cpu offline scenario
Date: Fri, 26 Jan 2024 18:30:12 +0800
Message-ID: <20240126103012.1020-3-jiangkunkun@huawei.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20240126103012.1020-1-jiangkunkun@huawei.com>
References: <20240126103012.1020-1-jiangkunkun@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600007.china.huawei.com (7.193.23.208)

commit dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour
of VMOVP") make an optimization, VMOVP can be skipped if moving
VPE to a cpu whose RD is sharing its VPE table with the current one.

In the cpu offline scenario, the mask_val is the entire cpu range,
except for the offline cpu. Therefore, the first cpu is CPU0. In
corner case, this may result in lost interrupts:
0. Each cpu die shares a VPE table and contains 32 CPUs
   die0(CPU0-31) die1(CPU32-63)...
1. VPE resides on CPU32, doorbell affinity to CPU32.
2. Move VPE to CPU16, doorbell affinity to CPU16.
3. Manually offline CPU16 on the host side:
   'echo 0 > /sys/devices/system/cpu/cpu16/online'
4. VMOVP will be skipped.
5. Subsequent doorbell interrupts will be lost.

So VMOVP cannot be skipped when the affinity CPU is not in mask_val.

Fixes: dd3f050a216e ("irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4b1dbb697959..bfb922f16bc6 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3817,7 +3817,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
 				bool force)
 {
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
-	int from, cpu = cpumask_first(mask_val);
+	int cur, from, cpu = cpumask_first(mask_val);
 	unsigned long flags;
 
 	/*
@@ -3839,11 +3839,13 @@ static int its_vpe_set_affinity(struct irq_data *d,
 
 	vpe->col_idx = cpu;
 
+	cur = cpumask_first(irq_data_get_effective_affinity_mask(d));
 	/*
 	 * GICv4.1 allows us to skip VMOVP if moving to a cpu whose RD
 	 * is sharing its VPE table with the current one.
 	 */
 	if (gic_data_rdist_cpu(cpu)->vpe_table_mask &&
+	    cpumask_test_cpu(cur, mask_val) &&
 	    cpumask_test_cpu(from, gic_data_rdist_cpu(cpu)->vpe_table_mask))
 		goto out;
 
-- 
2.33.0

