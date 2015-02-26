From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [kvm-unit-tests PATCH 00/18] arm/arm64: add smp support
Date: Thu, 26 Feb 2015 12:34:02 +0100
Message-ID: <20150226113402.GA3143@cbox>
References: <1422815686-24591-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2678246ABD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 06:28:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QvQjT-qJVZJq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 06:28:19 -0500 (EST)
Received: from mail-la0-f51.google.com (mail-la0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAB2146AB2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 06:28:18 -0500 (EST)
Received: by labgf13 with SMTP id gf13so10252278lab.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 03:34:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1422815686-24591-1-git-send-email-drjones@redhat.com>
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

On Sun, Feb 01, 2015 at 07:34:28PM +0100, Andrew Jones wrote:
> This series extends the kvm-unit-tests/arm[64] framework to support smp.
> A break down of the patches is as follows
> 
> 01-02: prepare general framework for smp use
> 03-06: arm/arm64 fixups not 100% related to this series,
>        but need to post some time...
> 07-09: add thread_info (for per-thread data) and suck some global
>        data into it
> 10-11: add cpumask support (for per-cpu data) and suck some more
>        global data in
>    12: add arm64 simple spinlock implementation
> 13-14: add some PSCI support
> 15-16: further prep for smp_boot_secondary
>    17: finally add smp_boot_secondary
>    18: as usual, add a selftest to make sure it all works
> 
> These patches are also available here:
> https://github.com/rhdrjones/kvm-unit-tests/tree/arm/smp
> 
I've tested these patches on Juno and they seem to run fine, however,
since we don't support big.LITTLE yet, you have to run them under
'taskset <mask>', but the config script uses $(getconf
_NPROCESSORS_CONF), which returns 6, and QEMU fails.  The interesting
bit is that the unit-tests still report 'PASS' - not sure why.

I'm fine with merging these and fixing anything up as we go along - this
is a test harness after all and I don't have time for an in-depth review
of these patches right now, sorry.

-Christoffer
