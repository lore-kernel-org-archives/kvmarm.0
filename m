Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE921F5EA
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770918534; cv=none; b=MbBAhk6tiGcR7y2X+YN2p0TMrHnmgBuOzJPkPw2ZtaQ3uhMDr2Tt/wmO4hVylXrJGECH636Uzuzk+8jE5TTPSU1eSpJHUNejXO6mPEcpzv1c79qXrB4pGSJa7lqMx9Tuiow/u92ujL3UDSz7qs26O+dmsPlt/E1plGX1dCwc9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770918534; c=relaxed/simple;
	bh=Y9YqPnc8BmjwKubmvFSXt3QWfkXvZK4RllFw60PzH/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1+qoCoJNpezZRmterndZ3z4r/MCTr/9awkA/SXJQrnRlEoqwrkAs6BOajXuBKRV9NkYOeTw0z1APKzc7OZaquRvuhOYyVZLF0LR3I4htRP5phsMbYzTBnzt9jk0UgMr46gu1vrQ9nFy8JXpbvn5rzIEVSjonSF9au4U2u7fB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ev/+VVqJ; arc=none smtp.client-ip=209.85.210.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ev/+VVqJ"
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-824484dba4dso112141b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770918531; x=1771523331; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wkYX9/8AMpNKTzDUSgXfqQoLj53MIkWsoktK8rnuztU=;
        b=ev/+VVqJ6z0diJhADlLnHJyaXjh4fZYJoe3jdmdc24HB0/n7JkLWxdhuCDW44dTxw8
         JlKC+4uxihINrcgcy6nqq11C6/lCCcIEMIGu9Jh0aw3KjOyAo9mRTTtm3hR0lHoEvt9J
         dZh2JinU+MTJWI3XfLKba3/66KjDnOoE7hfmlkcdJHQwBhDw1WH81Z0TAJQjN+SernBz
         Ga+ptNziV0Uh3zoE1EehCQT9zSHEbWt1q+K4LhGjRPm9ilZk6AAj3QHCI2FjTxq/3S15
         3DaIcGQtORoxVOe1QPGoi1VLOLAvwgHsSkhxDYzfedn3o9oWxH72EN82FpL5KiMQexYp
         Ub6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770918531; x=1771523331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkYX9/8AMpNKTzDUSgXfqQoLj53MIkWsoktK8rnuztU=;
        b=O5+oXQzzcn0Qnjd9qsiJx3A+3UTJxQmUlUWAqkXDPxizfpGwlGI7otGjkKWZvzPLdP
         0h8nqFFQtWAs94dt5cwpBZEFtAowIvUs4bZuJgbbzlo3x1JVgi7dLFwISofnwQlTl1ue
         JHLKz9wU884GZhf/w1ZIunnnx2YxlNQD523RAxnkUVgmJdRzt/HZhAFLuC6sa+4Khuj8
         5XwiPtSI/qWN+xd0GDLPPNJ8rGRK/WDkDWGtb6DmT+xHdm8patidc5oHxCze886zwCeP
         egQhylHmdx0BGUtvNpP+r8DpGIWTWrmOlTMVxzjcg5CCG6NJrVFvEb+zqFQ0lU5Bh7Eq
         d6/g==
X-Forwarded-Encrypted: i=1; AJvYcCVEZGSCelsvVlztYpmqb+yhe99U2JWl+nl/ozCymMASJcUBtOdt8aGcASQbajzb70YPTr0YKHQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmjU7Yria2+lYCVC0orrMCyKH/s2NQ3yEvF7FCl8VLcwjOYUrm
	o2nJIBWowokgUN+b0ktu+lhjr2WkCt55MDJ9BD/ohPz951eimskPYMnWsQ5myalQyMo=
