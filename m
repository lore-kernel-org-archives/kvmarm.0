Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D903BC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 10:00:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CDA64D4AF;
	Mon, 18 Jul 2022 06:00:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bZELPUDFa9vF; Mon, 18 Jul 2022 06:00:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE1954D4B0;
	Mon, 18 Jul 2022 06:00:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D83A4D4AB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:00:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3DiOkNn3TfE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 06:00:40 -0400 (EDT)
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com
 [209.85.160.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1397D4D4A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 06:00:40 -0400 (EDT)
Received: by mail-oa1-f44.google.com with SMTP id
 586e51a60fabf-10c0052da61so22358604fac.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 03:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Fqf6wKKo3lC9G5+M1ef19eODt2HuCtIL9StjZNMcJ2Q=;
 b=l2x2fTnLy/zYWJ+f+TQToWt/IL54nbJ0yVIZ9VFyPm/pVUDcF82T2gOZ/jVCW6DElN
 UWgcPRHI6xX0lDyb1tWoCVBHVK79+HEYJE2Yu9AzmeEoewLpPbHtbmSqMFUQFNHxDciA
 x1xo5AEfYAFfCRj0dLCeogElogO8j5dxrRuumXHd8LA4EZVj8qwuldImWV/9F+fd1tjx
 D3fQqoXguwPvdqrETsRZea2X1C0oRjt8Kw/Z7lpbKw1nr5cVeXjzlGEtc3Mi6NIjCEIl
 386k6PrXZYRZ9hOHUZCYC5qHd/+UWUAYGG6Ak6mb4UCFAOOoPtsJPSpmYRDn+G9lLv8l
 y2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Fqf6wKKo3lC9G5+M1ef19eODt2HuCtIL9StjZNMcJ2Q=;
 b=dFDm1zdwpKfJxrY57tu/ZaFDm9ctbj1/LxL9cEnXKtOeZNvV8o7XcWc3Ktwg75CJxQ
 lehq+FqtRt1pzSEsPfAuyTqTuJr/jZ55Y0UE14bXraS12RmVfUiXAbiq8BFx84oLhkEj
 5glFms3EdQcdB5bess0e9l20Qlk0XoqX7/lPJGyYQdfdAJZydbEtyPipzLioSkAuoPFm
 8G54VXsSQaLRbtbs2DX16hzOvCFr5vqWnw+D4DrYA/jQpmoEwUk2H+Mm1tDu18duHhYo
 FsvMJVf2uYUIO/P7GAFQ98eed7Z2nx0TvDj+pMckmIiz8sgRd6TrkHkbB9a2hzBeTtWv
 r/jw==
X-Gm-Message-State: AJIora/sJpOgdh+aZFoulz6NXjmVhNg1Huw02pxoR8CjSueTKxAV0ef2
 wGT3Gg73KAf2qcyLLGF3MHFQuo5byN6nFxOHjykLig==
X-Google-Smtp-Source: AGRyM1uox4hxQ7LkNj0+VsFUqxedF8ftJbu1vwH/Lnq6o11cLxNrijgbGJXVHMZjzjG6ma999hSm5CQdlLp+a5Ur+6Q=
X-Received: by 2002:a05:6871:890:b0:10b:f3eb:b45d with SMTP id
 r16-20020a056871089000b0010bf3ebb45dmr14815410oaq.294.1658138439232; Mon, 18
 Jul 2022 03:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220715061027.1612149-1-kaleshsingh@google.com>
 <20220715061027.1612149-10-kaleshsingh@google.com>
In-Reply-To: <20220715061027.1612149-10-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 18 Jul 2022 11:00:03 +0100
Message-ID: <CA+EHjTyY5ieRROhC9S-WzUybcp3j8egJLGpCHV_2vSt8ieUjXg@mail.gmail.com>
Subject: Re: [PATCH v4 09/18] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
To: Kalesh Singh <kaleshsingh@google.com>
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, madvenka@linux.microsoft.com,
 andreyknvl@gmail.com, kernel-team@android.com, elver@google.com,
 broonie@kernel.org, linux-arm-kernel@lists.infradead.org,
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

On Fri, Jul 15, 2022 at 7:11 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> In protected nVHE mode the host cannot directly access
> hypervisor memory, so we will dump the hypervisor stacktrace
> to a shared buffer with the host.
>
> The minimum size do the buffer required, assuming the min frame
> size of [x29, x30] (2 * sizeof(long)), is half the combined size of
> the hypervisor and overflow stacks plus an additional entry to
> delimit the end of the stacktrace.
>
> The stacktrace buffers are used later in the seried to dump the
> nVHE hypervisor stacktrace when using protected-mode.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  arch/arm64/include/asm/memory.h      | 7 +++++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c | 4 ++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 0af70d9abede..28a4893d4b84 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -113,6 +113,13 @@
>
>  #define OVERFLOW_STACK_SIZE    SZ_4K
>
> +/*
> + * With the minimum frame size of [x29, x30], exactly half the combined
> + * sizes of the hyp and overflow stacks is needed to save the unwinded
> + * stacktrace; plus an additional entry to delimit the end.
> + */
> +#define NVHE_STACKTRACE_SIZE   ((OVERFLOW_STACK_SIZE + PAGE_SIZE) / 2 + sizeof(long))

I do find this computation to be a bit confusing, especially with the
addition of the entry to delimit the end. Especially when considering
that in patch 12, where you add pkvm_save_backtrace_entry(), you need
to compensate for it again.

Not sure what the best way is, having two definitions, or something
like that, with one for the size and one for the delimiter.

Thanks,
/fuad

> +
>  /*
>   * Alignment of kernel segments (e.g. .text, .data).
>   *
> diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> index a3d5b34e1249..69e65b457f1c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> +++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
> @@ -9,3 +9,7 @@
>
>  DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
>         __aligned(16);
> +
> +#ifdef CONFIG_PROTECTED_NVHE_STACKTRACE
> +DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
> +#endif /* CONFIG_PROTECTED_NVHE_STACKTRACE */
> --
> 2.37.0.170.g444d1eabd0-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
