Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF58718C32A
	for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 07:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729237725; cv=none; b=mzVwUZd8o2/GVqLI++YSnyL3Tqt3o0TVMvRvl8j5hz7XZzaChLLuntdZTBEvwLzIi6gRhhY3/SDXWkcCgmi2ujomQKLl0tWJBkgmYOnsuhcgdoCjXXDaCMntcissTHtV80IBktRlRZ+9lbkJiKoe9Fv6mzTuxRbLWreUANion+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729237725; c=relaxed/simple;
	bh=qaPWhbVVNUb3qK/8F18GAMuMoH7gJEXSeWzCLSvYnlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=epc5a6l+FQLg5dpOTWbM66IhUkhBOVFL9TBqCTuUOLR0Wan+Z+M3QP4eimdcwf8SPDMriluSdRzO/mD1cr/ZfaZw617nkC/bIeNRuMk3ouW5JTgB+djBT8wXJmQm7eip5MUcaLI0zGof9jMhEMM7ZRX7Jud4BR5IqeAd806UXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iGZGpdf1; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iGZGpdf1"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4311a383111so11076295e9.3
        for <kvmarm@lists.linux.dev>; Fri, 18 Oct 2024 00:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729237722; x=1729842522; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdL5MTtmvyLkCQICGgSazmpiFB4ZKP0/T2UcGmeqmPI=;
        b=iGZGpdf1RvHc2xQMIqxLWiSzU4jkRRecrUoZalxB+8PFPlFLF+Q4l4FcarkEnmVaH/
         91Vd4/h4lGaSpdMJth01UgzW4Vo89f7fv7I4n86qhPcSo9NnRJqY0ZnFWaSIRs4F++Er
         fQ0a4Js2898HAcIgLUXO90PXFEpyhiokwZr+5yClpK78rQ/khupQzXJjcZqFGpazGZBL
         5xRcmQA5mV2T51Is+ujPEHfbr2lvDYNmpSbzPG86a/lvsLvSZ7j0T58NseTgE7tBBKV2
         b5E3c7zDtHs3PWbO+A8q3qznLqraNzNyZA+Izq6lIym/yb3+jXzQ8x8ZKPZBw7gkGu/W
         J/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729237722; x=1729842522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdL5MTtmvyLkCQICGgSazmpiFB4ZKP0/T2UcGmeqmPI=;
        b=qFCdp/wHItKVI6eOt2KY62/c1kDvD5FgXXVCcTtzdykqISMwfzLAwnvCdnbJz6+CyR
         P5nTriN+e8B92uAJnGwRzrXzedyXmnPfOST5yaWtzcCOcGl4RPocwpFFtFN8zpIaoYEF
         u3PvvRU6H/uYdQGoaOflMhc6l1/3DNbxapub759ar51VxmvwwW+VJpLug9YL/H/51WxL
         WQGvAF1CQorBTofjKzL8tJ29GyuPGMaCMYZiz28LSc1OpIURXKrBrbrsWOOFslzEcqOg
         k2uZqIZY7RKWcluRB+xazx+u6L9fExOrocFltUaOUW7wAOVwUVB8GlxACPI/pgx2/GL2
         ffig==
X-Gm-Message-State: AOJu0YzfoaJdEPp/Ukgmz29Dch0cUppHyDJB1Y3bR65AP8TaNSx8wrjG
	t5vkx19P/s1Z2zCC+tAkoESEtfA833rtqZWYwMao+n7Hf3u/1B8gkv77b/naiCPF6EteOzsEmpq
	a5/Fbg+6SCG/ORrQWV795hYRLo0xioAK93+1GGhdHaXeZ/RiucqG/3SIGKHofNucK9nmxOMIIge
	vSPYCtXDLhnSzUjBRqZQZiv35On+M=
X-Google-Smtp-Source: AGHT+IGO4GZ6ygQ+Gg9RldfNc21BbjaJf5VnguLH7eYU//q9IBSdXUfpvMPQqRyDkT1SlZ3Z+4LU1ekVAg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:219a:b0:430:55b1:ac9 with SMTP id
 5b1f17b1804b1-431615a14b0mr17335e9.0.1729237722112; Fri, 18 Oct 2024 00:48:42
 -0700 (PDT)
Date: Fri, 18 Oct 2024 08:48:31 +0100
In-Reply-To: <20241018074833.2563674-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241018074833.2563674-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241018074833.2563674-4-tabba@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Initialize the hypervisor's VM state at EL2
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

