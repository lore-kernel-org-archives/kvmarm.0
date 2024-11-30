Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041B21A00E7
	for <kvmarm@lists.linux.dev>; Sat, 30 Nov 2024 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732978351; cv=none; b=DF328m6RKT3RbtWZKcQcOMqcVQ5ViqIgxBS1hH2ByBWpeSG6ihKcP8HLcWFWlNBSYOxjJMLbDXS1eAtuQWSyajGHkqVxxcft7YIn464ETW9kqhtLl8AxtbLZQ9siN/Y1P3C3ueSoSdHXl1BIbwnhH6nJKjJPiPy0UyaH/e/GvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732978351; c=relaxed/simple;
	bh=vWtaSN8rM2LTTGXH10O1fuLhKy3XoxYmtA3uc2UghMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VQC7AAkmm/Xk/pLSBuyNrtBdDxw6krWicRyOXh2p/FjkrOOTSx3ix5738R/kspQCxxjMOBM9P50JoEQPxyRAarvKqskmx4l43WZeZQssuBSqa0+yBomEWYk9965Lm1qs6/rTL04/knrgZgyD4MiGO0zHYGlDAbiHtBH1c60VpGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=gv5W27rd; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="gv5W27rd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KVUate8IXpTBbdunUcVuF5j0MQrmSQF2pil6K03dYso=;
  b=gv5W27rdpCkbRSK7XMVvcHiht2gPVnSfkqIwFyAKLkimob8gepRK/xD2
   dPQuJk8bbkIdhP+KmJyq8EF5Hegbhn28vix1h3Ve3VYjS717yVpRQrtCE
   u8O2PCw6ewh0RdQdlnG4JCGthkIID8p1HRu+76N+1BCnDKze8j3BBiaV5
   k=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=keisuke.nishimura@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.12,198,1728943200"; 
   d="scan'208";a="103063229"
Received: from nr-lil-536.grid5000.fr (HELO gros-67.nancy.grid5000.fr) ([194.254.60.35])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 15:52:25 +0100
From: Keisuke Nishimura <keisuke.nishimura@inria.fr>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>
Subject: [PATCH v2] KVM: arm/arm64: vgic-its: Add error handling in vgic_its_cache_translation
Date: Sat, 30 Nov 2024 15:49:53 +0100
Message-Id: <20241130144952.23729-1-keisuke.nishimura@inria.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value of xa_store() needs to be checked. This fix adds an
error handling path that resolves the kref inconsistency on failure. As
suggested by Oliver Upton, this function does not return the error code
intentionally because the translation cache is best effort.

Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
---
 arch/arm64/kvm/vgic/vgic-its.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 198296933e7e..a08835d00aba 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -573,12 +573,22 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	lockdep_assert_held(&its->its_lock);
 	vgic_get_irq_kref(irq);
 
+	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
+
+	/*
+	 * Put the reference taken on @irq if the store fails. Intentionally do
+	 * not return the error as the translation cache is best effort.
+	 */
+	if (xa_is_err(old)) {
+		vgic_put_irq(kvm, irq);
+		return;
+	}
+
 	/*
 	 * We could have raced with another CPU caching the same
 	 * translation behind our back, ensure we don't leak a
 	 * reference if that is the case.
 	 */
-	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 	if (old)
 		vgic_put_irq(kvm, old);
 }
-- 
2.34.1

