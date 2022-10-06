Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BB4C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 00:34:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFDBF49EFA;
	Wed,  5 Oct 2022 20:34:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pwm6xGiwFo0Y; Wed,  5 Oct 2022 20:34:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5939A4B0BA;
	Wed,  5 Oct 2022 20:34:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7486240DE6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5u-qlqmqoXHU for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Oct 2022 20:34:21 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1551F411BD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:21 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 pc10-20020a17090b3b8a00b00202be8d81d2so1847829pjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Oct 2022 17:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=7AAoDxmpWj5x2ybL8wTFIqTszjzQUzGU8O6A4pyjNfw=;
 b=MzoY3wJKC57f6HTHbwXp6BEc6x2nX+LXz+Q4fY+52r2dxYepv1/ChNsHSUVGDlRlTL
 RgolXGHav8Nl9WQqJZZqodeVkTUXBRIvNR9SJOYaqM1at1r0JIbLyvNZuu65WM80y+Vo
 4yofkc62Zbz8ziQT9XblbhDw7URnRjsrN5GH0Kci5x1v+P4tT7x4hS1hFUMIs6dQwTkN
 yC3WsTSOrsdIcNJ8pWyzEUkIhKne2l+XqVRwJkun8zNFPccsDtByYqBQ6WwA3sXOYzfV
 icPZ7hHokXQzhV9sxYuTQUMQEkoqEhzEDTnNb/JoNHY/8DPAGGYwputUmXnchRV0CMhI
 ozGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=7AAoDxmpWj5x2ybL8wTFIqTszjzQUzGU8O6A4pyjNfw=;
 b=t+mksYNmZB/JzfhMplJIalQtyRmM0miJStY7lgbWOjripzaQKj0lAiYIHtfWDe2ZlY
 W8L0CySvUTkRPlIKtYTrU0YYL4IyQzsrYzOMWWiFjnxnaIPKfyQbS2wSPl882elngOFU
 ByMQ0HTS1dG8Z/la1TnCapueG8Ne+KT5Fx9QLlhHkpkvHjDoH2WUV6rFNZrMnNqcf/t9
 gKUMDpZPVNYhZS7I6t3SXl0P3jiljHKC3AcRpMlvU6SzoSeVUp+0m1VIPqfRPjcDobWu
 yhDKKO0oR8yilrKKtpHswcOQJaJN3B00MefuCdQx2u+mbGZ68MKVEgR6ofvuTibCSnWw
 Wphw==
X-Gm-Message-State: ACrzQf38MP6goIgRcae7nN2BPFHjOF+rSkRk6XM7f6YLyQC0h7CzYUaC
 /ECdEPC5FGVvOWc7I0EHk1S7B/wdxNY=
X-Google-Smtp-Source: AMsMyM6q13frsoAZ4xAqZiCG4Xm5nEWira6ZJ9vVe6YG5C1/Mh75aGy9vekeidUwoeirPKMuKeImmGnRF6s=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b4d:b0:561:b974:94b9 with SMTP id
 p13-20020a056a000b4d00b00561b97494b9mr2300869pfo.26.1665016460299; Wed, 05
 Oct 2022 17:34:20 -0700 (PDT)
Date: Thu,  6 Oct 2022 00:34:06 +0000
In-Reply-To: <20221006003409.649993-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006003409.649993-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006003409.649993-5-seanjc@google.com>
Subject: [PATCH v6 4/7] tools: Add atomic_test_and_set_bit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 Peter Gonda <pgonda@google.com>, linux-kselftest@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
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
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
