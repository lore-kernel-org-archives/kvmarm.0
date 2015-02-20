From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC/RFT PATCH 0/3] arm64: KVM: work around incoherency with
 uncached guest mappings
Date: Fri, 20 Feb 2015 16:36:26 +0100
Message-ID: <20150220153626.GB10942@hawk.usersys.redhat.com>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
 <20150219165731.GA26965@hawk.usersys.redhat.com>
 <CAKv+Gu8Je3RRrgEFCZ7JUWtOgk3WqA_qdBEOPAMc3OqnKr1bwg@mail.gmail.com>
 <20150219175518.GB26965@hawk.usersys.redhat.com>
 <54E62404.9040702@redhat.com>
 <20150220142905.GA10942@hawk.usersys.redhat.com>
 <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EDC46258
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Feb 2015 10:31:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MXKj1fuZRG7t for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Feb 2015 10:31:06 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC48C461D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Feb 2015 10:31:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-YUzmnACZQi98OPRgKKL+gAGqwWYq2-_dwCdNqcktNUg@mail.gmail.com>
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

On Fri, Feb 20, 2015 at 02:37:25PM +0000, Ard Biesheuvel wrote:
> On 20 February 2015 at 14:29, Andrew Jones <drjones@redhat.com> wrote:
> > So looks like the 3 orders of magnitude greater number of traps
> > (only to el2) don't impact kernel compiles.
> >
> 
> OK, good! That was what I was hoping for, obviously.
> 
> > Then I thought I'd be able to quick measure the number of cycles
> > a trap to el2 takes with this kvm-unit-tests test
> >
> > int main(void)
> > {
> >         unsigned long start, end;
> >         unsigned int sctlr;
> >
> >         asm volatile(
> >         "       mrs %0, sctlr_el1\n"
> >         "       msr pmcr_el0, %1\n"
> >         : "=&r" (sctlr) : "r" (5));
> >
> >         asm volatile(
> >         "       mrs %0, pmccntr_el0\n"
> >         "       msr sctlr_el1, %2\n"
> >         "       mrs %1, pmccntr_el0\n"
> >         : "=&r" (start), "=&r" (end) : "r" (sctlr));
> >
> >         printf("%llx\n", end - start);
> >         return 0;
> > }
> >
> > after applying this patch to kvm
> >
> > diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> > index bb91b6fc63861..5de39d740aa58 100644
> > --- a/arch/arm64/kvm/hyp.S
> > +++ b/arch/arm64/kvm/hyp.S
> > @@ -770,7 +770,7 @@
> >
> >         mrs     x2, mdcr_el2
> >         and     x2, x2, #MDCR_EL2_HPMN_MASK
> > -       orr     x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> > +//     orr     x2, x2, #(MDCR_EL2_TPM | MDCR_EL2_TPMCR)
> >         orr     x2, x2, #(MDCR_EL2_TDRA | MDCR_EL2_TDOSA)
> >
> >         // Check for KVM_ARM64_DEBUG_DIRTY, and set debug to trap
> >
> > But I get zero for the cycle count. Not sure what I'm missing.
> >
> 
> No clue tbh. Does the counter work as expected in the host?
>

Guess not. I dropped the test into a module_init and inserted
it on the host. Always get zero for pmccntr_el0 reads. Or, if
I set it to something non-zero with a write, then I always get
that back - no increments. pmcr_el0 looks OK... I had forgotten
to set bit 31 of pmcntenset_el0, but doing that still doesn't
help. Anyway, I assume the problem is me. I'll keep looking to
see what I'm missing.

drew
