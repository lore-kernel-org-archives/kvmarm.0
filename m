Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBD43AE71C
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 23:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773961331; cv=none; b=lhEGP4ow+JEKKjxn/Z/il5Ac8cn2Q3oIAYEQXEwAwUCH4VDcdPnNRw/VD/qVHG6k/r8UdSwApGFwchzK6pubIY91Le5R1gNsW1vSd4cjHQQrb+jHee7ijVxao/AsSMJ7Ltwu32VmDzLR5ynXyFEx5XeEXpUVZFVjuGCPiPJibbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773961331; c=relaxed/simple;
	bh=O/xNBL1lFnlrFZEUcSb88lJibJ0mr+kRo4zwFbNpyvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGRZls+4wALLCPPmB33MNDxWnjKgUxjvZ9MBIih2uk2M/JpCWmlkb8F2xkJkZzI13Kx0XG8Q2CDPmQZLd45ajUGw7yGuo04fIO11iGg87+uGxp8sZryIjFRSkOQka3ahiIdbUxdQ/vhF0izaMZbGxt1DiOcrtfuEJEpjMOlxAig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XBOtnT8B; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XBOtnT8B"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aae4816912so299715ad.2
        for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 16:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773961329; x=1774566129; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DtVhzb0DV85uGcvAl9P82/7gTaMXIzZ0xIhVOg4FCYk=;
        b=XBOtnT8BX6eirB/meoiM/tfJW2QwRU4M8v9amslj/SoBmpmRgqwvWrlbWigrJ6OSV/
         QNvcphwKS3KOvFG8XMoqgao6/MUQjwdtQMdBE7NuD3UFVyG7s43JWNVj2x7kHHc+ogzD
         Q8f68PlhAD9SQQf5aJLoQEBVURnlFqnmUYG0OxDkBi/701p6/OTVewdN+c9uIAaMHKgJ
         ceaInbY1z0W/0twfBF0KNfrmgNnWrNCJyklXPNkNMaAdaMIbzmsjSbNu3KaZ82NmRpo1
         W+VzOU4P/F/Mn0IAWzA6FTJ6+iFtjr/jz/Nhon66/UJqP9QwRXqGjrGV9hVeBh9gLiXV
         k0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773961329; x=1774566129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DtVhzb0DV85uGcvAl9P82/7gTaMXIzZ0xIhVOg4FCYk=;
        b=gEn69/nfkk7m3GdCACAEPDlk5w63aQTDMN9B9SejDMuXNy5RQ99sdzror4J1+a+P8a
         OBAXkbd9lj2duS6NzWKe0cEujV++BvPQnCX8gNGj5sS2B2L0gxoTq5gZ/dTSS1hh+FDb
         icNh7/M+iFfoQda8F089tRLv1AQCX+QOR+DMgMQDNqCw9HJP+LJQpMw9fxnAM9HD4GFM
         w5qPVuaS1kISjjBwCi2gi/zBg3ZEfMP2F/7liGafNobyt6v9ndkEWgS6CmgmZcdmwUGV
         9f0aNrM6WtgZvc21n5pCE0P/FpyX8wMzhxo3AX24mlFehgD1w8ubYDV0ANeJ1j5YLAsg
         HyiA==
X-Forwarded-Encrypted: i=1; AJvYcCXck6GR0W9MYR1n1PIKVy3L3j/cdEzZuOvR0GV6JOiflNu8n9iTz5/dEM3+a5XWotwwqteJZzs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaaEIjGv2O98mzl1PhKlQyisWPmMM0R/PxQuzDPEIuGyCc1h47
	pGGDuSkYFCjfrKVKvjCIFhBDTMEiL5cpP++iMZ2Gva7eBqS2ffEUb4O96PC97YkuOyk=
X-Gm-Gg: ATEYQzyXjuxabKnc9gEYQigagOo8uEX8/EV1LMkkFd1z/+tMjy1hZSCg67q1FKXiigz
	tDUQ0n2bzOqst271YUhBRKGnOBSmjymUjFQJvQa/UG+tSlBf6Hs9h+Fsg9AZQrS62jVncDzyY1O
	FLpSwIvA7TM25cbeatbwyJbJqloEsubB2KEwA6d8UzhMgYojlINK9QJJ/8z6xJ52U0ewqiGN5JW
	0yKk/OC0d3jr8P0sPExSySoUcLZ1LfxmAX30un2DcSqbcLeT5zc5Njr54WGM7wrkF/mfboIat0u
	FaG9SFqnBAWIA6OS0QYzA316Ebl+dfoO+O8BcZ3Rbg6qZMd3HOZG6H4g80Tm+qzuO60040VUnt7
	InzBKsB2/AXCBCaB3n+ioDHbKaJm+5MrEU4ihqQNd/ulKou/C4GjJPYnNFi5I+ZVWaqK89J6mqn
	Aqzy1Xy5itjKaGy4TfR+hxYqu89Dniv3HhH77OUA==
