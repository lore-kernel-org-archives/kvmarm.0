Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238319D064
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797328; cv=none; b=Q9KdPqqNsn2V+jcH3vL3xMYV8eM6hT0v3WWVuHdV+6hDuyLTFsP5Ep20h8OhHraVijUG6KJZ1wDZdhcq7VVJTycEVIpCerx3TKHe9Qyei/tqGI/7HFRHhrku64bUZtgfCIM3osaeOTXce0iYfUs+VsjRgK/bsXYYj4rlVOmfOYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797328; c=relaxed/simple;
	bh=xvE50174KReY1Qah+jcVRIx22sDENPOt+jaDBNqXy9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UXU+XBN9lWaI9HHeO974VTkUIUyO2X11K8c8otQCmHDKUFmSouvg0YpDN4SBpOSJI2Yh4hoP9w8D6un1jwQTkM3dAoBZPkd2KnZws2vIcCM3dzF5Z+Xb21DIUUf5sEN7B6f+lMgDlEZDlcBgd9QuOokfram62FxPR1tOQzxC0og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TVYEfM8y; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TVYEfM8y"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a104896cso5897085e9.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797325; x=1733402125; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+kRQ3NfjIG6Bs79ygogj1t8Kc3423PzxH4sJj7NjZHU=;
        b=TVYEfM8yQ8PaIxEVip3cM0ExSbrwboNEa4nkatqWIfCil0IppIsxW1I0hemg45GpwG
         b/qsImI//QmiTMiqPm77NeDhiSEjz/5B5NAxrurxTBfFJfwKrM69h3lvuN7BgbtbsDS8
         5TRhxcLLFxQdQsq069EizyIhkeVVHtBAV5W/rfnv7DqiiiivrCWiIgnkmyIKsMFBzn6F
         6AIQ6Utv9w9VgcGylHPUcJumPDdvrvlmM3pMh3ZQ0BuG2c8CZnC2cQ/2YrDobgC0tajr
         JsxhUah6gDcn/wb89XmZrsBCgO88cPiDFV0AruhOV/O7PCQgPwuSLi1eD5QxQJog51Qd
         uOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797325; x=1733402125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kRQ3NfjIG6Bs79ygogj1t8Kc3423PzxH4sJj7NjZHU=;
        b=Vosnb1ee2mbwTTXPvk/dmz6jjJ8mkKl3OYwzDu4QzlXmWGex6pNdQqCamS+Z8+Dw1j
         YJyRYZfLGC7aiOeKIW15ml3I+dEZOFVL7E4Yz8afIFHI5+gUnmv0EJ60nzQwOTixK96A
         2fkMeX5MbrmiXOsiGVYDxgjXt7ApROj8U29TxpDi79i85p7MwQFWuSDTI9bXSHSSIYlH
         FVq3kgZInIWorYDMVo0qovz8trUuAYIsQ/+io7xebqfOLxOTIhVxvH1ql/u2qVdmTkrx
         ObFJzOwjgUgReKVMAr3DVH/2IQrMUQDGQcD72ULLaw6njYCLsqTrpXdI4iKPxnDCQjHB
         MTGA==
X-Gm-Message-State: AOJu0YwhQeEPEQeLgqJnUHFc8VzHAux8Fzlp+cthFcdyC728pWVQex91
	6nNRVZIoigHUQReAof7aaoJpjKL/rgXIhWIsMguKV0dgBNt0bfDVZlEjB7IG+XHHQPY9gt2YE8m
	nNqKotu+CdLBY7HawjP/QEGIWQJ7tbyxNnNKKZlkEVu/+1+64wALrZh4+Yc3iM/Bx3qoXEHDYyQ
	yHlOzW9Bod1NPntM2hCJkNEfD7iqk=
X-Google-Smtp-Source: AGHT+IHMVReJErhhBo7053SStOHg6tt5oWLV5DgbbfQf1EpxKz1kiJMh0TSpRa+JHIfRw0tTmqmxL4KLIg==
X-Received: from wmlm9.prod.google.com ([2002:a7b:ca49:0:b0:434:a12e:328e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:6da8:0:b0:382:3210:4de0
 with SMTP id ffacd0b85a97d-385c6edd73amr5582769f8f.44.1732797325285; Thu, 28
 Nov 2024 04:35:25 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:04 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-5-tabba@google.com>
Subject: [PATCH v3 04/15] KVM: arm64: Use KVM extension checks for allowed
 protected VM capabilities
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
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

