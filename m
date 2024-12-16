Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836921FF7CA
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346291; cv=none; b=SMsrIp2OjbMoQySCzoElqBuhwBKTLUI1le9xnLGlop0j5tHLoYgCp6XR2G/9NC3fhjd5u+6EVpKAyWKZbwALuE8jT0JfeA2bAr5dDwn809bMNmSKId8HXXoRTdDDeajND7Mq23EGBAcGCy+/YGEoEcX6g2oxhIHlIMf78dbiP7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346291; c=relaxed/simple;
	bh=rRJ/GpKPCOg1fmZRJ6G4U5yW8065Jti4yOFmPK8Z4hs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F7hr7A+v9hse7+0YF/C92s+EWWIfGleJgOYX04RkFyjdedSReDHpQcLl34BRDP6gH/Tp/VoHVBAnws8YTvvdV/eIWSOKE2rNy9LHDEbWz5aSovayNEioCQa9AQ2q/BtamDFyMTXN1rRXpT44cwzorZvQP05WHojgM4WFUvqMoHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuDSWSxu; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuDSWSxu"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so21742745e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346288; x=1734951088; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FwAl12lINzUU1wjJNYXv+mjPrnLgBSqMlCHa0SUHO+Q=;
        b=yuDSWSxuQomGDj1j75rqoltdeZjOI6TMs7Y4rVE4jTJwd9ZugzODWtVZn9Ts9HNYMq
         HP5x2vUeVW51IT/YCh37x8dKOngWQmgsIswqTXUvuT+CZPJfsB6PQNw3a+gY7sgVYfGq
         LVnDGXgvOe0OeBUsrUp1NokbT6m82BqXuTGfpnQdTJk6sAEy8qaf29fCWX0ZknJh7Gwl
         nkMYWPz/GYBQD88snmFztM9kNn3LLDiXBJGhafDtLyyJhzUaAEEB7z8I1UI4hBK0DcBg
         I4pHlmMJX3uoQGX5ATXi7Cl6oEEhKeDX4E13dgHPasGghl5VYNMICZlaWHFfL05p8T8m
         HZ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346288; x=1734951088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwAl12lINzUU1wjJNYXv+mjPrnLgBSqMlCHa0SUHO+Q=;
        b=AnaDG61F/aQZFLO7cQkU6gCe8Tusx/IxqEyxUZFNu8IMmXJCmnH4mqSmSVLAPCP+wZ
         9zFHtJzZTvxxc4cjsSKU87ZDKxEKObOBKE+I+61kBCXunxwr78wAVOtwYKN/Ch0l0mo6
         fcfX2b2oWn/KYKN+v+2SmFdyMGsKn59RpPztRUrLIbmEmm2RxCbCyYkRPnDE1E/0qHNU
         OemT9WgT4igoMGQkEMNU1jawjt+6UbvimMXELmUWRuXcNM5gSOs/eCAJQ6YuP2+zujS2
         Sk+NB4hoZUXP4yQFUKA8FnmdL8xopw9r4vFxQESmFIDxVtZU7xecaBSLmO32PynyYU07
         VLdQ==
X-Gm-Message-State: AOJu0Yw6OtWNyn2ZgAqGAhFYYyJ5VjDbFmqBcarTZAXyySyCUufWLb0z
	FLMba6bnJYb7Y7bEciLJOS7OUF58afvbyH5Xj3OaixBsOHlxHMFMOd57X9MujvV576uqGKrBqJc
	4wsY7TG2RQwluRz8HHABspzY0mcL8rx/vBDroqNE0q8Ek4yAHdD46w1oAOYz0RZgb7V4A6n4lzJ
	IGm9pmcQwUiIueL9v8TkuD4z1cns8=
X-Google-Smtp-Source: AGHT+IHvIhoF+Aau4bm5gA9Mz1g4N0pfL3X1qn7U2qQUMs8ckEf3EvzkKqxsm+/X3rwMvyZosSwYUFQeDg==
X-Received: from wmos10.prod.google.com ([2002:a05:600c:45ca:b0:434:fa72:f1bf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:b99:b0:434:9e1d:7626
 with SMTP id 5b1f17b1804b1-4362aaa50d7mr99950255e9.25.1734346287862; Mon, 16
 Dec 2024 02:51:27 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:54 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-15-tabba@google.com>
Subject: [PATCH v5 14/17] KVM: arm64: Fix the value of the CPTR_EL2 RES1
 bitmask for nVHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since the introduction of SME, bit 12 in CPTR_EL2 (nVHE) is TSM
for trapping SME, instead of RES1, as per ARM ARM DDI 0487K.a,
section D23.2.34.

Fix the value of CPTR_NVHE_EL2_RES1 to reflect that, and adjust
the code that relies on it accordingly.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 2 +-
 arch/arm64/include/asm/kvm_emulate.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3e0f0de1d2da..24e4ac7c50f2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -300,7 +300,7 @@
 #define CPTR_EL2_TSM	(1 << 12)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
+#define CPTR_NVHE_EL2_RES1	(BIT(13) | BIT(9) | GENMASK(7, 0))
 #define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
 				 GENMASK(29, 21) |	\
 				 GENMASK(19, 14) |	\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7b3dc52248ce..6602a4c091ac 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -640,8 +640,8 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 
 		if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
-		if (cpus_have_final_cap(ARM64_SME))
-			val &= ~CPTR_EL2_TSM;
+		if (!cpus_have_final_cap(ARM64_SME))
+			val |= CPTR_EL2_TSM;
 	}
 
 	kvm_write_cptr_el2(val);
-- 
2.47.1.613.gc27f4b7a9f-goog