X-Received: by 2002:a17:902:d582:b0:2ae:4f15:1aba with SMTP id d9443c01a7336-2b08278b1b3mr7031995ad.30.1773961328468;
        Thu, 19 Mar 2026 16:02:08 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:bc0d:d18f:b06e:7b15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836ace98sm2468535ad.80.2026.03.19.16.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 16:02:07 -0700 (PDT)
Date: Thu, 19 Mar 2026 17:02:04 -0600
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
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
Message-ID: <abyAbPIkDn2bGZwd@p14s>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>

Good day,

On Wed, Mar 18, 2026 at 03:53:24PM +0000, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA).
> 
> New major version number! This now targets RMM v2.0-bet0[1]. And unlike
> for Linux this represents a significant change.
> 
> RMM v2.0 brings with it the ability to configure the RMM to have the
> same page size as the host (so no more RMM_PAGE_SIZE and dealing with
> granules being different from host pages). It also introduces range
> based APIs for many operations which should be more efficient and
> simplifies the code in places.
> 
> The handling of the GIC has changed, so the system registers are used to
> pass the GIC state rather than memory. This means fewer changes to the
> KVM code as it looks much like a normal VM in this respect.
> 
> And of course the new uAPI introduced in the previous v12 posting is
> retained so that also remains simplified compared to earlier postings.
> 
> The RMM support for v2.0 is still early and so this series includes a
> few hacks to ease the integration. Of note are that there are some RMM
> v1.0 SMCs added to paper over areas where the RMM implementation isn't
> quite ready for v2.0, and "SROs" (see below) are deferred to the final
> patch in the series.
> 
> The PMU in RMM v2.0 requires more handling on the RMM-side (and
> therefore simplifies the implementation on Linux), but this isn't quite
> ready yet. The Linux side is implemented (but untested).
> 
> PSCI still requires the VMM to provide the "target" REC for operations
> that affect another vCPU. This is likely to change in a future version
> of the specification. There's also a desire to force PSCI to be handled
> in the VMM for realm guests - this isn't implemented yet as I'm waiting
> for the dust to settle on the RMM interface first.
> 
> Stateful RMI Operations
> -----------------------
> 
> The RMM v2.0 spec brings a new concept of Stateful RMI Operations (SROs)
> which allow the RMM to complete an operation over several SMC calls and
> requesting/returning memory to the host. This has the benefit of
> allowing interrupts to be handled in the middle of an operation (by
> returning to the host to handle the interrupt without completing the
> operation) and enables the RMM to dynamically allocate memory for
> internal tracking purposes. One example of this is RMI_REC_CREATE no
> longer needs "auxiliary granules" provided upfront but can request the
> memory needed during the RMI_REC_CREATE operation.
> 
> There are a fairly large number of operations that are defined as SROs
> in the specification, but current both Linux and RMM only have support
> for RMI_REC_CREATE and RMI_REC_DESTROY. There a number of TODOs/FIXMEs
> in the code where support is missing.
> 
> Given the early stage support for this, the SRO handling is all confined
> to the final patch. This patch can be dropped to return to a pre-SRO
> state (albeit a mixture of RMM v1.0 and v2.0 APIs) for testing purposes.
> 
> A future posting will reorder the series to move the generic SRO support
> to an early patch and will implement the proper support for this in all
> RMI SMCs.
> 
> One aspect of SROs which is not yet well captured is that in some
> circumstances the Linux kernel will need to call an SRO call in a
> context where memory allocation is restricted (e.g. because a spinlock
> is held). In this case the intention is that the SRO will be cancelled,
> the spinlock dropped so the memory allocation can be completed, and then
> the SRO restarted (obviously after rechecking the state that the
> spinlock was protecting). For this reason the code stores the memory
> allocations within a struct rmi_sro_state object - see the final patch
> for more details.
> 
> This series is based on v7.0-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v13
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v11
> 
> Note that the kvmtool code has been tidied up (thanks to Suzuki) and
> this involves a minor change in flags. The "--restricted_mem" flag is no
> longer recognised (or necessary).
> 
> The TF-RMM has not yet merged the RMMv2.0 support, so you will need to
> use the following branch:
> 
> https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc

