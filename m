Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0394420766A
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 23:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741216120; cv=none; b=Lz+wBIbmDq0WKOw5Hm26avDV/CTsPxvBaYQdR5VPEbnlFagN9I+jyWEp8kAfHcJE250WjZNOPUG+S9jWxxCNzO9yWWFF+4u/IXt2ddNxwV0X5uylVEtrtmVNuuU2mtR6pGVrOB7SgWni2501yRm8b/ARx9O1vojuXbkfTHxOWvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741216120; c=relaxed/simple;
	bh=Myr+W2ah5Ms7yLw7munDnX235Zjz0ZVOjMTpI1cGb3o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mq7FuXIXvpogJlPOX01Wm43BEdWmnYHF5yXsYnjCrFk0aqr8xwFFHWO4WhaFY6ojFEwBqBeXgVWtJOLcklQLo4kqqeeLyUhBaai5yyYBv7yIRNC5J0mt586iIlEIKJJibTopBi74eRimcrNDLx/21OadsSYH/oRF3WB2enAAMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fJdaJ1v5; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fJdaJ1v5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741216115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OeMUxpYMtRZdPfMjytpLIjFdJNCkz0ZXu45Za+VdHWw=;
	b=fJdaJ1v5b0d6/0rkVUzlIK0PxATtxUv9Vinvq+j3dzD20S3THkTidChe2mNqfl+nOpFlXp
	uawY8uRE58Gmlp5oYMkXlIG9KZH6yX1KBGpJz/0M9uSQIXgjyGXDkfHD01r9SdcgI9IIT9
	8ZZD7qpcgTtVILobL/Jxl9oYjZZKQg4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: Copy guest CTR_EL0 into hyp VM
Date: Wed,  5 Mar 2025 15:08:23 -0800
Message-Id: <20250305230825.484091-2-oliver.upton@linux.dev>
In-Reply-To: <20250305230825.484091-1-oliver.upton@linux.dev>
References: <20250305230825.484091-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since commit 2843cae26644 ("KVM: arm64: Treat CTR_EL0 as a VM feature
ID register") KVM has allowed userspace to configure the VM-wide view of
CTR_EL0, falling back to trap-n-emulate if the value doesn't match
hardware. It appears that this has worked by chance in protected-mode
for some time, and on systems with FEAT_EVT protected-mode
unconditionally sets TID4 (i.e. TID2 traps sans CTR_EL0).

Forward the guest CTR_EL0 value through to the hyp VM and align the
TID2/TID4 configuration with the non-protected setup.

Fixes: 2843cae26644 ("KVM: arm64: Treat CTR_EL0 as a VM feature ID register")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3927fe52a3dd..2e2975248cd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -46,7 +46,8 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_FWB;
 
 	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE) &&
+	    kvm_read_vm_id_reg(vcpu->kvm, SYS_CTR_EL0) == read_cpuid(CTR_EL0))
 		vcpu->arch.hcr_el2 |= HCR_TID4;
 	else
 		vcpu->arch.hcr_el2 |= HCR_TID2;
@@ -374,6 +375,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
 	hyp_vm->kvm.arch.flags = 0;
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
+	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 }
 
 static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
-- 
2.39.5

