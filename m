Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295D42BCF7
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 09:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816806; cv=none; b=UwgBKME13ezuzczqyXPOU2h8KxjhsHzf/HSkk44zxJ2v8htrJALm027GKnqGSFGT96TRH/ns2hMf5AOfrdcqmT7lRjrrSCLZypcK4enOVmCbVkBQCrMJH4kNms55GXXVd62fn7e0pqtrmDb5IjEAlpuUvxKb18yn1rVo2eHJcc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816806; c=relaxed/simple;
	bh=x1S98sHSYhxkabprmCbrd2K4IpsVQD88YKDf/wPFgQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKKOJPr/EdfwXxrR3bzdguk7KCWHWDNczVKT4Wa+SzIZ1yyxRcJI5kVrZlIGb2cHrYKxp2ix/rQ9Y2N25b5qougflG6z493MBJg568I8X1trhk+5rhaVz3n0L8LgbcnF2b+c5Uv+T2B4Nl5UNptchygtxZnvGHDvWclqOl+ohks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vMfTEbmx; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vMfTEbmx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d0pU/1urqxYilVj53Ip1KYtHI35wj+PNtuLJSjy+uYo=;
	b=vMfTEbmx3n8BntxZAxz615n3jMiuLC40HjUl/AUUTd+3ex7zjkcBSO+0xpSIr4MS6fyp6m
	dsXQMZ5FGNAts1rcmS2qQIZvdQn+8psj5XEPX6TVwyOUjVyx2/eDof6AD+yywnBWA3Gvhd
	ZtEh0zYClbkXgAGauoANm3irPT7JgbY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 06/23] KVM: arm64: vgic: Get rid of the LPI linked-list
Date: Tue, 13 Feb 2024 09:32:43 +0000
Message-ID: <20240213093250.3960069-7-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

All readers of LPI configuration have been transitioned to use the LPI
xarray. Get rid of the linked-list altogether.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c | 1 -
 arch/arm64/kvm/vgic/vgic-its.c  | 8 ++------
 arch/arm64/kvm/vgic/vgic.c      | 1 -
 include/kvm/arm_vgic.h          | 2 --
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 411719053107..e25672d6e846 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -53,7 +53,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
 	xa_init_flags(&dist->lpi_xa, XA_FLAGS_LOCK_IRQ);
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index aefe0794b71c..c68164d6cba0 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -59,7 +59,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		return ERR_PTR(ret);
 	}
 
-	INIT_LIST_HEAD(&irq->lpi_list);
 	INIT_LIST_HEAD(&irq->ap_list);
 	raw_spin_lock_init(&irq->irq_lock);
 
@@ -75,10 +74,8 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	 * There could be a race with another vgic_add_lpi(), so we need to
 	 * check that we don't add a second list entry with the same LPI.
 	 */
-	list_for_each_entry(oldirq, &dist->lpi_list_head, lpi_list) {
-		if (oldirq->intid != intid)
-			continue;
-
+	oldirq = xa_load(&dist->lpi_xa, intid);
+	if (oldirq) {
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
@@ -100,7 +97,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	list_add_tail(&irq->lpi_list, &dist->lpi_list_head);
 	dist->lpi_list_count++;
 
 out_unlock:
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d90c42ff051d..e58ce68e325c 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -121,7 +121,6 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 	if (!kref_put(&irq->refcount, vgic_irq_release))
 		return;
 
-	list_del(&irq->lpi_list);
 	xa_erase(&dist->lpi_xa, irq->intid);
 	dist->lpi_list_count--;
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 795b35656b54..aeff363e3ba6 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -117,7 +117,6 @@ struct irq_ops {
 
 struct vgic_irq {
 	raw_spinlock_t irq_lock;	/* Protects the content of the struct */
-	struct list_head lpi_list;	/* Used to link all LPIs together */
 	struct list_head ap_list;
 
 	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
@@ -277,7 +276,6 @@ struct vgic_dist {
 	/* Protects the lpi_list and the count value below. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	struct list_head	lpi_list_head;
 	int			lpi_list_count;
 
 	/* LPI translation cache */
-- 
2.43.0.687.g38aa6559b0-goog

