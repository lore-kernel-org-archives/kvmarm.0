Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A58627
	for <kvmarm@lists.linux.dev>; Thu,  6 Oct 2022 00:34:20 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id o1-20020a170902d4c100b00177f59a9889so155112plg.13
        for <kvmarm@lists.linux.dev>; Wed, 05 Oct 2022 17:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=jehmeauQ3AD6HUw73krhy4PtkXlHDobPfGOZdxyCC3fN1x1mEm4p13cen3q300mzZX
         Ly11gChTp+QqnfE30jEZac8AkTogLpUv+pgPT6FMZKXIjyd9LpAYiJ+N2iIjV38L0WT8
         4wFBCgkn98FMgLgEYQajBMa+vVXaQL7tSAx8EZjsHsXgFkjNFhOagTEx3hIsmsnqf5gH
         NxAr/1Sv9aTpOrrGWEiDTGtKHOngx3Ek+CrPVG0RQtHkxDVbtLqdyy5t1amC0ynb+gOG
         XX+4G38elFEw9o7W5+Xok0TDSO3GrACiou6w87Szp3gSjZIaw7WXKVpMsQW1Y23CxIxF
         wf1w==
X-Gm-Message-State: ACrzQf0c/RjZoRgisabdhGCY3xbtxM2ZJ5OK337i1/X0CZip1om6dmKN
	z3yXs0Y9NgngrQMgBiZF6VLPSKxdcjo=
X-Google-Smtp-Source: AMsMyM6q13frsoAZ4xAqZiCG4Xm5nEWira6ZJ9vVe6YG5C1/Mh75aGy9vekeidUwoeirPKMuKeImmGnRF6s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b4d:b0:561:b974:94b9 with SMTP id
 p13-20020a056a000b4d00b00561b97494b9mr2300869pfo.26.1665016460299; Wed, 05
 Oct 2022 17:34:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Oct 2022 00:34:06 +0000
In-Reply-To: <20221006003409.649993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221006003409.649993-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006003409.649993-5-seanjc@google.com>
Subject: [PATCH v6 4/7] tools: Add atomic_test_and_set_bit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Peter Gonda <pgonda@google.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221006003406.C6RvKs2VwesihlI5UnT48lzlJGocTKNY5u2M5f64qoE@z>

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

