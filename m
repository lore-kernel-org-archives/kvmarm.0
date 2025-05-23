Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD13295535
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748016506; cv=none; b=X9Zlnq0KNM7JnQiCpJOvmfcH8NulBnwiHcvpb7R2jzzklKPB//spaCaoNc/vQXqHH35BgckijQmTS+XtZzTVPGs/DU8piPTwQ0IFVzvO6larSN0GrMzhHnzwBmOtOu+81k/Dh2i2C6qPoylm/wEDrR/22dzQHJHJq2WIciuZXbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748016506; c=relaxed/simple;
	bh=UXMxej6UjUWsaGprJYjDvLC7ZLglGp3E0FgN2qmn7Eg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GskPkDSXagR2jMgtDO5kNKB7yop/V6iplr/ipwoVcNvH8X8iBAoY298MKcpVvtDxgCg9tszD8CNV69f4UMmzc4BWLzGcnHYVRlb1rNoDdxeSC5O+qujmsNLJ5bXW9/Dptb0M1SgBev2ve05mWv2I/R0ATGv9PmUeic9Jqdrhqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LdyXe1UT; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LdyXe1UT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748016502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MHXOW1/WC5eV/AwPtZWBKgjz7pB7XsFcfgDpmvXaa2Q=;
	b=LdyXe1UTy4VY+bMxYNdsFVq2BZxgHkBwX8vXluFbdHpbEpshkyuhSGYwpMtt7eu/YklYql
	Cj9u3XYrLMfEksPgEGg3Or9LlEbBHIYPdWRLlKHsar+aeFTXzSsU4qhSyr4OJPW9Kch98w
	wZlu8Xcti1UxPGxS1zYDH+PnSs7sxbA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sweet Tea Dorminy <sweettea@google.com>
Subject: [PATCH 1/5] KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
Date: Fri, 23 May 2025 09:08:06 -0700
Message-Id: <20250523160810.4049313-2-oliver.upton@linux.dev>
In-Reply-To: <20250523160810.4049313-1-oliver.upton@linux.dev>
References: <20250523160810.4049313-1-oliver.upton@linux.dev>
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

Tested-by: Sweet Tea Dorminy <sweettea@google.com>
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

