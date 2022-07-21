Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44873C43334
	for <kvmarm@archiver.kernel.org>; Thu, 21 Jul 2022 09:58:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E93D84C8FF;
	Thu, 21 Jul 2022 05:58:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JTjWxJVegfLJ; Thu, 21 Jul 2022 05:58:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56644C8C2;
	Thu, 21 Jul 2022 05:58:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 122404C641
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yjvgU8RhTcVD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 05:58:33 -0400 (EDT)
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com
 [209.85.160.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E7A6C4C0DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 05:58:32 -0400 (EDT)
Received: by mail-oa1-f42.google.com with SMTP id
 586e51a60fabf-10d867a8358so1669958fac.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 02:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=cke61x1VyLaOYMRXa+KSlFmuqpeiXyYoEp5L0oHK1QY=;
 b=Tv95sC0RqA3YKlr8Mh8ehqDQQXV9jQB2dagD6vtqdXmVNw98AKjRH+UwEbuwL2OHbz
 KAAkhFIW3FZwlIYmgkwTCOJgSBItuMIrzMHPGXkY7LvyHwdFnRrGX0LevGgQFkGpNRpE
 J9wqLlYi4/pflPV5HBV4XXjyVO6b+I8QstZAqTw65q71c3h/PMs622hA5yg4rCgfSeJ5
 2g5Di77DrhkMVDgr+gOZbpQD3/hK1YSEfxYJGaey4k6XC/JL0gnm47mrlpXpzdxznlaL
 oGUh9EqkT5n2W2VMQjS6SQd/55HLeg9DGahze8oyN1mdYMq19MZHbB0woZe+TGiOkWwU
 JilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=cke61x1VyLaOYMRXa+KSlFmuqpeiXyYoEp5L0oHK1QY=;
 b=rAUxBndNDeA2QgDMtyoaNdlA1SQ0DQ3v8xttkSSeof3Z4aM0mwwd/8dybybCPCopTB
 daklmExEXZuYAfY1fobcFB1t/O3HVWQkQVzM5rOAR4/+MeIMXQVdRdNjVKYk1PGHbZ6a
 trcpePZZGEQxVnD42qlslgmSriywIj8EGJveg2L6Q07xrJOAL3nxp4Cvop1aZddh+loO
 ftL22eqTXpAjSr+OaiujW313pdY3Q/arHOfU6xGMAGtlD3O5DJa0ZkURjRk74GJuqFOW
 hBHs1vMwmHa9AtHcGMTSXwhOM7bQ7dSojYXMay4SReCrYu/skmeLrY/NLdgZh9VCw8tv
 FcnQ==
X-Gm-Message-State: AJIora+soyubtHyBp2L5YdPMH7GFpGPbqsp9YNPypdA5JZqir1Pjr5uB
 RTdmTZOL49SAiamPZAfQjQyR8g8pngEvdHmDmGqtvw==
X-Google-Smtp-Source: AGRyM1s1/WqNg+sC8uUwNPbq5XStZk8otBFSfStT4w/YkwUXcQ6JM+u9wee9XyLVbencTF50D7kTRxumET8UpAglsaI=
X-Received: by 2002:a05:6871:890:b0:10b:f3eb:b45d with SMTP id
 r16-20020a056871089000b0010bf3ebb45dmr4955346oaq.294.1658397512248; Thu, 21
 Jul 2022 02:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220721055728.718573-1-kaleshsingh@google.com>
 <20220721055728.718573-10-kaleshsingh@google.com>
In-Reply-To: <20220721055728.718573-10-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 Jul 2022 10:57:56 +0100
Message-ID: <CA+EHjTwvGj+1TQ1OKDNhJsFd=TjwuPr=mjGxvZDqTKWYMcbN+Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/17] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
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

On Thu, Jul 21, 2022 at 6:57 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> In protected nVHE mode the host cannot directly access
> hypervisor memory, so we will dump the hypervisor stacktrace
> to a shared buffer with the host.
>
> The minimum size for the buffer required, assuming the min frame
> size of [x29, x30] (2 * sizeof(long)), is half the combined size of
> the hypervisor and overflow stacks plus an additional entry to
> delimit the end of the stacktrace.
>
> The stacktrace buffers are used later in the seried to dump the

nit: seried/series

> nVHE hypervisor stacktrace when using protected-mode.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> Changes in v5:
>   - Fix typo in commit text, per Marc
>
>  arch/arm64/include/asm/memory.h      | 8 ++++++++
>  arch/arm64/kvm/hyp/nvhe/stacktrace.c | 4 ++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 0af70d9abede..cab80a9a4086 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -113,6 +113,14 @@
>
>  #define OVERFLOW_STACK_SIZE    SZ_4K
>
> +/*
> + * With the minimum frame size of [x29, x30], exactly half the combined
> + * sizes of the hyp and overflow stacks is the maximum size needed to
> + * save the unwinded stacktrace; plus an additional entry to delimit the
> + * end.
> + */
> +#define NVHE_STACKTRACE_SIZE   ((OVERFLOW_STACK_SIZE + PAGE_SIZE) / 2 + sizeof(long))
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
