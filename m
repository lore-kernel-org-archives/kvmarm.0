Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC703C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 19:02:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30D5761354
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 19:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 30D5761354
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C6C44B2E0;
	Tue,  5 Oct 2021 15:02:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yr5nHlwDzgsM; Tue,  5 Oct 2021 15:02:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2784B2A5;
	Tue,  5 Oct 2021 15:02:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6694A4B297
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 15:01:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6IZ9oOzc5o5L for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 15:01:58 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7F74B288
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 15:01:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633460518;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=pks3z+IN34uKEcJiugoE2qCaJ8Ch2RkxBo7zygTxWDE=;
 b=bYt0Bui4c5KWz9uuEG3Pd8UxPAmLzmKq5TaysP1uJGv6vtTmPB0/8+J+5ei9WIO6LOYie3
 dMp8kdktpv3iSyYE6tvdp5GqI92wxW16s5yt0ASawMGOMbFPhhxYO/3OwHVpfqiTcQJ8fW
 nsBEFGLG71Ken2a4/dHffACrXQz7GTU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-xET9OqhuNpKTMZQyZ9My3w-1; Tue, 05 Oct 2021 15:01:57 -0400
X-MC-Unique: xET9OqhuNpKTMZQyZ9My3w-1
Received: by mail-ed1-f72.google.com with SMTP id
 r11-20020aa7cfcb000000b003d4fbd652b9so146623edy.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 12:01:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=pks3z+IN34uKEcJiugoE2qCaJ8Ch2RkxBo7zygTxWDE=;
 b=BdizEnULfUGfVv4cqd/wacNe5P+8qOXjk4pspB3hE3U/aSGusfsrReLOecvlNpEkg/
 UHkcQ9U5Ks1F4TOj93+XPF+HDDnG9eBHymL+4hbiMEFGfPpaRfyL1oIzIB3c2KZIJ17w
 MTXFk14kCmjn5JDYNHIofO0JQvp00NhVfkjKbb+iaVzAm+IApBhg1DR+IrOjOYtgZk7x
 Pg7nig6WfziXziu8x6fcyM257TYXvw9chW4tDeNYyRycNsHpcLGLKEHTNlJWw60w6EEj
 T51wAug9zSngQyB5Y4oCu0rpBoYxuShEavvIduml2bjMHw8e+gLvSH2vpBfLBBVspSz9
 o41Q==
X-Gm-Message-State: AOAM531Tb0rKeAb1aBn+uOaD53rZFKbeBRlwkrJDbU4KgbIdiuOAA2IU
 AkVmAqta7fwpfan+2eeixEzJgxgH7i8wWpkTrUCY8gEjM9ssXxBfOd8ixeDqAKbHN3iCpyUA+YJ
 HLTjH4VpOHn2UDtJq2YwxHmZn
X-Received: by 2002:a50:a402:: with SMTP id u2mr7001814edb.164.1633460515756; 
 Tue, 05 Oct 2021 12:01:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwONHgv+rzWdOUDOp3pb03VLVgZb0u2aMFk5wZLbXeJGvkerMM7eHV4Ej3ChBcS+hGx+yWW0Q==
X-Received: by 2002:a50:a402:: with SMTP id u2mr7001789edb.164.1633460515538; 
 Tue, 05 Oct 2021 12:01:55 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id 21sm7981028ejv.54.2021.10.05.12.01.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Oct 2021 12:01:54 -0700 (PDT)
Date: Tue, 5 Oct 2021 21:01:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in
 a helper function
Message-ID: <20211005190153.dc2befzcisvznxq5@gator.home>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-4-oupton@google.com>
 <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
 <CAOQ_QshHDWWEw5BEu-uudFttP1pfJcKuQ-0D_xAkoHJRqYLq8Q@mail.gmail.com>
 <20211005133335.y4k5qv7d3g74nnzx@gator.home>
 <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsgwK=qyeaUtNJeZ1OWQwaFUAQcy6uopnDuyDA3Qyt7gmw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Tue, Oct 05, 2021 at 08:05:02AM -0700, Oliver Upton wrote:
> Hi folks,
> 
> On Tue, Oct 5, 2021 at 6:33 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Oct 01, 2021 at 09:10:14AM -0700, Oliver Upton wrote:
> > > On Thu, Sep 30, 2021 at 11:05 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
> > > > >
> > > > > In its implementation of the PSCI function, KVM needs to request that a
> > > > > target vCPU resets before its next entry into the guest. Wrap the logic
> > > > > for requesting a reset in a function for later use by other implemented
> > > > > PSCI calls.
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
> > > > >  1 file changed, 35 insertions(+), 24 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > > > > index 310b9cb2b32b..bb59b692998b 100644
> > > > > --- a/arch/arm64/kvm/psci.c
> > > > > +++ b/arch/arm64/kvm/psci.c
> > > > > @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
> > > > >         return !(affinity & ~MPIDR_HWID_BITMASK);
> > > > >  }
> > > > >
> > > > > -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> > > > > +                                       unsigned long entry_addr,
> > > > > +                                       unsigned long context_id,
> > > > > +                                       bool big_endian)
> > > > >  {
> > > > >         struct vcpu_reset_state *reset_state;
> > > > > +
> > > > > +       lockdep_assert_held(&vcpu->kvm->lock);
> > > > > +
> > > > > +       reset_state = &vcpu->arch.reset_state;
> > > > > +       reset_state->pc = entry_addr;
> > > > > +
> > > > > +       /* Propagate caller endianness */
> > > > > +       reset_state->be = big_endian;
> > > > > +
> > > > > +       /*
> > > > > +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > +        * the general purpose registers are undefined upon CPU_ON.
> > > > > +        */
> > > > > +       reset_state->r0 = context_id;
> > > > > +
> > > > > +       WRITE_ONCE(reset_state->reset, true);
> > > > > +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > +
> > > > > +       /*
> > > > > +        * Make sure the reset request is observed if the change to
> > > > > +        * power_state is observed.
> > > > > +        */
> > > > > +       smp_wmb();
> > > > > +       vcpu->arch.power_off = false;
> > > > > +}
> > > > > +
> > > > > +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > > +{
> > > > >         struct kvm *kvm = source_vcpu->kvm;
> > > > >         struct kvm_vcpu *vcpu = NULL;
> > > > >         unsigned long cpu_id;
> > > > > @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> > > > >                         return PSCI_RET_INVALID_PARAMS;
> > > > >         }
> > > > >
> > > > > -       reset_state = &vcpu->arch.reset_state;
> > > > > -
> > > > > -       reset_state->pc = smccc_get_arg2(source_vcpu);
> > > > > -
> > > > > -       /* Propagate caller endianness */
> > > > > -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> > > > > -
> > > > > -       /*
> > > > > -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> > > > > -        * the general purpose registers are undefined upon CPU_ON.
> > > > > -        */
> > > > > -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> > > > > -
> > > > > -       WRITE_ONCE(reset_state->reset, true);
> > > > > -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> > > > > -
> > > > > -       /*
> > > > > -        * Make sure the reset request is observed if the change to
> > > > > -        * power_state is observed.
> > > > > -        */
> > > > > -       smp_wmb();
> > > > > -
> > > > > -       vcpu->arch.power_off = false;
> > > > > +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> > > > > +                                   smccc_get_arg3(source_vcpu),
> > > > > +                                   kvm_vcpu_is_be(source_vcpu));
> > > > >         kvm_vcpu_wake_up(vcpu);
> > > > >
> > > > >         return PSCI_RET_SUCCESS;
> > > > > --
> > > > > 2.33.0.685.g46640cef36-goog
> > > >
> > > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > > >
> > > > Not directly related to the patch, but the (original) code doesn't
> > > > do any sanity checking for the entry address although the PSCI spec says:
> > > >
> > > > "INVALID_ADDRESS is returned when the entry point address is known
> > > > by the implementation to be invalid, because it is in a range that
> > > > is known not to be available to the caller."
> > >
> > > Right, I had noticed the same but was a tad too lazy to address in
> > > this series :) Thanks for the review, Reji!
> > >
> >
> > KVM doesn't reserve any subrange within [0 - max_ipa), afaik. So all
> > we need to do is check 'entry_addr < max_ipa', right?
> >
> 
> We could be a bit more pedantic and check if the IPA exists in a
> memory slot, seems like kvm_vcpu_is_visible_gfn() should do the trick.
> 
> Thoughts?

Are we sure that all emulated devices, nvram, etc. will always use a
memslot for regions that contain executable code? If there's any doubt,
then we can't be sure about non-memslot regions within the max_ipa range.
That'd be up to userspace.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
