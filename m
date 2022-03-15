Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A47C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 16:31:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29AC549F15;
	Tue, 15 Mar 2022 12:31:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DPm99gkwlA5J; Tue, 15 Mar 2022 12:31:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D441A49EC3;
	Tue, 15 Mar 2022 12:31:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3303049EC3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 12:31:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g6nE4UdOLsNv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 12:31:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E25249E35
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 12:31:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06BCC1474;
 Tue, 15 Mar 2022 09:31:02 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 04F7C3F766;
 Tue, 15 Mar 2022 09:31:00 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:31:34 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arch-run: Introduce QEMU_ARCH
Message-ID: <YjC62NycFfevZ4wx@monolith.localdoman>
References: <20220315080152.224606-1-drjones@redhat.com>
 <YjCHcV3iyTtSrw3k@monolith.localdoman>
 <20220315151630.obxraie6ikqrwtrw@gator>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220315151630.obxraie6ikqrwtrw@gator>
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

On Tue, Mar 15, 2022 at 04:16:30PM +0100, Andrew Jones wrote:
> On Tue, Mar 15, 2022 at 12:33:17PM +0000, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Tue, Mar 15, 2022 at 09:01:52AM +0100, Andrew Jones wrote:
> > > Add QEMU_ARCH, which allows run scripts to specify which architecture
> > > of QEMU should be used. This is useful on AArch64 when running with
> > > KVM and running AArch32 tests. For those tests, we *don't* want to
> > > select the 'arm' QEMU, as would have been selected, but rather the
> > > $HOST ('aarch64') QEMU.
> > > 
> > > To use this new variable, simply ensure it's set prior to calling
> > > search_qemu_binary().
> > 
> > Looks good, tested on an arm64 machine, with ACCEL set to tcg -
> > run_tests.sh selects qemu-system-arm; ACCEL unset - run_tests.sh selects
> > ACCEL=kvm and qemu-system-aarch64; also tested on an x86 machine -
> > run_tests.sh selects ACCEL=tcg and qemu-system-arm:
> > 
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > 
> > One thing I noticed is that if the user sets QEMU=qemu-system-arm on an arm64
> > machine, run_tests.sh still selects ACCEL=kvm which leads to the following
> > failure:
> > 
> > SKIP selftest-setup (qemu-system-arm: -accel kvm: invalid accelerator kvm)
> > 
> > I'm not sure if this deserves a fix, if the user set the QEMU variable I
> > believe it is probable that the user is also aware of the ACCEL variable
> > and the error message does a good job explaining what is wrong.
> 
> Yes, we assume the user selected the wrong qemu, rather than assuming the
> user didn't expect KVM to be enabled. If we're wrong, then the error
> message should hopefully imply to the user that they need to do
> 
>  QEMU=qemu-system-arm ACCEL=tcg ...

Yep, it was very easy to figure out what needs to be done to get the tests
running again.

> 
> > Just in
> > case, this is what I did to make kvm-unit-tests pick the right accelerator
> > (copied-and-pasted the find_word function from scripts/runtime.bash):
> > 
> > diff --git a/arm/run b/arm/run
> > index 94adcddb7399..b0c9613b8d28 100755
> > --- a/arm/run
> > +++ b/arm/run
> > @@ -10,6 +15,10 @@ if [ -z "$KUT_STANDALONE" ]; then
> >  fi
> >  processor="$PROCESSOR"
> > 
> > +if [ -z $ACCEL ] && [ "$HOST" = "aarch64" ] && ! find_word "qemu-system-arm" "$QEMU"; then
> 
> Instead of find_word,
> 
>  [ "$QEMU" ] && [ "$(basename $QEMU)" = "qemu-system-arm" ]
> 
> > +       ACCEL=tcg
> > +fi
> > +
> 
> When ACCEL is unset, we currently set it to kvm when we have /dev/kvm and
> $HOST == $ARCH_NAME or ($HOST == aarch64 && $ARCH == arm) and tcg
> otherwise. Adding logic like the above would allow overriding the
> "set to kvm" logic when $QEMU == qemu-system-arm. That makes sense to
> me, but we trade one assumption for another. We would now assume that
> $QEMU is correct and the user wants to run with TCG, rather than that
> $QEMU is wrong and the user wanted to run with KVM.
> 
> I think I'd prefer not adding the special case override. I think it's
> more likely the user expects to run with KVM when running on an AArch64
> host and that they mistakenly selected the wrong qemu, than that they
> wanted TCG with qemu-system-arm. We also avoid a few more lines of code
> and a change in behavior by maintaining the old assumption.

Well, kvm-unit-tests selects KVM or TCG under the hood without the user
being involved at all. In my opinion, it's slightly better from an
usability perspective for kvm-unit-tests to do its best to run the tests
based on what the user specifically set (QEMU=qemu-system-arm) than fail to
run the tests because of an internal heuristic of which the user might be
entirely ignorant (if arm64 and /dev/kvm is available, pick ACCEL=kvm).

Regardless, I don't have a strong opinion either way, and it's trivial for
a user to figure out that ACCEL=tcg will make the tests run. So from my
side this is mostly academic and the test runner can stay as it is if you
don't see a reason to change it.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
