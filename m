Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE3E1E4B2
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732801602; cv=none; b=Ed2Y3tncvWo8xvhgqUqlPAeFN95tE8Uzz5r5VLOnaii8XYlLMh6LmhxbbuYl+5dmt99bzcgbabD/mOFPpKN9XPj82es9qZnf2Xrnfd/b5NJ/Xkqw7/Mskl8fKDtM1y/tniUnvvIKPH/sybGs3x3Bf26WZmCUwn0W3kcUhK6+TiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732801602; c=relaxed/simple;
	bh=4tIoF6VkaTG0evLWfvk4a7lSD8o4N8RaLyj0BU86NSw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tjl6rnbkZYoMECVF4jL3earARIKbsmeowN+/4FbYgrect15Sr27unNXOqofG39IAgyFbOXmJ+c5ijJ+hYFRxPAolg1X4KyY5RY9F9ujpbaQz4XeYsNUn7WD2zFzgLaB2r1HS8HGpK0bfUxbp8ej62U49ERYsoOz+fSUW2xhkZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=jgdJKA1k; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="jgdJKA1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iaG1b+JwMIQi3DAhpRd2uui2yB6sNRs4Dsa8pT9Cl5Y=;
  b=jgdJKA1k4OEhWqv+nL2OKASeAJVraXY4UpfvLPeti47MZStlCeV1UKh/
   UqqYR70toyScT9uroTm5DRTXkxlL5lFvYVZwRbHAkMpzMwA4RbJnlTtU0
   A4KdwCwhUGMw24SvucUmlQaB55FKo20ytUHUwtncDXHGwc7xI6b/F1OKi
   E=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=keisuke.nishimura@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.12,192,1728943200"; 
   d="scan'208";a="102888059"
Received: from dt-aponte.paris.inria.fr (HELO keisuke-XPS-13-7390.paris.inria.fr) ([128.93.67.66])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2024 14:46:31 +0100
From: Keisuke Nishimura <keisuke.nishimura@inria.fr>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>
Subject: [PATCH] KVM: arm/arm64: vgic-its: Add error handling in vgic_its_cache_translation
Date: Thu, 28 Nov 2024 14:45:34 +0100
Message-Id: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xa_store() may fail because there is no guarantee that the cache_key
index is already used in its->translation_cache. This fix (1) resolves
the kref inconsistency on failure and (2) returns the error code.

Fixes: 8201d1028caa ("KVM: arm64: vgic-its: Maintain a translation cache per ITS")
Signed-off-by: Keisuke Nishimura <keisuke.nishimura@inria.fr>
---
 arch/arm64/kvm/vgic/vgic-its.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 198296933e7e..8f423857b7d2 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -555,7 +555,7 @@ static struct vgic_irq *vgic_its_check_cache(struct kvm *kvm, phys_addr_t db,
 	return irq;
 }
 
-static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
+static int vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 				       u32 devid, u32 eventid,
 				       struct vgic_irq *irq)
 {
@@ -564,7 +564,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 
 	/* Do not cache a directly injected interrupt */
 	if (irq->hw)
-		return;
+		return 0;
+
+	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
+	if (xa_is_err(old))
+		return xa_err(old);
 
 	/*
 	 * The irq refcount is guaranteed to be nonzero while holding the
@@ -578,9 +582,10 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
 	 * translation behind our back, ensure we don't leak a
 	 * reference if that is the case.
 	 */
-	old = xa_store(&its->translation_cache, cache_key, irq, GFP_KERNEL_ACCOUNT);
 	if (old)
 		vgic_put_irq(kvm, old);
+
+	return 0;
 }
 
 static void vgic_its_invalidate_cache(struct vgic_its *its)
@@ -618,6 +623,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 {
 	struct kvm_vcpu *vcpu;
 	struct its_ite *ite;
+	int ret;
 
 	if (!its->enabled)
 		return -EBUSY;
@@ -633,7 +639,9 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 	if (!vgic_lpis_enabled(vcpu))
 		return -EBUSY;
 
-	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
+	ret = vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
+	if (ret)
+		return ret;
 
 	*irq = ite->irq;
 	return 0;
-- 
2.34.1

