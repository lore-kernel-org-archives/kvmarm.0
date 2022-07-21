Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2DCC43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 16:06:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79F4C4C334;
	Thu, 21 Jul 2022 12:06:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HABA+f-fCRQk; Thu, 21 Jul 2022 12:06:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F054C58F;
	Thu, 21 Jul 2022 12:06:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B15474C587
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 12:06:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KGpGIcfoDeWv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 12:06:15 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1B3414C334
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 12:06:15 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id u5so2947369wrm.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 09:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=pc0I4yw59jOOvGkA/C+nGbiscopqpoytUjjB6d/I+0w=;
 b=lZURPGzF14j9sNlRgK0JYE0xAdEjjrbkT5z7sM3Stia1hYZlKagfsnRTFUVTxU7HQK
 Z+4YbWji4hQ3wGRC0dQDKjY2DSPgY13RAS4KuzygvfnPpKt8GnkwcO7cdYG+dMzYaxWI
 s4Z7MnglCfrSD0JKJvOUxTuZr1PhjvVvvHSkPAlP0m6VDvfYjY7Iw56mpO/FUdIlEGJB
 Ge18N+XGIs7+bDWY0PrduAM9NtO5945vUVy28vQ5TkFdgekJS2LwUr5z2/lRXJFDg82R
 KI4aO1f400QidOMoqd7evfw+mkZiKW5o+U1oXEvx7gter8t09mHCHMZV1tH50jdGyj7e
 sWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=pc0I4yw59jOOvGkA/C+nGbiscopqpoytUjjB6d/I+0w=;
 b=L/LXojM0NlH/6kMN8YCvqSGMLlgR5pPLur5GKELRP/e77abN+Sq0z1fGMmmMZsPgOh
 GAfPbu58k+0DO1ZxwbRDrl1h1oT7yP1M7D1se2euuICpM79oBQVolMf1BwApuhsXXOLB
 NTqn65guzJKE4qGVJUSIyFfbe8qGMjv06TGq2wVdp9d1EtUZQjlqy5Wj8CjnwhNfc+qf
 49EYM35VzAqUO8+pqadL9hF6pvhgxmbyg5EW+U/eqK1gOpnUh6Qey3nPX32LuMpc2Abm
 wgCMkXXuARhMUwhNyIReYKBaUBhP1V2DqFgeGzD6FT3hdJfceEMI1a0SydEOEqMxDOwd
 NyOg==
X-Gm-Message-State: AJIora8nPtInSI3wDpTq/Cw14MfZCg9GnJiVC1R7FaW7cPjmtckfZXFS
 M2oD2w+Me8XoqIwTg8pHlpJMxv7sUdZ2XESYcVEP4g==
X-Google-Smtp-Source: AGRyM1tMKiMRtpHV9YSfuYiFk44eLQKIqdZQ/iYuycWrx2bklYrgWAmV9kHG5RR8KmbUFbcR6TgyoS1YaIwyjhpwAMk=
X-Received: by 2002:a05:6000:1e04:b0:21d:7ec3:fe5a with SMTP id
 bj4-20020a0560001e0400b0021d7ec3fe5amr35846940wrb.116.1658419573778; Thu, 21
 Jul 2022 09:06:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <CA+EHjTzGJknPWSdzU0-G35KgzRyGhQzb6+gkANOYcjZqLuzaJw@mail.gmail.com>
In-Reply-To: <CA+EHjTzGJknPWSdzU0-G35KgzRyGhQzb6+gkANOYcjZqLuzaJw@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 21 Jul 2022 09:06:02 -0700
Message-ID: <CAC_TJvej+DLYs1u8i4k143WAXdNHzmBQCZV-j-Yd00VMDz5o-g@mail.gmail.com>
Subject: Re: [PATCH v5 00/17] KVM nVHE Hypervisor stack unwinder
To: Fuad Tabba <tabba@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marco Elver <elver@google.com>,
 vincenzo.frascino@arm.com, Will Deacon <will@kernel.org>,
 android-mm@google.com, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 "Cc: Android Kernel" <kernel-team@android.com>,
 Andrew Jones <drjones@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
 Mark Brown <broonie@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, andreyknvl@gmail.com,
 LKML <linux-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jul 21, 2022 at 2:56 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Kalesh,
>
>
> On Thu, Jul 21, 2022 at 6:57 AM Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> > Hi all,
> >
> > This is v5 of nVHE hypervisor stacktraces support. The series is based on
> > arm64 for-next/stacktrace.
> >
> > The previous versions were posted at:
> > v4: https://lore.kernel.org/r/20220715061027.1612149-1-kaleshsingh@google.com/
> > v3: https://lore.kernel.org/r/20220607165105.639716-1-kaleshsingh@google.com/
> > v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
> > v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/
> >
> > The main updates in this version are some refactoring to move stuff out of
> > stacktrace/nvhe.h (leaving only the unwinder implementation in the header);
> > and fixing the symbolization of the hyp stacktrace when KASLR is enabled;
> > along with the addressing the other minor comments.
> >
> > Patch 18 (KVM: arm64: Dump nVHE hypervisor stack on panic) was also squashed
> > into earlier patches.
> >
> > The previous cover letter is copied below for convenience.
> >
> > Thanks all for your feedback.
>
> Thank you for this. This will be very helpful.
>
> For the whole series:
> Tested-by: Fuad Tabba <tabba@google.com>

Thanks for your reviews, Fuad.

--Kalesh

