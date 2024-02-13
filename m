Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7719364C1
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816809; cv=none; b=iMFabt5rZAqWUOoq4haGMVl1HQSpum/WzaMBtmbl3rDF7WfXdwO7R5n05bmLxC7xzyWhqaAL+NzlIzxPMSs+mXSMzk+qUIJZnJtH7ChX7JC4l7LxBdtbO+O7bh5zHa+PzsblxyiXrmsYphe/c/3ccO9x1Y7FUzZApA6LtB4Q9tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816809; c=relaxed/simple;
	bh=K1BXK5oYZl6+dA5mTViFGwIhpj458PXsoVl/Nu1w2ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXbp+2tPkZun4Shd3AFg4ZUDBHS9hgkoNOWb4jUE1lp4Fv8mGvFUmzNrIl54ETTKxfJCsHytPK1tEGl/5Lt12reMlsys6CuGf/qUXSePwcWra642uRJmhPOHoVKjVGyvHanqEdF4t7kSBxST/bmEvIuZEZq3wctO50RXnpeGQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lQLrteem; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lQLrteem"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707816805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQ22xtb57Hhh6ukA9UKpHbyaiDwLVQOEd0N6U2bxudQ=;
	b=lQLrteem+/oNETa88tCfy93s3hWpOQjhHY9udjC6jjluC/ugre068aS/g+cCHk38wmFIsT
	llzxysWLqD6W5XXtdWNc3eO5DfxFGCce105uksr2XMisqueJ+4opUXNBfUW4IqJp1zCYUn
	AluLUWq2PU2m0JaY0lo+9urNUaCPJVg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 07/23] KVM: arm64: vgic: Use atomics to count LPIs
Date: Tue, 13 Feb 2024 09:32:44 +0000
Message-ID: <20240213093250.3960069-8-oliver.upton@linux.dev>
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

Switch to using atomics for LPI accounting, allowing vgic_irq references
to be dropped in parallel.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-debug.c | 2 +-
 arch/arm64/kvm/vgic/vgic-its.c   | 4 ++--
 arch/arm64/kvm/vgic/vgic.c       | 2 +-
 include/kvm/arm_vgic.h           | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
index 85606a531dc3..389025ce7749 100644
--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -149,7 +149,7 @@ static void print_dist_state(struct seq_file *s, struct vgic_dist *dist)
 	seq_printf(s, "vgic_model:\t%s\n", v3 ? "GICv3" : "GICv2");
 	seq_printf(s, "nr_spis:\t%d\n", dist->nr_spis);
 	if (v3)
-		seq_printf(s, "nr_lpis:\t%d\n", dist->lpi_list_count);
+		seq_printf(s, "nr_lpis:\t%d\n", atomic_read(&dist->lpi_count));
 	seq_printf(s, "enabled:\t%d\n", dist->enabled);
 	seq_printf(s, "\n");
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index c68164d6cba0..048226812974 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -97,7 +97,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		goto out_unlock;
 	}
 
-	dist->lpi_list_count++;
+	atomic_inc(&dist->lpi_count);
 
 out_unlock:
 	if (ret)
@@ -345,7 +345,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
 	 * command). If coming from another path (such as enabling LPIs),
 	 * we must be careful not to overrun the array.
 	 */
-	irq_count = READ_ONCE(dist->lpi_list_count);
+	irq_count = atomic_read(&dist->lpi_count);
 	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
 	if (!intids)
 		return -ENOMEM;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index e58ce68e325c..5988d162b765 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -122,7 +122,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
 		return;
 
 	xa_erase(&dist->lpi_xa, irq->intid);
-	dist->lpi_list_count--;
+	atomic_dec(&dist->lpi_count);
 
 	kfree(irq);
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index aeff363e3ba6..71e9d719533b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -273,10 +273,10 @@ struct vgic_dist {
 	 */
 	u64			propbaser;
 
-	/* Protects the lpi_list and the count value below. */
+	/* Protects the lpi_list. */
 	raw_spinlock_t		lpi_list_lock;
 	struct xarray		lpi_xa;
-	int			lpi_list_count;
+	atomic_t		lpi_count;
 
 	/* LPI translation cache */
 	struct list_head	lpi_translation_cache;
-- 
2.43.0.687.g38aa6559b0-goog

