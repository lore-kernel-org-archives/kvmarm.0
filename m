Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923DF180A99
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984891; cv=none; b=QWcb/lWZd3gsFOoooGaL6dB3BdnrEr9zk8iFYd5lZUYMhscAZUKs7BUsaK6/DyFF1VqdceRg/oBQgYSB6d5VnBc32YYR0Fto9PaHhFV0U1QBEnveKyWV6rqUMF5j/fh2eA4N25LVB59q+6+aJW0riQQL74VU/FkYBgqD1Lc1IzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984891; c=relaxed/simple;
	bh=9btKNfRjz6fK+DhlL9k76Ks1QkjES/uXicjLnT/2h3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmZ3qtF7AuEo4W+m1z8GAOSaBi+jzT1DauBQuc1cW4G6h8vAePV0G6AXQX59cpn21ogXCbVlWV4BSJ5TwUibp/DEfKAmUK1dcaRvVBUiwaPDk3YgcGvUe73PDmg/Ww90RrByaGdLDIBoGatRZzBkUb4DPe0DShLqS5dBkzfmEXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O8FC/iCL; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O8FC/iCL"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-579fd68b42aso707978a12.3
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984888; x=1717589688; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fl+f30rl7dVa/IVaUSQ5SKFqgJp4W7PmIf/N7fy8cOU=;
        b=O8FC/iCLjEw4hh6wG+bJscM7Are2AgZD0mbxjudJwL3pTJjMrUaher/+fHh75q78QN
         BECKyBYmtTxpxJT1TlRLywAIg0a3zJ193JVp/mk8UNNH27s5vOPPKqO9uKGPFt2Hf2dM
         vAzCv7zSsmx2lj6Twq/2Y50hXEfQ/QKR7LWgWqt/7W3p0CqpRnqI1eEfLqarpXoCAadB
         49NpouL50lh87BPFRnpbt1+6DTdMRuxF4KO+OZvhccEoNcwTAQBY6ep4UobQzKkCGJ0g
         DBZORNbOAtUGDytsryTx8SfvbAahd8Xdz2+EFg0UItaDkGY1XNxFRH3957GwuzTDbO5n
         SULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984888; x=1717589688;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Fl+f30rl7dVa/IVaUSQ5SKFqgJp4W7PmIf/N7fy8cOU=;
        b=Lgu3BwwWqv19UIV8FbPw5yQ7qh98hMSfiY5V+XrXCsy3C9K+rqrzuaPOv+I8P33FhC
         NsnITZQOkGov67eqRe6+VP3d7ZTG26KZVCXF0Dvj7N7d6kqOFxzCmlRU5pvHH/EIP0v9
         o6xuVDWJgpAVvAfTGxsbG+0n4FA6RF17TZNbmmWCgZ/ca4DQPN7oqRcLpbNFz0/nXeEp
         5OEkltNgcRyrl+WUT/Jazqwlcy2I2r3zu9kbXBuQan9PZ1wHDUtLO59qmfFJNbe3fDii
         o/IbmNwOmXWoap6jLPJe4KtnjunXmPxZNJ6s9KyqFvoaNlnDJfQ8NMhFS8miha+gKsNB
         JyeQ==
X-Gm-Message-State: AOJu0Yz2QN7Aas6cTwbSGcReVuMYkbgQGETw9pVnW3wZcqENfLa5tHDH
	TvSrXXYFtgXdFG3CO2zNXJuHWe6jOgUwrOaWqFkOeuRgmyP/KZ6WUcSvcJIH9arWL0sWwgagxsU
	/mLe2sIVGXZzDfzFFR0OaqIuvEIHKH2+aJlRQK+z2XFLPldSyyqUEaAg9BnUhyzsIJeZ8b7tx4G
	9SL0Kjq47yB6bjdFmPwqsl3A8KLSY=
X-Google-Smtp-Source: AGHT+IEEHNDVH5oua3/ecoC74+hCc08TVB6uy8myiwmNDRyQ2CUe66zxXOENHLIB7cqS59dn8IOjkr3XHg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:1954:b0:578:b249:2b06 with SMTP id
 4fb4d7f45d1cf-578b24964d6mr14880a12.6.1716984887626; Wed, 29 May 2024
 05:14:47 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:14 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-9-ptosi@google.com>
Subject: [PATCH v4 08/13] arm64: Introduce esr_comment() & esr_is_cfi_brk()
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already used in two places, move esr_comment() to a header for
re-use, with a clearer name.

Introduce esr_is_cfi_brk() to detect kCFI BRK syndromes, currently used
by early_brk64() but soon to be also used by hypervisor code.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 11 +++++++++++
 arch/arm64/kernel/debug-monitors.c |  4 +---
 arch/arm64/kernel/traps.c          |  8 +++-----
 arch/arm64/kvm/handle_exit.c       |  2 +-
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 7abf09df7033..77569d207ecf 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -379,6 +379,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/types.h>
=20
+static inline unsigned long esr_brk_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec =3D ESR_ELx_EC(esr);
@@ -386,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr=
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
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-m=
onitors.c
index 64f2ecbdfe5c..024a7b245056 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsign=
ed long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment =3D esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) =3D=3D hook->imm)
+		if ((esr_brk_comment(esr) & ~hook->mask) =3D=3D hook->imm)
 			fn =3D hook->fn;
 	}
=20
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..9e22683aa921 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook =3D {
 };
 #endif
=20
-#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
-
 /*
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
@@ -1115,15 +1113,15 @@ int __init early_brk64(unsigned long addr, unsigned=
 long esr,
 		struct pt_regs *regs)
 {
 #ifdef CONFIG_CFI_CLANG
-	if ((esr_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE)
+	if (esr_is_cfi_brk(esr))
 		return cfi_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_KASAN_SW_TAGS
-	if ((esr_comment(esr) & ~KASAN_BRK_MASK) =3D=3D KASAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) =3D=3D KASAN_BRK_IMM)
 		return kasan_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_comment(esr) & ~UBSAN_BRK_MASK) =3D=3D UBSAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) =3D=3D UBSAN_BRK_IMM)
 		return ubsan_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) !=3D DBG_HOOK_HANDLED;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index b037f0a0e27e..d41447193e13 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -423,7 +423,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
u64 spsr,
 	if (mode !=3D PSR_MODE_EL2t && mode !=3D PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) =3D=3D ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) =3D=3D BUG_BRK_IMM) {
+		   esr_brk_comment(esr) =3D=3D BUG_BRK_IMM) {
 		const char *file =3D NULL;
 		unsigned int line =3D 0;
=20
--=20
2.45.1.288.g0e0cd299f1-goog

