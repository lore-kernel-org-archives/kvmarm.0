Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93593C32774
	for <kvmarm@archiver.kernel.org>; Wed, 24 Aug 2022 03:21:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4083E4C2E7;
	Tue, 23 Aug 2022 23:21:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PJw-abTjOCE6; Tue, 23 Aug 2022 23:21:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CF984C2D5;
	Tue, 23 Aug 2022 23:21:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F5A4C29A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jv26mziC7w1A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 23:21:26 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 877F74C2CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 23:21:26 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 c7-20020a170902d48700b00172ea5ea9caso4905437plg.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 20:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:reply-to:from:to:cc;
 bh=DiPDkyCUU5+qWi0FAGBrmfRDeC2PU2rAf87l6jKus4Q=;
 b=XvXBevlrlAqE9wagoH125syNrQYxrpHCiRlRfiVQtu1MdNipV2GG0TAviWCkY42kue
 40hfNKd+srF0kxrbk+L6cIyjcvRD8ldiLVaaVnTF7/0DWZuQLDQlKmMKu1ugP09CeNj6
 VfX9VSOzSDrnlZamHjfahcZ2qWLNHssJ6Tq+/c4s295toNWRhLpMaKG2PErS9+FS8eu/
 nEwvow02yLb8KzgPd+H/QmXmd4FUVqVHY6f7qsUkwmsM976gLKCuj3wk6E+/Ec1o7Qk2
 rSKdgFoFxqyd41Hj6wSl65wgpFaa3s0g/kZVmRXjxDr+uNytf2U5o026FzYj9bwJFc5X
 barw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc;
 bh=DiPDkyCUU5+qWi0FAGBrmfRDeC2PU2rAf87l6jKus4Q=;
 b=nwrHiATpvHzLrfM7ufLXZ/0EHDVwLCHkIxtm0LAimLA0nh7v6e7ugqVUGmI/WBWiaw
 v7OIaAJbdpm6QtGvdiWoWC8yyJi4oLKbWlFee9pNQTcOf/BcvL+eomMdPLdsOvdcUf1E
 iwjjuLWjiHfSGTLUeWF5SSsgHefnlbhokR3CNGBk2GdP6RxOFJZ0Rl/gsSsJ5kefUFYz
 NGmL8tpv96Nw8WICSNXoIDwn3wiBP3jhCNlc7e4frmiGLWu2hHpD9ePI1aLYjcys+2/E
 7+rYOlk9jH22Zp5oTrP1yP2xtnwJwgc5TUEyBJ6Nv9kQ/S5GjAMZfaxCRJXJKhfkGo5c
 G8zw==
X-Gm-Message-State: ACgBeo2kuMyIlggTBuhvwV+KaoOfJG4mW+nHk5cGxc2AVdXmqnKIgcxC
 XAZqh6ji8a4918DVobUOH84sWUh8BpY=
X-Google-Smtp-Source: AA6agR7hkMAlHzZjMos7RFjUz8V/HjO4UccQUnDLH/uwK3wpKW33JaEUPX9HlB35rLdBTEQmTcaewjVzFKc=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:301c:b0:52d:bff9:5004 with SMTP id
 ay28-20020a056a00301c00b0052dbff95004mr27937449pfb.84.1661311285738; Tue, 23
 Aug 2022 20:21:25 -0700 (PDT)
Date: Wed, 24 Aug 2022 03:21:13 +0000
In-Reply-To: <20220824032115.3563686-1-seanjc@google.com>
Message-Id: <20220824032115.3563686-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220824032115.3563686-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v4 4/6] tools: Add atomic_test_and_set_bit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, Andrew Jones <andrew.jones@linux.dev>,
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

From: Peter Gonda <pgonda@google.com>

Add x86 and generic implementations of atomic_test_and_set_bit() to allow
KVM selftests to atomically manage bitmaps.

Note, the generic version is taken from arch_test_and_set_bit() as of
commit 415d83249709 ("locking/atomic: Make test_and_*_bit() ordered on
failure").

Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/arch/x86/include/asm/atomic.h    |  7 +++++++
 tools/include/asm-generic/atomic-gcc.h | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/tools/arch/x86/include/asm/atomic.h b/tools/arch/x86/include/asm/atomic.h
index 1f5e26aae9fc..01cc27ec4520 100644
--- a/tools/arch/x86/include/asm/atomic.h
+++ b/tools/arch/x86/include/asm/atomic.h
@@ -8,6 +8,7 @@
 
 #define LOCK_PREFIX "\n\tlock; "
 
+#include <asm/asm.h>
 #include <asm/cmpxchg.h>
 
 /*
@@ -70,4 +71,10 @@ static __always_inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return cmpxchg(&v->counter, old, new);
 }
 
+static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+{
+	GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, "Ir", nr, "%0", "c");
+
+}
+
 #endif /* _TOOLS_LINUX_ASM_X86_ATOMIC_H */
diff --git a/tools/include/asm-generic/atomic-gcc.h b/tools/include/asm-generic/atomic-gcc.h
index 4c1966f7c77a..6daa68bf5b9e 100644
--- a/tools/include/asm-generic/atomic-gcc.h
+++ b/tools/include/asm-generic/atomic-gcc.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -69,4 +70,15 @@ static inline int atomic_cmpxchg(atomic_t *v, int oldval, int newval)
 	return cmpxchg(&(v)->counter, oldval, newval);
 }
 
+static inline int atomic_test_and_set_bit(long nr, unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	long old;
+
+	addr += BIT_WORD(nr);
+
+	old = __sync_fetch_and_or(addr, mask);
+	return !!(old & mask);
+}
+
 #endif /* __TOOLS_ASM_GENERIC_ATOMIC_H */
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
