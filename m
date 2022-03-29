Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368C0C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 08:52:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE16149F31;
	Tue, 29 Mar 2022 04:52:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id olUY9Vd83xXz; Tue, 29 Mar 2022 04:52:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEC0D49EC3;
	Tue, 29 Mar 2022 04:52:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60B3549E37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ofpmeO4Wrl-H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 04:52:04 -0400 (EDT)
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com
 [209.85.160.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DC2A49DED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:52:04 -0400 (EDT)
Received: by mail-oa1-f44.google.com with SMTP id
 586e51a60fabf-df26ea5bfbso403042fac.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1kH8pAcoNjQYCA55yLv6TluBaUgL1Exq9SVpfrTvzIs=;
 b=kUUtVsrr6KVp6A8595f2Bo8SPMTe4Qjtb8M/f8urx5pnp61iAD3SZtFDk2rtgzk1cY
 bGImPSiGarLOTjdf0TybWE5kPqNrr9oUCdVxTgwdid+NXKHPJ+G9YMs+WLUR3OYWIKjx
 T/W5lggd/VSq80SBJ09vtOvhA68ZxSBtDZpzi5gbHvcOj6TF1BOEwqjx46snk+7WfJFD
 1j81h8P5jGJu/dVQZ1fVwCgGFLRPKVrrk84XPasUNIAEHwLuDusCJTcOfXjCiDWdbI9y
 SVa3Gb7hmsd0fxWkqWn2lAGlJAfsiBv1uYIVbix+FofHiVGbHfIG9b+lO50md4mWBxTl
 E54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1kH8pAcoNjQYCA55yLv6TluBaUgL1Exq9SVpfrTvzIs=;
 b=fduyNBnPmiPihlH+8plE1EtUxQZfN0vd70k1BoNxzaqvCjVFX2q0xEmAUAlKxNnTdZ
 JtE3xxSsWn/nzEqZahQeMgQnm99oIm7A1udKFeCsMWx4cPpxgX92/0T1FQlq5F0nNm2g
 IzQ/hXLFUnaeLHpRxaEknnGN4NgcOkRzscUEh0CEcba1MgNu3x/zpuPMUw5/ma4e7SEb
 N6jZG+upDE8pU54PYeqtJhK1Yob5FGaNmYjugMZg9m76hnfp6c+WYOFToM2o4Hupbgov
 k0cX563A3tpTL9o9e0cRT5sqVTBx68zcHW/w55WkyGVr3LMxcYyuaM7pYXx37dAyoMuZ
 UGvw==
X-Gm-Message-State: AOAM532tHJV51+wcnEB7ev15CszrOBKmWD26C5IQy2oll0a81FnoJuTx
 4xVTAcOXOQUz/oeb9AYe8G5mk17vdEv45LDhVlm93A==
X-Google-Smtp-Source: ABdhPJxQ1oyXEIRMc44EsRPCZYfsdeQM6GVz6j8ctOUgswgXBIGQRRbE++vTPKhM0h8E59gjqOQwaM2w22Hi8MC6yb0=
X-Received: by 2002:a05:6870:8196:b0:dd:e471:8bb5 with SMTP id
 k22-20020a056870819600b000dde4718bb5mr815646oae.294.1648543923470; Tue, 29
 Mar 2022 01:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-7-kaleshsingh@google.com>
In-Reply-To: <20220314200148.2695206-7-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 29 Mar 2022 09:51:27 +0100
Message-ID: <CA+EHjTw-A8qu924yGfjbhXLqoBssBz4iDb7WNMs3zej+Q==iWQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] KVM: arm64: Add hypervisor overflow stack
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, Andrew Walbran <qwandor@google.com>,
 will@kernel.org, Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Mon, Mar 14, 2022 at 8:05 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> Allocate and switch to 16-byte aligned secondary stack on overflow. This
> provides us stack space to better handle overflows; and is used in
> a subsequent patch to dump the hypervisor stacktrace. The overflow stack
> is only allocated if CONFIG_NVHE_EL2_DEBUG is enabled, as hypervisor
> stacktraces is a debug feature dependent on CONFIG_NVHE_EL2_DEBUG.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad



> ---
>
> Changes in v4:
>   - Update comment to clarify resetting the SP to the top of the stack
>     only happens if CONFIG_NVHE_EL2_DEBUG is disabled, per Fuad
>
>
>  arch/arm64/kvm/hyp/nvhe/host.S   | 11 ++++++++---
>  arch/arm64/kvm/hyp/nvhe/switch.c |  5 +++++
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index be6d844279b1..a0c4b4f1549f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -179,13 +179,18 @@ SYM_FUNC_END(__host_hvc)
>         b       hyp_panic
>
>  .L__hyp_sp_overflow\@:
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +       /* Switch to the overflow stack */
> +       adr_this_cpu sp, hyp_overflow_stack + PAGE_SIZE, x0
> +#else
>         /*
> -        * Reset SP to the top of the stack, to allow handling the hyp_panic.
> -        * This corrupts the stack but is ok, since we won't be attempting
> -        * any unwinding here.
> +        * If !CONFIG_NVHE_EL2_DEBUG, reset SP to the top of the stack, to
> +        * allow handling the hyp_panic. This corrupts the stack but is ok,
> +        * since we won't be attempting any unwinding here.
>          */
>         ldr_this_cpu    x0, kvm_init_params + NVHE_INIT_STACK_HYP_VA, x1
>         mov     sp, x0
> +#endif
>
>         bl      hyp_panic_bad_stack
>         ASM_BUG()
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 703a5d3f611b..efc20273a352 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -34,6 +34,11 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
>  DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
>  DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
>
> +#ifdef CONFIG_NVHE_EL2_DEBUG
> +DEFINE_PER_CPU(unsigned long [PAGE_SIZE/sizeof(long)], hyp_overflow_stack)
> +       __aligned(16);
> +#endif
> +
>  static void __activate_traps(struct kvm_vcpu *vcpu)
>  {
>         u64 val;
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
