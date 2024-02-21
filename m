Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1A73C46B
	for <kvmarm@lists.linux.dev>; Wed, 21 Feb 2024 05:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708494215; cv=none; b=uz4laUxpQONH/vsXi8fgTRYsTd297HmjTm6KOTYOg5iXmezYG7JNlGwEdgBzdzRYom4MkX6peHTZ6HPu7v0haU4Xr2d9FsobyibStnZEvBUQEUvQRlhVy8E5rriHb0IrPYW+C2ySYpZ+lhFbcCqv4wkrOQenV8TR8pDGd1DPer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708494215; c=relaxed/simple;
	bh=iPMx6to6nitv27V003CljDT9TCjGzeZ9T5PREHKTqXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1nNYgTX7iawtHklM1McCvSnuuRPf7V4kCinMjdCbinlHOTybJ+3VINq6ryu0xLK7uTNbxsRStm+9TCiFfo2ucq5Iangpw9TA0YtU0/jpDgPimcXfSskyTg6ZLXHbJELK6TVqu2sbCwv8NKWoqqkMxmQ+9uhlYsYUSXqNHiGMuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sdaejefD; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sdaejefD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708494212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2vP8fjlFG48ofYu0phwr6P5tTp39+9IxC+FJcXQ4f8=;
	b=sdaejefD5Jik4CTUWmfbhv0AYU/Q05Y8Op4W9bykUArkL/dz+jcAyW8mywmef8uZMcnfDU
	UIRvZ/bQ86t1OfXpl0cxcOBySejSehv3d6tkIZpwMvuPSuTYx748F88BSGe7BdJWFS/uzi
	AIMGLQHhX8DNtbIksD7DZa4YvK5oWhs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 07/10] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
Date: Wed, 21 Feb 2024 05:42:50 +0000
Message-ID: <20240221054253.3848076-8-oliver.upton@linux.dev>
In-Reply-To: <20240221054253.3848076-1-oliver.upton@linux.dev>
References: <20240221054253.3848076-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Free the vgic_irq structs in an RCU-safe manner to allow reads of the
LPI configuration data to happen in parallel with the release of LPIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 2 +-
 include/kvm/arm_vgic.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 15dbd17b3a9e..3fedc58e663a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -125,7 +125,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	xa_erase(&dist->lpi_xa, irq->intid);
 	atomic_dec(&dist->lpi_count);
 
-	kfree(irq);
+	kfree_rcu(irq, rcu);
 }
 
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 71e9d719533b..47035946648e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -117,6 +117,7 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
+	struct rcu_head rcu;
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
-- 
2.44.0.rc0.258.g7320e95886-goog

