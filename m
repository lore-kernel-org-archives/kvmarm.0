Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E571262FDB
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 16:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030449; cv=none; b=lvy85Bc1ZfE5WsUQGwiXfIxRwvTDjoo2Ke3v/YmCruTjiN7qhwY7oJ4U2guiA4AAhDbKAG2W69eJIfqUwDNbe3mXYsLn8kb7ec+COxUPjkEizZCxQJXu6ZonbGuBJy6QehDmaCZEaiSln9Xdi3A+6ycC8xV20oCZC9zuAeQxwBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030449; c=relaxed/simple;
	bh=nrCPdU0q/z+UhkgAcPbUE7M11/Gu6PDUNNKarNUhmLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NGnNwtBDKH3BpdfOc8KHL75flTe7YxxSjJHn4VdQ1D2ifKXTSqN+vBurwCFODwluTH9Qw1//cpOQk/3jZ1BnIdDlnPaBITwyqce1/zOOCj5iPfcgKmR1fIUt99BKk/gGHeM59NQeZyyAjR8qasiBAlzLQPwtRgFSFcfLRvLPIYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4cPZEL7Y; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4cPZEL7Y"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a08a1c0fc5so1332019f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 09:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746030446; x=1746635246; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Cc1UFbHiSntYShVPXAcoplaHQWwRkP8Qvo8LnShWWI=;
        b=4cPZEL7Y+8ozZp5oKh50ZpGOLnwlCa7Viob+G0nvAWq9tDOe4zgP/yZ3VzF5/WiIKJ
         G9h51ToRlOqXoCyMP709Truo+dp4kCI6nCiqUbw6sMJoajW2Cn8AtajyMACowsbNuH4N
         zPfgYyIYWGX/rhkCbKGMzGUTIFpouF+bLkydunR2jejZQmuJCg+VfA9NLZVOR1LZyifX
         8sr8C+HRspwghebiiKvpl20v+3nn3S1W89xoqyZ9cvix8mjh4EVhri2jXsvs4X8BrI6J
         7ZThImfAqm/R+Rh8HOgNFHj3XHy3j0SunhoCCP2seq2uQ97E6ijAdUSOlz0SWJvULJiR
         p6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030446; x=1746635246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Cc1UFbHiSntYShVPXAcoplaHQWwRkP8Qvo8LnShWWI=;
        b=I+CxCgBUhwREtG8sB1KOW2Z9w+Uwu9JI+PAMVELQb7H7M9fFTnEOuyFLB83Zp5UZYR
         Qeo7nKTrKlm3aTEZnPZ0EV7h1uaQAKUPaGgPKxVRUXNiDgGVihb6FY2gcO0XgVj4Ik15
         lmwSG/uFWxYNB3+teRaSUKcOBvW8OB2aLnWECKm4TBfUeT9VqJFs9PeBNVUQ9Ij920a4
         vqE4kEATKR8VbdZRgZxI3lQjKRGEofxCeCJKAnPZN+niRzyPjtZAO/ItrxC9f7SwyOdG
         p6Dbqxhkhfy6IgZM0QCK0C8e3YdltrTA7WSD2lfihudjSV09oxuJeAr0H8u0T2c8WcAx
         ltrw==
X-Gm-Message-State: AOJu0YyQ+xaw6XsCjnwQghWvw72Zqtz0lVcoAvIJNZH/8lhY8fD00v2n
	ol7HYsz5FLK/v5xfZ0fPLl9rSFp2jG1JrVyx9lOQJTf7/PZJBgS2r/qCWBxOUmMW1w85KYmK74i
	rHgMtWOlBcf2RfJ131yRwhvGA+hbcYpm8uFLms5A4KaNTnadNTsU0xmVB9uZayvLIjw1omTPn1E
	YBPh3NEUWTn4MeliQnrxjoTW7LJlOVJoeo2PwzMpTTW3g=
X-Google-Smtp-Source: AGHT+IHDzYZhWgLNGxcyelrM4O2AAV3CEZWXJdSJ7SeEaiIFmtJryw2vi0tu8g2u+0VnUpRP7QxKQEtc5Ig7EQ==
X-Received: from wrbfu6.prod.google.com ([2002:a05:6000:25e6:b0:39a:bcee:e7a1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:420e:b0:3a0:847d:8326 with SMTP id ffacd0b85a97d-3a08f777d82mr3895576f8f.25.1746030445844;
 Wed, 30 Apr 2025 09:27:25 -0700 (PDT)
Date: Wed, 30 Apr 2025 16:27:08 +0000
In-Reply-To: <20250430162713.1997569-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430162713.1997569-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430162713.1997569-2-smostafa@google.com>
Subject: [PATCH v2 1/4] arm64: Introduce esr_is_ubsan_brk()
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

Soon, KVM is going to use this logic for hypervisor panics,
so add it in a wrapper that can be used by the hypervisor exit
handler to decode hyp panics.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/esr.h | 5 +++++
 arch/arm64/kernel/traps.c    | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index e4f77757937e..350f02bf437d 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -440,6 +440,11 @@ static inline bool esr_is_cfi_brk(unsigned long esr)
 	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
 }
 
+static inline bool esr_is_ubsan_brk(unsigned long esr)
+{
+	return (esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM;
+}
+
 static inline bool esr_fsc_is_translation_fault(unsigned long esr)
 {
 	esr = esr & ESR_ELx_FSC;
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 529cff825531..224f927ac8af 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1145,7 +1145,7 @@ int __init early_brk64(unsigned long addr, unsigned long esr,
 		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
+	if (esr_is_ubsan_brk(esr))
 		return ubsan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
-- 
2.49.0.967.g6a0df3ecc3-goog

