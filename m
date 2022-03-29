Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A105C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 08:51:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF93D49ED6;
	Tue, 29 Mar 2022 04:51:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OdQc0MdkO2MS; Tue, 29 Mar 2022 04:51:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C7549F13;
	Tue, 29 Mar 2022 04:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5413949ED6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bqbGUu2s2xN1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 04:51:52 -0400 (EDT)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com
 [209.85.167.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2043649DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:52 -0400 (EDT)
Received: by mail-oi1-f182.google.com with SMTP id q189so18335845oia.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 01:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=R1lsy9bMwR3ErUveqedAk8smNA0HigoGBjxLcyNF7Hk=;
 b=rbrvbYiedyRBSdRYe6ZGpIj7XvntHQia/rB4xtJJLFMus5eHqW8Pemvzxfr7NXac3+
 JMagcc+W0AMpYApVy0+MqLkvwibf2VVZpVXknche0g03NNv8sC8YGGdNshJ1aeGD77Vq
 +NUWztvMoJTf0Essh7f73pRj5H7P9WnWHuDIvQsYVAGDITzwiCixYW/cSEru53TjZ0uy
 9LwegnaV7o/2eVro98LRwh5SbzGJfPzrHl/3oY0n4GZr/fNy/fW3o39UrP7PGtNZ8+Po
 Y11i0R1NhlQOcMom/HNueNTgjCC0DqT2Wm5JQAvSRD1NFwVqYJD/GePT68iWk1buWSjB
 qByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=R1lsy9bMwR3ErUveqedAk8smNA0HigoGBjxLcyNF7Hk=;
 b=MWlzfMZW1g99cuCpfOXNk6cCpnZPiv2Wlf5suRDSLU8K8mBw3Z2MZKu7W3pyzAwpav
 dCTQEOuxabAlMWNeBcFtbpYGmA0r7ng8o1yMvvaOAYQacznzw+YDOqwEkQhAcRa1639V
 PnxO4xhqD264uDb8Mndke/wG9v9Ol6w8S+hoDak/n7uBjqP884Yb/wtnHZIBA+3ramIg
 70OhJM6NaqUi9Py1FfOwafs3/cHZyAsfuWmUgY2vXz6MVKoHI7SXlw7rZDI8dmWlgtc1
 51w9S4P3bspUojvXBFpQZQbId/oWOVLfylOGPtAnNzpJZMzbm4AU5khkCFPVlL3iL8Ib
 d04Q==
X-Gm-Message-State: AOAM533DdpT82thr10SB1AW+dfOavcm/f2A6pOi2Djn6dmeIY7JFNpOj
 4d+GNvX44nAdhaEZ6j1WnFZo4OXNyT5hHmc55Jj08g==
X-Google-Smtp-Source: ABdhPJy/th1u/rMCaWZtzYowW7LJ1M2NUGV8icqQ2gVGgJiqN6PQR2SlsJkh6eQ+HBd+YiFyvJrCKH5iVJxXzxXwfpc=
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id
 h11-20020aca180b000000b002f723ae8cd1mr1592160oih.146.1648543911401; Tue, 29
 Mar 2022 01:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-9-kaleshsingh@google.com>
In-Reply-To: <20220314200148.2695206-9-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 29 Mar 2022 09:51:15 +0100
Message-ID: <CA+EHjTx-c8e1oHh-A=6aaSxHxdrsuhtsjrwosjFLsWP9Zizmhw@mail.gmail.com>
Subject: Re: [PATCH v6 8/8] KVM: arm64: Symbolize the nVHE HYP backtrace
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Peter Zijlstra <peterz@infradead.org>, Mark Brown <broonie@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
 linux-arm-kernel@lists.infradead.org
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

On Mon, Mar 14, 2022 at 8:07 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Reintroduce the __kvm_nvhe_ symbols in kallsyms, ignoring the local
> symbols in this namespace. The local symbols are not informative and
> can cause aliasing issues when symbolizing the addresses.
>
> With the necessary symbols now in kallsyms we can symbolize nVHE
> stacktrace addresses using the %pB print format specifier.
>
> Example call trace:
>
> [   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!
> [   98.918360][  T426] nVHE HYP call trace:
> [   98.918692][  T426] kvm [426]: [<ffffffc009615aac>] __kvm_nvhe_cpu_prepare_nvhe_panic_info+0x4c/0x68
> [   98.919545][  T426] kvm [426]: [<ffffffc0096159a4>] __kvm_nvhe_hyp_panic+0x2c/0xe8
> [   98.920107][  T426] kvm [426]: [<ffffffc009615ad8>] __kvm_nvhe_hyp_panic_bad_stack+0x10/0x10
> [   98.920665][  T426] kvm [426]: [<ffffffc009610a4c>] __kvm_nvhe___kvm_hyp_host_vector+0x24c/0x794
> [   98.921292][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
> . . .
>
> [   98.973382][  T426] kvm [426]: [<ffffffc009615718>] __kvm_nvhe_overflow_stack+0x24/0x34
> [   98.973816][  T426] kvm [426]: [<ffffffc0096152f4>] __kvm_nvhe___kvm_vcpu_run+0x38/0x438
> [   98.974255][  T426] kvm [426]: [<ffffffc009616f80>] __kvm_nvhe_handle___kvm_vcpu_run+0x1c4/0x364
> [   98.974719][  T426] kvm [426]: [<ffffffc009616928>] __kvm_nvhe_handle_trap+0xa8/0x130
> [   98.975152][  T426] kvm [426]: [<ffffffc009610064>] __kvm_nvhe___host_exit+0x64/0x64
> [   98.975588][  T426] ---- end of nVHE HYP call trace ----
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad



> ---
>
> Changes in v2:
>   - Fix printk warnings - %p expects (void *)
>
>
>  arch/arm64/kvm/handle_exit.c | 13 +++++--------
>  scripts/kallsyms.c           |  2 +-
>  2 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index ff69dff33700..3a5c32017c6b 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -296,13 +296,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>         u64 elr_in_kimg = __phys_to_kimg(elr_phys);
>         u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr_virt;
>         u64 mode = spsr & PSR_MODE_MASK;
> +       u64 panic_addr = elr_virt + hyp_offset;
>
> -       /*
> -        * The nVHE hyp symbols are not included by kallsyms to avoid issues
> -        * with aliasing. That means that the symbols cannot be printed with the
> -        * "%pS" format specifier, so fall back to the vmlinux address if
> -        * there's no better option.
> -        */
>         if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
>                 kvm_err("Invalid host exception to nVHE hyp!\n");
>         } else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> @@ -322,9 +317,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>                 if (file)
>                         kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
>                 else
> -                       kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
> +                       kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
> +                                       (void *)panic_addr);
>         } else {
> -               kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
> +               kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
> +                               (void *)panic_addr);
>         }
>
>         kvm_nvhe_dump_backtrace(hyp_offset);
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index 54ad86d13784..19aba43d9da4 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -111,7 +111,7 @@ static bool is_ignored_symbol(const char *name, char type)
>                 ".LASANPC",             /* s390 kasan local symbols */
>                 "__crc_",               /* modversions */
>                 "__efistub_",           /* arm64 EFI stub namespace */
> -               "__kvm_nvhe_",          /* arm64 non-VHE KVM namespace */
> +               "__kvm_nvhe_$",         /* arm64 local symbols in non-VHE KVM namespace */
>                 "__AArch64ADRPThunk_",  /* arm64 lld */
>                 "__ARMV5PILongThunk_",  /* arm lld */
>                 "__ARMV7PILongThunk_",
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
