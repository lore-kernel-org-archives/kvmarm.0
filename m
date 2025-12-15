Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D44B338902
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 15:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765813538; cv=none; b=s1KCzAoShP8v5yOmd/JzlbN/VuopAowQ5NZMgn39QnQsz7BJFlkCRb8ml6RHtV2EGO/iZ8swTsO0xKyK67YC/tbok4PeIyPI5RsbXOWRQYnYyKRyf4bwx14miDdANANwVARYYEnlx2v7a4Cw+RAWb/eqm5WziAzABzT6sPf5Dlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765813538; c=relaxed/simple;
	bh=H+BYPeuC46/cZwkzUGpKRp4PEKTMr0g8kH+Bp2Om/eI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A9Y1YSSH+TQw0zgtCbTTngxDtLNjNv7MdmSva6zGLcWj+vNW7VZHfRrS+KpEXga2eV/oeWySscy1ZjLksU4AlC5Xgkbj+/LSctlYHe2BewyXUywRgrDMErUpab9TV7zL+SHElje6AMHTqtWb1kMW2E55oIqyG4GHjzSLNQLXpc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jMUFYnZs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jMUFYnZs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779ecc3cc8so25643645e9.3
        for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 07:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765813535; x=1766418335; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=jMUFYnZskaehP8SuXxQFLAyyRq7jxlaJTudUKgP/s5o9tlVfpEo8mfwCAG0E4BiP3j
         uS+nqDcqFtlJT9P8w9HbNDttHlQaefE7QRkkbYR63EYSZegZH1ioVgxZo7FqqcBKiIdH
         mo+6Mlk+c4DcZm9kGrj3H1TDekCK5lcKOjO8Y641O3uYaPqgssJIiC+rub3j2BekDEpE
         H3Q25wNp4LTYjt9bccrv7XXbhysZfjsOsFcYkqbEuWLNTjXIzpLDagb3B5NSchC3ePrU
         jAfRT/iQY2/8JXGeNEyIG015o+94LHVT71wU6rlwoVplcsW0LId8M52kwjgev1bcSbSM
         E3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765813535; x=1766418335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rkHSL25koHVDTaMmCRcby8S1CrLCFqcfDXkn0dsUTFg=;
        b=TXch/WCB/PNqUKWL/UWHef8FAMya6+IgEavO7QRgovDKLijHtnyzcCN6U3gIem8L37
         Wo877zJriCj9Xtp5lFPgo2SIFwLwVQtHiBGf7Larn7En4yR+owt3Q7UqJIz7IPhlGkge
         v5/8kIhRBri5tGFlXtupaIzydnhJjiAbiWNEqImed7FzjarmkBNdqL4ONtMpTFuQSfqS
         Lg+4dcwhWffiFRIHUaizrvcnfM7wWJl+rMYeVu2MCpbEy1KljiYPZl/rQ6NDLXHjmS43
         wCELRt15M/IHELsrVPr1S5rrKdwPXG24O5BuT5j/lylnywqb3UHrEIFvFOvQkKAUec7r
         i7gg==
X-Gm-Message-State: AOJu0Ywy2EqzidIhl1w6dZlIEnZHKMIusSw9GCVDKnbDivIqQEik2Ecw
	/+XiP433/DAgjlYV4V56ssc69+HqwmF3cwRL6SYrvy0cVDDwtceDtzYVPng1v+MrvMWaIZTOFz3
	+gphK/RpH2aNFdt6kE/885q4G6BbxmozDKnf/KeM/nYcSbAJbzUHKJw6s3DGQMPEUp2MT4q5PdC
	DZWe6SvAQDwk4QfxR0Vvvgu7TOpbdGjPc=
X-Google-Smtp-Source: AGHT+IHygSESsYK4RUtj/wRDvzA17kzQXBviuMSGq8fm5KlzkeMm8FFn/k6iIvMKHZM+3w1EhOwz9LhhWA==
X-Received: from wma11.prod.google.com ([2002:a05:600c:890b:b0:47a:9505:f0b6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e8d:b0:475:e067:f23d
 with SMTP id 5b1f17b1804b1-47a8f90e531mr112398205e9.25.1765813535012; Mon, 15
 Dec 2025 07:45:35 -0800 (PST)
Date: Mon, 15 Dec 2025 15:45:29 +0000
In-Reply-To: <20251215154533.3154405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251215154533.3154405-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251215154533.3154405-2-tabba@google.com>
Subject: [PATCH v1 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
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

