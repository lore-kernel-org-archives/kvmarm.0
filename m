Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CF6FC43334
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 09:27:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D8DA04B39B;
	Wed, 22 Jun 2022 05:27:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HfCYOC4iDLap; Wed, 22 Jun 2022 05:27:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0904B332;
	Wed, 22 Jun 2022 05:27:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADFE4B27F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 05:27:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hy6IT12A4ogW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 05:27:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 145D84B178
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 05:27:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3E1613D5;
 Wed, 22 Jun 2022 02:27:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93E1B3F66F;
 Wed, 22 Jun 2022 02:27:32 -0700 (PDT)
Date: Wed, 22 Jun 2022 10:27:59 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 kvmtool 00/12] arm64: Allow the user to set RAM base
 address
Message-ID: <YrLgn1auBFx0B8l1@monolith.localdoman>
References: <20220616134828.129006-1-alexandru.elisei@arm.com>
 <f085b553-da9b-553f-17e2-1f4c43b25271@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f085b553-da9b-553f-17e2-1f4c43b25271@arm.com>
Cc: julien@xen.org, maz@kernel.org, andre.przywara@arm.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Suzuki, Will,

On Tue, Jun 21, 2022 at 06:03:22PM +0100, Suzuki K Poulose wrote:
> On 16/06/2022 14:48, Alexandru Elisei wrote:
> > The series can be found at [1]. It is loosely based on the patches that
> > allow the user to define the VM memory layout (RAM + MMIO) [2]. I've
> > cherry-picked a handful of patches from that series, the rest I wrote from
> > scratch since there have been several changes to the way guest memory is
> > handled. I've chosen to focus on specifying the RAM layout with only one
> > RAM bank and leave the rest for a later series because this was relatively
> > easy to accomplish, while still being very useful.
> > 
> > What this series does: for arm64, the user can now specify the base address
> > for RAM:
> > 
> > $ ./lkvm run -m1G@2G .. # Equivalent to ./lkvm run -m1024
> > 
> > The memory units are B (bytes), K (kilobytes), M (megabytes), G
> > (gigabytes), T (terrabytes), P (petabytes). Lowercase is also valid.
> > 
> > Want to put RAM at the top of the physical address range? Easy:
> > 
> > $ ./lkvm run -m2G@1022G .. # Assumes the maximum is 40 bits of IPA
> > 
> > There one limitation on the RAM base address: it must not overlap with the
> > MMIO range that kvmtool uses for arm/arm64, which lives below 2GB.
> > 
> > Why this is useful, in my opinion:
> > 
> > 1. Testing how a payload handles different memory layouts without the need
> > to hack kvmtool or find the hardware that implements the desired layout.
> > 
> > 2. It can serve as a development tool for adding support for larger PA
> > ranges for Linux and KVM (currently capped at 48 bits for 4k/16k pages), or
> > other payloads.
> > 
> > Summary of the series
> > ======================
> > 
> > * The series starts with refactoring how kvm->cfg.ram_size is validated
> >    and used, followed by several cleanups in the arm and arm64 code.
> > 
> > * Then patch #8 ("builtin_run: Allow standard size specifiers for memory")
> >    introduced the ability to specify the measurement unit for memory. I
> >    believe that typing the equivalent of 2TB in megabytes isn't appealing
> >    for anyone.
> > 
> > * More cleanups in the arm/arm64 code follow, which are needed for patch
> >    #12 ("arm64: Allow the user to specify the RAM base address"). This is
> >    where the ability to specify the RAM base address is introduced.
> > 
> > Testing
> > =======
> > 
> > Same testing as before:
> > 
> > - Build tested each patch for all architectures.
> > 
> > - Ran an x86 kernel with and without setting the amount of RAM using the
> >    memory specifiers; tested that setting the RAM address results in an
> >    error.
> > 
> > - Ran an arm64 kernel without setting the size, with setting the size and
> >    with setting the size and address; tried different addresses (2G, 3G,
> >    256G); also tested that going below 2G or above the maximum IPA correctly
> >    results in an error.
> > 
> > - Ran all arm64 kvm-unit-test tests with similar combinations of memory
> >    size and address (instead of 256G I used 128G, as that's where I/O lives
> >    for qemu and kvm-unit-tests maps that unconditionally as I/O).
> > 
> > - Ran all 32bit arm tests on an arm64 host with various combinations of
> >    memory size and address (base address at 2G and 2.5G only due to a
> >    limitation in the way the tests are set up).
> 
> I have tested this series on arm64 Fast model, with memory placed from
> 32bit to 48bit IPA and it works well.
> 
> For the series:
> 
> Reviewed-and-Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Thank you for the review and testing!

Will, do you want me to respin the series to gather all the Reviewed-by and
Tested-by tags?

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
