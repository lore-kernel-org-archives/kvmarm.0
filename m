Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3BFC4332F
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95554B63B;
	Fri, 18 Nov 2022 20:35:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LKPH++qlkk3i; Fri, 18 Nov 2022 20:35:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D4F14BB76;
	Fri, 18 Nov 2022 20:35:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAED54BB5C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZcZjEn1lv6W7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:35:07 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E5814BB4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:07 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 h19-20020a63e153000000b00434dfee8dbaso3954080pgk.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=qzw3IRf6ZKe9LngiNeoq0Xsow8qMnOMLe6mysjx7GEY=;
 b=WWS9khtEqbOMUnGtkkRMFWvzWDeu4ayjWFRQDGu0iXtOVJDbGSrq/gFRGxrZKKJlGY
 5URd5JYCZgwjvnTNl+Ti4rcPQweserrYFuLxS4+F3t/CDOTOr8AEBOZfx3Z2J7idO5c3
 IDrXNJR03kAw8HpcOlPfCE2+OuJJLGuPU94IZVw40YREPb5/vCeSYvPEvia9tHwTfU1C
 3eBObmpTzOi0i9sxvSozcBhsXpCtw6mLFCvyTAoFKa+x82RFPn06o73N3tlHftgOtE6+
 Xi5hjcYeXjmsl23MApz3bUysNrg7rYzS/9ickjvQa7GqFIN4rdzGd0NiV/GRPNAISoz2
 56jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=qzw3IRf6ZKe9LngiNeoq0Xsow8qMnOMLe6mysjx7GEY=;
 b=Dser1uhF9doEnPgpiivN+hb8zMKO8wwjvN0NJKUeI2IW7B7gdQnKjnvMgzaJQJjB4o
 vPkhbpjMvpmq+RBoKot4V2Yq0cwfK02Mv/Hj0HlZb1qHsNKkkjMmcbw9pAAAj0Lzu9qi
 U0Hc47OTUKShU/TOIHWkTCRB6WdaxfzpHoxE1CAbFpfk/FhEsvxR0qPQ6n1HO7Z62CGx
 7aUKp6sne38ukEiZuQWTfksjQoDcwhghHsXn4kyuZM4H6VUaV7qTUB+k0vWg1tB8Tb2w
 Xyq4WSkUdEEQeHlgZd7ENAFJrPgN44YaPDPLs6E1lnLqGWe2pf0Q67boEOnCDT6dA/1+
 f0IQ==
X-Gm-Message-State: ANoB5pna1VKrGt5g/xDbMD9kq0bYZtixw/eH6e+mSxG3tug87560VDFu
 mW1Cyi1NDDsFclRxo5awXBUS463WEMY=
X-Google-Smtp-Source: AA0mqf7p4CLtuFVtgdl7Bc/NuOg5CLDSNQp6GUYPt/V6N4R/KHWFFrAEPbFAt9/8yfYfs5xqa5KFvyBu1UA=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ce09:0:b0:470:537b:9d23 with SMTP id
 y9-20020a63ce09000000b00470537b9d23mr8701437pgf.185.1668821706323; Fri, 18
 Nov 2022 17:35:06 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:49 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-9-seanjc@google.com>
Subject: [PATCH 8/9] tools: Drop "atomic_" prefix from atomic
 test_and_set_bit()
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Drop the "atomic_" prefix from tools' atomic_test_and_set_bit() to
match the kernel nomenclature where test_and_set_bit() is atomic,
and __test_and_set_bit() provides the non-atomic variant.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/asm/atomic.h            | 3 +--
 tools/include/asm-generic/atomic-gcc.h         | 2 +-
 tools/testing/selftests/kvm/lib/ucall_common.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index 01cc27ec4520..a42733af7d51 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -71,10 +71,9 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
-static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+static inline int test_and_set_bit(long nr, unsigned long *addr)
 {
 	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
-
 }
 
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
index 6daa68bf5b9e..37ef522aaac4 100644
--- a/tools/include/asm-generic/atomic-gcc.h
+++ b/tools/include/asm-generic/atomic-gcc.h
@@ -70,7 +70,7 @@ static inline int atomic_cmpxchg(atomic_t *v, int oldval, int newval)
 	return cmpxchg(&(v)->counter, oldval, newval);
 }
 
-static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+static inline int test_and_set_bit(long nr, unsigned long *addr)
 {
 	unsigned long mask = BIT_MASK(nr);
 	long old;
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index fcae96461e46..820ce6c82829 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -44,7 +44,7 @@ static struct ucall *ucall_alloc(void)
 	GUEST_ASSERT(ucall_pool);
 
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
-		if (!atomic_test_and_set_bit(i, ucall_pool->in_use)) {
+		if (!test_and_set_bit(i, ucall_pool->in_use)) {
 			uc = &ucall_pool->ucalls[i];
 			memset(uc->args, 0, sizeof(uc->args));
 			return uc;
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
