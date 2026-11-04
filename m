Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793803326;
	b=E7XwL1NQ+9JWG2CT0c0u7CgRs/nxufzfBWX8EGJo523p3aPKjOR9HMlEEmDTIO5zaBVp
	 Ctrou4+As2SiQgDPge4oPNk+VVa2WupjWKG+6I8fDCJw4Bf11JgRDhz0I5TaLdU0g/gFb
	 xcOEYy7c9Jg2xr5q34BHPMbcASzzT4rXWOwWcbgDjazhCR6EUr30tq9LIa3M8dRgOm/+B
	 AIR/MgPvi3E7Z9S4STCZA08ulhe9tYOEfUo6hcZhsCHKr4TRWcHOo6MBpmddc7RP32Wmv
	 d0coLxu+1U0YNYVmRpwXJk+Ecpm/9sAG+nblqGyAa8weH9WwjAGohSzAeqoM68tqktQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793803326;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yEXOiGhgbR5kbYCDmjXy0GbChNz5nYoCzDv/8cG/g+Y=;
	b=zJH/hRC5aM9NGWFN31lfv3Bb3nEtJbdPu5eYSh3Ts2Zqh1nxy971EhuwhDZcqV8K0iPm
	 zfmHnPow18dgQXPzq+76QdO7Wv6licHUHHYzds9LHn27siJyaxer+TQDkRxCSspIWsaFI
	 hyJXM0LjIF8EY0w0SxLtJnFsiXYWM+WHceYWMk1oFrmgL+1R6H5rhse6oxMNlH4RwRdI8
	 3eSF2Yn+IWB3UkftzvSY+gVvJ9EgqVoAs4Jo7tcqEL4kzBQPjJgyVs8dmxK1zS3NRFT+7
	 hzejyI0bPBu72ZUR9twrxSifq0GJGljpEPsOPYhlcthhgB4/ycYXUxlqiMWvKqn335w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=luId+KEo;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52783606A335
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 14:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52783606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=luId+KEo
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F5F31476;
	Wed,  4 Nov 2026 06:42:01 -0800 (PST)
Received: from [10.57.65.23] (unknown [10.57.65.23])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF6933F673;
	Wed,  4 Nov 2026 06:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793803324; bh=OQ+6GXsnzNtECacWk2BjiQr1Za6EzTRmQxCpvw/0bo8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=luId+KEomiCYTx0zsDXfLF0NiGSbVJSZAawz5X649BNQCNK5aIrov6r7jQPa5f5G1
	 /y7/Z1tTcJswVlprth41Zn/4fMIj1S2AkxetBjIo4WJhSSAHooaIdF0oJpfr07XKSr
	 mYYkWIizutTHBEivTMuSApJZfPh5pMdZsop7CXg0=
Message-ID: <80b69632-dbe1-405b-910a-c17a943d8fc2@arm.com>
Date: Wed, 4 Nov 2026 14:41:59 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [BUMP] [RFC PATCH v2 00/15] Arm Core Local Accelerator Driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi All,

Just a polite bump; now that -rc1 is out, if anyone can spare any time to cast
an eye and offer opinions, I'd be grateful. At this point, I'm most interested
in feedback on the arm64 integration aspect; If you see blockers I'd like to
discuss early.

Thanks,
Ryan


