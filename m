Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07372080DB
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744817216; cv=none; b=F2BWKFb+4bCAD7Wyk6vJog+WlPxlAnrDyjYjoHURmVNa1MeZe4ippQ4HiaDGZxM5SWs5ji9MOmrHrtEyDnWt/AwmafZ5c7fyJxvS2BjZlWxpKcZAbRzgHQ7rRJKyXGpyX7rXWLmkanqBQ5oir1+63TygZwVbdfFrOV+H9m2Gxr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744817216; c=relaxed/simple;
	bh=+tI4PEfGQfafoe0FcQqYYwv3iwkEbI6CYxC3OLOKiy4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjemiX9qSQy6//X9Z45dZAO0rSYSM9URvlH6Xlp+TpDComeDlPNCc/BnBWvZqnDmvzoJ2DiiajGgmB2pMjs7OiH3wCyATEKN4iAtrCMuRqAr5JVDOToG7kTey8fG8JPBunMoq6286bDRh83QqqpSrWuveAY8tHZ2CUPqtN0pkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wp3I8vDM; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wp3I8vDM"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5e5d9682f53so5918888a12.2
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 08:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744817213; x=1745422013; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzD2f0rxQ0+kK+W36kLcNjO+gtstze2fsnlGYTmtJfM=;
        b=wp3I8vDMG8XY9d3SSEf0PSbhREPuT1Dg8q6yXOFL91/j+PqnfGv9ZDVZlyy95EILyB
         hX+M8XxzPDzG5Qz+q2nxFPrf3wF1kdizHN8LYISmzhxLzWN1awqRTaGaDkOb8D4w9V21
         QEPgQHDTPvqTl/vIxY4qek7bIPmLrH4zrcadGSB33KAqM7tbjA6zuQ9f9Rtr5+ik/8Cf
         ctLIYWoIEAGoY3aIB93HS3IFyLSUNJHuJxOkBVGxdIYWshPRQk4JGG8PcfgLCzkEapEQ
         zrUZkfVA3Ej0xbSx6XXhpHR4hAdpXbVJU/z7ReWeFzjU4ntlAGMW0dZ6nI9f7SShXz+S
         Pm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744817213; x=1745422013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uzD2f0rxQ0+kK+W36kLcNjO+gtstze2fsnlGYTmtJfM=;
        b=V/sM/H+8oKnc6hKm1Tb2JAQSVRNOwkVw3XXzIwLp4+L/dbL2E36oEUMIfgEdozFiXf
         Kfi0b+bNIkfVo+a1jSXEUDkp6wVLOAqskdrR3Zgpz+OU59r/k40tubixW+fubjrG9dxb
         t+PF/FtwMj26YBQBbx2uq1WXOIDzrwWlSaPLqjgcbOlXyhmLHXmIQCv7AYbbF673Kgx9
         YPZa09V++Fsw539eFCBEKN2shSDqc9BVTASRDmOqzyv7CUL9L8Tcm3iPNJSs4q3jh/PT
         XcE5KgIdi4VMECHmsVQAN2gbPP+rMUAjzfea+tgb5JhHz50ilMtZPwz5TSikSdXkmY3P
         s3wQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpgEIXh4nLZ9J12N3uiResmamH9SyF8f/QP42H0gT43NE6unOaUwBS4hQ+ZPatoDdpL1324kc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoPhAq0xnTEyknyy8MgoiBlUs8P8PXg1ecUvZPo5Rr8lPcnDj3
	yrv/FTyrgBj4g7ZXrZN8fLDLK0V+MHpgesFrIk8fSPDzz2OKCzoV1exRVVf3+wr5KYGuOl5f9rN
	n2Mn1vA==
X-Google-Smtp-Source: AGHT+IHeDz4onV1W2s/vfCOCzAITZ8Cgy1MgbHMQ8Bx0jNC7ijt2U2LknXq2pGOSmZDw3fZM7GLT6soOihnk
X-Received: from edsu15.prod.google.com ([2002:aa7:d98f:0:b0:5f4:ade4:88fd])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:35c2:b0:5e5:bbd5:676a
 with SMTP id 4fb4d7f45d1cf-5f4b75b2ce3mr1715528a12.22.1744817213096; Wed, 16
 Apr 2025 08:26:53 -0700 (PDT)
Date: Wed, 16 Apr 2025 15:26:41 +0000
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416152648.2982950-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416152648.2982950-2-qperret@google.com>
Subject: [PATCH v2 1/7] KVM: arm64: Track SVE state in the hypervisor vcpu structure
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <tabba@google.com>

When dealing with a guest with SVE enabled, make sure the host SVE
state is pinned at EL2 S1, and that the hypervisor vCPU state is
correctly initialised (and then unpinned on teardown).

Co-authored-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h  | 12 ++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 ---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 47 ++++++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..931011b68819 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -971,20 +971,22 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_zcr_elx(vcpu)						\
 	(unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
 
-#define vcpu_sve_state_size(vcpu) ({					\
+#define sve_state_size_from_vl(sve_max_vl) ({				\
 	size_t __size_ret;						\
-	unsigned int __vcpu_vq;						\
+	unsigned int __vq;						\
 									\
-	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
+	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
-		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
+		__vq = sve_vq_from_vl(sve_max_vl);			\
+		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
 	}								\
 									\
 	__size_ret;							\
 })
 
+#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2c37680d954c..59db9606e6e1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -123,10 +123,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
-	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
-	/* Limit guest vector length to the maximum supported by the host.  */
-	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
-
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 5a335a51deca..338505cb0171 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -372,6 +372,18 @@ static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 		hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
 }
 
+static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	void *sve_state;
+
+	if (!vcpu_has_feature(&hyp_vcpu->vcpu, KVM_ARM_VCPU_SVE))
+		return;
+
+	sve_state = kern_hyp_va(hyp_vcpu->vcpu.arch.sve_state);
+	hyp_unpin_shared_mem(sve_state,
+			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
+}
+
 static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 			     unsigned int nr_vcpus)
 {
@@ -384,6 +396,7 @@ static void unpin_host_vcpus(struct pkvm_hyp_vcpu *hyp_vcpus[],
 			continue;
 
 		unpin_host_vcpu(hyp_vcpu->host_vcpu);
+		unpin_host_sve_state(hyp_vcpu);
 	}
 }
 
@@ -398,12 +411,40 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	pkvm_init_features_from_host(hyp_vm, host_kvm);
 }
 
-static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
+static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
 {
 	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	unsigned int sve_max_vl;
+	size_t sve_state_size;
+	void *sve_state;
+	int ret = 0;
 
-	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
 		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
+		return 0;
+	}
+
+	/* Limit guest vector length to the maximum supported by the host. */
+	sve_max_vl = min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_host_sve_max_vl);
+	sve_state_size = sve_state_size_from_vl(sve_max_vl);
+	sve_state = kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
+
+	if (!sve_state || !sve_state_size) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = hyp_pin_shared_mem(sve_state, sve_state + sve_state_size);
+	if (ret)
+		goto err;
+
+	vcpu->arch.sve_state = sve_state;
+	vcpu->arch.sve_max_vl = sve_max_vl;
+
+	return 0;
+err:
+	clear_bit(KVM_ARM_VCPU_SVE, vcpu->kvm->arch.vcpu_features);
+	return ret;
 }
 
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
@@ -432,7 +473,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	if (ret)
 		goto done;
 
-	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
+	ret = pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.49.0.604.gff1f9ca942-goog

