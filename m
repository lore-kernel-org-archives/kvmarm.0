Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709A21C177
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744826725; cv=none; b=HwGDaqoDM4QCxRnBqtk49yuqMssw5utN2Wvz4XZb+dU2oa60Ushc7lJm6Y7d9GR0BGmvjExZXJOw5jZKmVgOVBzQAXSSDZPd394ca1XHJXNmXZfbMHR6J/obeM9U43XP36eZdD13wfV4+9OuO+KR7DKsOGmzqMIWbdqmN3j4oZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744826725; c=relaxed/simple;
	bh=D/VurCqLb27guso/GqkYusIvZ2SnsZDyUpD9nIbj4iE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SRWDtIV2IAYf2z2I1yi5qkDRdxz1QPOGMhrxNdTVy847Uf4EqBY+NmlSwaDPMMRSvvoeqsc834z/236AZ0F9rmE+Tf0f7QK8lr8fRycgpfD+04NY39kcOZsul3L8RHFxHJEhbGpiuNOFEnEs6gKHkye5YspNr+bd5pxTNjcEai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pl6CAEDg; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pl6CAEDg"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43cf5196c25so42927765e9.0
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 11:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744826721; x=1745431521; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EWRjEDjHgnGUTAO1fUxX0nlQ73sblTBfWxiyoAckCmI=;
        b=Pl6CAEDgS9pI1weHwTlSZUn6f+v/lsBzRE7BB1vwBCs/95tMVJ8aYlDfMtGVMLg+Tp
         RUgJqn7VY/OkdgEOe1INRoWz1LhOp2ZbF3BZcxkfK6bNgR0MisoTJsDvQ2g4JQQ4VQ+I
         3Dy3GGR155Ib4pEFHsFin6APD3nFNvc7CS19U/G0YoFh5pTd3KStfb1KWGgv8aUsrjfg
         BifARuS7wgZ4AMaF9n1I/71rOcdIGetE2upq+De14FDA2XJ4k2A5saHQXzlLY2hL4rUk
         ylCjgeuRtp5RjEkeMHZpYq/yUAPn0Znt2nfQVrxOfBianS2oddRzOHSJalxg7fg+rgjY
         /iyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744826721; x=1745431521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EWRjEDjHgnGUTAO1fUxX0nlQ73sblTBfWxiyoAckCmI=;
        b=RP6jjYslRQcHJ5tasYYJSMbirOOVPIiHUh6hRNo8Sgy1F0pfCKjcWi7zjsmbvbWy8p
         aJ/9PZTZ9jpeCnUMSPoHcC5ow+9kvgHD5PvcsVW0DYs4O6jqxxsx0ACmUnbyU+iw+w/q
         HtQaeCaNESAwh6GK1Bq1RboYS1QAwiaykQF+i7xw5uGB2j6RwECu0u5FX8+uXtlmXvDn
         bvSlfSt6OXMOo0iwgyojZRAkOtUglUewOULvvpBWxogG802nAtyq/UCJFMuPGoATieFl
         QkDlsci45GKsKDv5O5ygOLQpeRVNC49tl+HdPeYkKrW5LQ7BiaTZi/yOOIVJrvuKthgK
         1DZg==
X-Gm-Message-State: AOJu0YyjFMvPIGZbb1CtHRC55KsZmC+Js5nmW61m1PtfuVmZtxe3KpVG
	c45DLSCJ6qme/SPcaOQrOK6QbEDBauxCDjQyqqIwz0uE0KDfvm45psqS7kV28b+MkXtyVwYi6X+
	WGjHMbTgvRA+5Dg1mqUdtfKLhANterbOyjZBZfVIF7Ij9N2AfHUr9f+p/vJKGQTuu+aCYNi7Zze
	GW4ziJl41z7xI8DFusxZS2yMhKpXoCyci4xnAKCV5CFMM=
X-Google-Smtp-Source: AGHT+IGKfernDkJiPcq9aGD5Ngb6rDQ85prFSXMtxNjAKHAqgi+juJeLLNi5fr5EDrdbF7a6RZez8kPLKAZvew==
X-Received: from wmbev17.prod.google.com ([2002:a05:600c:8011:b0:43d:4055:98e3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3487:b0:43c:f70a:2af0 with SMTP id 5b1f17b1804b1-4405d62a49cmr36178345e9.16.1744826721678;
 Wed, 16 Apr 2025 11:05:21 -0700 (PDT)
Date: Wed, 16 Apr 2025 18:04:32 +0000
In-Reply-To: <20250416180440.231949-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416180440.231949-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250416180440.231949-3-smostafa@google.com>
Subject: [PATCH 2/4] ubsan: Remove regs from report_ubsan_failure()
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

report_ubsan_failure() doesn't use argument regs, and soon it will
be called from the hypervisor context were regs are not available.
So, remove the unused argument.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kernel/traps.c | 2 +-
 arch/x86/kernel/traps.c   | 2 +-
 include/linux/ubsan.h     | 4 ++--
 lib/ubsan.c               | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 224f927ac8af..9bfa5c944379 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -1118,7 +1118,7 @@ static struct break_hook kasan_break_hook = {
 #ifdef CONFIG_UBSAN_TRAP
 static int ubsan_handler(struct pt_regs *regs, unsigned long esr)
 {
-	die(report_ubsan_failure(regs, esr & UBSAN_BRK_MASK), regs, esr);
+	die(report_ubsan_failure(esr & UBSAN_BRK_MASK), regs, esr);
 	return DBG_HOOK_HANDLED;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9f88b8a78e50..4b5a7a1a8dde 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -351,7 +351,7 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	case BUG_UD1_UBSAN:
 		if (IS_ENABLED(CONFIG_UBSAN_TRAP)) {
 			pr_crit("%s at %pS\n",
-				report_ubsan_failure(regs, ud_imm),
+				report_ubsan_failure(ud_imm),
 				(void *)regs->ip);
 		}
 		break;
diff --git a/include/linux/ubsan.h b/include/linux/ubsan.h
index d8219cbe09ff..c843816f5f68 100644
--- a/include/linux/ubsan.h
+++ b/include/linux/ubsan.h
@@ -3,9 +3,9 @@
 #define _LINUX_UBSAN_H
 
 #ifdef CONFIG_UBSAN_TRAP
-const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type);
+const char *report_ubsan_failure(u32 check_type);
 #else
-static inline const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type)
+static inline const char *report_ubsan_failure(u32 check_type)
 {
 	return NULL;
 }
diff --git a/lib/ubsan.c b/lib/ubsan.c
index cdc1d31c3821..17993727fc96 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -25,7 +25,7 @@
  * The mappings of struct SanitizerKind (the -fsanitize=xxx args) to
  * enum SanitizerHandler (the traps) in Clang is in clang/lib/CodeGen/.
  */
-const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type)
+const char *report_ubsan_failure(u32 check_type)
 {
 	switch (check_type) {
 #ifdef CONFIG_UBSAN_BOUNDS
-- 
2.49.0.604.gff1f9ca942-goog

