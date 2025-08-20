Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAF1A9FB4;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652212; cv=none; b=NOh5Fb2GwTeHKhHT68Y6b7Rxo0/4URtu67s0HhDz/F3TKGOua+me2dZcQb6x4jdRlN5/5+ACO2Gz1226/vkF70LDfc0OVzOTlWlkkKpnf7VniYQ8qKZifuW3jMA0C/21IVW5gp2pGog+aQkPfSuplyEgX7iZPQ55iLm+DCzpUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652212; c=relaxed/simple;
	bh=4aIBTPvj3mlS0mFSQkiL9HbPQJIP8JJJzPIipzWkWOk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g6HnUClSez3g//XMUXnGsvvLWgFUElfd1DV4V31ZzPB9JpvsI737HghJmCim28DzNJ2Xoj8RcDaejtE9oQ4wADEuDdkfYdm0FcJYepszjd7RN+Z3AhBTPIQwF7UKcCwnAKsvB7LMhj9Nc8ktOjN+up/qgOBv07tJeBZHD1ZZn0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GzaaHHDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GzaaHHDL"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DA43C116D0;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755652212;
	bh=4aIBTPvj3mlS0mFSQkiL9HbPQJIP8JJJzPIipzWkWOk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GzaaHHDLfhUnLJbQKiPeZehfprLhYrBCe9jn1LXOT2K5sveDm0/Qfgc8Fq0bbM0KF
	 qyEkgfEnDH43srRVKQ/Kks6V3HpF9Z/9tnj3tHjDH5yaecrgS4usH/ufgz51IqsENi
	 /9TzQVcx9RO/9OhKV2DnK5rxOfQuhMXdToRGFB5GcYHmHtPFmvfJc5q1rlpd6Zrqn5
	 +NCyDVEgC7awb+YTNmPr7OjtdeVvipcjyUK7xnFpqzeKeenfTeENL8iE8UNLuvb6B+
	 4HD4Fs/Cy6NCaRI0qRhIe7/7RKw+CBnZar5jxENas5KSgnPyFILOsESCrnJUY2MVAf
	 8V0QoOXasfcPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85674CA0EEB;
	Wed, 20 Aug 2025 01:10:12 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 20 Aug 2025 01:10:09 +0000
Subject: [PATCH v11 5/6] KVM: arm64: Mask response to FFA_FEATURE call
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250820-virtio-msg-ffa-v11-5-497ef43550a3@google.com>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
In-Reply-To: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, ahomescu@google.com, armellel@google.com, 
 arve@android.com, ayrton@google.com, qperret@google.com, 
 sebastianene@google.com, qwandor@google.com, 
 Per Larsen <perlarsen@google.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755652211; l=1408;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=3+r7TtwJ1pvrBzvbuh6WKHBBgdJuz5zMPQcaMPudbmc=;
 b=oL6lSKpTwfPP5RproVmd6Kyn1Qhr93I9kYWFlPEIJc4+cwaIz9LywwGKcsoEfOCO0kfbPhwLx
 Hrsx9+U9Gk4Dw99/TMvf1seMeHsl8tP6wke67qGrvkKpYwqBYeNrBA7
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

The minimum size and alignment boundary for FFA_RXTX_MAP is returned in
bit[1:0]. Mask off any other bits in w2 when reading the minimum buffer
size in hyp_ffa_post_init.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
 include/linux/arm_ffa.h       | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 96109aa99c48741e45a2b85d8e7bf26440597398..a8ec1a94f3f8a86551895f4606918246c4ac1f39 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -739,7 +739,7 @@ static int hyp_ffa_post_init(void)
 	if (res.a0 != FFA_SUCCESS)
 		return -EOPNOTSUPP;
 
-	switch (res.a2) {
+	switch (res.a2 & FFA_FEAT_RXTX_MIN_SZ_MASK) {
 	case FFA_FEAT_RXTX_MIN_SZ_4K:
 		min_rxtx_sz = SZ_4K;
 		break;
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e1634897e159cdc208931938649eb0fb04d5a070..cd7ee4df9045dceca1c4e0dca2d533b770b1b056 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -128,6 +128,7 @@
 #define FFA_FEAT_RXTX_MIN_SZ_4K		0
 #define FFA_FEAT_RXTX_MIN_SZ_64K	1
 #define FFA_FEAT_RXTX_MIN_SZ_16K	2
+#define FFA_FEAT_RXTX_MIN_SZ_MASK	GENMASK(1, 0)
 
 /* FFA Bus/Device/Driver related */
 struct ffa_device {

-- 
2.51.0.rc1.167.g924127e9c0-goog


