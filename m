Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5397E101
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884810; cv=none; b=hzHHSn7E12EI4hCtLs4Cpr5NWsgV3RGNwtIdyzmMrjZ9yAz7MjNGzmkb3g7XNGriIIEPU4B6qFRHsP7ot8AHV+bjOycEz0Sg6y6J0FV/e2FBkZ2QWm55FDZeUe0RvKWoU/EVOrMqduOPt9JcSfPbfpOmakizHXOUHXrbv3/DFcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884810; c=relaxed/simple;
	bh=LtTsLZmEyQ38RkEpaI2WcInnKGr7V6SLBF5trKpLcMY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IkUoX1SnjqLz76PrBfWQUDyFLwwhYPnIgjELzWr2BwxqDqyesaHiMVcQq+MkrHsl5bjdD6FBl5KY+NP5C62m1RyO2Hf/6rRrT9NfInJfVzI81D5U7VajDjYUyfSMfMTwsmO62dhZH2qLW4u9b+bOKlIXlk66YpUunYjOWaDi6Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b/oIswJd; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b/oIswJd"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so9138065276.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884808; x=1714489608; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=93tIZsbDQ7aTB1Ag//lp+a36KMN6Q5Vbahl04yV5u4M=;
        b=b/oIswJdhz/IiQejoU3x6UvgxgM5jyRf8QgcLcPeVDjt0FP9+Ci+QQIvQZ33jiapjV
         GZgz7mjzokRSt2jIrSxBIGIUw+LmIUwobLnApXAi7j6nRUSeqJHar0lReWqilHM5hEa2
         3rD24p1+kfQ6juLw/kInbOj3gDhOf9qDGtnTUI3LY8fWee7vSYCYNg+7NOLFU47/KCtN
         AnC4VdKNSgiC+o4s/vk7oeQ2CetnIVKYD35nQg/FM3hbVZCSDjcmnTOsrnGNuVi+fwUv
         vvvHgL2cJD0lzwzULMWagGkwqizYZxF8zvlMc1Dx2rX/9lOCcCbiUjB6XkLQeHLo9AFg
         EuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884808; x=1714489608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=93tIZsbDQ7aTB1Ag//lp+a36KMN6Q5Vbahl04yV5u4M=;
        b=oc3c0yBeYBQqG2yY5E3yTt9Qk+CTif5dffHCaqfkPkk1pVV1z3P7BPmkZoGL6VBaaf
         7X7n86SWkjDUPkyJI7/z73F108FxpwHFyZGzBiDcihkLhw2AFInEVEOqsJJbcW1HpNac
         Tvkw0Ih+P3LmIRW7HEZa8nESH6LrdJscKrIQmvJ4dGeyJHYX9FyGNy2doKDuO7VU+BtU
         krXC2Z4C+EfVXgYGGpSkXac4LnnG9Psh+Jm8AmnWEk9zOn6s1m7awCBT3zZsHyAslqOa
         aSXUDavUA8YpdbjI46tg7uGm0HgRddoehoWkSDouSW/c6OEbtuUbc7mnxYdYM4QEwnpb
         LxUA==
X-Gm-Message-State: AOJu0Yz6uT35/alnDWH2y5wqEju9/jvlB7w5/mcMbXsSYy0dWsmFYzv0
	FZOKK/eHdgkC5EsEs/SLNc1QkiTGn3N9lAohfTIlI+2uFJkguj3tbbjU68YkvrhjALfp5DuKw94
	7VqUP+C06QrBCT16FSIT7e5czJPnIOYpDxDpP4pKZxvMa9jITIOGM5b6PwmAElYmRW0flQbM9wT
	XwE1eOViEUhzKrKSBt9oj8bH/POfQ=
X-Google-Smtp-Source: AGHT+IF3BGfAImGTRx2K3Bx7MtlcUeZG4nt+aXIobBscyZGiLwK6ZllinOOTUyjDlHLTIiYdB6z+AzwJlA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:725:b0:dbe:30cd:8fcb with SMTP id
 l5-20020a056902072500b00dbe30cd8fcbmr1031574ybt.0.1713884807336; Tue, 23 Apr
 2024 08:06:47 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:37 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-30-tabba@google.com>
Subject: [PATCH v4 29/30] KVM: arm64: Restrict supported capabilities for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

For practical reasons as well as security related ones, not all
capabilities are supported for protected VMs in pKVM.

Add a function that restricts the capabilities for protected VMs.
This behaves as an allow-list to ensure that future capabilities
are checked for compatibility and security before being allowed
for protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arm.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 647c81ebdb1b..cdda89378c63 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -70,6 +70,31 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
+/*
+ * This functions as an allow-list of protected VM capabilities.
+ * Features not explicitly allowed by this function are denied.
+ */
+static bool pkvm_ext_allowed(struct kvm *kvm, long ext)
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
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
@@ -78,6 +103,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	if (cap->flags)
 		return -EINVAL;
 
+	if (kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, cap->cap))
+		return -EINVAL;
+
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
@@ -250,6 +278,10 @@ static bool kvm_has_full_ptr_auth(void)
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r;
+
+	if (kvm && kvm_vm_is_protected(kvm) && !pkvm_ext_allowed(kvm, ext))
+		return 0;
+
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 		r = vgic_present;
-- 
2.44.0.769.g3c40516874-goog

