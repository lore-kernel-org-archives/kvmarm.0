Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABDB26B0AB
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746461662; cv=none; b=j0HEds1SJsC2dLBaLczMAZQf/7mMbIK0B2ZRPodbIo+KLTAyyekeLovx4zfNW95XtiXGCCSS34rPqORbPpglSJX4+XTKhgRtpnW0s2ORF/FHr4oLrOJnhNcJZAqMjJNPuZKYiuPGiQTRzFmpB8mfGoplV4hbCyzdELq5IBgXyfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746461662; c=relaxed/simple;
	bh=WNmcRnW25SuTNW/fidnyuzaC0ufF7CU/QhzVlk6Eyk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hlFfrxzcd+UhRlzKy9FTHhl5wCnJ1WSQAH/ft7zSLBW96JnM3k67xPlxXfHuOJkzH8QSkkloIqcsEhut65t+F0F5C6mgfCjQjVRsi8mqE9JKql2bOVD8trmpoKROwyh/tAf30s7gaxsle8VY/R72uBxZOPx6HWuPu2mfxwneBmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vWLGtHQI; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vWLGtHQI"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2265a09dbfcso62048405ad.0
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 09:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746461660; x=1747066460; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ih0/JpStngeu2lOMQmMMElA7ojSkXNH4xy6u5tdpksc=;
        b=vWLGtHQI800FxMJXUFIS9DlUbdhwWwgsVIsgolRuE6Pc2CeUTI9uRloKUM9Cx5nOVW
         cuPFTStAnPp0XLAr3nBP2vUVjJjyDs8ljacqvNOJOZYKPIVCil1dyb5GPvXNLfG9eGIy
         BINzAljIsAsxRvVeZClvScMDyMSYlFHDiZO1cHnBfvJwOPisnKdg+inlmyWImM5ellta
         D8BS57uXskMUajGyzTEYvS9CVbMdzJ9yR8kwFMzBN4W0NTC7CSc7dpXYcsXZ52dQM6kY
         u7aQ1trwtKESS3jx/LLISLGPseCpMsEL+dPAwFp1ez4kuga6YuT9xQ80DUbV7qXLHgPt
         +WEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746461660; x=1747066460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ih0/JpStngeu2lOMQmMMElA7ojSkXNH4xy6u5tdpksc=;
        b=dUgYuwJMCFuMbDBvLng468Bf/Nmquh2/pn0YU58sjHSghDby+je6UbFLBqldRRuYOI
         vUMOiPAp2qsxbiz+EQlcYvQ6oDzE+q6fzBFqNsKnSEPgbKo/EOLZv/yGk52QKRWRuWn8
         Bv5fqL5Yk/VXi0S3/I1dqyJyZCqpT/A4zoesDeUuUjYHRwmVoCyHVAUFqL3KgEDChQxy
         7SQcvZ4PxwgxTCbegyKHBsKgawm08pDsidxiz4+dAuwqaXDin4rBLMDgvVjLRV1fdCtl
         U8OUtBx4PZdVUV8w3vRqMJX1BCIXhU+dytWujM+JcP4E8MpzfqlnIPGI06P/3aEyFTer
         7Rtw==
X-Forwarded-Encrypted: i=1; AJvYcCWFvZjKJz2Dumt1K3Pha15gFQfuoSkp13bGdW5CD6GZ/cpOraRIQt9WFGXma8JfQJRYic6B9ag=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmN1i36l5iu3P8j/CE3fVflMWchJXjYOiESXWXmUjQCcoLm0dU
	ekh0iDCFAdEQiMpzOu4C3NoxmMgln1zr2IeGfUghYKQEahVhXXdiHb9qEsCWEMmSseI7cUQJAU8
	qCY4Js7fbuw==
X-Google-Smtp-Source: AGHT+IEALx06q4ifLBOjCQ9ZZOZ/gQJWNi+Q92PHdvJDeENKCM2QDj0Em0rsjG/Q7RXdhODS4FzwytaIsf6wMQ==
X-Received: from pfvo15.prod.google.com ([2002:a05:6a00:1b4f:b0:73d:b1c6:c137])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f683:b0:224:f12:3734 with SMTP id d9443c01a7336-22e1ea87368mr99744415ad.30.1746461659950;
 Mon, 05 May 2025 09:14:19 -0700 (PDT)
Date: Mon,  5 May 2025 16:14:09 +0000
In-Reply-To: <20250505161412.1926643-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250505161412.1926643-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505161412.1926643-4-jiaqiyan@google.com>
Subject: [PATCH v1 3/6] KVM: arm64: Allow userspace to inject external
 instruction aborts
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Raghavendra Rao Ananta <rananta@google.com>

When KVM returns to userspace for KVM_EXIT_ARM_SEA, the userspace is
encouraged to inject the abort into the guest via KVM_SET_VCPU_EVENTS.

KVM_SET_VCPU_EVENTS currently only allows injecting external data aborts.
However, the synchronous external abort that caused KVM_EXIT_ARM_SEA
is possible to be an instruction abort. Userspace is already able to
tell if an abort is due to data or instruction via kvm_run.arm_sea.esr,
by checking its Exception Class value.

Extend the KVM_SET_VCPU_EVENTS ioctl to allow injecting instruction
abort into the guest.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  3 ++-
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/guest.c            | 13 ++++++++++---
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c7..643e8c4825451 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,8 +184,9 @@ struct kvm_vcpu_events {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
 		__u8 ext_dabt_pending;
+		__u8 ext_iabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[5];
+		__u8 pad[4];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 47544945fba45..dc2efb627f450 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -319,6 +319,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
 	case KVM_CAP_ARM_NISV_TO_USER:
 	case KVM_CAP_ARM_INJECT_EXT_DABT:
+	case KVM_CAP_ARM_INJECT_EXT_IABT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2196979a24a32..4917361ecf5cb 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -825,9 +825,9 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
 
 	/*
-	 * We never return a pending ext_dabt here because we deliver it to
-	 * the virtual CPU directly when setting the event and it's no longer
-	 * 'pending' at this point.
+	 * We never return a pending ext_dabt or ext_iabt here because we
+	 * deliver it to the virtual CPU directly when setting the event
+	 * and it's no longer 'pending' at this point.
 	 */
 
 	return 0;
@@ -839,6 +839,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool serror_pending = events->exception.serror_pending;
 	bool has_esr = events->exception.serror_has_esr;
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
+	bool ext_iabt_pending = events->exception.ext_iabt_pending;
 
 	if (serror_pending && has_esr) {
 		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
@@ -852,8 +853,14 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 		kvm_inject_vabt(vcpu);
 	}
 
+	/* DABT and IABT cannot happen at the same time. */
+	if (ext_dabt_pending && ext_iabt_pending)
+		return -EINVAL;
+
 	if (ext_dabt_pending)
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+	else if (ext_iabt_pending)
+		kvm_inject_pabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 
 	return 0;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 79dc4676ff74b..bcf2b95b79123 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -941,6 +941,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
 #define KVM_CAP_ARM_SEA_TO_USER 240
+#define KVM_CAP_ARM_INJECT_EXT_IABT 241
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.49.0.967.g6a0df3ecc3-goog

