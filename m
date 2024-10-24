Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7C157A72
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 05:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729746425; cv=none; b=m1aXmQotNt6zShf5z8lF6wjOmjnYLZMinF+NcOdOKd1EB2YbRll/BfUy2Nw+AJljPZAxmFSu2X4ZkZNBO+sl4NuA1MnBLXzu4QATqR1ep2RQNm/ctTgE6zVgz6EyJARrhooFNQP2zLsv/gQu2G42yrze/GOgj2xUMt45y7f72iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729746425; c=relaxed/simple;
	bh=Y5+wMPPqVQmayEdNdJW6qQEM1DVHG6HDylFxeu+dK9c=;
	h=Message-ID:Date:MIME-Version:CC:From:Subject:To:Content-Type; b=b/N4aCuk+cgW+WFux0qVJOVreIM3sECkHeh2ghvg2D+hcv8CL9kSoU2HbMhAwJivzGpu52ysSdoEysGjhLQ1z38HJK+1iOf0qY3sB4dIp2wDMI6jUYxw6O0yAPTvT6KvvjI++z6Z6rDe0F3gAIWyoSEeaqL/IRwO5QvpmfnBA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XYv4b0FcMz1SCyJ;
	Thu, 24 Oct 2024 13:05:35 +0800 (CST)
Received: from kwepemf500015.china.huawei.com (unknown [7.202.181.2])
	by mail.maildlp.com (Postfix) with ESMTPS id BC397180043;
	Thu, 24 Oct 2024 13:06:59 +0800 (CST)
Received: from [10.174.178.37] (10.174.178.37) by
 kwepemf500015.china.huawei.com (7.202.181.2) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 24 Oct 2024 13:06:58 +0800
Message-ID: <bb4aeb68-c77b-4071-bca5-d129a1c5f6f3@huawei.com>
Date: Thu, 24 Oct 2024 13:06:58 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>, <yuzenghui@huawei.com>, <wangyanan55@huawei.com>,
	<jiangkunkun@huawei.com>, <jiaqingtong@huawei.com>
From: Zhiqiang Ni <nizhiqiang1@huawei.com>
Subject: [bug report] KVM: arm64: vgic-its: Performance degradation on GICv3
 LPI injection
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf500015.china.huawei.com (7.202.181.2)

Hi all,

I found a performance degradation on GICv3 LPI injection after this
commit ad362fe07fecf0aba839ff2cc59a3617bd42c33f(KVM: arm64: vgic-its:
Avoid potential UAF in LPI translation cache).

In my testcase, the vm's configuration is 60 VCPU 120G RAM with a
32-queue NIC and the kernel version is 5.10. The number of new TCP
connections per second changed from 150,000 to 50,000 after this
patch, with the %sys of cpu changed from 15% to 85%.

From the ftrace, I found that the duration of vgic_put_irq() is
13.320 us, which may be the reason for the performance degradation.

The call stack looks like below:
    kvm_arch_set_irq_inatomic()
      vgic_has_its();
      vgic_its_inject_cached_translation()
        vgic_its_check_cache()
        vgic_queue_irq_unlock()
        vgic_put_irq()

So, I tried to modify the code like below and I found the performance
degradation is gone. Is this a good idea?

From 2bd98f8a2cc02a17423ced36e07f7bb3c7e044af Mon Sep 17 00:00:00 2001
From: Zhiqiang Ni <nizhiqiang1@huawei.com>
Date: Thu, 24 Oct 2024 12:29:28 +0800
Subject: [PATCH] KVM: arm64: vgic-its: Avoid vgic_put_irq in LPI translation
 cache

---
 arch/arm64/kvm/vgic/vgic-its.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 93c0365cd..0efabe555 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -579,24 +579,6 @@ static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 	return NULL;
 }

-static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
-					     u32 devid, u32 eventid)
-{
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_irq *irq;
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
-
-	irq = __vgic_its_check_cache(dist, db, devid, eventid);
-	if (irq)
-		vgic_get_irq_kref(irq);
-
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
-
-	return irq;
-}
-
 static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
@@ -759,18 +741,24 @@ static int vgic_its_trigger_msi(struct kvm *kvm, struct vgic_its *its,
 int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 {
 	struct vgic_irq *irq;
-	unsigned long flags;
+	unsigned long flags, flags2;
 	phys_addr_t db;
+	struct vgic_dist *dist = &kvm->arch.vgic;

 	db = (u64)msi->address_hi << 32 | msi->address_lo;
-	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
-	if (!irq)
+	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags2);
+	irq = __vgic_its_check_cache(dist, db, msi->devid, msi->data);
+
+	if (!irq) {
+		raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags2);
 		return -EWOULDBLOCK;
+	}

 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 	irq->pending_latch = true;
 	vgic_queue_irq_unlock(kvm, irq, flags);
-	vgic_put_irq(kvm, irq);
+
+	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags2);

 	return 0;
 }
-- 
2.33.0

Thanks,
Zhiqiang Ni
