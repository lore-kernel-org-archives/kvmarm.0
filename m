From: Shih-Wei Li <shihwei@cs.columbia.edu>
Subject: Re: [PATCH kvm-unit-tests 2/2] arm64: add micro-bench
Date: Mon, 3 Sep 2018 11:06:51 -0400
Message-ID: <CAO+sbHHswsoUqhnwwzB5bGoc7G_cbkw24t6Br1=7bULVxoctaw@mail.gmail.com>
References: <20180830141733.21725-1-drjones@redhat.com>
 <20180830141733.21725-3-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 978094A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 11:07:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sf+Swlr1kNnr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Sep 2018 11:07:30 -0400 (EDT)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9AB2B49F93
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 11:07:30 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w83F7UnK007674
 for <kvmarm@lists.cs.columbia.edu>; Mon, 3 Sep 2018 11:07:30 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 506EF8B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 11:07:30 -0400 (EDT)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 970847E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Sep 2018 11:07:23 -0400 (EDT)
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w83F7Mxl046687
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 3 Sep 2018 11:07:23 -0400
Received: by mail-lf1-f69.google.com with SMTP id a7-v6so130406lfe.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Sep 2018 08:07:23 -0700 (PDT)
In-Reply-To: <20180830141733.21725-3-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Christoffer Dall <cdall@cs.columbia.edu>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Aug 30, 2018 at 10:17 AM, Andrew Jones <drjones@redhat.com> wrote:
> From: Shih-Wei Li <shihwei@cs.columbia.edu>
>
> Here we provide the support for measuring various micro level
> operations on arm64. Measurements are currently obtained using
> timer counters. Further modifications in KVM will be required
> to support timestamping using cycle counters, as KVM now disables
> accesses to the PMU counters from the VM.
>
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <cdall@cs.columbia.edu>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/Makefile.arm64 |   1 +
>  arm/micro-bench.c  | 213 +++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg  |   8 ++
>  3 files changed, 222 insertions(+)
>  create mode 100644 arm/micro-bench.c
>
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index f04bbf476763..637435c523da 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -15,6 +15,7 @@ OBJDIRS += lib/arm64
>
>  # arm64 specific tests
>  tests = $(TEST_DIR)/timer.flat
> +tests += $(TEST_DIR)/micro-bench.flat
>
>  include $(SRCDIR)/$(TEST_DIR)/Makefile.common
>
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> new file mode 100644
> index 000000000000..76650d647f6a
> --- /dev/null
> +++ b/arm/micro-bench.c
> @@ -0,0 +1,213 @@
> +/*
> + * Measure the cost of micro level operations.
> + *
> + * This test provides support for quantifying the cost of micro level
> + * operations. To improve precision in the measurements, one should
> + * consider pinning each VCPU to a specific physical CPU (PCPU) and to
> + * ensure no other task could run on that PCPU to skew the results.
> + * This can be achieved by enabling QMP server in the QEMU command in
> + * unittest.cfg for micro-bench, allowing a client program to get the
> + * thread_id for each VCPU thread from the QMP server. Based on that
> + * information, the client program can then pin the corresponding VCPUs to
> + * dedicated PCPUs and isolate interrupts and tasks from those PCPUs.
> + *
> + * Copyright Columbia University
> + * Author: Shih-Wei Li <shihwei@cs.columbia.edu>
> + * Author: Christoffer Dall <cdall@cs.columbia.edu>
> + * Author: Andrew Jones <drjones@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/gic.h>
> +
> +#define NTIMES (1U << 16)
> +
> +static u32 cntfrq;
> +
> +static volatile bool ipi_ready, ipi_received;
> +static void *vgic_dist_base;
> +static void (*write_eoir)(u32 irqstat);
> +
> +static void ipi_irq_handler(struct pt_regs *regs)
> +{
> +       ipi_ready = false;
> +       ipi_received = true;
> +       gic_write_eoir(gic_read_iar());
> +       ipi_ready = true;
> +}
> +
> +static void ipi_secondary_entry(void *data)
> +{
> +       install_irq_handler(EL1H_IRQ, ipi_irq_handler);
> +       gic_enable_defaults();
> +       local_irq_enable();
> +       ipi_ready = true;
> +       while (true)
> +               cpu_relax();
> +}
> +
> +static bool test_init(void)
> +{
> +       int v = gic_init();
> +
> +       if (!v) {
> +               printf("No supported gic present, skipping tests...\n");
> +               return false;
> +       }
> +
> +       if (nr_cpus < 2) {
> +               printf("At least two cpus required, skipping tests...\n");
> +               return false;
> +       }
> +
> +       switch (v) {
> +       case 2:
> +               vgic_dist_base = gicv2_dist_base();
> +               write_eoir = gicv2_write_eoir;
> +       case 3:
> +               vgic_dist_base = gicv3_dist_base();
> +               write_eoir = gicv3_write_eoir;
> +       }

I think we'll need a "break" in the switch case body for gicv2 here
otherwise it'll fall into the case body below and refer to the wrong
symbols for gicv3.

As I've tested on my seattle server hardware (with gicv2), this results
to incorrect execution in mmio_read_vgic_exec and a crash in
eoi_exec().

> +
> +       ipi_ready = false;
> +       gic_enable_defaults();
> +       on_cpu_async(1, ipi_secondary_entry, NULL);
> +
> +       cntfrq = get_cntfrq();
> +       printf("Timer Frequency %d Hz (Output in microseconds)\n", cntfrq);
> +
> +       return true;
> +}
> +
> +static void ipi_prep(void)
> +{
> +       unsigned tries = 1 << 28;
> +
> +       while (!ipi_ready && tries--)
> +               cpu_relax();
> +       assert(ipi_ready);
> +}
> +
> +static void ipi_exec(void)
> +{
> +       unsigned tries = 1 << 28;
> +       static int received = 0;
> +
> +       ipi_received = false;
> +
> +       gic_ipi_send_single(1, 1);
> +
> +       while (!ipi_received && tries--)
> +               cpu_relax();
> +
> +       ++received;
> +       assert_msg(ipi_received, "failed to receive IPI in time, but received %d successfully\n", received);
> +}
> +
> +static void hvc_exec(void)
> +{
> +       asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> +}
> +
> +static void mmio_read_user_exec(void)
> +{
> +       /*
> +        * FIXME: Read device-id in virtio mmio here in order to
> +        * force an exit to userspace. This address needs to be
> +        * updated in the future if any relevant changes in QEMU
> +        * test-dev are made.
> +        */
> +       void *userspace_emulated_addr = (void*)0x0a000008;
> +
> +       readl(userspace_emulated_addr);
> +}
> +
> +static void mmio_read_vgic_exec(void)
> +{
> +       readl(vgic_dist_base + GICD_IIDR);
> +}
> +
> +static void eoi_exec(void)
> +{
> +       int spurious_id = 1023; /* writes to EOI are ignored */
> +
> +       /* Avoid measuring assert(..) in gic_write_eoir */
> +       write_eoir(spurious_id);
> +}
> +
> +struct exit_test {
> +       const char *name;
> +       void (*prep)(void);
> +       void (*exec)(void);
> +       bool run;
> +};
> +
> +static struct exit_test tests[] = {
> +       {"hvc",                 NULL,           hvc_exec,               true},
> +       {"mmio_read_user",      NULL,           mmio_read_user_exec,    true},
> +       {"mmio_read_vgic",      NULL,           mmio_read_vgic_exec,    true},
> +       {"eoi",                 NULL,           eoi_exec,               true},
> +       {"ipi",                 ipi_prep,       ipi_exec,               true},
> +};
> +
> +struct ns_time {
> +       uint64_t ns;
> +       uint64_t ns_frac;
> +};
> +
> +#define PS_PER_SEC (1000 * 1000 * 1000 * 1000U)
> +static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
> +{
> +       uint64_t ps_per_tick = PS_PER_SEC / cntfrq + !!(PS_PER_SEC % cntfrq);
> +       uint64_t ps;
> +
> +       ps = ticks * ps_per_tick;
> +       ns_time->ns = ps / 1000;
> +       ns_time->ns_frac = (ps % 1000) / 100;
> +}
> +
> +static void loop_test(struct exit_test *test)
> +{
> +       uint64_t start, end, total_ticks, ntimes = NTIMES;
> +       struct ns_time total_ns, avg_ns;
> +
> +       if (test->prep)
> +               test->prep();
> +
> +       isb();
> +       start = read_sysreg(cntpct_el0);
> +       while (ntimes--)
> +               test->exec();
> +       isb();
> +       end = read_sysreg(cntpct_el0);
> +
> +       total_ticks = end - start;
> +       ticks_to_ns_time(total_ticks, &total_ns);
> +       avg_ns.ns = total_ns.ns / NTIMES;
> +       avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
> +
> +       printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
> +               test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       int i;
> +
> +       if (!test_init())
> +               return 1;
> +
> +       printf("\n%-30s%18s%13s%18s%13s\n", "name", "total ns", "", "avg ns", "");
> +       for (i = 0 ; i < 92; ++i)
> +               printf("%c", '-');
> +       printf("\n");
> +       for (i = 0; i < ARRAY_SIZE(tests); i++) {
> +               if (!tests[i].run)
> +                       continue;
> +               assert(tests[i].name && tests[i].exec);
> +               loop_test(&tests[i]);
> +       }
> +
> +       return 0;
> +}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 44b98cfc7afd..5c8a332da004 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -116,3 +116,11 @@ file = timer.flat
>  groups = timer
>  timeout = 2s
>  arch = arm64
> +
> +# Exit tests
> +[micro-bench]
> +file = micro-bench.flat
> +smp = 2
> +groups = nodefault,micro-bench
> +accel = kvm
> +arch = arm64
> --
> 2.17.1
>
