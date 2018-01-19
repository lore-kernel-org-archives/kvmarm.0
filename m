From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: Re: [PATCH v3 2/2] arm64: add micro test
Date: Fri, 19 Jan 2018 16:57:55 -0500
Message-ID: <CAO+sbHHKyYHjGqmS5uM=C6bCnUQ2CbHmmFBTAb=WanQsWdLU2Q@mail.gmail.com>
References: <1516225596-27071-1-git-send-email-shihwei@cs.columbia.edu>
 <1516225596-27071-3-git-send-email-shihwei@cs.columbia.edu>
 <20180118100958.j4iiq3ep2uruikss@yury-thinkpad>
 <20180118103737.jiwf5ly3up6w7f7r@kamzik.brq.redhat.com>
 <20180118112519.vzkfwkgqavvxqzdn@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A56549DCD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:53:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o0y5ldV7r7hF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jan 2018 16:53:17 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 55E2849DC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:53:17 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0JLv3qe027279
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:58:27 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 4586B82
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:58:28 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 1D2B081
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:58:28 -0500 (EST)
Received: from mail-it0-f72.google.com (mail-it0-f72.google.com
 [209.85.214.72])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w0JLwQQb062173
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 16:58:27 -0500
Received: by mail-it0-f72.google.com with SMTP id p144so3121747itc.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 13:58:27 -0800 (PST)
In-Reply-To: <20180118112519.vzkfwkgqavvxqzdn@yury-thinkpad>
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
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Thanks for the feedback about the mistakes in math and some issues in
naming, print msg, and coding style. I'll be careful and try to avoid
the same problems the next patch set. Sorry for all of the confusion.

So we now skip the test when "sample == 0" happens over 1000 times.
This is only due to the case that "cost is < 1/cntfrq" since it's not
possible for the tick to overflow for that many times. Did I miss
something here? I do agree that we should output better msgs to tell
users that the cost of a certain test is constantly smaller than a
tick.

Also, because ticks overflow should rarely happen, I wonder if we can
simply ignore the data set if it happens? If not, any thoughts on how
to efficiently distinguish one case from the other?

Thinking of the time granularity used in the output, given there's
likely difference in hardware implementation as previously mentioned,
should we output the cost in ticks (along with frequency) like I did
in v1 & v2 instead, allowing the users to do the translation to the exact
time based on the output?

Thanks again,
Shih-Wei

