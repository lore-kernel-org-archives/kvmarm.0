Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102B8101FB
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 12:25:04 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-3fe5c0e57d2so7225665e9.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 05:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691411103; x=1692015903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsP5nkPghUp19sfWVmpj073CCh46k2F98rtPHNJSKVE=;
        b=HCbP5hjavSOBpxbGA+3+VYKzXpS4H7ymx4XR1LfBAYF16hB5A60P/4lgvu/hlStE5x
         XCCUrDeOttgSewGGrBWzV2ziExaEA9G6mDSgoQhJadBJN4drjZK7qBKf0fKZAh+PnliW
         9juWbu9vE9KrTBTJ9+gtYcNx6Jsx9FT6V9pKUXGIcxINseiGmqfZNKmbvQsZXkIGF1am
         iq4ns7vUvfllyChtK+eZExZJHznzI9FXeWjyebx9Ao1qWVzJsko2eN9kbVmNE7qSJO8j
         s+R8Ruqmt0Dpu8uXWhAKmqkzUjVNyAU3Xev7Coz+RqjQnJKeKomKnh8TWQNDiw1gldSc
         TL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691411103; x=1692015903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fsP5nkPghUp19sfWVmpj073CCh46k2F98rtPHNJSKVE=;
        b=NyDoVbK19J6bEj+pRLGJ7YMTH8CSjoJUSkEV9f39kP5HEs6qLO3eZFK5m+XNhUxtY1
         JcE4aSY0sAtLiJcKYVxyECNhzuXZEY4nUc0mGnTiu/0Ayz/yU1YI3tnp7e4fgdWmspCI
         DpZJQTcNcXpFE8dq8a0YgStDXlj21n7Xw9t8VIG+DOdLI4O/ZTxnH/ZdYNNA8MCOKE48
         wHdX+UW6ctmMsQaXMara7KOqpf4XsaATzde/OvzkNl9tajN0jHjjMQnHreyJglUqCc8E
         J5pZmXj1EoUBVFqs4MMRi530uOTc9jlvTCt0Lxx7uXMMuMQt1aXyOI+gciPLTpsdC2JA
         j/Vw==
X-Gm-Message-State: AOJu0Yw6KckzbO8DGbEJFEeQo6h8juVq8Sm2UdDn4h1tGn7Z0OK8cBU0
	B3rfKP2ILZyhklbqrHobb0+iv0jEYRxQlUVqngYJ4g==
X-Google-Smtp-Source: AGHT+IGkDhKJzd1NsPjdHLX/dy9J8I2IzVN5ca8X5YV/X01EYWiVAfJfHJU+rwDFAp/3zaQfVRurPFTpiwow+cQF060=
X-Received: by 2002:a7b:cd94:0:b0:3fe:3521:d9ca with SMTP id
 y20-20020a7bcd94000000b003fe3521d9camr5908666wmj.3.1691411102967; Mon, 07 Aug
 2023 05:25:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com> <87il9rgjvw.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87il9rgjvw.fsf@oldenburg.str.redhat.com>
From: Marco Elver <elver@google.com>
Date: Mon, 7 Aug 2023 14:24:26 +0200
Message-ID: <CANpmjNN4h2+i3LUG__GHha849PZ3jK=mBoFQWpSz4jffXB4wrw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] compiler_types: Introduce the Clang
 __preserve_most function attribute
To: Florian Weimer <fweimer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Aug 2023 at 13:41, Florian Weimer <fweimer@redhat.com> wrote:
>
> * Marco Elver:
>
> > [1]: "On X86-64 and AArch64 targets, this attribute changes the calling
> > convention of a function. The preserve_most calling convention attempts
> > to make the code in the caller as unintrusive as possible. This
> > convention behaves identically to the C calling convention on how
> > arguments and return values are passed, but it uses a different set of
> > caller/callee-saved registers. This alleviates the burden of saving and
> > recovering a large register set before and after the call in the
> > caller."
> >
> > [1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most
>
> You dropped the interesting part:

I will add it back for the kernel documentation.

> | If the arguments are passed in callee-saved registers, then they will
> | be preserved by the callee across the call. This doesn=E2=80=99t apply =
for
> | values returned in callee-saved registers.
> |
> |  =C2=B7  On X86-64 the callee preserves all general purpose registers, =
except
> |     for R11. R11 can be used as a scratch register. Floating-point
> |     registers (XMMs/YMMs) are not preserved and need to be saved by the
> |     caller.
> |
> |  =C2=B7  On AArch64 the callee preserve all general purpose registers, =
except
> |     X0-X8 and X16-X18.
>
> Ideally, this would be documented in the respective psABI supplement.
> I filled in some gaps and filed:
>
>   Document the ABI for __preserve_most__ function calls
>   <https://gitlab.com/x86-psABIs/x86-64-ABI/-/merge_requests/45>

Good idea. I had already created
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D110899, and we need
better spec to proceed for GCC anyway.

> Doesn't this change impact the kernel module ABI?
>
> I would really expect a check here
>
> > +#if __has_attribute(__preserve_most__)
> > +# define __preserve_most notrace __attribute__((__preserve_most__))
> > +#else
> > +# define __preserve_most
> > +#endif
>
> that this is not a compilation for a module.  Otherwise modules built
> with a compiler with __preserve_most__ attribute support are
> incompatible with kernels built with a compiler without that attribute.

That's true, but is it a real problem? Isn't it known that trying to
make kernel modules built for a kernel with a different config (incl.
compiler) is not guaranteed to work? See IBT, CFI schemes, kernel
sanitizers, etc?

If we were to start trying to introduce some kind of minimal kernel to
module ABI so that modules and kernels built with different toolchains
keep working together, we'd need a mechanism to guarantee this minimal
ABI or prohibit incompatible modules and kernels somehow. Is there a
precedence for this somewhere?
