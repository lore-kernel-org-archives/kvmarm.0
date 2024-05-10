Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8274B17921D
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340465; cv=none; b=XG+FShgi8zFWOql5cmfYIeKhDHVDjqo+LAgLMhccrU9f2o/LwuUMj83aF8NvKY5IDlTggHClbka5VoFNGR8FJr4VbRvZ3X/xj6IGCiHQ6gx6LwdbPJsfmSKO/C16tIZ+88TEqNC+m/7u491QoRtFgQoc7md9KlaBtHKwS/svkoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340465; c=relaxed/simple;
	bh=tINeLBZyoJGokm0sOYwcRkf991k7B88IwoNF+qWz8XI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X+RPGi13kT/E1RVQK1u3pPwLifR3L3pkF8A4ez5ExohdlvdHWS9wVzNKrhmyLgmbayCXGQN8/JZM6aPR2VzY6F9EIjHIum7quBzx88nkXmlpmCvOqlee6FwosHU7GJl7Dp4Zq0XuXThjmR0lCwHjs1LF+CmK2/y0HQS+1XqEIU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zDAAu4Mo; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zDAAu4Mo"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5725fffb621so818911a12.0
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340462; x=1715945262; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kFhYs5lDqdu/+fs82ZoKuSCT3z4IC8Cn6RP491+YFBU=;
        b=zDAAu4MotlyhAdBo8lRlmBTakfv335Jiuoxss9c6KfoD+BA+5Dr/sXDHvTrdRM63Q4
         WjD0AHHBEdq/Pro1YZ1RUg9KiI6B08kfAE+CHsaH8idAvUTXZU+CpA8e0l7TVsURd9vK
         o2FL/vUS6/c6MAxPTbV3bCdf4EGJVGOZJFc6GbNaKDvapZc6tXtUolq8Z/72l1xGJX3t
         1szbn8HHiL7U1I35grBwhSsP6Np7ykvKCrHo9kO4Q1UDFr5Q+SA+8a4j+Iv1YyhVsmZI
         WxES8Vhp8hv/VQxepfe51ejWlyL3wyhZYxex33xc4mtxURtK7Yhb1nqPiXQRxXOsqBPx
         0NKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340462; x=1715945262;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kFhYs5lDqdu/+fs82ZoKuSCT3z4IC8Cn6RP491+YFBU=;
        b=U9FxLHTbEd8Xzn2nTe/lOcDvqmpacah37y+L74kw+lgq6rWrgMeQnJZyrdpV/lB24w
         2vhwbqEtK2lTOBHAL6YEIpVZ4vYFP5VnCbZy9ILd284tqKVdaWbn2TPTaFOZgkDcK+fG
         oCfycH9cvEUu5I561Z4RLtUvk0Y1V6L58zF4R5E4SVxiFIsUlLkvtlNu/QPu+oq0ar7A
         R7ah29+fZZkv8bXSjjdj4HLRBRW5Sl/B4prKMRGUrHpJ7z6jYxn8xNHloSOTsRIOvT7U
         5JRR/wvIYAG3u78O19GX6kxms07Cr/pS5uI7XOoRqfb7VoJ1IA9Ljb78gA7Wp460OWi8
         6EKA==
X-Gm-Message-State: AOJu0YwW67kuhTxQHVdtc7ECtnp4VfWnPY70pCyE9+KQWjK+jLW8Ptag
	RMbkAdFakFvtCSfJkE2gLCI7WT5DKHkyI4Nunh2ddXLDfikFloO7kh59yrOKvs8Wz/erdxzfiEC
	RCF2IqOZcaOYIicf4hcvPdXN8H9Z3VRJY10TETPOgg1dG3Hv6umjes0n+7L/S1dVSDr4uu25yBB
	scMj+1JCobhjzd2HW2ijwwYOP+JY8=
X-Google-Smtp-Source: AGHT+IGJhtD/wN9N41xGH4SqpBDhacAaIk1ZGwSPDqSUff1bOTvFtTBlhk3QdXGF6oIEd68ubcVUJM9mKg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:aa7:d4d2:0:b0:572:3273:62d5 with SMTP id
 4fb4d7f45d1cf-5734d6ecb9cmr2976a12.5.1715340461789; Fri, 10 May 2024 04:27:41
 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:39 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-11-ptosi@google.com>
Subject: [PATCH v3 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at EL2
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
 arch/arm64/include/asm/esr.h       |  6 ++++++
 arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 2bcf216be376..9eb9e6aa70cf 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -391,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr=
)
 	return ec =3D=3D ESR_ELx_EC_DABT_LOW || ec =3D=3D ESR_ELx_EC_DABT_CUR;
 }
=20
+static inline bool esr_is_cfi_brk(unsigned long esr)
+{
+	return ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_BRK64 &&
+	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE=
;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	/* Translation fault, level -1 */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0bcafb3179d6..0db23a6304ce 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -383,6 +383,15 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exce=
ption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
=20
+static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
+{
+	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+
+	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
+		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -413,6 +422,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 		else
 			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
 					(void *)(panic_addr + kaslr_offset()));
+	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
+		kvm_nvhe_report_cfi_failure(panic_addr);
 	} else {
 		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
 				(void *)(panic_addr + kaslr_offset()));
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 2250253a6429..2eb915d8943f 100644
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
index 5a15737b4233..33fb5732ab83 100644
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
@@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
 /*
  * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
  *                             void (*finalize_fn)(void));
+ *
+ * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirec=
tly
+ * using a physical pointer without triggering a kCFI failure.
  */
-SYM_FUNC_START(__pkvm_init_switch_pgd)
+SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
 	/* Load the inputs from the VA pointer before turning the MMU off */
 	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
 	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
--=20
2.45.0.118.g7fe29c98d7-goog

