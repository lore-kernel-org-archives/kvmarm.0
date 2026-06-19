Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8B7381B0E;
	Fri, 19 Jun 2026 11:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870070; cv=none; b=OEU9eSw0K/UOXkLWUwam+n2Aa91nvlupymCHBFR3UI+4vLrY7mqI+8eXUPskbAzjCM5MjfgN8mVbz4fPQ5GSg4OGLNn7Kitkq2peLgwRiGv94mWoOTXQ9qvUWboJYEep440XrPK8vT1qWoXeICSUx6pkDJc9cu5tCaf3ry78KH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870070; c=relaxed/simple;
	bh=MAidVOm4rcVnmFGFmS+qBAtD2pd6dZONotYiw2EAFzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChQlr82Ilu+Gnt1MduBEOt/uzTOx44+4atZxb2ZrRLvwQh+ZJR69+NPawu91Op3viIr63Q/ImWt6WCMa0NoirW4ZOuyBcAH/o221NLRAAEJXpJo8SyWSgfLV+khg9NZcr14/llpzrfGmXkTb52CkLO/7sOqhNG8HKd6959ayp8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5nLb/+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5nLb/+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D061F00A3A;
	Fri, 19 Jun 2026 11:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781870069;
	bh=M+1wOcPo/ykLklISsI5+Rv1fyEi6pM6pHn2Hi2zF5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5nLb/+b8BKFyThq/FScJqwWzDfOH1QKW1gA8nrazhx3fcFlGLcgpKn4bGD6VewwI
	 zx5sUAdOCfB/g/QQdiEG0nkIVHgwrd3PGBC6pP9hVgf6hpEV4MGhkUwN4E0rNkL9sF
	 5roTMpKP/1nEFgWEznVKB111ZBR11UFzrLMW/BDx6ZtiiM2PG17OY6eSgfjlxyG0ly
	 v3zDiCmYR+JWTfQOQummFFLhBYyouQx2DUKI8T1HbEtfwVusTRHGaQZy0pnXatOYOX
	 7YWwkHDzFSjU38asPCf4aLuQSBf9sdHxzadpwoXhq5EUDE5n2NGr0UyG7A9nLwVo0a
	 8IuauwhFNSygw==
From: Will Deacon <will@kernel.org>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 3/4] virtio: Add helper for enabling VIRTIO_F_ACCESS_PLATFORM
Date: Fri, 19 Jun 2026 12:54:13 +0100
Message-ID: <20260619115415.5475-4-will@kernel.org>
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

In preparation for supporting protected guests on arm64, introduce a
virtio helper to advertise the VIRTIO_F_ACCESS_PLATFORM feature for the
modern transport.

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
2.55.0.rc0.738.g0c8ab3ebcc-goog

