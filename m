Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C803ECBD8
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080945; cv=none; b=P4pGYxrdKx8QKBz8RbK9UY6tnZrS308Yse/R5vu+J6nANN4ddfO/NdpD+L8ceoP8utGqy/0XnryeDvJMQtcZ9gENbBUy0Om/n9flGgIQQFPCsF/48CbMSNEbt+mDFwjvDYUv7kKc+FJ1Gm2x91WQGsZYFRyJkHIRQcK6OoZFK+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080945; c=relaxed/simple;
	bh=AFDNR9MQSw6tKC05e/O2QNZA6nlRYNoQOpO2C2wQWL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PY9OqivgYYG6lJWcNR45Xag0j0i4AIcQckEp5UAJz4NJK8PX/p2nxOC06641HaanoSwEj085UGOJKkvAkYkLoxGVUBYlr6LrYjdK9sqJPNN+RNAujMxhSNGkF+xikVZ01Vm1MRCYngkhOMw1qeoYFTs3DxLpkTvFrpkRp9Xwj/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ksVTMbO; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ksVTMbO"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-42fd46385c0so526481f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 03:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769080941; x=1769685741; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+k1LmUzPe66jfGdVIo8KvWNogHSOvBXaX+ewOgvEHqk=;
        b=3ksVTMbO2ic9brIx/2NuEB8UpnuRZak9KAmSZFGZZ7+LlM6pLRr+ZhJs4rOlRBwRSY
         uTr4iQra1b4IcOKRk2u0SjqK8dFpe7qrXVlT038hqEXf91GXj10vgvJ2qk/PusNM29P7
         ctpEsoOUCf+v1o56NgfrE6Gl76KRt7rmF4AKyqTVp6v4E4zhM2VXCKdb+J0kG8Nb4iXW
         akjBzz9Hsj7kEG5UAt+0RzHUojzFSueu5E7F87mDJS1Nq//EgfKYe7fRPQWvlx88LGV2
         fs6mM36wZngUbXoRMNKQOg8aceGF3QEqpanyi37FuY1hDOVbkCXKWvSjZDtsElJisMvK
         hG6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769080941; x=1769685741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+k1LmUzPe66jfGdVIo8KvWNogHSOvBXaX+ewOgvEHqk=;
        b=Sv9sG+BMj1mDdnpH4+qfybmyFrGa+YuEoXqj2sV8bCPX3Yfi6QvOeIDlk6J2kww1p8
         Uem+N9yKdd9MdlvxtgXM56jM0gituJkVoizijwIMip6dgQZM1ZD3A1tGYz+1ybX1nEsG
         JT+bZ8yS9t6p8isYmMieDVNfLRKs7cUT6TqEBfUxaiZhd9nfpRra792TrIp0nY0aW8kW
         jImXp+MeQi6Mrt6qgfrmGcikRpp+BeiVTzxNlTKjKJ6F4zeD7FmKBzjsyd971lQYNfWE
         SN27HN5NVcpRGHq04nahaPno0a2t+gYPgGw233CaCBYHAqvDGcXgAA+Ga7li9teXdvLz
         jE/g==
X-Gm-Message-State: AOJu0YyRkuYm0klroJS/qvwPSZw1vyv+ATBlHH34E4RqYA+3vq+I3LmU
	6LuW0fstmZG+j5C8tieouNU0qKHqfQNd6hbXb8kdry31bDS5V6qNRME2MRXFx0kyqEDAFZU2BTy
	t8a7NTvhdLWIOs+aun9QBO4/BeVFxpUOfa+fI6cLW0uVoauBa6S1dA9eiJrknJNW45CWXACRd6g
	tcNjTnX125gf3l/H3KPEnsg17K7p2BMcA=
X-Received: from wro14.prod.google.com ([2002:a05:6000:41ce:b0:435:9760:a8f1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:48:b0:435:729b:c390
 with SMTP id ffacd0b85a97d-435729bc399mr20497315f8f.47.1769080940774; Thu, 22
 Jan 2026 03:22:20 -0800 (PST)
Date: Thu, 22 Jan 2026 11:22:16 +0000
In-Reply-To: <20260122112218.531948-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260122112218.531948-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260122112218.531948-3-tabba@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Trap MTE access and discovery when MTE is disabled
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

If MTE is not supported by the hardware, or is disabled in the kernel
configuration (`CONFIG_ARM64_MTE=n`) or command line (`arm64.nomte`),
the kernel stops advertising MTE to userspace and avoids using MTE
instructions. However, this is a software-level disable only.

When MTE hardware is present and enabled by EL3 firmware, leaving
`HCR_EL2.ATA` set allows the host to execute MTE instructions (STG, LDG,
etc.) and access allocation tags in physical memory.

Prevent this by clearing `HCR_EL2.ATA` when MTE is disabled. Remove it
from the `HCR_HOST_NVHE_FLAGS` default, and conditionally set it in
`cpu_prepare_hyp_mode()` only when `system_supports_mte()` returns true.
This causes MTE instructions to trap to EL2 when `HCR_EL2.ATA` is
cleared.

Additionally, set `HCR_EL2.TID5` when MTE is disabled. This traps reads
of `GMID_EL1` (Multiple tag transfer ID register) to EL2, preventing the
discovery of MTE parameters (such as tag block size) when the feature is
suppressed.

Early boot code in `head.S` temporarily keeps `HCR_ATA` set to avoid
special-casing initialization paths. This is safe because this code
executes before untrusted code runs and will clear `HCR_ATA` if MTE is
disabled.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 arch/arm64/kernel/head.S         | 2 +-
 arch/arm64/kvm/arm.c             | 6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e500600e4b9b..752e3e1604e8 100644
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
index 4f80da0c0d1d..aeac113e5e74 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2044,6 +2044,12 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
 		params->hcr_el2 = HCR_HOST_NVHE_FLAGS;
+
+	if (system_supports_mte())
+		params->hcr_el2 |= HCR_ATA;
+	else
+		params->hcr_el2 |= HCR_TID5;
+
 	if (cpus_have_final_cap(ARM64_KVM_HVHE))
 		params->hcr_el2 |= HCR_E2H;
 	params->vttbr = params->vtcr = 0;
-- 
2.52.0.457.g6b5491de43-goog

