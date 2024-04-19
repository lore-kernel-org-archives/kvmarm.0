Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5891B13D25D
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566359; cv=none; b=b9mT3ih+V9CNWNpjK86UWoIR3s3ZVvhIOE69cuXgXXgAFMqBbt7uFK51yN2fNhXGMKI97/iLl666/PD/4PjI0sqycw1tk8ERUsYplgaY690jfb9aYqzrGqBouYgXqAZfTk5Rr1EklaNpyO351A5yKCwb4zHz1fJsT2ZW4jlix+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566359; c=relaxed/simple;
	bh=sCysN5H+IjGiCJLkDeIpe0lHif6Nd2hYWAXWQ00rj3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owP9tZBswAxVDUvinRR7FeS/0ZkugtKcUvxABWBW+yEzEK13UK4++NwNDsS1ki8mloJHEE3e+9d9nl8wTSShbp92+KoaVcwPt9OjUZ8rhGX/OU8QxT9qlxS0WpCYCCsTpnjycbw7CVxdnikDpHDKYtsZAAq9cqMKitw1mhyiddc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YJ7WsEq5; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YJ7WsEq5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HYmeC0MP3tvp0vfvkVCbJAmJdwZVt+xQb8QlgbKVB4Y=;
	b=YJ7WsEq5KbUwZ4OL5R1g4Ac/JL2xrIOY5OlNbXt6IzW7qFksdnQkYe1h729bO502rJ+3kt
	9THzPk/GB9mJePYMX36aaBpfjx7FFbEO+Dzr8g8rl3HsahcQYt1LuqfQuyJBnCtEuTHMyW
	VKFogYpeTPOpE3DJItag6PmGTlZLu+0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 04/19] KVM: arm64: vgic-its: Walk LPI xarray in vgic_its_cmd_handle_movall()
Date: Fri, 19 Apr 2024 22:38:27 +0000
Message-ID: <20240419223842.951452-5-oliver.upton@linux.dev>
In-Reply-To: <20240419223842.951452-1-oliver.upton@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The new LPI xarray makes it possible to walk the VM's LPIs without
holding a lock, meaning that vgic_copy_lpi_list() is no longer
necessary. Prepare for the deletion by walking the LPI xarray directly
in vgic_its_cmd_handle_movall().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 07706c5e996b..420a71597b78 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1420,10 +1420,10 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
-	u32 *intids;
-	int irq_count, i;
+	unsigned long intid;
 
 	/* We advertise GITS_TYPER.PTA==0, making the address the vcpu ID */
 	vcpu1 = kvm_get_vcpu_by_id(kvm, its_cmd_get_target_addr(its_cmd));
@@ -1435,12 +1435,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (vcpu1 == vcpu2)
 		return 0;
 
-	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
-	if (irq_count < 0)
-		return irq_count;
-
-	for (i = 0; i < irq_count; i++) {
-		irq = vgic_get_irq(kvm, NULL, intids[i]);
+	xa_for_each(&dist->lpi_xa, intid, irq) {
+		irq = vgic_get_irq(kvm, NULL, intid);
 		if (!irq)
 			continue;
 
@@ -1451,7 +1447,6 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 
 	vgic_its_invalidate_cache(kvm);
 
-	kfree(intids);
 	return 0;
 }
 
-- 
2.44.0.769.g3c40516874-goog

