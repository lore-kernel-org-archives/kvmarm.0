Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3742F8E9F;
	Thu, 25 Jun 2026 17:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782407464; cv=none; b=oXnK1qt/D9ztFmsa5u6104UoUmH/pnn/sUkzAhY3V/Nt88d5/QGlHCcN5sS9Yj/Lag677zRNWgaSnl/7rPOdcL2nKWzDPIjjb2TyNXDRrIwQbltHnQmvwg3XvDrRKf+TnGM1gxjrLOJsgqDgM+bDxVr8QsD8W9pg4Vn3VOdzg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782407464; c=relaxed/simple;
	bh=X9ymLkvgESZNuu1mZsaQ4Thl7ofg/vFyNp8YOqMQFbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9gMjeXwXZkULIYAlNqG6R/CRS7WLFbr4n/ML6FSHpXNN5qVf+23o/hCNYOCNDX98XgMuz31gsJBe7up9gICmgNPYUq+dzg0xuN1WK0tLp3wzU4UXR3HziY0TBbvpZycpcFcF0yvuS0RUlGEnf6TC8Nrly1Xit3AEW3wFTbp4To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKsPzo2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKsPzo2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F41F000E9;
	Thu, 25 Jun 2026 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782407462;
	bh=upMfB/YHu6ZKIW6A4lyDoHPaZeYOB5hYVLeG3l6hdXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKsPzo2IEcsEePmOqPVoKTtHUnVIZxA8BRVvm02vfsu3350ADUjRP1T7TYkS7t+QR
	 60aW42CIBo8WQIyMlTpRuC3mg0+UJkwNM13MIxcUVhcnbqHS3MORPdltY/vlxQhJSN
	 zQf1LwIsLAFZPvEHq318YtkZ7nPAMzt1bOH0EbrJD/+isDeGknr34s7Yn5UqgYEcIE
	 /8Kom7mLUiON6E/TbhMwtNik+lecy8lzc0KcZspJTESvgs5CEM5Bsl7IVq1OO9BW/D
	 4JZBQugLYsmkp0fE7rgbh1NXv/pe2PEW0Gdm1Lq/INOUpdJ+mW7B6K/PCWIaAwzmta
	 m+V3cn/AIcGsA==
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
Subject: [PATCH v2 kvmtool 3/4] virtio: Add helper for enabling VIRTIO_F_ACCESS_PLATFORM
Date: Thu, 25 Jun 2026 18:10:44 +0100
Message-ID: <20260625171046.4482-4-will@kernel.org>
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

In preparation for supporting protected guests on arm64, introduce a
virtio helper to advertise the VIRTIO_F_ACCESS_PLATFORM feature for the
modern transport.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/kvm/virtio.h | 1 +
 virtio/core.c        | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index c95183b..dd3117b 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -277,6 +277,7 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 int virtio_vhost_set_features(int vhost_fd, u64 features);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
+void virtio_modern_enable_feat_access_platform(void);
 u64 virtio_get_modern_transport_features(void);
 
 #endif /* KVM__VIRTIO_H */
diff --git a/virtio/core.c b/virtio/core.c
index 8c5086d..96bbf96 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -355,6 +355,11 @@ bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
 
 static u64 virtio_modern_transport_features = 1ULL << VIRTIO_F_VERSION_1;
 
+void virtio_modern_enable_feat_access_platform(void)
+{
+	virtio_modern_transport_features |= 1ULL << VIRTIO_F_ACCESS_PLATFORM;
+}
+
 u64 virtio_get_modern_transport_features(void)
 {
 	return virtio_modern_transport_features;
-- 
2.55.0.rc0.799.gd6f94ed593-goog

