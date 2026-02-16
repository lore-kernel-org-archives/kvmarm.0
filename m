Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A3725771;
	Mon, 16 Feb 2026 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771245220; cv=none; b=rVi7iA8nVCrng5QwA+qpcs7qbDmxs0rWTdZ7s/52jp+fZgypfQojLQrwFS9/uUS9L2YabndzounMoZDrQGy5PEzVlZh6NfOaX0aWRN6wH/1fU345JMqp1C/Jj7/Hemjf9WWhsSBrV/ZE7GTxtPsmtQ5Xo1mw37aIVvfxAxgfGhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771245220; c=relaxed/simple;
	bh=oVulCBIAyL2Z3oHyKN1bQey3QNZZKFbQdOzacwJbT6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T8Z2u0rWmk4jZSOws0Z2MW8YJqt14u8AX8iRBSNRKCZfop+FF54gx5F3YR3J5rVFstVhbErA+KSU7MGvr0P8Qc1Me0mwsmAEitubLoHsbzQgyXwvlis3qDsOy7Uvt6dkiYtspuD/s9luWGpURZmxDLIuhD3d592Pg5MZtgtW25U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CBC5150C;
	Mon, 16 Feb 2026 04:33:31 -0800 (PST)
Received: from [10.57.56.155] (unknown [10.57.56.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 014843F73F;
	Mon, 16 Feb 2026 04:33:32 -0800 (PST)
Message-ID: <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
Date: Mon, 16 Feb 2026 12:33:31 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <aY4Sf4lMlWd9LyTo@p14s>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <aY4Sf4lMlWd9LyTo@p14s>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/02/2026 17:48, Mathieu Poirier wrote:
> Hi Steven,
> 
> On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
>> following feedback from Marc.
>>
>> The main change is that rather than providing a multiplex CAP and
>> expecting the VMM to drive the different stages of realm construction,
>> there's now just a minimal interface and KVM performs the necessary
>> operations when needed.
>>
>> This series is lightly tested and is meant as a demonstration of the new
>> uAPI. There are a number of (known) rough corners in the implementation
>> that I haven't dealt with properly.
>>
>> In particular please note that this series is still targetting RMM v1.0.
>> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
>> that there are a number of blockers for merging with RMM v1.0 and so I
>> expect to rework this series to support RMM v2.0 before it is merged.
>> That will necessarily involve reworking the implementation.
>>
>> Specifically I'm expecting improvements in:
>>
>>  * GIC handling - passing state in registers, and allowing the host to
>>    fully emulate the GIC by allowing trap bits to be set.
>>
>>  * PMU handling - again providing flexibility to the host's emulation.
>>
>>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
>>    RMM v2.0 provide the option for the host to change the granule size.
>>    The intention is that Linux would simply set the granule size equal
>>    to its page size which will significantly simplify the management of
>>    granules.
>>
>>  * Some performance improvement from the use of range-based map/unmap
>>    RMI calls.
>>
>> This series is based on v6.19-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
>>
>> Work in progress changes for kvmtool are available from the git
>> repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10
> 
> The first thing to note is that branch cca/v10 does not compile due to function
> realm_configure_parameters() not being called anywhere.  Marking the function as
> [[maybe_unused]] solved the problem on my side.

This is in the kvmtool code - and yes I agree "work in progress" is a
bit generous for the current state of that code, "horrid ugly hacks to
get things working" is probably more accurate ;)

The issue here is that the two things that realm_configure_parameters()
set up (hash algorithm and RPV) are currently unsupported with the Linux
changes, but will need to be reintroduced in the future. So the contents
of the functions which set this up (using the old uAPI) are just #if 0'd
out.

Depending on the compile flags the code will compile with a warning, but
using __attribute__((unused)) would at least make this clear. I'd want
to avoid the "[[maybe_unused]]" as it's not used elsewhere in the code
base and limits compatibility.

> Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
> worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
> from lkvm, mounting the initrd fails.  Looking into this issue further, I see
> that from a Realm kernel's perspective, the content of the initrd is either
> encrypted or has been trampled on.  

I can reproduce that, a quick fix is to change INITRD_ALIGN:

#define INITRD_ALIGN	SZ_64K

But the code was meant to be able to deal with an unaligned initrd -
I'll see if I can figure out what's going wrong.

Thanks,
Steve

> I'd be happy to provide more details on the above, just let me know.
> 
> Thanks,
> Mathieu
> 
>>
>> [1] https://developer.arm.com/documentation/den0137/latest/
>>
>> Jean-Philippe Brucker (7):
>>   arm64: RMI: Propagate number of breakpoints and watchpoints to
>>     userspace
>>   arm64: RMI: Set breakpoint parameters through SET_ONE_REG
>>   arm64: RMI: Initialize PMCR.N with number counter supported by RMM
>>   arm64: RMI: Propagate max SVE vector length from RMM
>>   arm64: RMI: Configure max SVE vector length for a Realm
>>   arm64: RMI: Provide register list for unfinalized RMI RECs
>>   arm64: RMI: Provide accurate register list
>>
>> Joey Gouly (2):
>>   arm64: RMI: allow userspace to inject aborts
>>   arm64: RMI: support RSI_HOST_CALL
>>
>> Steven Price (34):
>>   arm64: RME: Handle Granule Protection Faults (GPFs)
>>   arm64: RMI: Add SMC definitions for calling the RMM
>>   arm64: RMI: Add wrappers for RMI calls
>>   arm64: RMI: Check for RMI support at KVM init
>>   arm64: RMI: Define the user ABI
>>   arm64: RMI: Basic infrastructure for creating a realm.
>>   KVM: arm64: Allow passing machine type in KVM creation
>>   arm64: RMI: RTT tear down
>>   arm64: RMI: Activate realm on first VCPU run
>>   arm64: RMI: Allocate/free RECs to match vCPUs
>>   KVM: arm64: vgic: Provide helper for number of list registers
>>   arm64: RMI: Support for the VGIC in realms
>>   KVM: arm64: Support timers in realm RECs
>>   arm64: RMI: Handle realm enter/exit
>>   arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
>>   KVM: arm64: Handle realm MMIO emulation
>>   KVM: arm64: Expose support for private memory
>>   arm64: RMI: Allow populating initial contents
>>   arm64: RMI: Set RIPAS of initial memslots
>>   arm64: RMI: Create the realm descriptor
>>   arm64: RMI: Add a VMID allocator for realms
>>   arm64: RMI: Runtime faulting of memory
>>   KVM: arm64: Handle realm VCPU load
>>   KVM: arm64: Validate register access for a Realm VM
>>   KVM: arm64: Handle Realm PSCI requests
>>   KVM: arm64: WARN on injected undef exceptions
>>   arm64: Don't expose stolen time for realm guests
>>   arm64: RMI: Always use 4k pages for realms
>>   arm64: RMI: Prevent Device mappings for Realms
>>   HACK: Restore per-CPU cpu_armpmu pointer
>>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>>   arm64: RMI: Enable PMU support with a realm guest
>>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>>   arm64: RMI: Enable realms to be created
>>
>> Suzuki K Poulose (3):
>>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>>   kvm: arm64: Don't expose unsupported capabilities for realm guests
>>   arm64: RMI: Allow checking SVE on VM instance
>>
>>  Documentation/virt/kvm/api.rst       |   78 +-
>>  arch/arm64/include/asm/kvm_emulate.h |   31 +
>>  arch/arm64/include/asm/kvm_host.h    |   13 +-
>>  arch/arm64/include/asm/kvm_rmi.h     |  137 +++
>>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>>  arch/arm64/include/asm/rmi_smc.h     |  269 +++++
>>  arch/arm64/include/asm/virt.h        |    1 +
>>  arch/arm64/kernel/cpufeature.c       |    1 +
>>  arch/arm64/kvm/Kconfig               |    2 +
>>  arch/arm64/kvm/Makefile              |    2 +-
>>  arch/arm64/kvm/arch_timer.c          |   37 +-
>>  arch/arm64/kvm/arm.c                 |  179 ++-
>>  arch/arm64/kvm/guest.c               |   95 +-
>>  arch/arm64/kvm/hypercalls.c          |    4 +-
>>  arch/arm64/kvm/inject_fault.c        |    5 +-
>>  arch/arm64/kvm/mmio.c                |   16 +-
>>  arch/arm64/kvm/mmu.c                 |  214 +++-
>>  arch/arm64/kvm/pmu-emul.c            |    6 +
>>  arch/arm64/kvm/psci.c                |   30 +
>>  arch/arm64/kvm/reset.c               |   13 +-
>>  arch/arm64/kvm/rmi-exit.c            |  207 ++++
>>  arch/arm64/kvm/rmi.c                 | 1663 ++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c            |   53 +-
>>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>>  arch/arm64/kvm/vgic/vgic-v2.c        |    6 +-
>>  arch/arm64/kvm/vgic/vgic-v3.c        |   14 +-
>>  arch/arm64/kvm/vgic/vgic.c           |   55 +-
>>  arch/arm64/kvm/vgic/vgic.h           |   20 +-
>>  arch/arm64/mm/fault.c                |   28 +-
>>  drivers/perf/arm_pmu.c               |   20 +
>>  include/kvm/arm_arch_timer.h         |    2 +
>>  include/kvm/arm_pmu.h                |    4 +
>>  include/kvm/arm_psci.h               |    2 +
>>  include/linux/perf/arm_pmu.h         |    7 +
>>  include/uapi/linux/kvm.h             |   42 +-
>>  35 files changed, 3650 insertions(+), 116 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>  create mode 100644 arch/arm64/kvm/rmi-exit.c
>>  create mode 100644 arch/arm64/kvm/rmi.c
>>
>> -- 
>> 2.43.0
>>
>>

