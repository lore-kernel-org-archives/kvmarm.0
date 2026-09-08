Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D750D3101A9;
	Tue,  8 Sep 2026 04:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788840675; cv=none; b=GAPgfE2c90gF6SI3NWBVID/lSTZzSsWMx3WHLFd62CXLrlRtMqAZz1XELMyTPlbbZv3mhyX1IMZGcWT9Qbe3rqIY35C7+jIUKyJOI+ikzGWI3IE8a8ykgnRjONbaYsOLStlAhvN1YMTCID0+rJFcNtDFs8jOer4VgBtlLTeHNHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788840675; c=relaxed/simple;
	bh=1lJfLR7VTJt6Z4BK9Qx3EsC4zSeTnu2lBUv6+/ocf2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSZhMzXbQkyIrZNEW5ZZRhdEqOYkByR87U9Xb5T33aOR36qjI25PgKe0FuBHmQwniFEBSYLmK3vNPxtuTffcu2JRJpKTJtKtIfuGIUiWbaav7zL2DXZb5hymwCQmggiloGNnsJUQUujLlq4UeB53bmjBHAJ7yVJ1NM845IS4ND4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=WgeuPC5F; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="WgeuPC5F"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788840674; x=1820376674;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1lJfLR7VTJt6Z4BK9Qx3EsC4zSeTnu2lBUv6+/ocf2I=;
  b=WgeuPC5FKGa1VgqEXC2eEFsL6EAvzKRu/2kqeXipdr9ZNzCxkzh7cUBg
   vA4alFA+5e7U43EA8cRROB39EphYIuY/0QiVVWZYLiofNP92V2kJn6yQj
   TkAJ9C+SHgDtqNKU8988FYzZkSrV3xHZQbhhZhzhMww38sgNUC2aM6zoc
   ZlYxgoo8ohBbG+/ZRoHj0qeea4NbA0P1/wlC9axxUsw103itmd/MHJAzj
   TftCKRW4wGx6t6BHjB3saGO65yWjAvgYXEy/DDgXdnXAT0fPkTBdyAfer
   +ObhYOTBESg9leE9cvxmvyV4dslbIuoxh2wlnjUtFDyKrU7nL+8yPonX6
   A==;
X-CSE-ConnectionGUID: OSTcnrEFRjqMilWxEW5oGg==
X-CSE-MsgGUID: xrdzfng3QZCt6BgnSwyroQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="241767584"
X-IronPort-AV: E=Sophos;i="6.25,268,1779116400"; 
   d="scan'208";a="241767584"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 13:10:03 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 2A6C2100034B;
	Tue,  8 Sep 2026 04:10:03 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id CC279C00D56;
	Tue,  8 Sep 2026 04:10:02 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.15.163])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with SMTP id 8EE4B1800BBF;
	Tue,  8 Sep 2026 04:09:55 +0000 (UTC)
