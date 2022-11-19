Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA14B37C
	for <kvmarm@lists.linux.dev>; Sat, 19 Nov 2022 01:35:06 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id m2-20020a17090aab0200b002188c801f92so1398296pjq.4
        for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 17:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=FYjoNyuJm9KhyWUQge81HhT8C6f1EOvYJ2ySDADJ4hjZe2bNL8uGYyIzYf1MzubV3b
         vcqWA61U9lETLngZK701onh7cDh6J0eQJi3GI4pmq/1OZbVNTnuiFuSr2P74jAkM2C3t
         PhZdqWO53nt/gDA3pPvoD9r2I8N/2yMFx2mqhwrGt0X5jMxCuVmGzq9yuTVkPQTO2jHX
         0cZHW8qYW1+97SAVouZM1wugzF1lr45Ygb6V6Q5RBAldcnbZXRG5SvszjN5KLRtCOxZM
         mQqgJn5TndAy0tDZj2KMJAiZyfTSf4HJlH+Y7XuR8hgORWM8XNjpcTwSA2VQyJx2tsn0
         W4QA==
X-Gm-Message-State: ANoB5pmxjDb3B+zhUI8ZXgmliGDqx9rjhlCt/r3qqGf4KMKvCYM1pvmC
	VFtScd0a5S669JstrwTKyXXc4WvK3+Q=
X-Google-Smtp-Source: AA0mqf7p4CLtuFVtgdl7Bc/NuOg5CLDSNQp6GUYPt/V6N4R/KHWFFrAEPbFAt9/8yfYfs5xqa5KFvyBu1UA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ce09:0:b0:470:537b:9d23 with SMTP id
 y9-20020a63ce09000000b00470537b9d23mr8701437pgf.185.1668821706323; Fri, 18
 Nov 2022 17:35:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Sat, 19 Nov 2022 01:34:49 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-9-seanjc@google.com>
Subject: [PATCH 8/9] tools: Drop "atomic_" prefix from atomic test_and_set_bit()
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221119013449.lFQAJLdMtKFVXPxJim32jK0KdP8cx5sCS0lYAGoNcsY@z>

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

