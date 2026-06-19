Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399E6381AFC;
	Fri, 19 Jun 2026 11:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870068; cv=none; b=OoE6Nc+jAguCNhTuqHuQ26PoruLPBZtT/XRjGBNL9GK7G2YhirP0SgOOxuQFBId7r598+7G1WQMvZFbaiyGDyhyyO0amMwVEaR+bckiODApLc0zm6OY7mvXFcrZSNqpK3VFLAb7opWobbGQ0hu7pCQ7PeHeZDm/gGqJEsCbACxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870068; c=relaxed/simple;
	bh=iE1fyj1TprjtWSNYc7vnadO9pxJouGtVe7jcCnNdBHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9Q7okIIpgs5fZWYjYCW/Iexq8M7XtcJbs0JC31SzbLZqGK35kYY2aQ02ioAR9jJNj4kdw/9KwsM7yF665udqgivDPQ2DCZMlXF8lOE3mKre86i1mAoOiWCKsAbVfkYjzVZWfv/iSxB1Pzsd/RA0AlvAh3w1F4Pu3jS9tTMAiKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aj8jYgL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aj8jYgL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B07B1F000E9;
	Fri, 19 Jun 2026 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781870066;
	bh=6CJWY49CFsIekALGL686ZfGUyj61NGSBSLJxxNVZE1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aj8jYgL9R39NBFWe63BMJqgGITpd0kM8TtZezO6Ima3JsX2So11YNQQJc9rripu2f
	 NZSMbRFLC/1c2+SW4tShvBNstqkrid0ro4TGAbxv36v2CCDw91FkAQuXR6erL0m23R
	 +AnCDPYdHYRgZvYsYrPRS4LDwn6Z36KLICj9IwC11WCZ3NywJIznH6YDlRMIugazgu
	 uOwvJXmruNK8JXpNDO1ZwmocAfyDdzIlhvZjL57PZhzQcq7Jq2yGzellGGDvVQYIYm
	 bJbJA0Siweju0mTJWO8I8PBZ7pOrdFCCSyoi8IiskvfHaMVr9cRrW5okDrxAevyEWo
	 +NRcL75mymyIg==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 2/4] virtio: Factor out base features for modern virtio transports
Date: Fri, 19 Jun 2026 12:54:12 +0100
Message-ID: <20260619115415.5475-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115415.5475-1-will@kernel.org>
References: <20260619115415.5475-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for optionally enabling VIRTIO_F_ACCESS_PLATFORM,
factor out the base features for modern virtio transports.

Signed-off-by: Will Deacon <will@kernel.org>
---
 include/kvm/virtio.h | 1 +
 virtio/core.c        | 7 +++++++
 virtio/mmio-modern.c | 2 +-
 virtio/pci-modern.c  | 2 +-
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 8b7ec1b..c95183b 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -277,5 +277,6 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 int virtio_vhost_set_features(int vhost_fd, u64 features);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
+u64 virtio_get_modern_transport_features(void);
 
 #endif /* KVM__VIRTIO_H */
diff --git a/virtio/core.c b/virtio/core.c
index 50c9ddd..8c5086d 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -353,6 +353,13 @@ bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
 	return true;
 }
 
+static u64 virtio_modern_transport_features = 1ULL << VIRTIO_F_VERSION_1;
+
+u64 virtio_get_modern_transport_features(void)
+{
+	return virtio_modern_transport_features;
+}
+
 int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		struct virtio_ops *ops, enum virtio_trans trans,
 		int device_id, int subsys_id, int class)
diff --git a/virtio/mmio-modern.c b/virtio/mmio-modern.c
index 6c0bb38..7787508 100644
--- a/virtio/mmio-modern.c
+++ b/virtio/mmio-modern.c
@@ -11,7 +11,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 				  struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
-	u64 features = 1ULL << VIRTIO_F_VERSION_1;
+	u64 features = virtio_get_modern_transport_features();
 	u32 val = 0;
 
 	switch (addr) {
diff --git a/virtio/pci-modern.c b/virtio/pci-modern.c
index ef2f3e2..888afa5 100644
--- a/virtio/pci-modern.c
+++ b/virtio/pci-modern.c
@@ -148,7 +148,7 @@ static bool virtio_pci__common_read(struct virtio_device *vdev,
 {
 	u32 val;
 	struct virtio_pci *vpci = vdev->virtio;
-	u64 features = 1ULL << VIRTIO_F_VERSION_1;
+	u64 features = virtio_get_modern_transport_features();
 
 	switch (offset - VPCI_CFG_COMMON_START) {
 	case VIRTIO_PCI_COMMON_DFSELECT:
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

