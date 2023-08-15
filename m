Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69119880
	for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 21:58:36 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so4498263a12.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Aug 2023 14:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692136716; x=1692741516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Z8K31bkMTbdIni3NCgyAAMv9oewxKBq0qkaddr2kYE=;
        b=P5OEd4Nl1vFHMOZX0kiCCsg+ALdbM3Jq7SfXh8p09T5kt+BwT3N3A+WU/8d7eCFd2O
         LhOZTvl4ubIun+RbYT+844ggRTfu97S+QvSvLYZmQxkd8QzSViGI+4eiZUxpV4gS+ntY
         ZYn+0xq6abTK4+oIdkRuBdtGRoW6CGc4TDtu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692136716; x=1692741516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Z8K31bkMTbdIni3NCgyAAMv9oewxKBq0qkaddr2kYE=;
        b=GmDBI/5MWomlPYnsBxy3zP/kYsVpDlrdxXtAAV1+yayzlbnbq3mVTDyvrSW2hD3x6u
         Y8ELe5Ea0YnNmchxrr2spvvLxHHCBYpP1vwtPt/DQgslJ8LLOehUzWnoyHmVXrqqz2Ng
         wz7ZwrjO2iJ48CRelnWliN1hiZG12zz2D8lmOMeTa/hNaA2SbDrZ+NhJAcbsE2Za5/Eq
         IDuWwx/q8uWjBcVz1n7WH9YBUBxz5gzO9jJA248tB5gRiri0XIioNzaQyTj1bofqz3f6
         e4iQElq8ihZiNlB1XSdxihIitFVBFK/4QhHgEn6Fs4nT0ifW/gA+6dYIVcatosWrYJFf
         tFgQ==
X-Gm-Message-State: AOJu0YzjfNYWhKi6ef3yNa7qmPPeWNT/UgQPfTZGTfERSGYdU/E2furX
	4MYMRvyh8vaXzxcuKsNuJIOCkg==
X-Google-Smtp-Source: AGHT+IGIGJcDqcADsYQ9H0lWCBGqrfD4exL5cuoWWqNOlf/hsRbDS674HVOPC9PdGLNB8RfKgc3Qug==
X-Received: by 2002:a05:6a20:938b:b0:141:69d:8041 with SMTP id x11-20020a056a20938b00b00141069d8041mr158650pzh.48.1692136716284;
        Tue, 15 Aug 2023 14:58:36 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z17-20020a637e11000000b0056129129ef8sm10583401pgc.18.2023.08.15.14.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 14:58:35 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	kasan-dev@googlegroups.com,
	linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v4 1/4] compiler_types: Introduce the Clang __preserve_most function attribute
Date: Tue, 15 Aug 2023 14:58:29 -0700
Message-Id: <169213670578.656151.9756083800563304743.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230811151847.1594958-1-elver@google.com>
References: <20230811151847.1594958-1-elver@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 11 Aug 2023 17:18:38 +0200, Marco Elver wrote:
> [1]: "On X86-64 and AArch64 targets, this attribute changes the calling
> convention of a function. The preserve_most calling convention attempts
> to make the code in the caller as unintrusive as possible. This
> convention behaves identically to the C calling convention on how
> arguments and return values are passed, but it uses a different set of
> caller/callee-saved registers. This alleviates the burden of saving and
> recovering a large register set before and after the call in the caller.
> If the arguments are passed in callee-saved registers, then they will be
> preserved by the callee across the call. This doesn't apply for values
> returned in callee-saved registers.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/4] compiler_types: Introduce the Clang __preserve_most function attribute
      https://git.kernel.org/kees/c/7a0fd5e16785
[2/4] list_debug: Introduce inline wrappers for debug checks
      https://git.kernel.org/kees/c/b16c42c8fde8
[3/4] list: Introduce CONFIG_LIST_HARDENED
      https://git.kernel.org/kees/c/aebc7b0d8d91
[4/4] hardening: Move BUG_ON_DATA_CORRUPTION to hardening options
      https://git.kernel.org/kees/c/aa9f10d57056

Take care,

-- 
Kees Cook

