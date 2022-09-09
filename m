Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D712CECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 14:31:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6320D4C5FC;
	Fri,  9 Sep 2022 10:31:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fz+L-qmt3Jo2; Fri,  9 Sep 2022 10:31:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1BAC4C5FD;
	Fri,  9 Sep 2022 10:31:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFD24C169
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 10:31:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qd5++Zl1ZFZu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 10:31:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA4014BE7A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 10:31:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5136E165C;
 Fri,  9 Sep 2022 07:31:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EF3C3F93E;
 Fri,  9 Sep 2022 07:31:26 -0700 (PDT)
Date: Fri, 9 Sep 2022 15:32:18 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
Subject: Re: [PATCH] arm:Add PSCI_CPU_OFF testscase to  arm/psci testsuite.
Message-ID: <YxtOchZQO4bUdKf/@monolith.localdoman>
References: <20220805132601.461751-1-Nikita.Venkatesh@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805132601.461751-1-Nikita.Venkatesh@arm.com>
Cc: "thuth@redhat.com" <thuth@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
 "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, nd <nd@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

The patch doesn't apply on top of master (commit 7362976db651 ("x86/pmu:
Run the "emulation" test iff forced emulation is available")). I think it
doesn't apply correctly because you've used an email client which converts
tabs to spaces.

Another thing that I spotted while trying to figure out what is wrong is
that the encoding is iso-8859-1 (Content-Type: text/plain; charset="iso-8859-1")
instead of us-ascii or utf-8 as per the submitting patches documentation in
the Linux kernel [1]. That's also a good guide to make your email client
play nicely with the mailing lit.

Also, the subject should be in this format:

[kvm-unit-tests PATCH] arm: Add PSCI_CPU_OFF testcase to arm/psci testsuite

Notice the "kvm-unit-tests" prefix (and the missing and added spaces, and
the removed period "." at the end). The prefix should be there as per the
README file. Not a big deal, but it helps with sorting the emails. And it
definitely helps with getting people to notice the patch.

[1] https://github.com/torvalds/linux/blob/master/Documentation/process/email-clients.rst

On Fri, Aug 05, 2022 at 02:26:11PM +0100, Nikita Venkatesh wrote:
> The test uses the following method.
> 
> The primary CPU brings up all the secondary CPUs, which are held in a wait
> loop. Once the primary releases the CPUs, each of the secondary CPUs
> proceed to issue PSCI_CPU_OFF. This is indicated by a cpumask and also
> the status of the call is updated by the secondary CPU in cpu_off_done[].
> 
> The primary CPU waits for all the secondary CPUs to update the cpumask
> and then proceeds to check for the status of the individual CPU CPU_OFF
> request. There is a chance that some CPUs might fail at the CPU_OFF
> request and come back and update the status once the primary CPU has
> finished the scan. There is no fool proof method to handle this. As of
> now, we add a 1sec delay between the cpumask check and the scan for the
> status.
> 
> The test can be triggered by "cpu-off" command line argument.

The logic of the test looks correct to me, and the comments below are all
cosmetic.

What looks rather awkward is that we do the CPU_OFF test separate from the
CPU_ON test. The CPU_ON test already brings online all of the CPUs, doing
that again and as a separate test feels awkward.

I've sent a patch [2] which leaves all the secondary CPUs in do_idle(),
ready to execute another function. You can rework this patch on top of that
one, and have the regular PSCI test do CPU_OFF for all CPUs after the
existing CPU_ON test, which makes more sense to me.

I'm talking about something like this (some parts omitted for brevity):

[..]
+static void secondary_entry_stub (void *unused)
+{
+}
+
 static bool psci_cpu_off_test(void)
 {
        bool failed = false;
@@ -168,7 +172,7 @@ static bool psci_cpu_off_test(void)
        for_each_present_cpu(cpu) {
                if (cpu < 1)
                        continue;
-               smp_boot_secondary(cpu, cpu_off_secondary_test);
+               on_cpu_async(cpu, cpu_off_secondary_test, NULL);
        }

        cpumask_set_cpu(0, &cpu_off_done);

[..]
@@ -221,15 +213,18 @@ int main(int argc, char **argv)
        }

        report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
-                       PSCI_VERSION_MINOR(ver));
-       if (argc < 2) {
-               run_default_psci_tests();
-       } else if (strcmp(argv[1], "cpu-off") == 0) {
-               report(psci_cpu_off_test(), "cpu-off");
+                   PSCI_VERSION_MINOR(ver));
+
+       report(psci_invalid_function(), "invalid-function");
+       report(psci_affinity_info_on(), "affinity-info-on");
+       report(psci_affinity_info_off(), "affinity-info-off");
+       if (ERRATA(6c7a5dce22b3)){
+               report(psci_cpu_on_test(), "cpu-on");
        } else {
-               printf("Unknown subtest\n");
-               abort();
+               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
+               on_cpus(secondary_entry_stub, NULL);
        }
+       report(psci_cpu_off_test(), "cpu-off");

 done:
 #if 0

[2] https://lore.kernel.org/kvm/20220909142925.52198-1-alexandru.elisei@arm.com/

