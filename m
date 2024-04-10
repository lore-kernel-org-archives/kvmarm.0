Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100AD5CB5
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737786; cv=none; b=S31uwITkNljXehKezx5QQ8+veV+Nsu4fnOEZ2iSkhj28UR5c58ilI1q4H9ocVww6yAGiavqNb+v8r6CDzcfAimVaW5tbIMCsrQ0qXkF9LFY3VhTX8oXTk1hhwwye8dzXGRCReEKVCNcPe+YI1FttIDahj5IQAcKTzT4Z5/U8N8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737786; c=relaxed/simple;
	bh=sf0sDasYfNHboeUmoADUV0lyyWhLkNN4THpXFKwDkII=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kSML64Wvit+exQ4hjpg7h41PrDW39VusBamt0BNatTqo0txo7jef9YoreGxBKuwfIQAmYaF7KdVa3qbK1KqWd9KPdbMQXFEfefUeKLkj7E7VT05JrOjC+Nmqx3kGx8BQtzSWNboN+1pseAdeTtDapCfwI6Ujzz6D5D46OQVuRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5SRYWJJ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5SRYWJJ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a44ad785a44so756367366b.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737783; x=1713342583; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NZHDu7gaaGLVzR6sjGpXZZ06n1xRkbPQlKF9FVoL20=;
        b=n5SRYWJJa2snrmlRLR6oITvtBWqbbgGwJjP0GOl5Dvt18QFwsabJ+OHX95/eMdniRF
         4uM/NFFEm+/0MgMVyVXFz8KEGovKnAcW78ertSkzeZvump5GfIHHa58YPt4ZrfwsL0Wu
         actuGQBWs4A5ppygnErE0KQql95jOugyiQvilScRaPSs1B3TvFBDCFK3FpQla1jgP62R
         ciusdJN35EwTqIyEeW2WxYFVfGOcl1yA3KFwKpVyfSWtasHXJFp5iAoGKIqirP7IDuJi
         0xbaofQ9rvD0CpezkZlJmUdw8R1KHekGkrIjXcbgnwZztXSW+Syh8NTekGbSNIH5QbaS
         iCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737783; x=1713342583;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NZHDu7gaaGLVzR6sjGpXZZ06n1xRkbPQlKF9FVoL20=;
        b=pM8mmz/yVhmZxcRXZOP+JW30gqmm8RNw0zSfFa+U3wLW0is+2RWN0cIBQWTUp52n2n
         Xd2Ef1lF/Hey4tUbhpjFqBbhNIz7glnaxpfPMucb+zh6nVn3rOiJV32cS+AnRiHvLx5i
         CalbtRu1qJXUG4sKEif4DoahAxO9In5bTEKjH09fpNYSrpsvEiHdQ2QpQ1EGpl5UGFzs
         0Wf794r7IlMyWiRCFYbifJfStFweDT/kXGqEhjPEcJxQqW9J6MhDJWd76Qc3MBRVkxI9
         PgG+FyGAHjSk7kkbEnmfALB90k4WSjBFkgNQzr0ImyR/4KDijyL5xrd1UBMRz574zpdV
         crjA==
X-Gm-Message-State: AOJu0Yx+DuN5gEYOr4uOFR0XfPQmXEuqnJEzApd3O8w6KY5/dzVKGU/2
	1v+XLtByh3oSXT6Yb1VkGNjzKrYMpslDvidkTR86S3qFU6cEg6JG0F1tW8o1Iy6LXViZ5GHJ9Hm
	LKg==
X-Google-Smtp-Source: AGHT+IHk06Jj4qi1uxqsJ3TKZTuTcrqUHzkgKhb4lhb70e3Hy/FmNeOV4FhI393R0veGubX5c/yefQ==
X-Received: by 2002:a17:906:3554:b0:a51:fa56:4fc7 with SMTP id s20-20020a170906355400b00a51fa564fc7mr1066762eja.21.1712737783099;
        Wed, 10 Apr 2024 01:29:43 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id c22-20020a170906529600b00a51bbee7e55sm5299754ejm.53.2024.04.10.01.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:42 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:39 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 08/12] arm64: Move esr_comment() to <asm/esr.h>
Message-ID: <d7bs5iq4lb6yeza5y7evj6rqqqogclij5wat76b3asn7xvtmwz@x6lu7v3yih4p>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

As it is already defined twice and is about to be needed for kCFI error
detection, move esr_comment() to a header for re-use, with a clearer
name.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
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
 
+static inline unsigned long esr_brk_comment(unsigned long esr)
+{
+	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
+}
+
 static inline bool esr_is_data_abort(unsigned long esr)
 {
 	const unsigned long ec = ESR_ELx_EC(esr);
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 64f2ecbdfe5c..024a7b245056 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -312,9 +312,7 @@ static int call_break_hook(struct pt_regs *regs, unsigned long esr)
 	 * entirely not preemptible, and we can use rcu list safely here.
 	 */
 	list_for_each_entry_rcu(hook, list, node) {
-		unsigned long comment = esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
-
-		if ((comment & ~hook->mask) == hook->imm)
+		if ((esr_brk_comment(esr) & ~hook->mask) == hook->imm)
 			fn = hook->fn;
 	}
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 215e6d7f2df8..2652247032ae 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1105,8 +1105,6 @@ static struct break_hook ubsan_break_hook = {
 };
 #endif
 
-#define esr_comment(esr) ((esr) & ESR_ELx_BRK64_ISS_COMMENT_MASK)
-
 /*
  * Initial handler for AArch64 BRK exceptions
  * This handler only used until debug_traps_init().
@@ -1115,15 +1113,15 @@ int __init early_brk64(unsigned long addr, unsigned long esr,
 		struct pt_regs *regs)
 {
 #ifdef CONFIG_CFI_CLANG
-	if ((esr_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
+	if ((esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE)
 		return cfi_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_KASAN_SW_TAGS
-	if ((esr_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~KASAN_BRK_MASK) == KASAN_BRK_IMM)
 		return kasan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 #ifdef CONFIG_UBSAN_TRAP
-	if ((esr_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
+	if ((esr_brk_comment(esr) & ~UBSAN_BRK_MASK) == UBSAN_BRK_IMM)
 		return ubsan_handler(regs, esr) != DBG_HOOK_HANDLED;
 #endif
 	return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..0bcafb3179d6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -395,7 +395,7 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
-		   (esr & ESR_ELx_BRK64_ISS_COMMENT_MASK) == BUG_BRK_IMM) {
+		   esr_brk_comment(esr) == BUG_BRK_IMM) {
 		const char *file = NULL;
 		unsigned int line = 0;
 
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
