From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] arm/arm64: Use argv_find() for test
 names
Date: Thu, 24 Jan 2019 13:43:34 +0000
Message-ID: <20190124134334.271ba99f@donnerap.cambridge.arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-8-alexandru.elisei@arm.com>
 <20190124130732.cjht5dc77m72s2kj@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4810D4A3CC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 08:43:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yxWbMEP2w5s1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 08:43:40 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B034A3B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 08:43:40 -0500 (EST)
In-Reply-To: <20190124130732.cjht5dc77m72s2kj@kamzik.brq.redhat.com>
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
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 24 Jan 2019 14:07:32 +0100
Andrew Jones <drjones@redhat.com> wrote:

> On Thu, Jan 24, 2019 at 11:16:34AM +0000, Alexandru Elisei wrote:
> > Instead of aborting the test when an unexpected parameter is found,
> > use argv_find() to search for the desired parameter. On arm and
> > arm64, this allows kvm-unit-tests to be used with virtual machine
> > monitors like kvmtool which automatically adds parameters to the
> > kernel command line.
> > 
> > For example, to run the gicv3-ipi test the following command was
> > used:
> > 
> > lkvm run -k gic.flat -c 8 -m 410 -p "ipi" --irqchip=gicv3
> > 
> > The resulting kernel command line that was passed to kvm-unit-tests
> > was:
> > 
> > "console=ttyS0 rw
> > rootflags=trans=virtio,version=9p2000.L,cache=loose rootfstype=9p
> > init=/virt/init  ip=dhcp ipi"  
> 
> Why not write a patch for kvmtool that provides a new command line
> parameter which says to not add any kernel parameters other than what
> is provided with '-p'? Giving the user full control over the kernel
> command line seems like a feature kvmtool would want anyway.

Thanks, that was the reply I was hoping for ;-)
Gives me some leverage to justify the corresponding kvmtool patch.

Actually we are about to gain the --firmware switch for ARM in kvmtool,
and I am looking at piggy-backing on that.

Cheers,
Andre.

> > 
> > Without the patch, the following error occurs:
> > "ABORT: gicv3: Unknown subtest 'console=ttyS0'"
> > 
> > With the patch, the test is able to run.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/gic.c      |  7 ++++---
> >  arm/selftest.c | 19 ++++++++++++-------
> >  2 files changed, 16 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index ed5642e74f70..f3746de4bfd8 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -12,6 +12,7 @@
> >   * This work is licensed under the terms of the GNU LGPL, version
> > 2. */
> >  #include <libcflat.h>
> > +#include <argv.h>
> >  #include <asm/setup.h>
> >  #include <asm/processor.h>
> >  #include <asm/delay.h>
> > @@ -533,13 +534,13 @@ int main(int argc, char **argv)
> >  	if (argc < 2)
> >  		report_abort("no test specified");
> >  
> > -	if (strcmp(argv[1], "ipi") == 0) {
> > +	if (argv_find("ipi", argc, argv) != -1) {
> >  		report_prefix_push(argv[1]);
> >  		nr_cpu_check(2);
> >  		on_cpus(ipi_test, NULL);
> > -	} else if (strcmp(argv[1], "active") == 0) {
> > +	} else if (argv_find("active", argc, argv) != -1) {
> >  		run_active_clear_test();
> > -	} else if (strcmp(argv[1], "mmio") == 0) {
> > +	} else if (argv_find("mmio", argc, argv) != -1) {
> >  		report_prefix_push(argv[1]);
> >  		gic_test_mmio();
> >  		report_prefix_pop();
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index ea5101ef7217..44b2f23ca115 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -8,6 +8,7 @@
> >  #include <libcflat.h>
> >  #include <util.h>
> >  #include <devicetree.h>
> > +#include <argv.h>
> >  #include <asm/setup.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/asm-offsets.h>
> > @@ -319,28 +320,32 @@ static void cpu_report(void *data __unused)
> >  
> >  int main(int argc, char **argv)
> >  {
> > +	int pos;
> > +
> >  	report_prefix_push("selftest");
> >  
> >  	if (argc < 2)
> >  		report_abort("no test specified");
> >  
> > -	report_prefix_push(argv[1]);
> > -
> > -	if (strcmp(argv[1], "setup") == 0) {
> > +	if ((pos = argv_find("setup", argc, argv)) != -1) {
> >  
> > -		check_setup(argc-2, &argv[2]);
> > +		report_prefix_push("setup");
> > +		check_setup(argc-(pos+1), &argv[pos+1]);
> >  
> > -	} else if (strcmp(argv[1], "vectors-kernel") == 0) {
> > +	} else if (argv_find("vectors-kernel", argc, argv) != -1) {
> >  
> > +		report_prefix_push("vectors-kernel");
> >  		check_vectors(NULL);
> >  
> > -	} else if (strcmp(argv[1], "vectors-user") == 0) {
> > +	} else if (argv_find("vectors-user", argc, argv) != -1) {
> >  
> > +		report_prefix_push("vectors-user");
> >  		start_usr(check_vectors, NULL,
> >  				(unsigned
> > long)thread_stack_alloc()); 
> > -	} else if (strcmp(argv[1], "smp") == 0) {
> > +	} else if (argv_find("smp", argc, argv) != -1) {
> >  
> > +		report_prefix_push("smp");
> >  		report("PSCI version", psci_check());
> >  		on_cpus(cpu_report, NULL);
> >  
> > -- 
> > 2.17.0
> >   
