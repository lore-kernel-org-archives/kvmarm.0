Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DB9136662
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108933; cv=none; b=iltEbbjTnbXxV4V0V2UNWjg0l6YYmiksQc0cxG8bhQyYxigMfGU2L8jdnaHNYJTgazlqYchGZQQZulMxw8bPmCQhcFhpP+osVIeLB1pDkyMp2G9R0u0OqFaCwJCZgi87ijEfOWWYXkjzB1opQ3xyss1fwk7OjL5nr4bjdS87CpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108933; c=relaxed/simple;
	bh=Vcvs9scbETBbx3K0EOYQAZ7h+k9GiCx1VVK7pwIOKmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msWcqxTfSGDWf2h7320PKec6bl6lRtpWrcQjRwRUDdif+WHSADi9CS/358aM+b9dftrCU88vL3wD4kMk0VvXYMxJlcfDGUI5k7i5P2BuDjXsn+rxFY9gvGflF61g/c1Omj2mARgQMNxEuvO43hFqX+g+p9zhxupqjGEDOU9cayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fHkOMxWW; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fHkOMxWW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1JR94TUCmjSuW67hdoXXOUBEMTu1g9M0PtI4CuvL0o=;
	b=fHkOMxWWKme5F7VJkNfW+SwbWdAz9GsVCnFpRhADCScBrrGU7MQrfxUVI2JE/0KBwZ94j5
	dbg5VQW4Mm7l8ZMpBNR94yRYY9lIwtkG/t0ffTRAJ+FMAiB58P1pqTQPAjneWt/VoxOxb4
	rbgzSMMM9/TtYZYQN8d6MeanbSV03Po=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 02/10] KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
Date: Fri, 16 Feb 2024 18:41:45 +0000
Message-ID: <20240216184153.2714504-3-oliver.upton@linux.dev>
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
2.44.0.rc0.258.g7320e95886-goog

