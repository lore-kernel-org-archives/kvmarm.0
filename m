Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B510784
	for <kvmarm@lists.linux.dev>; Mon,  7 Aug 2023 13:07:59 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4fe700f9bf7so787231e87.0
        for <kvmarm@lists.linux.dev>; Mon, 07 Aug 2023 06:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691413677; x=1692018477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/4R25p4daYUTehiyP/H6NfDF6hC+5JyB6EXsqzz6/k=;
        b=CZsy0pok8t9/vlnLGm4O8VdNxEk0CcQX2MtFvzA2zSKcr8mMAe0DHTmVORe3TDmzNw
         NlF98o2pOwjM3gbhA2QBbnDzxhJUiV/U14l+nq8StfHXCTZfVHlYP9ZlKqXusZ0MlNLC
         SK3ueVaMMD7GEHVsMwmSnVoS7V8McfsYWRjgqBM+Dqysuzn0htMOI8pLZIeMOL9V8kOk
         GfsDu5bZ2tVfFVCrEahlI24fLYcd2yhZRD9SE6+P+EWGV2iJoZJ7auhrzdCqn5PTf3VO
         EflwubvyoVGschLEAI4Xekv7e/Ols84VsR0+dEphPPzqt92Kz0IAjzB3qzrSudUbP8jb
         92KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691413677; x=1692018477;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/4R25p4daYUTehiyP/H6NfDF6hC+5JyB6EXsqzz6/k=;
        b=iKsv+kexvnC0rqNkkbRlcYOzxkp5bv/6aS8kszIHDPTk3GIz6FXCItH1PgUHiI53vC
         +9dUs/6Y8PqCx7uLPrBloM5LHri0BFps4KLhteb6Vwd5ZH9BZkmB9ihymXo3WBvCnXBi
         JUFDyAN9yz4P9LKIs4Mr1UktpPabhkN+zlikwD5UGViHe43+PChR6rIIr3pnyYRFaA8v
         9Bqr9YkPAT9vx7E6Q2FjOSigvLk4q9IbdXi6wxlR/lXAO0Xoa/Zf7NLIsgMGKdsU+vSK
         A9Kk+XFLA8Z/G5qIiR1T/GGcjhGUSLqOD32jvHmVLHSOuLCOz0SSAqfWF9ZK1GiwBuWO
         DTnw==
X-Gm-Message-State: AOJu0Yzq9I4bQ2aHqgNc+BZbTWQxjlNWUgK+aFE5CTDRVJE7DthaD2fz
	UUxtyH6aJW3BjA/hPH4JhSctEbALFrbEXHRvh2YMyg==
X-Google-Smtp-Source: AGHT+IG88guCru7RMnods2FuhCiVzsW89iZtW1ovHWdm8V/bf9L2PO5Zpf2azd4F+0e536gG22KOf2XlazGJw24fQoo=
X-Received: by 2002:a05:6512:358b:b0:4fd:d4b4:faba with SMTP id
 m11-20020a056512358b00b004fdd4b4fabamr5211620lfr.51.1691413677214; Mon, 07
 Aug 2023 06:07:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com> <87il9rgjvw.fsf@oldenburg.str.redhat.com>
 <CANpmjNN4h2+i3LUG__GHha849PZ3jK=mBoFQWpSz4jffXB4wrw@mail.gmail.com> <87pm3zf2qi.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87pm3zf2qi.fsf@oldenburg.str.redhat.com>
From: Marco Elver <elver@google.com>
Date: Mon, 7 Aug 2023 15:07:20 +0200
Message-ID: <CANpmjNMoxZYZQNyZcnci_rC6d6X4WKpS+fX9goaBdGCJFPjUNQ@mail.gmail.com>
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

On Mon, 7 Aug 2023 at 14:37, Florian Weimer <fweimer@redhat.com> wrote:
>
> * Marco Elver:
>
> > Good idea. I had already created
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110899, and we need
> > better spec to proceed for GCC anyway.
>
> Thanks for the reference.
>
> >> Doesn't this change impact the kernel module ABI?
> >>
> >> I would really expect a check here
> >>
> >> > +#if __has_attribute(__preserve_most__)
> >> > +# define __preserve_most notrace __attribute__((__preserve_most__))
> >> > +#else
> >> > +# define __preserve_most
> >> > +#endif
> >>
> >> that this is not a compilation for a module.  Otherwise modules built
> >> with a compiler with __preserve_most__ attribute support are
> >> incompatible with kernels built with a compiler without that attribute.
> >
> > That's true, but is it a real problem? Isn't it known that trying to
> > make kernel modules built for a kernel with a different config (incl.
> > compiler) is not guaranteed to work? See IBT, CFI schemes, kernel
> > sanitizers, etc?
> >
> > If we were to start trying to introduce some kind of minimal kernel to
> > module ABI so that modules and kernels built with different toolchains
> > keep working together, we'd need a mechanism to guarantee this minimal
> > ABI or prohibit incompatible modules and kernels somehow. Is there a
> > precedence for this somewhere?
>
> I think the GCC vs Clang thing is expected to work today, isn't it?

I, personally, wouldn't bet on it. It very much depends on the kernel
config used.

> Using the Clang-based BPF tools with a GCC-compiled kernel requires a
> matching ABI.

BPF is a different story altogether, and falls more into the category
of user space to kernel ABI, which the kernel has strong guarantees
on.

> The other things you listed result in fairly obvious breakage, sometimes
> even module loading failures.  Unconditional crashes are possible as
> well.  With __preserve_most__, the issues are much more subtle and may
> only appear for some kernel/module compielr combinations and
> optimization settings.  The impact of incorrectly clobbered registers
> tends to be like that.

One way around this would be to make the availability of the attribute
a Kconfig variable. Then externally compiled kernel modules should do
the right thing, since they ought to use the right .config when being
built.

I can make that change for v3.
