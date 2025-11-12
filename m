Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2886D283FEE
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762939259; cv=none; b=pJolRDLGB9AQpCfYDEYFrJ1wXDSHlEKR/vF4SK5vehoueowWNsWx4i66Fm+IdC1C/14KTm5Q8hOIi1dBhfNdCWJecHj3ABGe6UWdEM/c9ZtRw3mnKombacqvT+dQAOSEA16y9Df1wjGwBm8L5mq8BuRxkv/QiSL+I9QnX/YBCWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762939259; c=relaxed/simple;
	bh=RWD4SvqEAUXVcxraYzizJjK5ggGL3IEyDAXeLQRA3Uk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T8p46pSBDOy72V2QHI/Fc57QPvJNSO4fzdWARpYwj05Ja1xirR0viXDEZA2QFU/xMT35lX0VxgGrSIjB4iDjW1cPIeQCEZk5KGAV+u3MDccDWRM90KvbfCIMfDbYJ1W54XjOdbUvmle/qfDZ61rMGOCpD/6OYlvwIFINf1eC2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X70GNZcs; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X70GNZcs"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4710d174c31so5255355e9.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 01:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762939256; x=1763544056; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aHIC92+7h1fiHoxXCfgvStA13HLz0Z6KTWisBidHWg8=;
        b=X70GNZcs89e3uUSd4KmsS1IuxuMHdf5uQJ28imGn8Eww0U5ffW4h1wTmk67Q5ZJIZc
         zMbpxNy2otm37E5z1wKKSxmJm3Tn6inildg2jM1ApoadSb+9y5FFrs0x6q1iv8pcoYAg
         OGs4p3sxHS4xY6gy3QU6QmgbIkcM05Lh0bG9DHW/bs+7XwKGdmCsqrv3Q7WKOxKsasBK
         qZrfBROOuVjp4grp+R3TVqMxGqkj9fdSqZ555u2CA24TF0+sTmFlq9kXyqrror5K0+HF
         C6acFxxlzIIppG4maTx7wv2/1eppjOJyqj8s494qOtGvFsipGgXRvI5/VCmGpa+ZXTej
         kWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762939256; x=1763544056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHIC92+7h1fiHoxXCfgvStA13HLz0Z6KTWisBidHWg8=;
        b=TXRYARXjKJIB6wM4kTzzJLcsIMSr0MJwCPug85vKJVRcVSIbK5B4ibqEeG/jVwH2V9
         kIGHv3kRK5UX+tNKg5J9TTbocs+6o/UZLQV3YnmajhWXjYerTQK5r4HQUlSow8Q5bkSm
         JNZoVgpxNhcPGLvGuUSgpTjFI1q/HD9Q/9tViqPq+O/90SoyV/4iZlIbh35IYIy+8Xg1
         tLuspqHiUmPxsTMAOeiseWujDXF9GP2TuPSNhrPdDdkNiW9afc+5MdRhQRaQwsyQ0sNT
         mj1sxnGfJZGhFSVK4EVHC6D8yyZirHdjNNohNQQkmozc0pIGwTiRSL/iiUi4xR0I4PPs
         33EQ==
X-Gm-Message-State: AOJu0Ywmfqd5L98sH92gUIN2kxJtsR42qn2Uoz7nE/hlURqwqdDdoKHO
	PXEAurRBVnENuNFWXabpjxcy+XtebAVAZ+C8zn0szcEkfKMNgaUEJQBgZ3xwA1Tjn1a03WFMmvF
	2WghjLt3veH3Xect73b405ncbF+BGn+FzeCodGTSnBKTwHJI3PMm4Favy4PjhuB8YgFTers0U8u
	FXGTp3oG3h3K8AQNm83jShP+gWhrBL8k4=
X-Google-Smtp-Source: AGHT+IFki9EQn03MZJ4Y3nhV5qb6E34s520PEnpe57GRhND4Zk/Km1oPA5OjMIFLoxgwnt8/4Ps7KmzJfw==
X-Received: from wmdd6.prod.google.com ([2002:a05:600c:a206:b0:477:5559:88d6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b37:b0:477:5c58:3d42
 with SMTP id 5b1f17b1804b1-4778707d687mr18254815e9.10.1762939256475; Wed, 12
 Nov 2025 01:20:56 -0800 (PST)
Date: Wed, 12 Nov 2025 09:20:48 +0000
In-Reply-To: <20251112092051.1376245-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251112092051.1376245-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112092051.1376245-6-tabba@google.com>
Subject: [PATCH v4 5/8] KVM: arm64: Include VM type when checking VM
 capabilities in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Certian features and capabilities are restricted in protected mode. Most
of these features are restricted only for protected VMs, but some
are restricted for ALL VMs in protected mode.

Extend the pKVM capability check to pass the VM (kvm), and use that when
determining supported features. Moreover, extend the check to disallow
MTE for all VM types in protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 10 ++++++----
 arch/arm64/kvm/arm.c              |  4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 10 +++++-----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 08be89c95466..7195be508d99 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -23,10 +23,12 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
 
 /*
- * This functions as an allow-list of protected VM capabilities.
- * Features not explicitly allowed by this function are denied.
+ * Check whether the specific capability is allowed in pKVM.
+ *
+ * Certain features are allowed only for non-protected VMs in pKVM, which is why
+ * this takes the VM (kvm) as a parameter.
  */
-static inline bool kvm_pvm_ext_allowed(long ext)
+static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 {
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
@@ -43,7 +45,7 @@ static inline bool kvm_pvm_ext_allowed(long ext)
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
 	default:
-		return false;
+		return !kvm || !kvm_vm_is_protected(kvm);
 	}
 }
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..10d853f2722e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -87,7 +87,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (cap->flags)
 		return -EINVAL;
 
-	if (kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(cap->cap))
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
 		return -EINVAL;
 
 	switch (cap->cap) {
@@ -299,7 +299,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-	if (kvm && kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(ext))
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
 		return 0;
 
 	switch (ext) {
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 16d7bf493c18..581dec4b8271 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -351,23 +351,23 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		return;
 	}
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE))
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
 
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PMU_V3))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
 		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_ADDRESS))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE)) {
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE)) {
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog

