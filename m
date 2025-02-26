Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2996827455
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 18:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594712; cv=none; b=BVx5tdGNEotzRanm8HYjushVln81Nf6S0uyK21d9PCAb34uo+85BDin6niF326O4kfpVu080ClJok9rtfIlV4oQayzyU60j+56rF9jCReJkTth2S/b/u0NVYHU0j1vAG/H0wJs6Th2F58G/InHdxy66nAZqnryJcuhbFONxCga8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594712; c=relaxed/simple;
	bh=F+Wi0lkYTqJWKAbUxCRwtFOLuOlEQnOVzkbaXp2E8MU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZvzKEnlp0kPlN5CeJtXOqysSwRTlRGFINjyn+mNhNsQpz51W0t5dHVwuwU1NPRArUVgJdt0kHKjGfjy2fP167r95WXYmptk16NvqlWucodSiBccI5Z4sWILz3iHb01THLXANy94pfgWhcBcq3jj5Z/chCV9ewtEDPqUGa6gXESk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s/CzXSBw; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s/CzXSBw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740594708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkrJlPVZD93tAXHkksyryX5vaqixqktH7cxaIajuZrs=;
	b=s/CzXSBwP7Ebx+n6nJWFvmxuS1t/ISenQNgnKowgrTclY23rnidJD25DnJFvknYV/pibIq
	ye44OA1DHkq9hiKR8zirGI8Ft9Dmn+TAEXhKO81mI3U6WRlflirdlwHfjZQTy71xfL9YLs
	gF/AACDKbz+jccQ79KGFK/95Du1CN8M=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sudheer Dantuluri <dantuluris@google.com>
Subject: [PATCH 2/4] KVM: arm64: vgic-v4: Only WARN for HW IRQ mismatch when unmapping vLPI
Date: Wed, 26 Feb 2025 10:31:22 -0800
Message-Id: <20250226183124.82094-3-oliver.upton@linux.dev>
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

The VMM or guest can easily screw up GICv4 vLPI injection by
misconfiguring the MSI or the virtual ITS. Don't fuss over it; limit the
WARN in vgic_v4_unset_forwarding() to fire in the worrying case where an
unrelated HW IRQ was mapped to a vLPI.

Reported-by: Sudheer Dantuluri <dantuluris@google.com>
Tested-by: Sudheer Dantuluri <dantuluris@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index eedecbbbcf31..3e1de40720e0 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -512,7 +512,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	if (ret)
 		goto out;
 
-	WARN_ON(!(irq->hw && irq->host_irq == virq));
+	WARN_ON(irq->hw && irq->host_irq != virq);
 	if (irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
-- 
2.39.5

