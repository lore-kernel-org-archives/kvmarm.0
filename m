Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5286518DF90
	for <kvmarm@lists.linux.dev>; Fri,  9 Aug 2024 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723193517; cv=none; b=D/YM0/mMsucl2GjhPb0cP/DqkreeG5wgIFPZ2RXPrhy/yEehojN0s4yr3sym556X9tIMQ2uBMB9AagVwbkp1MX1UkLgfKWU7Owzqz+kzcO3HYIOtok/VGekXJJofiG0vwMGLYQ4A3orDZEBpbDzwQ2KM6yUpe0dkLqCfZHPM6qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723193517; c=relaxed/simple;
	bh=sU/E4wH+yel4Jh1AAzSD0n9C6fLxtQCi4BrWa7rew2c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nmBaWLnl0/FRbcu65rQf2NZgnvghsPG60EIrgXjvlkK/tA3I44nekzJSYwQggL1FG8mqu4SYBmJjuJOyflNKVGkhx23NKItrH5yM45vpKDQI+FgBjzv2YiC6/4d6OCMLsbSzrIfSmwYmZv0+vV8Dxf71eQdFqe36nh2VScmT9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WgHb90Gv9z2Cm0L;
	Fri,  9 Aug 2024 16:47:01 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A8DB1A0188;
	Fri,  9 Aug 2024 16:51:46 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 9 Aug
 2024 16:51:45 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <james.morse@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <kvmarm@lists.linux.dev>
CC: <zhangzekun11@huawei.com>
Subject: [PATCH] KVM: arm64: vgic-v4: Use helper function irq_get_irq_data()
Date: Fri, 9 Aug 2024 16:39:06 +0800
Message-ID: <20240809083906.2534-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf500003.china.huawei.com (7.202.181.241)

The returned value of irq_to_desc() is only used to get the irq_data
by calling irq_desc_get_irq_data(), and there is a helper function
irq_get_irq_data() which has already provided the functionality. So,
use irq_get_irq_data() to make the code more simple.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 74a67ad87f29..2707ab0ab0a5 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -124,7 +124,6 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 	 */
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
-		struct irq_desc *desc;
 		unsigned long flags;
 		int ret;
 
@@ -138,8 +137,7 @@ static void vgic_v4_enable_vsgis(struct kvm_vcpu *vcpu)
 
 		/* Transfer the full irq state to the vPE */
 		vgic_v4_sync_sgi_config(vpe, irq);
-		desc = irq_to_desc(irq->host_irq);
-		ret = irq_domain_activate_irq(irq_desc_get_irq_data(desc),
+		ret = irq_domain_activate_irq(irq_get_irq_data(irq->host_irq),
 					      false);
 		if (!WARN_ON(ret)) {
 			/* Transfer pending state */
@@ -161,7 +159,6 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < VGIC_NR_SGIS; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, i);
-		struct irq_desc *desc;
 		unsigned long flags;
 		int ret;
 
@@ -176,8 +173,7 @@ static void vgic_v4_disable_vsgis(struct kvm_vcpu *vcpu)
 					    &irq->pending_latch);
 		WARN_ON(ret);
 
-		desc = irq_to_desc(irq->host_irq);
-		irq_domain_deactivate_irq(irq_desc_get_irq_data(desc));
+		irq_domain_deactivate_irq(irq_get_irq_data(irq->host_irq));
 	unlock:
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		vgic_put_irq(vcpu->kvm, irq);
-- 
2.17.1

