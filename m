Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83F1C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Feb 2022 12:14:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C8749E2A;
	Thu, 17 Feb 2022 07:14:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sCYzwDdyQvXK; Thu, 17 Feb 2022 07:14:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8B6A49E27;
	Thu, 17 Feb 2022 07:14:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2A9549E1B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 07:14:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NkCIgixugjWN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 07:14:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A81410F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 07:14:31 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACD50113E;
 Thu, 17 Feb 2022 04:14:30 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1BD3F66F;
 Thu, 17 Feb 2022 04:14:28 -0800 (PST)
Date: Thu, 17 Feb 2022 12:14:47 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/4] configure changes and rename
 --target-efi
Message-ID: <Yg48KawN1+u+sL53@monolith.localdoman>
References: <20220210150943.1280146-1-alexandru.elisei@arm.com>
 <YgVKmjBnAjITQcm+@google.com>
 <YgVPPCTJG7UFRkhQ@monolith.localdoman>
 <CAEDJ5ZSR=rw_ALjBcLgeVz9H6TS67eWvZW2SvGTJV468WjgyKw@mail.gmail.com>
 <YgVpJDIfUVzVvFdx@google.com>
 <CAEDJ5ZRkuCbmPzZXz0x2XUXqjKoi+O+Uq_SNkNW_We2mSv4aRg@mail.gmail.com>
 <f326daff-8384-4666-fc5e-6b7b509f6fe8@redhat.com>
 <YgaMqwbWts3vQ6fD@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YgaMqwbWts3vQ6fD@google.com>
Cc: Thomas Huth <thuth@redhat.com>, Zixuan Wang <zxwang42@gmail.com>,
 kvm list <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
 Paolo Bonzini <pbonzini@redhat.com>, Varad Gautam <varad.gautam@suse.com>
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

On Fri, Feb 11, 2022 at 04:19:55PM +0000, Sean Christopherson wrote:
> On Fri, Feb 11, 2022, Thomas Huth wrote:
> > On 10/02/2022 20.48, Zixuan Wang wrote:
> > > On Thu, Feb 10, 2022 at 11:36 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > 
> > > > On Thu, Feb 10, 2022, Zixuan Wang wrote:
> > > > > On Thu, Feb 10, 2022 at 11:05 AM Alexandru Elisei
> > > > > <alexandru.elisei@arm.com> wrote:
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > On Thu, Feb 10, 2022 at 05:25:46PM +0000, Sean Christopherson wrote:
> > > > > > > On Thu, Feb 10, 2022, Alexandru Elisei wrote:
> > > > > > > > I renamed --target-efi to --efi-payload in the last patch because I felt it
> > > > > > > > looked rather confusing to do ./configure --target=qemu --target-efi when
> > > > > > > > configuring the tests. If the rename is not acceptable, I can think of a
> > > > > > > > few other options:
> > > > > > > 
> > > > > > > I find --target-efi to be odd irrespective of this new conflict.  A simple --efi
> > > > > > > seems like it would be sufficient.
> > > > > > > 
> > > > > > > > 1. Rename --target to --vmm. That was actually the original name for the
> > > > > > > > option, but I changed it because I thought --target was more generic and
> > > > > > > > that --target=efi would be the way going forward to compile kvm-unit-tests
> > > > > > > > to run as an EFI payload. I realize now that separating the VMM from
> > > > > > > > compiling kvm-unit-tests to run as an EFI payload is better, as there can
> > > > > > > > be multiple VMMs that can run UEFI in a VM. Not many people use kvmtool as
> > > > > > > > a test runner, so I think the impact on users should be minimal.
> > > > > > > 
> > > > > > > Again irrespective of --target-efi, I think --target for the VMM is a potentially
> > > > > > > confusing name.  Target Triplet[*] and --target have specific meaning for the
> > > > > > > compiler, usurping that for something similar but slightly different is odd.
> > > > > > 
> > > > > > Wouldn't that mean that --target-efi is equally confusing? Do you have
> > > > > > suggestions for other names?
> > > > > 
> > > > > How about --config-efi for configure, and CONFIG_EFI for source code?
> > > > > I thought about this name when I was developing the initial patch, and
> > > > > Varad also proposed similar names in his initial patch series [1]:
> > > > > --efi and CONFIG_EFI.
> > > > 
> > > > I don't mind CONFIG_EFI for the source, that provides a nice hint that it's a
> > > > configure option and is familiar for kernel developers.  But for the actually
> > > > option, why require more typing?  I really don't see any benefit of --config-efi
> > > > over --efi.
> > > 
> > > I agree, --efi looks better than --target-efi or --config-efi.
> > 
> > <bikeshedding>
> > Or maybe --enable-efi ... since configure scripts normally take
> > "--enable-..." or "--disable-..." parameters for stuff like this?
> > </bikeshedding>
> 
> I don't hate it :-)  It'll also future-proof things if we ever make UEFI the
> default for x86.

Thank you all for the feedback.

I'll respin the series and rename --target-efi to --enable-efi.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