X-Gm-Gg: AZuq6aJOSVCaQgjrvfZODbwa7iy2PqBrVXp/MlKSj165SQV/+FBulitxSKCXH4ptqk/
	whTGceCAO1Hodd8rd1wOe/LU5akXH52O2OfaOoExLxTaDf2DA6UyLatTOtr/hVdsZCK5vFF2xjn
	iY9Y62pKfF8k6cEsF6ax+FdluvCs/oLCAMhDW2mIk40Qhz7XWKQzcBIbM5TIDp/xx8YuC0/xPfE
	EUitGNr8XNFOAL4esAsueExZQhsqyrWp/jqLhDzFmK0PrQ4V0mxsNUlxyj2CZnvvsbVgyrkH3KO
	meosBU4a5dUICVW0yi5oNvoi++vltH5G0pBepGv2gBxBYkIY18rewbwz7ILUBF+jxTX/CeLYHyL
	bzi121EGti0/FRLthmsOPKruII/tksvuW77SzZBAt+EbXfK4yLVf941KMxSUjcelIkKpbKqjOeL
	R5Q8oFVoqp2VXntXxCpF9MIgINnec=
X-Received: by 2002:a05:6a00:17a1:b0:824:a304:e5b7 with SMTP id d2e1a72fcca58-824b302d476mr3194178b3a.51.1770918530788;
        Thu, 12 Feb 2026 09:48:50 -0800 (PST)
