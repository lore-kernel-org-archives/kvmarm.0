Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FC479FF;
	Wed,  2 Aug 2023 17:09:04 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6b9cf7e6ab2so83288a34.1;
        Wed, 02 Aug 2023 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690996143; x=1691600943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VzgOK7S/nDkSxIWVLP6Niz2nC5TbUp6AvvmSTjYDoz0=;
        b=fPw/kdvfhtWEf4UBlljKxHTeCnXzAczix4g5kutrq7CH0rJnQKdQVspzYFHMZDDs/T
         G/JNOATOQJoDlFrS7qbXFyw97Sar/IhQAYWdjudC/9i0EmPT/+spzXX9oaLLM++MaELe
         s+HfTuVyDtdxU4dU3ngRnCLrjDPUyPH4TtLUuB9tVg0SSLVtb4EyLyRyuAbnpKBGzUol
         PxpK86twd7NPi9GzrENjM4dy5nTMYz06aj3adfEymnxYaBxlEWUj3LpiJUyMrESIKBVi
         dMM/u7xvWZQlPRKFDqFayN7aTgTy5DCS2vs0lYi/a1MgFmntRe+Fe0kJaVRT8CMYkS/J
         FNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690996143; x=1691600943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VzgOK7S/nDkSxIWVLP6Niz2nC5TbUp6AvvmSTjYDoz0=;
        b=AfEIzThTExykNpu3FQLKjAzRY5FDTAgII1c3VIasuTBEJrQFWruoMT8uaiiUHHEokA
         RxqXLYd0I9xJ6k9z7bOTcKdGmVApMlcA3fKs2zkk1KC3bYHELtFQ52l2puMJ5CwO4n3C
         gncEkqyB3n+7xDsqRkpoJ6J2Gdc830xByeqD/Zf9Qlh7aRJ1CvviBbiNgOB1oPzHZO2r
         31t8hx9dlRdgFOA0RGx2iKzb0mELAiKGTCEuspTABrc2O1uLLtEmTW4d0rAt5ybTb4WQ
         MRIQkPynHRN03u97m0UuSpAfCpDKbWDQTjXTagILv9TJ5E2ytwaQkUbf5ZlxRS4ky/IQ
         IT/A==
X-Gm-Message-State: ABy/qLYzz/YjDNXIsQQ1QIba5q8rJj7Oe79DaoJ34xR7Tw8tFkJ7KzlH
	PAGJXy6JxD+U73zuWbX/mPERS8dis/m/l8uIiio=
X-Google-Smtp-Source: APBJJlEunU1vMsI7Ba5iPzVifoTkFdqWTVRlsIl1b3LmpG0allJXwK4ZcEhL9CUMO+GM4B+HRL4Vd9l6rafbjWpjMjs=
X-Received: by 2002:a9d:7a41:0:b0:6b9:482e:ed10 with SMTP id
 z1-20020a9d7a41000000b006b9482eed10mr18099228otm.21.1690996143376; Wed, 02
 Aug 2023 10:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230802150712.3583252-1-elver@google.com> <CANpmjNPVO_t058c6Wcwr9TBwxeoH7Ba0ECsf6Wapn60br8EtkQ@mail.gmail.com>
In-Reply-To: <CANpmjNPVO_t058c6Wcwr9TBwxeoH7Ba0ECsf6Wapn60br8EtkQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Aug 2023 19:08:51 +0200
Message-ID: <CANiq72k7_Ujg31UHfivv8zyog-6Vs7YehTpk2y-qRiuT-KMmAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Compiler attributes: Introduce the __preserve_most
 function attribute
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Guenter Roeck <linux@roeck-us.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nathan Chancellor <nathan@kernel.org>, Tom Rix <trix@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 2, 2023 at 6:51=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
>
> Mark says that there may be an issue with using this in combination
> with ftrace because arm64 tracing relies on AAPCS. Probably not just
> arm64, but also other architectures (x86?).
>
> To make this safe, I'm going to move __preserve_most to
> compiler_types.h and always pair it with notrace and some comments in
> v2.

Sounds good, thanks! The patch here was otherwise good in terms of
`compiler_attributes.h`.

I was also thinking about the implications for Rust. I guess if we
need to call them, we will go through a C helper for the moment, and
later on if we get cross-language LTO (or the LLVM IR hacks), it will
hopefully not be a performance penalty.

Cheers,
Miguel
