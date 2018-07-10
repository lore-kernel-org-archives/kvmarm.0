From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v2 6/6] KVM: arm/arm64: vgic: Allow configuration of
 interrupt groups
Date: Tue, 10 Jul 2018 16:38:26 +0100
Message-ID: <CAFEAcA9rKb=c3XFN-9a2xjrr3q=AVQ7hA2_dEsG_JGhYuuAn8Q@mail.gmail.com>
References: <1530697100-22419-1-git-send-email-christoffer.dall@arm.com>
 <1530697100-22419-7-git-send-email-christoffer.dall@arm.com>
 <7f875ead-d3cb-1fec-bc84-56e64526e6a7@arm.com>
 <20180709224836.GA26579@u002843.usa.arm.com>
 <f07199bf-9e31-25ad-72d9-27192c27fccd@redhat.com>
 <20180710103223.GE2656@work-vm>
 <20180710152727.GA8890@u002843.usa.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E5EA49F8B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 11:26:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q8ex56Gxdkfv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Jul 2018 11:26:03 -0400 (EDT)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
 [209.85.218.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A320408AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 11:26:03 -0400 (EDT)
Received: by mail-oi0-f67.google.com with SMTP id w126-v6so43432407oie.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Jul 2018 08:38:47 -0700 (PDT)
In-Reply-To: <20180710152727.GA8890@u002843.usa.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 10 July 2018 at 16:27, Christoffer Dall <christoffer.dall@arm.com> wrote:
> Unless someone objects, I'll try to come up with a v3 that asks
> userspace to confirm it wants writable groups.  Ideally I'd like for
> this to happen automatically if userspace writes an IIDR with revision 2
> and above, but that may result in either
>
>   (1) imposing ordering on the restore sequence from userspace;
>       userspace must write IIDR before IGROUPR if it wants non-default
>       groups,
>   (2) terrible sequence of locking and resetting everything if IIDR
>       hasn't been written before time of first executing a VCPU, or
>   (3) an additional bookkeeping flag in the critical path for GICv2
>       which ignores the group unless userspace wrote IIDR.
>
> Out of the three, I think (3) is the least desirable because it
> precludes the guest from programming its own groups.  I'll have a look
> at how (2) looks, because it hides everything, and finally we can fall
> back to (1) and document it clearly.

There are already some ordering restrictions on the restore
sequence for the GICv3, I think (eg there's a comment in QEMU
about having to restore GICR_PROPBASER/PENDBASER before GICR_CTLR),
so (1) isn't the end of the world...

thanks
-- PMM
