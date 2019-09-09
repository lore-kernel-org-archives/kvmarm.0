Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C97C4740C
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 15:16:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE0762196E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 15:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE0762196E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C464A4F7;
	Mon,  9 Sep 2019 11:16:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yGptsfUlKajw; Mon,  9 Sep 2019 11:16:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E9554A52D;
	Mon,  9 Sep 2019 11:16:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA7F4A52D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 11:16:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wBOv0Vfzpewt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 11:16:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0AF34A4F7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 11:16:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A152169E;
 Mon,  9 Sep 2019 08:16:34 -0700 (PDT)
Received: from localhost (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 978C43F59C;
 Mon,  9 Sep 2019 08:16:33 -0700 (PDT)
Date: Mon, 9 Sep 2019 17:16:31 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Allow user injection of external
 data aborts
Message-ID: <20190909151631.GA26449@lvm>
References: <20190909121337.27287-1-christoffer.dall@arm.com>
 <20190909121337.27287-3-christoffer.dall@arm.com>
 <CAFEAcA8WcQNJV27q5WJ-SMhOyjFZyh1Pz7H7duK6zW1wiAvqKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA8WcQNJV27q5WJ-SMhOyjFZyh1Pz7H7duK6zW1wiAvqKQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Mon, Sep 09, 2019 at 01:32:46PM +0100, Peter Maydell wrote:
> On Mon, 9 Sep 2019 at 13:13, Christoffer Dall <christoffer.dall@arm.com> wrote:
> >
> > In some scenarios, such as buggy guest or incorrect configuration of the
> > VMM and firmware description data, userspace will detect a memory access
> > to a portion of the IPA, which is not mapped to any MMIO region.
> >
> > For this purpose, the appropriate action is to inject an external abort
> > to the guest.  The kernel already has functionality to inject an
> > external abort, but we need to wire up a signal from user space that
> > lets user space tell the kernel to do this.
> >
> > It turns out, we already have the set event functionality which we can
> > perfectly reuse for this.
> >
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  Documentation/virt/kvm/api.txt    | 15 ++++++++++++++-
> >  arch/arm/include/uapi/asm/kvm.h   |  3 ++-
> >  arch/arm/kvm/guest.c              |  3 +++
> >  arch/arm64/include/uapi/asm/kvm.h |  3 ++-
> >  arch/arm64/kvm/guest.c            |  3 +++
> >  arch/arm64/kvm/inject_fault.c     |  4 ++--
> >  include/uapi/linux/kvm.h          |  1 +
> >  virt/kvm/arm/arm.c                |  1 +
> >  8 files changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index 02501333f746..edd6cdc470ca 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -955,6 +955,8 @@ The following bits are defined in the flags field:
> >
> >  ARM/ARM64:
> >
> > +User space may need to inject several types of events to the guest.
> > +
> >  If the guest accesses a device that is being emulated by the host kernel in
> >  such a way that a real device would generate a physical SError, KVM may make
> >  a virtual SError pending for that VCPU. This system error interrupt remains
> > @@ -989,12 +991,23 @@ Specifying exception.has_esr on a system that does not support it will return
> >  -EINVAL. Setting anything other than the lower 24bits of exception.serror_esr
> >  will return -EINVAL.
> >
> > +If the guest performed an access to I/O memory which could not be handled by
> > +user space, for example because of missing instruction syndrome decode
> > +information or because there is no device mapped at the accessed IPA, then
> > +user space can ask the kernel to inject an external abort using the address
> > +from the exiting fault on the VCPU. It is a programming error to set
> > +ext_dabt_pending at the same time as any of the serror fields, or to set
> > +ext_dabt_pending on an exit which was not either KVM_EXIT_MMIO or
> > +KVM_EXIT_ARM_NISV. This feature is only available if the system supports
> > +KVM_CAP_ARM_INJECT_EXT_DABT;
> > +
> >  struct kvm_vcpu_events {
> >         struct {
> >                 __u8 serror_pending;
> >                 __u8 serror_has_esr;
> > +               __u8 ext_dabt_pending;
> >                 /* Align it to 8 bytes */
> > -               __u8 pad[6];
> > +               __u8 pad[5];
> >                 __u64 serror_esr;
> >         } exception;
> >         __u32 reserved[12];
> 
> This API seems to be missing support for userspace to specify
> whether the ESR_ELx for the guest should have the EA bit set
> (and more generally other syndrome/fault status bits). I think
> if we have an API for "KVM_EXIT_MMIO but the access failed"
> then it should either (a) be architecture agnostic, since
> pretty much any architecture might have a concept of "access
> gave some bus-error-type failure" and it would be nice if userspace
> didn't have to special case them all in arch-specific code,
> or (b) have the same flexibility for specifying exactly what
> kind of fault as the architecture does. This sort of seems to
> fall between two stools. (My ideal for KVM_EXIT_MMIO faults
> would be a generic API which included space for optional
> arch-specific info, which for Arm would pretty much just be
> the EA bit.)

I'm not sure I understand exactly what would be improved by making this
either more architecture speific or more architecture generic.  The
EA bit will always be set, that's why the field is called
'ext_dabt_pending'.

I thought as per the previous discussion, that we were specifically
trying to avoid userspace emulating the exception in detail, so I
designed this to provide the minimal effort API for userspace.

Since we already have an architecture specific ioctl, kvm_vcpu_events, I
don't think we're painting ourselves into a corner by using that.  Is a
natural consequence of what you're saying not that we should try to make
that whole call architecture generic?

Unless we already have specific examples of how other architectures
would want to use something like this, and given the impact of this
patch, I'm not sure it's worth trying to speculate about that.

> 
> As and when we support nested virtualization, any suggestions
> on how this API would extend to support userspace saying
> "deliver fault to guest EL1" vs "deliver fault to guest EL2" ?
> 

If we took one of the supported exits from a VM with nested virt
support, it means that you either had a fault from the guest hypervisor,
or a fault from a nested guest where the guest hypervisor has set up a
virtual stage 2 mapping to a hole in the VM's IPA space.  In the former
case, the exception would be delivered back to guest hypervisor, and in
the latter case the target depends on the guest hypervisor's
configuration of the virtual HCR_EL2(.TEA), which the kernel should
respect when handling the KVM_SET_VCPU_EVENTS ioctl.


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
