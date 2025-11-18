Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A13330B3D
	for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462298; cv=none; b=Vh87oRmcqM2gg7NoLlq4SdLUjBR7RNn2i6hT7KBYJEy4cDSYSxY4KmUZxgxAICff63+wvkS68hGCENkcP9ZjunZhySRnrjqKvYr8C2cKH/i9yLVuRxBSvZqLZxJAV0nE3d5l42OtkMILjgP6fw+juDsFRvjadvk1fP93BrXx8FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462298; c=relaxed/simple;
	bh=+T9pWVPxkhIqZEeKHCDUYC6bVKUN5yOXgXVN0FrZNrQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lBp/N5wVidtQWVlC+lBi/+QVEYdkvX4Ie6dg6lELQw2auReGpSBfqUc/Il2yKWU0g5cMMHlHVNGs+GpdwJIf6jHH6w7v0w39pbbRO5drv0eVnSMO3doRqr9aR4/YtODZjAtpFhb0LiCbPZ9DNza3UqqRGWlI2jaHHBcr+D8O7OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3lD2AFug; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3lD2AFug"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2b642287so3034600f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Nov 2025 02:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763462293; x=1764067093; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V3DY/r7vs4MdPYVHCLsSRZJ7Jsv5MwDNd3VXG3UBq7M=;
        b=3lD2AFugrNsBCh7na7DY4NgNzxbBUTE5wBTDdDfZIISOsDLJUalh7jsAg3mYB131gi
         vRXojsrq0PfDDTlesD3drdKb8YoIqlpZv2HCMUln9u9bFxz2HaQHJn06m2oWjkvipaBV
         fUZFM/hJlhUKJ2uiNigMJjF6DB8GYqGKlg7uZMsyaxKVBH76WTGGUMrns8qnfbFJZq4Y
         dVLMUOs3IisvLWvVvc7GbD2VtWTQKR1sKD/XFgTcGsbTy6ZALYnPpG8Ux3yFimNtDttT
         fVkspPUr1WcA/rpWNmguZD3IYAQTNhIOzJA5foAkdurVodXSaHefdks8GkFJgjgjSZdA
         xMLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763462293; x=1764067093;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V3DY/r7vs4MdPYVHCLsSRZJ7Jsv5MwDNd3VXG3UBq7M=;
        b=liQEZ9JeE1q/WgXoOtnb5RHJn8KXRmg2SMg7FeEraDgNvyVShei2xm8G0y5wrlARYC
         +bjKZWHs9xswUbAgf4vlcNZyJN0r9pNgXMuHXd+i+2v2eIheLhc2/5qXZQyS2UtcZjiE
         MaIoT4wZFwBt+ix0NR0giFV+n6R4rXjT9l/My7kG03LoDr9O6MHncxhpee9uXQidi4jJ
         iUChKHwUwHGf7PnHmmbGIJ5puCekuIW8V2lRmcA/Af6xzvrfljozYQiEOJmj9nbvcSOY
         DGYVjnv4/UXK5xOlB5QgCzbQ22PUBgnMxhzFMHny/DPx+gH9ZEy2RrU4+200GXIvKZjm
         QOJg==
X-Gm-Message-State: AOJu0Yzfeu494yop5yolp7YGBu+1Q+FQC+sO5CFnzbWuBqyweBOw59mM
	XZzUUsQd6tX+VN1r6ygv7QD1szrb7xoFPcglZcY+KmJCngoqAcc2y1lYujT4zvIsOEbnGaTnSlZ
	+3+rUx+C+ckfEsIc+M53Mmu65hK2L8IA5wVRc+2DYDG4T2Q4PqNJcR+Wjn3Rqyjs7PYOqBfEp5/
	afnixnPgiG21AE4QeWwgYW34JnWlOF3NU=
X-Google-Smtp-Source: AGHT+IEM0HDE+lvs9ScNzQ8shtoujqBquagXe3II1XZ7PNdFFLvsEYqm1nNc2hPRwGYPRVWpbIx2645UEQ==
X-Received: from wrxb9.prod.google.com ([2002:a05:6000:10c9:b0:42b:36e8:75b4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2910:b0:42b:2b07:8630
 with SMTP id ffacd0b85a97d-42b59374207mr13697323f8f.31.1763462292547; Tue, 18
 Nov 2025 02:38:12 -0800 (PST)
Date: Tue, 18 Nov 2025 10:38:02 +0000
In-Reply-To: <20251118103807.707500-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118103807.707500-6-tabba@google.com>
Subject: [PATCH v5 5/9] KVM: arm64: Include VM type when checking VM
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
2.52.0.rc1.455.g30608eb744-goog

