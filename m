Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A7E31C58A
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246137; cv=none; b=i4jBur365g0Gfm27unt0/7kzNwHQQOgGvvkSVJIFAvP3t0jVVMlboR5QGcR98U76hK6aHKLiAG4T/6XiPDIZqMH+WMf3TzAsvc3LhRrhf2cXCkwqRiK8+CRBZXKbTQIsT6SDfbq4x/leJXZnik/e0sxm+alCXae/YZfrmdM/0aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246137; c=relaxed/simple;
	bh=2fjOFd450U2t1qzpvNAbcTYPXRL5QGV+hMmRfvQNB80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uj0Q7MnvcAo/ZG179dIIPXRl/1ki7ladL6RU/R+y5U89NifYQh/nheczdoXTqeBbVA6lITF58Pp/Py0Nr2cZ4RZOtVDPFrGQrCW9OyDSQubQ4/Pe9nW62irtJo+AF/Yul1gDKypRL1PWcv4tAD6GRkXhGFaZYCNI5qI7bG6wP2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PO3u61YC; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PO3u61YC"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cbed2b8fso407758f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246133; x=1764850933; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K8t7JCSo1LSco+lfW6s2Jl4uvle1Dm+5io69ZjZFXR4=;
        b=PO3u61YC42wjZNJYzGr45CNX7iGv7OfvN3g1ZwcL8jHd9uHa4spzJIp4kfQZxcHqCU
         TR4tBrzTmPs2twOglyZ1GzmysWFwXca2nbtG09UVK4bmwhxoFPMmrfh57fUSzbpbh4mp
         8uyDBsrZc9yOtNySLO4lX4R9X0Wm0QUbgHAxytQE/LwzbqOxnuEBY8OM9YKVkszkTsrE
         9ekntKHYq2vv4Q/jAZamqLVjHFphRdyWwwYhgX7Nc91csOKg7mqsTBQGKYrHWQmFHFEm
         +/rOhX323eVwkH6OSrBtKHSvLCcNRfqo5hF5A+UsrWZgLZl7kTFomlHfP3PKfhvfmbDG
         +d/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246133; x=1764850933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K8t7JCSo1LSco+lfW6s2Jl4uvle1Dm+5io69ZjZFXR4=;
        b=XF/0tg6xxvo5e7o+2WsddTMgekOgnWscKnP1dVCUs12RlfP6myPXz47Sy1SR7pJsQC
         bkTsyrqMZNMyAXHzl9EC55kbUzLX40vkRZtiKNHlc39Rj3DfELFXKhUgmX7o1yhimHd8
         4oYa71v2G0bL27Hnw4P8dOmkV2Jzr/c9Miu0406zhsnR7JC1BzMxP/16a8Q8Nz0e3u7w
         /9fLku2sGws5TJMIHqECBFhOWsP04uJ2cyEnCu6LZ4YA1yFJO7AteVOHj8HTmY5Zs6nS
         QM1rxyAQmyaE4U905MW3Q8jeqOGSWZ7AEjz3gWAowIM8yFmCDpmfYaUE0vvhrXYJc7YG
         fnpg==
X-Gm-Message-State: AOJu0YztRIb/t2YywPbQ7ChzpuOfqoIZWSXxuIzaUmf3X4Hzq9hIBrJE
	iHav8rBK5OTov0UJButRHExE38TA+1Sp0+7AnLBSZnoRNeRt2sb9GnruE0ykJFOnncP5SmpLfgf
	sOC56MsB1J3ZFwFc1g/TI40g1EtNkFKAK8CZ02jbcZDtQic4Ls+/vLhzIeflEo7LdXVaz4aU1S/
	LGuSYh/geiFmBa8Rg3c9EFdOe+hPgufbw=
X-Google-Smtp-Source: AGHT+IEqSAdYc8YHjn0eimTFu8K6zN3jS5v9Ar+BYfq+408jOZe7QNhivJMHsv31TKVmV6tQ2R82jdCQ8g==
X-Received: from wmpx22.prod.google.com ([2002:a05:600c:1896:b0:477:a181:1919])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5491:b0:46e:32d4:46a1
 with SMTP id 5b1f17b1804b1-477c01c36d7mr211055005e9.22.1764246133472; Thu, 27
 Nov 2025 04:22:13 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:07 +0000
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-3-tabba@google.com>
Subject: [PATCH v1 2/5] arm64: Clear HCR_EL2.ATA when MTE is not supported or disabled
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

If MTE is not supported by the hardware, or is disabled in the kernel
configuration (CONFIG_ARM64_MTE=n) or command line (arm64.nomte), the
kernel stops advertising MTE to userspace and avoids using MTE
instructions. However, this is a software-level disable only.

When MTE hardware is present and enabled by EL3 firmware, leaving
HCR_EL2.ATA set allows the host to execute MTE instructions (STG, LDG,
etc.) and access allocation tags in physical memory. This creates a
security risk where a malicious or buggy host could lead to system
crashes, undefined behavior, or compromise guests.

Prevent this by clearing HCR_EL2.ATA when MTE is disabled. Remove it
from the HCR_HOST_NVHE_FLAGS default, and conditionally set it in
cpu_prepare_hyp_mode() only when system_supports_mte() returns true.
This causes MTE instructions to trap to EL2 when HCR_EL2.ATA is cleared.

Early boot code in head.S temporarily keeps HCR_ATA set to avoid
special-casing initialization paths. This is safe because this code
executes before untrusted code runs and will clear HCR_ATA if MTE is
disabled.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 arch/arm64/kernel/head.S         | 2 +-
 arch/arm64/kvm/arm.c             | 4 ++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce..a41e3087e00a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -101,7 +101,7 @@
 			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
-#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
+#define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK)
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H | HCR_AMO | HCR_IMO | HCR_FMO)
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index ca04b338cb0d..87a822e5c4ca 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -299,7 +299,7 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	isb
 0:
 
-	init_el2_hcr	HCR_HOST_NVHE_FLAGS
+	init_el2_hcr	HCR_HOST_NVHE_FLAGS | HCR_ATA
 	init_el2_state
 
 	/* Hypervisor stub */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 052bf0d4d0b0..c03006b1c5bc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2030,6 +2030,10 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+
+	if (system_supports_mte())
+		params->hcr_el2 |= HCR_ATA;
+
 	if (cpus_have_final_cap(ARM64_KVM_HVHE))
 		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
-- 
2.52.0.487.g5c8c507ade-goog

