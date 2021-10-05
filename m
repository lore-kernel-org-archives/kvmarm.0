Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9129C4332F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:05:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 50552614C8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 15:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 50552614C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1F334B2EF;
	Tue,  5 Oct 2021 11:05:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mk0h0NbsFShL; Tue,  5 Oct 2021 11:05:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8609C4B2F3;
	Tue,  5 Oct 2021 11:05:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1784B2EF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:05:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FummvlT29a20 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 11:05:19 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E0C04B2BB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 11:05:19 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id r19so4831936lfe.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 08:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=HqqxFqGpoPg5UsnQOH2LSR3rMJcXiVCZ/CJeT8HveYE=;
 b=RY1wIjfDq9+SAd96CHn57dURL6ZXbL4I2NbPQrvjfUP9h5tmxq45G6s/GKSWlnr6ja
 0otKi37tmc8H1pG7JxuwNjafSUDZz4YY5HG7U/sGgGHDlYHXPjc0QlBnZctuW4XxFVIK
 q8F2uzbo4imvEmYV1QnCbhr/b0RE9lh7ApZ/YKS8ayP/atoarrH/gl2wLzaoQepQgplN
 nv6BC20DtSoH+hvAdPPY191guRmfGV8LX16fpG5YdFXU4x2GFLsZ+rVXeCWehdctVBnu
 Md08GkhtO8ZhpzMYfThwCesnfNJCjQfb7tst02QgWlO8qY0DLnq/Ng/WXK69Ce5k0Q92
 /IOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=HqqxFqGpoPg5UsnQOH2LSR3rMJcXiVCZ/CJeT8HveYE=;
 b=dOcn19do9xhHNBK73vztNi7Nf5j4ogWzVfeYrPTeNzKy+8heYokWK9VjzZJT35XDUk
 0J7lSvZY7LJcZLD6UtAABoYIsDfs870bDGOSyOALQcsPEejcy+12WvHvxnuLvN27/8Bk
 pDAwsHFAgmoH74n8W8Wr39S21p+lB14/vizXWhTQEggnSnkbmqNOBPo72Ybdnb0GteBS
 vqxPbiU0Wo+sIOWGOGuW34QtzMs3QtcDmJTHZ9B3GmwEBzp2PdCx0SO5lFoDisMQsOUr
 pO6a5cTsjLgbfIo03Mn7ddafMhj0cdAGrPP8VtAOq6/dbJ9IXWLLD/q7Oi1WD8IMwFG0
 tAHA==
X-Gm-Message-State: AOAM5304SWct3xA0Whj/rBT8Cn111+kZdPOOp4j/cg/mA8d6VmbWPfz0
 u6OOUI0qTXaPVPPoONB9JaZV4UPB6v2rel9faxdquQ==
X-Google-Smtp-Source: ABdhPJxX8U4W/cLaz3K2FSVqDERDSyCaRKhLNGtRzddkM6nSSebMuNQDwRkMdCq8atcRNjsbnnH2tHHq2sX5yk5qrA4=
X-Received: by 2002:ac2:4ecf:: with SMTP id p15mr3985703lfr.669.1633446316476; 
 Tue, 05 Oct 2021 08:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
 <20211005133335.y4k5qv7d3g74nnzx@gator.home>
In-Reply-To: <20211005133335.y4k5qv7d3g74nnzx@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Tue, 5 Oct 2021 08:05:02 -0700
Message-ID: <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
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

Hi folks,

On Tue, Oct 5, 2021 at 6:33 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> > On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > In its implementation of the PSCI function, KVM needs to request that a
> > > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > > for requesting a reset in a function for later use by other implemented
> > > > PSCI calls.
> > > >
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > ---
> > > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > index 310b9cb2b32b..bb59b692998b 100644
> > > > --- a/arch/arm64/kvm/psci.c
> > > > +++ b/arch/arm64/kvm/psci.c
> > > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > > >  }
> > > >
> > > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > > +                                       unsigned long entry_addr,
> > > > +                                       unsigned long context_id,
> > > > +                                       bool big_endian)
> > > >  {
> > > >         struct vcpu_reset_state *reset_state;
> > > > +
> > > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > > +
> > > > +       reset_state = &vcpu->arch.reset_state;
> > > > +       reset_state->pc = entry_addr;
> > > > +
> > > > +       /* Propagate caller endianness */
> > > > +       reset_state->be = big_endian;
> > > > +
> > > > +       /*
> > > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > +        * the general purpose registers are undefined upon CPU_ON.
> > > > +        */
> > > > +       reset_state->r0 = context_id;
> > > > +
> > > > +       WRITE_ONCE(reset_state->reset, true);
> > > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > +
> > > > +       /*
> > > > +        * Make sure the reset request is observed if the change to
> > > > +        * power_state is observed.
> > > > +        */
> > > > +       smp_wmb();
> > > > +       vcpu->arch.power_off = false;
> > > > +}
> > > > +
> > > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > +{
> > > >         struct kvm *kvm = source_vcpu->kvm;
> > > >         struct kvm_vcpu *vcpu = NULL;
> > > >         unsigned long cpu_id;
> > > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > >                         return PSCI_RET_INVALID_PARAMS;
> > > >         }
> > > >
> > > > -       reset_state = &vcpu->arch.reset_state;
> > > > -
> > > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > > -
> > > > -       /* Propagate caller endianness */
> > > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > > -
> > > > -       /*
> > > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > -        * the general purpose registers are undefined upon CPU_ON.
> > > > -        */
> > > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > > -
> > > > -       WRITE_ONCE(reset_state->reset, true);
> > > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > -
> > > > -       /*
> > > > -        * Make sure the reset request is observed if the change to
> > > > -        * power_state is observed.
> > > > -        */
> > > > -       smp_wmb();
> > > > -
> > > > -       vcpu->arch.power_off = false;
> > > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > > +                                   smccc_get_arg3(source_vcpu),
> > > > +                                   kvm_vcpu_is_be(source_vcpu));
> > > >         kvm_vcpu_wake_up(vcpu);
> > > >
> > > >         return PSCI_RET_SUCCESS;
> > > > --
> > > > 2.33.0.685.g46640cef36-goog
> > >
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > >
> > > Not directly related to the patch, but the (original) code doesn't
> > > do any sanity checking for the entry address although the PSCI spec says:
> > >
> > > "INVALID_ADDRESS is returned when the entry point address is known
> > > by the implementation to be invalid, because it is in a range that
> > > is known not to be available to the caller."
> >
> > Right, I had noticed the same but was a tad too lazy to address in
> > this series :) Thanks for the review, Reji!
> >
>
> KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
> we need to do is check 'entry_addr < max_ipa', right?
>

We could be a bit more pedantic and check if the IPA exists in a
memory slot, seems like kvm_vcpu_is_visible_gfn() should do the trick.

Thoughts?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