Date: Tue, 8 Sep 2026 13:09:48 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, 
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org
Subject: Re: [PATCH v17 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Message-ID: <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260907095942.1140734-1-suzuki.poulose@arm.com>

Hi Suzuki,

On 09/07 10:59, Suzuki K Poulose wrote:
> This series adds the generic firmware layer for talking to the Realm
> Management Monitor (RMM), as specified by the RMM v2.0-bet3
> specification[1]. It is the first part of the Arm CCA host support that
> was previously posted as part of the larger KVM series.
> 
> The split allows this RMM support to be used as a base for other work,
> including Aneesh's PCI IDE support with Arm CCA RMM as the TSM,
>  without depending on the KVM Realm support that will follow as separate
>  series. (See more on that below)
> 
> The series adds:
> 
>  * The RMI SMC definitions and direct-call wrappers.
> 
>  * RMM discovery and version checks during firmware init.
> 
>  * RMM host configuration, including the host page size.
> 
>  * Stateful RMI Operation (SRO) infrastructure for commands which the RMM
>    can complete across multiple SMC calls while requesting or returning
>    memory to the host.
> 
>  * Verification that granule tracking is available at fine granularity.
>    Fine-grained tracking allows each granule in the system to be tracked
>    independently, which is required before individual granules can be
>    delegated. A future series will add support for dynamically supplying
>    memory to the RMM for this tracking.
> 
>  * Support for fully firmware-managed systems, where the Granule Protection
>    Tables for memory regions are allocated and managed by firmware. RMM v2.0
>    also allows dynamic GPT creation on demand; support for that will be added
>    in a later series.
> 
>  * Wrappers for the RMI commands that are used for managing the "Realm VM"
>    lifecycle. This is added in to make it easier for the on-going KVM support
>    to evolve in parallel pieces.
> 
> If the platform firmware cannot manage the granule tracking or the GPTs, we
> bail out and deactivate the RMM, reclaiming any memory that we have donated.
> 
> The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
> the RMM to complete an operation over several SMC calls while requesting
> or returning memory to the host. This allows interrupts to be handled in
> the middle of an operation and lets the RMM dynamically allocate memory
> for internal tracking purposes. For example, RMI_REC_CREATE no longer
> needs auxiliary granules to be provided up front, and can instead
> request memory during the operation.
> 
> This series applies on v7.3-rc1 and a branch is available at [2]. The KVM
> CCA support that builds on this series is available at [3] as an integration
> branch. The KVM support depends on guest-memfd-in-place conversion support v12
> from Ackerley [4], we plan to split that into parts, which apply cleanly on
> v7.3-rcx without any dependency and is in progress. This will be made available
> as soon as it is ready. Until then [3] shows how this base series enables KVM
> CCA support. You may find the tf-RMM [5] and kvmtool support [6] below.
> 
> [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
> [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v17
> [3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/kvm-integration/v17
> [4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v12
> [5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)

I understand that QEMU-virt is not intended to model a realistic
production platform and that QEMU-SBSA is generally preferred. However,
I sometimes use QEMU-virt to test functionality quickly because it runs
slightly faster than QEMU-SBSA.

I tested this series with QEMU-virt and found that RMM initialization
failed during boot:

  [...]
  INFO:    BL31: Initializing RMM
  INFO:    RMM init start.
  ERROR:   RMM init failed: -8
  WARNING: BL31: RMM initialization failed

The following TF-A revision was used:
  https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git master (38269bb)

After investigating, I found that the failure was caused by the lack of
a plat_rmmd_reserve_memory() implementation for the QEMU-virt platform
in TF-A. Adding an implementation equivalent to the QEMU-SBSA one
resolved the issue:
    https://git.trustedfirmware.org/plugins/gitiles/TF-A/trusted-firmware-a.git/+/9d594743aa4d4e8160cdf025ea7538041648972c

Is QEMU virt still intended to be supported as an RME emulation
platform? In particular, is this functionality simply not implemented
yet, or is there a reason why RME support is not planned for QEMU virt?

If this is not the appropriate place to discuss this, please let me
know :)

Thanks,
Kohei

> [6] kvmtool https://gitlab.arm.com/linux-arm/kvmtool-cca.git cca/kvm-v17
> 
> Known issues: RMMv2.0
>  * RmiOpMemDonateReq:count (Uint14) is incompatible with RmiAddrRangeDesc4KB
>   (Uint10) and RmiAddrRangeDesc16KB (Uint12). i.e., a larger contiguous request
>   may not be satisfiable by the host. Arm is aware of this defect and a spec fix
>   is in progress.
> 
> 
> Steven Price (7):
>   firmware: arm_rmm: Add SMC definitions for calling the RMM
>   firmware: arm_rmm: Check for RMI support at init
>   firmware: arm_rmm: Configure the RMM with the host's page size
>   firmware: arm_rmm: Add support for SRO
>   firmware: arm_rmm: Activate the RMM
>   firmware: arm_rmm: Ensure the RMM has GPT entries for memory
>   firmware: arm_rmm: Add wrappers for Realm related RMI commands
> 
>  arch/arm64/Kconfig                |   1 +
>  arch/arm64/kernel/cpufeature.c    |   1 +
>  drivers/firmware/Kconfig          |   1 +
>  drivers/firmware/Makefile         |   1 +
>  drivers/firmware/arm_rmm/Kconfig  |  26 +
>  drivers/firmware/arm_rmm/Makefile |   2 +
>  drivers/firmware/arm_rmm/rmi.c    | 819 ++++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h      | 678 +++++++++++++++++++++++++
>  include/linux/arm-smccc-rmi.h     | 494 ++++++++++++++++++
>  9 files changed, 2023 insertions(+)
>  create mode 100644 drivers/firmware/arm_rmm/Kconfig
>  create mode 100644 drivers/firmware/arm_rmm/Makefile
>  create mode 100644 drivers/firmware/arm_rmm/rmi.c
>  create mode 100644 include/linux/arm-rmi-cmds.h
>  create mode 100644 include/linux/arm-smccc-rmi.h
> 
> -- 
> 2.43.0
> 
