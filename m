Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931E4221F0A;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753910117; cv=none; b=Yq4DP7QEBQDLraappzZ2clvg1sS8hP0S522aZW8pIB4iyZU+aORchELbTOgY4Fajwgent9zqqJjqijs/4gGWtt/QJcMANWVSEndJ9PHfgPD8TOVO949cBZtN+MEFG5kKvoBTk5XwNZltYp/fsfWMUpG3z810BFJPhZyHKld4YeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753910117; c=relaxed/simple;
	bh=ehvmTG9QreVlMg6OcuHCCXf3VqnfwjHcKBdR0xt8aDc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Slt/FK3WdOutrnoGnlhFnXHRgGY2zDgil0BQ+HAdwnCDsbUvexuhpocolqDd1J2AgAkAE737lJVJTFJLfASuu8Pt/Ji/JaZUXjssvmkbxbaPh+BQbtCEW0TdF0M3L1XJEeizWd1XOjcLwzV+9jvAuwvXr7zDDFCFLQoTQSak+Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBqQimjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBqQimjo"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F211C4AF0D;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753910117;
	bh=ehvmTG9QreVlMg6OcuHCCXf3VqnfwjHcKBdR0xt8aDc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dBqQimjon9cc9FuTYW+n1MgKyLnBz2rq/EnCOZGPRXbmlJzwEa2EtQz5ee4IQbo4t
	 a/oYOE2p77bxIzjMxX339tI0AJ2T2YCoBconffQYqlxSYWGCVY2O0exH9KZ7oguL0v
	 gNY8Rgpe0HhXTGVsBrqSlFZdbQDYMDasWQQiS8Fzrrq65SChw1ceGX2ohWLSWtm74K
	 8LH8yI4Pmrs9m32hlT1xqC+UXsCa7EjHZ5s7OILwnSKM0zsbKAGfn3u9W4gSgVvwli
	 RcpeELnrGsZDjm6RiAW9aymeU1BVBeX7mVmw/pcZEUE8OeNfMaQp67a8Vv5rbFFqnA
	 rYnbIk0hOkvzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162C4C87FC9;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 30 Jul 2025 21:15:08 +0000
Subject: [PATCH v9 5/6] KVM: arm64: Mask response to FFA_FEATURE call
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250730-virtio-msg-ffa-v9-5-7f1b55c8d149@google.com>
References: <20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com>
In-Reply-To: <20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753910116; l=1404;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=dmZ1vWZl/Z8DB9SSRWT99aiqcW400QLvm9waNv1o6lM=;
 b=sRoCHIfQXsIH2vwYvzb57woXK8E/mk/95HlK7n8HCQXbVfmha00ufq2QGwvnBeuZDY+siyh6W
 BliUlx3XlYvAVWOk3fx7g0CEYqej7aqLgCnp+PGIOOxfI3WlJFAhr1l
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
index 7fe96fe626d630a9009551e8dec1683617acafbd..6afc7e97a1e1e5e23ccf9cc11553b3fdaf8a51e7 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -737,7 +737,7 @@ static int hyp_ffa_post_init(void)
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
2.50.1.552.g942d659e1b-goog


