Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67170C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 16:10:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB07D61A0A
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 16:10:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB07D61A0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C86F4B090;
	Fri,  1 Oct 2021 12:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WLi7eUWmQABC; Fri,  1 Oct 2021 12:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDFE14B0A3;
	Fri,  1 Oct 2021 12:10:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06E224B090
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 12:10:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GG4vEt0fK9KA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 12:10:27 -0400 (EDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com
 [209.85.167.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 993F04B08A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 12:10:27 -0400 (EDT)
Received: by mail-lf1-f43.google.com with SMTP id i25so40646340lfg.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Oct 2021 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=AOjdVs0gLzgwiu5uLvm60KP3Mb7LDeQaYun407G8UYQ=;
 b=QOQt7xquMrri75hr+imb6/l8b9yxLVWyvzdFTCV3kBQpUZFH76Kl0MhtBP9IRq9Kht
 TfHFJxRAqzYiM//zRd4rKptDVQ0V2Qk5Lq+2+B4RwI4A+AaIiEEJ+9RjQhGHo8ROPpmO
 cp0Rbql5jMhnzgdFrRwGN1azeecrigwFwNlCVMdK+vkWwwqrhpEq8CfgqQkdGclvE9Z9
 QkpqZ3jO0oD7WJOYkrgqOrkrP4rpqmDni8U1zb+rWTz7sy5Ic+y9gppw+9dQFVMfrT7z
 hzLgurXI1N0QRvG1h2+B1qLnU7mD6seEB7cJZwBMW1OPukWuZVh7QbYaqPc1DVSkEClE
 SWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=AOjdVs0gLzgwiu5uLvm60KP3Mb7LDeQaYun407G8UYQ=;
 b=zhalGqLGR07oustKwBvzrJXidmaxG+hb48ESSGUMP6FUoX7gnPeWqwI8F4qaXLZMpM
 8WYfE5ZKMrnYVI6r2qmuu0WsUlFurwFjOu8BrSj5TTSd3YoKB9L6nIuodBxg2FyGPOI4
 M/0l++G7Gj9zlNLqtjiIbU7tb4rX1hpH92dJ+z1MhO1JSDwyDw0CpCz34zFjti01ykyk
 afuK5fp2VN+tWieqJp3Vbavn9q8pUmXlMoVUxyr0ZdnNrDijdlzYhDUx6q7/uS0642OH
 QWVmaIV+MMMeZb6obHxx3oxDuDraTYEIkajLmGOsaQLgdh8CXsT/6KXodra1MitWjo7c
 fvPg==
X-Gm-Message-State: AOAM530kFtuRxbbVhQ4f+O0EUQDl7eTxneeeRKortY8sdjFjflpI4t69
 6B6EppnCrHC61qSzVPLGKw2ajRq1bb3z58SE4qnYRw==
X-Google-Smtp-Source: ABdhPJxmcZrlAnqTaxaqtK7S3tGDT1MORYk1ITq+wYAf6E76frJZ61t721fneGrclV0Yf3qXB9NhlV9UtDXstD5epgI=
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr6360221lfp.685.1633104625244; 
 Fri, 01 Oct 2021 09:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
In-Reply-To: <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
From: Oliver Upton <oupton@google.com>
Date: Fri, 1 Oct 2021 09:10:14 -0700
Message-ID: <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To: Reiji Watanabe <reijiw@google.com>
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

On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> >
> > In its implementation of the PSCI function, KVM needs to request that a
> > target vCPU resets before its next entry into the guest. Wrap the logic
> > for requesting a reset in a function for later use by other implemented
> > PSCI calls.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> >  1 file changed, 35 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index 310b9cb2b32b..bb59b692998b 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> >         return !(affinity & ~MPIDR_HWID_BITMASK);
> >  }
> >
> > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > +                                       unsigned long entry_addr,
> > +                                       unsigned long context_id,
> > +                                       bool big_endian)
> >  {
> >         struct vcpu_reset_state *reset_state;
> > +
> > +       lockdep_assert_held(&vcpu->kvm->lock);
> > +
> > +       reset_state = &vcpu->arch.reset_state;
> > +       reset_state->pc = entry_addr;
> > +
> > +       /* Propagate caller endianness */
> > +       reset_state->be = big_endian;
> > +
> > +       /*
> > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > +        * the general purpose registers are undefined upon CPU_ON.
> > +        */
> > +       reset_state->r0 = context_id;
> > +
> > +       WRITE_ONCE(reset_state->reset, true);
> > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > +
> > +       /*
> > +        * Make sure the reset request is observed if the change to
> > +        * power_state is observed.
> > +        */
> > +       smp_wmb();
> > +       vcpu->arch.power_off = false;
> > +}
> > +
> > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > +{
> >         struct kvm *kvm = source_vcpu->kvm;
> >         struct kvm_vcpu *vcpu = NULL;
> >         unsigned long cpu_id;
> > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >                         return PSCI_RET_INVALID_PARAMS;
> >         }
> >
> > -       reset_state = &vcpu->arch.reset_state;
> > -
> > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > -
> > -       /* Propagate caller endianness */
> > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > -
> > -       /*
> > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > -        * the general purpose registers are undefined upon CPU_ON.
> > -        */
> > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > -
> > -       WRITE_ONCE(reset_state->reset, true);
> > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > -
> > -       /*
> > -        * Make sure the reset request is observed if the change to
> > -        * power_state is observed.
> > -        */
> > -       smp_wmb();
> > -
> > -       vcpu->arch.power_off = false;
> > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > +                                   smccc_get_arg3(source_vcpu),
> > +                                   kvm_vcpu_is_be(source_vcpu));
> >         kvm_vcpu_wake_up(vcpu);
> >
> >         return PSCI_RET_SUCCESS;
> > --
> > 2.33.0.685.g46640cef36-goog
>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>
> Not directly related to the patch, but the (original) code doesn't
> do any sanity checking for the entry address although the PSCI spec says:
>
> "INVALID_ADDRESS is returned when the entry point address is known
> by the implementation to be invalid, because it is in a range that
> is known not to be available to the caller."

Right, I had noticed the same but was a tad too lazy to address in
this series :) Thanks for the review, Reji!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
