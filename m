From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests RFC 00/15] arm/arm64: add ITS
 framework
Date: Tue, 6 Dec 2016 12:21:21 +0100
Message-ID: <20161206112121.577yyjtzeh2f7fkp@kamzik.brq.redhat.com>
References: <1480974406-29345-1-git-send-email-eric.auger@redhat.com>
 <20161206094841.2wi34yfapalf6fth@kamzik.brq.redhat.com>
 <e7850784-09d3-c4eb-17c6-02765fecddf2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC89340430
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:20:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kwT9Df53vFxU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2016 06:20:30 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B96740428
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2016 06:20:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <e7850784-09d3-c4eb-17c6-02765fecddf2@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 06, 2016 at 11:14:41AM +0000, Andre Przywara wrote:
> Hi,
> 
> On 06/12/16 09:48, Andrew Jones wrote:
> > On Mon, Dec 05, 2016 at 10:46:31PM +0100, Eric Auger wrote:
> >> This series proposes a framework to test the virtual ITS.
> >> This is based on Drew's v7 series [1]. The last patch tests
> >> several ITS commands (collection/device mapping, interrupt
> >> translation service entry creation and LPI trigger through INT
> >> command). At this point we don't use any external PCIe device
> >> to write into the GITS_TRANSLATER register.
> >>
> >> The bulk of the code derives from the ITS driver code so all
> >> the credit is due to Marc.
> >>
> >> Many other ITS commands could be tested. Also existing MMIO
> >> accesses could be enhanced into standalone tests. Current focus
> >> was to make it functional.
> >>
> >> The code deserves more cleanup with respect to cacheability
> >> attributes in general.
> >>
> >> Tested on Cavium ThunderX [2].
> >>
> >> Best Regards
> >>
> >> Eric
> >>
> >> [1] [kvm-unit-tests PATCH v7 00/11] arm/arm64: add gic framework
> >>
> >> [2] sample command line:
> >>
> >> $QEMU -machine virt,accel=kvm -cpu host \
> >>  -device virtio-serial-device \
> >>  -device virtconsole,chardev=ctd -chardev testdev,id=ctd \
> >>  -display none -serial stdio \
> >>  -kernel arm/gic.flat \
> >>  -smp 8 -machine gic-version=3 -append 'its'
> >>
> >> Eric Auger (15):
> >>   libcflat: Add other size defines
> >>   arm/arm64: gicv3: Add some re-distributor defines
> >>   arm/arm64: ITS skeleton
> >>   arm/arm64: ITS: BASER parsing and setup
> >>   arm/arm64: GICv3: add cpu count
> >>   arm/arm64: ITS: Set the LPI config and pending tables
> >>   arm/arm64: ITS: Init the command queue
> >>   arm/arm64: ITS: enable LPIs at re-distributor level
> >>   arm/arm64: ITS: Parse the typer register
> >>   arm/arm64: ITS: its_enable_defaults
> >>   arm/arm64: ITS: create device
> >>   arm/arm64: ITS: create collection
> >>   arm/arm64: ITS: commands
> >>   arm/arm64: gic: Generalize ipi_enable()
> >>   arm/arm64: ITS test
> >>
> >>  arm/Makefile.common        |   1 +
> >>  arm/gic.c                  | 101 +++++++++++-
> >>  lib/arm/asm/gic-v3-its.h   | 238 +++++++++++++++++++++++++++
> >>  lib/arm/asm/gic-v3.h       |  84 ++++++++++
> >>  lib/arm/asm/gic.h          |   1 +
> >>  lib/arm/gic-v3-its-cmd.c   | 399 +++++++++++++++++++++++++++++++++++++++++++++
> >>  lib/arm/gic-v3-its.c       | 305 ++++++++++++++++++++++++++++++++++
> >>  lib/arm/gic-v3.c           |   2 +
> >>  lib/arm/gic.c              |  30 +++-
> >>  lib/arm64/asm/gic-v3-its.h |   1 +
> >>  lib/libcflat.h             |   3 +
> >>  11 files changed, 1154 insertions(+), 11 deletions(-)
> >>  create mode 100644 lib/arm/asm/gic-v3-its.h
> >>  create mode 100644 lib/arm/gic-v3-its-cmd.c
> >>  create mode 100644 lib/arm/gic-v3-its.c
> >>  create mode 100644 lib/arm64/asm/gic-v3-its.h
> >>
> >> -- 
> >> 2.5.5
> >>
> >>
> > 
> > Thanks for this Eric! I'm glad to see we're getting more GIC test
> > coverage written, even before v8 of the gic series is posted :-)
> > v8 will be rebased on some sysreg stuff Wei is doing for the PMU
> > series,
> 
> Are you planning on a v8 post any time soon?

I think Wei is going to post PMU today. Hopefully everyone will be happy
with the sysreg bits. If so, then I'll post v8 no later than tomorrow
sometime.

> 
> > that's why it's held up. I'll need to set plenty of time
> > aside to learn enough in order to review all the 'ITS:' patches
> > in this series.
> 
> Are you sure you want to really taint yourself with this stuff? You
> wouldn't be the first who risks his mental health by understanding the
> ITS ;-)
> 
> That being said, I will take a look, I am in ITS land anyway for Xen ...

Excellent! Thanks!

drew

> 
> Cheers,
> Andre.
> 
> 
> > Apologies if I can't get to it right away.
> > 
> > Thanks again,
> > drew
> > 
