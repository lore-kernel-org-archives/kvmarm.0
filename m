Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016B4176FD6
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340461; cv=none; b=sSc4rDsdNer2zvcOZ2jc4LuHF8Ilpxrl4nNk8YSJL4Oc5zknVY7r2mY7515L5Q6K/lWWC40U9n0QbuoOqcUj8R3U1OTdvMNYDbhZYNd3ns/FmxdBz2L1kU58xrRJldxmpAb/s2/HYvpkdhTDet7F5ewWcF27/bTHEbXE3NtD+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340461; c=relaxed/simple;
	bh=4OKNjh0djyGb87YHfRcKtU3RYjXJ+P/49RV4qkJxE7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ys+ebE2aqZJxwgDsxRUFJTOeb07dj1IcDYhApe3zqOEeH7UdryrSbZszhf9wtC2Mt8HYyXrVsBVO9BleBqM+o6s3S/ulIw8ncTzkRGd9UTjtvdlZLA19KdX965QrNNaCohV3puOEWimTHeY0yz75YBiSesSXnfdtj4SpYCcej6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YSjG8zSW; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YSjG8zSW"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a59a17f35c8so123010166b.0
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340457; x=1715945257; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BYiDxgRL4/PJcTPYc8te2M3RBep5LmiQ+KSg/yVolMc=;
        b=YSjG8zSWHDOx+QM9Utt/m7OFawKJxBbHJ+M1Zl/CsJBfioyqE81ODxxzO8MZj04TEU
         mWR3EXX/o8M3QGrH5WvUqkgEkzvj/fzTnvfepu0pWsZB7jDBPeJyXGS7QkulZMiJbSmR
         rwmQRvjGcEUd6guDv5n0Tc0pUfU2pL6ItafOEM2WMdmMz9lFtEjJz+lUz2RtgKbVfSXm
         tyZ8lmZpT1a52XVlcaLHakRWcu70NPRipTN+y4r+aKK6YkgkFllG9gbE/oRk0QT39l4i
         NiH7SA7+EeJYjxxQusyabxI2Tp+ZI8e09epRo579SGiROIezYxQuLAqPBe1jvMhZYPtV
         4Epg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340457; x=1715945257;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BYiDxgRL4/PJcTPYc8te2M3RBep5LmiQ+KSg/yVolMc=;
        b=uwT+khD3gxPd7lBq1/O8booszsMe4ghWP6XG8VW8E/978hpBSkRG3EWAScxwKorlCV
         X8L/OfXG6mT2vXd8d8QqJnlyPLU03NSZ8kW92ZypR+zSJ4twdSrAOjuRcdjIDpjY5rP3
         gjl4mjimQ94GheTUnYF7Lx7C1w69I+aJTyXftGMyTh/C6JByuh4e2+ZfUL17G9xRMH4R
         Rdd4RYUHJUl/auJK2CJzGPz9SU6CAI5tTisPNydOY/mvfBunj5sWasgClgPj5+pnZOt7
         Jfo2fdx5GCDkQLGUkxHnUZISMv2YzRU3fHym0/AyvF0LloqbAdQZL8X4Ix0mI2eSljqr
         pBPA==
X-Gm-Message-State: AOJu0Yzo5V7tr3/Qrnr3xyshYHSXFEuHFgJ9T1U57HbuXBpre/1uG0Qs
	hiJijKlXzgD7MU3/gPiaLUsx7esLOFGNf6B1nwDa5+pu/V14mrIAk50KxlddW8a/EarMKpJCN0Y
	eXzp8B+RcNAXRzLOWfOHFpOBVguXmfagVAZGn/UFRK5uQtKQ4LCT+rtacSMAI2OeP0b8iI0OkWU
	7PKy0FUwK64vRmqJUxPAOtNK57I+E=
X-Google-Smtp-Source: AGHT+IHFd5o0vQu25tuDgldMkm4aPBD8ZTZa88+e/50cMnpBaWWfrW1M4Ov32MuLEgdpxktrbzGRQJLKwg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:27cc:b0:a54:c131:8128 with SMTP id
 a640c23a62f3a-a5a2d6796c7mr215866b.14.1715340457059; Fri, 10 May 2024
 04:27:37 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:37 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-9-ptosi@google.com>
Subject: [PATCH v3 08/12] arm64: Move esr_comment() to <asm/esr.h>
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As it is already defined twice and is about to be needed for kCFI error
detection, move esr_comment() to a header for re-use, with a clearer
name.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/esr.h       | 5 +++++
 arch/arm64/kernel/debug-monitors.c | 4 +---
 arch/arm64/kernel/traps.c          | 8 +++-----
 arch/arm64/kvm/handle_exit.c       | 2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 81606bf7d5ac..2bcf216be376 100644
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
index 215e6d7f2df8..2652247032ae 100644
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
+	if ((esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) =3D=3D CFI_BRK_IMM_BASE)
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
index 617ae6dea5d5..0bcafb3179d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, =
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
2.45.0.118.g7fe29c98d7-goog

