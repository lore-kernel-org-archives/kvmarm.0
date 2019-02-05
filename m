From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/5] arm/arm64: Add support for running
 under kvmtool
Date: Tue, 5 Feb 2019 13:38:49 +0100
Message-ID: <20190205123849.jot674sttflwygfy@kamzik.brq.redhat.com>
References: <20190204134412.47877-1-alexandru.elisei@arm.com>
 <20190204143926.sfnfgqruevqtnao5@kamzik.brq.redhat.com>
 <059b5122-2d02-f417-9980-8ef5ceba5379@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D334A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 07:38:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I6-uSm2BmHx9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Feb 2019 07:38:54 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0FA774A214
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Feb 2019 07:38:54 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <059b5122-2d02-f417-9980-8ef5ceba5379@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 05, 2019 at 12:05:35PM +0000, Alexandru Elisei wrote:
> On 2/4/19 2:39 PM, Andrew Jones wrote:
> > On Mon, Feb 04, 2019 at 01:44:07PM +0000, Alexandru Elisei wrote:
> >> kvm-unit-tests is designed to be run with QEMU as the virtual machine
> >> monitor. It relies on devices emulated by QEMU (like isa-debug-exit or
> >> testdev) and it makes certain assumptions based on the implicit QEMU
> >> virtual environment configuration (like the serial base address).
> >>
> >> kvmtool [1] is a lightweight virtual machine monitor for running KVM
> >> guests. kvmtool has reduced complexity compared to QEMU and is easily
> >> hackable.
> >>
> >> This patch series aims to make it possible to run kvm-unit-tests using
> >> kvmtool on the arm and arm64 architectures, with two caveats:
> >>
> >> (1) When terminating a test, the userspace process won't exit with an exit
> >> code that signals the success or failure of the test. Output from the test
> >> can still be parsed to determine the outcome of the test.
> >>
> >> (2) kvmtool has been designed to work with a linux guest and it
> >> automatically generates the command line arguments for a Linux kernel. The
> >> arm/arm64 selftest and gic tests will fail if unexpected command line
> >> arguments are found. To get around this limitation, the test binary needs
> >> to be loaded using the --firmware option introduced by kvmtool in commit
> >> 5e4b563d75b9 ("arm: Allow command line for firmware"). This option
> >> suppresses the automatic kernel command line and can be used to run all
> >> tests, not just the tests that require specific arguments.
> >>
> >> The run scripts haven't been modified. To run a test under kvmtool, one
> >> needs to launch kvmtool manually. For example, to run the timer test the
> >> following command can be used:
> >>
> >> lkvm run --cpus 1 --console serial --firmware timer.flat.
> >>
> >> To run the gicv3-ipi test:
> >>
> >> lkvm run --cpus 8 --console serial --params "ipi" --irqchip gicv3 \
> >>     --firmware gic.flat
> > This looks good to me. I tested with lkvm and saw that all tests were able
> > to run and pass, except pci-test since lkvm doesn't have pci-testdev. The
> > only other issue was selftest.vectors-user which ends in user mode and
> > thus can't make the PSCI call to exit. The following patch can get that
> > to work if lkvm users want it
> >
> > diff --git a/arm/selftest.c b/arm/selftest.c
> > index ea5101ef7217..7ba3f02a9b9d 100644
> > --- a/arm/selftest.c
> > +++ b/arm/selftest.c
> > @@ -272,10 +272,18 @@ static bool check_svc(void)
> >  }
> >  #endif
> >  
> > +static void user_psci_off(struct pt_regs *regs, unsigned int esr)
> > +{
> > +       psci_system_off();
> I was wondering if it's worth checking that the cause for the unknown exception
> was actually the instruction hvc #0 from user space. Getting the function id
> from x0/r0 is trivial, and we could also check the opcode from the memory
> location pointed to by the pc.
> > +       halt();
> > +}
> > +
> >  static void check_vectors(void *arg __unused)
> >  {
> >         report("und", check_und());
> >         report("svc", check_svc());
> > +       if (is_user())
> > +               install_exception_handler(EL0_SYNC_64, ESR_EL1_EC_UNKNOWN, user_psci_off);
> >         exit(report_summary());
> >  }
> 
> Thank you for posting this, when I started playing with kvm-unit-tests I noticed
> that selftest-vectors-user isn't working, but I totally forgot about it. I am
> interested in the patch, do you want to write the patch yourself? If not, I can
> pick it up and submit it.

I'll post it as 6/5 of this series. Have you reviewed/tested it? I.e. any
tags you'd like me to add to the posting?

Thanks,
drew

> 
> >
> >
> > Anyway, thanks for submitting these patches to enable another user of
> > kvm-unit-tests.
> >
> > drew
> >
> >
> >> Changes in v3:
> >> * Updated cover letter with information about the kvmtool --firmware
> >>   option.
> >> * Gathered Reviewed-by tags.
> >> * Renamed the config.h define UART_EARLY_BASE to CONFIG_UART_EARLY_BASE and
> >>   made the necessary casts in lib/arm/io.c
> >>
> >> Changes in v2:
> >> * Generate lib/config.h when configuring kvm-unit-tests; arm/arm64 uses it
> >>   to get the UART address.
> >> * Added --vmm configure option for arm/arm64 which will set the UART
> >>   address in lib/config.h when the tests are run under QEMU or kvmtool.
> >> * Renamed psci_sys_reset() to psci_system_reset().
> >> * Dropped patches that allowed a test to ignore unexpected command line
> >>   arguments.
> >>
> >> Summary:
> >> * Patches 1, 2 and 3 add support for configuring kvm-unit-tests on arm and
> >>   arm64 to use the ns16550a UART emulated by kvmtool.
> >> * Patches 4 and 5 provide an alternative mechanism for terminating the
> >>   virtual machine by using PSCI.
> >>
> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/
> >> [2] https://www.spinics.net/lists/kvm-arm/msg34352.html
> >>
> >> Alexandru Elisei (5):
> >>   lib: arm: Use UART address from generated config.h
> >>   configure: arm/arm64: Add --vmm option with no effect
> >>   lib: arm: Use ns16550a UART when --vmm=kvmtool
> >>   lib: arm: Implement PSCI SYSTEM_OFF in psci_system_off()
> >>   lib: arm: Fallback to psci_system_off() in exit()
> >>
> >>  configure          | 32 ++++++++++++++++++++++++++++++++
> >>  Makefile           |  2 +-
> >>  lib/arm/asm/psci.h |  3 ++-
> >>  lib/arm/io.c       | 41 ++++++++++++++++++++++++++---------------
> >>  lib/arm/psci.c     |  8 +++++++-
> >>  .gitignore         |  1 +
> >>  6 files changed, 69 insertions(+), 18 deletions(-)
> >>
> >> -- 
> >> 2.17.0
> >>
