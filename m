Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D018CBEC
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 23:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343843; cv=none; b=PytNfiYrjgAeb1/L96pOmYeUjvDW3NyDxs5TdXSxF25GH4aheTbVRbypiAsR9s21zIjfiRhsf5LrCQbKP19l8efvIm8cIWjV73uNhAOvHuBtgz9vKTnPKy7ch9ueErGw+VQmLX0M9b+e4bYHGvWEoOFIWbAY/IDYjwj+F1TiyXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343843; c=relaxed/simple;
	bh=gpsp7wZZTbbaMcWqJVXy9S8IdhcZZl4h8bwsTDb2lpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXjao0l16PShLymDF8ICxDDWtTwELEXv5GQaSeHMexnV7OlkB5k657v8d9bMlhuUiccoOgNyDRNf3uSz/HJPa16uDrv+1kTMpBiukMeYM1Ruwf3GZMwH/1VjGmaUFdD7o9QpJg+VseyiNihc2HVYizJ1Voelv9TQEQmP7wqURw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=omfykoUI; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="omfykoUI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728343839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fB3TGZWBMGjpvis3j3EmBL6RE/LRM/skKPpvSaxmrzE=;
	b=omfykoUIR9pQJGtRmhOWrMhHHTHRtlFOFvzOtr4qe9F/7lf8lunenlL/mGUaPG+gpu7J8r
	jvZ2IuZYLBzAJkrqFQFZcy0h689IFa1onkUaSPw1+wOyPTbvyeTJsyqco7mHgY3b04Hd3Q
	HlqCbnswQOunmnjR7pR81pbFhOj070c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 1/4] KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
Date: Mon,  7 Oct 2024 23:30:25 +0000
Message-ID: <20241007233028.2236133-2-oliver.upton@linux.dev>
In-Reply-To: <20241007233028.2236133-1-oliver.upton@linux.dev>
References: <20241007233028.2236133-1-oliver.upton@linux.dev>
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