On Thu, Jan 18, 2018 at 6:39 AM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> On Thu, Jan 18, 2018 at 11:37:37AM +0100, Andrew Jones wrote:
>> On Thu, Jan 18, 2018 at 01:09:58PM +0300, Yury Norov wrote:
>> > On Wed, Jan 17, 2018 at 04:46:36PM -0500, Shih-Wei Li wrote:
>> > > Here we provide the support for measuring various micro level
>> > > operations on arm64. We iterate each of the tests and output
>> > > their average, minimum and maximum cost in microseconds.
>> > > Instruction barriers were used before taking timestamps to
>> > > avoid out-of-order execution or pipelining from skewing our
>> > > measurements.
>> > >
>> > > The operations we currently supported and measured are mostly
>> > > self-explanatory by their function name. For IPI, we measured the
>> > > cost of sending IPI from a source VCPU to a target VCPU, until the
>> > > target VCPU receives the IPI.
>> > >
>> > > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
>> > > Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
>> > > ---
>> > >  arm/Makefile.common |   1 +
>> > >  arm/micro-test.c    | 252 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>> > >  arm/unittests.cfg   |   7 ++
>> > >  3 files changed, 260 insertions(+)
>> > >  create mode 100644 arm/micro-test.c
>> > >
>> > > diff --git a/arm/Makefile.common b/arm/Makefile.common
>> > > index 0a039cf..c7d5c27 100644
>> > > --- a/arm/Makefile.common
>> > > +++ b/arm/Makefile.common
>> > > @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>> > >  tests-common += $(TEST_DIR)/gic.flat
>> > >  tests-common += $(TEST_DIR)/psci.flat
>> > >  tests-common += $(TEST_DIR)/sieve.flat
>> > > +tests-common += $(TEST_DIR)/micro-test.flat
>> > >
>> > >  tests-all = $(tests-common) $(tests)
>> > >  all: directories $(tests-all)
>> > > diff --git a/arm/micro-test.c b/arm/micro-test.c
>> > > new file mode 100644
>> > > index 0000000..407ce8b
>> > > --- /dev/null
>> > > +++ b/arm/micro-test.c
>> > > @@ -0,0 +1,252 @@
>> > > +/*
>> > > + * Measure the cost of micro level operations.
>> > > + *
>> > > + * Copyright Columbia University
>> > > + * Author: Shih-Wei Li <shihwei@cs.columbia.edu>
>> > > + * Author: Christoffer Dall <cdall@cs.columbia.edu>
>> > > + *
>> > > + * This work is licensed under the terms of the GNU LGPL, version 2.
>> > > + */
>> > > +#include <asm/gic.h>
>> > > +#include "libcflat.h"
>> > > +#include <util.h>
>> > > +#include <limits.h>
>> > > +
>> > > +static volatile bool ipi_received;
>> > > +static volatile bool ipi_ready;
>> > > +static volatile unsigned int cntfrq;
>> > > +static volatile void *vgic_dist_addr;
>> >
>> > Volatiles considered harmful for kernel code. I think it is also correct
>> > for your case:
>> > https://lwn.net/Articles/234017/
>> >
>> > I would prefer use readl/writel accessors for interprocessor
>> > communications which guaranties cache synchronization and proper
>> > ordering.
>> >
>> > Also, ipi_received and ipi_ready are looking like synchronization
>> > primitives. Did you consider using spinlocks instead?
>> >
>> > Also-also, cntfrq is written only once at init. What for you make it
>> > volatile?
>>
>> We frequently take some shortcuts in kvm-unit-tests, using busy loops and
>> volatile globals for synchronization, trying to keep things as simple as
>> possible. I'm ok with the ipi_* synchronization variables being volatile,
>> but agree the other two don't need to be.
>>
>> >
>> > > +void (*write_eoir)(u32 irqstat);
>> > > +
>> > > +#define IPI_IRQ          1
>> > > +
>> > > +#define TRIES    (1U << 28)
>> > > +
>> > > +#define MAX_FAILURES     1000
>> > > +
>> > > +/*
>> > > + * The counter may not always start with zero, which means it could
>> > > + * overflow after some period of time.
>> > > + */
>> > > +#define COUNT(c1, c2) \
>> > > + ((c1) > (c2) ? 0 : (c2) - (c1))
>> > > +
>> > > +static uint64_t read_cc(void)
>> > > +{
>> > > + isb();
>> > > + return read_sysreg(cntpct_el0);
>> > > +}
>> > > +
>> > > +static void ipi_irq_handler(struct pt_regs *regs __unused)
>> > > +{
>> > > + u32 ack;
>> > > + ipi_ready = false;
>> > > + ipi_received = true;
>> > > + ack = gic_read_iar();
>> > > + gic_write_eoir(ack);
>> > > + ipi_ready = true;
>> > > +}
>> > > +
>> > > +static void ipi_test_secondary_entry(void *data __unused)
>> > > +{
>> > > + enum vector v = EL1H_IRQ;
>> > > + install_irq_handler(v, ipi_irq_handler);
>> > > +
>> > > + gic_enable_defaults();
>> > > +
>> > > + local_irq_enable(); /* Enter small wait-loop */
>> > > + ipi_ready = true;
>> > > + while (true);
>> > > +}
>> > > +
>> > > +static int test_init(void)
>> > > +{
>> > > + int v;
>> > > +
>> > > + v = gic_init();
>> > > + if (v == 2) {
>> > > +         vgic_dist_addr = gicv2_dist_base();
>> > > +         write_eoir = gicv2_write_eoir;
>> > > + } else if (v == 3) {
>> > > +         vgic_dist_addr = gicv3_dist_base();
>> > > +         write_eoir = gicv3_write_eoir;
>> > > + } else {
>> > > +         printf("No supported gic present, skipping tests...\n");
>> > > +         return 0;
>> > > + }
>> > > +
>> > > + ipi_ready = false;
>> > > +
>> > > + gic_enable_defaults();
>> > > + on_cpu_async(1, ipi_test_secondary_entry, 0);
>> > > +
>> > > + cntfrq = get_cntfrq();
>> > > + printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
>> > > +
>> > > + return 1;
>> > > +}
>> > > +
>> > > +static unsigned long ipi_test(void)
>> > > +{
>> > > + unsigned int tries = TRIES;
>> > > + uint64_t c1, c2;
>> > > +
>> > > + while (!ipi_ready && tries--);
>> > > + assert(ipi_ready);
>> > > +
>> > > + ipi_received = false;
>> > > +
>> > > + c1 = read_cc();
>> > > +
>> > > + gic_ipi_send_single(IPI_IRQ, 1);
>> > > +
>> > > + tries = TRIES;
>> > > + while (!ipi_received && tries--);
>> > > + assert(ipi_received);
>> > > +
>> > > + c2 = read_cc();
>> > > + return COUNT(c1, c2);
>> > > +}
>> > > +
>> > > +static unsigned long hvc_test(void)
>> > > +{
>> > > + uint64_t c1, c2;
>> > > +
>> > > + c1 = read_cc();
>> > > + asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
>> > > + c2 = read_cc();
>> > > + return COUNT(c1, c2);
>> > > +}
>> > > +
>> > > +static unsigned long mmio_read_user(void)
>> > > +{
>> > > + uint64_t c1, c2;
>> > > + /*
>> > > +  * FIXME: Read device-id in virtio mmio here. This address
>> > > +  * needs to be updated in the future if any relevent
>> > > +  * changes in QEMU test-dev are made.
>> > > +  */
>> > > + void *mmio_read_user_addr = (void*) 0x0a000008;
>> >
>> > Again, could you rename it? device_id_ptr sounds much better.
>> >
>> > > + c1 = read_cc();
>> > > + readl(mmio_read_user_addr);
>> > > + c2 = read_cc();
>> > > + return COUNT(c1, c2);
>> > > +}
>> > > +
>> > > +static unsigned long mmio_read_vgic(void)
>> > > +{
>> > > + uint64_t c1, c2;
>> > > +
>> > > + c1 = read_cc();
>> > > + readl(vgic_dist_addr + GICD_IIDR);
>> > > + c2 = read_cc();
>> > > + return COUNT(c1, c2);
>> > > +}
>> > > +
>> > > +static unsigned long eoi_test(void)
>> > > +{
>> > > + uint64_t c1, c2;
>> > > +
>> > > + u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
>> > > +
>> > > + /* Avoid measuring assert(..) in gic_write_eoir */
>> > > + c1 = read_cc();
>> > > + write_eoir(val);
>> > > + c2 = read_cc();
>> > > +
>> > > + return COUNT(c1, c2);
>> > > +}
>> > > +
>> > > +struct exit_test {
>> > > + const char *name;
>> > > + unsigned long (*test_fn)(void);
>> > > + bool run;
>> > > +};
>> > > +
>> > > +static struct exit_test tests[] = {
>> > > + {"hvc",                hvc_test,           true},
>> > > + {"mmio_read_user",     mmio_read_user,     true},
>> > > + {"mmio_read_vgic",     mmio_read_vgic,     true},
>> > > + {"eoi",                eoi_test,           true},
>> > > + {"ipi",                ipi_test,           true},
>> > > +};
>> > > +
>> > > +static void get_us_output(const char *name,
>> > > +                   unsigned long cycles)
>> > > +{
>> > > + unsigned int ns_per_cycle = 10^9U / cntfrq;
>> > > + unsigned int ns, us, us_frac;
>> >
>> > '^' is 'xor', you probably mean 1000*1000*1000. And anyway,
>> > ThunderX2 works at ~2GHz, so 10E9/get_cntfrq() is 0 for it.
>>
>> The counter (cntpct_el0) ticks that fast? We could start with picoseconds
>> if necessary.
>>
>> >
>> > For CPUs working at 500...1000 MHz, ns_per_cycle is 1,
>> > For CPUs working at 1GHz+ it is 0. What's point in it?
>>
>> We're not looking at the CPU cycles, we're looking at counter ticks.
>> Indeed we could rename cycles to ticks everywhere to make that more
>> explicit.
>
> Ah, I don't say that counter ticks at CPU frequency on TX2, or
> something like that. I was probably confused by name. But switching to
> picoseconds, or even femtoseconds sounds reasonable anyway.
>
> Yury
