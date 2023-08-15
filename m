Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E217ABF
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 18:22:38 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3fe2fb9b4d7so51807325e9.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 11:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692123756; x=1692728556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rRFUf4dNqMSfHq2+lBU85kOOjIYPLnDmd2dSara3YQ0=;
        b=B5+dfis4GodiyMswujpdft5yTaiXEq+hCwoLLuJZRiCvztSGpvOULmk8iJEZg0adZH
         BY8An2LpsxdQEREmqow3gZhdUpFsyxA5U4miqfRxIUa2E7orC7Q7Ko0rzGuYQoBGy3qE
         uJuL2aJukQjiTszT6TACOaiShD5ikUEvhecLDrbpWvp0vfZwKh8yvRzW81AuKihenO+k
         gAvQFt9BBsbYBPBrxoO18Y0Bx8A9NLjX4Dppy7CnQFNiNPm0XWjqjxeGhTirjoSgNZrN
         VA5L9DiSGMhLlpHCXIi62EV9vWnA4wHPi/7SHM9HSJEE9w35I7MEUBr2S7/c/OBIEDC9
         TeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692123756; x=1692728556;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rRFUf4dNqMSfHq2+lBU85kOOjIYPLnDmd2dSara3YQ0=;
        b=JdYP/c3nrxLAiYw5iCd/0z2dgJpgWkBKuh34iKbp8m74MVvLVNMS/9mY0cwp46qC8Y
         +P5jmx8AkKiAI9g1CEwZOKsKl5WU30m7pKub6VzdC79WTtHo50yRBxdD+x2v01RDhmTm
         24OuB09ipbYvpJYU+ra86Mlt+ySiUZLPqa1fds5e/yWxbZ+VJ1yqSDHBKsjsoY/T+VWF
         qsNys8AioYLAOMXiZfSIBxwKcvF3sk6ROCU6rBHIQSH83FgCpeB1Z83mVaHQJQsboFn0
         8VzkF8Afs9yNk577jJd4WswhmgEGdyZ1lx4BdUjIUVmxz9n06ASE/91bFxEkLj/x0D17
         Ka0Q==
X-Gm-Message-State: AOJu0Yz3fNoK6cPsdFYWQjVCFILCh2KFwJPzKNe0Qr/MwBvqTRxgPIF1
	meqTi+me3SN/cg2GeLZbbA1fw3LjyhJIgd98ImVlRA==
X-Google-Smtp-Source: AGHT+IGIPWace5mdmcxiYsdjUOHTOAtdVTz9UvfQVQP31URfweI7ITp2r94AA2XEk86pkT7L3VWHyy8DVHcpStWzCas=
X-Received: by 2002:a7b:cd99:0:b0:3fe:14af:ea21 with SMTP id
 y25-20020a7bcd99000000b003fe14afea21mr10108651wmj.21.1692123756120; Tue, 15
 Aug 2023 11:22:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230811151847.1594958-1-elver@google.com> <202308141620.E16B93279@keescook>
In-Reply-To: <202308141620.E16B93279@keescook>
From: Marco Elver <elver@google.com>
Date: Tue, 15 Aug 2023 20:21:59 +0200
Message-ID: <CANpmjNNDcVK9gmnBfxbthD3KEzsdc=PJb97AXcPEaweLNM5mPw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] compiler_types: Introduce the Clang
 __preserve_most function attribute
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
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

On Tue, 15 Aug 2023 at 01:21, Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Aug 11, 2023 at 05:18:38PM +0200, Marco Elver wrote:
> > [1]: "On X86-64 and AArch64 targets, this attribute changes the calling
> > convention of a function. The preserve_most calling convention attempts
> > to make the code in the caller as unintrusive as possible. This
> > convention behaves identically to the C calling convention on how
> > arguments and return values are passed, but it uses a different set of
> > caller/callee-saved registers. This alleviates the burden of saving and
> > recovering a large register set before and after the call in the caller.
> > If the arguments are passed in callee-saved registers, then they will be
> > preserved by the callee across the call. This doesn't apply for values
> > returned in callee-saved registers.
> >
> >  * On X86-64 the callee preserves all general purpose registers, except
> >    for R11. R11 can be used as a scratch register. Floating-point
> >    registers (XMMs/YMMs) are not preserved and need to be saved by the
> >    caller.
> >
> >  * On AArch64 the callee preserve all general purpose registers, except
> >    x0-X8 and X16-X18."
> >
> > [1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most
> >
> > Introduce the attribute to compiler_types.h as __preserve_most.
> >
> > Use of this attribute results in better code generation for calls to
> > very rarely called functions, such as error-reporting functions, or
> > rarely executed slow paths.
> >
> > Beware that the attribute conflicts with instrumentation calls inserted
> > on function entry which do not use __preserve_most themselves. Notably,
> > function tracing which assumes the normal C calling convention for the
> > given architecture.  Where the attribute is supported, __preserve_most
> > will imply notrace. It is recommended to restrict use of the attribute
> > to functions that should or already disable tracing.
> >
> > Note: The additional preprocessor check against architecture should not
> > be necessary if __has_attribute() only returns true where supported;
> > also see https://github.com/ClangBuiltLinux/linux/issues/1908. But until
> > __has_attribute() does the right thing, we also guard by known-supported
> > architectures to avoid build warnings on other architectures.
> >
> > The attribute may be supported by a future GCC version (see
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110899).
> >
> > Signed-off-by: Marco Elver <elver@google.com>
> > Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> > Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
>
> Should this go via -mm, the hardening tree, or something else? I'm happy
> to carry it if no one else wants it?

v3 of this series is already in mm-unstable, and has had some -next
exposure (which was helpful in uncovering some additional issues).
Therefore, I think it's appropriate that it continues in mm and Andrew
picks up the latest v4 here.

Your official Ack would nevertheless be much appreciated!

Thanks,
-- Marco
