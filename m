Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A81A1BEEB
	for <kvmarm@lists.linux.dev>; Fri,  4 Aug 2023 18:08:50 +0000 (UTC)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4fe28e4671dso4157516e87.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Aug 2023 11:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691172528; x=1691777328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fsI9PvVRlWWAw6F53JK6JF21HssLhBf6Wzr398dkifg=;
        b=X23tQDKFZHZXw8vPF2onfJSiUk154utWV6xqv1kCTYlgpZUjj2KkNegETxF601fdJl
         dm76y8nVjeePT6jAyycp3SiPMxChFEicabp4u8TD9JeI3W6a6rpO3ZlaW3E3vq94Q+dv
         LWQocPYMMJy3D4WpvEKTD4ZKOlZ82sgBoGZFgOdmPo+tkJMxdIlUOCi5SSfDJpDRGxQi
         A8p+IdoK61KVNPKWg049Z+sXkrRoPFq0G1UJintkhqNdDNbBqGH53DDuNAoL0VO/pLdt
         SSQvOr4+k6UDpjEZMBERx82yG7cSmjPhdqT32mxaXm/q3NpJAeX7MwZIbVeMYvXnUMH6
         XGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691172528; x=1691777328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fsI9PvVRlWWAw6F53JK6JF21HssLhBf6Wzr398dkifg=;
        b=LSQWIoWrFLIC1JKs/OAMDKc8xPxWgh51QZrR/VxMW/CRFshNBrWHyrSi6UAaZu2cz/
         GAHmdgcWqVy2Os3IwjjRSgIcmlAI8tAVmLu5WpsirHHGzPLMrbyw2abokBtC3vwyXieJ
         8kfcdpcPIklCj/T2hFiUbf80Z/OnMud68pqcIzQD96tuMToBtsMqlb4zpvdfwkfsqZBP
         CuamnbcJZnVd5TLf3YWiurMzmd3eHuJfgBhxU0dHAoY0J4q3YXdzs4+qu69dwsFo2W+E
         xNTq2fgN6ZcpFfvEAHYo3cxtnyvlgmNgPaiGygnz+WT/DNivwlcc9ADONA8aWYZJCtPJ
         vypg==
X-Gm-Message-State: AOJu0YzOQYfnLwAc5Iw363iZecuUlvT78Yq2J6HyfuW6LRnF794DcVM+
	IjHrZXtatMbD7jjHjQBcAOrCrY+YDHls4CVQtVm+xw==
X-Google-Smtp-Source: AGHT+IGyzN84161ZVHwtE2F/keTNz/u1GwxFBnzoFsr0eNmQ2zjl00SMrwlc9THZutNzTKjC7toTVi0zxPqJSe8t74o=
X-Received: by 2002:a05:6512:3297:b0:4fb:9446:598b with SMTP id
 p23-20020a056512329700b004fb9446598bmr1882858lfe.27.1691172528068; Fri, 04
 Aug 2023 11:08:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230804090621.400-1-elver@google.com> <20230804090621.400-2-elver@google.com>
 <20230804120308.253c5521@gandalf.local.home> <CANpmjNNN6b9L72DoLzu5usGGjLw5Li8rnfu0VuaCsL-p2iKTgg@mail.gmail.com>
 <20230804135757.400eab72@gandalf.local.home> <20230804135902.7925ebb6@gandalf.local.home>
In-Reply-To: <20230804135902.7925ebb6@gandalf.local.home>
From: Marco Elver <elver@google.com>
Date: Fri, 4 Aug 2023 20:08:10 +0200
Message-ID: <CANpmjNPqfucNx7NdPOGSjjYgiZHntaBozGY1_rOSC4Wn4YCF1Q@mail.gmail.com>
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

On Fri, 4 Aug 2023 at 19:59, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 4 Aug 2023 13:57:57 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 4 Aug 2023 19:49:48 +0200
> > Marco Elver <elver@google.com> wrote:
> >
> > > > I've been guilty of this madness myself, but I have learned the errors of
> > > > my ways, and have been avoiding doing so in any new code I write.
> > >
> > > That's fair. We can call them __list_*_valid() (inline), and
> > > __list_*_valid_or_report() ?
> >
> > __list_*_valid_check() ?

Well, in patch 3/3, the inline function will also do a reduced set of
checking, so "valid_check" is also misleading because both will do
checks.

The key distinguishing thing between the inline and non-inline version
is that the non-inline version will check more things, and also
produce reports.

So I can see

 1. __list_*_valid_or_report()
 2. __list_*_full_valid()

To be appropriate. Preference?

> I have to admit, I think the main reason kernel developers default to using
> these useless underscores is because kernel developers are notoriously
> lousy at naming. ;-)

Heh, naming is hard. ;-)
