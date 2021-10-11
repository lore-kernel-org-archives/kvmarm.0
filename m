Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6033C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 13:36:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 39FA360F6E
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 13:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 39FA360F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97A2F4B0DE;
	Mon, 11 Oct 2021 09:36:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2Bt+01EE-4v2; Mon, 11 Oct 2021 09:36:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE90407D1;
	Mon, 11 Oct 2021 09:36:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29AC84B089
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 09:36:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LIIEZpn4Nbrw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 09:36:44 -0400 (EDT)
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com
 [209.85.167.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E69F407D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 09:36:44 -0400 (EDT)
Received: by mail-oi1-f172.google.com with SMTP id n64so24724040oih.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 06:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=/JNfG7kesfRccmBVAhgQG5AruC/McrlnRGzPRsyxeyM=;
 b=NifGimNaB2ZW4w+nudH3Crr3IAjX+qDkvy69+ohEL27gn2rQ2wjsXz1N232aoWVZxx
 ipJe3zMObIHGcqEGDwPBNxIdci8gIDofGP+QoyDXYTLNXOTWawZ1/PlCTKG3ngJpo7EO
 oLLKgBt0JFyU86cgQGcqG0nxjkhmnhbOqUl1ok+B3oH88pcem65YTGdQ6TumCIHEcKH1
 VJ3XSGwVybDV+ASkqVpmhLFyVwFVlZu6OoFq9m27Vy+uHD7enH7QOt5wC9NnLBtUXtWs
 2uFLlGCV04JFgFcjG6ysHt15JS9u7jH2fAiJsQZVEKJc/UdbdptpFmhMZY3j7SwKOe0/
 WzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=/JNfG7kesfRccmBVAhgQG5AruC/McrlnRGzPRsyxeyM=;
 b=WRUdCMhMt6A5R8Fktt6fR3o+37DAd7Gbehh6uiNH0zRhbd7DbGaIDeuI/SbDCxhMEZ
 CCQlmJEeizST5c0QeEFmpUNw5QFBvUeaUnomgXVeW42EQF4b7kKOlRdy6zkusgdRkHBg
 pq1+4XOBTaalvHpgDTQNXPq84sJAVpK+mo/JyeVof3TsHdbSAPsFKwEXpolQRuqeL5ZJ
 4UKOhiRQKMWl/cAq7Lhr3Dmkjn+DwuQXpUASBVvdns9Od0me84VrFLVex2CAtu+mtUAl
 rO7S7YNyfbTXszBKFlL7Go1I33qEXHshYCQyGldNHf/sV7GLFpZ4LJCs6iX0DpwLAi0Z
 NFnQ==
X-Gm-Message-State: AOAM531gvNyue/wdF6Zk/9Y+hRvTEWxN4Mvi+9Qz6FLsfPTwiSC4M1Yn
 2wBiVcURC1Jaz5JuoEmyAtq/NkRpvNvAHIq6zyPkSQ==
X-Google-Smtp-Source: ABdhPJxSU1RD8HB9ikjK3AC6DC3JCIDrsYxB9kWDH3QApKuFfDrikxmBHv7urC3iR+Spt9gzOmk7NSFXmKQug5Q3HIc=
X-Received: by 2002:aca:c0c4:: with SMTP id q187mr14780782oif.96.1633959403235; 
 Mon, 11 Oct 2021 06:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
 <20211010145636.1950948-12-tabba@google.com>
 <87o87vpuze.wl-maz@kernel.org>
In-Reply-To: <87o87vpuze.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Oct 2021 14:36:06 +0100
Message-ID: <CA+EHjTxKn7Ff7zOCnoVR+L-qKg7OE81EerkO-SgcXVUZxJjbug@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] KVM: arm64: Handle protected guests at 32 bits
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
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

Hi Marc,

On Mon, Oct 11, 2021 at 2:11 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Sun, 10 Oct 2021 15:56:36 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Protected KVM does not support protected AArch32 guests. However,
> > it is possible for the guest to force run AArch32, potentially
> > causing problems. Add an extra check so that if the hypervisor
> > catches the guest doing that, it can prevent the guest from
> > running again by resetting vcpu->arch.target and returning
> > ARM_EXCEPTION_IL.
> >
> > If this were to happen, The VMM can try and fix it by re-
> > initializing the vcpu with KVM_ARM_VCPU_INIT, however, this is
> > likely not possible for protected VMs.
> >
> > Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> > AArch32 systems")
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 34 ++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 2c72c31e516e..f25b6353a598 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -232,6 +232,37 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >       return hyp_exit_handlers;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) are not be allowed to run in AArch32.
> > + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> > + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> > + * hypervisor spots a guest in such a state ensure it is handled, and don't
> > + * trust the host to spot or fix it.  The check below is based on the one in
> > + * kvm_arch_vcpu_ioctl_run().
> > + *
> > + * Returns false if the guest ran in AArch32 when it shouldn't have, and
> > + * thus should exit to the host, or true if a the guest run loop can continue.
> > + */
> > +static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> > +{
> > +     struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> > +
> > +     if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu)) {
> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid. The VMM
> > +              * can try and fix it by re-initializing the vcpu with
> > +              * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +              * protected VMs.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
>
> Aren't we losing a potential SError here, which the original commit
> doesn't need to handle? I'd expect something like:
>
>                 *exit_code &= BIT(ARM_EXIT_WITH_SERROR_BIT);
>                 *exit_code |= ARM_EXCEPTION_IL;

Yes, you're right. That would ensure the SError is preserved.

Thanks,
/fuad


> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -294,6 +325,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >               /* Jump in the fire! */
> >               exit_code = __guest_enter(vcpu);
> >
> > +             if (unlikely(!handle_aarch32_guest(vcpu, &exit_code)))
> > +                     break;
> > +
> >               /* And we're baaack! */
> >       } while (fixup_guest_exit(vcpu, &exit_code));
> >
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
