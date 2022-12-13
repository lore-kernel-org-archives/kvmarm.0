Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DB79C9
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 20:03:09 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so4781368pjd.0
        for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 12:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SlLKeNs0EWVsu+ptfdWBNmvU18ZVhMR61XWdAxFV9XQ=;
        b=Jgh2h70gyFoI+vZEt+HRyYhvy8YXmJruypdwVRYeOAtwakBPLsrcx6y+QvB3hUhUNm
         v/DiIWAZ3oh+MtBheCrEL++Gyb7HLAT1gDnpqMiVuiB04sbr6RL+4HisIMlXsah7jJHs
         BQh9UrAAjRfz+6OEQK8DW+ZocCeLgGW7E9/YuE4vDZ2U7pCZP9xxdvcW7BRNNE9/dvXk
         UHFZHnLNmVVz3QPKDVMD9nL2tc1Un2n3p3lY72Vrrn4IEro5ne4Mp2Xd+uRIFimABqMP
         9hVMz9Et/jMsgOYssc4gfckHfVOAIkEUwXeMIcmjytkpiwFO3ZODSvpun/Uk3hH9yVpu
         tYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlLKeNs0EWVsu+ptfdWBNmvU18ZVhMR61XWdAxFV9XQ=;
        b=jU+Ay74Oj08LwzP5ngfprmXSNMcWsoUPFWM/sffnWvWwvmdgZkLJh3XLepJMRl/Spm
         wJgtMHqo5Wz7LT6PtsxHwH8EXz/Jo7wEQ9tWnBC03LFW6/vpp4pQGoGJBdI1Z4c2nuhO
         bCDaduZNZFDA1qPifJ6AeqrS7gZfTdEixrj3bMyBdaOHEqxKt+/Lk8KMImWp4tJpNHSY
         mFeBqwqowpR5JcgtQGTC7LAvKG+7spChFLmH/Pb3O3pt1k7vrvmLkYKGtWrt7UJp3CBc
         4eHvQNyPUu7aic3LuA6fhhkN+MriyDWm7Fpa/4TtEDEXzalSP9kd/S5fAQCrQQTWcRk6
         KV5A==
X-Gm-Message-State: ANoB5pmLxIZercUJ9ZuKxCEuM4FWFEoWOcHDCfmnj1iNWgVWjUiu17uW
	d4KezsFIvKf6anL4WbnBoiCUbg==
X-Google-Smtp-Source: AA0mqf43rfeTLye05owqv8MbDwr9r9xovoe2k6ziCGD54isSIqaMDQrLxrh/vw468kpaItrUN7BQ5g==
X-Received: by 2002:a17:902:7b96:b0:189:858f:b5c0 with SMTP id w22-20020a1709027b9600b00189858fb5c0mr428994pll.0.1670961788301;
        Tue, 13 Dec 2022 12:03:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903124500b00189667acf19sm289595plh.95.2022.12.13.12.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 12:03:07 -0800 (PST)
Date: Tue, 13 Dec 2022 20:03:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>, Tom Rix <trix@redhat.com>,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
Message-ID: <Y5jadzKz6Qi9MiI9@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213001653.3852042-7-seanjc@google.com>
Message-ID: <20221213200303.j3P9vP8MJdRZArSi3iF68yz-A8-F2QSrTTf_mSqIaGY@z>

+David

On Tue, Dec 13, 2022, Sean Christopherson wrote:
> Rename UNAME_M to ARCH_DIR and explicitly set it directly for x86.  At
> this point, the name of the arch directory really doesn't have anything
> to do with `uname -m`, and UNAME_M is unnecessarily confusing given that
> its purpose is purely to identify the arch specific directory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> -# No change necessary for x86_64
> -UNAME_M := $(shell uname -m)
> -
> -# Set UNAME_M for arm64 compile/install to work
> -ifeq ($(ARCH),arm64)
> -	UNAME_M := aarch64
> -endif
> -# Set UNAME_M s390x compile/install to work
> -ifeq ($(ARCH),s390)
> -	UNAME_M := s390x
> -endif
> -# Set UNAME_M riscv compile/install to work
> -ifeq ($(ARCH),riscv)
> -	UNAME_M := riscv
> +ifeq ($(ARCH),x86)

As discovered by by David, this breaks doing "ARCH=x86_64 make", which is an
allowed/supported variant in the kernel proper, so this needs to be:

  ifneq (,$(filter $(ARCH),x86 x86_64))

or alternatively

  ifeq ($(ARCH),x86_64)
  ARCH := x86
  endif

Hmm, unless there's a reason to keep ARCH=x86_64, the latter appears to be the
better option as lib.mak doesn't play nice with x86_64 either, e.g. `ARCH=x86_64
LLVM=1 make` fails.  That's arguably a lib.mak bug, but it's trivial to handle
in KVM's makefile so forcing lib.mak to handle both seems unnecessary.

I'll also add a comment to call out that $(ARCH) follows the kernel's terminology
for arch/*, whereas for whatever reason KVM selftests effectively uses `uname -m`
terminology.

One last thought/question, what do y'all think about renaming directories to
follow the kernel proper?  I.e. aarch64=>arm64, s390x=>s390, and x86_64=>x86.
Then $(ARCH_DIR) would go away.  The churn would be unfortunate, but it would be
nice to align with arch/ and tools/arch/.

> +	ARCH_DIR := x86_64
> +else ifeq ($(ARCH),arm64)
> +	ARCH_DIR := aarch64
> +else ifeq ($(ARCH),s390)
> +	ARCH_DIR := s390x
> +else ifeq ($(ARCH),riscv)
> +	ARCH_DIR := riscv
> +else
> +$(error Unknown architecture '$(ARCH)')
>  endif
