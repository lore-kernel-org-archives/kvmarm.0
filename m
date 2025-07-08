Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4CC2E6131
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995554; cv=none; b=sTaGgaHXhPq2JFpifqDN4UOGHxnVp6Y0hmvAtO28x/e2H7/DmVAER5BOjo5Oa68wxyrLqT7JohydPup/Yqy/FCWwQzPrpuD9WHlJPpMnQyjKP0qK7g8ynyLXFXbIh8DoMt6RWik4DnopkKwGYUijT/Jfe7CDFj3p6Rg27IvfJoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995554; c=relaxed/simple;
	bh=NJZvMiVBSzHVnmOm7mxBnDMps3PgizOMq4i9wrHzW80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C456WJRJm8Lg/py/Tsn346xj2O/ga4s9JTcFQSsqvGPnGYStGqc6CEtsLUNbEOwo79QlFDWNVbB0MaRGW+7Jgk95vGthd6lD/YzwYHokHGFHIUPIEHmJJvfOesi7yVF89aqOnxyt9EmMTTTBRYFMxFVHuC5/oYM8bllpiqRabP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vEvHdm6g; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vEvHdm6g"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fzSPGaWG0/4OSmf3LerNCymrQjkfXD4pDCl6nXbdbPM=;
	b=vEvHdm6ghwR6U831F7Bl+C/0/332OqvPEadz4pGGLeam8h2NxGcnVGcWVZU7b6hpYbGuq1
	rHk5791+Mg7nC+iuIrgf2iBwn/usNJMBfFFDCNaKv5+n5RwrhrDW05c+4LrDZJLmCt+ZfB
	oWL3CLRMR/XR4aRYa7z/j1udFqJkTc0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 04/27] KVM: arm64: Treat vCPU with pending SError as runnable
Date: Tue,  8 Jul 2025 10:25:09 -0700
Message-Id: <20250708172532.1699409-5-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
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

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 659446378fca..bbe7b98e1ce3 100644
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

