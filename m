Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAA3C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 04:37:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AFD3261206
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 04:37:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AFD3261206
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 283EF4A173;
	Wed, 22 Sep 2021 00:37:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8lGlICOaKVj0; Wed, 22 Sep 2021 00:37:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0834A193;
	Wed, 22 Sep 2021 00:37:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 536A34A00B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 00:37:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OiCYt-Uaebvt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 00:37:49 -0400 (EDT)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2244749F6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 00:37:49 -0400 (EDT)
Received: by mail-pg1-f178.google.com with SMTP id q68so1341073pga.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 21:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=m6kldB4rj/R0WAkH0imKrXheJ5V9FdbCmll402cf/IA=;
 b=ICo+Qb1xVrXPRSI7NnKutgqIbTVSjHefGoL4UTvWcdLzlKBJcZSOAiv37rrnqZo5Rz
 jNJVc+p3x+rdeAuuHjiG9hFl/ETgaYUUm8MAeg5KJi1Bk02G1yoSkpeyIWxy2d9wZAtw
 i8YENzp7fDKb9uovIf0iENUaGw66di9BTbJjh/Zo1wJKNAkzSX4udgaHcybfT3HuiKiF
 bYitJiAyGbWz/wX/nZy8zut9LS8vOk9eL2QPKDL1xRWvGwwX0T2+e/i/jly2XCsK1cpU
 sdeeADNM/l3nMY1rLbHvXxjuGnmm38PHeJOlwbdjlTi4jwxwQUNHex7hqfXsEoKMrZH6
 MkhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=m6kldB4rj/R0WAkH0imKrXheJ5V9FdbCmll402cf/IA=;
 b=jNKULsaLCD4VVAXfoPwYume/35GSAf+uoM6WhKBZn02K9CGdZKMlTJrx/KfBi2pd1v
 4SG1POXbYxsVsXPM3d3DAixuOyX1g7WcwFJZxTOeSn6qsWC50Advq9LMKJ+pptyPXgtn
 YFyBYkwgCrBW94QWM4GHP/MVBRC+HbA8vHElbvt0GO/cmrDE76Ugu4W8e5U1L0U7WLbx
 hSAHrjp3gf6cHpfgcn4nouxXtvKCs2r8ogk+uVgYlWp9xupLv0zUzqllG6hK6mZZ7GkJ
 dLBX7C1CGVT5yoSHRQPZnFJa5XXYORChJs17V32Ukw3aJEzyOYlXZqq6YpT52f7dRU0x
 +N8w==
X-Gm-Message-State: AOAM531sidwYa1GxJlfKAZppJKRUZGNfj1bs5kDDgcHn+S67qm0v7TKT
 Zu2V9ijWets8+Zrd6CwkwXzAuwspEAN+5z7nyjdY1Q==
X-Google-Smtp-Source: ABdhPJxyLcmXtJzqXIty5HMyLdZx4wO2ii7Xm2RUsWDJqS7lv9IkDE3r3XN2xqczjqfgfhUPLESfVblUgyopY3T/WXI=
X-Received: by 2002:a63:f80a:: with SMTP id n10mr30957910pgh.303.1632285467778; 
 Tue, 21 Sep 2021 21:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
 <20210916181510.963449-3-oupton@google.com>
In-Reply-To: <20210916181510.963449-3-oupton@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 21 Sep 2021 21:37:31 -0700
Message-ID: <CAAeT=Fznwct=D8tk-zRg1SGTa9FqrOrXZ7Boc9yMOnrZ5NPMZw@mail.gmail.com>
Subject: Re: [PATCH v8 2/8] KVM: arm64: Separate guest/host counter offset
 values
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <seanjc@google.com>, Peter Shier <pshier@google.com>,
 Marc Zyngier <maz@kernel.org>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> In some instances, a VMM may want to update the guest's counter-timer
