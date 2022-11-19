Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F186037C
	for <kvmarm@lists.linux.dev>; Sat, 19 Nov 2022 01:35:08 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 204-20020a2510d5000000b006be7970889cso6058365ybq.21
        for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 17:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M4XtlcLSA1eOcscbEJGlMDnS4DurFp6ZmUN31qIh/uk=;
        b=dJgWIzI/def4Yf3bVRfXEYvj2NK+TZzjCq+SwSBO5Xayoxkc3jQ6teJXcUkMGSOzEx
         0tVqu35wvxz/ZWi5L6uEH/ZJ4GoMiPXAgBNrepSJ50Kv1mX80m/q7WUCeQnvl6r0HFqo
         zQpUvuJmapnNm9uUFeoLypIHsbw+YmUDECSnc/6vGR3pHqbLfO8qalr8m2Xz6QFFaP7p
         I7a8h6+T6mtseU/p3ik635y6rZmkPCITjDjiaGVxHy3bAZOEQ7gOETU6HzJ3zj1n5wqA
         kFhoyVsi/Mt2oTc5ssyLuq6XczcFlEaPqeQiKqx08W5lZ87mYk65ljyaFvl1b3iFyKlw
         RfGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M4XtlcLSA1eOcscbEJGlMDnS4DurFp6ZmUN31qIh/uk=;
        b=KACxhI/7X/+cKEe8m8uVfxrvopXjS4LDk1/Lvp6ci2My6MY/u6JmeqopoOIb/CIuAx
         XMTgyMM8UZ+Tfa1hiYG9RyxlkFZ33pm2S2A7Q9NU4jcbe6CrGAtMk3FL8/SyVkY6dOk+
         nV1ykkKqZZbNvHzva/qONf11l3dqFbdUhNfQscTCzY0V+AFJpZyLsj9Aucw4senIw5oq
         BjV2pQCfLmv5cu/EBh8w9aqA0bXM7xarLobdgSP8hEI9vKKhEqWDe/8gH7aXMluzE6+l
         aG0tbuSbty56bHn10nj1GJCvYS3M2Tv2Kp4OjryUdO8pHaE7aUT7wyzRD3Xajp23+gu7
         jxZg==
X-Gm-Message-State: ANoB5pnRYIIlGpXDLt4YGr/tb0YXJUEeSCoYa0Ibs/IclxXkLXsuBP/i
	yUrhFhzNwdAGwN7Q7igPXT88bHm3IkY=
X-Google-Smtp-Source: AA0mqf4l9rdo5FZDeZJiSSgH5IVaJdCuTdeBhZvi3lE+67bd0dJxU/CMOjaq3dmkEWoL+sTgDMUC73IKb+A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e8cd:0:b0:38c:e62a:bf59 with SMTP id
 r196-20020a0de8cd000000b0038ce62abf59mr8926692ywe.244.1668821707984; Fri, 18
 Nov 2022 17:35:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Sat, 19 Nov 2022 01:34:50 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-10-seanjc@google.com>
Subject: [PATCH 9/9] tools: KVM: selftests: Convert clear/set_bit() to actual atomics
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
Message-ID: <20221119013450.24Mo_goOYkSgXh3DtQEauSBp9EAvuL0i_JsmHUbUDFg@z>

Convert {clear,set}_bit() to atomics as KVM's ucall implementation relies
on clear_bit() being atomic, they are defined in atomic.h, and the same
helpers in the kernel proper are atomic.

KVM's ucall infrastructure is the only user of clear_bit() in tools/, and
there are no true set_bit() users.  tools/testing/nvdimm/ does make heavy
use of set_bit(), but that code builds into a kernel module of sorts, i.e.
pulls in all of the kernel's header and so is already getting the kernel's
atomic set_bit().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/asm/atomic.h       |  5 +++++
 tools/include/asm-generic/atomic-gcc.h    | 11 +++++++++++
 tools/include/asm-generic/bitops/atomic.h | 15 ++++++---------
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index a42733af7d51..365cf182df12 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -76,4 +76,9 @@ static inline int test_and_set_bit(long nr, unsigned long *addr)
 	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
 }
 
+static inline int test_and_clear_bit(long nr, unsigned long *addr)
+{
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(btc), *addr, "Ir", nr, "%0", "c");
+}
+
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
index 37ef522aaac4..9b3c528bab92 100644
--- a/tools/include/asm-generic/atomic-gcc.h
+++ b/tools/include/asm-generic/atomic-gcc.h
@@ -81,4 +81,15 @@ static inline int test_and_set_bit(long nr, unsigned long *addr)
 	return !!(old & mask);
 }
 
+static inline int test_and_clear_bit(long nr, unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	long old;
+
+	addr += BIT_WORD(nr);
+
+	old = __sync_fetch_and_and(addr, ~mask);
+	return !!(old & mask);
+}
+
 #endif /* __TOOLS_ASM_GENERIC_ATOMIC_H */
diff --git a/tools/include/asm-generic/bitops/atomic.h b/tools/include/asm-generic/bitops/atomic.h
index f64b049d236c..ab37a221b41a 100644
--- a/tools/include/asm-generic/bitops/atomic.h
+++ b/tools/include/asm-generic/bitops/atomic.h
@@ -5,14 +5,11 @@
 #include <asm/types.h>
 #include <asm/bitsperlong.h>
 
-static inline void set_bit(unsigned long nr, unsigned long *addr)
-{
-	addr[nr / __BITS_PER_LONG] |= 1UL << (nr % __BITS_PER_LONG);
-}
-
-static inline void clear_bit(unsigned long nr, unsigned long *addr)
-{
-	addr[nr / __BITS_PER_LONG] &= ~(1UL << (nr % __BITS_PER_LONG));
-}
+/*
+ * Just alias the test versions, all of the compiler built-in atomics "fetch",
+ * and optimizing compile-time constants on x86 isn't worth the complexity.
+ */
+#define set_bit test_and_set_bit
+#define clear_bit test_and_clear_bit
 
 #endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_ATOMIC_H_ */
-- 
2.38.1.584.g0f3c55d4c2-goog