> 
> Signed-off-by: Nikita Venkatesh <Nikita.Venkatesh@arm.com>
> ---
>  arm/psci.c        | 87 +++++++++++++++++++++++++++++++++++++++++------
>  arm/unittests.cfg |  6 ++++
>  2 files changed, 83 insertions(+), 10 deletions(-)
> 
> diff --git a/arm/psci.c b/arm/psci.c
> index efa0722..5485718 100644
> --- a/arm/psci.c
> +++ b/arm/psci.c
> @@ -12,6 +12,9 @@
>  #include <asm/processor.h>
>  #include <asm/smp.h>
>  #include <asm/psci.h>
> +#include <asm/delay.h>
> +
> +#define CPU_OFF_TEST_WAIT_TIME 1000
> 
>  static bool invalid_function_exception;
> 
> @@ -69,8 +72,10 @@ static bool psci_affinity_info_off(void)
>  }
> 
>  static int cpu_on_ret[NR_CPUS];
> -static cpumask_t cpu_on_ready, cpu_on_done;
> +static bool cpu_off_success[NR_CPUS];
> +static cpumask_t cpu_on_ready, cpu_on_done, cpu_off_done;
>  static volatile int cpu_on_start;
> +static volatile int cpu_off_start;
> 
>  static void cpu_on_secondary_entry(void)
>  {
> @@ -83,6 +88,19 @@ static void cpu_on_secondary_entry(void)
>         cpumask_set_cpu(cpu, &cpu_on_done);
>  }
> 
> +static void cpu_off_secondary_test(void)

cpu_off_secondary_entry?

> +{
> +       int cpu = smp_processor_id();

The coding style followed by this file has a newline after local variable
declaration(s).

> +       while (!cpu_off_start)
> +               cpu_relax();
> +       /* On to the CPU off test */
> +       cpu_off_success[cpu] = true;
> +       cpumask_set_cpu(cpu, &cpu_off_done);
> +       cpu_psci_cpu_die();
> +       /* The CPU shouldn't execute the next steps. */
> +       cpu_off_success[cpu] = false;
> +}
> +
>  static bool psci_cpu_on_test(void)
>  {
>         bool failed = false;
> @@ -130,7 +148,56 @@ static bool psci_cpu_on_test(void)
>         return !failed;
>  }
> 
> -int main(void)
> +static bool psci_cpu_off_test(void)
> +{
> +       bool failed = false;
> +       int cpu;
> +
> +       for_each_present_cpu(cpu) {
> +               if (cpu < 1)

I would prefer the test to be if (cpu == 0), as it makes it clear that the
boot CPU is expected to be CPU 0. It also matches the way you express this
test below, in the for loop.

> +                       continue;
> +               smp_boot_secondary(cpu, cpu_off_secondary_test);
> +       }
> +
> +       cpumask_set_cpu(0, &cpu_off_done);
> +
> +       report_info("PSCI OFF Test");

This is not strictly necessary, the psci_cpu_on_tests doesn't have it and
it clutters the output by displaying redundant information. I guess it can
be helpful because the test is rather long (at least 1 second because of
the delay) and we don't want the user to get the impression that the
hanged. How about changing it to
report_info("starting CPU_OFF test..."), which looks similar to what
kvm-unit-tests does for the timer test, which has also has a similar delay?
Up to you really, as this is a matter of taste.

> +
> +       /* Release the CPUs */
> +       cpu_off_start = 1;
> +
> +       /* Wait until all are done */
> +       while (!cpumask_full(&cpu_off_done))
> +               cpu_relax();
> +
> +       /* Allow all the other CPUs to complete the operation */
> +       mdelay(CPU_OFF_TEST_WAIT_TIME);
> +
> +       for_each_present_cpu(cpu) {
> +               if (cpu == 0)
> +                       continue;
> +
> +               if (!cpu_off_success[cpu]) {
> +                       report_info("CPU%d could not be turned off", cpu);
> +                       failed = true;
> +               }
> +       }
> +       return !failed;
> +}
> +
> +static void run_default_psci_tests(void)
> +{
> +       report(psci_invalid_function(), "invalid-function");
> +       report(psci_affinity_info_on(), "affinity-info-on");
> +       report(psci_affinity_info_off(), "affinity-info-off");
> +       if (ERRATA(6c7a5dce22b3)){
> +               report(psci_cpu_on_test(), "cpu-on");
> +       } else {
> +               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> +       }
> +}
> +
> +int main(int argc, char **argv)
>  {
>         int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> 
> @@ -143,15 +210,15 @@ int main(void)
> 
>         report_info("PSCI version %d.%d", PSCI_VERSION_MAJOR(ver),
>                                           PSCI_VERSION_MINOR(ver));
> -       report(psci_invalid_function(), "invalid-function");
> -       report(psci_affinity_info_on(), "affinity-info-on");
> -       report(psci_affinity_info_off(), "affinity-info-off");
> -
> -       if (ERRATA(6c7a5dce22b3))
> -               report(psci_cpu_on_test(), "cpu-on");
> -       else
> -               report_skip("Skipping unsafe cpu-on test. Set ERRATA_6c7a5dce22b3=y to enable.");
> 
> +       if (argc < 2) {
> +               run_default_psci_tests();
> +       } else if (strcmp(argv[1], "cpu-off") == 0) {
> +               report(psci_cpu_off_test(), "cpu-off");
> +       } else {
> +               printf("Unknown subtest\n");
> +               abort();
> +       }

There should be a newline here, as it previously was.

Thanks,
Alex

>  done:
>  #if 0
>         report_summary();
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 5e67b55..02ffbcd 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -218,6 +218,12 @@ file = psci.flat
>  smp = $MAX_SMP
>  groups = psci
> 
> +[psci-cpu-off]
> +file = psci.flat
> +groups = psci
> +smp = $MAX_SMP
> +extra_params = -append 'cpu-off'
> +
>  # Timer tests
>  [timer]
>  file = timer.flat
> --
> 2.25.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
