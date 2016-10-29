From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Sat, 29 Oct 2016 09:19:01 -0400 (EDT)
Message-ID: <1154342410.9324183.1477747141878.JavaMail.zimbra@redhat.com>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
 <3e85d538-2539-f190-0d17-a2ecfe7b48ce@suse.de> <20160930154335.GB7996@cbox>
 <71b0ae9d-baea-1f65-3c01-5d87f4f4746f@suse.de>
 <3928feee-cb23-8635-20bd-4c068b649a1d@arm.com>
 <7500DEDE-EC21-4287-9B11-04C058A48747@suse.de>
 <56812724-4bac-8265-b6f6-b1ff00308ec0@arm.com>
 <554F7514-1900-41B4-8DDC-36C00B903164@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EA1740430
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 09:19:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o94lOE0y1H9c for <kvmarm@lists.cs.columbia.edu>;
 Sat, 29 Oct 2016 09:19:00 -0400 (EDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCB9D402EC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 29 Oct 2016 09:19:00 -0400 (EDT)
In-Reply-To: <554F7514-1900-41B4-8DDC-36C00B903164@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

> > > > What the status of userspace for this thing? Are QEMU patches being
> > > > posted and reviewed?
> > > 
> > > I didn't see a notification that the patches were merged. Are they in
> > > Linus' tree yet? Then I can post enablement to qemu-devel.
> > 
> > I think you got it backward. I have no intention of merging them until I
> > see a vague consensus on the userspace API, and a set of patches ready
> > to be merged in QEMU.
> 
> That's not how kvm apis are made.

Actually I think it's always been like this, depending on what Marc meant for
"ready to be merged in QEMU".  It doesn't make sense to merge KVM APIs without
having userspace patches at least posted as RFC to qemu-devel, and without
having at least a positive response from the QEMU architecture maintainer.
ARM does require a bit more care because there's no overlap between kernel
and userspace maintainers, so perhaps that's the source of the confusion?

Now, of course merging the patches in QEMU may take a month or two depending
on the timing (because you have to wait for the patches to be merged into
Linus's tree and for the KVM headers to be updated in QEMU---which is not
going to happen during freeze of course).  So of course the KVM patch thus
can be committed even if QEMU is in freeze, as long as the QEMU architecture
maintainer gives an overall green light.

In fact a couple weeks from now would be the perfect time to post the patches
to QEMU.  Then you can get a review from Peter once he's back from vacation
(beginning of December), the KVM patches can easily make it for the 4.10 merge
window (end of December), and the userspace patches will hopefully be merged in
QEMU 2.9 in January 2017.

Thanks,

Paolo
