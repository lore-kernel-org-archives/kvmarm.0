Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ABE28C5BF
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 23:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748646404; cv=none; b=FV5KGcV++VSqNuctiMNhToNZElbNtVtLwYpV4/OiLXn99YOGvhucvjL38EKF9QK6Ur8gx9davfIrZdm0dr6KJwCIk41sBiS+g512VLJKuKK+vMWAu9u8lip+zOhLkWlSw3RkA8FtHNGyPV7Di99lqtS1Jw5zYryZSCkOTf09eUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748646404; c=relaxed/simple;
	bh=aUt8fXL0AH/BVeclhW6hx7CDrokRoa9QZKfyr/v40N4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pUHmXG/u+rqV0sNWLTx2SRlO8HtJpuJiWGT5935KC2RrT37BbeKXRF7HaibWSBKllkg5EzTvdTjrI7/aYy2F0EAQw+i0fWzP9xDZF5U5viKkbq334h/NXvcashX+fyz1vg65y6hJlOSO7AAZadO5vvaW0g3HB8fOayzrr1pKTPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bNVagtwj; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bNVagtwj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748646401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KLHGOUe8htugSzjobBtkUrXJUl92FR7hblGdKzPIFz4=;
	b=bNVagtwjJx4OyWUZ/HEQRKp7+oAa2nunxAGR1P24iCstffZ1ubejZU/yUG3PboAzC0H8gw
	BxLygv7aDbbJKbzfHtDZ67AhZRDArUJiwFP6yqxQgkV3JOOyHSMu8hKUMb9IkHVjfWpCCz
	MCiuv64/6UXLi579LlYOx/+G7oHPx0w=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 4/4] KVM: arm64: Treat vCPU with pending SError as runnable
Date: Fri, 30 May 2025 16:06:23 -0700
Message-Id: <20250530230623.650888-5-oliver.upton@linux.dev>
In-Reply-To: <20250530230623.650888-1-oliver.upton@linux.dev>
References: <20250530230623.650888-1-oliver.upton@linux.dev>
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
index 5a4aca8082e7..c5c1b3ec0f7e 100644
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

