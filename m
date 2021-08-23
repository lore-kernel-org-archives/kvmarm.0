Return-Path: <SRS0=YqI3=NO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEC0C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:26:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0C906124B
	for <kvmarm@archiver.kernel.org>; Mon, 23 Aug 2021 10:26:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E0C906124B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CDF44B24D;
	Mon, 23 Aug 2021 06:26:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FDoJd51TaN3d; Mon, 23 Aug 2021 06:25:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD374B206;
	Mon, 23 Aug 2021 06:25:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3D994B1D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UCKQVm++DwfB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Aug 2021 06:25:57 -0400 (EDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com
 [209.85.210.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A154A4B17E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 06:25:57 -0400 (EDT)
Received: by mail-ot1-f50.google.com with SMTP id
 g66-20020a9d12c8000000b0051aeba607f1so26522965otg.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Aug 2021 03:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=iil3g1xzE54TUwgwxXbVjp/I2BXWoZeDWrISpeeZe14=;
 b=BEW3pF7bCpIXQquKczEegFeZjB4PN2FJINV+cpI96e+ZQKAUumwIkxkDwpbx3KxVX/
 jEV7r2X/PXB2J5H9vROz1yIGrg/C9BzHL2ENP4rws1a69K/LMgiALseDgDCqMkZf1zTT
 iXMVQXasH/iLEIZZQ2O019Dd8bfQCg7UE4mAC5hsYCzmN3+VqRSGWNbgF2jwGtyaNrbq
 2dh21hx5nfjAG1EedyrdGR+2AIZE0gAzriJ9sCGtm4N9Rxdpdj5w5BYRgmlh+IHNZiu9
 wOpyw2qGxapWYcgQ0s4wMPR5DW1y51wv1BZX/EIraK4Wzwln68WzoQTFeaTaW1NQ3nYg
 c3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=iil3g1xzE54TUwgwxXbVjp/I2BXWoZeDWrISpeeZe14=;
 b=AFeAvzqn1nAP0kQLT6Ofb8BiJd9Q0o4CoAaLzKzf9FngZyszNl4OmeZUwI/BbIuyqh
 z1aBogTFRkYDWBUprD3rT4Cl+U2oTLC1JFHHgHzDbfTXA2u6Npxs5fH2d7ztPHNIPwDd
 pHGnjUo0NrgoUN58rW7vz8qgSX6n5zZWLMOBSlVyNYL5Cp8/Agth0EIJPiTVHq/GsnzE
 plwTwhy2gO9k6+bG/EDEm3xV7WcV7112uhUOIyeanVDwX5tQZy6lpAPLM80GVokjLhP3
 stNi67f2c7q6iri8IbwsuNo7Dkj/olrfjwgbhcFtlm5GTj7QhCJUzBcICRd/AFKDDzrj
 8Mwg==
X-Gm-Message-State: AOAM531viU60Ae2oq++Fy2r5DCJ73dDikjxU2N04GPW1Jx5UYQ5H6LPi
 BuRHLNjlhu8Vv983/n5cBYJBcwG81GiW8clfIdYcqA==
X-Google-Smtp-Source: ABdhPJyc5KKsDid+ISzlkW07QeZX7D5K3hIbXU4y15H3axJsNCGDbA+XxfiyQc68SzeSTbGJu39OzYXXM1Av29ZlITE=
X-Received: by 2002:a05:6830:1dac:: with SMTP id
 z12mr23465282oti.52.1629714356807; 
 Mon, 23 Aug 2021 03:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
 <20210817081134.2918285-16-tabba@google.com>
 <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
In-Reply-To: <CAOQ_QsgSfHVjJkSJku5DwUe0_=ds4GduPbJ7vC-t+4_=fPVFBQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 23 Aug 2021 11:25:20 +0100
Message-ID: <CA+EHjTwPgjXtrR5dFx0RBN9xdX0j7ugO=NqAmkmZqYE9N_jP7w@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] KVM: arm64: Handle protected guests at 32 bits
To: Oliver Upton <oupton@google.com>
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Thu, Aug 19, 2021 at 9:10 AM Oliver Upton <oupton@google.com> wrote:
>
> Hi Fuad,
>
> On Tue, Aug 17, 2021 at 1:12 AM Fuad Tabba <tabba@google.com> wrote:
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
> >  arch/arm64/kvm/hyp/nvhe/switch.c | 37 ++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index 398e62098898..0c24b7f473bf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -20,6 +20,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -195,6 +196,39 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
> >                 return NULL;
> >  }
> >
> > +/*
> > + * Some guests (e.g., protected VMs) might not be allowed to run in AArch32. The
> > + * check below is based on the one in kvm_arch_vcpu_ioctl_run().
> > + * The ARMv8 architecture does not give the hypervisor a mechanism to prevent a
> > + * guest from dropping to AArch32 EL0 if implemented by the CPU. If the
> > + * hypervisor spots a guest in such a state ensure it is handled, and don't
> > + * trust the host to spot or fix it.
> > + *
> > + * Returns true if the check passed and the guest run loop can continue, or
> > + * false if the guest should exit to the host.
> > + */
> > +static bool check_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
>
> This does a bit more than just check & return, so maybe call it
> handle_aarch32_guest()?
>
> > +{
> > +       if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
>
> maybe initialize a local with a hyp pointer to the kvm structure.

Will do.

> > +           vcpu_mode_is_32bit(vcpu) &&
> > +           FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL0),
> > +                                        PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) <
> > +               ID_AA64PFR0_ELx_32BIT_64BIT) {
>
> It may be more readable to initialize a local variable with this
> feature check, i.e:
>
> bool aarch32_allowed = FIELD_GET(...) == ID_AA64PFR0_ELx_32BIT_64BIT;
>
> and then:
>
>   if (kvm_vm_is_protected(kvm) && vcpu_mode_is_32bit(vcpu) &&
> !aarch32_allowed) {

I agree.

Thanks,
/fuad

> > +               /*
> > +                * As we have caught the guest red-handed, decide that it isn't
> > +                * fit for purpose anymore by making the vcpu invalid. The VMM
> > +                * can try and fix it by re-initializing the vcpu with
> > +                * KVM_ARM_VCPU_INIT, however, this is likely not possible for
> > +                * protected VMs.
> > +                */
> > +               vcpu->arch.target = -1;
> > +               *exit_code = ARM_EXCEPTION_IL;
> > +               return false;
> > +       }
> > +
> > +       return true;
> > +}
> > +
> >  /* Switch to the guest for legacy non-VHE systems */
> >  int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >  {
> > @@ -255,6 +289,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
> >                 /* Jump in the fire! */
> >                 exit_code = __guest_enter(vcpu);
> >
> > +               if (unlikely(!check_aarch32_guest(vcpu, &exit_code)))
> > +                       break;
> > +
> >                 /* And we're baaack! */
> >         } while (fixup_guest_exit(vcpu, &exit_code));
> >
> > --
> > 2.33.0.rc1.237.g0d66db33f3-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
