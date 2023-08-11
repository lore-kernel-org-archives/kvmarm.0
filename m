Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CFA125AC
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 15:19:58 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-56942442eb0so25276247b3.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 08:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691767198; x=1692371998;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1vaThr58cHhzt3vCJBdqBIs2Yl/3Z2jvMp4OgQvCHVc=;
        b=5xqJ+9vOp2nrO/mxnyBJ/b/1HWLsgBT1IHmI50RXMG+v00b5fp1vs2Rwd8BJ+9On+a
         Q4jl5SsKlofCJHbO3RpNFGWeldC2dgdOf7WiBs7B3msfJcvntjhupdIzPNHiuqPJVz+z
         R/HdlzmM4cQEmJpgDlmTthNmGG/KyvuF0gdplPRvM4udG74+d0udlvizD0YfOPv0Opv2
         3tPbceoZMBOxCBuYZR9Iewa4BKkdIHfl4kSzyUUw34WMnBaidreMjrhu73PoE0V1Y3HY
         Lo9Pzzu3F/0G/X2jav91I9Oukq8tP4eQTMYHi0nGsMKpFT4HL5VWbyKeiy/SS6PBE/G+
         bSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691767198; x=1692371998;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1vaThr58cHhzt3vCJBdqBIs2Yl/3Z2jvMp4OgQvCHVc=;
        b=Jtuoa7B4qhxIbKumne2hD6b7LyIkt+8BDmA+XCzlNvpmN13ASlk3nraR5XpVg1PLZZ
         jbxA0AK8NgjUyh1XUvxkXqQT/xYnbMxiN6r9Oz71S6EpOvved/UlWPQx8U1D4YXPh+0R
         mieCRS/7ZOWJDo+6tJFB1l/udUvXcLP1GtYLddrSdOxm4UG9FUZ5qBoeoLSvHGrMbxqa
         rXXv/npMZ99JR2EoJUZ28KqcIy3WQYsc6zLbvQ1gxfJ/cOldUdT+VqqcwIWAGikaLaQX
         76u4RswROxpy5cYGnk1yzGEQ+2hTVhRwUpkeyJuGJqHC9YXueozlk9a+yF4K4DwqUnsm
         pLsQ==
X-Gm-Message-State: AOJu0YzxxnJmsmQzPTqSmTcGiYPcd4rOcssL7P9ao93zxTw0mKrYb57S
	varzXHQWdhnw7UuMkt5n6rPZbCYb2Q==
X-Google-Smtp-Source: AGHT+IHOFdGW52whxAtpTQwrYswR+9FGN+f7HEI1ais6Hmme/G/bIwskagiWtjT5lu9yqzqehThNh6eXAg==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:9c:201:8dc0:5176:6fda:46a0])
 (user=elver job=sendgmr) by 2002:a81:451d:0:b0:589:9d51:c8c0 with SMTP id
 s29-20020a81451d000000b005899d51c8c0mr41482ywa.2.1691767197794; Fri, 11 Aug
 2023 08:19:57 -0700 (PDT)
Date: Fri, 11 Aug 2023 17:18:38 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230811151847.1594958-1-elver@google.com>
Subject: [PATCH v4 1/4] compiler_types: Introduce the Clang __preserve_most
 function attribute
From: Marco Elver <elver@google.com>
To: elver@google.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	llvm@lists.linux.dev, Dmitry Vyukov <dvyukov@google.com>, 
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
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

Note: The additional preprocessor check against architecture should not
be necessary if __has_attribute() only returns true where supported;
also see https://github.com/ClangBuiltLinux/linux/issues/1908. But until
__has_attribute() does the right thing, we also guard by known-supported
architectures to avoid build warnings on other architectures.

The attribute may be supported by a future GCC version (see
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110899).

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
v4:
* Guard attribute based on known-supported architectures to avoid
  compiler warnings about the attribute being ignored.

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
index 547ea1ff806e..c523c6683789 100644
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
+#if __has_attribute(__preserve_most__) && (defined(CONFIG_X86_64) || defined(CONFIG_ARM64))
+# define __preserve_most notrace __attribute__((__preserve_most__))
+#else
+# define __preserve_most
+#endif
+
 /* Builtins */
 
 /*
-- 
2.41.0.694.ge786442a9b-goog

