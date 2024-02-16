Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A61350E8
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108942; cv=none; b=afTW+Dx7MYXbrn0msvV/DQp3Hwz6zZrOFbcMm++5Itjtl/2BKxKrqjodwEHmslBpW3/qrymYZMdwl0CmVyS0+mb+oUaMsLyhKzs7EBlYkZHLrNpWiHQjjUTlBBOlX7yy947AOTJVgJje21dBTc9W3S2y8JxVOdJdYtkutXLzzko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108942; c=relaxed/simple;
	bh=vtekqhGgtjmqisr8NulSQvgtjNS1TOilwFJMKeBnMg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0y10LBZNc4Zyz2hhFJzJiB3nfzz/HX7IbRYI3+RC2DUfvjIyEtYu5MrZRxpqzpbjl9vZcFvE3LZyBvdifl60l83Z+vDDlnl5phPfe52EtzvEJArUOzhsBzApJxp60ni1FINx9W/AYIumyOmn+PUgQd5vuDmiKpqmd9SEAMtxlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B8h55U4v; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B8h55U4v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z9GN6WeBnSe+DXw8hn3rK0c8U+qc433lF4ad1LOLZiY=;
	b=B8h55U4vyFlSMWnLw3WokyuHHqf8SDrZYLk+F5/4/VmqI7gxyrbjsPcP5qiY84KN4ccDQL
	F+qnE61n5c9PbbeXv8H0A5xjvpRrfV9ItrPXnR+conGlKE00t8cEPfgeS7GGbp9ME7If5Q
	8kpOuHuA8ql4HXQg4tlW5W9asI4smsE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 07/10] KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
Date: Fri, 16 Feb 2024 18:41:50 +0000
Message-ID: <20240216184153.2714504-8-oliver.upton@linux.dev>
In-Reply-To: <20240216184153.2714504-1-oliver.upton@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
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
index 5988d162b765..be3ed4c5e1fa 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -124,7 +124,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
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

