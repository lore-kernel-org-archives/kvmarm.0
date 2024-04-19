Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1760A13D25D
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 22:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713566366; cv=none; b=mXlrW56v2Q2w1rlyHa90g5qGIyGSGM1sKfhJrZS6kEqh2Bz7pISg5OIc6fmvh/xXRvUPQYHGSYGakd/sHM+zC/9uKzH3Wk256EWidkMTYWv25ldQxc9YNm5FbW6CK3xcXu8tVWeHBkQWdFREw+Rska1cJV8HlsjnQaxAedqf1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713566366; c=relaxed/simple;
	bh=Ad+M7Ie1C9+QfMlt1qAKvUIOJZ3CNTNlmIIGK5eG5+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptj+xXxqf3ldGSRPC6Dasq2/XguQRrjYB3wiBM2BYqyvVEQUj9mXLtWip5A36lt5P3lVvJy3fYWHfhfewJomsH/mU43+jhCfxzmdADOLyqWaya708tXscJlXBqH8pATlWBz8ZH2ksw/HWi4FFBJddFpT3aLO7NIG3L4dT3Ij3cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fflrYJDd; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fflrYJDd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713566363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKWHFYMRQb/SkVQG0f6pf/q4G/s/EREZBrEFaLnUKDo=;
	b=fflrYJDdz65mhvmO4Q4NhK4M2J7H9P7Xp9PXNYTIKa9oeC3ML58sSSbxWMorZVk4uT/vFf
	8iP/bNyKSiyd+vqhpssUQDR8PHRUf4zSXUZAB3RmJYGPJO+KMj0NXLL/bOBqU7dpE6uii7
	dPeZNbcQSB2XRfWR5pvWTDK2EgHSFmY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 08/19] KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
Date: Fri, 19 Apr 2024 22:38:31 +0000
Message-ID: <20240419223842.951452-9-oliver.upton@linux.dev>
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

The fast path will soon need to find an ITS by doorbell address, as the
translation caches will become local to an ITS. Spin off a helper to do
just that.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 4afd42b6a16c..be17a53d16ef 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -511,6 +511,25 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
 	return 0;
 }
 
+static struct vgic_its *__vgic_doorbell_to_its(struct kvm *kvm, gpa_t db)
+{
+	struct kvm_io_device *kvm_io_dev;
+	struct vgic_io_device *iodev;
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, db);
+	if (!kvm_io_dev)
+		return ERR_PTR(-EINVAL);
+
+	if (kvm_io_dev->ops != &kvm_io_gic_ops)
+		return ERR_PTR(-EINVAL);
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+	if (iodev->iodev_type != IODEV_ITS)
+		return ERR_PTR(-EINVAL);
+
+	return iodev->its;
+}
+
 static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
 					       phys_addr_t db,
 					       u32 devid, u32 eventid)
@@ -688,8 +707,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 {
 	u64 address;
-	struct kvm_io_device *kvm_io_dev;
-	struct vgic_io_device *iodev;
 
 	if (!vgic_has_its(kvm))
 		return ERR_PTR(-ENODEV);
@@ -699,18 +716,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 
 	address = (u64)msi->address_hi << 32 | msi->address_lo;
 
-	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
-	if (!kvm_io_dev)
-		return ERR_PTR(-EINVAL);
-
-	if (kvm_io_dev->ops != &kvm_io_gic_ops)
-		return ERR_PTR(-EINVAL);
-
-	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
-	if (iodev->iodev_type != IODEV_ITS)
-		return ERR_PTR(-EINVAL);
-
-	return iodev->its;
+	return __vgic_doorbell_to_its(kvm, address);
 }
 
 /*
-- 
2.44.0.769.g3c40516874-goog

