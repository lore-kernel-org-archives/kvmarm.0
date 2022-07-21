Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913DCC43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:59:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 375E64C960;
	Thu, 21 Jul 2022 05:59:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jcZsm2OSbC87; Thu, 21 Jul 2022 05:59:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAB0D4C94C;
	Thu, 21 Jul 2022 05:59:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B31B4C94C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QLiqC8w1SCRA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:59:42 -0400 (EDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com
 [209.85.208.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2CC794C942
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:59:42 -0400 (EDT)
Received: by mail-ed1-f43.google.com with SMTP id m8so1478072edd.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=x8zWIB1Jk2zC+zVLL1a5oZ4AS/1//k+cudXHvaMTMBs=;
 b=edW3k4aa7VTAEr7wdc8jVCjhirK5Irfk8qBCUEZYzkV3OrB9Eh5klc2iIHR3uoWZnP
 oIdozVUd8gHdA+uKkJkcXPSjwyC6t3R+pGAr86haOciELQsjQ+wFI/JARYogzWodUh5N
 ysZNIaIz+gVAWzwvDqaNl+//D5dwZ2JjMpBW3ncAD43CDUJSaIGNOmhioKAlDKjazGJy
 W0W3encQyf4Dk3Sx4gWlYpVtl8xxXDNaF36/jz3+VPVS2Ci1DcQ5GifTFYY4rPt1iL2G
 1VzCqDD2cE5RZWo90gjRANWeQABVDxX4vJLgkbtZ6Yp4F+vu9pN9syrHkrFqsKiazHvr
 pTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=x8zWIB1Jk2zC+zVLL1a5oZ4AS/1//k+cudXHvaMTMBs=;
 b=pRdy1YImIJKmFjqYh9M5Rj59Dh5181nhJRF1rRzz4VuCrKUp2h+ltzSRK1hqosgmP6
 Q5J4J/IRNmb2uQUr/7AdV+BKr7gRXrQ4tW3ZMF+ZirdvFaGqEXZqItPX8hNaVLixUDo/
 dRsDRkvHGjtsbgiJ/xbbePdzaP1iGa3IzPLC42WSaMQM378f1HytlU+kl1XTTqZWJoOo
 Rz/DOQfU2nRUHYWyEr1pd3n5ZtcmDoHrvc4qbyq9cgT1Gq+aST7QJsZ9n6CqENsiyyih
 e4xOxxzDkm3wlmZhBmqvO0DFC9Xk5Cn5d+CuSQI3WK7OyjVZci4sIEL5idpDQ29qtw3o
 3cWw==
X-Gm-Message-State: AJIora8CwIRy4CGyNBaOgltQQWOYyG8RTYmbn6m6280ziVxvnT30COeW
 jP0bkVXy8crbv0k6FBRoDqUt6C9+592FYhxOgp16Ow==
X-Google-Smtp-Source: AGRyM1vcbTyNNjymvJFxOWfYP/8b5Bg4F5Cy83gLQY0P3cKR7FwP9f4aHqEOZXNwA07/ltOSFkCxdCCmfELPDgaY4MY=
X-Received: by 2002:a05:6402:753:b0:43b:a416:3963 with SMTP id
 p19-20020a056402075300b0043ba4163963mr13574229edy.267.1658397581111; Thu, 21
 Jul 2022 02:59:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-17-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-17-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:59:04 +0100
Message-ID: <CA+EHjTzc8Rxe-n3uy0TQDFTVMw0hN_GwzAZunqpOE3HGXrq2CQ@mail.gmail.com>
Subject: Re: [PATCH v5 16/17] KVM: arm64: Introduce pkvm_dump_backtrace()
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, madvenka@linux.microsoft.com, kernel-team@android.com,
 elver@google.com, broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
 andreyknvl@gmail.com, linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

On Thu, Jul 21, 2022 at 6:58 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Dumps the pKVM hypervisor backtrace from EL1 by reading the unwinded
> addresses from the shared stacktrace buffer.
>
> The nVHE hyp backtrace is dumped on hyp_panic(), before panicking the
> host.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>
> Changes in v5:
>   - Move code out from nvhe.h header to handle_exit.c, per Marc
>   - Fix stacktrace symoblization when CONFIG_RAMDOMIZE_BASE is enabled,
>     per Fuad
>   - Use regular comments instead of doc comments, per Fuad
>
>  arch/arm64/kvm/handle_exit.c | 54 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index f66c0142b335..ad568da5c7d7 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -318,6 +318,57 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>                 kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
>  }
>
> +#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> +DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
> +                        pkvm_stacktrace);
> +
> +/*
> + * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
> + *
> + * @hyp_offset: hypervisor offset, used for address translation.
> + *
> + * Dumping of the pKVM HYP backtrace is done by reading the
> + * stack addresses from the shared stacktrace buffer, since the
> + * host cannot direclty access hyperviosr memory in protected

directly and hypervisor

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> + * mode.
> + */
> +static void pkvm_dump_backtrace(unsigned long hyp_offset)
> +{
> +       unsigned long *stacktrace_entry
> +               = (unsigned long *)this_cpu_ptr_nvhe_sym(pkvm_stacktrace);
> +       unsigned long va_mask, pc;
> +
> +       va_mask = GENMASK_ULL(vabits_actual - 1, 0);
> +
> +       kvm_err("Protected nVHE HYP call trace:\n");
> +
> +       /* The stack trace is terminated by a null entry */
> +       for (; *stacktrace_entry; stacktrace_entry++) {
> +               /* Mask tags and convert to kern addr */
> +               pc = (*stacktrace_entry & va_mask) + hyp_offset;
> +               kvm_err(" [<%016lx>] %pB\n", pc, (void *)(pc + kaslr_offset()));
> +       }
> +
> +       kvm_err("---- End of Protected nVHE HYP call trace ----\n");
> +}
> +#else  /* !CONFIG_PROTECTED_NVHE_STACKTRACE */
> +static void pkvm_dump_backtrace(unsigned long hyp_offset)
> +{
> +       kvm_err("Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE\n");
> +}
> +#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> +
> +/*
> + * kvm_nvhe_dump_backtrace - Dump KVM nVHE hypervisor backtrace.
> + *
> + * @hyp_offset: hypervisor offset, used for address translation.
> + */
> +static void kvm_nvhe_dump_backtrace(unsigned long hyp_offset)
> +{
> +       if (is_protected_kvm_enabled())
> +               pkvm_dump_backtrace(hyp_offset);
> +}
> +
>  void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>                                               u64 elr_virt, u64 elr_phys,
>                                               u64 par, uintptr_t vcpu,
> @@ -353,6 +404,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>                                 (void *)panic_addr);
>         }
>
> +       /* Dump the nVHE hypervisor backtrace */
> +       kvm_nvhe_dump_backtrace(hyp_offset);
> +
>         /*
>          * Hyp has panicked and we're going to handle that by panicking the
>          * kernel. The kernel offset will be revealed in the panic so we're
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