> offset in a transparent manner, meaning that changes to the hardware
> value do not affect the synthetic register presented to the guest or the
> VMM through said guest's architectural state. Lay the groundwork to
> separate guest offset register writes from the hardware values utilized
> by KVM.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/arch_timer.c  | 42 +++++++++++++++++++++++++++---------
>  include/kvm/arm_arch_timer.h |  3 +++
>  2 files changed, 35 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index c0101db75ad4..cf2f4a034dbe 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -84,11 +84,9 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
>
>  static u64 timer_get_offset(struct arch_timer_context *ctxt)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> -               return __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +               return ctxt->host_offset;
>         default:
>                 return 0;
>         }
> @@ -128,17 +126,33 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
>
>  static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
>  {
> -       struct kvm_vcpu *vcpu = ctxt->vcpu;
> -
>         switch(arch_timer_ctx_index(ctxt)) {
>         case TIMER_VTIMER:
> -               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +               ctxt->host_offset = offset;
>                 break;
>         default:
>                 WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
>         }
>  }
>
> +static void timer_set_guest_offset(struct arch_timer_context *ctxt, u64 offset)
> +{
> +       struct kvm_vcpu *vcpu = ctxt->vcpu;
> +
> +       switch (arch_timer_ctx_index(ctxt)) {
> +       case TIMER_VTIMER: {
> +               u64 host_offset = timer_get_offset(ctxt);
> +
> +               host_offset += offset - __vcpu_sys_reg(vcpu, CNTVOFF_EL2);
> +               __vcpu_sys_reg(vcpu, CNTVOFF_EL2) = offset;
> +               timer_set_offset(ctxt, host_offset);
> +               break;
> +       }
> +       default:
> +               WARN_ONCE(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
> +       }
> +}
> +
>  u64 kvm_phys_timer_read(void)
>  {
>         return timecounter->cc->read(timecounter->cc);
> @@ -749,7 +763,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
>
>  /* Make offset updates for all timer contexts atomic */
>  static void update_timer_offset(struct kvm_vcpu *vcpu,
> -                               enum kvm_arch_timers timer, u64 offset)
> +                               enum kvm_arch_timers timer, u64 offset,
> +                               bool guest_visible)

The name 'guest_visible' looks confusing to me because it also
affects the type of the 'offset' that its caller needs to specify.
(The 'offset' must be an offset from the guest's physical counter
if 'guest_visible' == true, and an offset from the host's virtual
counter otherwise.)
Having said that, I don't have a good alternative name for it though...
IMHO, 'is_host_offset' would be less confusing because it indicates
what the caller needs to specify.


>  {
>         int i;
>         struct kvm *kvm = vcpu->kvm;
> @@ -758,13 +773,20 @@ static void update_timer_offset(struct kvm_vcpu *vcpu,
>         lockdep_assert_held(&kvm->lock);
>
>         kvm_for_each_vcpu(i, tmp, kvm)
> -               timer_set_offset(vcpu_get_timer(tmp, timer), offset);
> +               if (guest_visible)
> +                       timer_set_guest_offset(vcpu_get_timer(tmp, timer),
> +                                              offset);
> +               else
> +                       timer_set_offset(vcpu_get_timer(tmp, timer), offset);
>
>         /*
>          * When called from the vcpu create path, the CPU being created is not
>          * included in the loop above, so we just set it here as well.
>          */
> -       timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
> +       if (guest_visible)
> +               timer_set_guest_offset(vcpu_get_timer(vcpu, timer), offset);
> +       else
> +               timer_set_offset(vcpu_get_timer(vcpu, timer), offset);
>  }
>
>  static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
> @@ -772,7 +794,7 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
>         struct kvm *kvm = vcpu->kvm;
>
>         mutex_lock(&kvm->lock);
> -       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff);
> +       update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, true);
>         mutex_unlock(&kvm->lock);
>  }
>
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 51c19381108c..9d65d4a29f81 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -42,6 +42,9 @@ struct arch_timer_context {
>         /* Duplicated state from arch_timer.c for convenience */
>         u32                             host_timer_irq;
>         u32                             host_timer_irq_flags;
> +
> +       /* offset relative to the host's physical counter-timer */
> +       u64                             host_offset;
>  };

Just out of curiosity, have you considered having 'host_offset'
in one place (in arch_timer_cpu or somewhere ?) as physical offset
rather than having them separately for each arch_timer_context ?
I would think that could simplify the offset calculation code
and update_ptimer_cntpoff() doesn't need to call update_timer_offset()
for TIMER_VTIMER.  It would require extra memory accesses for
timer_get_offset(TIMER_VTIMER) though...

Otherwise,
Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
