Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DD412D1F1
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748029658; cv=none; b=VXIAoqn7cR8EZq+5k4YL5bTK4d3B9PXlTLFQgqQHgtOLvdc16apRlfqlicPsUbJOq/J92jU9M7WukQOV7a2Xk+eCdfL2Z7qCSS2CTbs3F5Q7a7SaBG0BKDxwkWEWBgG5EQqLgFSpJo1sGu7D8bn5C3ooCU7jVsXp+q7O7focaZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748029658; c=relaxed/simple;
	bh=AiQZ5Y/+sCya+l1XB6lbBJl38PyKFZG0o0drT0eRQRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TO5xvzAOf8nSCULMofWDyrQ+5Qn3YCaeYJhAViTuJPIquenz+KUDbC9IIr4iKlbAMRmxYM6PWwzYlV67AJjt6FGl3spWGYmLEM7A+UuWPBtz10DCtHyIWgRtaQzZa00FBmQwZwyVMS2Ae4rHF3zkXNtnZGR3POwRvk/LP7NKyb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dRa5j5mG; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dRa5j5mG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748029653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sm6+AAbgzan07rqyu/pLMutzopswt3vrn8iFlTBImGs=;
	b=dRa5j5mG36GlkzQUPrbzLF15Il6NqZi2fJEPZTylIQmOfmbDDjbd64ajdH0/rnPzxTf7X7
	F1RH0vZylT7W8YVKJDx1tpt4HYgXYb+DO6fgTwuLyGHozBcZjXDEPAdAC/sCvaJbGKKklU
	j4/tllmkxd9jaM4eh+Bmf34HQyDwicY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 1/5] KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
Date: Fri, 23 May 2025 12:47:18 -0700
Message-Id: <20250523194722.4066715-2-oliver.upton@linux.dev>
In-Reply-To: <20250523194722.4066715-1-oliver.upton@linux.dev>
References: <20250523194722.4066715-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The locking dance is about to get more interesting, switch the its_lock
over to a lock guard to make it a bit easier to handle.

Tested-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c7de6154627c..8b25e7650998 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -444,7 +444,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	if (IS_ERR(its))
 		return 0;
 
-	mutex_lock(&its->its_lock);
+	guard(mutex)(&its->its_lock);
 
 	/*
 	 * Perform the actual DevID/EventID -> LPI translation.
@@ -455,11 +455,11 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	 */
 	if (vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
 				 irq_entry->msi.data, &irq))
-		goto out;
+		return 0;
 
 	/* Silently exit if the vLPI is already mapped */
 	if (irq->hw)
-		goto out;
+		return 0;
 
 	/*
 	 * Emit the mapping request. If it fails, the ITS probably
@@ -479,7 +479,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 
 	ret = its_map_vlpi(virq, &map);
 	if (ret)
-		goto out;
+		return ret;
 
 	irq->hw		= true;
 	irq->host_irq	= virq;
@@ -503,8 +503,6 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	}
 
-out:
-	mutex_unlock(&its->its_lock);
 	return ret;
 }
 
-- 
2.39.5

