Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28C9C4740A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 17:36:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28BA12086D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 17:36:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28BA12086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 851794A534;
	Mon,  9 Sep 2019 13:36:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aWQTTUWcB0CA; Mon,  9 Sep 2019 13:36:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29E914A520;
	Mon,  9 Sep 2019 13:36:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B915C4A520
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 13:36:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t0vAqU3hXRE4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 13:36:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C5E54A4CD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 13:36:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66A901000;
 Mon,  9 Sep 2019 10:36:19 -0700 (PDT)
Received: from localhost (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C01DD3F71F;
 Mon,  9 Sep 2019 10:36:18 -0700 (PDT)
Date: Mon, 9 Sep 2019 19:36:16 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 2/2] KVM: arm/arm64: Allow user injection of external
 data aborts
Message-ID: <20190909173616.GA28908@lvm>
References: <20190909121337.27287-1-christoffer.dall@arm.com>
 <20190909121337.27287-3-christoffer.dall@arm.com>
 <CAFEAcA8WcQNJV27q5WJ-SMhOyjFZyh1Pz7H7duK6zW1wiAvqKQ@mail.gmail.com>
 <20190909151631.GA26449@lvm>
 <CAFEAcA-F3YLEQgKAvfbyGGYdzs_wYPz+QMuxk4qZd_oeU-_PBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA-F3YLEQgKAvfbyGGYdzs_wYPz+QMuxk4qZd_oeU-_PBA@mail.gmail.com>
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

On Mon, Sep 09, 2019 at 04:56:23PM +0100, Peter Maydell wrote:
> On Mon, 9 Sep 2019 at 16:16, Christoffer Dall <christoffer.dall@arm.com> wrote:
> >
> > On Mon, Sep 09, 2019 at 01:32:46PM +0100, Peter Maydell wrote:
> > > This API seems to be missing support for userspace to specify
> > > whether the ESR_ELx for the guest should have the EA bit set
> > > (and more generally other syndrome/fault status bits). I think
> > > if we have an API for "KVM_EXIT_MMIO but the access failed"
> > > then it should either (a) be architecture agnostic, since
> > > pretty much any architecture might have a concept of "access
> > > gave some bus-error-type failure" and it would be nice if userspace
> > > didn't have to special case them all in arch-specific code,
> > > or (b) have the same flexibility for specifying exactly what
> > > kind of fault as the architecture does. This sort of seems to
> > > fall between two stools. (My ideal for KVM_EXIT_MMIO faults
> > > would be a generic API which included space for optional
> > > arch-specific info, which for Arm would pretty much just be
> > > the EA bit.)
> >
> > I'm not sure I understand exactly what would be improved by making this
> > either more architecture speific or more architecture generic.  The
> > EA bit will always be set, that's why the field is called
> > 'ext_dabt_pending'.
> 
> ESR_EL1.EA doesn't mean "this is an external abort". It means
> "given that this is an external abort as indicated by ESR_EL1.DFSC,
> specify the external abort type". Traditionally this is 0 for
> an AXI bus Decode error ("interconnect says there's nothing there")
> and 1 for a Slave error ("there's something there but it told us
> to go away"), though architecturally it's specified as impdef
> because not everybody uses AXI. In QEMU we track the difference
> between these two things and for TCG will raise external aborts
> with the correct EA bit value.
> 

Ah, I missed that.  I don't think we want to allow userspace to supply
any implementation defined values for the VM, though.

> > I thought as per the previous discussion, that we were specifically
> > trying to avoid userspace emulating the exception in detail, so I
> > designed this to provide the minimal effort API for userspace.
> >
> > Since we already have an architecture specific ioctl, kvm_vcpu_events, I
> > don't think we're painting ourselves into a corner by using that.  Is a
> > natural consequence of what you're saying not that we should try to make
> > that whole call architecture generic?
> >
> > Unless we already have specific examples of how other architectures
> > would want to use something like this, and given the impact of this
> > patch, I'm not sure it's worth trying to speculate about that.
> 
> In QEMU, use of a generic API would look something like
> this in kvm-all.c:
> 
>         case KVM_EXIT_MMIO:
>             DPRINTF("handle_mmio\n");
>             /* Called outside BQL */
>             MemTxResult res;
> 
>             res = address_space_rw(&address_space_memory,
>                                    run->mmio.phys_addr, attrs,
>                                    run->mmio.data,
>                                    run->mmio.len,
>                                    run->mmio.is_write);
>             if (res != MEMTX_OK) {
>                 /* tell the kernel the access failed, eg
>                  * by updating the kvm_run struct to say so
>                  */
>             } else {
>                 /* access passed, we have updated the kvm_run
>                  * struct's mmio subfield, proceed as usual
>                  */
>             }
>             ret = 0;
>             break;
> 
> [this is exactly the current QEMU code except that today
> we throw away the 'res' that tells us if the transaction
> succeeded because we have no way to report it to KVM and
> effectively always RAZ/WI the access.]
> 
> This is nice because you don't need anything here that has to do
> "bail out to architecture specific handling of anything",
> you just say "nope, the access failed", and let the kernel handle
> that however the CPU would handle it. It just immediately works
> for all architectures on the userspace side (assuming the kernel
> defaults to not actually trying to report an abort to the guest
> if nobody's implemented that on the kernel side, which is exactly
> what happens today where there's no way to report the error for
> any architecture).
> The downside is that you lose the ability to be more specific about
> architecture-specific fine distinctions like decode errors vs slave
> errors, though.

I understand that it's convenient to avoid having to write an
architecture hook, but I simply don't know if it makes sense to do this
on other architectures, and while it can be more code to have to write
the architecture hooks in QEMU, it's hardly a strong argument against
using an existing architecture-specific mechanism to inject an event to
a guest.

Note that I looked at using a an appropriate field in the kvm_run
structure, but nothing elegant came to mind.

Do you have a concrete example of how you would like to change the
kvm_run structure?

> 
> Or you could have an arm-specific API that does care about
> fine details like the EA bit (and maybe also other ESR_ELx
> fields); that has the downside that userspace needs to
> make the handling of error returns from "handle this MMIO
> access" architecture specific, but you get architecture-specific
> benefits as a result. (Preferably the architecture-specific
> APIs should at least be basically the same, eg same ioctl
> or same bit of the kvm_run struct being updated with some parts
> being arch-specific data, rather than 3 different mechanisms.)

Are there other bits of the ESR than the EA that you think we should be
able to specify?

Can we decide if we need to allow userspace to provide additional
information or not, and then decide on the mechanism, instead of
conflating the two questions?

I think we should either expose the minimal mechanism to user space, or
just leave it to user space to emulate the whole thing.


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
