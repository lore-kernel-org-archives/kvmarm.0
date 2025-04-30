Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B3C266571
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030456; cv=none; b=qdjfAh/wrTZKzXZldpA0Y3+yLGmsZXMuS5ueDw1uXkH9XRsnEm824t24vL/GzeWg3XXc+i6vABPpfT+dV4KADhvLgZodDDSVBCph7VMAaleVIJz+dcJf2agNZve57kqNFqVsrp4RCr71kHT6U/91OmX7mRSVaW4uYrwj7YiP5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030456; c=relaxed/simple;
	bh=64gtqcGZ8wcy6/ozndo3lRwaVc9zcMKebNzxQK1wlWk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dB1pA1YzIw3mOEMNrT511Pj7W9u5fdR1J/uQaDOSGTi6o80OB6BuRrwWzP6gd9dGB0QgrgQ2KpEHmWAVeCHsPoSo2TwhmnDnU0zVlNt7TfSoX6/H7+4luPkslgVn3sfyKptpRFKvtdYMHmk9YZ0AOBlMHlaaCBkZonrevRhP/OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XkKebgpP; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XkKebgpP"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43cf446681cso43930695e9.1
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 09:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746030452; x=1746635252; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqTf0w984hWi5llfvtlyawmZ56xQei2ohDzGa9Ujg2A=;
        b=XkKebgpPXTpG4ZsB3wUN1g0QJImQ8Ccc+glHHxB8kX1O8J7W4Xpn5RcuwnOLzoYUu0
         f5gw+GNsiBzV5HW9ypHmjB0wAXETmR6kuyz7pAB5725wHCvYkyxriak5E1GetR4unkxl
         /3+2MSd4elwlV9yRX4Z3rjHR3CKpdHHwJqBmkXkQXzaZwpMmVIxLxba4GaGd4kxw4j5i
         alOO3YPwr4ePbUCUs2X8zDRCBXVLHHKarm9YV9s2seMVTn20/sRjNPmGEnA93TLdgm9R
         kQNzcZj0I7/Yyp0B48HJQZAHg1JMo2jbpuom61xo+UmvNIMV2coSWRBkCP0A+W5qrL4k
         aFvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030452; x=1746635252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqTf0w984hWi5llfvtlyawmZ56xQei2ohDzGa9Ujg2A=;
        b=hI6u4nPBMVt+V//oBzeNd3AiIRS4QQz+/25TPlkSlxKASTmO84U3wx8nyFdPahrDmF
         QNdAfCclsZP0mKj2gwpuBUC0OCtM+qRA4Ikz7IZQxaqsvGxEGBtclfSKnf7+HzKDsJea
         FHatpnvQ2qSfRgcfG/l7QVKPano8Y5Sr40pxp9OvmnUDu+fgMG4lpSOC6q4inBam3/ca
         MInhKIScUsTYBQ6ch/SqUEybim9tvU4qMP7c42hoKwStyrhlXRWEre611HkrBJEXbU7i
         dMoJ/IHPc/r9W/HyMe15SljHWBoTcgIhjB3gS8FZozaGnyNwHfzEVYCi64ifipbtSK5U
         1ibA==
X-Gm-Message-State: AOJu0YzCKbEou3Nwa3K666jFjIyL0UuK4x6WiqFNaaVqOfjV7JkRwPEq
	vltzZFDYoMKFBzSeVw4jlKRuHrckBK+7StIJAMB+dx+5x4OZV/PQb4P5EvmTaF/pWwFjYX0ytya
	ndvEGSbF9cfdc9agjWPasw2tYr21bbhuSxZPL+/7p/BUDbWMLNioa32VF6Toxmdrj/4pXcmeITG
	Nxspm3/v0qrjMS/kvol57OI48p7sTKFslgJB1LE+zksoo=
X-Google-Smtp-Source: AGHT+IElx2K4Ydzexiq6oj60bHV5vV1dfYGpgIOCHldmU1tuiZbYiGFH3YyV8uq6opoqtz/pcuka5AJ5zvQ7LQ==
X-Received: from wrp29.prod.google.com ([2002:a05:6000:41fd:b0:399:71d8:5e84])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f4e:0:b0:3a0:8712:5983 with SMTP id ffacd0b85a97d-3a08f7d1a1bmr3354676f8f.51.1746030452526;
 Wed, 30 Apr 2025 09:27:32 -0700 (PDT)
Date: Wed, 30 Apr 2025 16:27:11 +0000
In-Reply-To: <20250430162713.1997569-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430162713.1997569-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430162713.1997569-5-smostafa@google.com>
Subject: [PATCH v2 4/4] KVM: arm64: Handle UBSAN faults
From: Mostafa Saleh <smostafa@google.com>
To: kvmarm@lists.linux.dev, kasan-dev@googlegroups.com, 
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kees@kernel.org, elver@google.com, andreyknvl@gmail.com, 
	ryabinin.a.a@gmail.com, akpm@linux-foundation.org, yuzenghui@huawei.com, 
	suzuki.poulose@arm.com, joey.gouly@arm.com, masahiroy@kernel.org, 
	nathan@kernel.org, nicolas.schier@linux.dev, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

As now UBSAN can be enabled, handle brk64 exits from UBSAN.
Re-use the decoding code from the kernel, and panic with
UBSAN message.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/handle_exit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b73dc26bc44b..5c49540883e3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -10,6 +10,7 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/ubsan.h>
 
 #include <asm/esr.h>
 #include <asm/exception.h>
@@ -474,6 +475,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
 		kvm_nvhe_report_cfi_failure(panic_addr);
+	} else if (IS_ENABLED(CONFIG_UBSAN_KVM_EL2) &&
+		   ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
+		   esr_is_ubsan_brk(esr)) {
+		print_nvhe_hyp_panic(report_ubsan_failure(esr & UBSAN_BRK_MASK),
+				     panic_addr);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
-- 
2.49.0.967.g6a0df3ecc3-goog

