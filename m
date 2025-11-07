Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47360339B2F
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541330; cv=none; b=Ag8+kiWG0RQt07o08vXZ/HejyODYKiDOCZr06IM3KYp6I7kXvQOJxwJ3eVFmQzCtaKELLdaU/AlWK9hvf8ubGbMua88bD9ovPj9dqpmQd8olypzUJ1TGNaEbq2vgoyDC85+WTTe04u0+6oE1wZA3iWYJKqA64ybM1r6QjaO5ZZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541330; c=relaxed/simple;
	bh=y9cQH9ZSwEdqGDezhqG6ZR+wZcmzq93k0eJZmATkFUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmCshKy/6PvP1JKlxNz4XJ8dsqqqJzN30YEgLuY+SohB4GuvJ/06k8aeOVvo7ivjkPFdiNLPqWl1WeRBM8zSAe2OvRufeb6qvw1Tbh5I1tLFASfVKxcRvGjTwJPpft99wqpxa/lGaIwjoyHaTqFx9aWfB6IVFM5hP0Vdh8+6exs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hzn364c2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hzn364c2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DCBC4AF09;
	Fri,  7 Nov 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762541329;
	bh=y9cQH9ZSwEdqGDezhqG6ZR+wZcmzq93k0eJZmATkFUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzn364c2pJ0VAJ5HhtQOItXarveZlQlbWH7RGoCCriTvtveXHnxXPee7tKa2FpY80
	 NjndUq4dXV7FA/PFdtd4s8dF65xp3vO5Bk+Lqh+2xJJLiy4ceQQ3FHazOrXVgPJnM4
	 3eM33QUaUMvU8im2AV1EPfiCfO8Cl9MLbqcAI2iMSsuBc4Vl0H2P9D34muo3Qb1tU8
	 CBWAWdQ/AfBStZ2ECfUyxzYIzFPYqJk5B1s4UQD/tgizN7k7A73W8IyAhMrsImzuNS
	 HaThA/u7Ru/o25WT3wzuDMNdQwH6SNlsUGPX7vgGN1t1Kf1GgQ9IJN5zIZLBM72p/o
	 JngX9/AgblqvA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 2/2] KVM: arm64: vgic-v3: Release reserved slot outside of lpi_xa's lock
Date: Fri,  7 Nov 2025 10:48:47 -0800
Message-ID: <20251107184847.1784820-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251107184847.1784820-1-oupton@kernel.org>
References: <20251107184847.1784820-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xa_release() expects to be called outside of the xa_lock. Fix
vgic_add_lpi() to drop the lock before calling and restructure to get
rid of the goto label.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Closes: https://lore.kernel.org/kvmarm/d0853e82-7d95-5025-7abf-c6f1e0cdf7b5@huawei.com/
Fixes: 481c9ee846d2 ("KVM: arm64: vgic-its: Get rid of the lpi_list_lock")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index f162206adb48..3f1c4b10fed9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -115,21 +115,18 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 		/* Someone was faster with adding this LPI, lets use that. */
 		kfree(irq);
 		irq = oldirq;
-
-		goto out_unlock;
+	} else {
+		ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
 	}
 
-	ret = xa_err(__xa_store(&dist->lpi_xa, intid, irq, 0));
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
 	if (ret) {
 		xa_release(&dist->lpi_xa, intid);
 		kfree(irq);
-	}
 
-out_unlock:
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
-	if (ret)
 		return ERR_PTR(ret);
+	}
 
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
-- 
2.47.3

