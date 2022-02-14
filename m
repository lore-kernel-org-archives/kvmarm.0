Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D67C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 10:20:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0398A49E17;
	Mon, 14 Feb 2022 05:20:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7zHyspc2xNYC; Mon, 14 Feb 2022 05:20:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D83949E2A;
	Mon, 14 Feb 2022 05:20:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B0149B26
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 05:20:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QdHKqNmGKpOh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 05:20:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2407F40AFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 05:20:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D9281396;
 Mon, 14 Feb 2022 02:20:08 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40E593F718;
 Mon, 14 Feb 2022 02:20:06 -0800 (PST)
Date: Mon, 14 Feb 2022 10:20:24 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH v2 kvmtool 00/10] arm64: Improve PMU support on
 heterogeneous systems
Message-ID: <Ygos2TDwGK//LvSK@monolith.localdoman>
References: <20220127162033.54290-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220127162033.54290-1-alexandru.elisei@arm.com>
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

The KVM patches were picked up, I'm hoping they land in v5.18-rc1. I'll
send a new version of the kvmtool series when that happens. I would really
appreciate some sort of review before the next iteration.

Thanks,
Alex

On Thu, Jan 27, 2022 at 04:20:23PM +0000, Alexandru Elisei wrote:
> The series can be found at [1], and the Linux patches that this series is
> based on at [2].
> 
> The series adds support for the KVM_ARM_VCPU_PMU_V3_SET_PMU PMU attribute,
> which allows userspace to set a PMU for a VCPU. This PMU is used by KVM
> when creating perf events to emulate the guest PMU.
> 
> Without settings this attribute, the PMU used when creating events is the
> first one that successfully probed when booting, but this is unreliable as
> the probe order can change (if the order of the PMUs is changed in the DTB
> or if asynchronous driver probing is enabled on the host's command line),
> and furthermore it requires the user to have intimate knowledge of how the
> PMU was chosen in order to pin the VM on the correct physical CPUs.
> 
> With KVM_ARM_VCPU_PMU_V3_SET_PMU, the user is still expected to pin the
> VCPUs on a particular set of CPUs, but now it can be any CPUs as long as
> they share the same PMU. The set does not depend anymore on the driver
> probe order and all that is necessary for the user to know is which CPUs
> are the little core and which are the big cores, in a big.little
> configuration, which I believe is more reasonable.
> 
> Patches #1-#2 are fixes and can be taken independently of this series.
> 
> Patches #3-#6 move the PMU code to aarch64, where it belongs, because the
> PMU has never been supported on KVM for arm. This also paves the way for
> pulling in the KVM_ARM_VCPU_PMU_V3_SET_PMU attribute, which was not defined
> for KVM for arm (when KVM supported arm). This also can be merged right
> now, independently of the other patches.
> 
> Patch #7 adds the cpumask_* functions which are necessary for subsequent
> patches.
> 
> Patch #9 adds basic support for KVM_ARM_VCPU_PMU_V3_SET_PMU; the user is
> still expected to use taskset to pin the entire VM to the correct CPUs.
> 
> Patch #10 adds --vcpu-affinity command line argument to pin VCPUs to the
> correct CPUs without pinning the rest of the kvmtool threads.
> 
> Changes since v1:
> 
> * Patch #2 ("bitops.h: Include wordsize.h to provide the __WORDSIZE
>   define") is new.
> 
> * Added for_each_cpu(), cpumask_and() and cpumask_subset() functions and
>   all the cpumask_* functions are added in one patch.
> 
> * Bumped NR_CPUS fro arm64 to 4096 to match the Linux Kconfig option.
> 
> * Reworked the way kvmtool specific header files were included to use
>   quotes to clearly differentiate them from the system level headers and to
>   keep the style consistent with the current code (for example, #include
>   <linux/bitops.h> is now "linux/bitops.h").
> 
> * Patch #10 ("arm64: Add --vcpu-affinity command line argument") is new.
> 
> [1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/pmu-big-little-fix-v2
> [2] https://gitlab.arm.com/linux-arm/linux-ae/-/tree/pmu-big-little-fix-v4
> 
> Alexandru Elisei (10):
>   linux/err.h: Add missing stdbool.h include
>   bitops.h: Include wordsize.h to provide the __WORDSIZE define
>   arm: Move arch specific VCPU features to the arch specific function
>   arm: Get rid of the ARM_VCPU_FEATURE_FLAGS() macro
>   arm: Make the PMUv3 emulation code arm64 specific
>   arm64: Rework set_pmu_attr()
>   Add cpumask functions
>   update_headers.sh: Sync headers with Linux v5.17-rc1 + SET_PMU
>     attribute
>   arm64: Add support for KVM_ARM_VCPU_PMU_V3_SET_PMU
>   arm64: Add --vcpu-affinity command line argument
> 
>  Makefile                                      |   6 +-
>  arm/aarch32/include/asm/kernel.h              |   8 +
>  arm/aarch32/include/kvm/kvm-cpu-arch.h        |   4 -
>  arm/aarch64/arm-cpu.c                         |   3 +-
>  arm/aarch64/include/asm/kernel.h              |   8 +
>  arm/aarch64/include/asm/kvm.h                 |   4 +
>  .../arm-common => aarch64/include/asm}/pmu.h  |   0
>  arm/aarch64/include/kvm/kvm-config-arch.h     |   5 +
>  arm/aarch64/include/kvm/kvm-cpu-arch.h        |   6 -
>  arm/aarch64/kvm-cpu.c                         |  21 ++
>  arm/aarch64/kvm.c                             |  32 +++
>  arm/aarch64/pmu.c                             | 231 ++++++++++++++++
>  arm/include/arm-common/kvm-arch.h             |   7 +
>  arm/include/arm-common/kvm-config-arch.h      |   1 +
>  arm/kvm-cpu.c                                 |  14 +-
>  arm/pmu.c                                     |  76 ------
>  include/linux/bitmap.h                        |  71 +++++
>  include/linux/bitops.h                        |   4 +
>  include/linux/bits.h                          |   8 +
>  include/linux/cpumask.h                       |  67 +++++
>  include/linux/err.h                           |   2 +
>  include/linux/find.h                          |  30 ++
>  include/linux/kernel.h                        |   6 +
>  include/linux/kvm.h                           |  16 ++
>  mips/include/asm/kernel.h                     |   8 +
>  powerpc/include/asm/kernel.h                  |   8 +
>  util/bitmap.c                                 | 256 ++++++++++++++++++
>  util/find.c                                   |  40 +++
>  x86/include/asm/kernel.h                      |   8 +
>  x86/include/asm/kvm.h                         |  16 +-
>  30 files changed, 867 insertions(+), 99 deletions(-)
>  create mode 100644 arm/aarch32/include/asm/kernel.h
>  create mode 100644 arm/aarch64/include/asm/kernel.h
>  rename arm/{include/arm-common => aarch64/include/asm}/pmu.h (100%)
>  create mode 100644 arm/aarch64/pmu.c
>  delete mode 100644 arm/pmu.c
>  create mode 100644 include/linux/bitmap.h
>  create mode 100644 include/linux/bits.h
>  create mode 100644 include/linux/cpumask.h
>  create mode 100644 include/linux/find.h
>  create mode 100644 mips/include/asm/kernel.h
>  create mode 100644 powerpc/include/asm/kernel.h
>  create mode 100644 util/bitmap.c
>  create mode 100644 util/find.c
>  create mode 100644 x86/include/asm/kernel.h
> 
> -- 
> 2.31.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
