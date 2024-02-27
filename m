Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E8322EE0
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073797; cv=none; b=bWlEL0XDWiFEfkL43uFKZrAoASiW7901C9dybwRJljjNlV9ZP1WH6LF1Sv4koB+C7Wh01FkGMScm9Qjxtv6NNml5yyYLi8eNdhPbQzYp1HU2fiQOyN4PDTKFjl9V728zyVxT/2uZ70+q/QWBuMseJ5KoDCUbvspGhZqU1gnK6/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073797; c=relaxed/simple;
	bh=j1JfX0+OxFdKNZs7VX1oaWeu6r3lgqSvEkxwHxNDNnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxS9yNF1VWikHYXnE7MOvYNU5FLA0Rem6rjUkE4yAFRrqiZPoH0CjbmCLqMpLTJD8Lw/52WDN3XuOWUYErFTZTav7xzSk/w4oAsUvzrj3U2KSMR2VGtjNasYU1C1htCa2lt07G00ZeWXz+0j9Wdl8HYbeB4pCcEMzJ1sGvjZDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WC/wkS9M; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WC/wkS9M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIkQIF87EMga50bwebE9fCrx7j9Yrp1l65NBCSb4PIc=;
	b=WC/wkS9MU6A/N6G+thU8O0J3WnEnd0xe7QjZ1wS94ej/Fap+RD7bvIt9hYQtXQVTwB4yxY
	0fwq/L+xMq/2R1rt2QzWhJwPgRVou1ZwBuU86Va1JPamfB02nou1uh17T8ORD+UFxHW0VN
	1ICQM8lFQEq93DoH/Z5GqyJFEyu7fyk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 08/20] KVM: arm64: vgic-its: Spin off helper for finding ITS by doorbell addr
Date: Tue, 27 Feb 2024 22:42:37 +0000
Message-ID: <20240227224249.2209194-9-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
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
index 81f173694761..ea812f4137d9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -509,6 +509,25 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
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
@@ -686,8 +705,6 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 {
 	u64 address;
-	struct kvm_io_device *kvm_io_dev;
-	struct vgic_io_device *iodev;
 
 	if (!vgic_has_its(kvm))
 		return ERR_PTR(-ENODEV);
@@ -697,18 +714,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 
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
2.44.0.rc1.240.g4c46232300-goog

