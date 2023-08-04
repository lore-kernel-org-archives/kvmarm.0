Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61EE1AA6B
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 17:50:27 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-3fe426b86a8so15361655e9.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 10:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691171426; x=1691776226;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Im4dcEZwNsAe1Y2oMqCTaJQsYwxClHXtIW7/6pymoyo=;
        b=UphmCrMdpkSP7a4kk/vE3lUOeIiuyB34qLRvc1hVE1UR5N24Pb2doPpops1e0fJZO3
         l7+Bk3H7d5jOmKNeKhcDLsMZJNuIyHqNmGr75RUO5jWp2HPE5ptjfRqhQ0IrbU7mEv97
         MuSxSto9os2ONR7Oe9dcetZWP8f9vvHSvb+t8rF4ZYgDh27z2ODAr7TqttRRHIADws9s
         Ae5OPXRm1TlbOsahEMKzhYUMk1sQ9dGAdCwA0kmpXEK+3dKfbfK4mxVDVwPW58H6cw05
         yLRe304WmuDsKIOPh9865os6tl4CxYMAVH/YKDrjCu9dUNU4OoRCLk4W+tWKgRLfg3Nw
         KRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691171426; x=1691776226;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Im4dcEZwNsAe1Y2oMqCTaJQsYwxClHXtIW7/6pymoyo=;
        b=Y01oo63n+sOd6TAMMzft6V4/V3/bMP5mYYs1UqesqGTq2bMw61CIOOcM/L0RfOEh7X
         b58eHThtsFAlcyJcX5avx7h9g2IXuYpfPop07Zt1KmvcKz83aIiRsPuIpoxmTEm/ZQ45
         OTuzobic+oWzk7vHkuN9UIkjNTfwEjr6ZBVtDgzowNCywppZq5jOy8UY+PS/gzDzOR2F
         EDU69aEkFociaGx+3Uudcev2H8LnNMyTkg01NAXZLd6xlqNhYg2HQ7JqefGdwdHMgn8Z
         XNYg4DhVuFPEtELU0eMeNL/cosc2Zd28g2oDLymlqVu2vFRP8Ar+6RkHV9RY0BhPSGE7
         ZXKg==
X-Gm-Message-State: AOJu0YyJxUqOhvnlq1UNbGo/YqCyNs78xgGv7Y77UZmsY0B5/gnEq3VR
	zuDYv8dTDf5Rbbl+889lU3qKw7LN5gja14s3ePA8kg==
X-Google-Smtp-Source: AGHT+IFCpKdw5xT0hmDqmMcqVOJlFAgL0wRRdu5YxGtWnPb4KKrgp8kcqaD2UASnRwTjmhmQD6u7JjQJgAG5sZzFLQo=
X-Received: by 2002:a1c:cc08:0:b0:3fe:485f:ed13 with SMTP id
 h8-20020a1ccc08000000b003fe485fed13mr2162276wmb.29.1691171425779; Fri, 04 Aug
 2023 10:50:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com> <20230804090621.400-2-elver@google.com>
 <20230804120308.253c5521@gandalf.local.home>
In-Reply-To: <20230804120308.253c5521@gandalf.local.home>
From: Marco Elver <elver@google.com>
Date: Fri, 4 Aug 2023 19:49:48 +0200
Message-ID: <CANpmjNNN6b9L72DoLzu5usGGjLw5Li8rnfu0VuaCsL-p2iKTgg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] list_debug: Introduce inline wrappers for debug checks
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, 
	Guenter Roeck <linux@roeck-us.net>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, 
	linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Aug 2023 at 18:03, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  4 Aug 2023 11:02:57 +0200
> Marco Elver <elver@google.com> wrote:
>
> > Turn the list debug checking functions __list_*_valid() into inline
> > functions that wrap the out-of-line functions. Care is taken to ensure
> > the inline wrappers are always inlined, so that additional compiler
> > instrumentation (such as sanitizers) does not result in redundant
> > outlining.
> >
> > This change is preparation for performing checks in the inline wrappers.
> >
> > No functional change intended.
>
> I think the entire underscoring functions calling more underscoring
> functions in the kernel is an abomination. Yes, there's lots of precedence
> to this craziness, but let's not extend it.
>
> Can we give actual real names to why the function is "special" besides that
> it now has another underscore added to it?
>
> I've been guilty of this madness myself, but I have learned the errors of
> my ways, and have been avoiding doing so in any new code I write.

That's fair. We can call them __list_*_valid() (inline), and
__list_*_valid_or_report() ?
