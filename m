Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0565DC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 04:48:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70B8860FDA
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 04:48:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 70B8860FDA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FA14B0E1;
	Wed, 13 Oct 2021 00:48:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oSmSSHvorpmC; Wed, 13 Oct 2021 00:48:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F7B4B0EF;
	Wed, 13 Oct 2021 00:48:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA0D84B0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 00:48:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LzBlODKotx5d for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 00:48:30 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 610204B0CE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 00:48:30 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id k23so1286638pji.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 21:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6UiNjqdn6cQd+ZVgitW5U2ThWAYr+h/7ydwszKNRfeQ=;
 b=nzwS/la0l10TdQDUpS6EfK4tSOxmnO6gZczOW3XJ5ZU1nIPUAxwDNnB2z9hTGuVAMd
 mgb1tQ19a6Q+2r5XVqtEliz2FNtZ0rqo+33A4Ivl95sb7AGy+SkTWs65NeWFnsFeMGwQ
 Gm+fc045nNg6NXAFk81MgVtH5UXeBCqAChSCDJ7lgTot5LlSBW+ltZlSzumx/ddgxa00
 WETV2eyglYrzjiruF6nPlraZeEumFm71fFy7p4X0qJiFUwjZi6k+fsDlxaW6m5bVCs7Q
 uUOYlSZB4EzY6iUs0q82EBZOJP/57C1a05fC+DqTMLuOaApLNQJcSnSdg/hb/YuIyv7x
 7oYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6UiNjqdn6cQd+ZVgitW5U2ThWAYr+h/7ydwszKNRfeQ=;
 b=DW6Y+Qw3QbAb76u8qwiaqzYffVKa5pIIRkl1csBYuU2tyQJyTA+MhIxTN13wEYYU5q
 bdijYK7bR+y637t2dGEFWK56tJi9mUaWHjsPkm2g+faoIsOOCY1a2ukjIlhmOkR66hQz
 gL/ItzBs/b8uB6krTsqIHxL9TPUn9HGy8ksm7DIGfds50I4Rn0daqXc/IdS71oeW5MOD
 3leYvfrtYzJAhDYSo49yooCwvcltiz8LwR+9jjWgBlcXRaQiwVBudr0BbSkeQ6IUhYNz
 B4oWoIY4qC/I40x/2/6Tx0jbIPpP4Mp3yR5jTR7p2g5gphap/952bks0Omx0Y0x+75FS
 19MQ==
X-Gm-Message-State: AOAM530F4WzIpnIqeQSUygXYRmNyBbE+8ZliTgK6TBDFanC/yEsyJLS6
 4brh8Ue0ageY1rFAVesQuoFWHn1n15+v9Aa/cwRSFA==
X-Google-Smtp-Source: ABdhPJzQV44ZsRub96kp2SNXYmhtc2cOENMwhtRPwrRAakcpX1FISHL38AgFunXCxStCzrda6gvZVrPojmYrDWvjo7Y=
X-Received: by 2002:a17:90b:38c3:: with SMTP id
 nn3mr11214221pjb.110.1634100509147; 
 Tue, 12 Oct 2021 21:48:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
 <20211005133335.y4k5qv7d3g74nnzx@gator.home>
 <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
 <20211005190153.dc2befzcisvznxq5@gator.home>
In-Reply-To: <20211005190153.dc2befzcisvznxq5@gator.home>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 12 Oct 2021 21:48:13 -0700
Message-ID: <CAAeT=FyA8uFK5WyK-_9-V93TzSLEhgmS6nRDg-i=ot1jLy+6bA@mail.gmail.com>
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

