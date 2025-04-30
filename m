Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC36264639
	for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030451; cv=none; b=iK11W7FkKpMEmbIGgmxZl80HjBuDE48unh4DHWYbyTHgvCLw3PIvIfcZ1tdxXKodH5LYQdYGHBFF9rc/xChWTMkE5SNBi9doqVIjOROcA/aPz5v+3iFuMOQYY2S/I2wWyrNdPLL0LiJjeX3XCM78WQzIJ+NcCbid9EqgF+96aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030451; c=relaxed/simple;
	bh=GTOg1ysfEG4bdpGS4A571FfqA9HLp7EmYpGHSBXrIcY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QMySTZfj84GNnUKwrShitDjAD9zO2o60214BnuabdjIUJPvLDHDvWrw68vpO+GHlevqTznFG0m99ga5A0Ugmiy5lAbI72g6sVdPlknz3yq4FJXQh1LkPgV+y59ygcNEvB91OQEkEaWtpTD53zcC3zruYZJsRRA5q8cYwAV+NOe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wd6R/SBc; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wd6R/SBc"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3913aaf1e32so3258231f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Apr 2025 09:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746030448; x=1746635248; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=003i/GX+SMhbEk8JM6zOLdGB+5OhPHak3AuWaDpYHh0=;
        b=Wd6R/SBckUOAWq57ss0nI2GeTjD21n/GFkjdbAI1tzkaBv3zhZY+UG2ao2DHnKSCVx
         mmJLAVgimHdWgJwozqpvCa559pcsMzWdeDbtQJ2A6iYQIrmTTWL4KtqdwOwv3abVXQ93
         Vtp6IBh2nxm/nQCmNQukjNzF3i0XzxwkMf7iJB7fCQAQAaD7eSM67bGFMsVt7R/eeGB8
         8lOSZJZZYXrx4l6t2S8v0wNexEsaCTtAn+UzweA3ieRjaxmL3VjwBUF6wKBqQa0nZtP7
         rJfVB00rQpH+4APgoD+olrNsdNzPSo9kUneow1sdktGnmkbYj8KVkDEjLgwaVHGkZ1bP
         QPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030448; x=1746635248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=003i/GX+SMhbEk8JM6zOLdGB+5OhPHak3AuWaDpYHh0=;
        b=tog7+GAbN0XKSj7U0vsxd8mnP461Wj9KHkisCVJskq+woxwwHzpWS6qlqXSi0lM4Wd
         8WHmSsj+orPusCQfzZnlBT5DvBgqFLNlbutwyV2X4N3qSRQIHr+Bj+c3MPDFqF8SZ6Bu
         22YVOd8UH64ZK21C0796EUyVJeZgIAVkD8bX92NP00/3/eMXBDlMi9O2A6VA0cTsXU7u
         uwwcNLqYlzc5xBaP0FXFcp+e2Zqp5s363Dca9WOIalAbgb/CABFjuFtQCeVl9kggy3nY
         IqoexfB5e8gzVGK9YvTV+e14poEetYzaW0ANxPRLbrVtc5qYSuSXd0PspcqsPUBdG1+m
         LH+g==
X-Gm-Message-State: AOJu0YzgvX1/E46KxGfwFTWKIpkDjV5JLSdNnFIw6Nz76oIxq9/NQ37n
	yyLMY0IoeLlshJqsaYf3JtWHtj28zUeB08tx018AfpLs+BPmGwr3gLotXdY7TR1u8DltuuaeFPu
	vzo1MDZmtaOaajROEodLYTr4SwucXNKWl8Bx8PtUKAq/EGdoNIFdeWkQttF5gyjDXipiTthe7cZ
	WYbt5iY77fagUe+uR+JHrxCRVTp2h4rtSGLTLe9ewpRMk=
X-Google-Smtp-Source: AGHT+IFmvlkwLxNmZ9CSFJVW5lMLHM9FQhYVBrEhGonj9gK38XYoJ6Wzk9kIHfgZWiH30GqYlq6Z8FTj6W6gdg==
X-Received: from wryv6.prod.google.com ([2002:a5d:59c6:0:b0:391:4999:778e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:3107:b0:3a0:7af3:843f with SMTP id ffacd0b85a97d-3a08f761185mr3815578f8f.19.1746030448153;
 Wed, 30 Apr 2025 09:27:28 -0700 (PDT)
Date: Wed, 30 Apr 2025 16:27:09 +0000
In-Reply-To: <20250430162713.1997569-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250430162713.1997569-1-smostafa@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430162713.1997569-3-smostafa@google.com>
Subject: [PATCH v2 2/4] ubsan: Remove regs from report_ubsan_failure()
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
Acked-by: Kees Cook <kees@kernel.org>
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
2.49.0.967.g6a0df3ecc3-goog

