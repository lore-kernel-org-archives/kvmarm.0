Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68721B9E4
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744826723; cv=none; b=g/RlE+7v+ylIlejdUKYW70nQi/qkPHk4252vJYxlXGfhrhmiS9jtUo33jfa5mJcHZqKgIQm9P4MqycGQnVLm+NB77affUsPOSbfrcDA8nH6eFUUfdH2ZE+2rLfPZo2Alj3XuJP2i/lg4dtmAYbYeCWPLIhW2wqd3VBqYo2NIg6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744826723; c=relaxed/simple;
	bh=HuYM3NTjVtNvVmUfTJyuc9HW9TP1DbEzDgukU0Okvnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LFFnUI/CcjJSFLac3kLZSL+Bf1L3pHhNeN19Ab9Xowj+o3JnwvQxBk5pSQBMCT31XDcI7eSnuAtEfWNUsb3/q+R/FAvAAgjBhBUhfQaZiUMGzZSQ0qc2PyoHsI/8xIg2RJabczSvH17ye/iOeVimVFT9OkdLr5RH8L6d4OrwXLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TnPDEmvZ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TnPDEmvZ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d5ca7c86aso42327445e9.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 11:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744826719; x=1745431519; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cig4j4B59mGrHXUscIMbyQJ5aIiV+Rf6+4/as61+W8M=;
        b=TnPDEmvZVbDovZ/jxXeZ3muS+w4JKgRrBKWot9zvsVCLyNRMRtEfk7ZDVDs3hHk36C
         hMmzM4Qp8FTdtvazOH8yuNHBZYu/B0EUrRBIBf1KmDtjPDB4hs2ZxkH23fzl05f1qIEL
         mYLJItbsA8NxtPUii3/QJwSfv7j0oGh9dO42XyC+1JA5++Z3WNL7GEWZQnNxFvTfS138
         M1pxUcn39iqHSyO8K+YIDzKm3iHJNUXm4ROaHfAxALYFOXpgQpw0moAXKTqT06ipK6Na
         Hv/7+XLE0vl+Rslx8uHJAsC9JvW5ZIHy+pA2UW52Q4Lm4lxef/3G6XpQijUB5farJ1hG
         Y8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744826719; x=1745431519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cig4j4B59mGrHXUscIMbyQJ5aIiV+Rf6+4/as61+W8M=;
        b=nMQemkW+K0R4XEJ6u+Fl2Ptkxp5d1fBOwR4EAbM0OjF/ADksLzs1E54n1wbAc16O9P
         o5JlKOGtAZTHqqb4pYVST6wQSIsC1u5xNKDvKX0MfvbPUJWRPoCxg1OWWHxCudtsqYsg
         GOYzTDHEq6j3Wn5ymXp7GJjbbAR9yChpIVj2RLkKetTVF9fH/GvyH4zvcXyU1PBhvocM
         2TIrpWGRH9OB7mptDWN5bzvXTUIoXsz6JuciR+ua0WKiCC6EN/TxwxuFRVmIMyZJaduN
         ppuCP2KbuLgrNUNhgVOccQvqYDs34zHBw48NELTMzPYM9hAOuisAbQidtaz/HizB8tjs
         5bcQ==
X-Gm-Message-State: AOJu0Yya4CbRH1nmUg/jd2UPydXJz6/6SVhWysL9OEU92d749ck9sZZr
	1Z0Th8ThCPTt7mHW6apHBDUmfQ44oOCY1H7i4hiA4T1LLAAeQd+Uf8fxgPXc3hptv2hSadcoefg
	xT7y0lPyvm6gfTmAf705xipqV45y2aFayadZoQanavOei9gaVmaique6O3f9CyajRz9KGN6XqGI
	czgmrK7u22Mhigj7r/r9HupClXhpVdtZO8Px03gjZtXQI=
X-Google-Smtp-Source: AGHT+IEiPUfN9S/47HXHkhZb5HxXPnfUW71Ci+ZV97xZnZ+QKkE230TNxvDfhI7LnVtAM5BZRKK50jEgq3SU8A==
X-Received: from wmhu10.prod.google.com ([2002:a05:600c:a36a:b0:43d:44cf:11f8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c07:b0:43c:f616:f08 with SMTP id 5b1f17b1804b1-4405d61cdccmr26873015e9.8.1744826719680;
 Wed, 16 Apr 2025 11:05:19 -0700 (PDT)
Date: Wed, 16 Apr 2025 18:04:31 +0000
In-Reply-To: <20250416180440.231949-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416180440.231949-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250416180440.231949-2-smostafa@google.com>
Subject: [PATCH 1/4] arm64: Introduce esr_is_ubsan_brk()
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
2.49.0.604.gff1f9ca942-goog

