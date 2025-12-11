Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F462FC887
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765453114; cv=none; b=U7Bd2vEy4tvFst3BVON3U1kOiAquusLWghZOIYx36BjeFs/dpFefaGKRtFQ9GN/zqo/6oKtHhNijKDkrirFRQ8fI7Fa083ug+iuiM4D9TVCSPwocvxyae/YBLySOQBvTgq9Fv95+PxI0dBJ9UXhy1irhcW0y3g3ShmCJW7I8B8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765453114; c=relaxed/simple;
	bh=Yo7CU3gKprYx5fnpslhRHqCG3PUyUojyR1vEJUouLXo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BY7vu/AjWdkfJZ+9XNhMtmeBKTczN1bb9QzkdLYptZFVQlYM4+WV50HAz41M3RIsit9cfIFczSuzHpG6NQ/3JfYWBHH+39TYzGFjA2NOWJAnYwjGGsEYHA8wMyZK45GwaqSfPe3mxrXhJGsS+BcT1+y55lHrpjFj6aDoQgkwnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VxR+kxgC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VxR+kxgC"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4776079ada3so6438485e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 03:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765453111; x=1766057911; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gs+Q4zsHPmfn9d2bK4NrhKT3oLA9uDx+1JwH1OB2RUs=;
        b=VxR+kxgCgknQq3TQYoyo9cTnWglMGE/FkhqtaMXKwk+8KRfOHXPXKZ239EKRLQPfQf
         YghKc1MA92cnn8RND5XPIBtKEKyrxRoHLdJeafWXIalZygzbGQUe0FlmBIlrMh4lNtOr
         IZj4O5F4hhtx10y3LtMzKRlfjr+A+c4hR4RQ4CulFK0c/HHqCch0WPDxW9jmgZICOLYf
         /+lFl+DLhCotwkf+8JP9t99ktb4IWJqNoiwkIyPmiyEfu4FQOLS1o/bg63SodY8ThPP6
         ZSiuM9qhDmoHwnyX39IYLR0vilCjWhyNAyjg/ik6C336g7nX8pkcTyzilV00DovMy9F7
         LevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765453111; x=1766057911;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gs+Q4zsHPmfn9d2bK4NrhKT3oLA9uDx+1JwH1OB2RUs=;
        b=dXHhL/NsMdGqnV5kNHsmkAulLkUqZ6Zz0Oagg6HzrEU1+41CWioZehFbc8TS1mDxWm
         e9onPwdr/pCAB8wXppczQUV9MC0nOya3W0FdgqxkruMKV0o/cXQAZxyHxMN9vTBHEx0g
         EE2rCKu7H1WVBNCgr742iPetbvD2zunwLjMp0OButc//2a0fURU1vnIeOZkSaHQONM1+
         Ota4p/0k/0FaRKOx4T3XlQv9wOMDTN8Q5ImPxHBYALswy5/lHTzfBz5049/BN2ODsrGr
         NK/3TDgsKOlYsmNbvAY5KIptSve1fCOk9cVILvYeEXAQlIb7BHeM0AIfbmQkPTIXfxFN
         31ZQ==
X-Gm-Message-State: AOJu0YzUV3BT/eqc6HCoDX+ErB7t3sqOwPlx/Dz8xkDb71pyZUijzNDL
	vIj8uslPdIlb/JIiCrhvDwVVCp/CTY0tmi39kBs7ZtsMYJWl/7P/+HL8jNHNezvK2qNE73iW58e
	9bR1dYFJ7ssIPc+yk4KI0amavrFdMUpBszs94wRD0aRSZBx0kdS7rjNfpDH5SWnIqPEwX2s1y26
	U9gJKokKoMT10CEn5PnIZ6E5tXTsGEg4k=
X-Google-Smtp-Source: AGHT+IGPJRiGq3R7mZWn5CrzLP8vm1wupxaeI5H/gIQqF11dMv1/zMHsAynG4PMZbWmvXJ3VunNPyr+QDQ==
X-Received: from wmcn8.prod.google.com ([2002:a05:600c:c0c8:b0:479:36b0:ff54])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e88:b0:477:54cd:200e
 with SMTP id 5b1f17b1804b1-47a837449f7mr53974875e9.1.1765453110985; Thu, 11
 Dec 2025 03:38:30 -0800 (PST)
Date: Thu, 11 Dec 2025 11:38:25 +0000
In-Reply-To: <20251211113828.370370-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251211113828.370370-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211113828.370370-3-tabba@google.com>
Subject: [PATCH v2 2/5] arm64: Clear HCR_EL2.ATA when MTE is not supported or disabled
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
2.52.0.223.gf5cc29aaa4-goog

