Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66DC2F693F
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 10:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765450038; cv=none; b=cWlsWaV09gJ98bHWfBgM6jWgnlF/tLpssg5WG1ij/4fqzBWIrCVdMn7vtVAZzL7ZynSvU7GzAVUxtOrRkBabIkCNlrGzzTA8kFLg9h5CXiJepGsiSJJ/2HKUuKo69LI1l2qQxlXav0rOpRqeCB1ttVJw1CpxScPbjisfsl+RX9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765450038; c=relaxed/simple;
	bh=JsW05yVfuKyt4ffkx+VNJa7JjlwXFLDVM5vN/pziQZY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mrsKy6sMd9XQlLFCfmbC/bMVxkfnit3ZkPPwDJ4xMoSM+K0uQM/wGdGn1ceC54qkQVY+/Sny1q/kEx/fgediryco7tjHUUYE0+reZerDkJTGzU148p4yRRpFu8DnIa6G6kE9lnOS8frPrQr4VKVwbjumCoVDqSZ7d9/slhYCWMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7MxoxC3; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7MxoxC3"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42e2d5e833fso372688f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 02:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765450035; x=1766054835; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7g9tc9pp77WlckYZf2FBlXkDOOJvDIiD4XWZ7msWSEM=;
        b=d7MxoxC3384+dpBmMcjbwOcQyXR5BB3/yxq7flVoRbBVxSVyVSCgGMCgkLNI5aFyUS
         K1J3LliymReTWOmhmeU6ntW/F7EEpBtUtXxVcK8MmmEaOpuyZ0/oSg24evbQ6uPMQpI/
         az5ZbfEUOIGiet1xtjd4uTxXBIAXzEZJXUhtv5ah4oib/E5lHtoJBxDtku9k84A7IKYf
         bxwreLY4xsRsw00hCMa9uxCvv5ZbjTIbQV7LLLPopGMHOoKWrt3vjXOAgRKom4Ab7qxh
         zprMU7LSOVeVEcGmiQYIyAu++BUayqjWqoRERTPc/O8xptL76cSvjgZq6gE+eME4kKqQ
         /1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450035; x=1766054835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7g9tc9pp77WlckYZf2FBlXkDOOJvDIiD4XWZ7msWSEM=;
        b=xJ/hSVa6WiuAaobIZItK6z2CESRbhBpyjjlEowXCShz2K0yYuDBwRwBRU0GQZ+rIND
         nB+ZpV8j3yzSjPYqOC0nSM70ozzARnACCWqswYPEX96O5TnH7sku2bUX1ZzMYL5Jbmd7
         AoQsh3z/9QnZ8SwZpfEKDqwe8zI9NRFMdqjiFKxJVJyiRnSsxLzK4sE86ch6D/SWaFxB
         yPCnYwTrjlkDHcgVliL+nqCv8ntbQjcKswgtDpz36eRiedATkwSsWe3/R6u4VRKgQBqo
         XS8YmFiZKWWJNRL9zTO/8Wc8omTp8+qE+1SjDhk83uGp466u8eS6MDW5jKYx5rfYuvm9
         3KFg==
X-Gm-Message-State: AOJu0YxVIy0itiNUd4BAdQyoXC/c4GTOc0NkNW8c7v6sUwzAYZwV1/du
	8dJbj3rNG4Li5/zVTG85qL9EVJIcqmHkrleRilMkgAaBpa5xrEy+5FwTkiH0KTeyjTpEj1zNNK7
	nB5/sgVF+tgZUjLD0PjmLYC4J66sDffm8/p//MshLgDCM9Kg3lJlaVP4qPCUgmkKxRH4amSG/pb
	gN3flEz5Hy4e3nmWwxLPHXc8L5xw2rURg=
X-Google-Smtp-Source: AGHT+IG703o4qZLb6Vo8SzMBijudOudloOFbOISpm/Ryn8VPTSIuNK95aLbzFzJErHYHZF6cYYR3o3Jr6Q==
X-Received: from wrsz6.prod.google.com ([2002:a5d:4c86:0:b0:42b:5eaf:191d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2503:b0:42b:4081:ccea
 with SMTP id ffacd0b85a97d-42fa3b0fbc0mr6051865f8f.35.1765450035041; Thu, 11
 Dec 2025 02:47:15 -0800 (PST)
Date: Thu, 11 Dec 2025 10:47:05 +0000
In-Reply-To: <20251211104710.151771-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211104710.151771-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211104710.151771-6-tabba@google.com>
Subject: [PATCH v6 5/9] KVM: arm64: Include VM type when checking VM
 capabilities in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Certain features and capabilities are restricted in protected mode. Most
of these features are restricted only for protected VMs, but some
are restricted for ALL VMs in protected mode.

Extend the pKVM capability check to pass the VM (kvm), and use that when
determining supported features.

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
index 052bf0d4d0b0..e4936cb9c8c3 100644
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
2.52.0.223.gf5cc29aaa4-goog

