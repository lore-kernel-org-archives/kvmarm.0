Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917371BBBC4
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 16:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728925102; cv=none; b=un+kxQ1MTj9Mi8vy2jMpEUsQImvz+1g47e7gr9uny/2rA2ZvA2/h8ozVcxeojnljuC7WVBYpjcJ7FJ/F5fG9pLa5XveetqKlD3CkTI9glIzYRHZ9/OLU9hdML2hg2h7U7AmlsM+wCS/RFBOS9IOAQtCKtzDJ7D21uy3ZMLiBmGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728925102; c=relaxed/simple;
	bh=tGsadu+qRvcyHXiADuGKeQFob2GUx5MGeUfJqEIqUF8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ucOF0/+qJ0l3QhwTPbb7WnkPMqwP741uUyL3U6+qXPmum4cC7uC3KHIqDsQ06pIvhzWfy10X/DWw6LRzt8/pzy4hgEVO6PpRjhEFlir9FazXmI8rmJi2PZRQAW6XeAV+biTLxwXtd7qrbeXvZuf6yTyw6PqYhU7P1bgP3p5PcWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xE2Djw97; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xE2Djw97"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02fff66a83so6913361276.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 09:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728925099; x=1729529899; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xK2MSdwho6V+GWX3NuxPJRNZlPzf99n8IHnRPdTpY6M=;
        b=xE2Djw97fEhc+dC/qUmtVg6kR6SZcoSOUOJZby//2Ua8lofMZAXonvF9tEQ2D+qrWA
         6RbCp5QV2gItxBeDqpWwHrcaBc5uu0F318UtSMSWqmDy87l3oruHD5Q/oWSWNMzOlUbY
         zxaArwSpXIJ1+WsN6ZX1IpLk2HtdfQEZTHdqZImjW9BH1S2BmmHEwyFMV5qcEr4SW7xj
         +vQw3BzO7CcjFxudN2ZMHj1h+UhCml5JMhd1quza6iEs1nbylxDothNowE0eOACmK1Qk
         3r7Pb8sX/Zut8Z0ZfmCw1JWxKJOmWArovomp4s4VokveLqlgDfqJMl7cLkWrLYY4Kf1e
         Bk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728925099; x=1729529899;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xK2MSdwho6V+GWX3NuxPJRNZlPzf99n8IHnRPdTpY6M=;
        b=ExrPePUCqmeYQ979dUeZfFVPD2ZrEpRffzMCII/xGwY5jCFNTmiTMn19nTWe8O19lU
         azuYgCQChfAzRm/uSa0pXkl5V5Y7lA46GDdRjkfC1vnNghkLsYtbeHQTAkXkSREngr61
         k0eLe08MOLFCjCGUTsOq0DTqinguZ1q7tUUZSk775T1eO1Zz8AZJynw3s8VU+LfBp09T
         K0tQVlxWXbKl2jKvRUvRdNV3jAhHGPrt/oOrUKeuy9FjGnn6t1dctVzGJsOsSCc1+leX
         fbpBXz+K4g639ESaFxMNjBg0mCmI3cx1e1v77d9Vuo9cKY0VpWffih+jzMuzb9nH0Rhs
         n3zQ==
X-Gm-Message-State: AOJu0YzAO/6OKbIeY2wYnQLeF2lbLAleNmHps9X4xLjmTQArUzQpkCcM
	e0wt/6JZyGAsAEnU4+MmmE70EkLPH1aOhgjxy3aL52x/qCOQl/UGsFW4sdZZ33z/lcb9erJ2RQw
	79BkvUw5cezwibbZhTVetrIRZNhSA32FW8xapY+11GCsPI7XHP1ac0kWEW4zjVax79GfV1xt3j5
	FVFDQY1PTuIFmhDtRP8w/Z6AJwPJw=
X-Google-Smtp-Source: AGHT+IH/KjpEXYp/7PJ1p4TW8Ugg/+8TqcW+wsafVSDUvNIQzu+wKayV43K7/ACdz48F47kQZbuZlXQspw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5b:706:0:b0:e24:9af1:43e7 with SMTP id
 3f1490d57ef6-e2919d9ee16mr7808276.5.1728925098970; Mon, 14 Oct 2024 09:58:18
 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:58:08 +0100
