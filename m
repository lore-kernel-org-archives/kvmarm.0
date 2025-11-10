Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224E11FF5F9
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782334; cv=none; b=INcrbWQciNjIutGelJhf/W4uyBHdqgfZ1Lira29t2pC8IIFb/wrzIupY+CaS5d8tzze5icNevEDlSwulCmAYWpxBLPMc0t6chORKLOFOREj/UF41Q0ZqChW+z7GrupZGyfxILGsP+Wc+9xdkFt52k/aqDrDnz9paYR+tz06JOC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782334; c=relaxed/simple;
	bh=rUNFbs9bsyqvQdllG1aHVD+H8fawn3DS2uAVXPDn/3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g9ElZtVxYdlk/VnID8HUBS4NjbXydfKdU0zS+Quna1Ilmwn/ZVhgzVhGy9x5gkZJlOv+6FmZXmbk6s+EI04llex/wHNtI0hNQ9Ykx1pScKc/i37uQhpFeI72VbfrmFvckeL73g4Nmw0INbdglBXAfBkPYkpcSGEeqClLPKlEYtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BK7hCk29; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BK7hCk29"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563e531cso37135885e9.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782331; x=1763387131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=try8WC1fF3BAE79rr/w67fgQlh2kGwhAnWrTJpFDLF4=;
        b=BK7hCk291/dkthV+8rBdXQcfK/kZa3D24w02O3iIk6CItrtU5Mx5pTrv1lgS9PXh2m
         UeM4GKBkVMZdMXu/4UmUBE2GI1Sqnn0n/aNk+GAxFduylhEUSfT6A328O6UZxucDmOzt
         shPRCjGRNkyAd6vjQxpjgEiFmDubbI5GMYnEEUYZhCHTuZM3zyAxlw6ppH3eWhdkYVe/
         wc4l+vwUx67yM82js/tN8e6eg7qfsdljaU+alpOdA+oqkR5UV8ZW3fJ0KKfDdpOfcEEh
         iskKN8S9Zszlq6ppQOTLETlpOze0FC9+miIxx3zzYYT8YbOKIn8qXp7NOh4G/5lMRVYk
         Dt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782331; x=1763387131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=try8WC1fF3BAE79rr/w67fgQlh2kGwhAnWrTJpFDLF4=;
        b=vFKrGkH4Vq/iuuWjGHbIU7xWeOtyVSj6AYa97Atpg+UmAA0jqop8Ed0efgelxxKSu7
         9T1rHFWQ1t9A5KEj2gL7xrfNjtvHXuXk3LQ2z+JrGiZ7daoca/+Q0vCs0rzLFQsmQ5bZ
         Mcd0gb/4TaVKFE2VPhgdt85mV7Zrwfp/CPoY/qExpkWNRA0+REfWx5xFv0uu8GOAkGby
         7GpJpI48vJnp342MJMUro0Ccyl1xXpm+TCC8XQ4lcfy7HdZoS0exOjZizCAJKpx5AQCZ
         hKpNXtylF0CZdZAcB5xBpnGfzovqskNWkX7RCzu3aIifK0/ve50m+eV432xtXq7qKYvP
         DB5w==
X-Gm-Message-State: AOJu0Yx05ZptEwVohnKEV1zaQtkSKYkBGlTHgpWRoIW1o49+GNz0ZZOm
	GoNJahs49WiYuqCB32F627DzbdIq6sue2qBPHDfdoPzRS1nw1j1OD0ii476/75KzQFCq+tdRhx5
	+jhU1rvRZJgpJaQ8b/LJI4Of9nEI5XxX1oHgxMvBJiuwRz9oVLKR2QrBBeIZpwPYzpns1afPkVd
	+5uECQd+rFUGeNugQZhHDpCBp4eZtvags=
X-Google-Smtp-Source: AGHT+IF/YlnQrYhy/rtnE5rg4ZuxaDgVfodztUXFrMxQxA2Qx6YAdDGeqcGNEKNfr+Q2rDleE2o41q/Iag==
X-Received: from wmby11-n2.prod.google.com ([2002:a05:600c:c04b:20b0:475:df4b:95a9])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e93:b0:471:7a:791a
 with SMTP id 5b1f17b1804b1-47773236f02mr76725015e9.7.1762782331578; Mon, 10
 Nov 2025 05:45:31 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:22 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-6-tabba@google.com>
Subject: [PATCH v3 5/8] KVM: arm64: Include VM type when checking VM
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
index 7e370e31260d..290e4b46cd32 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -355,21 +355,21 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
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
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_MTE)) {
+	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE)) {
 		set_bit(KVM_CAP_ARM_MTE, allowed_features);
 		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_MTE_ENABLED);
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog

