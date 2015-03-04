From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Wed, 4 Mar 2015 15:12:12 +0100
Message-ID: <20150304141212.GA5352@hawk.usersys.redhat.com>
References: <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
 <20150302163146.GB9686@lvm> <54F51A63.4060302@samsung.com>
 <20150304113505.GS28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8OUtcpaQh5+gb6vNrdi+Q7eu_zKOujmyoRPrzrs+GJVQ@mail.gmail.com>
 <20150304122956.GT28951@e104818-lin.cambridge.arm.com>
 <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA4CA479F6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:06:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ezwlIxc7tcIV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 09:06:20 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6592479F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 09:06:20 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-JnvXFzr-fpjZZ-zTt8hOSfGqefw69s+4JX2iu_6_BMw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 01:43:02PM +0100, Ard Biesheuvel wrote:
> On 4 March 2015 at 13:29, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Wed, Mar 04, 2015 at 12:50:57PM +0100, Ard Biesheuvel wrote:
> >> On 4 March 2015 at 12:35, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >> > On Mon, Mar 02, 2015 at 06:20:19PM -0800, Mario Smarduch wrote:
> >> >> On 03/02/2015 08:31 AM, Christoffer Dall wrote:
> >> >> > However, my concern with these patches are on two points:
> >> >> >
> >> >> > 1. It's not a fix-all.  We still have the case where the guest expects
> >> >> > the behavior of device memory (for strong ordering for example) on a RAM
> >> >> > region, which we now break.  Similiarly this doesn't support the
> >> >> > non-coherent DMA to RAM region case.
> >> >> >
> >> >> > 2. While the code is probably as nice as this kind of stuff gets, it
> >> >> > is non-trivial and extremely difficult to debug.  The counter-point here
> >> >> > is that we may end up handling other stuff at EL2 for performanc reasons
> >> >> > in the future.
> >> >> >
> >> >> > Mainly because of point 1 above, I am leaning to thinking userspace
> >> >> > should do the invalidation when it knows it needs to, either through KVM
> >> >> > via a memslot flag or through some other syscall mechanism.
> >> >
> >> > I expressed my concerns as well, I'm definitely against merging this
> >> > series.
> >>
> >> Don't worry, that was never the intention, at least not as-is :-)
> >
> > I wasn't worried, just wanted to make my position clearer ;).
> >
> >> I think we have established that the performance hit is not the
> >> problem but the correctness is.
> >
> > I haven't looked at the performance figures but has anyone assessed the
> > hit caused by doing cache maintenance in Qemu vs cacheable guest
> > accesses (and no maintenance)?
> >

I'm working on a PoC of a QEMU/KVM cache maintenance approach now.
Hopefully I'll send it out this evening. Tomorrow at the latest.
Getting numbers of that approach vs. a guest's use of cached memory
for devices would take a decent amount of additional work, so won't
be part of that post. I'm actually not sure we should care about
the numbers for a guest using normal mem attributes for device
memory - other than out of curiosity. For correctness this issue
really needs to be solved 100% host-side. We can't rely on a
guest to do different/weird things, just because it's a guest.
Ideally guests don't even know that they're guests. (Even if we
describe the memory as cache-able to the guest, I don't think we
can rely on the guest believing us.)

drew
