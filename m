Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33674403AF8;
	Fri, 31 Jul 2026 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785494835; cv=none; b=V7lQ8mkva50qmpMDLKJLZjNtDD6zpc6ATSgipb4A106SHRmDoqaqsLBx5yzG+8kSd0jwe9tF6aoQ6AWdI975QIZetb0mpZl+1OUGYE42YKtAUlKnMT5uvs4U10M+qhUiVIUCEeWsQjaeYoIV1QAEbScjWch3eD7b5eD4+hd+o8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785494835; c=relaxed/simple;
	bh=xnQDXFr6x9WSg7RzzF32+vNJKDwAKWafEf9u1c2+2A8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iWS5NZRcgt6nKen1+vUFG7pkdJLijaJd6naAIDJN8VPFrdZyCpzcSOiT5OZFXOcKt9NmRLEAQqoJWcAnVYxvVEzKCvpDobnK7Vx88Yn2GxlcKhi6F1Y7PSXrwBFjTncHuHnCxBwnVEaXTAMElt+wcUJ1CWkXzLgXhwxNDhAGXPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=U0I5ymXy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="U0I5ymXy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 430B9165C;
	Fri, 31 Jul 2026 03:46:59 -0700 (PDT)
Received: from [10.57.41.95] (unknown [10.57.41.95])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DDAA3F86F;
	Fri, 31 Jul 2026 03:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785494823; bh=xnQDXFr6x9WSg7RzzF32+vNJKDwAKWafEf9u1c2+2A8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U0I5ymXyAcvtBhfwzLJP6OiqaHKPHoEJ+/G9qjCJbs8UU44IG9uFNYAdplwIDZZtU
	 1OJ/kllaVrv5Zu+K9RZ9Xg9DUesQAMGg1DxH8SXy8m9QPuj0n7NW4QFfC1m0zY2zKW
	 Jw/X8cGnlds8C47/dOOL8fUyWBrnTBCNaEwMiRTY=
Message-ID: <54805b15-c3cd-4dfd-ad50-fdaa460d4f5f@arm.com>
Date: Fri, 31 Jul 2026 11:46:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] firmware: arm_rmm: Check for RMI support at init
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo Pieralisi <lpieralisi@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-4-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260715142739.80398-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 15/07/2026 15:27, Steven Price wrote:
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v15:
>   * The code is moved again, this time into the 'firmware' directory.
> v14:
>   * This moves the basic RMI setup into the 'kernel' directory. This is
>     because RMI will be used for some features outside of KVM so should
>     be available even if KVM isn't compiled in.
> ---
>   arch/arm64/Kconfig                |   1 +
>   arch/arm64/kernel/cpufeature.c    |   1 +
>   drivers/firmware/Kconfig          |   1 +
>   drivers/firmware/Makefile         |   1 +
>   drivers/firmware/arm_rmm/Kconfig  |  22 +++++++
>   drivers/firmware/arm_rmm/Makefile |   2 +
>   drivers/firmware/arm_rmm/rmi.c    | 100 ++++++++++++++++++++++++++++++
>   7 files changed, 128 insertions(+)
>   create mode 100644 drivers/firmware/arm_rmm/Kconfig
>   create mode 100644 drivers/firmware/arm_rmm/Makefile
>   create mode 100644 drivers/firmware/arm_rmm/rmi.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index b3afe0688919..0f1956edf130 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -38,6 +38,7 @@ config ARM64
>   	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>   	select ARCH_HAS_MEM_ENCRYPT
>   	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
> +	select ARCH_SUPPORTS_RMM
>   	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>   	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>   	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9a22df0c5120..4ae63c89cda9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -293,6 +293,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>   static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> index 12dc70254842..55542879fbb8 100644
> --- a/drivers/firmware/Kconfig
> +++ b/drivers/firmware/Kconfig
> @@ -301,5 +301,6 @@ source "drivers/firmware/samsung/Kconfig"
>   source "drivers/firmware/smccc/Kconfig"
>   source "drivers/firmware/tegra/Kconfig"
>   source "drivers/firmware/xilinx/Kconfig"
> +source "drivers/firmware/arm_rmm/Kconfig"
>   
>   endmenu
> diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
> index 4ddec2820c96..07e8ca1789b4 100644
> --- a/drivers/firmware/Makefile
> +++ b/drivers/firmware/Makefile
> @@ -38,3 +38,4 @@ obj-y				+= samsung/
>   obj-y				+= smccc/
>   obj-y				+= tegra/
>   obj-y				+= xilinx/
> +obj-y				+= arm_rmm/
> diff --git a/drivers/firmware/arm_rmm/Kconfig b/drivers/firmware/arm_rmm/Kconfig
> new file mode 100644
> index 000000000000..d224a72cca90
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/Kconfig
> @@ -0,0 +1,22 @@
> +
> +config ARCH_SUPPORTS_RMM
> +	bool
> +
> +config ARM_RMM
> +	bool "Realm Management Monitor (RMM) Support"
> +	depends on ARCH_SUPPORTS_RMM
> +	default y
> +	help
> +	  Support the Realm Management Monitor (RMM) on Arm systems that
> +	  implement the Realm Management Extension (RME), as defined by the
> +	  Arm Confidential Compute Architecture.
> +
> +	  The RMM runs in the Realm world and provides the Realm Management