Received: from p14s ([2604:3d09:148c:c800:b17f:2662:e1ea:5d37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3bd3b2sm6231651b3a.22.2026.02.12.09.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 09:48:50 -0800 (PST)
Date: Thu, 12 Feb 2026 10:48:47 -0700
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
Message-ID: <aY4Sf4lMlWd9LyTo@p14s>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>

Hi Steven,

On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
> following feedback from Marc.
> 
> The main change is that rather than providing a multiplex CAP and
> expecting the VMM to drive the different stages of realm construction,
> there's now just a minimal interface and KVM performs the necessary
> operations when needed.
> 
> This series is lightly tested and is meant as a demonstration of the new
> uAPI. There are a number of (known) rough corners in the implementation
> that I haven't dealt with properly.
> 
> In particular please note that this series is still targetting RMM v1.0.
> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
> that there are a number of blockers for merging with RMM v1.0 and so I
> expect to rework this series to support RMM v2.0 before it is merged.
> That will necessarily involve reworking the implementation.
> 
> Specifically I'm expecting improvements in:
> 
>  * GIC handling - passing state in registers, and allowing the host to
>    fully emulate the GIC by allowing trap bits to be set.
> 
>  * PMU handling - again providing flexibility to the host's emulation.
> 
>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
>    RMM v2.0 provide the option for the host to change the granule size.
>    The intention is that Linux would simply set the granule size equal
>    to its page size which will significantly simplify the management of
>    granules.
> 
>  * Some performance improvement from the use of range-based map/unmap
>    RMI calls.
> 
> This series is based on v6.19-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10

The first thing to note is that branch cca/v10 does not compile due to function
realm_configure_parameters() not being called anywhere.  Marking the function as
[[maybe_unused]] solved the problem on my side.

Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
from lkvm, mounting the initrd fails.  Looking into this issue further, I see
that from a Realm kernel's perspective, the content of the initrd is either
encrypted or has been trampled on.  

I'd be happy to provide more details on the above, just let me know.

Thanks,
Mathieu

> 
> [1] https://developer.arm.com/documentation/den0137/latest/
> 
> Jean-Philippe Brucker (7):
>   arm64: RMI: Propagate number of breakpoints and watchpoints to
>     userspace
>   arm64: RMI: Set breakpoint parameters through SET_ONE_REG
>   arm64: RMI: Initialize PMCR.N with number counter supported by RMM
>   arm64: RMI: Propagate max SVE vector length from RMM
>   arm64: RMI: Configure max SVE vector length for a Realm
>   arm64: RMI: Provide register list for unfinalized RMI RECs
>   arm64: RMI: Provide accurate register list
> 
> Joey Gouly (2):
>   arm64: RMI: allow userspace to inject aborts
>   arm64: RMI: support RSI_HOST_CALL
> 
> Steven Price (34):
>   arm64: RME: Handle Granule Protection Faults (GPFs)
>   arm64: RMI: Add SMC definitions for calling the RMM
>   arm64: RMI: Add wrappers for RMI calls
>   arm64: RMI: Check for RMI support at KVM init
>   arm64: RMI: Define the user ABI
>   arm64: RMI: Basic infrastructure for creating a realm.
>   KVM: arm64: Allow passing machine type in KVM creation
>   arm64: RMI: RTT tear down
>   arm64: RMI: Activate realm on first VCPU run
>   arm64: RMI: Allocate/free RECs to match vCPUs
>   KVM: arm64: vgic: Provide helper for number of list registers
>   arm64: RMI: Support for the VGIC in realms
>   KVM: arm64: Support timers in realm RECs
>   arm64: RMI: Handle realm enter/exit
>   arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
>   KVM: arm64: Handle realm MMIO emulation
>   KVM: arm64: Expose support for private memory
>   arm64: RMI: Allow populating initial contents
>   arm64: RMI: Set RIPAS of initial memslots
>   arm64: RMI: Create the realm descriptor
>   arm64: RMI: Add a VMID allocator for realms
>   arm64: RMI: Runtime faulting of memory
>   KVM: arm64: Handle realm VCPU load
>   KVM: arm64: Validate register access for a Realm VM
>   KVM: arm64: Handle Realm PSCI requests
>   KVM: arm64: WARN on injected undef exceptions
>   arm64: Don't expose stolen time for realm guests
>   arm64: RMI: Always use 4k pages for realms
>   arm64: RMI: Prevent Device mappings for Realms
>   HACK: Restore per-CPU cpu_armpmu pointer
>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>   arm64: RMI: Enable PMU support with a realm guest
>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>   arm64: RMI: Enable realms to be created
> 
> Suzuki K Poulose (3):
>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>   kvm: arm64: Don't expose unsupported capabilities for realm guests
>   arm64: RMI: Allow checking SVE on VM instance
> 
>  Documentation/virt/kvm/api.rst       |   78 +-
>  arch/arm64/include/asm/kvm_emulate.h |   31 +
>  arch/arm64/include/asm/kvm_host.h    |   13 +-
>  arch/arm64/include/asm/kvm_rmi.h     |  137 +++
>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>  arch/arm64/include/asm/rmi_smc.h     |  269 +++++
>  arch/arm64/include/asm/virt.h        |    1 +
>  arch/arm64/kernel/cpufeature.c       |    1 +
>  arch/arm64/kvm/Kconfig               |    2 +
>  arch/arm64/kvm/Makefile              |    2 +-
>  arch/arm64/kvm/arch_timer.c          |   37 +-
>  arch/arm64/kvm/arm.c                 |  179 ++-
>  arch/arm64/kvm/guest.c               |   95 +-
>  arch/arm64/kvm/hypercalls.c          |    4 +-
>  arch/arm64/kvm/inject_fault.c        |    5 +-
>  arch/arm64/kvm/mmio.c                |   16 +-
>  arch/arm64/kvm/mmu.c                 |  214 +++-
>  arch/arm64/kvm/pmu-emul.c            |    6 +
>  arch/arm64/kvm/psci.c                |   30 +
>  arch/arm64/kvm/reset.c               |   13 +-
>  arch/arm64/kvm/rmi-exit.c            |  207 ++++
>  arch/arm64/kvm/rmi.c                 | 1663 ++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c            |   53 +-
>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>  arch/arm64/kvm/vgic/vgic-v2.c        |    6 +-
>  arch/arm64/kvm/vgic/vgic-v3.c        |   14 +-
>  arch/arm64/kvm/vgic/vgic.c           |   55 +-
>  arch/arm64/kvm/vgic/vgic.h           |   20 +-
>  arch/arm64/mm/fault.c                |   28 +-
>  drivers/perf/arm_pmu.c               |   20 +
>  include/kvm/arm_arch_timer.h         |    2 +
>  include/kvm/arm_pmu.h                |    4 +
>  include/kvm/arm_psci.h               |    2 +
>  include/linux/perf/arm_pmu.h         |    7 +
>  include/uapi/linux/kvm.h             |   42 +-
>  35 files changed, 3650 insertions(+), 116 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>  create mode 100644 arch/arm64/kvm/rmi-exit.c
>  create mode 100644 arch/arm64/kvm/rmi.c
> 
> -- 
> 2.43.0
> 
> 
