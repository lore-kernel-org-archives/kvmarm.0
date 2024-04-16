Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE25A86ACC
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261490; cv=none; b=R4ZxdjiYy6jzPqB9Uplweg+ifo41h92O3Tkxm+ssxJDnW0F9rt6F2VrfEU7xAMllPczr59aInneHEMGgTf9qCMAO2BahjHgFWAz39/eT+vDKmJCnsvtWm4uNVjE6DopJ0255lO7xf+kXn65NSff6B2qxcTNmu7MmPq8ZSwBoFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261490; c=relaxed/simple;
	bh=91Myt6OUEbtfmfIiTMWovCdo3vxfqdu/OLkuOjXy03I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImUnP2cWHPlPSFX5vIHd/L3Dq9krPJyjF5+fVkv2o37GqO3NYEhMX5Er/68rYbpAtoPvd/OurH+Fv0t1hMO/h8nL8xWIchTj1vjVHKtzaJlOp9/wq8lH3mvCUykDjRBZqvbaPHi0bd/qVT8UN9J/mIaOVRyqLNDwwKb+M9xbk6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l2WKGvzw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l2WKGvzw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-417fb8195d7so14904385e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261487; x=1713866287; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTexkHVu2OG8bwrkjNa6TXgP2UM7ULGp+qGz5Rx7n38=;
        b=l2WKGvzwtxLBYqJwJChH9+xVDk5eBWOpwz1bXKQnsoTTGDNngs2icu4LDhkbjH6+GG
         WuNrah6kP3wpdJsNVpiQ9yvpTAYINHPlJECcNenOW5kygCvcRXwc6ESp7ClTvWWCWp2H
         S/qNfNfhPpcZmtkEQ39HL/N1PvdS29FXhgN0w6Dvk5svJs/R/pK2RFpy1Ay76SpTHc8U
         Z9wcG1Xvi49zB2rwDhOH/3Zp/EbMHV9IqSpx3ElSwWYZf2qCCcNT3FSKFS1SaD8aS0tr
         T2DA6rYc6gcuhXVALaqJAUs3gwNZKfXWOGijhlqz8zZQqddMhvWVw12uP9dGJ5T2YmOU
         i7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261487; x=1713866287;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTexkHVu2OG8bwrkjNa6TXgP2UM7ULGp+qGz5Rx7n38=;
        b=SFdpwu4MqqEJERO38CronPMSTlbhZTMSAM0lo4/5Da307iqghoVqhwJomBWmoxrRto
         zaIgHCvudc770AW06jLxTy2NsA9G+M7v+Jqib7MyQXS32uA/oRzWKb3xde3iK/yXtvt/
         lsFRYAcLEtp9uAtIXVWicoOkMcsZ3AA793oBR+7fzd8jE7H2gtGztThKSMlrzpH9S7+L
         XiwD0b/416g7NR7pDqJxIB814s5bnSYapo3tlpBCUxfJpdtCzZN+GuHWBANoUztygbGL
         oQa5PiFXY448WvOR2jdnqkos5KHQ5WER8GGCQYwSy3+pQBURUQ4I3ntXKyawbaFh4PhZ
         FmXA==
X-Gm-Message-State: AOJu0YykKKJwgqRQvgSLem6QRsPaSL2rZE2mPwSKBQEuOmACh7skHLsw
	6lytpraokSnp9RbINvg90xJfZaQ2IXSH6qWXpzO4CMTwr6IjRybDtBuY6Mz2AJZoUcAL2kxgw/z
	pQaeIAjfjW/31rkSe/ZOOIZzpnNraDRiIHQPW+M6gyOLkKuWjhvg5JNFdYZ9AtfF1Vcd7VzBils
	h38t4sQG3NRepGm0AAkKd3UdMrn/4=
X-Google-Smtp-Source: AGHT+IFDW98uCxARtPkgIYbD0Dlz0lq3x3/ui/Qemf9WzT40++KpDwJPATte30oWx1Aj3WorNXcf7WaYsw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5104:b0:417:4ff3:386d with SMTP id
 o4-20020a05600c510400b004174ff3386dmr134648wms.3.1713261487524; Tue, 16 Apr
 2024 02:58:07 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:29 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-39-tabba@google.com>
Subject: [PATCH v2 38/47] KVM: arm64: Restrict protected VM capabilities
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Restrict protected VM capabilities based on the
fixed-configuration for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 27 ++++++++++++
 arch/arm64/kvm/arm.c              | 69 ++++++++++++++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 5bf5644aa5db..970b0cf72f7d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -225,6 +225,33 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
 	)
 
+/*
+ * Returns the maximum number of breakpoints supported for protected VMs.
+ */
+static inline int pkvm_get_max_brps(void)
+{
+	int num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_BRPs),
+			    PVM_ID_AA64DFR0_ALLOW);
+
+	/*
+	 * If breakpoints are supported, the maximum number is 1 + the field.
+	 * Otherwise, return 0, which is not compliant with the architecture,
+	 * but is reserved and is used here to indicate no debug support.
+	 */
+	return num ? num + 1 : 0;
+}
+
+/*
+ * Returns the maximum number of watchpoints supported for protected VMs.
+ */
+static inline int pkvm_get_max_wrps(void)
+{
+	int num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_WRPs),
+			    PVM_ID_AA64DFR0_ALLOW);
+
+	return num ? num + 1 : 0;
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66301131d5a9..edb321594505 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -218,9 +218,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_arm_teardown_hypercalls(kvm);
 }
 
-int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+static int kvm_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
@@ -332,6 +333,72 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+/*
+ * Checks whether the extension specified in ext is supported in protected
+ * mode for the specified vm.
+ * The capabilities supported by kvm in general are passed in kvm_cap.
+ */
+static int pkvm_check_extension(struct kvm *kvm, long ext, int kvm_cap)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_ARM_PSCI:
+	case KVM_CAP_ARM_PSCI_0_2:
+	case KVM_CAP_NR_VCPUS:
+	case KVM_CAP_MAX_VCPUS:
+	case KVM_CAP_MAX_VCPU_ID:
+	case KVM_CAP_MSI_DEVID:
+	case KVM_CAP_ARM_VM_IPA_SIZE:
+		r = kvm_cap;
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_BPS:
+		r = min(kvm_cap, pkvm_get_max_brps());
+		break;
+	case KVM_CAP_GUEST_DEBUG_HW_WPS:
+		r = min(kvm_cap, pkvm_get_max_wrps());
+		break;
+	case KVM_CAP_ARM_PMU_V3:
+		r = kvm_cap && FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
+					 PVM_ID_AA64DFR0_ALLOW);
+		break;
+	case KVM_CAP_ARM_SVE:
+		r = kvm_cap && FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE),
+					 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
+		r = kvm_cap &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API),
+			      PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA),
+			      PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	case KVM_CAP_ARM_PTRAUTH_GENERIC:
+		r = kvm_cap &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI),
+			      PVM_ID_AA64ISAR1_ALLOW) &&
+		    FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA),
+			      PVM_ID_AA64ISAR1_ALLOW);
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r = kvm_check_extension(kvm, ext);
+
+	if (kvm && kvm_vm_is_protected(kvm))
+		r = pkvm_check_extension(kvm, ext, r);
+
+	return r;
+}
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
-- 
2.44.0.683.g7961c838ac-goog

