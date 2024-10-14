Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1D15B14B
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901466; cv=none; b=S0AMQiRseedbSkJ5yj+Pu8vHxAjdtLsHNecj5gVg2gYHVpXrQ+SxrfNKgzvmkHK1psXaLLzt3UorGvnEEf6bjQFnZvV97I2DvKZu+PpNpI/qSIij+ayU9Fr9hgGwLKYTH9ZC5RZbTDcGPaltOfS5yTDBsfG70LvPL0qarfl6L/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901466; c=relaxed/simple;
	bh=qaPWhbVVNUb3qK/8F18GAMuMoH7gJEXSeWzCLSvYnlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Od2kpEqIcyiDY93KUuLMfjxQqxOc+CcVmkDscYoYrIZhvTKRjHGcnMe7Cvn38fT1QFIBkUTQwFxaWDuEKKEaY40g5+fg50e18+DtEnjujmNRmaVWGdqjTn4QwZZeroDf+NYxEqpdfCvqgb2goGapkIWt+yv2ahxSDSFY3Ro08Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1k5MeFO1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1k5MeFO1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43057565db5so21821965e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 03:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728901463; x=1729506263; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdL5MTtmvyLkCQICGgSazmpiFB4ZKP0/T2UcGmeqmPI=;
        b=1k5MeFO1oycPkEX0XPO8AzeR6rhfcePxJC562z4J+HR0QCqXu2/6e+Qoy1AR4NqUyp
         1BYCpaIykpy2Q1cE1fGGWMbdQjvWcyZ+qT6TqAJ55wCG96HO0+IufodApyNdIkIJIeUI
         mM1IIuBcjaxNMUaYDbNTwPvIGMBx0RfhObhojyhdE5zjh+ulpDHPwfPQwg97KagSGNmZ
         x+DshQVcEOWxjFgSglzy99RITv88d8Frt/rlamhAIhO4xOhhezJ9s0jCLfLLlQXK/XCx
         bd2yGszCj6iRZo7o3SjxNJfwNoFOIiSOS/vUQqSpmqea742ApfZKjaGJUIcziC6g33BK
         xsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901463; x=1729506263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdL5MTtmvyLkCQICGgSazmpiFB4ZKP0/T2UcGmeqmPI=;
        b=D+A6gjYWqZlypZ55NFgFYaShvg1pNPyk+8Iw01Ox3fiTxQqKlUz4lnPUwhUeQHQgYm
         SwSbJE/B9JWM894slOqP5JpEhOyPDSZMwVkURcDl9pLyZHOLvcJMtMjw5iSNj6DpzEZs
         ow04r3Si7/cv+1To7P/HkkA+PLWZuiFhgXKed3QfL+VTiJAm+02MBpru+cB6chvaxIdS
         mDZTLkxpFnQ+Z4Z36sQbVPgM7Xah3ge3P3OqFO/6xcF0B3CRyrNPFB3q6d/JsZxJZyAb
         GIH5W2eLsMPRkTLKUtWWM4hFe1ba/sESMeYR+cnV6rv01HAtWjA3grHGgOuwEXXuX6SG
         YQig==
X-Gm-Message-State: AOJu0YzbZamQ9HkiKvHsYiBFfulb2hiLvIAVatABcZu+H2ou6JHMfJj+
	tlapTfIW4dNT4D7lv8gGLLnQRQqadU/yrZ80PvrKq3XYYWcvuScU9JlQri50zedSbyr4zeUVY28
	l7xWuHwJUqg5GOcbSeaH0Ksw/oz6/tZB6cPaW3O+FLP6LxaIcL/HIzKtklVhG63Zzrx9GnKLbt9
	9DQfbv3esq9ZHtCwYWNG2kszcGSSg=
X-Google-Smtp-Source: AGHT+IFaeLjwgTb5LKfm/87sscnU4Ndq5AkMQbEwSUKCGetq5SyFB5N2xc1A1+Ga0Tp6LEJO7MyvPPijOA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:68cc:b0:42c:a8a3:197 with SMTP id
 5b1f17b1804b1-43115af9143mr2001725e9.3.1728901462475; Mon, 14 Oct 2024
 03:24:22 -0700 (PDT)
Date: Mon, 14 Oct 2024 11:24:11 +0100
In-Reply-To: <20241014102413.4092725-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014102413.4092725-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014102413.4092725-4-tabba@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Initialize the hypervisor's VM state at EL2
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Do not trust the state of the VM as provided by the host when
initializing the hypervisor's view of the VM sate. Initialize it
instead at EL2 to a known good and safe state, as pKVM already
does with hypervisor VCPU states.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 77 ++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 869955e551a0..954df57a935f 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -6,6 +6,9 @@
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
+
+#include <asm/kvm_emulate.h>
+
 #include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
@@ -289,6 +292,65 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_spin_unlock(&vm_table_lock);
 }
 
+static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struct kvm *host_kvm)
+{
+	struct kvm *kvm = &hyp_vm->kvm;
+	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/* No restrictions for non-protected VMs. */
+	if (!kvm_vm_is_protected(kvm)) {
+		bitmap_copy(kvm->arch.vcpu_features,
+			    host_kvm->arch.vcpu_features,
+			    KVM_VCPU_MAX_FEATURES);
+		return;
+	}
+
+	bitmap_zero(allowed_features, KVM_VCPU_MAX_FEATURES);
+
+	/*
+	 * For protected VMs, always allow:
+	 * - CPU starting in poweroff state
+	 * - PSCI v0.2
+	 */
+	set_bit(KVM_ARM_VCPU_POWER_OFF, allowed_features);
+	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
+
+	/*
+	 * Check if remaining features are allowed:
+	 * - Performance Monitoring
+	 * - Scalable Vectors
+	 * - Pointer Authentication
+	 */
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), PVM_ID_AA64DFR0_ALLOW))
+		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), PVM_ID_AA64PFR0_ALLOW))
+		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API), PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA), PVM_ID_AA64ISAR1_RESTRICT_UNSIGNED))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
+
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI), PVM_ID_AA64ISAR1_ALLOW) &&
+	    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA), PVM_ID_AA64ISAR1_ALLOW))
+		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
+
+	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
+		   allowed_features, KVM_VCPU_MAX_FEATURES);
+}
+
+static void pkvm_vcpu_init_ptrauth(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_ADDRESS) ||
+	    vcpu_has_feature(vcpu, KVM_ARM_VCPU_PTRAUTH_GENERIC)) {
+		kvm_vcpu_enable_ptrauth(vcpu);
+	} else {
+		vcpu_clear_flag(&hyp_vcpu->vcpu, GUEST_HAS_PTRAUTH);
+	}
+}
+
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
@@ -310,6 +372,18 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
 	hyp_vm->host_kvm = host_kvm;
 	hyp_vm->kvm.created_vcpus = nr_vcpus;
 	hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
+	hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
+	pkvm_init_features_from_host(hyp_vm, host_kvm);
+}
+
+static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *host_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
+		vcpu_clear_flag(vcpu, GUEST_HAS_SVE);
+		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
+	}
 }
 
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
@@ -335,7 +409,10 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
+	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
+	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
+	pkvm_vcpu_init_ptrauth(hyp_vcpu);
 	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
 done:
 	if (ret)
-- 
2.47.0.rc1.288.g06298d1525-goog

