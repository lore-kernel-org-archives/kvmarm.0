From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 19 Dec 2017 13:05:21 +0300
Message-ID: <20171219100521.oqnqlxhooe3jjlxb@yury-thinkpad>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218173121.kmef47u2q7qa4eqb@yury-thinkpad>
 <20171219091200.GB31048@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171219091200.GB31048@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, drjones@redhat.com, pbonzini@redhat.com, "Kalra, Ashish" <Ashish.Kalra@cavium.com>, "Goutham, Sunil" <Sunil.Goutham@cavium.com>, "Cherian, Linu" <Linu.Cherian@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 19, 2017 at 10:12:00AM +0100, Christoffer Dall wrote:
> On Mon, Dec 18, 2017 at 08:31:21PM +0300, Yury Norov wrote:
> > On Fri, Dec 15, 2017 at 04:15:39PM -0500, Shih-Wei Li wrote:
> > > Here we provide the support for measuring various micro level
> > > operations on arm64. We iterate each of the tests for millions of
> > > times and output their average, minimum and maximum cost in timer
> > > counts. Instruction barriers are used before and after taking
> > > timestamps to avoid out-of-order execution or pipelining from
> > > skewing our measurements.
> > > 
> > > The tests we currently support and measure are mostly
> > > straightforward by the function names and the respective comments.
> > > For IPI test, we measure the cost of sending IPI from a source
> > > VCPU to a target VCPU, until the target VCPU receives the IPI.
> > > 
> > > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> > > ---
> > >  arm/Makefile.common |   1 +
> > >  arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  arm/unittests.cfg   |   6 ++
> > >  3 files changed, 296 insertions(+)
> > >  create mode 100644 arm/micro-test.c
> > > 
> > > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > > index 0a039cf..c7d5c27 100644
> > > --- a/arm/Makefile.common
> > > +++ b/arm/Makefile.common
> > > @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
> > >  tests-common += $(TEST_DIR)/gic.flat
> > >  tests-common += $(TEST_DIR)/psci.flat
> > >  tests-common += $(TEST_DIR)/sieve.flat
> > > +tests-common += $(TEST_DIR)/micro-test.flat
> > >  
> > >  tests-all = $(tests-common) $(tests)
> > >  all: directories $(tests-all)
> > > diff --git a/arm/micro-test.c b/arm/micro-test.c
> > > new file mode 100644
> > > index 0000000..7df2272
> > > --- /dev/null
> > > +++ b/arm/micro-test.c
> > > @@ -0,0 +1,289 @@
> > > +#include <util.h>
> > > +#include <asm/gic.h>
> > > +
> > > +static volatile bool second_cpu_up;
> > > +static volatile bool first_cpu_ack;
> > > +static volatile bool ipi_acked;
> > > +static volatile bool ipi_received;
> > > +static volatile bool ipi_ready;
> > > +#define IPI_IRQ		1
> > > +
> > > +#define TIMEOUT (1U << 28)
> > > +
> > > +#define ARR_SIZE(_x) ((int)(sizeof(_x) / sizeof(_x[0])))
> > > +#define for_each_test(_iter, _tests, _tmp) \
> > > +	for (_tmp = 0, _iter = _tests; \
> > > +			_tmp < ARR_SIZE(_tests); \
> > > +			_tmp++, _iter++)
> > > +
> > > +#define CYCLE_COUNT(c1, c2) \
> > > +	(((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))
> > 
> > Is my understanding correct that this is overflow protection?
> > c1 and c2 are 64-bit values. To overflow them you need 58 years
> > at 1G CPU freq.
> > 
> 
> That's assuming your cycle counter starts at 0, and that nobody
> programmed it near the overflow value to get an overflow interrupt.
> 
> So if you get rid of this, you have to make sure the host never plays
> with the cycle counter behind your back, and that you've initialized it
> to zero.

Ah, now I understand it. But if there's no evil intention to break the
test, there's single chance to overflow in 584 years. And if it happened,
isn't it simpler to run test again? 

If host shifts cycle counter during the test, the whole test becomes useless,
I think.

> FWIW, when we first wrote some version of this code 5+ years ago in a
> different world, we actually saw overflow as a result of the way we ran
> this code.  That may have changed, but it's not as clear cut.

Maybe 5+ years ago it was ARM32, and overflow was the result of
erroneous cast to unsigned long? (I guess it because the cast exists
in this patch.)

Anyway, this is minor. I'll happily take the test with or without this
hunk. But if you / Shih-Wei decide to save it, the comment would be
appreciated.

Yury
