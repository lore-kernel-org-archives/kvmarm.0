Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91451212B2B
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115009; cv=none; b=VLaxyiAKbgqDkxu0FFQtn3ci5wcwbiPTzFByVoOkddJ3GjNY3dkgysMaj/jgO1F4E6vpMZ2HyZx806PXbhx3rjGYVyg6cA5eaMp+hTBbS90z3hPva9XOD6KPkoC3yuJNLskIS5IClN+4hl0lJ7z8ob3qeEgtdR9Buynko42DNA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115009; c=relaxed/simple;
	bh=SsVevdp+TjB4lKAo0St7UJ3ScxS+pJeT72FYjaLt+u0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TOioGGHJ7f9kAAwJEIAGX68y6yOcaqllZ/WM9ikr3h4RduTdIwaxcrfBezInATS7nt4l+dK5Z+bKjybA/TkY+1FWv4A6ng2QUgte6IL14K+x9TgPzx5cwifbtHuWPP09oTV9VGPkizfExbuclX2og5YyJW2OPrMj4USZEAfHYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kdSXrqNv; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kdSXrqNv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0/YnsgPS7qfunPYcOmJ4wnrZCG1oz1yXcJZG2tFaw/g=;
	b=kdSXrqNvPxf3Zqbz1EkPzTHoAgYGvv4voMpHO7rWc7frRoNNqg4RgAbA8hbOy6IOgw+dRo
	uPrdpPK0lmXnX+DSbrvNQIYb2OOVyVEaXnTifIFmhKmXUu+yNYniOFOoYSzBOXcsOjGqd+
	YxMaX2nEVlzz2cr87abQ/qWc63aaRNY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 04/27] KVM: arm64: Treat vCPU with pending SError as runnable
Date: Mon, 16 Jun 2025 16:02:45 -0700
Message-Id: <20250616230308.1192565-5-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Per R_VRLPB, a pending SError is a WFI wakeup event regardless of
PSTATE.A, meaning that the vCPU is runnable. Sample VSE in addition to
the other IRQ lines.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8419da3581d3..e99b2535cf51 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -740,7 +740,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
+	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF | HCR_VSE);
+
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
 		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }
-- 
2.39.5

