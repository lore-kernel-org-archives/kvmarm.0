From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 19 Dec 2017 14:04:36 +0100
Message-ID: <20171219130436.GC31048@cbox>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
 <20171218173121.kmef47u2q7qa4eqb@yury-thinkpad>
 <20171219091200.GB31048@cbox>
 <20171219100521.oqnqlxhooe3jjlxb@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95D2149DA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 08:01:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iLROt60UdUfR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Dec 2017 08:01:01 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E167849D9E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 08:01:00 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id g75so3631038wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Dec 2017 05:04:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20171219100521.oqnqlxhooe3jjlxb@yury-thinkpad>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: "Goutham, Sunil" <Sunil.Goutham@cavium.com>, kvm@vger.kernel.org, marc.zyngier@arm.com, "Cherian, Linu" <Linu.Cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 19, 2017 at 01:05:21PM +0300, Yury Norov wrote:
> On Tue, Dec 19, 2017 at 10:12:00AM +0100, Christoffer Dall wrote:
> > On Mon, Dec 18, 2017 at 08:31:21PM +0300, Yury Norov wrote:
> > > On Fri, Dec 15, 2017 at 04:15:39PM -0500, Shih-Wei Li wrote:
> > > > Here we provide the support for measuring various micro level
> > > > operations on arm64. We iterate each of the tests for millions of
> > > > times and output their average, minimum and maximum cost in timer
> > > > counts. Instruction barriers are used before and after taking
> > > > timestamps to avoid out-of-order execution or pipelining from
> > > > skewing our measurements.
> > > > 
> > > > The tests we currently support and measure are mostly
> > > > straightforward by the function names and the respective comments.
> > > > For IPI test, we measure the cost of sending IPI from a source
> > > > VCPU to a target VCPU, until the target VCPU receives the IPI.
> > > > 
> > > > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> > > > ---
> > > >  arm/Makefile.common |   1 +
> > > >  arm/micro-test.c    | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  arm/unittests.cfg   |   6 ++
> > > >  3 files changed, 296 insertions(+)
> > > >  create mode 100644 arm/micro-test.c
> > > > 
> > > > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > > > index 0a039cf..c7d5c27 100644
> > > > --- a/arm/Makefile.common
> > > > +++ b/arm/Makefile.common
> > > > @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
> > > >  tests-common += $(TEST_DIR)/gic.flat
> > > >  tests-common += $(TEST_DIR)/psci.flat
> > > >  tests-common += $(TEST_DIR)/sieve.flat
> > > > +tests-common += $(TEST_DIR)/micro-test.flat
> > > >  
> > > >  tests-all = $(tests-common) $(tests)
> > > >  all: directories $(tests-all)
> > > > diff --git a/arm/micro-test.c b/arm/micro-test.c
> > > > new file mode 100644
> > > > index 0000000..7df2272
> > > > --- /dev/null
> > > > +++ b/arm/micro-test.c
> > > > @@ -0,0 +1,289 @@
> > > > +#include <util.h>
> > > > +#include <asm/gic.h>
> > > > +
> > > > +static volatile bool second_cpu_up;
> > > > +static volatile bool first_cpu_ack;
> > > > +static volatile bool ipi_acked;
> > > > +static volatile bool ipi_received;
> > > > +static volatile bool ipi_ready;
> > > > +#define IPI_IRQ		1
> > > > +
> > > > +#define TIMEOUT (1U << 28)
> > > > +
> > > > +#define ARR_SIZE(_x) ((int)(sizeof(_x) / sizeof(_x[0])))
> > > > +#define for_each_test(_iter, _tests, _tmp) \
> > > > +	for (_tmp = 0, _iter = _tests; \
> > > > +			_tmp < ARR_SIZE(_tests); \
> > > > +			_tmp++, _iter++)
> > > > +
> > > > +#define CYCLE_COUNT(c1, c2) \
> > > > +	(((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))
> > > 
> > > Is my understanding correct that this is overflow protection?
> > > c1 and c2 are 64-bit values. To overflow them you need 58 years
> > > at 1G CPU freq.
> > > 
> > 
> > That's assuming your cycle counter starts at 0, and that nobody
> > programmed it near the overflow value to get an overflow interrupt.
> > 
> > So if you get rid of this, you have to make sure the host never plays
> > with the cycle counter behind your back, and that you've initialized it
> > to zero.
> 
> Ah, now I understand it. But if there's no evil intention to break the
> test, there's single chance to overflow in 584 years. And if it happened,
> isn't it simpler to run test again? 

I believe we used this to throw away results where there was an
overflow, which is nicer to the user than leaving them guessing 'this is
a very high number, I better run the test again'.

-Christoffer
