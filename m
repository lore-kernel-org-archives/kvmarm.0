Return-Path: <SRS0=xqRQ=MZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56526C432BE
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 23:28:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD0E060EE6
	for <kvmarm@archiver.kernel.org>; Mon,  2 Aug 2021 23:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD0E060EE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36CB940C88;
	Mon,  2 Aug 2021 19:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wfbUgYAvy2wJ; Mon,  2 Aug 2021 19:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEB51407D1;
	Mon,  2 Aug 2021 19:28:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C2340463
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 19:28:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K5yMsnq5HHuB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Aug 2021 19:28:11 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32DB7402BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Aug 2021 19:28:11 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id x7so25961442ljn.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Aug 2021 16:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=J9HZ+dRqIjGaHUpE5nN2lo/SuVqbz/56Q93GhSWxRHU=;
 b=f3ulRBAIBoSniofTbVTngfqKcyPVhP5suwWHrT1VOLa5IUa7oaZDDSU1UCNv83pwBE
 lsPAlcmUJkJczrayqXzvYqg8mar0U+oKeYEBdagjvUHxFyRZESgQbkjUVetXdgFZIPL/
 8vpYfIz+pZQjQDijDsbLshqY+5eyeFNoaUMiCzUwVyLCg8xXLVUtHdEPuDpttN0oREdc
 VlSECrTomjtYtZ06L6dpF9BN0tR3h0+p4W/M2XOcJOLZIU6NdzjUtbHymwlsqeRxBGus
 GusToQoR7B2uj7do4M5GrfcA/yWnUAEFYpfrDQWW9VmQKVoj4uJOcwv4eyS54g7cjcxj
 gPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=J9HZ+dRqIjGaHUpE5nN2lo/SuVqbz/56Q93GhSWxRHU=;
 b=jjW5G4jcwszDrpt3frsuGlq/gIFCmDLDnHBmXoLgV07WpLovydvNjAnG46rKW94IQ2
 N41i+k7wPdPNw8zIp0dT26rmCZKeL/+HZNVBSQvNPXPDFRpq7uNkXtbbB5GZKAi83+Cp
 njctXayvL7pxWXFp60/wt+19gZZwthFKZFDpn0s7QgRMf3Qo0uWPxjXLv4dni9cKDywk
 xkampCP/P2t6NFJiV6D+4aUZnys1v3CtxrJRmu3qvP5zejT3DrFryz+RMpeqc48eBnFZ
 HXJWwYEXA3S49aUsou3+RP8yIODYFfxSBPJ5dE9bs9WHO0Z9Zaj9euFyziXOtD1b74Wj
 VOAg==
X-Gm-Message-State: AOAM532o4C3gNZvo4IYaLrzjnaPua5af1Mopead/8u9oxsOC0ItzIHZi
 LddphHJWm3G4KBw2/kSSzNcYitBluTK80l/lrzVntA==
X-Google-Smtp-Source: ABdhPJx4PMflNKq4l++/Ia5h4WkHkX05BnmK2AolU5x1FQ8DXEXIM1Eagkz5xAjX4eGnRjHffPcUhFrmG57FcQFcx8I=
X-Received: by 2002:a2e:535c:: with SMTP id t28mr12614273ljd.129.1627946888933; 
 Mon, 02 Aug 2021 16:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
 <20210729173300.181775-10-oupton@google.com>
 <877dh82jrh.wl-maz@kernel.org>
