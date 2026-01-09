Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37CD313532
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767946953; cv=none; b=Vdg1VpDZbe1wAD52cShVr1PLCWlvqPWsZVA+Hfq6jpopU2MbVvQy4p6dpitutdDjAqGbKOJSfzqxqhEC865W/xvF/g101/jELqFzGuCkOG82NblDbDGGw4rcEUzXi61EI9bCfWR242YAWgjXEeW0kwRdGHsOQ2/P5j40BAqRqMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767946953; c=relaxed/simple;
	bh=a+P8IDuXmE3XGEoH5ksrNZ5ogpqK5TTuuqzWjToyeZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bMnsqpnDr4kEwk/NftL1ajHmwlbKZ7IZr0kvcaqhCHjsqEV0Va9QWOaUCMsoygAcrSO+hhqD0/Be0QjOz81fWqQeXosCaHlcKNu1prXq038pV5ErlyF1MKGurWvyWgFhvGwmY65+R7pMJB7K2Afu+Ss6gc9M0FkM/4uTaJBRjng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bydl1y9U; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bydl1y9U"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fdaba167so1949580f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 00:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767946940; x=1768551740; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sYmtUt8Xl9FkSFC/XVvZCPE49zR2Dt2nIyVImhULnc8=;
        b=bydl1y9Ulqik6SI9HolF2COeD4nMClgtDVdic0Iy9H8IWFNEUxB92Fvh0NG+yfNbgV
         6PMFyuKRZE2ya2uC3GIzWeyyGAQ3YGFnMnPlsxbpLsdNprFkEfETTsCIW80DEZFwZtJN
         H3qu0v4xX8W/NDEgxKx83MQTyQdtcVqM1c2+/tGV5hr+IQLg1r/ybetaJzb50XEsmpAv
         Wp4O/PPxAJuU7I7z1CBCXQ99CLDq0dp05mNk60gf8oInSx18w9YCSY3h1lCPAITVbDLq
         rRkRjxkiY0nfns6UnlQFdVj+1F7r2eiBbRQIR7fu+yX5mgwg6ZGB8O0gnGRrP2RXMeDh
         mjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946940; x=1768551740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYmtUt8Xl9FkSFC/XVvZCPE49zR2Dt2nIyVImhULnc8=;
        b=Nkyaka1wyyYwkWbaWmDjk/DM71PWBnFfvyVLATaGxdJH4ARHGepHHWxeLGj2iUI5aZ
         6AnhTkDXaYZ45aSMrdusR0HiBLbZiz4byxJhvST4Llh6GnDCCk3l+kUUnBmC4KVoM0lM
         09+dnvvFnJ48qO2scCUWoZygiC5iKjfkqXHsg7xDYRoJ07rGcy3letCwRSNI2oGxBISg
         EMipymv27I+588HjP0ixwzLuts+FybuZ1hTw8+Sf+xe7ddhMQFKkEjJq2nRYwBx0JuEx
         6BG6IGfbQ6JqPkDumPb6ruJnu87I2kwtCoTWXjtV9yCVMVA/x4z6vIvRRaCZX1No7+FC
         WzXw==
X-Forwarded-Encrypted: i=1; AJvYcCUHIFFiSTqDTiAB8Zmo7DM1Ds8oqw7nb4d8VK5XfIokKclwm/Wg+Sytq5VF8Wtj2J7+RqDydyU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDZcehhnDDMR2tgZM7Bd5KdJ+gIP6kNs8NmiLYFPT0bQ1om6LH
	P0F1W2Aj1vIOoIw0tyCP8a6Di4+REv8fSoV8qtpuZJEwQiYaISzhftLmcpbR8Yqw9VytUVix4Di
	YAQ==
X-Google-Smtp-Source: AGHT+IETB7LrDsnfiW2BPzlfWyDm7NKj1+DX1BU5/AFEdV7tYtJ3d8mxv/c+jnVIsPQwWb0Tl7EWECUx/w==
X-Received: from wrbgx16.prod.google.com ([2002:a05:6000:4710:b0:42f:b666:90bb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:26c4:b0:430:96bd:411b
 with SMTP id ffacd0b85a97d-432c3775a8cmr10939156f8f.58.1767946940503; Fri, 09
 Jan 2026 00:22:20 -0800 (PST)
Date: Fri,  9 Jan 2026 08:22:14 +0000
In-Reply-To: <20260109082218.3236580-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260109082218.3236580-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109082218.3236580-2-tabba@google.com>
Subject: [PATCH v4 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	atish.patra@linux.dev, itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, 
	seanjc@google.com, tabba@google.com
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
Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
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
2.52.0.457.g6b5491de43-goog

