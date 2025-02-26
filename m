Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A729722A4E2
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594713; cv=none; b=pMtsEX5ZWnY57uPJt968JfbvtfqVgZt7QNzc6KgeFIowVILxdh5KD7rzGhyHO74nROfz+DYa/Nln1XEMAXLmwOfXh7dlsIL+zV3Myp+gDefcH8lpv7bVF3oWT9B7xzhScZVuEwX+K1BNgkZ327z9js5IryCuhc2iqVxdQhCD6Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594713; c=relaxed/simple;
	bh=M9dkhC4KaEHdFRrnD899ESuio7jbggPaoRt10qlCO0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ts3nWUZirHCm8ZB3E7+LMTKHpCF8YnJNWHmXrbq4EsCqdmr9nI/67gAjUNW/nlFkrR/sWjGwT5yXeySftgbvg00rAJTyXKioSMVfGwVnmqmEZiXTAFh4eTqTHwyKIz4LpumZ6On+2xTkkKe8RuM7VxcVWOuf7cuHKWvOkNeM9NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cjZzbskE; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cjZzbskE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740594709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hHdwIKW5jfI/ljjUoW8WDI2vRLg63R6c4R9558gXvMY=;
	b=cjZzbskEiBH9cPPAOjdKi+2Mr5DFo6RRPQQfaKSVmCRAWcRnQLiK7ehQr/e+xv6OGTWG0O
	WwPmapajsTKsVwk+M1JMchkaUsJ4ZgVx+LYnR3S+lUI67cQEFnxf+SEaLVWhQ8E0z7kLL8
	f/CE4C0dTE0pIFfRrETZBSRWflae2pQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sudheer Dantuluri <dantuluris@google.com>
Subject: [PATCH 3/4] KVM: arm64: vgic-v4: Fall back to software irqbypass if LPI not found
Date: Wed, 26 Feb 2025 10:31:23 -0800
Message-Id: <20250226183124.82094-4-oliver.upton@linux.dev>
In-Reply-To: <20250226183124.82094-1-oliver.upton@linux.dev>
References: <20250226183124.82094-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Continuing with the theme of broken VMMs and guests, irqbypass
registration can fail if the virtual ITS lacks a translation for the
MSI. Either the guest hasn't mapped it or userspace may have forgotten
to restore the ITS.

Exit silently and allow irqbypass configuration to succeed. As a reward
for ingenuity, LPIs are demoted to software injection.

Tested-by: Sudheer Dantuluri <dantuluris@google.com>
Fixes: 196b136498b3 ("KVM: arm/arm64: GICv4: Wire mapping/unmapping of VLPIs in VFIO irq bypass")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 3e1de40720e0..9f51d58b5f8a 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -415,7 +415,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 	struct vgic_irq *irq;
 	struct its_vlpi_map map;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	if (!vgic_supports_direct_msis(kvm))
 		return 0;
@@ -430,10 +430,15 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
 
 	mutex_lock(&its->its_lock);
 
-	/* Perform the actual DevID/EventID -> LPI translation. */
-	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
-				   irq_entry->msi.data, &irq);
-	if (ret)
+	/*
+	 * Perform the actual DevID/EventID -> LPI translation.
+	 *
+	 * Silently exit if translation fails as the guest (or userspace!) has
+	 * managed to do something stupid. Emulated LPI injection will still
+	 * work if the guest figures itself out at a later time.
+	 */
+	if (vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
+				 irq_entry->msi.data, &irq))
 		goto out;
 
 	/* Silently exit if the vLPI is already mapped */
-- 
2.39.5