This RMM version is expecting a RMM EL3 interface version of at least 2.0.  Do
you have a TF-A to use with it?

Thanks,
Mathieu

> 
> [1] https://developer.arm.com/documentation/den0137/2-0bet0/
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
> Steven Price (36):
>   kvm: arm64: Avoid including linux/kvm_host.h in kvm_pgtable.h
>   arm64: RME: Handle Granule Protection Faults (GPFs)
>   arm64: RMI: Add SMC definitions for calling the RMM
>   arm64: RMI: Temporarily add SMCs from RMM v1.0 spec
>   arm64: RMI: Add wrappers for RMI calls
>   arm64: RMI: Check for RMI support at KVM init
>   arm64: RMI: Configure the RMM with the host's page size
>   arm64: RMI: Check for LPA2 support
>   arm64: RMI: Ensure that the RMM has GPT entries for memory
>   arm64: RMI: Define the user ABI
>   arm64: RMI: Basic infrastructure for creating a realm.
>   KVM: arm64: Allow passing machine type in KVM creation
>   arm64: RMI: RTT tear down
>   arm64: RMI: Activate realm on first VCPU run
>   arm64: RMI: Allocate/free RECs to match vCPUs
>   arm64: RMI: Support for the VGIC in realms
>   KVM: arm64: Support timers in realm RECs
>   arm64: RMI: Handle realm enter/exit
>   arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
>   KVM: arm64: Handle realm MMIO emulation
>   KVM: arm64: Expose support for private memory
>   arm64: RMI: Allow populating initial contents
>   arm64: RMI: Set RIPAS of initial memslots
>   arm64: RMI: Create the realm descriptor
>   arm64: RMI: Runtime faulting of memory
>   KVM: arm64: Handle realm VCPU load
>   KVM: arm64: Validate register access for a Realm VM
>   KVM: arm64: Handle Realm PSCI requests
>   KVM: arm64: WARN on injected undef exceptions
>   arm64: Don't expose stolen time for realm guests
>   arm64: RMI: Always use 4k pages for realms
>   arm64: RMI: Prevent Device mappings for Realms
>   arm64: RMI: Enable PMU support with a realm guest
>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>   arm64: RMI: Enable realms to be created
>   [WIP] arm64: RMI: Add support for SRO
> 
> Suzuki K Poulose (3):
>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>   kvm: arm64: Don't expose unsupported capabilities for realm guests
>   arm64: RMI: Allow checking SVE on VM instance
> 
>  Documentation/virt/kvm/api.rst       |   86 +-
>  arch/arm64/include/asm/kvm_emulate.h |   31 +
>  arch/arm64/include/asm/kvm_host.h    |   15 +-
>  arch/arm64/include/asm/kvm_pgtable.h |    5 +-
>  arch/arm64/include/asm/kvm_pkvm.h    |    2 +-
>  arch/arm64/include/asm/kvm_rmi.h     |  129 ++
>  arch/arm64/include/asm/rmi_cmds.h    |  692 +++++++++
>  arch/arm64/include/asm/rmi_smc.h     |  430 ++++++
>  arch/arm64/include/asm/virt.h        |    1 +
>  arch/arm64/kernel/cpufeature.c       |    1 +
>  arch/arm64/kvm/Kconfig               |    2 +
>  arch/arm64/kvm/Makefile              |    2 +-
>  arch/arm64/kvm/arch_timer.c          |   28 +-
>  arch/arm64/kvm/arm.c                 |  178 ++-
>  arch/arm64/kvm/guest.c               |   95 +-
>  arch/arm64/kvm/hyp/pgtable.c         |    1 +
>  arch/arm64/kvm/hypercalls.c          |    4 +-
>  arch/arm64/kvm/inject_fault.c        |    5 +-
>  arch/arm64/kvm/mmio.c                |   16 +-
>  arch/arm64/kvm/mmu.c                 |  214 ++-
>  arch/arm64/kvm/pmu-emul.c            |    6 +
>  arch/arm64/kvm/psci.c                |   30 +
>  arch/arm64/kvm/reset.c               |   13 +-
>  arch/arm64/kvm/rmi-exit.c            |  207 +++
>  arch/arm64/kvm/rmi.c                 | 1948 ++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c            |   53 +-
>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>  arch/arm64/mm/fault.c                |   28 +-
>  include/kvm/arm_arch_timer.h         |    2 +
>  include/kvm/arm_pmu.h                |    4 +
>  include/kvm/arm_psci.h               |    2 +
>  include/uapi/linux/kvm.h             |   41 +-
>  32 files changed, 4176 insertions(+), 97 deletions(-)
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
