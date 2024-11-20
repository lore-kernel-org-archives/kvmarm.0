Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D66A19D093
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099989; cv=none; b=RIHQw304wIfzNnI+T+wYmNjO+ieH1oF1c/37LJXyEIptMA72PfX8155kFnne8iAxJGEkzdPO0sKBoGY9OhG8U95gbFKqmb6vyRE/p4r8H/flbU+T+SFM0CIIs15tLkezXiwxoAEpfM3ILmLWaprFU87x5M3lfoW4UUuFLfTW7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099989; c=relaxed/simple;
	bh=xvE50174KReY1Qah+jcVRIx22sDENPOt+jaDBNqXy9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D8lJ5LwztqLoQnb9cAIIdiCUeeONyR1XrugqGvRGIHtb/n3YquUcWKOx2UjMgkYNcXTNzb42jgGTgMkeSOOKabASI5r0POjXZfinJEWILpHrKqJBpI1cKL/pK2B1QWkf7NT8q923PDOxFVSGH/vlg4xx7b9fJveu5kDHjmhwD0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQGtEiMo; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQGtEiMo"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30daaf5928so3240236276.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099986; x=1732704786; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+kRQ3NfjIG6Bs79ygogj1t8Kc3423PzxH4sJj7NjZHU=;
        b=aQGtEiMoD8zSKtB9z1EzzmZJBhuwWZ3N3ECsAE5PmJOVmJrss/LUxDYdjceV1lRN1Z
         HYTkAJyd49gbpRxdSGXltUK/g81Tuwo6xJ8njxMD/W2M9idu5R8Ev660AUX0urpWEG7z
         xo12gx4TsKjpwnLxKogcxYQDwk4RkSxIxBQOr0PCahNXhiWZ4NC3R2E4gfKWiezL1cb/
         qVWix3UdPeDZMiVCjBOWM9h04GRPVPh4bprvpBamESmCHvu5h7JuYNLpJRPZKxI/lI8b
         e6BTn5J0kSqc7b4QGTFJuqVNp1TFuopZPVWOeL4GiO9kGiCDRNGqK6xfab30ToAbt3S5
         M4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099986; x=1732704786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kRQ3NfjIG6Bs79ygogj1t8Kc3423PzxH4sJj7NjZHU=;
        b=WKqXhmWRYnVBvDCMNbkQuUvEqPi5tO08wO2XuH1yjf1yr4V15bIHpH7NKyWxaqEicE
         mVA+wtRKnYpa+Dwt3QDwcZtp4oOpgokE6oKtwHFbvIEqMNKDwRCAjPjwWDR3To8hUHhp
         H7BFpls+d53UHSLRkp2LnOwAPj5HK4Rz+D1Fa9Hnaxg/TpHWoRLT10JzMjZKul1GAjC1
         IJX5yNaMnhcxdITBvjodRL/oxugSb5EBb7aKXVL/kj62W1RikRUWKtpYRHZXHW67ZzKq
         1ChF/H3nsATpXqFaTQE0F9DrNrVLHNkpIIX3icTbf2mbMIptwLMq3AxMnOApH1M56bD1
         zThw==
X-Gm-Message-State: AOJu0Yy41iBG6jOmm90TGNySeG2GP2pVJWVEF/ZITKJ3Fmg464sirMnW
	W7fbn2qNWztGLOCXnE+mOvhfY8WxYtiLEZ8n5hy3wbHNb4AVD9M5kdqOAt/MAHVtD3KT75O+HPW
	4rHm/sVMUZ4IndqY4GlC/C8fI5RWZHGQEGb8zcgQzmN5cyW/pxQS5K9mlvDxBSAc7qRhgSTqduA
	yYJzAGq5WuQ7HgSNSojeIJqq+mO4M=
X-Google-Smtp-Source: AGHT+IHapSdLMD1TCvxruDtKv7QaVyot+JGorzkSR7TVaRWZsbecXQby/LtTC8b5CQRmbtQvzTdmdWe/YA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:b21e:0:b0:e2e:2cba:ac1f with SMTP id
 3f1490d57ef6-e38cb5fbce5mr1513276.6.1732099986055; Wed, 20 Nov 2024 02:53:06
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:46 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-5-tabba@google.com>
Subject: [PATCH v1 04/12] KVM: arm64: Use KVM extension checks for allowed
 protected VM capabilities
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Use KVM extension checks as the source for determining which
capabilities are allowed for protected VMs. KVM extension checks
is the natural place for this, since it is also the interface
exposed to users.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 25 +++++++++++++++++++++++++
 arch/arm64/kvm/arm.c              | 29 ++---------------------------
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 26 ++++++--------------------
 3 files changed, 33 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56acd9a842..400f7cef1e81 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -20,6 +20,31 @@ int pkvm_init_host_vm(struct kvm *kvm);
 int pkvm_create_hyp_vm(struct kvm *kvm);
 void pkvm_destroy_hyp_vm(struct kvm *kvm);
 
+/*
+ * This functions as an allow-list of protected VM capabilities.
+ * Features not explicitly allowed by this function are denied.
+ */
+static inline bool kvm_pvm_ext_allowed(long ext)
+{
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+	case KVM_CAP_ARM_PMU_V3:
+	case KVM_CAP_ARM_SVE:
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		return true;
+	default:
+		return false;
+	}
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..b295218cdc24 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -80,31 +80,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
-/*
- * This functions as an allow-list of protected VM capabilities.
- * Features not explicitly allowed by this function are denied.
- */
-static bool pkvm_ext_allowed(struct kvm *kvm, long ext)
-{
-	switch (ext) {
-	case KVM_CAP_IRQCHIP:
-	case KVM_CAP_ARM_PSCI:
-	case KVM_CAP_ARM_PSCI_0_2:
-	case KVM_CAP_NR_VCPUS:
-	case KVM_CAP_MAX_VCPUS:
-	case KVM_CAP_MAX_VCPU_ID:
-	case KVM_CAP_MSI_DEVID:
-	case KVM_CAP_ARM_VM_IPA_SIZE:
-	case KVM_CAP_ARM_PMU_V3:
-	case KVM_CAP_ARM_SVE:
-	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
-	case KVM_CAP_ARM_PTRAUTH_GENERIC:
-		return true;
-	default:
-		return false;
-	}
-}
-
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -113,7 +88,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (cap->flags)
 		return -EINVAL;
 
-	if (kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, cap->cap))
+	if (kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(cap->cap))
 		return -EINVAL;
 
 	switch (cap->cap) {
@@ -311,7 +286,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
 
-	if (kvm && kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, ext))
+	if (kvm && kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(ext))
 		return 0;
 
 	switch (ext) {
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fb733b36c6c1..59ff6aac514c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -329,34 +329,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
 	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
 
-	/*
-	 * For protected VMs, always allow:
-	 * - CPU starting in poweroff state
-	 * - PSCI v0.2
-	 */
-	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
 	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
 
-	/*
-	 * Check if remaining features are allowed:
-	 * - Performance Monitoring
-	 * - Scalable Vectors
-	 * - Pointer Authentication
-	 */
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), PVM_ID_AA64DFR0_ALLOW))
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PMU_V3))
 		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
 
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), PVM_ID_AA64PFR0_ALLOW))
-		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
-
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_ALLOW) &&
-	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_ALLOW))
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_ADDRESS))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
 
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
-	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA), PVM_ID_AA64ISAR1_ALLOW))
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE))
+		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
+
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
-- 
2.47.0.338.g60cca15819-goog

