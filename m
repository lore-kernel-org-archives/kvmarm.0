From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 0/3] KVM: Introduce
 KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 15:00:37 +0200
Message-ID: <20150514130037.GB12812@localhost.localdomain>
References: <5554826E.1040706@redhat.com> <20150514112910.GR32765@cbox>
 <55548777.9000702@redhat.com> <20150514113634.GS32765@cbox>
 <5554893E.4030105@redhat.com> <20150514120039.GU32765@cbox>
 <55549051.1090007@redhat.com> <20150514122413.GV32765@cbox>
 <55549501.2010000@redhat.com>
 <CAFEAcA_OXHH2NmU6c=KB+DgRQS=+YYX4es+otjE_k0qzn+6+0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39ABD514CE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yoh5jA3kwiwe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 08:51:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03C42514CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 08:51:41 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA_OXHH2NmU6c=KB+DgRQS=+YYX4es+otjE_k0qzn+6+0Q@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 01:38:11PM +0100, Peter Maydell wrote:
> On 14 May 2015 at 13:28, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > Well, PCI BARs are generally MMIO resources, and hence should not be cached.
> >
> > As an optimization, OS drivers can mark them as cacheable or
> > write-combining or something like that, but in general it's a safe
> > default to leave them uncached---one would think.
> 
> Isn't this handled by the OS mapping them in the 'prefetchable'
> MMIO window rather than the 'non-prefetchable' one? (QEMU's
> generic-PCIe device doesn't yet support the prefetchable window.)

I was thinking (with my limited PCI knowledge) the same thing, and
was planning on experimenting with that.

drew