In-Reply-To: <20241014165809.984883-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014165809.984883-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014165809.984883-4-tabba@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Convert KVM_ARM_VCPU_* features into an enum
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Instead of using compile time defines, convert the KVM_ARM_VCPU_*
features into an enum. Among other things, this reduces the
chances of missing to update KVM_ARM_VCPU_MAX_FEATURES.

Also rename KVM_VCPU_MAX_FEATURES and KVM_ARM_VCPU_VALID_FEATURES
to KVM_ARM_VCPU_MAX_FEATURES and KVM_ARM_VCPU_VALID_FEATURES in
order to match the features they're counting.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/uapi/asm/kvm.h | 25 ++++++++++++++-----------
 arch/arm64/kvm/arm.c              | 10 +++++-----
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 85901afeb332..9b7bf4ba07a3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -326,7 +326,7 @@ struct kvm_arch {
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
-	DECLARE_BITMAP(vcpu_features, KVM_VCPU_MAX_FEATURES);
+	DECLARE_BITMAP(vcpu_features, KVM_ARM_VCPU_MAX_FEATURES);
 
 	/* MPIDR to vcpu index mapping, optional */
 	struct kvm_mpidr_data *mpidr_data;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 2d5fd0ed7dff..b6ebd79b8373 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -100,17 +100,20 @@ struct kvm_regs {
 #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
 #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
 
-#define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
-#define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
-#define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
-#define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
-#define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
-#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
-#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
-#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
-
-#define KVM_VCPU_MAX_FEATURES 8
-#define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
+enum kvm_arm_vcpu_features {
+	KVM_ARM_VCPU_POWER_OFF = 0,	/* CPU is started in OFF state */
+	KVM_ARM_VCPU_EL1_32BIT,		/* CPU running a 32bit VM */
+	KVM_ARM_VCPU_PSCI_0_2,		/* CPU uses PSCI v0.2 */
+	KVM_ARM_VCPU_PMU_V3,		/* Support guest PMUv3 */
+	KVM_ARM_VCPU_SVE,		/* enable SVE for this CPU */
+	KVM_ARM_VCPU_PTRAUTH_ADDRESS,	/* VCPU uses address authentication */
+	KVM_ARM_VCPU_PTRAUTH_GENERIC,	/* VCPU uses generic authentication */
+	KVM_ARM_VCPU_HAS_EL2,		/* Support nested virtualization */
+
+	KVM_ARM_VCPU_MAX_FEATURES,	/* Must be last */
+};
+
+#define KVM_ARM_VCPU_VALID_FEATURES	(BIT(KVM_ARM_VCPU_MAX_FEATURES) - 1)
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a0d01c46e408..df17d50887d6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -211,7 +211,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm_arm_init_hypercalls(kvm);
 
-	bitmap_zero(kvm->arch.vcpu_features, KVM_VCPU_MAX_FEATURES);
+	bitmap_zero(kvm->arch.vcpu_features, KVM_ARM_VCPU_MAX_FEATURES);
 
 	return 0;
 
@@ -1407,7 +1407,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 
 static unsigned long system_supported_vcpu_features(void)
 {
-	unsigned long features = KVM_VCPU_VALID_FEATURES;
+	unsigned long features = KVM_ARM_VCPU_VALID_FEATURES;
 
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
@@ -1435,7 +1435,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	unsigned long features = init->features[0];
 	int i;
 
-	if (features & ~KVM_VCPU_VALID_FEATURES)
+	if (features & ~KVM_ARM_VCPU_VALID_FEATURES)
 		return -ENOENT;
 
 	for (i = 1; i < ARRAY_SIZE(init->features); i++) {
@@ -1474,7 +1474,7 @@ static bool kvm_vcpu_init_changed(struct kvm_vcpu *vcpu,
 	unsigned long features = init->features[0];
 
 	return !bitmap_equal(vcpu->kvm->arch.vcpu_features, &features,
-			     KVM_VCPU_MAX_FEATURES);
+			     KVM_ARM_VCPU_MAX_FEATURES);
 }
 
 static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
@@ -1509,7 +1509,7 @@ static int __kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	    kvm_vcpu_init_changed(vcpu, init))
 		goto out_unlock;
 
-	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_VCPU_MAX_FEATURES);
+	bitmap_copy(kvm->arch.vcpu_features, &features, KVM_ARM_VCPU_MAX_FEATURES);
 
 	ret = kvm_setup_vcpu(vcpu);
 	if (ret)
-- 
2.47.0.rc1.288.g06298d1525-goog

