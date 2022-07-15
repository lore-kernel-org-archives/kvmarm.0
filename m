Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98B2C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jul 2022 13:56:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 058BA4BF07;
	Fri, 15 Jul 2022 09:56:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RPKK1T+koLrL; Fri, 15 Jul 2022 09:56:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A87E94BE4F;
	Fri, 15 Jul 2022 09:56:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF164BE32
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:55:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UsmABxqGstNS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jul 2022 09:55:58 -0400 (EDT)
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com
 [209.85.167.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 354364BE25
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 09:55:58 -0400 (EDT)
Received: by mail-oi1-f169.google.com with SMTP id s204so6145252oif.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jul 2022 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=fmTpiXQsRGba6Ab2CmL1NtPiLfD0z73ZyAdaCn9pALw=;
 b=H7fWj0XkAq8MDBI1mBbQ1020de9SLOGyH72c6VSc+FqcYsBfX+OgMVfxFlb0q3RXLR
 quVkqfwqd0ImP99UyZyuBvTzG1tOgfTfD0gUaqKSWA2BgvaK9LI4BTNSyuCL6pU7gAPP
 q74pdZGJb2YIkvSSO8wqIkGuI5+sx4Xu+GXrZ06YbQo0yJDZjNKJlmINJfA/WGE99HCM
 Q4FlqllVKRBjMEvmlQhC08Qr5ze+Xd8nAsbwNVlj14N1IV7esFJ1eak1e7ei9hPhah5z
 w8mz8H9jy44cZ7w3gRMjNh8hlgmHFAfT0ULFxEGBjURn40N5PW5GZ9YS+qPK2VPAx2kt
 HaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=fmTpiXQsRGba6Ab2CmL1NtPiLfD0z73ZyAdaCn9pALw=;
 b=FxXpZvLs1ziUq5T2AXmRhOYHu102Ms7kjgzGUfs653K6aazr3bPl1FuCZWMlT8jqQD
 GwPFmq2jNNeXMYJJQNTXATg6bus7aMj4nynmi50OZOjNZbf+CxwWOuH2M/qYv6aG1NyA
 WYxrHCGJlKbC5a+kXYQgq0vJLdQbfXbo0yaVvoZbCwjDjS9pGgRfCW1kz45t2cErFf9B
 aVnAp5Xnwu07G3MhnT6yJxAHdTmt00bqJEorpGMzmc9PVrjp3pZb/o1pvYIOzpG+jc5V
 V+0MutHpHClIyHGPnxLcUwg8DS5ahG20TF25Lefqg+sw7tocgauj4dDg2hnu7Q1tUSsO
 T5AQ==
X-Gm-Message-State: AJIora8yABrj80fPQ+UNIzHgZskZVyCQvGSLH19cepnPFVgMT8pIQKdY
 E8tw/a0grVsY/P7epyEUnZBCZvTLtINuSHKXlZyW5g==
X-Google-Smtp-Source: AGRyM1te6pRsqRJI/o6//1EtStQg49wCaMpJRijOqffmG8CLlNXMADlHS0l7R6s1wXrzSW3eurlZBWpmbRR3FfXtC80=
X-Received: by 2002:a05:6808:1596:b0:337:8c17:b17f with SMTP id
 t22-20020a056808159600b003378c17b17fmr7427949oiw.294.1657893355814; Fri, 15
 Jul 2022 06:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-1-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 15 Jul 2022 14:55:19 +0100
Message-ID: <CA+EHjTzPu9hticW4sPbVsxp43swRGOv4ou843S=Q5q=oQ6ii=g@mail.gmail.com>
Subject: Re: [PATCH v4 00/18] KVM nVHE Hypervisor stack unwinder
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, elver@google.com, catalin.marinas@arm.com,
 ast@kernel.org, vincenzo.frascino@arm.com, will@kernel.org,
 android-mm@google.com, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
 madvenka@linux.microsoft.com, andreyknvl@gmail.com, kernel-team@android.com,
 drjones@redhat.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 russell.king@oracle.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

Hi Kalesh,

On Fri, Jul 15, 2022 at 7:10 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Hi all,
>
> This is v4 of the series adding support for nVHE hypervisor stacktraces;
> and is based on arm64 for-next/stacktrace.
>
> Thanks all for your feedback on previous revisions. Mark Brown, I
> appreciate your Reviewed-by on the v3, I have dropped the tags in this
> new verision since I think the series has changed quite a bit.
>
> The previous versions were posted at:
> v3: https://lore.kernel.org/r/20220607165105.639716-1-kaleshsingh@google.com/
> v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
> v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/
>
> The main updates in this version are to address concerens from Marc on the
> memory usage and reusing the common code by refactoring into a shared header.
>
> Thanks,
> Kalesh

I tested an earlier version of this patch series, and it worked fine,
with symbolization. However, testing it now, both with nvhe and with
pkvm the symbolization isn't working for me. e.g.

[   32.986706] kvm [251]: Protected nVHE HYP call trace:
[   32.986796] kvm [251]:  [<ffff800008f8b0e0>] 0xffff800008f8b0e0
[   32.987391] kvm [251]:  [<ffff800008f8b388>] 0xffff800008f8b388
[   32.987493] kvm [251]:  [<ffff800008f8d230>] 0xffff800008f8d230
[   32.987591] kvm [251]:  [<ffff800008f8d51c>] 0xffff800008f8d51c
[   32.987695] kvm [251]:  [<ffff800008f8c064>] 0xffff800008f8c064
[   32.987803] kvm [251]: ---- End of Protected nVHE HYP call trace ----

CONFIG_PROTECTED_NVHE_STACKTRACE CONFIG_NVHE_EL2_DEBUG and
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT are all enabled. Generating
a backtrace in the host I get proper symbolisation.

Is there anything else you'd like to know about my setup that would
help get to the bottom of this?

Thanks,
/fuad




>
> ============
>
> KVM nVHE Stack unwinding.
> ===
>
> nVHE has two modes of operation: protected (pKVM) and unprotected
> (conventional nVHE). Depending on the mode, a slightly different approach
> is used to dump the hyperviosr stacktrace but the core unwinding logic
> remains the same.
>
> Protected nVHE (pKVM) stacktraces
> ====
>
> In protected nVHE mode, the host cannot directly access hypervisor memory.
>
> The hypervisor stack unwinding happens in EL2 and is made accessible to
> the host via a shared buffer. Symbolizing and printing the stacktrace
> addresses is delegated to the host and happens in EL1.
>
> Non-protected (Conventional) nVHE stacktraces
> ====
>
> In non-protected mode, the host is able to directly access the hypervisor
> stack pages.
>
> The hypervisor stack unwinding and dumping of the stacktrace is performed
> by the host in EL1, as this avoids the memory overhead of setting up
> shared buffers between the host and hypervisor.
>
> Resuing the Core Unwinding Logic
> ====
>
> Since the hypervisor cannot link against the kernel code in proteced mode.
> The common stack unwinding code is moved to a shared header to allow reuse
> in the nVHE hypervisor.
>
> Reducing the memory footprint
> ====
>
> In this version the below steps were taken to reduce the memory usage of
> nVHE stack unwinding:
>
>     1) The nVHE overflow stack is reduced from PAGE_SIZE to 4KB; benificial
>        for configurations with non 4KB pages (16KB or 64KB pages).
>     2) In protected nVHE mode (pKVM), the shared stacktrace buffers with the
>        host are reduced from PAGE_SIZE to the minimum size required.
>     3) In systems other than Android, conventional nVHE makes up the vast
>        majority of use case. So the pKVM stack tracing is disabled by default
>        (!CONFIG_PROTECTED_NVHE_STACKTRACE), which avoid the memory usage for
>        setting up shared buffers.
>     4) In non-protected nVHE mode (conventional nVHE), the stack unwinding
>        is done directly in EL1 by the host and no shared buffers with the
>        hyperviosr are needed.
>
> Sample Output
> ====
>
> The below shows an example output from a simple stack overflow test:
>
> [  126.862960] kvm [371]: nVHE hyp panic at: [<ffff8000090a51d0>] __kvm_nvhe_recursive_death+0x10/0x34!
> [  126.869920] kvm [371]: Protected nVHE HYP call trace:
> [  126.870528] kvm [371]:  [<ffff8000090a5570>] __kvm_nvhe_hyp_panic+0xac/0xf8
> [  126.871342] kvm [371]:  [<ffff8000090a55cc>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
> [  126.872174] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> [  126.872971] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
>    . . .
>
> [  126.927314] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> [  126.927727] kvm [371]:  [<ffff8000090a51e4>] __kvm_nvhe_recursive_death+0x24/0x34
> [  126.928137] kvm [371]:  [<ffff8000090a4de4>] __kvm_nvhe___kvm_vcpu_run+0x30/0x40c
> [  126.928561] kvm [371]:  [<ffff8000090a7b64>] __kvm_nvhe_handle___kvm_vcpu_run+0x30/0x48
> [  126.928984] kvm [371]:  [<ffff8000090a78b8>] __kvm_nvhe_handle_trap+0xc4/0x128
> [  126.929385] kvm [371]:  [<ffff8000090a6864>] __kvm_nvhe___host_exit+0x64/0x64
> [  126.929804] kvm [371]: ---- End of Protected nVHE HYP call trace ----
>
> ============
>
>
> Kalesh Singh (18):
>   arm64: stacktrace: Add shared header for common stack unwinding code
>   arm64: stacktrace: Factor out on_accessible_stack_common()
>   arm64: stacktrace: Factor out unwind_next_common()
>   arm64: stacktrace: Handle frame pointer from different address spaces
>   arm64: stacktrace: Factor out common unwind()
>   arm64: stacktrace: Add description of stacktrace/common.h
>   KVM: arm64: On stack overflow switch to hyp overflow_stack
>   KVM: arm64: Add PROTECTED_NVHE_STACKTRACE Kconfig
>   KVM: arm64: Allocate shared pKVM hyp stacktrace buffers
>   KVM: arm64: Stub implementation of pKVM HYP stack unwinder
>   KVM: arm64: Stub implementation of non-protected nVHE HYP stack
>     unwinder
>   KVM: arm64: Save protected-nVHE (pKVM) hyp stacktrace
>   KVM: arm64: Prepare non-protected nVHE hypervisor stacktrace
>   KVM: arm64: Implement protected nVHE hyp stack unwinder
>   KVM: arm64: Implement non-protected nVHE hyp stack unwinder
>   KVM: arm64: Introduce pkvm_dump_backtrace()
>   KVM: arm64: Introduce hyp_dump_backtrace()
>   KVM: arm64: Dump nVHE hypervisor stack on panic
>
>  arch/arm64/include/asm/kvm_asm.h           |  16 ++
>  arch/arm64/include/asm/memory.h            |   7 +
>  arch/arm64/include/asm/stacktrace.h        |  92 ++++---
>  arch/arm64/include/asm/stacktrace/common.h | 224 ++++++++++++++++
>  arch/arm64/include/asm/stacktrace/nvhe.h   | 291 +++++++++++++++++++++
>  arch/arm64/kernel/stacktrace.c             | 157 -----------
>  arch/arm64/kvm/Kconfig                     |  15 ++
>  arch/arm64/kvm/arm.c                       |   2 +-
>  arch/arm64/kvm/handle_exit.c               |   4 +
>  arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
>  arch/arm64/kvm/hyp/nvhe/host.S             |   9 +-
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c       | 108 ++++++++
>  arch/arm64/kvm/hyp/nvhe/switch.c           |   5 +
>  13 files changed, 727 insertions(+), 205 deletions(-)
>  create mode 100644 arch/arm64/include/asm/stacktrace/common.h
>  create mode 100644 arch/arm64/include/asm/stacktrace/nvhe.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/stacktrace.c
>
>
> base-commit: 82a592c13b0aeff94d84d54183dae0b26384c95f
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
