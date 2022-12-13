Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB69D15B0
	for <kvmarm@lists.linux.dev>; Tue, 13 Dec 2022 01:37:09 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id gt4so1782187pjb.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Dec 2022 17:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
        b=UOLR4/D4l8GUzElS0sejD2JapJwiXXo2meP6+lJ4UUi6Oj9CCz+E9FE2qBHGrI7Utw
         7OokGhkdZbKxc3Ctt6ZZXN0i35uOg0peSR+0R+WVwqWr9OVFPJSib+WjKq5pQzui/58i
         Y8s1Y27VjQTtgwC7o5gYdWnjHddNTpRNWzMaZm5tNwUVmLRfMdVKxsEBBWh6ITeGtOW7
         gXOTqvopxiSjsYbG5ApbWUNiAL3dozmKHp10byFJU92ZP4hQWonUzETTShKtTRFN2+Hf
         tAOTXVSSNORLHBQ3eDPsuPXE6+G5eltxPXeLQCSKhU6J5/WfdMsaHX1ArV2nqpfebXr2
         dRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJwqdDN1RvNeTFiZyaSzmASJkDq0+IG5uFFQ0Vq+pIE=;
        b=228Iklsw8XJETi+s16pgG3jlboT1lXRfNPnjKFXcF3HBZIDMe4dT4OSl3LyIMUobis
         MAe8C8EJ6rQ1HQtV/VNJ50XUkr6BMnHEP3jdM2Ye6hDy8PjI3isFKH9paJmTKwHhqYez
         tRiGbaYy5LqPZei5efxbaKQWDi6MgPNitXdurvEhiBsyQEXcOTK7RbNAiMDLKvDFOVmN
         w3ZSfKTY4NS59/2Mop2zMulBzFFurTWGHDwbrS6YW4/2r6Tw5GaTTu8o7O/v2DYviYBj
         f1y9PZomPLXYNgHosp+rq3k5gxeqBWNBXVD8+rLudkuWo4fFPvD7I384iaYidx/luAZ+
         3aRQ==
X-Gm-Message-State: ANoB5pktMQKoGAJXaUwVXD1PrgT4fATGkKhDoSG8JjrYjWhemH3CbPqo
	R0GkSO+FxtnOF4y5R/GD/PQ2PDnin3DpvRIxFnQPPQ==
X-Google-Smtp-Source: AA0mqf59hLKHWHycEAofu9/939ZBb87HK2lBuOCJYN0Zs3K9cbu8MbXmw0OtELFZfn97VUt5D/c7xWXV2p8gd3eTyxg=
X-Received: by 2002:a17:902:f092:b0:189:9b43:a082 with SMTP id
 p18-20020a170902f09200b001899b43a082mr45842703pla.95.1670895428992; Mon, 12
 Dec 2022 17:37:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221213001653.3852042-1-seanjc@google.com> <20221213001653.3852042-12-seanjc@google.com>
In-Reply-To: <20221213001653.3852042-12-seanjc@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 12 Dec 2022 17:36:58 -0800
Message-ID: <CAKwvOdnRQQb9YbH=MgDymBmmjYgajc8tkyjbJVxjpA5zDZpNTQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] KVM: selftests: Disable "gnu-variable-sized-type-not-at-end"
 warning
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Tom Rix <trix@redhat.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ricardo Koller <ricarkol@google.com>, 
	Aaron Lewis <aaronlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221213013658.vye6DGdf0F8IdvwWczmRhavQF-1-Vrg4qPo7WNR04Yc@z>

On Mon, Dec 12, 2022 at 4:17 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Disable gnu-variable-sized-type-not-at-end so that tests and libraries
> can create overlays of variable sized arrays at the end of structs when
> using a fixed number of entries, e.g. to get/set a single MSR.
>
> It's possible to fudge around the warning, e.g. by defining a custom
> struct that hardcodes the number of entries, but that is a burden for
> both developers and readers of the code.
>
> lib/x86_64/processor.c:664:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:772:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> lib/x86_64/processor.c:787:19: warning: field 'header' with variable sized type 'struct kvm_msrs'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>                 struct kvm_msrs header;
>                                 ^
> 3 warnings generated.
>
> x86_64/hyperv_tlb_flush.c:54:18: warning: field 'hv_vp_set' with variable sized type 'struct hv_vpset'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct hv_vpset hv_vp_set;
>                         ^
> 1 warning generated.
>
> x86_64/xen_shinfo_test.c:137:25: warning: field 'info' with variable sized type 'struct kvm_irq_routing'
> not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
>         struct kvm_irq_routing info;
>                                ^
> 1 warning generated.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 2487db21b177..9cff99a1cb2e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -196,6 +196,7 @@ else
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  endif
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
> +       -Wno-gnu-variable-sized-type-not-at-end \

This is a clang-specific warning. This will need to be wrapped in a
cc-option check.

tools/build/Build.include seems to redefine that make macro, so be
sure to test it first.

>         -fno-builtin-memcmp -fno-builtin-memcpy -fno-builtin-memset \
>         -fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>         -I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
>


-- 
Thanks,
~Nick Desaulniers
