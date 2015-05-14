From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 14:00:39 +0200
Message-ID: <20150514120039.GU32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
 <20150514113634.GS32765@cbox> <5554893E.4030105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A6E251494
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:51:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GsMopF47eCq1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 07:51:21 -0400 (EDT)
Received: from mail-la0-f50.google.com (mail-la0-f50.google.com
 [209.85.215.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FB1751492
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 07:51:20 -0400 (EDT)
Received: by layy10 with SMTP id y10so63958066lay.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 05:00:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <5554893E.4030105@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 01:38:38PM +0200, Paolo Bonzini wrote:
> 
> 
> On 14/05/2015 13:36, Christoffer Dall wrote:
> > > > > (It's probably worth looking at the documentation in the first hunk too,
> > > > > under the commit message.)
> > > > 
> > > > Why is this a hack/unintuitive?  Is the semantics of the QEMU PCI bus
> > > > not simply that MMIO regions are coherent?
> > > 
> > > Only until device assignment gets into the picture.
> > 
> > Will UEFI have to deal with device assignment in any respect?
> 
> Why not?  For example you could do network boot from an assigned network
> card.
> 
> In fact, anything that UEFI has to deal with, the OS has to deal with
> too.  If you need a UEFI hack, chances are you need or will need a Linux
> hack too.
> 
Fair enough.  I was thinking that UEFI needs to be built with knowledge
of all the hardware present including any passthrough devices, but I
guess this is plainly not true with PCI (and might not even be true with
the level of DT parsing we do for the virtual platform).

So, getting back to my original question.  Is the point then that UEFI
must assume (from ACPI/DT) the cache-coherency properties of the PCI
controller which exists in hardware on the system you're running on,
even for the virtual PCI bus because that will be the semantics for
assigned devices?

And in that case, we have no way to distinguish between passthrough
devices and virtual devices plugged into the virtual PCI bus?

What about the idea of having two virtual PCI buses on your system where
one is always cache-coherent and uses for virtual devices, and the other
is whatever the hardware is and used for passthrough devices?

-Christoffer
