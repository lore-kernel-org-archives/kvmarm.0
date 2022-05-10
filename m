Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001BBC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:44:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6181C49EF3;
	Tue, 10 May 2022 05:44:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFtox2ayWEoa; Tue, 10 May 2022 05:44:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67DBC40159;
	Tue, 10 May 2022 05:44:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B98FA49F3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:44:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id APfi7b1Q8SNv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:44:40 -0400 (EDT)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715FA49EF3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:44:40 -0400 (EDT)
Received: by mail-oi1-f174.google.com with SMTP id q8so17920089oif.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=tYmmaSjEQ0DAQ3hg78JmoXw7IWzTfCf5R6XNgYIbQdw=;
 b=jCnsf3hK1Pir0MXvc5uMjsEDPJnUI43QrFH+brw/Jo2vC6JSYoNSPTUX2qfDOJZQvf
 HUWB+IHA3rcd9mhQPx6R/EXneddFLEbJeYWjrRiGFPrgVvQnLOSEC+Xmh5brb/vcOqYj
 SNj66hg7iLoRFudTYvCzNI3qm5tMvIQ5pgrEWeK38YkYHMDDuMT/6BSbHrqdVWO+2HJR
 TLF2DKCb/iU6Wt1bZBpEhNA71HvYwYqmNyFreQULZ3U362tk6ARL/I1Cw9kjbWWopUbC
 fusK9b2Q7CQuUuPMnQTUcnoszsTym+W4jqOu/GBwu4egVLuEheEp8Sdm8ERqeZgd/nio
 Tclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=tYmmaSjEQ0DAQ3hg78JmoXw7IWzTfCf5R6XNgYIbQdw=;
 b=JINI+Sk4ooyuuPRp6YA20ni6QxpqCZ52dA/ter4c6QOVxxNeKReBc3sGbiJqHU9v3t
 HCOCbxU64820NmOgdQaRYt8cnj99wqNnuuuYdAFI97nyOqaznVxz/k05osJ97zgZccJY
 qfMMdxsQjY/M9edqeM3DRxDDjupGSA4/hLQyEkFeeLixEV0lsmFaDYkcD+YxvJF9/Q+J
 psQ99432KJ5Lx/SJF4qZoK/6zkrzOyMHFTbAjODcOhx7dct/GZfThK4vdgrQ9nopTORw
 eASc8fdZi64rxeU8TGC2qAzvgVUAzgcWr9HW4x5qRlkNp4NGXb8mxwJKDRPL3uZTYfiT
 wixg==
X-Gm-Message-State: AOAM531fRkRiuJ1VnYX7gN2A2PJndJmrO7eNS2t65Ix3QnGP+Aqxtmx9
 hyD795G0YJeWndLYlrp9epYl2kHzecMVZJfgZZRTvw==
X-Google-Smtp-Source: ABdhPJwi2uvaLL5WnzUOVGJ8SKVlBEr9x64tGdRwKs5uPLqPlRBlIPuG/lgPmYNqeBIi9V5qKOAF0+eR3XEjjvTNyWo=
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id
 h11-20020aca180b000000b002f723ae8cd1mr13432825oih.146.1652175878175; Tue, 10
 May 2022 02:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
 <20220509162559.2387784-2-oupton@google.com>
In-Reply-To: <20220509162559.2387784-2-oupton@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 May 2022 10:44:01 +0100
Message-ID: <CA+EHjTz3J4aJ3MximOc1ybZQV8yNG7Z9gyQPFrm2XtrF-zUAxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap
 handler
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

On Mon, May 9, 2022 at 5:26 PM Oliver Upton <oupton@google.com> wrote:
>
> The pVM-specific FP/SIMD trap handler just calls straight into the
> generic trap handler. Avoid the indirection and just call the hyp
> handler directly.
>
> Note that the BUILD_BUG_ON() pattern is repeated in
> pvm_init_traps_aa64pfr0(), which is likely a better home for it.
>
> No functional change intended.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/switch.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index 6410d21d8695..3dee2ad96e10 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -175,23 +175,6 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
>                 kvm_handle_pvm_sysreg(vcpu, exit_code));
>  }
>
> -/**
> - * Handler for protected floating-point and Advanced SIMD accesses.
> - *
> - * Returns true if the hypervisor has handled the exit, and control should go
> - * back to the guest, or false if it hasn't.
> - */
> -static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
> -{
> -       /* Linux guests assume support for floating-point and Advanced SIMD. */
> -       BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
> -                               PVM_ID_AA64PFR0_ALLOW));
> -       BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
> -                               PVM_ID_AA64PFR0_ALLOW));
> -
> -       return kvm_hyp_handle_fpsimd(vcpu, exit_code);
> -}
> -
>  static const exit_handler_fn hyp_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
> @@ -207,7 +190,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
>         [0 ... ESR_ELx_EC_MAX]          = NULL,
>         [ESR_ELx_EC_SYS64]              = kvm_handle_pvm_sys64,
>         [ESR_ELx_EC_SVE]                = kvm_handle_pvm_restricted,
> -       [ESR_ELx_EC_FP_ASIMD]           = kvm_handle_pvm_fpsimd,
> +       [ESR_ELx_EC_FP_ASIMD]           = kvm_hyp_handle_fpsimd,
>         [ESR_ELx_EC_IABT_LOW]           = kvm_hyp_handle_iabt_low,
>         [ESR_ELx_EC_DABT_LOW]           = kvm_hyp_handle_dabt_low,
>         [ESR_ELx_EC_PAC]                = kvm_hyp_handle_ptrauth,
> --
> 2.36.0.512.ge40c2bad7a-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