On Tue, Oct 5, 2021 at 12:02 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Tue, Oct 05, 2021 at 08:05:02AM -0700, Oliver Upton wrote:
> > Hi folks,
> >
> > On Tue, Oct 5, 2021 at 6:33 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> > > > On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > >
> > > > > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > > > > >
> > > > > > In its implementation of the PSCI function, KVM needs to request that a
> > > > > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > > > > for requesting a reset in a function for later use by other implemented
> > > > > > PSCI calls.
> > > > > >
> > > > > > No functional change intended.
> > > > > >
> > > > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > > > ---
> > > > > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > > > > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > > > index 310b9cb2b32b..bb59b692998b 100644
> > > > > > --- a/arch/arm64/kvm/psci.c
> > > > > > +++ b/arch/arm64/kvm/psci.c
> > > > > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > > > > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > > > > >  }
> > > > > >
> > > > > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > > > > +                                       unsigned long entry_addr,
> > > > > > +                                       unsigned long context_id,
> > > > > > +                                       bool big_endian)
> > > > > >  {
> > > > > >         struct vcpu_reset_state *reset_state;
> > > > > > +
> > > > > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > > > > +
> > > > > > +       reset_state = &vcpu->arch.reset_state;
> > > > > > +       reset_state->pc = entry_addr;
> > > > > > +
> > > > > > +       /* Propagate caller endianness */
> > > > > > +       reset_state->be = big_endian;
> > > > > > +
> > > > > > +       /*
> > > > > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > > +        * the general purpose registers are undefined upon CPU_ON.
> > > > > > +        */
> > > > > > +       reset_state->r0 = context_id;
> > > > > > +
> > > > > > +       WRITE_ONCE(reset_state->reset, true);
> > > > > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > > +
> > > > > > +       /*
> > > > > > +        * Make sure the reset request is observed if the change to
> > > > > > +        * power_state is observed.
> > > > > > +        */
> > > > > > +       smp_wmb();
> > > > > > +       vcpu->arch.power_off = false;
> > > > > > +}
> > > > > > +
> > > > > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > > +{
> > > > > >         struct kvm *kvm = source_vcpu->kvm;
> > > > > >         struct kvm_vcpu *vcpu = NULL;
> > > > > >         unsigned long cpu_id;
> > > > > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > >                         return PSCI_RET_INVALID_PARAMS;
> > > > > >         }
> > > > > >
> > > > > > -       reset_state = &vcpu->arch.reset_state;
> > > > > > -
> > > > > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > > > > -
> > > > > > -       /* Propagate caller endianness */
> > > > > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > > > > -
> > > > > > -       /*
> > > > > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > > -        * the general purpose registers are undefined upon CPU_ON.
> > > > > > -        */
> > > > > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > > > > -
> > > > > > -       WRITE_ONCE(reset_state->reset, true);
> > > > > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > > -
> > > > > > -       /*
> > > > > > -        * Make sure the reset request is observed if the change to
> > > > > > -        * power_state is observed.
> > > > > > -        */
> > > > > > -       smp_wmb();
> > > > > > -
> > > > > > -       vcpu->arch.power_off = false;
> > > > > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > > > > +                                   smccc_get_arg3(source_vcpu),
> > > > > > +                                   kvm_vcpu_is_be(source_vcpu));
> > > > > >         kvm_vcpu_wake_up(vcpu);
> > > > > >
> > > > > >         return PSCI_RET_SUCCESS;
> > > > > > --
> > > > > > 2.33.0.685.g46640cef36-goog
> > > > >
> > > > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > > >
> > > > > Not directly related to the patch, but the (original) code doesn't
> > > > > do any sanity checking for the entry address although the PSCI spec says:
> > > > >
> > > > > "INVALID_ADDRESS is returned when the entry point address is known
> > > > > by the implementation to be invalid, because it is in a range that
> > > > > is known not to be available to the caller."
> > > >
> > > > Right, I had noticed the same but was a tad too lazy to address in
> > > > this series :) Thanks for the review, Reji!
> > > >
> > >
> > > KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
> > > we need to do is check 'entry_addr < max_ipa', right?
> > >
> >
> > We could be a bit more pedantic and check if the IPA exists in a
> > memory slot, seems like kvm_vcpu_is_visible_gfn() should do the trick.
> >
> > Thoughts?
>
> Are we sure that all emulated devices, nvram, etc. will always use a
> memslot for regions that contain executable code? If there's any doubt,
> then we can't be sure about non-memslot regions within the max_ipa range.
> That'd be up to userspace.

I'm sorry for the late response.
IMHO, I would prefer Andrew's suggestion (check with the max_ipa).

It looks like instructions must always be in memslot for KVM/ARM looking
at the current implementation (especially kvm_handle_guest_abort()).
But, it doesn't necessarily mean the address is not invalid for the
guest (could be valid for load/store) and it might be changed in
the future.


Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
