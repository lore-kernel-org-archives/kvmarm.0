From: Li Zhang <zhlcindy@gmail.com>
Subject: Re: kvm-unit-tests gicv2 cases fail
Date: Mon, 5 Nov 2018 15:19:50 +0800
Message-ID: <CAD8of+qMPs=miB6O_wyS6E8cyO3PjubDUmLV0p6Oikb9g15s1Q@mail.gmail.com>
References: <CAD8of+q29DrQa4Ay6karXC19vXzX++2T8FR-V1SAjGuO0ejYhQ@mail.gmail.com>
 <20181101101048.GJ12057@e113682-lin.lund.arm.com>
 <86a7mt2ix9.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 651C14A2AC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 02:20:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nptceZXcbZyD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Nov 2018 02:20:33 -0500 (EST)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E0924A0C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Nov 2018 02:20:33 -0500 (EST)
Received: by mail-yw1-f68.google.com with SMTP id v77-v6so3259207ywc.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 04 Nov 2018 23:20:33 -0800 (PST)
In-Reply-To: <86a7mt2ix9.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 1, 2018 at 6:25 PM Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> [Thanks Christoffer for cc'ing me]
>
> On Thu, 01 Nov 2018 10:10:48 +0000,
> Christoffer Dall <christoffer.dall@arm.com> wrote:
> >
> > On Thu, Oct 18, 2018 at 05:17:57PM +0800, Li Zhang wrote:
> > > Hi,
> > >
> > > I run kvm-units-test on ARM server(QDF2400), but gicv2-ipi,
> > > gicv2-active cases fail.
> >
> > I didn't think QDF2400 has GICv2 on GICv3 support?
> >
> > Do the test cases fail or are they reported as skipped?
> >
> > > By debuging kvm-unit-tests source code, I found that interrupt is not
> > > handled. do_handle_exception is not called.
> > >
> > > By looking into KVM source code, it has GICv2 emulation on GICv3 support.
> > > I've tried a lot of kernel versions, from v4.12~v4.19 in mainline,
> > > these cases always fail.
> > > Is it possible that hardware/software disables this?
>
> Most implementations do not have the v2 compatibility interface, and
> nobody really needs it. This is a convenient way to run older VMs that
> do not know about GICv3 (32bit VMs, for example), but that's in no way
> a common setup.

I see, thanks for your explanation.

>
> > >
> > > It seems that GICv2 is a little old for ARM server, I am confused when
> > > we can use it.
> > > Do we need to care about these cases?
> > >
> >
> > I don't think you need to care.  I believe Marc has run the
> > GICv2-on-GICv3 tests on his supported platforms with recent
> > kvm-unit-tests and other have reported succes as well.
>
> Here you go (on my Chromebook running 4.18):
>
> PASS gicv2-ipi (3 tests)
> PASS gicv2-mmio (17 tests)
> PASS gicv2-mmio-up (17 tests)
> PASS gicv2-mmio-3p (17 tests)
> PASS gicv3-ipi (3 tests)
> PASS gicv2-active (1 tests)
> PASS gicv3-active (1 tests)
>
> Thanks,
>
>         M.
>
> --
> Jazz is not dead, it just smell funny.



-- 

Best Regards
-Li
