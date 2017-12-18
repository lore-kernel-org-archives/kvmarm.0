From: "Kalra, Ashish" <Ashish.Kalra@cavium.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: add micro test
Date: Tue, 19 Dec 2017 03:48:59 +0530
Message-ID: <ab19fd8f-2840-11c7-06d3-4448728c9589@cavium.com>
References: <1513372539-10180-1-git-send-email-shihwei@cs.columbia.edu>
 <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9072283891941012532=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B68749D5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 17:15:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3+Qghjl1MZsf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 17:15:35 -0500 (EST)
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0085.outbound.protection.outlook.com [104.47.34.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21F4F49D40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 17:15:35 -0500 (EST)
In-Reply-To: <1513372539-10180-2-git-send-email-shihwei@cs.columbia.edu>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shih-Wei Li <shihwei@cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

This is a multi-part message in MIME format.
--===============9072283891941012532==
Content-Type: multipart/alternative;
 boundary="------------44CDDF15A44F0D8094D713AC"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------44CDDF15A44F0D8094D713AC
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Hello Shih-Wei,

This "micro" test is really useful for micro-architectural performance
measurement of KVM/ARM.

But, to get more accurate cycle counts, it will be preferable to compute
counter read (and isb) overhead and deduct it from the final cycle
count, something like this :

+static unsigned long counter_read_overhead;

+static void compute_counter_read_overhead(void)
+{
+       unsigned long c1, c2;
+
+       c1 = read_cc();
+       c2 = read_cc();
+       counter_read_overhead = c2 - c1;
+}

+#define CYCLE_COUNT(c1, c2) \
+       (((c1) > (c2) || ((c1) == (c2))) ? 0 : ((c2) - (c1)) -
counter_read_overhead )
+

static int test_init(void)
{
         int ret;
         unsigned int timeout = TIMEOUT;

+       compute_counter_read_overhead();
..
..

Thanks,
Ashish

On 12/16/2017 2:45 AM, Shih-Wei Li wrote:
 > Here we provide the support for measuring various micro level
 > operations on arm64. We iterate each of the tests for millions of
 > times and output their average, minimum and maximum cost in timer
 > counts. Instruction barriers are used before and after taking
 > timestamps to avoid out-of-order execution or pipelining from
 > skewing our measurements.
 >
 > The tests we currently support and measure are mostly
 > straightforward by the function names and the respective comments.
 > For IPI test, we measure the cost of sending IPI from a source
 > VCPU to a target VCPU, until the target VCPU receives the IPI.
 >
 > Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
 > ---
 >   arm/Makefile.common |   1 +
 >   arm/micro-test.c    | 289 
++++++++++++++++++++++++++++++++++++++++++++++++++++
 >   arm/unittests.cfg   |   6 ++
 >   3 files changed, 296 insertions(+)
 >   create mode 100644 arm/micro-test.c
 >
 > diff --git a/arm/Makefile.common b/arm/Makefile.common
 > index 0a039cf..c7d5c27 100644
 > --- a/arm/Makefile.common
 > +++ b/arm/Makefile.common
 > @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat
 >   tests-common += $(TEST_DIR)/gic.flat
 >   tests-common += $(TEST_DIR)/psci.flat
 >   tests-common += $(TEST_DIR)/sieve.flat
 > +tests-common += $(TEST_DIR)/micro-test.flat
 >
 >   tests-all = $(tests-common) $(tests)
 >   all: directories $(tests-all)
 > diff --git a/arm/micro-test.c b/arm/micro-test.c
 > new file mode 100644
 > index 0000000..7df2272
 > --- /dev/null
 > +++ b/arm/micro-test.c
 > @@ -0,0 +1,289 @@
 > +#include <util.h>
 > +#include <asm/gic.h>
 > +
 > +static volatile bool second_cpu_up;
 > +static volatile bool first_cpu_ack;
 > +static volatile bool ipi_acked;
 > +static volatile bool ipi_received;
 > +static volatile bool ipi_ready;
 > +#define IPI_IRQ              1
 > +
 > +#define TIMEOUT (1U << 28)
 > +
 > +#define ARR_SIZE(_x) ((int)(sizeof(_x) / sizeof(_x[0])))
 > +#define for_each_test(_iter, _tests, _tmp) \
 > +     for (_tmp = 0, _iter = _tests; \
 > +                     _tmp < ARR_SIZE(_tests); \
 > +                     _tmp++, _iter++)
 > +
 > +#define CYCLE_COUNT(c1, c2) \
 > +     (((c1) > (c2) || ((c1) == (c2))) ? 0 : (c2) - (c1))
 > +
 > +#define IPI_DEBUG 0
 > +
 > +#if IPI_DEBUG == 1
 > +#define debug(fmt, ...) \
 > +     printf("[cpu %d]: " fmt, smp_processor_id(),  ## __VA_ARGS__)
 > +#else
 > +#define debug(fmt, ...) {}
 > +#endif
 > +
 > +static uint64_t read_cc(void)
 > +{
 > +     uint64_t cc;
 > +     asm volatile(
 > +             "isb\n"
 > +             "mrs %0, CNTPCT_EL0\n"
 > +             "isb\n"
 > +             : [reg] "=r" (cc)
 > +             ::
 > +     );
 > +     return cc;
 > +}
 > +
 > +static void ipi_irq_handler(struct pt_regs *regs __unused)
 > +{
 > +     u32 ack;
 > +     ipi_ready = false;
 > +     ipi_received = true;
 > +     ack = gic_read_iar();
 > +     ipi_acked = true;
 > +     gic_write_eoir(ack);
 > +     ipi_ready = true;
 > +}
 > +
 > +static void ipi_test_secondary_entry(void)
 > +{
 > +     unsigned int timeout = TIMEOUT;
 > +
 > +     debug("secondary core up\n");
 > +
 > +     enum vector v = EL1H_IRQ;
 > +     install_irq_handler(v, ipi_irq_handler);
 > +
 > +     gic_enable_defaults();
 > +
 > +     second_cpu_up = true;
 > +
 > +     debug("secondary initialized vgic\n");
 > +
 > +     while (!first_cpu_ack && timeout--);
 > +     if (!first_cpu_ack) {
 > +             debug("ipi_test: First CPU did not ack wake-up\n");
 > +             exit(1);
 > +     }
 > +
 > +     debug("detected first cpu ack\n");
 > +
 > +     local_irq_enable(); /* Enter small wait-loop */
 > +     ipi_ready = true;
 > +     while (true);
 > +}
 > +
 > +static int test_init(void)
 > +{
 > +     int ret;
 > +     unsigned int timeout = TIMEOUT;
 > +
 > +     ret = gic_init();
 > +     if (!ret) {
 > +             debug("No supported gic present, skipping tests...\n");
 > +             goto out;
 > +     }
 > +
 > +     ipi_ready = false;
 > +
 > +     gic_enable_defaults();
 > +
 > +     debug("starting second CPU\n");
 > +     smp_boot_secondary(1, ipi_test_secondary_entry);
 > +
 > +     while (!second_cpu_up && timeout--); /* Wait for second CPU! */
 > +
 > +     if (!second_cpu_up) {
 > +             debug("ipi_test: timeout waiting for secondary CPU\n");
 > +             ret = 0;
 > +             goto out;
 > +     }
 > +
 > +     debug("detected secondary core up\n");
 > +
 > +     first_cpu_ack = true;
 > +
 > +     printf("Timer Frequency %d Hz (Output in timer count)\n", 
get_cntfrq());
 > +
 > +out:
 > +     return ret;
 > +}
 > +
 > +static unsigned long ipi_test(void)
 > +{
 > +     unsigned int timeout = TIMEOUT;
 > +     unsigned long c1, c2;
 > +
 > +     while (!ipi_ready && timeout--);
 > +     if (!ipi_ready) {
 > +             debug("ipi_test: second core not ready for IPIs\n");
 > +             exit(1);
 > +     }
 > +
 > +     ipi_received = false;
 > +
 > +     c1 = read_cc();
 > +
 > +     gic_ipi_send_single(IPI_IRQ, 1);
 > +
 > +     timeout = TIMEOUT;
 > +     while (!ipi_received && timeout--);
 > +     if (!ipi_received) {
 > +             debug("ipi_test: secondary core never received ipi\n");
 > +             exit(1);
 > +     }
 > +
 > +     c2 = read_cc();
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +
 > +static unsigned long hvc_test(void)
 > +{
 > +     unsigned long c1, c2;
 > +
 > +     c1 = read_cc();
 > +     asm volatile("mov w0, #0x4b000000; hvc #0");
 > +     c2 = read_cc();
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +static void __noop(void)
 > +{
 > +}
 > +
 > +static unsigned long noop_guest(void)
 > +{
 > +     unsigned long c1, c2;
 > +
 > +     c1 = read_cc();
 > +     __noop();
 > +     c2 = read_cc();
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +static unsigned long mmio_read_user(void)
 > +{
 > +     unsigned long c1, c2;
 > +     void *mmio_read_user_addr = (void*) 0x0a000008;
 > +
 > +     /* Measure MMIO exit to QEMU in userspace */
 > +     c1 = read_cc();
 > +     readl(mmio_read_user_addr);
 > +     c2 = read_cc();
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +static unsigned long mmio_read_vgic(void)
 > +{
 > +     unsigned long c1, c2;
 > +     int v = gic_version();
 > +     void *vgic_dist_addr = NULL;
 > +
 > +     if (v == 2)
 > +             vgic_dist_addr = gicv2_dist_base();
 > +     else if (v == 3)
 > +             vgic_dist_addr = gicv3_dist_base();
 > +
 > +     /* Measure MMIO exit to host kernel */
 > +     c1 = read_cc();
 > +     readl(vgic_dist_addr + 0x8); /* Read GICD_IIDR */
 > +     c2 = read_cc();
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +static unsigned long eoi_test(void)
 > +{
 > +     unsigned long c1, c2;
 > +     int v = gic_version();
 > +     void (*write_eoir)(u32 irqstat) = NULL;
 > +
 > +     u32 val = 1023; /* spurious IDs, writes to EOI are ignored */
 > +
 > +     if (v == 2)
 > +             write_eoir = gicv2_write_eoir;
 > +     else if (v == 3)
 > +             write_eoir = gicv3_write_eoir;
 > +
 > +     c1 = read_cc();
 > +     write_eoir(val);
 > +     c2 = read_cc();
 > +
 > +     return CYCLE_COUNT(c1, c2);
 > +}
 > +
 > +struct exit_test {
 > +     const char *name;
 > +     unsigned long (*test_fn)(void);
 > +     bool run;
 > +};
 > +
 > +static struct exit_test available_tests[] = {
 > +     {"hvc",                hvc_test,           true},
 > +     {"noop_guest",         noop_guest,         true},
 > +     {"mmio_read_user",     mmio_read_user,     true},
 > +     {"mmio_read_vgic",     mmio_read_vgic,     true},
 > +     {"eoi",                eoi_test,           true},
 > +     {"ipi",                ipi_test,           true},
 > +};
 > +
 > +static void loop_test(struct exit_test *test)
 > +{
 > +     unsigned long i, iterations = 32;
 > +     unsigned long sample, cycles;
 > +     unsigned long long min = 0, max = 0;
 > +     const unsigned long long goal = (1ULL << 29);
 > +
 > +     do {
 > +             iterations *= 2;
 > +             cycles = 0;
 > +             for (i = 0; i < iterations; i++) {
 > +                     sample = test->test_fn();
 > +                     if (sample == 0) {
 > +                             /*
 > +                              * If something went wrong or we had an
 > +                              * overflow, don't count that sample.
 > +                              */
 > +                             iterations--;
 > +                             i--;
 > +                             debug("cycle count overflow: %lu\n", 
sample);
 > +                             continue;
 > +                     }
 > +                     cycles += sample;
 > +                     if (min == 0 || min > sample)
 > +                             min = sample;
 > +                     if (max < sample)
 > +                             max = sample;
 > +             }
 > +     } while (cycles < goal);
 > +     printf("%s:\t avg %lu\t min %llu\t max %llu\n",
 > +             test->name, cycles / (iterations), min, max);
 > +}
 > +
 > +void kvm_unit_test(void)
 > +{
 > +     int i=0;
 > +     struct exit_test *test;
 > +     for_each_test(test, available_tests, i) {
 > +             if (!test->run)
 > +                     continue;
 > +             loop_test(test);
 > +     }
 > +
 > +     return;
 > +}
 > +
 > +int main(int argc, char **argv)
 > +{
 > +     if (!test_init())
 > +             exit(1);
 > +     kvm_unit_test();
 > +     return 0;
 > +}
 > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
 > index 44b98cf..1d0c4ca 100644
 > --- a/arm/unittests.cfg
 > +++ b/arm/unittests.cfg
 > @@ -116,3 +116,9 @@ file = timer.flat
 >   groups = timer
 >   timeout = 2s
 >   arch = arm64
 > +
 > +# Exit tests
 > +[micro-test]
 > +file = micro-test.flat
 > +smp = 2
 > +groups = micro-test
 >

--------------44CDDF15A44F0D8094D713AC
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;
      charset=windows-1252">
    <meta name="Generator" content="Microsoft Exchange Server">
    <!-- converted from text -->
    <style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left: #800000 2px solid; } --></style>
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <font size="2"><span style="font-size:11pt;">
        <div class="PlainText">Hello Shih-Wei,<br>
          <br>
          This "micro" test is really useful for micro-architectural
          performance <br>
          measurement of KVM/ARM.<br>
          <br>
          But, to get more accurate cycle counts, it will be preferable
          to compute<br>
          counter read (and isb) overhead and deduct it from the final
          cycle <br>
          count, something like this :<br>
          <br>
          +static unsigned long counter_read_overhead;<br>
          <br>
          +static void compute_counter_read_overhead(void)<br>
          +{<br>
          +       unsigned long c1, c2;<br>
          +<br>
          +       c1 = read_cc();<br>
          +       c2 = read_cc();<br>
          +       counter_read_overhead = c2 - c1;<br>
          +}<br>
          <br>
          +#define CYCLE_COUNT(c1, c2) \<br>
          +       (((c1) &gt; (c2) || ((c1) == (c2))) ? 0 : ((c2) -
          (c1)) - <br>
          counter_read_overhead )<br>
          +<br>
          <br>
          static int test_init(void)<br>
          {<br>
                  int ret;<br>
                  unsigned int timeout = TIMEOUT;<br>
          <br>
          +       compute_counter_read_overhead();<br>
          ..<br>
          ..<br>
          <br>
          Thanks,<br>
          Ashish<br>
          <br>
          On 12/16/2017 2:45 AM, Shih-Wei Li wrote:<br>
          &gt; Here we provide the support for measuring various micro
          level<br>
          &gt; operations on arm64. We iterate each of the tests for
          millions of<br>
          &gt; times and output their average, minimum and maximum cost
          in timer<br>
          &gt; counts. Instruction barriers are used before and after
          taking<br>
          &gt; timestamps to avoid out-of-order execution or pipelining
          from<br>
          &gt; skewing our measurements.<br>
          &gt; <br>
          &gt; The tests we currently support and measure are mostly<br>
          &gt; straightforward by the function names and the respective
          comments.<br>
          &gt; For IPI test, we measure the cost of sending IPI from a
          source<br>
          &gt; VCPU to a target VCPU, until the target VCPU receives the
          IPI.<br>
          &gt; <br>
          &gt; Signed-off-by: Shih-Wei Li
          <a class="moz-txt-link-rfc2396E" href="mailto:shihwei@cs.columbia.edu">&lt;shihwei@cs.columbia.edu&gt;</a><br>
          &gt; ---<br>
          &gt;   arm/Makefile.common |   1 +<br>
          &gt;   arm/micro-test.c    | 289
          ++++++++++++++++++++++++++++++++++++++++++++++++++++<br>
          &gt;   arm/unittests.cfg   |   6 ++<br>
          &gt;   3 files changed, 296 insertions(+)<br>
          &gt;   create mode 100644 arm/micro-test.c<br>
          &gt; <br>
          &gt; diff --git a/arm/Makefile.common b/arm/Makefile.common<br>
          &gt; index 0a039cf..c7d5c27 100644<br>
          &gt; --- a/arm/Makefile.common<br>
          &gt; +++ b/arm/Makefile.common<br>
          &gt; @@ -16,6 +16,7 @@ tests-common += $(TEST_DIR)/pmu.flat<br>
          &gt;   tests-common += $(TEST_DIR)/gic.flat<br>
          &gt;   tests-common += $(TEST_DIR)/psci.flat<br>
          &gt;   tests-common += $(TEST_DIR)/sieve.flat<br>
          &gt; +tests-common += $(TEST_DIR)/micro-test.flat<br>
          &gt;   <br>
          &gt;   tests-all = $(tests-common) $(tests)<br>
          &gt;   all: directories $(tests-all)<br>
          &gt; diff --git a/arm/micro-test.c b/arm/micro-test.c<br>
          &gt; new file mode 100644<br>
          &gt; index 0000000..7df2272<br>
          &gt; --- /dev/null<br>
          &gt; +++ b/arm/micro-test.c<br>
          &gt; @@ -0,0 +1,289 @@<br>
          &gt; +#include &lt;util.h&gt;<br>
          &gt; +#include &lt;asm/gic.h&gt;<br>
          &gt; +<br>
          &gt; +static volatile bool second_cpu_up;<br>
          &gt; +static volatile bool first_cpu_ack;<br>
          &gt; +static volatile bool ipi_acked;<br>
          &gt; +static volatile bool ipi_received;<br>
          &gt; +static volatile bool ipi_ready;<br>
          &gt; +#define IPI_IRQ              1<br>
          &gt; +<br>
          &gt; +#define TIMEOUT (1U &lt;&lt; 28)<br>
          &gt; +<br>
          &gt; +#define ARR_SIZE(_x) ((int)(sizeof(_x) / sizeof(_x[0])))<br>
          &gt; +#define for_each_test(_iter, _tests, _tmp) \<br>
          &gt; +     for (_tmp = 0, _iter = _tests; \<br>
          &gt; +                     _tmp &lt; ARR_SIZE(_tests); \<br>
          &gt; +                     _tmp++, _iter++)<br>
          &gt; +<br>
          &gt; +#define CYCLE_COUNT(c1, c2) \<br>
          &gt; +     (((c1) &gt; (c2) || ((c1) == (c2))) ? 0 : (c2) -
          (c1))<br>
          &gt; +<br>
          &gt; +#define IPI_DEBUG 0<br>
          &gt; +<br>
          &gt; +#if IPI_DEBUG == 1<br>
          &gt; +#define debug(fmt, ...) \<br>
          &gt; +     printf("[cpu %d]: " fmt, smp_processor_id(),  ##
          __VA_ARGS__)<br>
          &gt; +#else<br>
          &gt; +#define debug(fmt, ...) {}<br>
          &gt; +#endif<br>
          &gt; +<br>
          &gt; +static uint64_t read_cc(void)<br>
          &gt; +{<br>
          &gt; +     uint64_t cc;<br>
          &gt; +     asm volatile(<br>
          &gt; +             "isb\n"<br>
          &gt; +             "mrs %0, CNTPCT_EL0\n"<br>
          &gt; +             "isb\n"<br>
          &gt; +             : [reg] "=r" (cc)<br>
          &gt; +             ::<br>
          &gt; +     );<br>
          &gt; +     return cc;<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static void ipi_irq_handler(struct pt_regs *regs
          __unused)<br>
          &gt; +{<br>
          &gt; +     u32 ack;<br>
          &gt; +     ipi_ready = false;<br>
          &gt; +     ipi_received = true;<br>
          &gt; +     ack = gic_read_iar();<br>
          &gt; +     ipi_acked = true;<br>
          &gt; +     gic_write_eoir(ack);<br>
          &gt; +     ipi_ready = true;<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static void ipi_test_secondary_entry(void)<br>
          &gt; +{<br>
          &gt; +     unsigned int timeout = TIMEOUT;<br>
          &gt; +<br>
          &gt; +     debug("secondary core up\n");<br>
          &gt; +<br>
          &gt; +     enum vector v = EL1H_IRQ;<br>
          &gt; +     install_irq_handler(v, ipi_irq_handler);<br>
          &gt; +<br>
          &gt; +     gic_enable_defaults();<br>
          &gt; +<br>
          &gt; +     second_cpu_up = true;<br>
          &gt; +<br>
          &gt; +     debug("secondary initialized vgic\n");<br>
          &gt; +<br>
          &gt; +     while (!first_cpu_ack &amp;&amp; timeout--);<br>
          &gt; +     if (!first_cpu_ack) {<br>
          &gt; +             debug("ipi_test: First CPU did not ack
          wake-up\n");<br>
          &gt; +             exit(1);<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     debug("detected first cpu ack\n");<br>
          &gt; +<br>
          &gt; +     local_irq_enable(); /* Enter small wait-loop */<br>
          &gt; +     ipi_ready = true;<br>
          &gt; +     while (true);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static int test_init(void)<br>
          &gt; +{<br>
          &gt; +     int ret;<br>
          &gt; +     unsigned int timeout = TIMEOUT;<br>
          &gt; +<br>
          &gt; +     ret = gic_init();<br>
          &gt; +     if (!ret) {<br>
          &gt; +             debug("No supported gic present, skipping
          tests...\n");<br>
          &gt; +             goto out;<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     ipi_ready = false;<br>
          &gt; +<br>
          &gt; +     gic_enable_defaults();<br>
          &gt; +<br>
          &gt; +     debug("starting second CPU\n");<br>
          &gt; +     smp_boot_secondary(1, ipi_test_secondary_entry);<br>
          &gt; +<br>
          &gt; +     while (!second_cpu_up &amp;&amp; timeout--); /*
          Wait for second CPU! */<br>
          &gt; +<br>
          &gt; +     if (!second_cpu_up) {<br>
          &gt; +             debug("ipi_test: timeout waiting for
          secondary CPU\n");<br>
          &gt; +             ret = 0;<br>
          &gt; +             goto out;<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     debug("detected secondary core up\n");<br>
          &gt; +<br>
          &gt; +     first_cpu_ack = true;<br>
          &gt; +<br>
          &gt; +     printf("Timer Frequency %d Hz (Output in timer
          count)\n", get_cntfrq());<br>
          &gt; +<br>
          &gt; +out:<br>
          &gt; +     return ret;<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static unsigned long ipi_test(void)<br>
          &gt; +{<br>
          &gt; +     unsigned int timeout = TIMEOUT;<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +<br>
          &gt; +     while (!ipi_ready &amp;&amp; timeout--);<br>
          &gt; +     if (!ipi_ready) {<br>
          &gt; +             debug("ipi_test: second core not ready for
          IPIs\n");<br>
          &gt; +             exit(1);<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     ipi_received = false;<br>
          &gt; +<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +<br>
          &gt; +     gic_ipi_send_single(IPI_IRQ, 1);<br>
          &gt; +<br>
          &gt; +     timeout = TIMEOUT;<br>
          &gt; +     while (!ipi_received &amp;&amp; timeout--);<br>
          &gt; +     if (!ipi_received) {<br>
          &gt; +             debug("ipi_test: secondary core never
          received ipi\n");<br>
          &gt; +             exit(1);<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +<br>
          &gt; +static unsigned long hvc_test(void)<br>
          &gt; +{<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +     asm volatile("mov w0, #0x4b000000; hvc #0");<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static void __noop(void)<br>
          &gt; +{<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static unsigned long noop_guest(void)<br>
          &gt; +{<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +     __noop();<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static unsigned long mmio_read_user(void)<br>
          &gt; +{<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +     void *mmio_read_user_addr = (void*) 0x0a000008;<br>
          &gt; +<br>
          &gt; +     /* Measure MMIO exit to QEMU in userspace */<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +     readl(mmio_read_user_addr);<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static unsigned long mmio_read_vgic(void)<br>
          &gt; +{<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +     int v = gic_version();<br>
          &gt; +     void *vgic_dist_addr = NULL;<br>
          &gt; +<br>
          &gt; +     if (v == 2)<br>
          &gt; +             vgic_dist_addr = gicv2_dist_base();<br>
          &gt; +     else if (v == 3)<br>
          &gt; +             vgic_dist_addr = gicv3_dist_base();<br>
          &gt; +<br>
          &gt; +     /* Measure MMIO exit to host kernel */<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +     readl(vgic_dist_addr + 0x8); /* Read GICD_IIDR */<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +static unsigned long eoi_test(void)<br>
          &gt; +{<br>
          &gt; +     unsigned long c1, c2;<br>
          &gt; +     int v = gic_version();<br>
          &gt; +     void (*write_eoir)(u32 irqstat) = NULL;<br>
          &gt; +<br>
          &gt; +     u32 val = 1023; /* spurious IDs, writes to EOI are
          ignored */<br>
          &gt; +<br>
          &gt; +     if (v == 2)<br>
          &gt; +             write_eoir = gicv2_write_eoir;<br>
          &gt; +     else if (v == 3)<br>
          &gt; +             write_eoir = gicv3_write_eoir;<br>
          &gt; +<br>
          &gt; +     c1 = read_cc();<br>
          &gt; +     write_eoir(val);<br>
          &gt; +     c2 = read_cc();<br>
          &gt; +<br>
          &gt; +     return CYCLE_COUNT(c1, c2);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +struct exit_test {<br>
          &gt; +     const char *name;<br>
          &gt; +     unsigned long (*test_fn)(void);<br>
          &gt; +     bool run;<br>
          &gt; +};<br>
          &gt; +<br>
          &gt; +static struct exit_test available_tests[] = {<br>
          &gt; +     {"hvc",                hvc_test,           true},<br>
          &gt; +     {"noop_guest",         noop_guest,         true},<br>
          &gt; +     {"mmio_read_user",     mmio_read_user,     true},<br>
          &gt; +     {"mmio_read_vgic",     mmio_read_vgic,     true},<br>
          &gt; +     {"eoi",                eoi_test,           true},<br>
          &gt; +     {"ipi",                ipi_test,           true},<br>
          &gt; +};<br>
          &gt; +<br>
          &gt; +static void loop_test(struct exit_test *test)<br>
          &gt; +{<br>
          &gt; +     unsigned long i, iterations = 32;<br>
          &gt; +     unsigned long sample, cycles;<br>
          &gt; +     unsigned long long min = 0, max = 0;<br>
          &gt; +     const unsigned long long goal = (1ULL &lt;&lt; 29);<br>
          &gt; +<br>
          &gt; +     do {<br>
          &gt; +             iterations *= 2;<br>
          &gt; +             cycles = 0;<br>
          &gt; +             for (i = 0; i &lt; iterations; i++) {<br>
          &gt; +                     sample = test-&gt;test_fn();<br>
          &gt; +                     if (sample == 0) {<br>
          &gt; +                             /*<br>
          &gt; +                              * If something went wrong
          or we had an<br>
          &gt; +                              * overflow, don't count
          that sample.<br>
          &gt; +                              */<br>
          &gt; +                             iterations--;<br>
          &gt; +                             i--;<br>
          &gt; +                             debug("cycle count
          overflow: %lu\n", sample);<br>
          &gt; +                             continue;<br>
          &gt; +                     }<br>
          &gt; +                     cycles += sample;<br>
          &gt; +                     if (min == 0 || min &gt; sample)<br>
          &gt; +                             min = sample;<br>
          &gt; +                     if (max &lt; sample)<br>
          &gt; +                             max = sample;<br>
          &gt; +             }<br>
          &gt; +     } while (cycles &lt; goal);<br>
          &gt; +     printf("%s:\t avg %lu\t min %llu\t max %llu\n",<br>
          &gt; +             test-&gt;name, cycles / (iterations), min,
          max);<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +void kvm_unit_test(void)<br>
          &gt; +{<br>
          &gt; +     int i=0;<br>
          &gt; +     struct exit_test *test;<br>
          &gt; +     for_each_test(test, available_tests, i) {<br>
          &gt; +             if (!test-&gt;run)<br>
          &gt; +                     continue;<br>
          &gt; +             loop_test(test);<br>
          &gt; +     }<br>
          &gt; +<br>
          &gt; +     return;<br>
          &gt; +}<br>
          &gt; +<br>
          &gt; +int main(int argc, char **argv)<br>
          &gt; +{<br>
          &gt; +     if (!test_init())<br>
          &gt; +             exit(1);<br>
          &gt; +     kvm_unit_test();<br>
          &gt; +     return 0;<br>
          &gt; +}<br>
          &gt; diff --git a/arm/unittests.cfg b/arm/unittests.cfg<br>
          &gt; index 44b98cf..1d0c4ca 100644<br>
          &gt; --- a/arm/unittests.cfg<br>
          &gt; +++ b/arm/unittests.cfg<br>
          &gt; @@ -116,3 +116,9 @@ file = timer.flat<br>
          &gt;   groups = timer<br>
          &gt;   timeout = 2s<br>
          &gt;   arch = arm64<br>
          &gt; +<br>
          &gt; +# Exit tests<br>
          &gt; +[micro-test]<br>
          &gt; +file = micro-test.flat<br>
          &gt; +smp = 2<br>
          &gt; +groups = micro-test<br>
          &gt; <br>
        </div>
      </span></font>
  </body>
</html>

--------------44CDDF15A44F0D8094D713AC--

--===============9072283891941012532==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9072283891941012532==--
