Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD382208B
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 09:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817224; cv=none; b=gUVm+LVFpa3EyDmUGRoCvj/NTtNqpzIYGByv7iqpXDpUDlo+D9kZVUmgnt1/yMF+VSRGcZWApvYgyXfvKQNfgeifSk0q0qjCD70vDjGObEgkhV4C7K+aD1MOh0PlbVqgm0iwOkHftWmGJOpzrqainAYlsORRbcT7ukK+rstJa+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817224; c=relaxed/simple;
	bh=Hw7vNI2Kb24vC0nkaK7/5I/kAuFRQ3NHTOq4CoOcbhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRcsZD2IKNWwjzUeFb6So1dU5+RjAEsoqBvuz2Rzm12bITGpajaqHA7tlgMsNsb/ooBy+R2CaVkS/XhpJyGiHZ9vOqH9Tf6jEdTZI9HBmGiuACD60jQqf1djZ38IUA1RiUgO8nQGU7q/8/+zJlO+JgvEZQEHl1XIfqv6hrc9FFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A9/0Pdap; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A9/0Pdap"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OvMkuTAmZ2Y4I5mIeurgoX7p1vggpBUJZeCNdIuhqjI=;
	b=A9/0Pdapfde4UMXWBuOSYEnsYs3XzXeTFT8/HtvInZYMXQGfoyHtP9GTyIEbV2KV6N5ZJf
	1GzoPWM9GzgXptD4kKnxk5qSHY2zanY52NPwmDaJzKgsZSISUa26dRM3mo7RTWUFOcRMKa
	pXPEbI09FCmKKPQNM2lUj+U/uXTIovE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 16/23] KVM: arm64: vgic-its: Rely on RCU to protect translation cache reads
Date: Tue, 13 Feb 2024 09:40:12 +0000
Message-ID: <20240213094012.3961447-1-oliver.upton@linux.dev>
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

Stop taking the lpi_list_lock when reading the LPI translation cache.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 55463eb84763..0e449f8c1f01 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -593,15 +593,14 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
 	if (!vgic_try_get_irq_kref(irq))
 		irq = NULL;
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	rcu_read_unlock();
 
 	return irq;
 }
-- 
2.43.0.687.g38aa6559b0-goog

