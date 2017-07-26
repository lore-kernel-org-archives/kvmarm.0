From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 2/3] arm64: timer: Fix test on APM X-Gene
Date: Wed, 26 Jul 2017 04:38:41 -0700
Message-ID: <20170726113841.GF1588@lvm>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-3-cdall@linaro.org>
 <a58bfe11-19a0-aa92-5166-2c33e4cb8981@arm.com>
 <20170714154512.GC1535@lvm>
 <20170718100503.crn2dgqlalrirzqw@kamzik.brq.redhat.com>
 <20170718103512.GB14069@cbox>
 <20170718121527.ptemrr6mbhfwwbwe@kamzik.brq.redhat.com>
 <b7900fdf-bcc0-00af-bf5d-940eca09e4ae@redhat.com>
 <CAMJs5B-CbRdDPO31XaWuDp0=um5KpePZGBVEw+mU9EnZkZFKwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EA5740D44
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jul 2017 07:37:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VUC+9ytZXu-Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jul 2017 07:37:42 -0400 (EDT)
Received: from mail-lf0-f47.google.com (mail-lf0-f47.google.com
 [209.85.215.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF44E40960
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jul 2017 07:37:41 -0400 (EDT)
Received: by mail-lf0-f47.google.com with SMTP id y15so67111699lfd.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jul 2017 04:38:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAMJs5B-CbRdDPO31XaWuDp0=um5KpePZGBVEw+mU9EnZkZFKwg@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 24, 2017 at 11:25:50PM +0200, Christoffer Dall wrote:
> On Mon, Jul 24, 2017 at 7:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 18/07/2017 14:15, Andrew Jones wrote:
> >>>
> >>> If we want to add a "the platform provides a timer with 56 valid bits in
> >>> the counter and compare register", then I think it should be a separate
> >>> test, and the the user can see that "basic stuff works", "architecture
> >>> compliance not so much" and shrug accordingly.
> >> Two separate tests sounds good to me. Although, if the value of 'now' is
> >> large enough that now + 10s will set bit 31, then a mustang run (at least
> >> mine) will fail - and most likely cause a lot of confusion, since it
> >> normally does not. We should probably attempt to address that known issue
> >> in some way as well.
> >
> > Is the value relative to vm startup or host startup?
> >
> For the virtual timer, KVM currently resets the counter to zero (so VM
> startup) and for the physical timer it's since host startup.
> 
> I confirmed the behavior Drew reported on my mustang too, but it only
> appears to apply for the vtimer when writing cval with bit 31 set, not
> for the ptimer.  I was thinking that this may be a problem with KVM,
> some sort of signed bit extension problem, but since the problem
> doesn't show up on other platforms, it may just be a problem there.

ok, so I did some digging here.  The problem doesn't seem to be with bit
31 specifically, but rather that the Mustang cannot handle a larger
difference between cval and cnt, than (1 << 31) - 1.

I verified this by writing to tval instead and increasing its value more
and more.

Furthermore, I also added a delay loop, that waits until the counter
reaches 0xffffffff and then program cval with something later, which
works just fine.

I also looked at the hardware registers and observe things like:

cval: 0x100000000 cnt_ctl: 0x5 cnt: 0x225a6e

Which means that the timer sets ISTATUS even though it clearly shouldn't
fire.

The explanation why Linux always (seems to) work on the platform is
likely that Linux never programs a timer further out than ~80 seconds.

Broken hardware, oh well.

Thanks,
-Christoffer
