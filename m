Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8FD341076
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765817521; cv=none; b=VATPf4Qkm+Fnky60mLRAXg+DbvArlXuiCegAxOSN8WXXOYB3qARU0MbyufZyOYMAekGmdelHHam16AzdWoZki2sE5kLcq4M6kI5O6/QMU0WcZvruKLldI8o9UuSRKOZ4Bb40qRCNKKkpyYXvduoZC4jZ4t+FFLfR3bpswEoOMP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765817521; c=relaxed/simple;
	bh=H+BYPeuC46/cZwkzUGpKRp4PEKTMr0g8kH+Bp2Om/eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sdva1Ow/7zY0YdYDxVL47LPNhL8oDHvCYgeDGamWLQEjV8p+1mieK3w3NzdfdFNcgt0zp3LTbXapSQjHKsdn8ZMvKEA1VHTnDty7f5ug8jCtr9gcdct/3KwyVVG5TrW4UHmcJGVmuubzdqgWPkDjaybuq+t6NdlFvCGGmfg/tRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q6DRbE6I; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q6DRbE6I"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6409f6d6800so5335175a12.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 08:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765817517; x=1766422317; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=q6DRbE6I+81tfP9FMZpgrhQYtcWAtSO4Q3YjobJyY5Ix5DaP5FabybKIv6Ht/QMGln
         VloKv6A6J8dsLik8XqubQDifw96G4NTj3DEz3GRqrgIH9H0Na2sVXcST+nO4EWjRMF7G
         xeYgTtFOr+WjQz+YoyxnN130FMxxaorc3fc5Fidu/2lvJkYE7XaMZ7sA4zRytECZVrQg
         ZiGY/DzCSfJu9tuzs9qPhAG/dVPsAbMjFWRyaFttG4bXTIbKft5VRn0ceku6fRsEs2mv
         yU3HvAub7KWKwV10POg7taF3zBbaGeaCnnoeP/CYnqnLIWf4rLRLSWXErODR8pdGUz+i
         n97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765817517; x=1766422317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=gYqrf1G69TEhQbIBlkFcnD7uF7Vl17kFmVwFKiT18iaCpIN4ohVfwi0BByEn+DM1QC
         ASf/09c4qYZtniGiONS5JfCI0qYUc9+6rGn1H3QHl7RpDBbaM0aRcf4dqTzZe/SAHOOh
         lpZONDL90VN7Ke18kBHO8qODHXQ7acN3WqOheU4KOgmZ0+K56Xab/yaQtU1MObK6+sQN
         7rPRk33w2JuXpGNrXzVKxCVyED45svTGo6DABRG4IDl8vKjeAsGm4Yr8kNEw5PktTEM5
         87xJ6xBnhUY7mA4IJfV8i+HDxI4UT4/I5ApfyTMavgomQACJzOnT5XlNj+obcUnqhclK
         18Dw==
X-Forwarded-Encrypted: i=1; AJvYcCXn/tJ13em3JWFmVGLE8zBDkxros8RhTXVfrzGm0MdeiKkp6X/tKB8DtfyDMWJHRmb0jXqZmU4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs9V9vZ3XjH4e9WklxAu2ylKeRbcr76LjZtVuy1UnL4vSvUr22
	xb2SNw6S6/J5KoMh064DS+KkSAUBfmH+KmBeXLxHB7rcS/NpJOS+7mAvUp7kzRCS9ZUh2uYtKOS
	t4A==
X-Google-Smtp-Source: AGHT+IFrHxiEYHDjT58c4YVmrMD5eO1DrDlCmV6f5ukjJAbXvW2Vssi5+5Lw36DE9YHOiX+0KsCF3RMJMA==
X-Received: from edbdk5.prod.google.com ([2002:a05:6402:1d85:b0:649:1567:4ee3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:d08:b0:641:8a92:9334
 with SMTP id 4fb4d7f45d1cf-6499b1301b7mr10482727a12.6.1765817517246; Mon, 15
 Dec 2025 08:51:57 -0800 (PST)
Date: Mon, 15 Dec 2025 16:51:51 +0000
In-Reply-To: <20251215165155.3451819-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215165155.3451819-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215165155.3451819-2-tabba@google.com>
Subject: [PATCH v2 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

KVM selftests map all guest code and data into the lower virtual address
range (0x0000...) managed by TTBR0_EL1. The upper range (0xFFFF...)
managed by TTBR1_EL1 is unused and uninitialized.

If a guest accesses the upper range, the MMU attempts a translation
table walk using uninitialized registers, leading to unpredictable
behavior.

Set `TCR_EL1.EPD1` to disable translation table walks for TTBR1_EL1,
ensuring that any access to the upper range generates an immediate
Translation Fault. Additionally, set `TCR_EL1.TBI1` (Top Byte Ignore) to
ensure that tagged pointers in the upper range also deterministically
trigger a Translation Fault via EPD1.

Define `TCR_EPD1_MASK`, `TCR_EPD1_SHIFT`, and `TCR_TBI1` in
`processor.h` to support this configuration. These are based on their
definitions in `arch/arm64/include/asm/pgtable-hwdef.h`.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index ff928716574d..ac97a1c436fc 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -90,6 +90,9 @@
 #define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
 #define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
 
+#define TCR_EPD1_SHIFT		23
+#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
+
 #define TCR_IPS_SHIFT		32
 #define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
 #define TCR_IPS_52_BITS	(UL(6) << TCR_IPS_SHIFT)
@@ -97,6 +100,7 @@
 #define TCR_IPS_40_BITS	(UL(2) << TCR_IPS_SHIFT)
 #define TCR_IPS_36_BITS	(UL(1) << TCR_IPS_SHIFT)
 
+#define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_DS			(UL(1) << 59)
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index d46e4b13b92c..5b379da8cb90 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -384,6 +384,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	tcr_el1 |= TCR_IRGN0_WBWA | TCR_ORGN0_WBWA | TCR_SH0_INNER;
 	tcr_el1 |= TCR_T0SZ(vm->va_bits);
+	tcr_el1 |= TCR_TBI1;
+	tcr_el1 |= TCR_EPD1_MASK;
 	if (use_lpa2_pte_format(vm))
 		tcr_el1 |= TCR_DS;
 
-- 
2.52.0.239.gd5f0c6e74e-goog

