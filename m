Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9651DDA15;
	Wed, 30 Jul 2025 21:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753910117; cv=none; b=jUozOOBHKLe2n+GC68Z+1BcCWob27GCLjsvFCnngbJcBw6zbxGIXuv+VkCMGDNAMUE0s/yX/+EF1LUsTKKqZS/6ZApm8LAat2ahKg9Sd+Ttr64lUs8VJSocbtO29VKdQMhSayps51+rQQ2p3IVYhoIT7xqAOHQYY8iL9ATFc/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753910117; c=relaxed/simple;
	bh=p7eZsxpS3vtI9tDNOoEZiy9hk5CJI4f8gTmOSqmh174=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nLZ5hT39WBW+iF3ZhN4NIzKHGll0ZYfcFDP7F9kBQsDrxHv1JSj8tlXL3Bud36PQSh9DL9AlVIqJ3u9WakwEgu42qxOZFGEnETD7i1zW2I+DAujmLh+5JSeVc0yBc/2e6rezljk4V8M61ApJvNrrkn58pEHVSD7N3IpA+kBfJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmTqUVtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmTqUVtx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D6E45C4CEEB;
	Wed, 30 Jul 2025 21:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753910116;
	bh=p7eZsxpS3vtI9tDNOoEZiy9hk5CJI4f8gTmOSqmh174=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YmTqUVtxYpaNhdbkPogckhsBnYFGwmR0Vtdaf//I6za5TKQ0VnghxjOVegG/jG2Ny
	 zsRQNR3aRGs4zFphKpbQlySpGdfweQZ+0EbP6RJuy0e/hITMX6Pir8Y3gpAdkbyB+g
	 rxo6xRfN0h47InrLEAReQI2Kr9fTPUh25Zzbzv+w7o7V0CE22LxZhfxLdvD4DH6JcR
	 0XschW/Zj3zQ/i3tpLe2bc4ZyHWHQgj5BhC07F/Qn2nF7+Tu7eaXE97yTsw+DUe6kT
	 f7SaYYtkDnVoQ3B9sXXxTl42t3bO8TC6wqeZdVuP5IBwZ8OR9wJV4w+HWYmG15Kwoq
	 fEun/NOLKGOdA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F76C87FCC;
	Wed, 30 Jul 2025 21:15:16 +0000 (UTC)
From: Per Larsen via B4 Relay <devnull+perlarsen.google.com@kernel.org>
Date: Wed, 30 Jul 2025 21:15:04 +0000
Subject: [PATCH v9 1/6] KVM: arm64: Correct return value on host version
 downgrade attempt
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250730-virtio-msg-ffa-v9-1-7f1b55c8d149@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753910116; l=1399;
 i=perlarsen@google.com; s=20250508; h=from:subject:message-id;
 bh=P+lmb3sotGE8m34PBEfN/prSolKXtIpxrlMSQIy5CgE=;
 b=VKzFYOmcY0g8SQT9dFrjRsgwYo/TQGIlpS1AMrLT5Fz0mUdsn2nlcFi9n9U8XRR0V/4CPVnn1
 9X2bF0wPHL4BHihowB+PK5QTAl3dw8KfYS5jViTtx1u6yIQGIVfJnUP
X-Developer-Key: i=perlarsen@google.com; a=ed25519;
 pk=jjc/Ta4VmrLRmMoahP6d1mBcKzvWU+nsmdtYe2oS2kQ=
X-Endpoint-Received: by B4 Relay for perlarsen@google.com/20250508 with
 auth_id=402
X-Original-From: Per Larsen <perlarsen@google.com>
Reply-To: perlarsen@google.com

From: Per Larsen <perlarsen@google.com>

Once the hypervisor negotiates the FF-A version with the host, it should
remain locked-in. However, it is possible to load FF-A as a module first
supporting version 1.1 and then 1.0.

Without this patch, the FF-A 1.0 driver will use 1.0 data structures to
make calls which the hypervisor will incorrectly interpret as 1.1 data
structures. With this patch, negotiation will fail.

This patch does not change existing functionality in the case where a
FF-A 1.2 driver is loaded after a 1.1 driver; the 1.2 driver will need
to use 1.1 in order to proceed.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Per Larsen <perlarsen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 3369dd0c4009f84ad3cf9481c747bdc57a162370..2c199d40811efb5bfae199c4a67d8ae3d9307357 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -712,7 +712,10 @@ static void do_ffa_version(struct arm_smccc_res *res,
 
 	hyp_spin_lock(&version_lock);
 	if (has_version_negotiated) {
-		res->a0 = hyp_ffa_version;
+		if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(hyp_ffa_version))
+			res->a0 = FFA_RET_NOT_SUPPORTED;
+		else
+			res->a0 = hyp_ffa_version;
 		goto unlock;
 	}
 

-- 
2.50.1.552.g942d659e1b-goog


