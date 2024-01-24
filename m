Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0C51350FE
	for <kvmarm@lists.linux.dev>; Wed, 24 Jan 2024 20:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129393; cv=none; b=tm3MLy3od0bpwqGzdVl0ABHIzNeD5u0WMThFA3tSymBiV7vuBHZ2xK+Z6DCGdiCji9KVfMZTQ9JTOODQ9Y1yh6JslOzlm12c8+uE7MXeiwPBtctWamYMt8UCbpjpcL47+mqTg3fZ4ajI9Mr/3nkAB8nJ2P94jIpRmiZl4x159Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129393; c=relaxed/simple;
	bh=3DFCwiB6MeI2Ico7jMywLcbYPxCd+D2TwpKxJ/Zr86k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgM3mvkGZyW5mARA6tc2fSABbdQsfdGpNGG3zoXnRoAM9QT4kskqywGEqgWg0aH1XZWpKjBM8mQLUBE5DO83n+/YhYGfDpLucDZHpPyo0bsuwbQI7NGfzYO3/qJHGEqz+qIAFPJp6wH+pIZrI+mo8BvB6/sNDoxAZ71uoTnOzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KWeOQxnF; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KWeOQxnF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706129390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kczms5RnsRrZgA05jJgqcXdZsBvDLLGbHzeZIIdOh7w=;
	b=KWeOQxnF7FEi1R519+74lreCzlafBL4c2mQrnfaHQHtiUYzbUSeZW7KwBQiiUhv4ZQAL+G
	dd4BTDM1zzV/s1EXxPZig5yLkDQ4ZCY0/yXRmwe1ZpzEhHPa0V+cMD7A7xVqr9TBFSnShL
	Cg+VrxgFrUxSEKdZyc2+sMQ2MkM3SK0=
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
Subject: [PATCH 15/15] KVM: arm64: vgic-its: Rely on RCU to protect translation cache reads
Date: Wed, 24 Jan 2024 20:49:09 +0000
Message-ID: <20240124204909.105952-16-oliver.upton@linux.dev>
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

Stop taking the lpi_list_lock when reading the LPI translation cache.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 1670b452c682..46ff21fea785 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -590,15 +590,14 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 	struct vgic_irq *irq;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
+	rcu_read_lock();
 
 	irq = __vgic_its_check_cache(dist, db, devid, eventid);
 	if (irq && !vgic_try_get_irq_kref(irq))
 		irq = NULL;
 
-	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
+	rcu_read_unlock();
 
 	return irq;
 }
-- 
2.43.0.429.g432eaa2c6b-goog