>
> Cheers,
> /fuad
>
>
> >
> > --Kalesh
> >
> > ============
> >
> > KVM nVHE Stack unwinding.
> > ===
> >
> > nVHE has two modes of operation: protected (pKVM) and unprotected
> > (conventional nVHE). Depending on the mode, a slightly different approach
> > is used to dump the hypervisor stacktrace but the core unwinding logic
> > remains the same.
> >
> > Protected nVHE (pKVM) stacktraces
> > ====
> >
> > In protected nVHE mode, the host cannot directly access hypervisor memory.
> >
> > The hypervisor stack unwinding happens in EL2 and is made accessible to
> > the host via a shared buffer. Symbolizing and printing the stacktrace
> > addresses is delegated to the host and happens in EL1.
> >
> > Non-protected (Conventional) nVHE stacktraces
> > ====
> >
> > In non-protected mode, the host is able to directly access the hypervisor
> > stack pages.
> >
> > The hypervisor stack unwinding and dumping of the stacktrace is performed
> > by the host in EL1, as this avoids the memory overhead of setting up
> > shared buffers between the host and hypervisor.
> >
> > Resuing the Core Unwinding Logic
> > ====
> >
> > Since the hypervisor cannot link against the kernel code in proteced mode.
> > The common stack unwinding code is moved to a shared header to allow reuse
> > in the nVHE hypervisor.
> >
> > Reducing the memory footprint
> > ====
> >
> > In this version the below steps were taken to reduce the memory usage of
> > nVHE stack unwinding:
> >
> >     1) The nVHE overflow stack is reduced from PAGE_SIZE to 4KB; benificial
> >        for configurations with non 4KB pages (16KB or 64KB pages).
> >     2) In protected nVHE mode (pKVM), the shared stacktrace buffers with the
> >        host are reduced from PAGE_SIZE to the minimum size required.
> >     3) In systems other than Android, conventional nVHE makes up the vast
> >        majority of use case. So the pKVM stack tracing is disabled by default
> >        (!CONFIG_PROTECTED_NVHE_STACKTRACE), which avoid the memory usage for
> >        setting up shared buffers.
> >     4) In non-protected nVHE mode (conventional nVHE), the stack unwinding
> >        is done directly in EL1 by the host and no shared buffers with the
> >        hypervisor are needed.
> >
> > Sample Output
> > ====
> >
> > The below shows an example output from a simple stack overflow test:
> >
> > [  126.862960] kvm [371]: nVHE hyp panic at: [<ffff8000090a51d0>] __kvm_nvhe_recursive_death+0x10/0x34!
> > [  126.869920] kvm [371]: Protected nVHE HYP call trace:
> > [  126.870528] kvm [371]:  [<ffff8000090a5570>] __kvm_nvhe_hyp_panic+0xac/0xf8
> > [  126.871342] kvm [371]:  [<ffff8000090a55cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
> > [  126.872174] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> > [  126.872971] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> >    . . .
> >
> > [  126.927314] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> > [  126.927727] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> > [  126.928137] kvm [371]:  [<ffff8000090a4de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
> > [  126.928561] kvm [371]:  [<ffff8000090a7b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
> > [  126.928984] kvm [371]:  [<ffff8000090a78b8>] __kvm_nvhe_handle_trap+0xc4/0x128
> > [  126.929385] kvm [371]:  [<ffff8000090a6864>] __kvm_nvhe___host_exit+0x64/0x64
> > [  126.929804] kvm [371]: ---- End of Protected nVHE HYP call trace ----
> >
> > ============
> >
> > Kalesh Singh (17):
> >   arm64: stacktrace: Add shared header for common stack unwinding code
> >   arm64: stacktrace: Factor out on_accessible_stack_common()
> >   arm64: stacktrace: Factor out unwind_next_common()
> >   arm64: stacktrace: Handle frame pointer from different address spaces
> >   arm64: stacktrace: Factor out common unwind()
> >   arm64: stacktrace: Add description of stacktrace/common.h
> >   KVM: arm64: On stack overflow switch to hyp overflow_stack
> >   KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
> >   KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
> >   KVM: arm64: Stub implementation of pKVM HYP stack unwinder
> >   KVM: arm64: Stub implementation of non-protected nVHE HYP stack
> >     unwinder
> >   KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
> >   KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
> >   KVM: arm64: Implement protected nVHE hyp stack unwinder
> >   KVM: arm64: Implement non-protected nVHE hyp stack unwinder
> >   KVM: arm64: Introduce pkvm_dump_backtrace()
> >   KVM: arm64: Introduce hyp_dump_backtrace()
> >
> >  arch/arm64/include/asm/kvm_asm.h           |  16 ++
> >  arch/arm64/include/asm/memory.h            |   8 +
> >  arch/arm64/include/asm/stacktrace.h        |  92 +++++----
> >  arch/arm64/include/asm/stacktrace/common.h | 230 +++++++++++++++++++++
> >  arch/arm64/include/asm/stacktrace/nvhe.h   | 199 ++++++++++++++++++
> >  arch/arm64/kernel/stacktrace.c             | 157 --------------
> >  arch/arm64/kvm/Kconfig                     |  15 ++
> >  arch/arm64/kvm/arm.c                       |   2 +-
> >  arch/arm64/kvm/handle_exit.c               | 101 +++++++++
> >  arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
> >  arch/arm64/kvm/hyp/nvhe/host.S             |   9 +-
> >  arch/arm64/kvm/hyp/nvhe/stacktrace.c       | 116 +++++++++++
> >  arch/arm64/kvm/hyp/nvhe/switch.c           |   6 +
> >  13 files changed, 749 insertions(+), 204 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/stacktrace/common.h
> >  create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
> >  create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c
> >
> >
> > base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
> > --
> > 2.37.0.170.g444d1eabd0-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