In-Reply-To: <877dh82jrh.wl-maz@kernel.org>
From: Oliver Upton <oupton@google.com>
Date: Mon, 2 Aug 2021 16:27:57 -0700
Message-ID: <CAOQ_QsiLLUgPYO4q3kn1mApTMysCO=5U9g0h3Xqu8a11bpbAJA@mail.gmail.com>
Subject: Re: [PATCH v5 09/13] KVM: arm64: Allow userspace to configure a
 vCPU's virtual offset
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Peter Shier <pshier@google.com>, Raghavendra Rao Anata <rananta@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Jul 30, 2021 at 3:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 29 Jul 2021 18:32:56 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Add a new vCPU attribute that allows userspace to directly manipulate
> > the virtual counter-timer offset. Exposing such an interface allows for
> > the precise migration of guest virtual counter-timers, as it is an
> > indepotent interface.
> >
> > Uphold the existing behavior of writes to CNTVOFF_EL2 for this new
> > interface, wherein a write to a single vCPU is broadcasted to all vCPUs
> > within a VM.
> >
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  Documentation/virt/kvm/devices/vcpu.rst | 22 ++++++++
> >  arch/arm64/include/uapi/asm/kvm.h       |  1 +
> >  arch/arm64/kvm/arch_timer.c             | 68 ++++++++++++++++++++++++-
> >  3 files changed, 89 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> > index 0f46f2588905..ecbab7adc602 100644
> > --- a/Documentation/virt/kvm/devices/vcpu.rst
> > +++ b/Documentation/virt/kvm/devices/vcpu.rst
> > @@ -139,6 +139,28 @@ configured values on other VCPUs.  Userspace should configure the interrupt
> >  numbers on at least one VCPU after creating all VCPUs and before running any
> >  VCPUs.
> >
> > +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
> > +------------------------------------------------
> > +
> > +:Parameters: Pointer to a 64-bit unsigned counter-timer offset.
> > +
> > +Returns:
> > +
> > +      ======= ======================================
> > +      -EFAULT Error reading/writing the provided
> > +              parameter address
> > +      -ENXIO  Attribute not supported
> > +      ======= ======================================
> > +
> > +Specifies the guest's virtual counter-timer offset from the host's
> > +virtual counter. The guest's virtual counter is then derived by
> > +the following equation:
> > +
> > +  guest_cntvct = host_cntvct - KVM_ARM_VCPU_TIMER_OFFSET_VTIMER
>
> I still have a problem with this, specially as you later introduce a
> physical timer offset. My gut feeling is that the virtual offset
> should be relative to the physical counter *of the guest*, and not
> that of the host. The physical offset should be the only one that is
> relative to the host. Anything else should be deriving from it.
>
> If you don't set the ptimer offset, then the two definitions are
> strictly identical. It will also match the definition of a
> userspace-visible CNTVOFF_EL2 with NV, which is strictly relative to
> the guest view of the physical counter.

Yeah, this sounds good to me. I very much like the idea of maintaining
exactly one offset from the host to the guest. So long as users are
fine with paying the cost of an emulated physical counter-timer on
non-ECV hosts. That said, a non-NV guest shouldn't be using the
physical counter in the first place..

>
> > +
> > +KVM does not allow the use of varying offset values for different vCPUs;
> > +the last written offset value will be broadcasted to all vCPUs in a VM.
> > +
>
> Please document the effects of this attribute w.r.t. writing
> CNTVCT_EL0 from userspace.
>

Good idea.

> > -int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > +     u64 offset;
> > +
> > +     if (get_user(offset, uaddr))
> > +             return -EFAULT;
> > +
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             update_vtimer_cntvoff(vcpu, offset);
>
> Probably not a good idea if the timer is already enabled on any of the
> CPUs (we probably already have that problem, so let's fix it once and
> for all).

hmm... would this cause any issues to enforce ordering on an existing
UAPI? If I understand the suggestion correctly, we will refuse to
write the counter offset for a VM with an active timer.

If that is the case, then when we migrate a guest the VMM would have
to be very deliberate about the order in which it restores registers,
no?

> > +int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> > +     struct arch_timer_context *timer;
> > +     u64 offset;
> > +
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             timer = vcpu_vtimer(vcpu);
> > +             break;
> > +     default:
> > +             return -ENXIO;
>
> What is the rational for retrieving this offset the first place? I
> don't dislike the symmetry, but we already have an architectural way
> of getting it (read the counter registers).

I don't believe this is necessary any more.

The reason that I had exposed the virtual counter offset as a device
attribute was to separate VMM and guest manipulation of the virtual
counter. A VMM migrating an EL2 guest would likely want to adjust the
vtimer according to the difference in virtual counters between two
hosts without changing any guest-visible sysregs. However, if we go
with your suggestion above, the hypervisor would only ever need to
poke a physical offset attribute to make transparent changes to *both*
counters.

So, I suppose this is what I'm proposing: treat VMM writes to
CNTVOFF_EL2 the same as guest writes. For CNTPOFF_EL2, we do a special
dance; guest writes to CNTPOFF_EL2 will be visible in the register
_and_ change the value KVM writes to CNTPOFF_EL2 in hardware. Host
writes to a physical offset device attribute will cause KVM to change
the hardware value of CNTPOFF_EL2, but not update the guest-visible
register value. This way, a guest can be transparently migrated
between hosts with different counters.

>
> > +     }
> > +
> > +     offset = timer_get_offset(timer);
> > +     return put_user(offset, uaddr);
> > +}
> > +
> > +int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> > +{
> > +     switch (attr->attr) {
> > +     case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> > +     case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > +             return kvm_arm_timer_get_attr_irq(vcpu, attr);
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> > +             return kvm_arm_timer_get_attr_offset(vcpu, attr);
> > +     }
> > +
> > +     return -ENXIO;
> > +}
> > +
> >  int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >  {
> >       switch (attr->attr) {
> >       case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
> >       case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
> > +     case KVM_ARM_VCPU_TIMER_OFFSET_VTIMER:
> >               return 0;
> >       }
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
