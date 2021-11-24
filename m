Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F99C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 13:09:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D9B54B0C3;
	Wed, 24 Nov 2021 08:09:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AMKo9HcrgO52; Wed, 24 Nov 2021 08:09:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BD494B1A5;
	Wed, 24 Nov 2021 08:09:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A9BA4B1A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:09:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rzVVyrEmrqyX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 08:09:00 -0500 (EST)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com
 [209.85.167.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 06E214B0CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 08:08:59 -0500 (EST)
Received: by mail-oi1-f178.google.com with SMTP id n66so5187082oia.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 05:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=1rvmNxp+ZtA3HbUdsVCZv4Nlqvs5Xp/+S8TXy0ecUM0=;
 b=pl/FfakhouFer+0yVcn+lqB8MhZkiNrWzu3kYkf5qnxnJqtGJSIs4PYBZfPz2TD4vP
 l6N0I7MlQDR0L+5RYQ2pPRcbMCcJOObJKlv1TwjAeqeR5ZQ2QIHK6uC+kfCCwExqX+ef
 7qxrz0adF7nAZuWapS7EUhelX6F3A8P8KislRj4qV4ey7KJEhASK28fFfEz8N4MSX6zw
 gn7VKGg342BuZ3GquHXcFojbeTege8EanA9l7BvkHPKf+pOehvz3FE58xZvEffVXdku9
 TnWo8TNgn4WtWOGJJgr1Tuik0NzcKARfVrYny+xL/r1NDnoeoItfUSp7PmDZ8HcUOket
 W/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=1rvmNxp+ZtA3HbUdsVCZv4Nlqvs5Xp/+S8TXy0ecUM0=;
 b=KmQneDPZn4Zb9MbqJ6VOU8k9pBQKBsBvksOyN+K6RQ/yhhYN1lVX85aThKCpVgPQbH
 oF/gHGgf2m8cyfZpj+aZgRWRcNxM4OUR57Rtqrj26VMsRB9eddMVp/0//qCZOvQeZLU9
 qGU/O6IgPi3I7Bz39dpl0sCj6+sfjG5QxU1k9OWZ2BTLyQOHbMJOqguUzTtYTSYiEM/x
 drWSkAA1uve+7tSYjxdmIspXjfjc3uS0iu6burRBu9YId1HOYRVHcMWUTigzG7N5edNj
 ZtGcKwP7Lp2XoRxzc6KKXuxHqZg7xtdStnSaie17wX5m9o586DxWL7P+OxQOFNwXFhBf
 jRfA==
X-Gm-Message-State: AOAM533dg/cd9GeJeU/jfv0k9TfF2tR34n47VxWYu27k6hzd8vctzr6y
 SDgTsn5WXDFVVKSi8Wrh0sSMitnzQwlP54pINQsMjg==
X-Google-Smtp-Source: ABdhPJyTVHnCyxx52YxNwzJrYF43Uk3OQDtKuXCZO7KVCqWd190uR7WGLd+soVX2N6327m8SSW4aKEgqDjPt01EJeRQ=
X-Received: by 2002:a05:6808:485:: with SMTP id
 z5mr5828262oid.96.1637759339134; 
 Wed, 24 Nov 2021 05:08:59 -0800 (PST)
MIME-Version: 1.0
References: <20211123142247.62532-1-maz@kernel.org>
 <20211123142247.62532-2-maz@kernel.org>
In-Reply-To: <20211123142247.62532-2-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Nov 2021 13:08:23 +0000
Message-ID: <CA+EHjTx1i0jEhhBJx6T=6sjkj_hpy5FnkkJqFuY0td83d6C08A@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Save PSTATE early on exit
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
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

Hi Marc,



On Tue, Nov 23, 2021 at 2:23 PM Marc Zyngier <maz@kernel.org> wrote:
>
> In order to be able to use promitives such as vcpu_mode_is_32bit(),
> we need to synchronize the guest PSTATE. However, this is currently
> done deep imto the bowels of the world-switch code, and we do have
> helpers evaluating this much earlier (__vgic_v3_perform_cpuif_access
> and handle_aarch32_guest, for example).

Couple of nits:
s/promitives/primitives
s/imto/into

>
> Move the saving of the guest pstate into the early fixups, which
> cures the first issue. The second one will be addressed separately.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h    | 6 ++++++
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 7 ++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 7a0af1d39303..d79fd101615f 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -429,6 +429,12 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>   */
>  static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  {
> +       /*
> +        * Save PSTATE early so that we can evaluate the vcpu mode
> +        * early on.
> +        */
> +       vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
> +
>         if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
>                 vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index de7e14c862e6..7ecca8b07851 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -70,7 +70,12 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
>  {
>         ctxt->regs.pc                   = read_sysreg_el2(SYS_ELR);
> -       ctxt->regs.pstate               = read_sysreg_el2(SYS_SPSR);
> +       /*
> +        * Guest PSTATE gets saved at guest fixup time in all
> +        * cases. We still need to handle the nVHE host side here.
> +        */
> +       if (!has_vhe() && ctxt->__hyp_running_vcpu)
> +               ctxt->regs.pstate       = read_sysreg_el2(SYS_SPSR);
>
>         if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
>                 ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
> --
> 2.30.2
>

I see that now that you're storing pstate early at the guest exit, and
therefore no need for vhe path to check for it for the guest when saving
the return state. Going through the various possibilities, I think
that all cases are covered.

I tested this code as well and it ran fine.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
