From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 5/7] lib: arm: Fallback to
 psci_system_off() in exit()
Date: Fri, 25 Jan 2019 16:31:37 +0100
Message-ID: <20190125153137.dakwla2ozmd22vq2@kamzik.brq.redhat.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
 <20190124111634.4727-6-alexandru.elisei@arm.com>
 <20190124130020.5gjoblt5lqqujzqw@kamzik.brq.redhat.com>
 <20190124133511.3izvap4y2crqrbbp@kamzik.brq.redhat.com>
 <6cf2fe9d-9c35-ae42-6cb4-d34dfdc2df3b@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB3574A3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:31:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DbGnUI0mzD1y for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 10:31:43 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4312D4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:31:43 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <6cf2fe9d-9c35-ae42-6cb4-d34dfdc2df3b@arm.com>
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

On Fri, Jan 25, 2019 at 02:56:30PM +0000, Alexandru Elisei wrote:
> 
> On 1/24/19 1:35 PM, Andrew Jones wrote:
> > On Thu, Jan 24, 2019 at 02:00:20PM +0100, Andrew Jones wrote:
> >> [..]
> >> chr_testdev_init() ensures vcon is NULL if it fails to initialize.
> >> chr_testdev_exit() immediately returns if vcon is NULL. This was
> >> done by design to allow fallback exits to be placed below the
> >> chr_testdev_exit call, e.g. halt().
> >>
> >> We should be able to drop patch 3/7 and change exit() to this
> >>
> >>   void exit(int code)
> >>   {
> >>       chr_testdev_exit(code);
> >>       psci_system_off();
> >>       halt(code);
> >>       __builtin_unreachable();
> >>   }
> >>
> > There's also a framework for exits that can't return status codes. powerpc
> > uses it. Before exiting with psci_system_off we need to make this print
> > statement
> >
> >  printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1); 
> >
> > And run_qemu in arm/run needs to be changed to run_qemu_status. It's
> > hacky, but maybe we can live with it until kvmtool offers some sort of
> > debug exit.
> >
> > Thanks,
> > drew
> 
> I can make the change, but if I understand the scripts/arch-run.bash code
> correctly, run_qemu() will check if QEMU was terminated because of a signal and
> adjust the return code to take that into account. Using run_qemu_status() means
> that check won't be made when the tests are run under QEMU, is that acceptable?
>

run_qemu_status() first calls run_qemu(). If the return value from
run_qemu() is 1, then it'll change the value to whatever the EXIT:
status line says it should be. If run_qemu() detected that a signal
caused the exit, then the return value won't be 1. In that case
run_qemu_status() will simply propagate the value to the caller.

It might be worth doing a few tests to ensure that all works out as
designed, but I'm pretty sure it should.

Thanks,
drew
