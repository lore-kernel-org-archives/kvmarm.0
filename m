Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AE68821
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 18:52:07 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3fe1d462762so2000215e9.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Aug 2023 11:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691002326; x=1691607126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e52Aik7+FekPE4EeT0gUdOPtk6uJBw/P3h7TeG+ZQTM=;
        b=WfVLnk4FWXPNM0WW627hTSTpm7C1QI/GaOlJ/IVv7BwfSgJZ1fD4ypk5OZ8R4EARS8
         CSrHuK7ypa5A+bPWY7otmO7cd8gXEJ6oH8W7EpMd/T7W1knurhj8U/6aodvbqWV3Ztvy
         RGw+qHxhDKdzspoRfTT326Svc/BjrRc2YFlcO/qpICZ2gsdzQlEf3rE/caVy55R8yUmX
         EWZKiBE+y501N0kpmXdMBFH38U2FoYKpAcQMNEb5K2rmcmrHJb/y1JxNpJ8a7wIbb76m
         FGC1n5C8fy/vs4Nq5jKJsUKG+AEaEx9rFb8B+AIzmU4qZ5gYWug1jbhFhWKIYg6fQfJU
         iJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691002326; x=1691607126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e52Aik7+FekPE4EeT0gUdOPtk6uJBw/P3h7TeG+ZQTM=;
        b=G1sNg1zqbVF0ebIOCpdAPekEeHiseNNIPWsnvVGIWzYyN1D27y6F8lhlcGv3Kb5WPS
         9JbyeTPs+JyiBIv4oA3quC8SWulGBNAzayl1YkwhZ2VJO/wSbqK1I1y2NHx+ZVZFhCnM
         EsDWr98dQ6Ht7JnMIVr3PBJti598UOdyE8DmnzLV7yxMc1zfh9w+tjy7EnoM9tMnl2vb
         4yX1e+C5G+ABCmZSAvM2JjDBptqXGcV8HDhFT9U1gtFg7N0Lxn0gWaMFdprd/Vv4AAN2
         qzT44botoFdTkLJ+vqHk6147GRhUGxqB0BRyl0hIrBbFcpgqAhbzEgJW3NKUZ5mK5dIO
         3oMQ==
X-Gm-Message-State: ABy/qLbTyFcQWsQCEKIhtPWN++w47QeskwUq/+JmgnSOA6wcM2H3y90Q
	i1MIehxOhiBN0iDCEIVHEgBybG36e4TMPBqWduszaA==
X-Google-Smtp-Source: APBJJlFGJmuh9G19C0lrt8whk0BOd6695zMBbC3wUwduITvwBCYcOoVfLa4zq2ZnVZjsm9Lnt615gAFmoBX8dXCD6VU=
X-Received: by 2002:a7b:c3d5:0:b0:3fb:b34f:6cd6 with SMTP id
 t21-20020a7bc3d5000000b003fbb34f6cd6mr5624229wmj.41.1691002326042; Wed, 02
 Aug 2023 11:52:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230802150712.3583252-1-elver@google.com> <20230802110303.1e3ceeba5a96076f723d1d08@linux-foundation.org>
In-Reply-To: <20230802110303.1e3ceeba5a96076f723d1d08@linux-foundation.org>
From: Marco Elver <elver@google.com>
Date: Wed, 2 Aug 2023 20:51:29 +0200
Message-ID: <CANpmjNNZ7sRLxCFF0jTZvOK6s-=Z=DOAy8uz=B-i22GEnhNjbA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Compiler attributes: Introduce the __preserve_most
 function attribute
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Guenter Roeck <linux@roeck-us.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Aug 2023 at 20:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed,  2 Aug 2023 17:06:37 +0200 Marco Elver <elver@google.com> wrote:
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
> >
> > Use of this attribute results in better code generation for calls to
> > very rarely called functions, such as error-reporting functions, or
> > rarely executed slow paths.
> >
> > Introduce the attribute to compiler_attributes.h.
>
> That sounds fairly radical.  And no changes are needed for assembly
> code or asm statements?

The callee in this case is supposed to save the registers and restore
them. If the caller (such as in asm) redundantly saves the registers
as well, this would be safe although redundant. That being said, there
are no plans to call functions marked with the attribute from asm.
Only issue would be if someone implements such a function in asm with
a C decl with the attribute - but also, there are no plans to do this.

I'll need to spin a v2 to always add notrace: one way this can go
wrong if something inserts itself between the callers and callee, such
as tracing would.
