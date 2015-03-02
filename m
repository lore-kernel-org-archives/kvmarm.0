From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 00/18] arm/arm64: add smp support
Date: Mon, 2 Mar 2015 08:22:52 -0800
Message-ID: <20150302162252.GA9686@lvm>
References: <1422815686-24591-1-git-send-email-drjones@redhat.com>
 <20150226113402.GA3143@cbox>
 <20150226135037.GF3023@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4BF24756C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:17:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lk7avXD6fBK2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Mar 2015 11:17:09 -0500 (EST)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
 [209.85.216.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B06294755A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Mar 2015 11:17:09 -0500 (EST)
Received: by qcxm20 with SMTP id m20so25343023qcx.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 Mar 2015 08:23:07 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20150226135037.GF3023@hawk.usersys.redhat.com>
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
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 26, 2015 at 02:50:38PM +0100, Andrew Jones wrote:
> On Thu, Feb 26, 2015 at 12:34:02PM +0100, Christoffer Dall wrote:
> > On Sun, Feb 01, 2015 at 07:34:28PM +0100, Andrew Jones wrote:
> > > This series extends the kvm-unit-tests/arm[64] framework to support smp.
> > > A break down of the patches is as follows
> > > 
> > > 01-02: prepare general framework for smp use
> > > 03-06: arm/arm64 fixups not 100% related to this series,
> > >        but need to post some time...
> > > 07-09: add thread_info (for per-thread data) and suck some global
> > >        data into it
> > > 10-11: add cpumask support (for per-cpu data) and suck some more
> > >        global data in
> > >    12: add arm64 simple spinlock implementation
> > > 13-14: add some PSCI support
> > > 15-16: further prep for smp_boot_secondary
> > >    17: finally add smp_boot_secondary
> > >    18: as usual, add a selftest to make sure it all works
> > > 
> > > These patches are also available here:
> > > https://github.com/rhdrjones/kvm-unit-tests/tree/arm/smp
> > > 
> > I've tested these patches on Juno and they seem to run fine, however,
> > since we don't support big.LITTLE yet, you have to run them under
> > 'taskset <mask>', but the config script uses $(getconf
> > _NPROCESSORS_CONF), which returns 6, and QEMU fails.  The interesting
> 
> Should I try to read the number of host cpus from some other source?
> If you know something I can read that also works on big.LITTLE, then
> I can change it now.
> 

I have no idea what the right scripting fix would be. But we should
really fix big.LITTLE support in KVM.  Hmmm.

> > bit is that the unit-tests still report 'PASS' - not sure why.
> 
> Ah, this is due to the weird way qemu's debugexit device sets its exit
> code
> 
> hw/misc/debugexit.c:debug_exit_write()
> {
>   exit((val << 1) | 1);
> }
> 
> To be consistent with that we made chr-testdev do the same thing (see
> backends/testdev.c:testdev_eat_packet():case 'q'). Now, the
> kvm-unit-tests run_tests.sh script knows about that, so it has
> 
>   eval $cmdline >> test.log
>   if [ $? -le 1 ]; then
>      echo -e "\e[32mPASS\e[0m $1"
>   else
>      echo -e "\e[31mFAIL\e[0m $1"
>   fi
> 
> Yes, this sucks, as we can't tell the difference between qemu failing
> to run the test, and exiting with 1 vs. the test running, passing -
> exiting with (0 << 1) | 1. It's too bad debugexit didn't set a higher
> bit (like 5 or 6) to flag a "debug exit". Maybe it's not too late to
> change it? Paolo?
> 

This would be really good to address somehow, because we don't want
to report that everything is happy when the test harness broke, that
really goes against the whole idea of this work.

Thanks,
-Christoffer
