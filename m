Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70745C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:05:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D9FA96137C
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D9FA96137C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66ED34B2A6;
	Tue,  5 Oct 2021 05:05:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qFOImI02H8Gb; Tue,  5 Oct 2021 05:05:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50C9D4B2C0;
	Tue,  5 Oct 2021 05:05:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E24A4B2A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:05:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W8PIMg6MrVHb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:05:45 -0400 (EDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com
 [209.85.167.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6359D4B2A5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:05:45 -0400 (EDT)
Received: by mail-oi1-f177.google.com with SMTP id v10so1113754oic.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZM3Zs1hD0IvxW0NEoOVRpgIBxIg0g/Aefp92Tu/RS14=;
 b=DGxWG2YlpVunKcb7OQr0SKzOX9CTc0PhPEnwq/MUvowulZ084/74w+yMqV8HfUqupl
 Z8i6/b71iIdwf+SVw4wxivnoh5EpKdwJEDO7eb4Wp1Zv8utuUQc65OrqfF+TcYSt6Gwy
 3SF4c04jFlYufVJ3N3z1MG3Beo6zWubWbiNzAncDftNled8YOM767waM69j1UDGGuy6L
 1+/BL38Q7i0U/Y3mY4Allok0YDrxxDrc8oBAuit2EmoDXcENtSNL5/iGh18RsDGpzjHt
 iAoM9jSihkQLb79YcfOmYUZ06/jPuKCqzVhfEUK3YihTHoRGo4Jf5lxo5CX9KoWqXb2/
 qvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZM3Zs1hD0IvxW0NEoOVRpgIBxIg0g/Aefp92Tu/RS14=;
 b=W5SVlg0YpYiWXtXojrKT2NmvPUE03KIZqvGBf4PMReInyBzISiGVSLR3202dSGRX0T
 asIbLsjuSMStzJw8I4dWeEZxwhBb+hT7rs2cflWTMliNbYw71ja9/VGzNjc/1T1eU+m3
 7NiFrT87+k5XY93dwAsrnBFpEmTeUQeR6mlKA/y4RPeoNOmQMbbA7yVSA9G4eUk6BNZF
 HOHtb7H8AmIcOpd+4Yfi/ngKdymlm6nFwm77g/U3dE/Ws9FMC5k/SvIxq5fCjs6COLwC
 Ooj0p1xbb6cGiEDR7jTEwnJrt+1GdHj9Rz3P82IBjO9+RhMMbw41usjLLXf9Ht+L37nD
 TcTg==
X-Gm-Message-State: AOAM533XuASbo8sHxoEIdfxEA0+dNPLrjtC8UupCVjv44NPHsVtDt4ko
 KnZzWXs2wcEPEajRcIS+PiEw2d56QAnx1mgS+sqyHg==
X-Google-Smtp-Source: ABdhPJz67hcp3PPxwZdQScqsFRDex6KiMAh2iDnZJJt+LUbAzcOQmphJP5sqXjayKo9PJSWuAvxT7mO1+VdmpRsxF9Q=
X-Received: by 2002:aca:604:: with SMTP id 4mr1531266oig.8.1633424744609; Tue,
 05 Oct 2021 02:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
 <20210922124704.600087-13-tabba@google.com>
 <87sfxfrh6k.wl-maz@kernel.org>
In-Reply-To: <87sfxfrh6k.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Oct 2021 10:05:08 +0100
Message-ID: <CA+EHjTyYz4Hf6-awZTLinWxkr3N_j9K-m7TEe=EKCFUuQL_mYA@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] KVM: arm64: Handle protected guests at 32 bits
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

On Tue, Oct 5, 2021 at 9:48 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 22 Sep 2021 13:47:04 +0100,
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
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 40 ++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 2bf5952f651b..d66226e49013 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -235,6 +235,43 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
> >       return hyp_exit_handlers;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32.
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
> > +     struct kvm *kvm = (struct kvm *) kern_hyp_va(vcpu->kvm);
>
> There is no need for an extra cast. kern_hyp_va() already provides a
> cast to the type of the parameter.

Will drop it.

> > +     bool is_aarch32_allowed =
> > +             FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> > +                       get_pvm_id_aa64pfr0(vcpu)) >=
> > +                             ID_AA64PFR0_ELx_32BIT_64BIT;
> > +
> > +
> > +     if (kvm_vm_is_protected(kvm) &&
> > +         vcpu_mode_is_32bit(vcpu) &&
> > +         !is_aarch32_allowed) {
>
> Do we really need to go through this is_aarch32_allowed check?
> Protected VMs don't have AArch32, and we don't have the infrastructure
> to handle 32bit at all. For non-protected VMs, we already have what we
> need at EL1. So the extra check only adds complexity.

No. I could change it to a build-time assertion just to make sure that
AArch32 is not allowed instead.

Thanks,
/fuad

> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid. The VMM
> > +              * can try and fix it by re-initializing the vcpu with
> > +              * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +              * protected VMs.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -297,6 +334,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
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
