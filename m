Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA36DDBF
	for <kvmarm@lists.linux.dev>; Tue,  8 Aug 2023 10:21:28 +0000 (UTC)
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3178e3f46b1so2546890f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 03:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691490087; x=1692094887;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hmnOfvRNRbQKO2Fig5tO7oMJZvMK80sR98XXmZHYIOg=;
        b=UcRiSP5zMkafefDkpMy4ag+CqrreExj50BgcvvqUxENJG1/lpohTMUGaMRE6dQWAe+
         dc0KSS4bJtSXBo6u8B2TD1qebHcDd5nh7/wEMRUvQktCQ4V/bMLKV0b1xtucMQ2ElFsD
         ND4RxmLFCJwArzcfgz12LoyG/eZo31pUrpRu20Td78p+BpbDSmOfCjj+Z+IC7HAW0UJI
         wNAjAblR9P5aB6un9d6Wp0XUwVazJc3Q87ZThxQIRdmvgDi/7Bg1jdLM7HiLjR2VXgNZ
         T2SsfgyBgPh1IFQrdE4pgKb+j8xLGZwt6QAMfltBDv+DaBw14Bc1t2LIR4Vp0fXHemjD
         QpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691490087; x=1692094887;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hmnOfvRNRbQKO2Fig5tO7oMJZvMK80sR98XXmZHYIOg=;
        b=H72t5s0epvXAeO+6ptj48Ga9AfCfGI6w1KKcIkzBF9ZvSsgs5WwvA27qBlP93gVUeZ
         IlVkSh/+xikWRsBDsFmi2mLAonD0voh4yXI0ZGTKFAFu55jkt2aO/bGh5zwxWNlo0sG6
         LiiBieOpDt+7KvuZ4hMzQWV1TiA619ipoNhct2C+mZn2d1yWy8vesTuJ7TRTU5HpL2yc
         y76kVMEE2a1RaQt9g1SdbH15YP9QE6pMBaWhU82d3BpGbas+K0Df3dgBJqWHnJuvykOS
         kZfQ15I/iVelLl+UcLpjNk1U0VrUxtmKpmEHO7Z341cK1wvhrIEGqBWddcPvKQSOQh8E
         0ELA==
X-Gm-Message-State: AOJu0YwwpMS/m/qnX035TNKp4wi77pJcEX43k/d/j2X4Q+bv8FOH3Nf0
	KQNH9zcZ+2v9uoJG15OYIkfrbRgUfQ==
X-Google-Smtp-Source: AGHT+IFO91+Sq0a4bROaXXMkpleB+MNLqFDhhb5O1iR8Zhdu/8OTj2ivFrTXYjJox8ukr1691thj7vV+Eg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:39c0:833d:c267:7f64])
 (user=elver job=sendgmr) by 2002:adf:f0cb:0:b0:317:5e4f:9097 with SMTP id
 x11-20020adff0cb000000b003175e4f9097mr74564wro.7.1691490086705; Tue, 08 Aug
 2023 03:21:26 -0700 (PDT)
Date: Tue,  8 Aug 2023 12:17:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230808102049.465864-1-elver@google.com>
Subject: [PATCH v3 1/3] compiler_types: Introduce the Clang __preserve_most
 function attribute
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

[1]: "On X86-64 and AArch64 targets, this attribute changes the calling
convention of a function. The preserve_most calling convention attempts
to make the code in the caller as unintrusive as possible. This
convention behaves identically to the C calling convention on how
arguments and return values are passed, but it uses a different set of
caller/callee-saved registers. This alleviates the burden of saving and
recovering a large register set before and after the call in the caller.
If the arguments are passed in callee-saved registers, then they will be
preserved by the callee across the call. This doesn't apply for values
returned in callee-saved registers.

 * On X86-64 the callee preserves all general purpose registers, except
   for R11. R11 can be used as a scratch register. Floating-point
   registers (XMMs/YMMs) are not preserved and need to be saved by the
   caller.

 * On AArch64 the callee preserve all general purpose registers, except
   x0-X8 and X16-X18."

[1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most

Introduce the attribute to compiler_types.h as __preserve_most.

Use of this attribute results in better code generation for calls to
very rarely called functions, such as error-reporting functions, or
rarely executed slow paths.

Beware that the attribute conflicts with instrumentation calls inserted
on function entry which do not use __preserve_most themselves. Notably,
function tracing which assumes the normal C calling convention for the
given architecture.  Where the attribute is supported, __preserve_most
will imply notrace. It is recommended to restrict use of the attribute
to functions that should or already disable tracing.

The attribute may be supported by a future GCC version (see
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110899).

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
v3:
* Quote more from LLVM documentation about which registers are
  callee/caller with preserve_most.
* Code comment to restrict use where tracing is meant to be disabled.

v2:
* Imply notrace, to avoid any conflicts with tracing which is inserted
  on function entry. See added comments.
---
 include/linux/compiler_types.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 547ea1ff806e..c88488715a39 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -106,6 +106,34 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 #define __cold
 #endif
 
+/*
+ * On x86-64 and arm64 targets, __preserve_most changes the calling convention
+ * of a function to make the code in the caller as unintrusive as possible. This
+ * convention behaves identically to the C calling convention on how arguments
+ * and return values are passed, but uses a different set of caller- and callee-
+ * saved registers.
+ *
+ * The purpose is to alleviates the burden of saving and recovering a large
+ * register set before and after the call in the caller.  This is beneficial for
+ * rarely taken slow paths, such as error-reporting functions that may be called
+ * from hot paths.
+ *
+ * Note: This may conflict with instrumentation inserted on function entry which
+ * does not use __preserve_most or equivalent convention (if in assembly). Since
+ * function tracing assumes the normal C calling convention, where the attribute
+ * is supported, __preserve_most implies notrace.  It is recommended to restrict
+ * use of the attribute to functions that should or already disable tracing.
+ *
+ * Optional: not supported by gcc.
+ *
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#preserve-most
+ */
+#if __has_attribute(__preserve_most__)
+# define __preserve_most notrace __attribute__((__preserve_most__))
+#else
+# define __preserve_most
+#endif
+
 /* Builtins */
 
 /*
-- 
2.41.0.640.ga95def55d0-goog

