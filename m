Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D510C43334
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jun 2022 17:03:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB5A84B250;
	Tue, 21 Jun 2022 13:03:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y3rmJ+TdJPtP; Tue, 21 Jun 2022 13:03:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8964B1E0;
	Tue, 21 Jun 2022 13:03:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 953EE4B19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:03:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xKpbR8+-DPX8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 13:03:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 456644B0D9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 13:03:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A835A165C;
 Tue, 21 Jun 2022 10:03:30 -0700 (PDT)
Received: from [10.57.84.82] (unknown [10.57.84.82])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61A923F792;
 Tue, 21 Jun 2022 10:03:26 -0700 (PDT)
Message-ID: <f085b553-da9b-553f-17e2-1f4c43b25271@arm.com>
Date: Tue, 21 Jun 2022 18:03:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH v4 kvmtool 00/12] arm64: Allow the user to set RAM base
 address
To: Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com, maz@kernel.org, julien@xen.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 james.morse@arm.com, andre.przywara@arm.com
References: <20220616134828.129006-1-alexandru.elisei@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20220616134828.129006-1-alexandru.elisei@arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 16/06/2022 14:48, Alexandru Elisei wrote:
> The series can be found at [1]. It is loosely based on the patches that
> allow the user to define the VM memory layout (RAM + MMIO) [2]. I've
> cherry-picked a handful of patches from that series, the rest I wrote from
> scratch since there have been several changes to the way guest memory is
> handled. I've chosen to focus on specifying the RAM layout with only one
> RAM bank and leave the rest for a later series because this was relatively
> easy to accomplish, while still being very useful.
> 
> What this series does: for arm64, the user can now specify the base address
> for RAM:
> 
> $ ./lkvm run -m1G@2G .. # Equivalent to ./lkvm run -m1024
> 
> The memory units are B (bytes), K (kilobytes), M (megabytes), G
> (gigabytes), T (terrabytes), P (petabytes). Lowercase is also valid.
> 
> Want to put RAM at the top of the physical address range? Easy:
> 
> $ ./lkvm run -m2G@1022G .. # Assumes the maximum is 40 bits of IPA
> 
> There one limitation on the RAM base address: it must not overlap with the
> MMIO range that kvmtool uses for arm/arm64, which lives below 2GB.
> 
> Why this is useful, in my opinion:
> 
> 1. Testing how a payload handles different memory layouts without the need
> to hack kvmtool or find the hardware that implements the desired layout.
> 
> 2. It can serve as a development tool for adding support for larger PA
> ranges for Linux and KVM (currently capped at 48 bits for 4k/16k pages), or
> other payloads.
> 
> Summary of the series
> ======================
> 
> * The series starts with refactoring how kvm->cfg.ram_size is validated
>    and used, followed by several cleanups in the arm and arm64 code.
> 
> * Then patch #8 ("builtin_run: Allow standard size specifiers for memory")
>    introduced the ability to specify the measurement unit for memory. I
>    believe that typing the equivalent of 2TB in megabytes isn't appealing
>    for anyone.
> 
> * More cleanups in the arm/arm64 code follow, which are needed for patch
>    #12 ("arm64: Allow the user to specify the RAM base address"). This is
>    where the ability to specify the RAM base address is introduced.
> 
> Testing
> =======
> 
> Same testing as before:
> 
> - Build tested each patch for all architectures.
> 
> - Ran an x86 kernel with and without setting the amount of RAM using the
>    memory specifiers; tested that setting the RAM address results in an
>    error.
> 
> - Ran an arm64 kernel without setting the size, with setting the size and
>    with setting the size and address; tried different addresses (2G, 3G,
>    256G); also tested that going below 2G or above the maximum IPA correctly
>    results in an error.
> 
> - Ran all arm64 kvm-unit-test tests with similar combinations of memory
>    size and address (instead of 256G I used 128G, as that's where I/O lives
>    for qemu and kvm-unit-tests maps that unconditionally as I/O).
> 
> - Ran all 32bit arm tests on an arm64 host with various combinations of
>    memory size and address (base address at 2G and 2.5G only due to a
>    limitation in the way the tests are set up).

I have tested this series on arm64 Fast model, with memory placed from
32bit to 48bit IPA and it works well.

For the series:

Reviewed-and-Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
