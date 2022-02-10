Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1417EC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 10 Feb 2022 17:48:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D6A49F17;
	Thu, 10 Feb 2022 12:48:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qb3uIcjrufOA; Thu, 10 Feb 2022 12:48:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 956AC49F0A;
	Thu, 10 Feb 2022 12:48:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B53349E08
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:48:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hkllTnxQle+9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Feb 2022 12:48:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B1240F9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Feb 2022 12:48:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CEE9D6E;
 Thu, 10 Feb 2022 09:48:21 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB0473F70D;
 Thu, 10 Feb 2022 09:48:19 -0800 (PST)
Date: Thu, 10 Feb 2022 17:48:35 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <YgVP8zy6N4fL66Wk@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YgVPPCTJG7UFRkhQ@monolith.localdoman>
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

On Thu, Feb 10, 2022 at 05:45:47PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > configuring the tests. If the rename is not acceptable, I can think of a
> > > few other options:
> > 
> > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > seems like it would be sufficient.

I missed this bit in my earlier reply, I like --efi better. I would also like to
hear the opinion of the people who added EFI support before reworking the patch.

> > 
> > > 1. Rename --target to --vmm. That was actually the original name for the
> > > option, but I changed it because I thought --target was more generic and
> > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > to run as an EFI payload. I realize now that separating the VMM from
> > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > a test runner, so I think the impact on users should be minimal.
> > 
> > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > compiler, usurping that for something similar but slightly different is odd.
> 
> Wouldn't that mean that --target-efi is equally confusing? Do you have
> suggestions for other names?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
