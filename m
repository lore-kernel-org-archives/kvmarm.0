Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566DDC433FE
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C854BB52;
	Fri, 18 Nov 2022 20:35:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x2yvUbJdw9dK; Fri, 18 Nov 2022 20:35:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57BB4BB9B;
	Fri, 18 Nov 2022 20:35:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7337E4BB62
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pxlVHytgqmkX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:35:10 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B8884BB95
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:08 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-352e29ff8c2so65220447b3.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
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
 b=ZxvPJYpKtorFUtL+anRa3srxviTOdueJpKa+kHrhHEU+0Q2Km5VzS9lZk6eCxzPLzE
 uAnw7jOdzKeBzrgtPlDWDBnqOdRrSUp4RBZhTaUKvFCv1OLy3n59Wu6evThEw41Vf9pb
 0O03uei+NojXn6ulGLA7ZsMvkMqxHG5cDQTHWN+T3jbxloJ/XY2fzJ2zRDBwmri288JR
 gTIIewCziFDKkQVohBsbZAogdccSre9PMT05ojh018JfgoMYpiaPP9G5h5z4O2ljj/Ev
 jhOulhJr9RkPWKnVEV/tQq07xkCALloZ+ekt/wGoYUT2wrJqR9R9SUhvjnrDxj3Z7yG1
 eVCQ==
X-Gm-Message-State: ANoB5pnj3CwkSbl2runa8N3sJmFdH9yOS+zRWLkHjPv6u8bt0hiOhI93
 Oa6KcIFLoqiXu0jfjfSqQ2CfM/hoYfg=
X-Google-Smtp-Source: AA0mqf4l9rdo5FZDeZJiSSgH5IVaJdCuTdeBhZvi3lE+67bd0dJxU/CMOjaq3dmkEWoL+sTgDMUC73IKb+A=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e8cd:0:b0:38c:e62a:bf59 with SMTP id
 r196-20020a0de8cd000000b0038ce62abf59mr8926692ywe.244.1668821707984; Fri, 18
 Nov 2022 17:35:07 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:50 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-10-seanjc@google.com>
Subject: [PATCH 9/9] tools: KVM: selftests: Convert clear/set_bit() to actual
 atomics
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
