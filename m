Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F873A7852;
	Thu, 25 Jun 2026 17:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407462; cv=none; b=M0ZjBnuHWsAh5sI85uPaVk961+rdTw5H56A5FFX7hy1dmCoKolgqBFG1jqqIJT7uvBQQ4hJoYDam24vOcLP8Hqv9Cyg0wWqghKCvDv37KxsUYygi2lpQeu8sH3miN21HnSNEYc0fiE+Rg56F5PCcKJ8VspttuUrn1Dv8grqHKvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407462; c=relaxed/simple;
	bh=KW4n2A+51iSKPXbkszs52X4dDYrOOAabAsmbMICgtn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp2n8gf1QpZ9lWeCxUqBpunmqa4N/I2ccPYf6kl1kqF+85p/cq3s6kQ4w2eMZNfiMSX0jT1U1k49yJGhlp6VMWI4SRjyi/gK0YutTJHF1P5npkMuBk2ZGpZbdh7DE5RdqRn3H+1DaRr9hDyYZCUawPjqbMzjQsLzXSqHTeOSMts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RiZwS9sf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RiZwS9sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADA1F00A3D;
	Thu, 25 Jun 2026 17:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782407459;
	bh=bWQ4QN1rUNWitOtu1b0ydoByyjCbSevfz1s1YNlqu3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiZwS9sfroWZ/215Y7mSqWss197dfz5osQ6ivCl5qn8WatnWNYTFgekzLSIAiNGst
	 ybos+TkifTybdlJWuax7a+8DYeFiVTBepw7SHxJSU+l26pufXj8UTqf39wsfZfmDx6
	 rXNLFNRMgmzeYqmxJwFz55qs3O7QbHQTh5RHSmo04POLt+5U5IBE7fWQ1C0dqEhhU1
	 4YgmH+0aTGp7QeLlf9LufJ85MLDC+jsK5y+V9SH7Hmfld9yKxIU4Fq/p08+OJLCi9a
	 QGnuYl65XyAlzwPmNKfrF7l56AURisOeeiuh0fKHE4n9ueBHYbfQODUvcsMi/kOJxg
	 xZ2+rPg0YfWiQ==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH v2 kvmtool 2/4] virtio: Factor out base features for modern virtio transports
Date: Thu, 25 Jun 2026 18:10:43 +0100
Message-ID: <20260625171046.4482-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625171046.4482-1-will@kernel.org>
References: <20260625171046.4482-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for optionally enabling VIRTIO_F_ACCESS_PLATFORM,
factor out the base features for modern virtio transports.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
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
2.55.0.rc0.799.gd6f94ed593-goog

