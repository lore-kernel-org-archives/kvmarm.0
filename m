Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B08A1350CB
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129371; cv=none; b=Efp8oRWCFD8NHq5GOgoDie0PXRY8lng6iklzH+sG53Yw8m00TXnjCEP+OOmfNrlnKJSxKGBY1lzZirY4t1n+VISLxO+wfT1idZW4g4krE4NtWgvZ0WEK5ib14FxsC/W68+8VASr1Fm1mobPp6wnKZ8NchrfueYcXyJxytgaZvfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129371; c=relaxed/simple;
	bh=s/7p2y0MuJJ2yjCghMin92mq2VbvJX2KFI0tYjDUUaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgZy8Q34w+bBzGd1Twpj7J0W5WuUTMun+a+9khGWsLXtVJ1Hr1aCm2eG7aTxFufh8A6U+W0EZUfOF/NdG+APYZrWeONTv8nDjoIjB7glUPsukyxoBHBPQ3+XXVBTtXLNNxTfqkOjsXInsXQJKFeZd8RPIEzUwbSxW//oOvE+qEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V/OJnTnl; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V/OJnTnl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBBQZKa3HE+jnKMX9AT3xH561Qb4a05EumcmqYcHZtQ=;
	b=V/OJnTnlZZInSqrkwJ+S5kImPcNYXsDJnD7LwwwmFMyZqHTTkClxwmvA4aVBNfXdzX/AjM
	NwUpC5bi++ja91vcM/MWbG4sCWP3fra3DMqjoQlb7SLwGjA2TL9CTeIqXEb3qC0dQlzIZn
	2tIEN4WDY4rM/Lx4XB0lAS8HtEuT80M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 02/15] KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
Date: Wed, 24 Jan 2024 20:48:56 +0000
Message-ID: <20240124204909.105952-3-oliver.upton@linux.dev>
In-Reply-To: <20240124204909.105952-1-oliver.upton@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Iterating over the LPI linked-list is less than ideal when the desired
index is already known. Use the INTID to index the LPI xarray instead.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c126014f8395..d90c42ff051d 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -54,8 +54,9 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  */
 
 /*
- * Iterate over the VM's list of mapped LPIs to find the one with a
- * matching interrupt ID and return a reference to the IRQ structure.
+ * Index the VM's xarray of mapped LPIs and return a reference to the IRQ
+ * structure. The caller is expected to call vgic_put_irq() later once it's
+ * finished with the IRQ.
  */
 static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 {
@@ -65,20 +66,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 
 	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
-		if (irq->intid != intid)
-			continue;
-
-		/*
-		 * This increases the refcount, the caller is expected to
-		 * call vgic_put_irq() later once it's finished with the IRQ.
-		 */
+	irq = xa_load(&dist->lpi_xa, intid);
+	if (irq)
 		vgic_get_irq_kref(irq);
-		goto out_unlock;
-	}
-	irq = NULL;
 
-out_unlock:
 	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 
 	return irq;
-- 
2.43.0.429.g432eaa2c6b-goog

