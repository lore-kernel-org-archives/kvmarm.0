Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3BA17F4F6
	for <kvmarm@lists.linux.dev>; Fri,  5 Sep 2025 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757082111; cv=none; b=h0vYRjrGAqseytYUF49+kf5+/jNICoMrFqnwq7gJn/uO1fJMc+S1PTr8EntaQlcVUQ12rTNupf2ikPR/nYpXEtjAsWWWPHIcHSAn0g4HRbvfT7nO+dX2DkbzjOYJXMmRbQ3hZsVCfzDoij9gSSz/sJJ19Sg8m57CJhgtpvFF4hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757082111; c=relaxed/simple;
	bh=OwJORqhRmIe/5u77fqZAOf514uBSNHGSrHXb4th3KLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k0dy4clGYGHNUcHwbIXgQrQGHQ/pWC2em8zckZD/SY3HXuK7pCYXgoXHGcZOjcmhStxEzSVwZgIobTbqjscGPNzpTJvqF6kSFOEgoMuknOi1athjgC2o3yoKThcVOPK3hgF24T2Q2xFdrnRuE2JdpHzmbbFOj67/cZNf3MyUnr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XBf6Xo1M; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XBf6Xo1M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757082107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zStLybG7giQrNZu0Fxxxphxr566Y5C2gqoA4VFn3atE=;
	b=XBf6Xo1Mxov8t7NEntRfd1cQXCgRomuFBuu7T1btTF4oPIq1MAhvoSlkE8uvYtBgdzfaWf
	iBS7mxauBmNcqacO1CnRgE1M5Ss9d1k1hfqicVVboBlX59vmf8x8cHQtY9LwuysyI0qIMq
	qLJZRMuUsPEm2tJMZhKaegan56ASphw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 6/6] KVM: arm64: vgic-v3: Indicate vgic_put_irq() may take LPI xarray lock
Date: Fri,  5 Sep 2025 03:05:31 -0700
Message-Id: <20250905100531.282980-7-oliver.upton@linux.dev>
In-Reply-To: <20250905100531.282980-1-oliver.upton@linux.dev>
References: <20250905100531.282980-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The release path on LPIs is quite rare, meaning it can be difficult to
find lock ordering bugs on the LPI xarray's spinlock. Tell lockdep that
vgic_put_irq() might acquire the xa_lock to make unsafe patterns more
obvious.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index a21b482844ce..3b247041a130 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -142,6 +142,9 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
+	if (irq->intid >= VGIC_MIN_LPI)
+		might_lock(&dist->lpi_xa.xa_lock);
+
 	if (!__vgic_put_irq(kvm, irq))
 		return;
 
-- 
2.39.5

