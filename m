Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812AF1DB52D
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 16:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728319394; cv=none; b=qttstG7cpMnzSvjT3Ux5cz76uOOSweQCB6c9OPNoTLH8plaIYjz0RVrHTRswkrYwoHbzOJrgyLqeg6rgpGXdX44xbZkO0FyxO2FX58rq379OzUjGmhBgCrXpNVMu9HEU6nOQDv2kVeNBSKySzLGkJDuNGVHP27UAMonCB+2uOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728319394; c=relaxed/simple;
	bh=gpsp7wZZTbbaMcWqJVXy9S8IdhcZZl4h8bwsTDb2lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKgA2qQ+dibEsAcdxfCcT/Pty9B1j4qhIrrgF7FVxkP3bVWWHJltGPqvkUJuvqXzfS24fR8Vcv21nxXkq6SFtzqNmU/6YPqyN/NCeeEYqJKTm+6WpXWe3uxItFETSG6oe7uOerLBMPzOZLmSnng93byNZHrt/i5lqp+gHq/HCFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Nw84O9Em; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Nw84O9Em"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728319390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fB3TGZWBMGjpvis3j3EmBL6RE/LRM/skKPpvSaxmrzE=;
	b=Nw84O9Emy8Ii48TVStpkR12N/TK0ctT11+tgKDS0GF/+FRQQMwnZbKV1yofSArcuOXhVNN
	O8+712jzsjcuQ0+X9zSoeU+GFgrex7R26aMedo2jad++MNf3/pMWnvCYVAASvPyHvep/Ye
	YIwNYGGZPYLIfXGBRRBq1g/ba1EPVso=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
Date: Mon,  7 Oct 2024 16:42:52 +0000
Message-ID: <20241007164256.1795250-2-oliver.upton@linux.dev>
In-Reply-To: <20241007164256.1795250-1-oliver.upton@linux.dev>
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If a vCPU is scheduling out and not in WFI emulation, it is highly
likely it will get scheduled again soon and reuse the MMU it had before.
Dropping the MMU at vcpu_put() can have some unfortunate consequences,
as the MMU could get reclaimed and used in a different context, forcing
another 'cold start' on an otherwise active MMU.

Avoid that altogether by keeping a reference on the MMU if the vCPU is
scheduling out, ensuring that another vCPU cannot reclaim it while the
current vCPU is away. Since there are more MMUs than vCPUs, this does
not affect the guarantee that an unused MMU is available at any time.

Furthermore, this makes the vcpu->arch.hw_mmu ~stable in preemptible
code, at least for where it matters in the stage-2 abort path. Yes, the
MMU can change across WFI emulation, but there isn't even a use case
where this would matter.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/nested.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f9e30dd34c7a..df670c14e1c6 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -663,6 +663,13 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * The vCPU kept its reference on the MMU after the last put, keep
+	 * rolling with it.
+	 */
+	if (vcpu->arch.hw_mmu)
+		return;
+
 	if (is_hyp_ctxt(vcpu)) {
 		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 	} else {
@@ -674,10 +681,18 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
 
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 {
-	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu)) {
+	/*
+	 * Keep a reference on the associated stage-2 MMU if the vCPU is
+	 * scheduling out and not in WFI emulation, suggesting it is likely to
+	 * reuse the MMU sometime soon.
+	 */
+	if (vcpu->scheduled_out && !vcpu_get_flag(vcpu, IN_WFI))
+		return;
+
+	if (kvm_is_nested_s2_mmu(vcpu->kvm, vcpu->arch.hw_mmu))
 		atomic_dec(&vcpu->arch.hw_mmu->refcnt);
-		vcpu->arch.hw_mmu = NULL;
-	}
+
+	vcpu->arch.hw_mmu = NULL;
 }
 
 /*
-- 
2.47.0.rc0.187.ge670bccf7e-goog

