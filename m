Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7B5C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 17:45:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B177649F3D;
	Thu, 10 Feb 2022 12:45:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xSTaHX1KzfTi; Thu, 10 Feb 2022 12:45:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CC5A49EF6;
	Thu, 10 Feb 2022 12:45:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F4C349EF2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:45:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Znrf9IRs6CAT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 12:45:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9214740B80
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:45:33 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1378AD6E;
 Thu, 10 Feb 2022 09:45:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A8FC3F718;
 Thu, 10 Feb 2022 09:45:31 -0800 (PST)
Date: Thu, 10 Feb 2022 17:45:47 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YgVKmjBnAjITQcm+@google.com>
Cc: thuth@redhat.com, kvm@vger.kernel.org, zixuanwang@google.com,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, varad.gautam@suse.com
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

On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > looked rather confusing to do ./configure --target=qemu --target-efi when
> > configuring the tests. If the rename is not acceptable, I can think of a
> > few other options:
> 
> I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> seems like it would be sufficient.
> 
> > 1. Rename --target to --vmm. That was actually the original name for the
> > option, but I changed it because I thought --target was more generic and
> > that --target=efi would be the way going forward to compile kvm-unit-tests
> > to run as an EFI payload. I realize now that separating the VMM from
> > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > a test runner, so I think the impact on users should be minimal.
> 
> Again irrespective of --target-efi, I think --target for the VMM is a potentially
> confusing name.  Target Triplet[*] and --target have specific meaning for the
> compiler, usurping that for something similar but slightly different is odd.

Wouldn't that mean that --target-efi is equally confusing? Do you have
suggestions for other names?

> 
> But why is the VMM specified at ./configure time?  Why can't it be an option to
> run_tests.sh?  E.g. --target-efi in configure makes sense because it currently
> requires different compilation options, but even that I hope we can someday change
> so that x86-64 always builds EFI-friendly tests.  I really don't want to get to a
> point where tests themselves have to be recompiled to run under different VMMs.

Setting the VMM at configure time was initially added to remove a warning
from lib/arm/io.c, where if the UART address if different than what
kvm-unit-tests expects the test would print:

WARNING: early print support may not work. Found uart at 0x1000000, but early base is 0x9000000.

kvmtool emulates a different UART, at a different address than what qemu
emulates, and kvm-unit-tests compares the address found in the DTB with the
qemu UART's address (the address is used to be a #define lib/arm/io.c, now
it's generated at configure time in lib/config.h).

On top of that, configuring kvm-unit-tests to run under kvmtool will also
set CONFIG_ERRATA_FORCE to 1. At the time when kvmtool support was added,
kvmtool didn't have support for running a test with an initrd from which to
extract erratas. This has been recently fixed in kvmtool, now it can run a
test with an initrd.

Thanks,
Alex

> 
> [*] https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/html_node/Specifying-Target-Triplets.html
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
