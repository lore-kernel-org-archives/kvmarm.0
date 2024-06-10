Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B22374E
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001198; cv=none; b=G1/IsxFa7X+Dn77zXJW1uFWgc2hv0li76gGtDYVW1sZlw4PI0N2cC01brY2BCV8VIeemGl2P2AirXgt3SGgiER2kwPvmLt4FKQ32O3dhE+g5BQo3RnDZPCAN4f8EHLSu0FYkMjO9bzjsrLbpIrSDPa44aaRIb9KD1ZbKvcdhqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001198; c=relaxed/simple;
	bh=gutDst1iGuxauvOLWt6qjbv2PXcJmlMUw+iw8PL4uSI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iwSGNVnsayp/697CaPav3eU2tpinO0/DpZkoy6dQpVUfR4+OsMPr+UzYTQlb3xz9cHhABIC/FafM9Q1MtZaD8M3H3qGCarQ6Kd2VyunZ0e9wiFOm/mAPQJATnlL9gCoryQ4QNJJ9RUIIZ6kRCrLzALjC2IBYdp8OfDxrLvxBprI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=foASEGco; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="foASEGco"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-57c7f3187a0so412398a12.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001195; x=1718605995; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DG6vYupY7WAr9zwo8BTUXtx1v0A9oK0vgYWOEtX0E4=;
        b=foASEGcoQaHUq2FqiAOSv6HE4DgYYeY2/tmg/+UONelcaqLEkU8nmJNeVDqV04+i80
         Dra+0PMKlHY0/eu5cJsuu4317hkZ0R1gX8GrxfiAC43QKHfi5uIgpXh9n7axGsqnirO5
         V3udmLsDFUoPQTWCAhRyG6X7U64HZFF+CGs4Ob3bLomMctVS3DljxY/HjdCIz8trp4Fh
         xU9wTzpVewTxxaQ08gCZYKSPIdjXXGxB+peTB0zMcvxLTX8IZxKFJj3ncd1SSJTtPx04
         JnfOSqMt4cIMdTRDnm0nGiN2ww7bTn+SYircdS8k6Lzt3D+nxAbhbkl3vejs+yqSPbG4
         Xt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001195; x=1718605995;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DG6vYupY7WAr9zwo8BTUXtx1v0A9oK0vgYWOEtX0E4=;
        b=wk04eQBBGluqp7YEZSYlU5S/tYrOgo64uEptw0rjuRZ4uatZb43VTe+6B6QBVmqZEH
         3Jla2cLhFKP0qCbzaT3FBkb7qgCG8OIr9/NQSPXJ4WaaBpAYsQRpG2eHurQWXXAxYYsK
         iHKs6WFGm6oqjCZVkrn/uwmk6qsOe/xpmkRq6i//xreVG40lrFVGy7Y/uZSw0gak0Az+
         uAIBkGw95+bv+5UIwOh+vEi+6DqiYheyOgy3IEmVpKhnWSu0nwnLU2zK1lUyeokIWsZb
         LJQELvkity8bF3nSOhI3Fwd1trXmnI7r9c9XWrGo2wHHP61QevCRX18xq1bJ88nU8Yfu
         dMSw==
X-Gm-Message-State: AOJu0YxsJPXildrZR2+x/KcvsRs2K05hk+nbDfLRySOG2wA+01bCIMij
	btWOaAdsDXBQDcDA7S5qU0PZzTWEqAGlEDC9ZXzJiB53jz8jHgWKq+O+Itw6gD1nMi4smaejhit
	JGZSHtIzid4Yl35zidFZ7DeuIPyj1qli9B3AbTRrOBwb1l0olaI5IB/c92YZyX4uE/O1ncKKNMZ
	DPU6XgevttoRHXyZix0i54a6v9p8I=
X-Google-Smtp-Source: AGHT+IHt0FJ6sbCckrZkKJOfJcRcRL2EfcoqbTKxzqlq4WyO2vf8tBUdRX1+5ixxV1gmd31Ov951xdBvBA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:434a:b0:57c:7fc5:b3eb with SMTP id
 4fb4d7f45d1cf-57c7fc5b583mr3212a12.8.1718001195339; Sun, 09 Jun 2024 23:33:15
 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:35 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-7-ptosi@google.com>
Subject: [PATCH v5 6/8] arm64: Introduce esr_brk_comment, esr_is_cfi_brk
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already used in two places, move esr_comment() to a header for
re-use, with a clearer name.

Introduce esr_is_cfi_brk() to detect kCFI BRK syndromes, currently used
by early_brk64() but soon to also be used by hypervisor code.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
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
2.45.2.505.gda0bf45e8d-goog