On 15/10/2026 15:25, Ryan Roberts wrote:
> Hi All,
> 
> This is v2 of an RFC to introduce a driver for the Arm Core Local Accelerator
> (CLA), a CPU-local interface for programming attached accelerators. While the
> interface is agnostic to the accelerator type, the initial (and currently only)
> target is a compute engine.
> 
> The RFC aims to engage the community and get feedback on some key aspects. This
> will help plan our approach for eventual upstreaming. Based on feedback from
> Will and Marc in RFCv1, the driver now supports both bare metal and virtualized
> environments. I also have commitments to publish the CLA spec, a supporting FVP
> and a representaive user space, all to support upstreaming the driver, as per
> Will's feedback.
> 
> For now you can find documentation included with patch 1, which describes the HW
> and driver design. Note that the CLA is not part of the Arm Architecture.
> 
> Patch 1 documents the hardware and driver design, and adds a driver skeleton.
> Patches 2-5 initialize and probe the device. Patches 6-9 add context management
> for switching the device between different users. Patches 10-12 add some (small)
> changes to KVM and VFIO, which then enables patches 13-15 to expose the HW for
> device assignment into a VM.
> 
> Aspects I'm seeking feedback for:
> 
> * The general structure of the driver: The current shape addresses the
>   performance requirements we have for the use cases, and is therefore our
>   preferred approach. But there are some unusual aspects due to the HW design.
> 
> * Driver interaction with architectural support: I've opted to treat the CLA as
>   a device rather than a CPU extension, so it's implemented as a (mostly)
>   self-contained driver. It has some unavoidable coupling to the arch code since
>   it needs to share page tables and ASIDs/VMIDs. All arm64 arch interaction is
>   contained in cla-mtc.c.
> 
> * The location of the driver: although most accelerators will likely be compute
>   ones, CLA is a generic MMIO interface that could handle any kind of
>   accelerator. It's currently implemented as a misc driver. accel is another
>   potential option, but given the current SVA approach, we would not use any of
>   the services (memory-management or otherwise) that accel provides.
> 
> * Virtualization support: since the HW uses the CPU's MMU, we introduced a new
>   VFIO_CPU_MMU group type, and added the kvm_arch_[get|put]_guest_mmu() API to
>   KVM/arm64 so that the CLA can share the stage2 pgtables and VMID. The CPU
>   pinning problem remains unsolved; the vCPU must be pinned to the pCPU that
>   owns the CLA in order to access it. If the pCPU goes offline or the vCPU is
>   otherwise unpinned, it would look to the guest like the HW is faulty. This
>   issue is therefore contained to the guest. I've additionally improved the
>   robustness of the core driver to deal with this eventuality gracefully.
> 
> I consider the core driver to be well tested and robust. The virtualization
> portion is prototype and has known issues that would be addressed assuming the
> approach gets positive feedback.
> 
> Changes since RFCv1 [1]
> =======================
> 
>  - Added KVM guest support through VFIO mdev, including exclusive domain
>    assignment, stage-2 memory translation and VMID pinning
>  - Changed the userspace ABI to expose one `/dev/cla/<class-id>` device per
>    accelerator class; `ARM_CLA_PARAM_DEV_ACCELS` now reports only accelerators
>    belonging to the opened class (per Arnd)
>  - Removed `ARM_CLA_UABI_VERSION` and the `ARM_CLA_PARAM_UABI_VERSION` query
>    (per Arnd)
>  - Various driver bug fixes and robustness improvements
> 
> 
> Source, along with some tests, is available at [2]. Patches based on v7.3-rc5.
> 
> [1] https://lore.kernel.org/all/20260717104759.123203-1-ryan.roberts@arm.com/
> [2] https://gitlab.arm.com/linux-arm/linux-rr/-/tree/features/cla-driver-v2-rfc-tests
> 
> Thanks,
> Ryan
> 
> 
> Jean-Philippe Brucker (10):
>   misc/arm-cla: Add driver skeleton and documentation
>   misc/arm-cla: Add launch operation helpers
>   misc/arm-cla: Probe firmware-described devices
>   misc/arm-cla: Initialize devices on CPU bringup
>   misc/arm-cla: Accelerator context save and restore
>   KVM: arm64: Export stage-2 MMU config
>   vfio: Support VFIO devices that access the CPU MMU
>   misc/arm-cla: Add stage-2 MTC and VM context switch
>   misc/arm-cla: Support exclusive context assignment
>   misc/arm-cla: Add vfio-mdev user interface
> 
> Ryan Roberts (4):
>   dt-bindings: misc: Add Arm Core Local Accelerator
>   misc/arm-cla: Set up memory translation context
>   misc/arm-cla: Manage domain contexts
>   misc/arm-cla: Add userspace interface
> 
> Shameer Kolothum (1):
>   KVM: arm64: Introduce support to pin VMIDs
> 
>  .../devicetree/bindings/misc/arm,cla.yaml     |  77 +++
>  Documentation/misc-devices/arm-cla.rst        | 217 +++++++
>  Documentation/misc-devices/index.rst          |   1 +
>  MAINTAINERS                                   |   9 +
>  arch/arm64/include/asm/kvm_host.h             |  14 +
>  arch/arm64/include/asm/kvm_mmu.h              |   1 +
>  arch/arm64/kvm/mmu.c                          | 102 ++++
>  arch/arm64/kvm/sys_regs.c                     |  14 +-
>  arch/arm64/kvm/vmid.c                         |  77 ++-
>  drivers/misc/Kconfig                          |   1 +
>  drivers/misc/Makefile                         |   1 +
>  drivers/misc/arm-cla/Kconfig                  |  26 +
>  drivers/misc/arm-cla/Makefile                 |  15 +
>  drivers/misc/arm-cla/arm-cla-regs.h           | 192 ++++++
>  drivers/misc/arm-cla/arm-cla.h                | 393 ++++++++++++
>  drivers/misc/arm-cla/cla-ctx.c                | 229 +++++++
>  drivers/misc/arm-cla/cla-init.c               | 562 ++++++++++++++++++
>  drivers/misc/arm-cla/cla-mdev.c               | 469 +++++++++++++++
>  drivers/misc/arm-cla/cla-mtc.c                | 335 +++++++++++
>  drivers/misc/arm-cla/cla-ops.c                | 417 +++++++++++++
>  drivers/misc/arm-cla/cla-regs.c               | 370 ++++++++++++
>  drivers/misc/arm-cla/cla-sched.c              | 474 +++++++++++++++
>  drivers/misc/arm-cla/cla-topology.c           | 202 +++++++
>  drivers/misc/arm-cla/cla-user.c               | 541 +++++++++++++++++
>  drivers/vfio/group.c                          |  37 +-
>  drivers/vfio/vfio.h                           |   5 +
>  drivers/vfio/vfio_main.c                      |  16 +-
>  include/linux/vfio.h                          |   1 +
>  include/uapi/linux/arm-cla.h                  | 198 ++++++
>  29 files changed, 4969 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/misc/arm,cla.yaml
>  create mode 100644 Documentation/misc-devices/arm-cla.rst
>  create mode 100644 drivers/misc/arm-cla/Kconfig
>  create mode 100644 drivers/misc/arm-cla/Makefile
>  create mode 100644 drivers/misc/arm-cla/arm-cla-regs.h
>  create mode 100644 drivers/misc/arm-cla/arm-cla.h
>  create mode 100644 drivers/misc/arm-cla/cla-ctx.c
>  create mode 100644 drivers/misc/arm-cla/cla-init.c
>  create mode 100644 drivers/misc/arm-cla/cla-mdev.c
>  create mode 100644 drivers/misc/arm-cla/cla-mtc.c
>  create mode 100644 drivers/misc/arm-cla/cla-ops.c
>  create mode 100644 drivers/misc/arm-cla/cla-regs.c
>  create mode 100644 drivers/misc/arm-cla/cla-sched.c
>  create mode 100644 drivers/misc/arm-cla/cla-topology.c
>  create mode 100644 drivers/misc/arm-cla/cla-user.c
>  create mode 100644 include/uapi/linux/arm-cla.h
> 
> --
> 2.43.0
> 