minor nit:
	  The RMM runs at EL2 in the Realm world ...
		OR
	  The RMM runs at R-EL2 ...


> +	  Interface (RMI) used by a Normal World host to create, manage and run
> +	  protected virtual machines called Realms. This option builds the

           The RMM could also act as a TSM, as defined by the PCIe TDISP
	  and can manage the PCI IDE setup for securing the PCIe links.

for covering the IDE setup case, which could exist withou the Realm VM
support.

Rest looks good to me.

Suzuki



> +	  host-side RMI support used by KVM to detect a compatible RMM,
> +	  configure it, manage delegated memory and enable Realm guests.
> +
> +	  Selecting this option does not by itself make Realm guests available:
> +	  the system must also provide RME-capable hardware and firmware with a
> +	  compatible RMM implementation.
> diff --git a/drivers/firmware/arm_rmm/Makefile b/drivers/firmware/arm_rmm/Makefile
> new file mode 100644
> index 000000000000..51aef5cc04b0
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/Makefile
> @@ -0,0 +1,2 @@
> +
> +obj-$(CONFIG_ARM_RMM)	= rmi.o
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> new file mode 100644
> index 000000000000..c4850976544f
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + */
> +
> +#include <linux/cpufeature.h>
> +#include <linux/memblock.h>
> +#include <linux/arm-rmi-cmds.h>
> +#include <linux/slab.h>
> +
> +#include <asm/memory.h>
> +#include <asm/pgtable-hwdef.h>
> +
> +/* Currently only the first 2 registers are used by Linux */
> +#define RMI_FEAT_REG_COUNT	2
> +static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
> +
> +unsigned long rmi_feat_reg(unsigned long id)
> +{
> +	if (WARN_ON(id >= RMI_FEAT_REG_COUNT))
> +		return 0;
> +
> +	return rmi_feat_reg_cache[id];
> +}
> +
> +static int rmi_check_version(void)
> +{
> +	struct arm_smccc_res res;
> +	unsigned short version_major, version_minor;
> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
> +						     RMI_ABI_MINOR_VERSION);
> +	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> +
> +	/* If RME isn't supported, then RMI can't be */
> +	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
> +		return -ENXIO;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
> +
> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
> +		return -ENXIO;
> +
> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
> +
> +	if (res.a0 != RMI_SUCCESS) {
> +		unsigned short high_version_major, high_version_minor;
> +
> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> +
> +		pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
> +		       version_major, version_minor,
> +		       high_version_major, high_version_minor,
> +		       RMI_ABI_MAJOR_VERSION,
> +		       RMI_ABI_MINOR_VERSION);
> +		return -ENXIO;
> +	}
> +
> +	pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
> +
> +	return 0;
> +}
> +
> +static int rmi_read_features(void)
> +{
> +	/*
> +	 * Since we've negotiated a compatible version these feature registers
> +	 * should always be available
> +	 */
> +	for (int i = 0; i < RMI_FEAT_REG_COUNT; i++) {
> +		if (WARN_ON(rmi_features(i, &rmi_feat_reg_cache[i])))
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init arm64_init_rmi(void)
> +{
> +	int ret;
> +
> +	/* Continue without realm support if we can't agree on a version */
> +	ret = rmi_check_version();
> +	if (ret)
> +		return ret;
> +
> +	ret = rmi_read_features();
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/*
> + * Note arm64_init_rmi() must be called before kvm_init_rmi() otherwise KVM
> + * will not support realm guests. subsys_initcall() is called before
> + * module_init() (used for KVM) so this is OK.
> + */
> +subsys_initcall(arm64_init_rmi);

