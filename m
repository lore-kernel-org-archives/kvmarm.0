From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 14:24:13 +0200
Message-ID: <20150514122413.GV32765@cbox>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103018.GM32765@cbox> <5554826E.1040706@redhat.com>
 <20150514112910.GR32765@cbox> <55548777.9000702@redhat.com>
 <20150514113634.GS32765@cbox> <5554893E.4030105@redhat.com>
 <20150514120039.GU32765@cbox> <55549051.1090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 645C4514A3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:14:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QdpeKFZog6-S for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 08:14:55 -0400 (EDT)
Received: from mail-la0-f45.google.com (mail-la0-f45.google.com
 [209.85.215.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 192AD514A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:14:54 -0400 (EDT)
Received: by labbd9 with SMTP id bd9so64853193lab.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 05:24:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55549051.1090007@redhat.com>
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
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, Laszlo Ersek <lersek@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 02:08:49PM +0200, Paolo Bonzini wrote:
> 
> 
> On 14/05/2015 14:00, Christoffer Dall wrote:
> > So, getting back to my original question.  Is the point then that UEFI
> > must assume (from ACPI/DT) the cache-coherency properties of the PCI
> > controller which exists in hardware on the system you're running on,
> > even for the virtual PCI bus because that will be the semantics for
> > assigned devices?
> > 
> > And in that case, we have no way to distinguish between passthrough
> > devices and virtual devices plugged into the virtual PCI bus?
> 
> Well, we could use the subsystem id.  But it's a hack, and may cause
> incompatibilities with some drivers.  Michael, any ideas?
> 
> > What about the idea of having two virtual PCI buses on your system where
> > one is always cache-coherent and uses for virtual devices, and the other
> > is whatever the hardware is and used for passthrough devices?
> 
> I think that was rejected before.
> 

Do you remember where?  I just remember Catalin mentioning the idea to
me verbally.

Besides the slightly heavy added use of resources etc. it seems like it
would address some of our issues in a good way.

But I'm still not sure why UEFI/Linux currently sees our PCI bus as
being non-coherent when in fact it is and we have no passthrough issues
currently.  Are all PCI controllers always non-coherent for some reason
and therefore we model it as such too?

-Christoffer
