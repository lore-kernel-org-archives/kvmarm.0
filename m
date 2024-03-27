Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE712E1F1
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561038; cv=none; b=BlihWbmXtnejYKAPydJJL5gYR48ljj0Om6u3Y34d8uvLj7s/zBcc4/zWii7SDqqs/kGOS79ERpakGUDrXI8VDv8swaGGmUW59ZJ8zWrObFzRR0CruiE8J7nEVyeUzypMZUCY+MRJe8C24AHyjql/lxmDLNfp+V4Lppoej9nW5h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561038; c=relaxed/simple;
	bh=E3ijehK0e9K5uZnb47r+kvBewzWPGNN51NNgE4h5OqU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ya7pE/sNG7ktGNk4hVT12ZD7MfxXo9BOKQs0DVfUcxi1IOH+PYEB8r0i5dCtdTw3p2Q24oQ2tj9LhZzG5iHCxFDEWT9V3gSRfIrhOiKqOcFQnZHYdCPl0iXiH2TkvLEDToRA7f4PyCOzhOnkrMj8+noaa6iYHvsb7pMMkMc22Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jJBKiKh4; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJBKiKh4"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd8e82dd47eso41110276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561036; x=1712165836; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bcARctp1mKnS/h6xHFyZebVDq6w4ScwaC+WjNc/L64=;
        b=jJBKiKh4tDF2z94EGu4S2oNSx4cM+2z+NmTz40yFHbnA2xuazOdbAwe5v7QNoGKqCz
         aVYO87Y/NJXPRt3WiXliTEoksgcbZNX2YSXklbYqSyxafanUdi2O97ZBCD/IaWLn8+8+
         xJM3YvBLGbHvPSbebrJFkw1+P6UhSyZWrlN6Cu+5MsxlBI2/jFOFKfuM1iAbAFU9FqNC
         Jf/G+SOmdydVSaH30LrduYU0OpmU9PzpyWRHI1d2mXSjUomNp6jT2y/KqVl5sfRUhA05
         zkMOUbKtcTKPo5f66HElfOXw/XWidZGktAJ3YE6EPeeSTNKhFPKeHbk3Y/4FhCTM8+oW
         QW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561036; x=1712165836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7bcARctp1mKnS/h6xHFyZebVDq6w4ScwaC+WjNc/L64=;
        b=wbRrNz31RBV4aElK3G92SqVz4ACqElSwTPziCIx/bgOXiToh1RQmSY9qUdoTMZSoSx
         FuTMRr4H4PJJmy5fea+XKlAu2oC+9IfxaJXx8klMlF4FJ11fvBZovRyGLOF68cSPYic/
         gNUCFW/wGzfCvoVPHobwfzcej/x+QuY0RGWbEYlQgc+O8wiOuklX/uuKMxafjkMtHtHz
         o78UuTmNb71XUaUWgL+vyoygM//vrXUvmohzGylpDP2YIeJdeXfjB2Dg0N15gUzNi7CE
         Iu0QCyMHkSEuiIWSQ+XfjhACgL/O7de4xrlTfcYaczIpopNHQerNqbir6rn3MV3TWNfF
         g4vA==
X-Gm-Message-State: AOJu0YwdtkvNG6MPu1JQxUNNr/6rN4oslbR8Em7hljgcAVnFhxNwgUmU
	t2+Hh4EcZp8bdGDhGQVufBpPLaCgFGLZDempI6vQHQyH4RNXCdhyajnfM52LDPMjIlaeKfPe29n
	ZQu19quOAqPlDvS9ePyC/aq9FPOeD8VdY8RbeC8upQzY5rGF9ygLRRyRR7QjuU8tOL1hpYPQriJ
	x5G+wlblTs6u2v3V72xt85CBQ++Ls=
X-Google-Smtp-Source: AGHT+IG05FTDOPLv4nGOvJ8KNZNVccBMrxn6jAe1uUzLPmejRqjhLrOUipyHKuEgtUrJWCrGxOWQWo7XPA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1887:b0:dbe:30cd:8fcb with SMTP id
 cj7-20020a056902188700b00dbe30cd8fcbmr64705ybb.0.1711561035652; Wed, 27 Mar
 2024 10:37:15 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:26 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-40-tabba@google.com>
Subject: [PATCH v1 39/44] KVM: arm64: Restrict protected VM capabilities
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 9cb39b6f070b..6e3c57c055d6 100644
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
2.44.0.478.gd926399ef9-goog

