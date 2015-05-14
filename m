From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 0/3] KVM: Introduce
 KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 15:48:25 +0200
Message-ID: <20150514154327-mutt-send-email-mst@redhat.com>
References: <55548777.9000702@redhat.com> <20150514113634.GS32765@cbox>
 <5554893E.4030105@redhat.com> <20150514120039.GU32765@cbox>
 <55549051.1090007@redhat.com> <20150514122413.GV32765@cbox>
 <55549501.2010000@redhat.com>
 <CAFEAcA_OXHH2NmU6c=KB+DgRQS=+YYX4es+otjE_k0qzn+6+0Q@mail.gmail.com>
 <20150514130037.GB12812@localhost.localdomain>
 <5554A3DA.2070307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5B0B51512
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9wZlKsV3uFtQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 09:39:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64A4D514E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:39:26 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <5554A3DA.2070307@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Laszlo Ersek <lersek@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 03:32:10PM +0200, Laszlo Ersek wrote:
> On 05/14/15 15:00, Andrew Jones wrote:
> > On Thu, May 14, 2015 at 01:38:11PM +0100, Peter Maydell wrote:
> >> On 14 May 2015 at 13:28, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>> Well, PCI BARs are generally MMIO resources, and hence should not be cached.
> >>>
> >>> As an optimization, OS drivers can mark them as cacheable or
> >>> write-combining or something like that, but in general it's a safe
> >>> default to leave them uncached---one would think.
> >>
> >> Isn't this handled by the OS mapping them in the 'prefetchable'
> >> MMIO window rather than the 'non-prefetchable' one? (QEMU's
> >> generic-PCIe device doesn't yet support the prefetchable window.)
> > 
> > I was thinking (with my limited PCI knowledge) the same thing, and
> > was planning on experimenting with that.
> 
> This could be supported in UEFI as well, with the following steps:
> - the DTB that QEMU provides UEFI with should advertise such a
>   prefetchable window.
> - The driver in UEFI that parses the DTB should understand that DTB
>   node (well, record type), and store the appropriate base & size into
>   some new dynamic PCDs (= basically, firmware wide global variables;
>   PCD = platform configuration database)
> - The entry point of the host bridge driver would call
>   gDS->AddMemorySpace() twice, separately for the two different windows,
>   with their appropriate caching attributes.
> - The host bridge driver needs to be extended so that TypePMem32
>   requests are not rejected (like now); they should be handled
>   similarly to TypeMem32. Except, the gDS->AllocateMemorySpace() call
>   should allocate from the prefetchable range (determined by the new
>   PCDs above).
> - QEMU's emulated devices should then expose their BARs as prefetchable
>   (so that the above branch would be taken in the host bridge driver).
> 
> (Of course, if QEMU intends to emulate PCI devices somewhat
> realistically, then QEMU should claim "non-prefetchable" for BARs that
> would not be prefetchable on physical hardware either, and then the
> hypervisor should accommodate the firmware's UC mapping and say "hey I
> know better, we're virtual in fact", and override the attribute (-> use
> WB instead of UC). With which we'd be back to square one...)
> 
> Thanks
> Laszlo

Prefetcheable is unrelated to BAR caching or drivers, it's a way to tell
host bridges they can do limited tweaks to downstream transactions in a
specific range.

Really non-prefetcheable BARs are mostly those where read has
side-effects, which is best avoided. this does not mean it's ok to
reorder transactions or cache them.

-- 
MST
