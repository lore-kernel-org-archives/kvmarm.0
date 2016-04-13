From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Wed, 13 Apr 2016 19:24:18 +0200
Message-ID: <20160413172418.GA21653@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <20160331183019.GK4126@cbox> <570E6EDC.5070209@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9898F49B58
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 13:22:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jRtUwU86Iojr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Apr 2016 13:22:17 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 90CD349B51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 13:22:17 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id a140so113132089wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Apr 2016 10:23:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570E6EDC.5070209@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 13, 2016 at 05:07:56PM +0100, Andr=E9 Przywara wrote:
> On 31/03/16 19:30, Christoffer Dall wrote:
> > On Fri, Mar 25, 2016 at 02:04:23AM +0000, Andre Przywara wrote:
> >> This series is a joint effort to re-implement KVM's GIC emulation.
> >>
> >> While the current implementation is centered around providing
> >> efficient MMIO emulation, the hot path for most guests is actually
> >> the guest entry and exit, which currently is rather costly.
> >> Also the existing emulation has a global distributor lock, which
> >> quickly becomes a bottleneck once the number of VCPUs increases.
> >> Additionally the emulation was originally designed for GICv2, adding
> >> GICv3 ITS emulation support to this proved to be rather painful.
> >> Last, but not least the existing code became less and less
> >> maintainable, with many special cases handled explicitly.
> >>
> >> The new implementation is build around a struct vgic_irq data data
> >> structure, which holds all information about a virtual interrupt.
> >> Interruts which should be injected are hold in a per-VCPU list, this
> >> make the entry/exit path much more efficient. Also the new structure
> >> allows to have more fine grained locking - per IRQ and per VCPU -
> >> getting rid of the global distributor lock.
> >> As a result of the new design ITS emulation fits in more nicely, the
> >> respective code will be provided as a follow-up series.
> >>
> >> This series implements the same feature set as the existing emulation,
> >> as a goodie we now implement priorities correctly.
> >> To allow an easy transition with good test coverage, but still maintain
> >> stability, both implementations live side by side, selectable via a
> >> Kconfig option. The default is the new implementation.
> >> If this code proves to be reliable, we will later remove the current
> >> implementation with an extra patch set.
> >>
> >> Please have a look at the series, review it and give the code some
> >> serious testing (and possibly debugging). All feedback is appreciated.
> >>
> > =

> > Hmph, starting a guest a couple of times and running hackbench inside
> > the guest actually gave me (twice) the following error:
> > =

> > NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:0:4]
> =

> On the host or in the guest?

In the guest.

> Can you reproduce it easily? If yes, can you add some lock debugging to
> see if we are stuck in a spinlock?
> =


I'll do this when you've posted a new version. Sound ok?

-Christoffer
