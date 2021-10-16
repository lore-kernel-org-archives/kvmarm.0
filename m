Return-Path: <SRS0=NFrk=PE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5737AC433F5
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 19:54:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5DC360FDC
	for <kvmarm@archiver.kernel.org>; Sat, 16 Oct 2021 19:54:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B5DC360FDC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B974B133;
	Sat, 16 Oct 2021 15:54:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wH9hvtMxUP2j; Sat, 16 Oct 2021 15:54:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD3FF4B13A;
	Sat, 16 Oct 2021 15:54:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A554B11B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 15:54:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DIGgmhWES74s for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Oct 2021 15:54:35 -0400 (EDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com
 [209.85.214.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D545F4B119
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 15:54:34 -0400 (EDT)
Received: by mail-pl1-f177.google.com with SMTP id y1so8562962plk.10
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Oct 2021 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7Bg6TGOLAavtW0s4J/kZZMV1bnJwdYuD4TGepUNX/tY=;
 b=AmqmWsOfoRoUoz+WTi74gAe9rN4hcVK8XFoVdL+M8NRmib/RrP1Z1AdbG2lOogb1Wt
 1W8+dQ6xJKWyXh2UgWICoXnk8BsDVfVn/6c0mtGveFqfGlCxffbRim8qKyPbE2RIwHkX
 D96Dz46VL/Y3G+ooYKS0GmL1ICXlJCdvFWJatzq9jr5r7YKwvg5jJ1ui1wpZ5zq4Haay
 YPknnmtgflDrWaqTepv0noQ2UXBDtt8oCluxFZ4duhKt/rCcXtd0EC3POAPwOHE5VmV8
 Xx9VeRn2rzEPhE1h+Nm5huLq6DIS/w9+bohPezxLHhxxa9UmJamkUfPXbwj7eeFOR3eP
 rFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7Bg6TGOLAavtW0s4J/kZZMV1bnJwdYuD4TGepUNX/tY=;
 b=7jCeWO6/b4GM05B6v3M3MehKcQy8GLLSWcNZIhiIEpnT5DWO8fYW/fwmOFORVzzs/E
 3G1LyLw3VMrSlsJB/O3IsVHJIzxOV1IbN9sKZLPrExa2jaBfB8YkHWE+EQi4wbrGidbu
 Vd0fUHnyDsbcDE36vSC/O+WTdB8QmYL7gamYLtpizsNnYF4xOVe0Fand+RHXCRu2xqHw
 x0327teDKAyqLA+jAXj9w8Xa6hvfipQPihjCe6L7+k1XWVb2uss79DCgJjQlNp/kwPhT
 eRLunWGmhEYSltLl8DxK57X0yQXRcV7Z5n+R1MPAXFzM1AQQSaeEWPcGuumHaJ08H1hg
 TGzw==
X-Gm-Message-State: AOAM5305ltUCmZM8lNARwu0UHV6uvTuYJDx4Vq73pEAENuG4O+d0nX8C
 WT5t7g0xnltXaxqfU6gc9NKMY4gTkMqYSRHH3SrCvQ==
X-Google-Smtp-Source: ABdhPJy8Zqegj2FjeexRUCd5FvBZlqkWIK73RiHjvMhow6D+8ObsSPjfF+SGKLlFtZcHDY002b/ddFUmLDeOv6QcUxk=
X-Received: by 2002:a17:90a:bd04:: with SMTP id
 y4mr22202191pjr.9.1634414073731; 
 Sat, 16 Oct 2021 12:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-2-reijiw@google.com>
 <20211015101259.4lmlgk5ll2mrnohd@gator>
In-Reply-To: <20211015101259.4lmlgk5ll2mrnohd@gator>
From: Reiji Watanabe <reijiw@google.com>
Date: Sat, 16 Oct 2021 12:54:18 -0700
Message-ID: <CAAeT=Fy13Y9AJPvk3EovX9_-mo7D=kRaN6-gHA9q9o99r3qhog@mail.gmail.com>
Subject: Re: [RFC PATCH 01/25] KVM: arm64: Add has_reset_once flag for vcpu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Andrew,

On Fri, Oct 15, 2021 at 3:13 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 11, 2021 at 09:35:11PM -0700, Reiji Watanabe wrote:
> > Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> > if the vCPU reset has been done once, for later use.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 2 ++
> >  arch/arm64/kvm/reset.c            | 4 ++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..9b5e7a3b6011 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
> >               u64 last_steal;
> >               gpa_t base;
> >       } steal;
> > +     bool has_reset_once;
> >  };
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
> >
> >  #define vcpu_has_sve(vcpu) (system_supports_sve() &&                 \
> >                           ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> > +#define      vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
> >
> >  #ifdef CONFIG_ARM64_PTR_AUTH
> >  #define vcpu_has_ptrauth(vcpu)                                               \
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 5ce36b0a3343..4d34e5c1586c 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       if (loaded)
> >               kvm_arch_vcpu_load(vcpu, smp_processor_id());
> >       preempt_enable();
> > +
> > +     if (!ret && !vcpu->arch.has_reset_once)
> > +             vcpu->arch.has_reset_once = true;
> > +
> >       return ret;
> >  }
> >
> > --
> > 2.33.0.882.g93a45727a2-goog
> >
>
> Hi Reiji,
>
> Can't we use kvm_vcpu_initialized(vcpu)? vcpu->arch.target should
> only be >= when we've successfully reset the vcpu at least once.

Thank you for reviewing the patch (and other patches as well) !

As you already noticed, we can't simply use kvm_vcpu_initialized()
because vcpu->arch.target is currently set earlier than the first
vcpu reset.

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
