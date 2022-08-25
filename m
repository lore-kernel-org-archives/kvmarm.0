Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28395ECAAD1
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 23:25:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48694E24C;
	Thu, 25 Aug 2022 19:25:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hjja7Dtx6tPO; Thu, 25 Aug 2022 19:25:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61B9F4E23B;
	Thu, 25 Aug 2022 19:25:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD3DB4E246
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NUrTZVgeakNy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 19:25:32 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49FD74E229
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:32 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 e9-20020aa78249000000b00537a62a6175so1052956pfn.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 16:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc;
 bh=a5nruIl0wNeupXvrAMbGBAS1GScaEkKaYOUNnuHLnXk=;
 b=MUrthn9a6RY6CpiffJkHt9EOPrKtSEGmXhqqxQ3D2qRZw+a7bNGa46Lw6wQ3BknnIy
 Nccq5f/lszbKbQJgrG/Y3TeW7LcYWHSCnV1949i35B4xTqNhw6TutpLsyYtPkh4tpQun
 8YqYEvHVdG6s/enTMEeqcr2tgcITSa5HsHiuHtd8k1okdf8J78W/3/sDX30h3JhVfrmf
 sDq9IBDxUOd9h4P2X17g89DICK0NQZ8O2oP1O3SUmdgBnpZE5Bd1EVN61k53zguEnNjY
 zxzQgf5iHjst9fKoqExYlsFYRa7aqRLWkLtfs18aJWmLVPp8Pj+CMrtVB/3l2rPzHLPo
 UUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc;
 bh=a5nruIl0wNeupXvrAMbGBAS1GScaEkKaYOUNnuHLnXk=;
 b=dp3img4KH2K77rlLABz7ZgHtxz6lwUGyIylGIZ23GhWF8qfh0honWlSKsfR4k92bVZ
 Z/0qmT2gkuvDNCgbde8WBybDKRjov6GbNSI+tYOGOEamJG4tpRDXXxsFlZfTUUGhTLq1
 g6RDS6Dk+J1ajfT1Lqddf+tI/ZrjY5pbtGXouIZApc8mZ/kLwvIJryRTOyEOyTqRy5qB
 oQcUozUYULvTuq4XlPSRXT1Whxrn1xF9/7W7aQ+EKcpWkYqGKUgIWDiZS/5rXe0IRXx+
 /mLD8e9rh4RnY81oKSvW9u62JMS9JqUqJRSAp80KzqsFwKn3/32USI8bwsJMF0OrQxvp
 bcrQ==
X-Gm-Message-State: ACgBeo1HsnOD8b8SfixNC4rN8eMpKGW76w/AluS2GPqwo+3b93t8PCeM
 +QSRLWnqNv2+hm6IuP8DoqOxTWkvq2o=
X-Google-Smtp-Source: AA6agR5ycc86vDkZZxz/2DKZfcSQPVYnqerGrhMoWS/DoaCwEB56TzgSv+N+GPw1ZMSLN5eesLErkDwOY7I=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f542:b0:173:a8a:d7bf with SMTP id
 h2-20020a170902f54200b001730a8ad7bfmr1185847plf.134.1661469931377; Thu, 25
 Aug 2022 16:25:31 -0700 (PDT)
Date: Thu, 25 Aug 2022 23:25:19 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-5-seanjc@google.com>
Subject: [PATCH v5 4/7] tools: Add atomic_test_and_set_bit()
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
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
