Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943418131B
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984895; cv=none; b=XvUrIac46SiiM5Oxr1yKgJnIHIvFl74wMXORz+5EnmPzrDywxHizORdUQk5Y4S8QNZeIm/BMA/wPVhYd4Bhtu5VPoaAONjcAAgyRrdhmRqfE7UxmbfZvW48lEn9Po/B4LVsMGErakxy1T5W12bNhlbq3nShU4VGiDvGBFy41XbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984895; c=relaxed/simple;
	bh=RAWRwxx2x29Z9C8sFEWaOgpe83fasv5IFOL7pJOwjNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JV904Z/WjnFYNFFIC5vey7b6dUPGaOtGxQn1dq2xurnovt51CpRbNlO4yLTOgki2CxeD3ZJbEGTCXi3e3JTo1bBNRl6VEVeQkLNtIROvHLPuCmn7Rzsak+kZpgXfsvXxFHVhQGA8trI2JbJbjJO0ZAAJp3hBmvfsfYHz6gHO3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VKe0l6aS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VKe0l6aS"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df789a425d3so3177967276.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984893; x=1717589693; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4CCra/rqIFpxe8HMFYt7fMIj2cwQLIfhoDjzzJPzF3M=;
        b=VKe0l6aSN5qW1iK2QYUnEsPdW3KdyzisWFOyARGGvVxeln7vtaYTGItjkCfCuAG9IR
         auSBUmmzISX9C6seaHKbaFCQD4yFOeHkZzcedxBuxCYhCwsDRkO1shj5kEyRQ3IuMhHY
         h6cKTMfQK7cB/opnZPiBPdkphB0oJMk3qlNVbbcgXmR0dyvU1Vup6SVow6IAkDbeBwZ+
         MNhVnpIugB+Z+c+SLoATfGalA19Ep+Mpf/CNIAOAcGzARBQz3MjLDVP6EIMAKAnyUdxE
         L7KsWMdarNqD3LuRfnEOPsDsd9O+wT5A2sr4tHYq2rGGr48VQmP0RziRXXZDEUGG20vM
         sICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984893; x=1717589693;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4CCra/rqIFpxe8HMFYt7fMIj2cwQLIfhoDjzzJPzF3M=;
        b=WhCZVh3upam9GgVT9kfxUf7MDDG30rRAdWo+PGl9xsiPXqLxLgxvMSvym6oIjr9M8Z
         kp/bAk2M3M2+kcwZyMIiEzSFa/E/j3YJRxwcNV4HarU/ipGKOQArui5BXHRuwwU23H/P
         9+5wgnfkBZzdAqf6KFxzFkbf514+6ucWW8zzpVV6H0D7VvL3EJydJSEJx857J8+ELEkY
         vWtlub7ixioBzsE6YL5LvHSSqQVVUsJ/NT0wHcQ8ibtH2/WHcmVTJLpAyyDqRuQ+RwGz
         PitOwIDqLiIzzZlaEDbm9UtBcuCy0ocrbfO+Fg1vKgBbBweyiX3Pn+Qb4OWDz+KiS2Q6
         CtXA==
X-Gm-Message-State: AOJu0YyYmCXn4JoKEEz5NVNuo4vuaZtYgvcTcdkO/ao3nEVyo3EG3lDd
	/zbzxnwrGYno3vCvKeTlEQVd7E2BGySibDkeRDNE4wcvdsZQLh0YE5ahbAKAF95Pjh4EVgnxCGv
	xDqEC3GBqcNWgTB6FeKyyr1AkXl3KA8qHzgM21lXG2oDoA2vMrU1PLbGjRn2kF1WEkjKQKUS6ks
	IlMekanXuHyBmHXu57QgIAPqAxlLg=
X-Google-Smtp-Source: AGHT+IHKlfLzIehWc22oDX8uMfcDmLL5aEy3cA9blPvEjAUh7oYjXMJskW3TDfNlIiBODMYBSdvEYmQV4w==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1248:b0:df7:6f84:f36f with SMTP id
 3f1490d57ef6-df772172705mr1421198276.4.1716984892739; Wed, 29 May 2024
 05:14:52 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:16 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-11-ptosi@google.com>
Subject: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The compiler implements kCFI by adding type information (u32) above
every function that might be indirectly called and, whenever a function
pointer is called, injects a read-and-compare of that u32 against the
value corresponding to the expected type. In case of a mismatch, a BRK
instruction gets executed. When the hypervisor triggers such an
exception in nVHE, it panics and triggers and exception return to EL1.

Therefore, teach nvhe_hyp_panic_handler() to detect kCFI errors from the
ESR and report them. If necessary, remind the user that EL2 kCFI is not
affected by CONFIG_CFI_PERMISSIVE.

Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.

Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
call it directly and must use a PA function pointer from C (because it
is part of the idmap page), which would trigger a kCFI failure if the
type ID wasn't present.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c       | 10 ++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b3d6657a259d..69b08ac7322d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -417,6 +417,14 @@ static void print_nvhe_hyp_panic(const char *name, u64=
 panic_addr)
 		(void *)(panic_addr + kaslr_offset()));
 }
=20
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	print_nvhe_hyp_panic("CFI failure", panic_addr);
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -446,6 +454,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
 			print_nvhe_hyp_panic("BUG", panic_addr);
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		print_nvhe_hyp_panic("panic", panic_addr);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 50fa0ffb6b7e..782b34b004be 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -89,9 +89,9 @@ quiet_cmd_hyprel =3D HYPREL  $@
 quiet_cmd_hypcopy =3D HYPCOPY $@
       cmd_hypcopy =3D $(OBJCOPY) --prefix-symbols=3D__kvm_nvhe_ $< $@
=20
-# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
-# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotation=
s.
-KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FL=
AGS_CFI), $(KBUILD_CFLAGS))
+# Remove ftrace and Shadow Call Stack CFLAGS.
+# This is equivalent to the 'notrace' and '__noscs' annotations.
+KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUI=
LD_CFLAGS))
 # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profil=
e'
 # when profile optimization is applied. gen-hyprel does not support SHT_RE=
L and
 # causes a build failure. Remove profile optimization flags.
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/h=
yp-init.S
index d859c4de06b6..b1c8977e2812 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -5,6 +5,7 @@
  */
=20
 #include <linux/arm-smccc.h>
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
=20
 #include <asm/alternative.h>
@@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
=20
 /*
  * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void)=
);
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirec=
tly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x9, sctlr_el2
--=20
2.45.1.288.g0e0cd299f1-goog

