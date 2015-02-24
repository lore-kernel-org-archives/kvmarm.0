From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Tue, 24 Feb 2015 20:12:53 +0100
Message-ID: <20150224191252.GA16521@hawk.usersys.redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150219165731.GA26965@hawk.usersys.redhat.com>
 <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
 <20150220153626.GB10942@hawk.usersys.redhat.com>
 <20150224145529.GA5498@hawk.usersys.redhat.com>
 <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32CB346135
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 14:07:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZW7KLfXhO8m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 14:07:25 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34C2A4612F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 14:07:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Uk2wg1OkoWgQe4da_EiFoEz_u8VuD8Ees6qU1UYMDvQ@mail.gmail.com>
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
Cc: KVM devel mailing list <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 05:47:19PM +0000, Ard Biesheuvel wrote:
> On 24 February 2015 at 14:55, Andrew Jones <drjones@redhat.com> wrote:
> > On Fri, Feb 20, 2015 at 04:36:26PM +0100, Andrew Jones wrote:
> >> On Fri, Feb 20, 2015 at 02:37:25PM +0000, Ard Biesheuvel wrote:
> >> > On 20 February 2015 at 14:29, Andrew Jones <drjones@redhat.com> wrote:
> >> > > So looks like the 3 orders of magnitude greater number of traps
> >> > > (only to el2) don't impact kernel compiles.
> >> > >
> >> >
> >> > OK, good! That was what I was hoping for, obviously.
> >> >
> >> > > Then I thought I'd be able to quick measure the number of cycles
> >> > > a trap to el2 takes with this kvm-unit-tests test
> >> > >
> >> > > int main(void)
> >> > > {
> >> > >         unsigned long start, end;
> >> > >         unsigned int sctlr;
> >> > >
> >> > >         asm volatile(
> >> > >         "       mrs %0, sctlr_el1\n"
> >> > >         "       msr pmcr_el0, %1\n"
> >> > >         : "=&r" (sctlr) : "r" (5));
> >> > >
> >> > >         asm volatile(
> >> > >         "       mrs %0, pmccntr_el0\n"
> >> > >         "       msr sctlr_el1, %2\n"
> >> > >         "       mrs %1, pmccntr_el0\n"
> >> > >         : "=&r" (start), "=&r" (end) : "r" (sctlr));
> >> > >
> >> > >         printf("%llx\n", end - start);
> >> > >         return 0;
> >> > > }
> >> > >
> >> > > after applying this patch to kvm
> >> > >
> >> > > diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> >> > > index bb91b6fc63861..5de39d740aa58 100644
> >> > > --- a/arch/arm64/kvm/hyp.S
> >> > > +++ b/arch/arm64/kvm/hyp.S
> >> > > @@ -770,7 +770,7 @@
> >> > >
> >> > >         mrs     x2, mdcr_el2
> >> > >         and     x2, x2, #MDCR_EL2_HPMN_MASK
> >> > > -       orr     x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> >> > > +//     orr     x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> >> > >         orr     x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
> >> > >
> >> > >         // Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
> >> > >
> >> > > But I get zero for the cycle count. Not sure what I'm missing.
> >> > >
> >> >
> >> > No clue tbh. Does the counter work as expected in the host?
> >> >
> >>
> >> Guess not. I dropped the test into a module_init and inserted
> >> it on the host. Always get zero for pmccntr_el0 reads. Or, if
> >> I set it to something non-zero with a write, then I always get
> >> that back - no increments. pmcr_el0 looks OK... I had forgotten
> >> to set bit 31 of pmcntenset_el0, but doing that still doesn't
> >> help. Anyway, I assume the problem is me. I'll keep looking to
> >> see what I'm missing.
> >>
> >
> > I returned to this and see that the problem was indeed me. I needed yet
> > another enable bit set (the filter register needed to be instructed to
> > count cycles while in el2). I've attached the code for the curious.
> > The numbers are mean=6999, std_dev=242. Run on the host, or in a guest
> > running on a host without this patch series (after TVM traps have been
> > disabled), I get a pretty consistent 40.
> >
> > I checked how many vm-sysreg traps we do during the kernel compile
> > benchmark. It's 124924. So it's a bit strange that we don't see the
> > benchmark taking 10 to 20 seconds longer on average. I should probably
> > double check my runs. In any case, while I like the approach of this
> > series, the overhead is looking non-negligible.
> >
> 
> Thanks a lot for producing these numbers. 125k x 7k == <1 billion
> cycles == <1 second on a >1 GHz machine, I think?
> Or am I missing something? How long does the actual compile take?
>

Wait, my fault. I dropped a pretty big divisor in my calculation. Don't
ask... I'll just go home and study one of my daughter's math books now...

So, I even have a 2.4 GHz machine, which explains why the benchmark times
are the same with and without this series (those times are provided earlier
in this thread, they're roughly 03:10). I'm glad you straighted me out. I
was second guessing my benchmark results, and considering redoing them.

Anyway, this series, at least wrt to overhead, is looking good again.

Thanks,
drew
