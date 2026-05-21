Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8145368D6B;
	Thu, 21 May 2026 15:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779377600; cv=none; b=TJi50+i+XXbCgu3EIOgFHOZbOB/EegeNoU3N0ZO3gonOg1WBJ/V0YJ6qX66Dz1rB6Cj/DuFDyLWsThEzzblfolVvk0FiQHUJj5vG9oZSpe139SVDs8zdzz7Ck1LTQS5/mgr99tJpGYInFivm3oVsgoSaksDM2ObAsOS35kxOA+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779377600; c=relaxed/simple;
	bh=jRpDWZllViOIhdxWgcvcrGP6DY9oO4m2EiLTS9DbBI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHuHOS04KN7ArV5ZgrAUxh5MJkaFEhy5vW4LbQtny9hM04hODaWG09vVN1csUgMc3svmiioRXoYoWWHsdBijxvH1StUrgnh+zKTU1sHgxGsqArIQkXXsHA7nz2tOzQZxr2DyxV3F97xcc8bqhmRxZCPDhh8FuD8sR1wmuotFp/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NTzE3ZpR; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NTzE3ZpR"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E206E1C25;
	Thu, 21 May 2026 08:33:12 -0700 (PDT)
Received: from [10.1.32.22] (e122027.cambridge.arm.com [10.1.32.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEB9B3F7B4;
	Thu, 21 May 2026 08:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779377598; bh=jRpDWZllViOIhdxWgcvcrGP6DY9oO4m2EiLTS9DbBI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NTzE3ZpR34hknc3Oe4ExcKxHcifZK4kcAeciWHTNFVx14yLqlL+/jQ/+UDXQ5sIvX
	 gf2HD/p35PYjtb9tXdGrGeutS6bl7wT4412iKdnBy7DcF4Mm7xpiWp+xSFH3iuJ2d2
	 BYO4+PJaDBI6OJ+PaIq4Hfv19Xe4Wrh7RkfMboks=
Message-ID: <3261b04f-1a0c-451d-8981-1e2bccc8a9ca@arm.com>
Date: Thu, 21 May 2026 16:33:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/44] arm64: RMI: Add SMC definitions for calling the
 RMM
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
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
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-5-steven.price@arm.com> <86ecj5vsu4.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86ecj5vsu4.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/05/2026 13:40, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:12 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 2.0-bet1
>>
>> [1] https://developer.arm.com/documentation/den0137/2-0bet1/
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v13:
>>  * Updated to RMM spec v2.0-bet1
>> Changes since v12:
>>  * Updated to RMM spec v2.0-bet0
>> Changes since v9:
>>  * Corrected size of 'ripas_value' in struct rec_exit. The spec states
>>    this is an 8-bit type with padding afterwards (rather than a u64).
>> Changes since v8:
>>  * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
>>    permits to be modified.
>> Changes since v6:
>>  * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
>>    these are flag values.
>> Changes since v5:
>>  * Sorted the SMC #defines by value.
>>  * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>>    RMI calls.
>>  * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>>    number of available list registers could be lower.
>>  * Provided a define for the reserved fields of FeatureRegister0.
>>  * Fix inconsistent names for padding fields.
>> Changes since v4:
>>  * Update to point to final released RMM spec.
>>  * Minor rearrangements.
>> Changes since v3:
>>  * Update to match RMM spec v1.0-rel0-rc1.
>> Changes since v2:
>>  * Fix specification link.
>>  * Rename rec_entry->rec_enter to match spec.
>>  * Fix size of pmu_ovf_status to match spec.
>> ---
>>  arch/arm64/include/asm/rmi_smc.h | 448 +++++++++++++++++++++++++++++++
>>  1 file changed, 448 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>
>> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
>> new file mode 100644
>> index 000000000000..a09b7a631fef
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_smc.h
>> @@ -0,0 +1,448 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + *
>> + * The values and structures in this file are from the Realm Management Monitor
>> + * specification (DEN0137) version 2.0-bet1:
>> + * https://developer.arm.com/documentation/den0137/2-0bet1/
> 
> How long is this spec going to be available on the ARM web site, which
> has a tendency of being reorganised every other week? And there is
> already a beta2.

Obviously I can't predict the next reorganisation - but at least it's a
link that could be fed into archive.org or similar.

There is a beta2 - that was released just after this series. I'll
obviously be updating to that shortly. Sadly the spec is still a bit of
a moving target, but hopefully all the major changes have already happened.

> 
>> + */
>> +
>> +#ifndef __ASM_RMI_SMC_H
>> +#define __ASM_RMI_SMC_H
>> +
>> +#include <linux/arm-smccc.h>
>> +
>> +#define SMC_RMI_CALL(func)				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
>> +			   ARM_SMCCC_SMC_64,		\
>> +			   ARM_SMCCC_OWNER_STANDARD,	\
>> +			   (func))
>> +
>> +#define SMC_RMI_VERSION				SMC_RMI_CALL(0x0150)
>> +
>> +#define SMC_RMI_RTT_DATA_MAP_INIT		SMC_RMI_CALL(0x0153)
>> +
>> +#define SMC_RMI_REALM_ACTIVATE			SMC_RMI_CALL(0x0157)
>> +#define SMC_RMI_REALM_CREATE			SMC_RMI_CALL(0x0158)
>> +#define SMC_RMI_REALM_DESTROY			SMC_RMI_CALL(0x0159)
>> +#define SMC_RMI_REC_CREATE			SMC_RMI_CALL(0x015a)
>> +#define SMC_RMI_REC_DESTROY			SMC_RMI_CALL(0x015b)
>> +#define SMC_RMI_REC_ENTER			SMC_RMI_CALL(0x015c)
>> +#define SMC_RMI_RTT_CREATE			SMC_RMI_CALL(0x015d)
>> +#define SMC_RMI_RTT_DESTROY			SMC_RMI_CALL(0x015e)
>> +
>> +#define SMC_RMI_RTT_READ_ENTRY			SMC_RMI_CALL(0x0161)
>> +
>> +#define SMC_RMI_RTT_DEV_VALIDATE		SMC_RMI_CALL(0x0163)
>> +#define SMC_RMI_PSCI_COMPLETE			SMC_RMI_CALL(0x0164)
>> +#define SMC_RMI_FEATURES			SMC_RMI_CALL(0x0165)
>> +#define SMC_RMI_RTT_FOLD			SMC_RMI_CALL(0x0166)
>> +
>> +#define SMC_RMI_RTT_INIT_RIPAS			SMC_RMI_CALL(0x0168)
>> +#define SMC_RMI_RTT_SET_RIPAS			SMC_RMI_CALL(0x0169)
>> +#define SMC_RMI_VSMMU_CREATE			SMC_RMI_CALL(0x016a)
>> +#define SMC_RMI_VSMMU_DESTROY			SMC_RMI_CALL(0x016b)
>> +#define SMC_RMI_RMM_CONFIG_SET			SMC_RMI_CALL(0x016e)
>> +#define SMC_RMI_PSMMU_IRQ_NOTIFY		SMC_RMI_CALL(0x016f)
>> +
>> +#define SMC_RMI_PDEV_ABORT			SMC_RMI_CALL(0x0174)
>> +#define SMC_RMI_PDEV_COMMUNICATE		SMC_RMI_CALL(0x0175)
>> +#define SMC_RMI_PDEV_CREATE			SMC_RMI_CALL(0x0176)
>> +#define SMC_RMI_PDEV_DESTROY			SMC_RMI_CALL(0x0177)
>> +#define SMC_RMI_PDEV_GET_STATE			SMC_RMI_CALL(0x0178)
>> +
>> +#define SMC_RMI_PDEV_STREAM_KEY_REFRESH		SMC_RMI_CALL(0x017a)
>> +#define SMC_RMI_PDEV_SET_PUBKEY			SMC_RMI_CALL(0x017b)
>> +#define SMC_RMI_PDEV_STOP			SMC_RMI_CALL(0x017c)
>> +#define SMC_RMI_RTT_AUX_CREATE			SMC_RMI_CALL(0x017d)
>> +#define SMC_RMI_RTT_AUX_DESTROY			SMC_RMI_CALL(0x017e)
>> +#define SMC_RMI_RTT_AUX_FOLD			SMC_RMI_CALL(0x017f)
>> +
>> +#define SMC_RMI_VDEV_ABORT			SMC_RMI_CALL(0x0185)
>> +#define SMC_RMI_VDEV_COMMUNICATE		SMC_RMI_CALL(0x0186)
>> +#define SMC_RMI_VDEV_CREATE			SMC_RMI_CALL(0x0187)
>> +#define SMC_RMI_VDEV_DESTROY			SMC_RMI_CALL(0x0188)
>> +#define SMC_RMI_VDEV_GET_STATE			SMC_RMI_CALL(0x0189)
>> +#define SMC_RMI_VDEV_UNLOCK			SMC_RMI_CALL(0x018a)
>> +#define SMC_RMI_RTT_SET_S2AP			SMC_RMI_CALL(0x018b)
>> +#define SMC_RMI_VDEV_COMPLETE			SMC_RMI_CALL(0x018e)
>> +
>> +#define SMC_RMI_VDEV_GET_INTERFACE_REPORT	SMC_RMI_CALL(0x01d0)
>> +#define SMC_RMI_VDEV_GET_MEASUREMENTS		SMC_RMI_CALL(0x01d1)
>> +#define SMC_RMI_VDEV_LOCK			SMC_RMI_CALL(0x01d2)
>> +#define SMC_RMI_VDEV_START			SMC_RMI_CALL(0x01d3)
>> +
>> +#define SMC_RMI_VSMMU_EVENT_NOTIFY		SMC_RMI_CALL(0x01d6)
>> +#define SMC_RMI_PSMMU_ACTIVATE			SMC_RMI_CALL(0x01d7)
>> +#define SMC_RMI_PSMMU_DEACTIVATE		SMC_RMI_CALL(0x01d8)
>> +
>> +#define SMC_RMI_PSMMU_ST_L2_CREATE		SMC_RMI_CALL(0x01db)
>> +#define SMC_RMI_PSMMU_ST_L2_DESTROY		SMC_RMI_CALL(0x01dc)
>> +#define SMC_RMI_DPT_L0_CREATE			SMC_RMI_CALL(0x01dd)
>> +#define SMC_RMI_DPT_L0_DESTROY			SMC_RMI_CALL(0x01de)
>> +#define SMC_RMI_DPT_L1_CREATE			SMC_RMI_CALL(0x01df)
>> +#define SMC_RMI_DPT_L1_DESTROY			SMC_RMI_CALL(0x01e0)
>> +#define SMC_RMI_GRANULE_TRACKING_GET		SMC_RMI_CALL(0x01e1)
>> +
>> +#define SMC_RMI_GRANULE_TRACKING_SET		SMC_RMI_CALL(0x01e3)
>> +
>> +#define SMC_RMI_RMM_CONFIG_GET			SMC_RMI_CALL(0x01ec)
>> +
>> +#define SMC_RMI_RMM_STATE_GET			SMC_RMI_CALL(0x01ee)
>> +
>> +#define SMC_RMI_PSMMU_EVENT_CONSUME		SMC_RMI_CALL(0x01f0)
>> +#define SMC_RMI_GRANULE_RANGE_DELEGATE		SMC_RMI_CALL(0x01f1)
>> +#define SMC_RMI_GRANULE_RANGE_UNDELEGATE	SMC_RMI_CALL(0x01f2)
>> +#define SMC_RMI_GPT_L1_CREATE			SMC_RMI_CALL(0x01f3)
>> +#define SMC_RMI_GPT_L1_DESTROY			SMC_RMI_CALL(0x01f4)
>> +#define SMC_RMI_RTT_DATA_MAP			SMC_RMI_CALL(0x01f5)
>> +#define SMC_RMI_RTT_DATA_UNMAP			SMC_RMI_CALL(0x01f6)
>> +#define SMC_RMI_RTT_DEV_MAP			SMC_RMI_CALL(0x01f7)
>> +#define SMC_RMI_RTT_DEV_UNMAP			SMC_RMI_CALL(0x01f8)
>> +#define SMC_RMI_RTT_ARCH_DEV_MAP		SMC_RMI_CALL(0x01f9)
>> +#define SMC_RMI_RTT_ARCH_DEV_UNMAP		SMC_RMI_CALL(0x01fa)
>> +#define SMC_RMI_RTT_UNPROT_MAP			SMC_RMI_CALL(0x01fb)
>> +#define SMC_RMI_RTT_UNPROT_UNMAP		SMC_RMI_CALL(0x01fc)
>> +#define SMC_RMI_RTT_AUX_PROT_MAP		SMC_RMI_CALL(0x01fd)
>> +#define SMC_RMI_RTT_AUX_PROT_UNMAP		SMC_RMI_CALL(0x01fe)
>> +#define SMC_RMI_RTT_AUX_UNPROT_MAP		SMC_RMI_CALL(0x01ff)
>> +#define SMC_RMI_RTT_AUX_UNPROT_UNMAP		SMC_RMI_CALL(0x0200)
>> +#define SMC_RMI_REALM_TERMINATE			SMC_RMI_CALL(0x0201)
>> +#define SMC_RMI_RMM_ACTIVATE			SMC_RMI_CALL(0x0202)
>> +#define SMC_RMI_OP_CONTINUE			SMC_RMI_CALL(0x0203)
>> +#define SMC_RMI_PDEV_STREAM_CONNECT		SMC_RMI_CALL(0x0204)
>> +#define SMC_RMI_PDEV_STREAM_DISCONNECT		SMC_RMI_CALL(0x0205)
>> +#define SMC_RMI_PDEV_STREAM_COMPLETE		SMC_RMI_CALL(0x0206)
>> +#define SMC_RMI_PDEV_STREAM_KEY_PURGE		SMC_RMI_CALL(0x0207)
>> +#define SMC_RMI_OP_MEM_DONATE			SMC_RMI_CALL(0x0208)
>> +#define SMC_RMI_OP_MEM_RECLAIM			SMC_RMI_CALL(0x0209)
>> +#define SMC_RMI_OP_CANCEL			SMC_RMI_CALL(0x020a)
>> +#define SMC_RMI_VSMMU_FEATURES			SMC_RMI_CALL(0x020b)
>> +#define SMC_RMI_VSMMU_CMD_GET			SMC_RMI_CALL(0x020c)
>> +#define SMC_RMI_VSMMU_CMD_COMPLETE		SMC_RMI_CALL(0x020d)
>> +#define SMC_RMI_PSMMU_INFO			SMC_RMI_CALL(0x020e)
>> +
>> +#define RMI_ABI_MAJOR_VERSION	2
>> +#define RMI_ABI_MINOR_VERSION	0
>> +
>> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
>> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
>> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
>> +
>> +#define RMI_UNASSIGNED			0
>> +#define RMI_ASSIGNED			1
>> +#define RMI_TABLE			2
>> +
>> +#define RMI_RETURN_STATUS(ret)		((ret) & 0xFF)
>> +#define RMI_RETURN_INDEX(ret)		(((ret) >> 8) & 0xFF)
>> +#define RMI_RETURN_MEMREQ(ret)		(((ret) >> 8) & 0x3)
>> +#define RMI_RETURN_CAN_CANCEL(ret)	(((ret) >> 10) & 0x1)
> 
> Use FIELD_GET() and specify masks that define the actual fields.

Sure, that makes sense.

>> +
>> +#define RMI_SUCCESS			0
>> +#define RMI_ERROR_INPUT			1
>> +#define RMI_ERROR_REALM			2
>> +#define RMI_ERROR_REC			3
>> +#define RMI_ERROR_RTT			4
>> +#define RMI_ERROR_NOT_SUPPORTED		5
>> +#define RMI_ERROR_DEVICE		6
>> +#define RMI_ERROR_RTT_AUX		7
>> +#define RMI_ERROR_PSMMU_ST		8
>> +#define RMI_ERROR_DPT			9
>> +#define RMI_BUSY			10
>> +#define RMI_ERROR_GLOBAL		11
>> +#define RMI_ERROR_TRACKING		12
>> +#define RMI_INCOMPLETE			13
>> +#define RMI_BLOCKED			14
>> +#define RMI_ERROR_GPT			15
>> +#define RMI_ERROR_GRANULE		16
>> +
>> +#define RMI_OP_MEM_REQ_NONE		0
>> +#define RMI_OP_MEM_REQ_DONATE		1
>> +#define RMI_OP_MEM_REQ_RECLAIM		2
>> +
>> +#define RMI_DONATE_SIZE(req)		((req) & 0x3)
>> +#define RMI_DONATE_COUNT_MASK		GENMASK(15, 2)
>> +#define RMI_DONATE_COUNT(req)		(((req) & RMI_DONATE_COUNT_MASK) >> 2)
>> +#define RMI_DONATE_CONTIG(req)		(!!((req) & BIT(16)))
>> +#define RMI_DONATE_STATE(req)		(!!((req) & BIT(17)))
> 
> FIELD_GET().
> 
>> +
>> +#define RMI_OP_MEM_DELEGATED		0
>> +#define RMI_OP_MEM_UNDELEGATED		1
>> +
>> +#define RMI_ADDR_TYPE_NONE		0
>> +#define RMI_ADDR_TYPE_SINGLE		1
>> +#define RMI_ADDR_TYPE_LIST		2
>> +
>> +#define RMI_ADDR_RANGE_SIZE_MASK	GENMASK(1, 0)
>> +#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
>> +#define RMI_ADDR_RANGE_ADDR_MASK	(PAGE_MASK & GENMASK(51, 0))
>> +#define RMI_ADDR_RANGE_STATE_MASK	BIT(63)
>> +
>> +#define RMI_ADDR_RANGE_SIZE(ar)		(FIELD_GET(RMI_ADDR_RANGE_SIZE_MASK, \
>> +						   (ar)))
>> +#define RMI_ADDR_RANGE_COUNT(ar)	(FIELD_GET(RMI_ADDR_RANGE_COUNT_MASK, \
>> +						   (ar)))
>> +#define RMI_ADDR_RANGE_ADDR(ar)		((ar) & RMI_ADDR_RANGE_ADDR_MASK)
>> +#define RMI_ADDR_RANGE_STATE(ar)	(FIELD_GET(RMI_ADDR_RANGE_STATE_MASK, \
>> +						   (ar)))
>> +
>> +enum rmi_ripas {
>> +	RMI_EMPTY = 0,
>> +	RMI_RAM = 1,
>> +	RMI_DESTROYED = 2,
>> +	RMI_DEV = 3,
>> +};
>> +
>> +#define RMI_NO_MEASURE_CONTENT	0
>> +#define RMI_MEASURE_CONTENT	1
>> +
>> +#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
>> +#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
>> +#define RMI_FEATURE_REGISTER_0_SVE		BIT(9)
>> +#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
>> +#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
>> +#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
>> +#define RMI_FEATURE_REGISTER_0_PMU		BIT(26)
>> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
>> +
>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_4KB	BIT(0)
>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_16KB	BIT(1)
>> +#define RMI_FEATURE_REGISTER_1_RMI_GRAN_SZ_64KB	BIT(2)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_256	BIT(3)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_384	BIT(4)
>> +#define RMI_FEATURE_REGISTER_1_HASH_SHA_512	BIT(5)
>> +#define RMI_FEATURE_REGISTER_1_MAX_RECS_ORDER	GENMASK(9, 6)
>> +#define RMI_FEATURE_REGISTER_1_L0GPTSZ		GENMASK(13, 10)
>> +#define RMI_FEATURE_REGISTER_1_PPS		GENMASK(16, 14)
>> +
>> +#define RMI_FEATURE_REGISTER_2_DA		BIT(0)
>> +#define RMI_FEATURE_REGISTER_2_DA_COH		BIT(1)
>> +#define RMI_FEATURE_REGISTER_2_VSMMU		BIT(2)
>> +#define RMI_FEATURE_REGISTER_2_ATS		BIT(3)
>> +#define RMI_FEATURE_REGISTER_2_MAX_VDEVS_ORDER	GENMASK(7, 4)
>> +#define RMI_FEATURE_REGISTER_2_VDEV_KROU	BIT(8)
>> +#define RMI_FEATURE_REGISTER_2_NON_TEE_STREAM	BIT(9)
>> +
>> +#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES	GENMASK(3, 0)
>> +#define RMI_FEATURE_REGISTER_3_RTT_PLAN			GENMASK(5, 4)
>> +#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT	BIT(6)
>> +
>> +#define RMI_FEATURE_REGISTER_4_MEC_COUNT		GENMASK(63, 0)
>> +
>> +#define RMI_MEM_CATEGORY_CONVENTIONAL		0
>> +#define RMI_MEM_CATEGORY_DEV_NCOH		1
>> +#define RMI_MEM_CATEGORY_DEV_COH		2
>> +
>> +#define RMI_TRACKING_RESERVED			0
>> +#define RMI_TRACKING_NONE			1
>> +#define RMI_TRACKING_FINE			2
>> +#define RMI_TRACKING_COARSE			3
>> +
>> +#define RMI_GRANULE_SIZE_4KB	0
>> +#define RMI_GRANULE_SIZE_16KB	1
>> +#define RMI_GRANULE_SIZE_64KB	2
>> +
>> +/*
>> + * Note many of these fields are smaller than u64 but all fields have u64
>> + * alignment, so use u64 to ensure correct alignment.
>> + */
>> +struct rmm_config {
>> +	union { /* 0x0 */
>> +		struct {
>> +			u64 tracking_region_size;
>> +			u64 rmi_granule_size;
>> +		};
>> +		u8 sizer[0x1000];
> 
> SZ_4K?
> 
>> +	};
>> +};
>> +
>> +#define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
>> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
>> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
>> +
>> +struct realm_params {
>> +	union { /* 0x0 */
>> +		struct {
>> +			u64 flags;
>> +			u64 s2sz;
>> +			u64 sve_vl;
>> +			u64 num_bps;
>> +			u64 num_wps;
>> +			u64 pmu_num_ctrs;
>> +			u64 hash_algo;
>> +			u64 num_aux_planes;
>> +		};
>> +		u8 padding0[0x400];
> 
> SZ_1K? And similarly all over the shop?

I'm a bit less sure that makes the code more readable - these structures
are a bit of a pain because they are somewhat sparse. I've left a
comment where the beginning of each union is, and personally I find it
easier to see 0x0 + 0x400 == 0x400 rather than trying to work out what
SZ_1K is in hex. This is particularly the case in terms of:

> struct rec_params {
> 	union { /* 0x0 */
> 		u64 flags;
> 		u8 padding0[0x100];
> 	};
> 	union { /* 0x100 */
> 		u64 mpidr;
> 		u8 padding1[0x100];
> 	};
> 	union { /* 0x200 */
> 		u64 pc;
> 		u8 padding2[0x100];
> 	};
> 	union { /* 0x300 */
> 		u64 gprs[REC_CREATE_NR_GPRS];
> 		u8 padding3[0xd00];
> 	};
> };

Where 0xd00 doesn't even have a correspoding SZ_ define.

The RMM deals with this with macro magic:

> struct rmi_rec_params {
>         /* Flags */
>         SET_MEMBER_RMI(unsigned long flags, 0, 0x100);  /* Offset 0 */
>         /* MPIDR of the REC */
>         SET_MEMBER_RMI(unsigned long mpidr, 0x100, 0x200);      /* 0x100 */
>         /* Program counter */
>         SET_MEMBER_RMI(unsigned long pc, 0x200, 0x300); /* 0x200 */
>         /* General-purpose registers */
>         SET_MEMBER_RMI(unsigned long gprs[REC_CREATE_NR_GPRS], 0x300, 0x1000); /* 0x300 */
> };

where the offsets are just directly encoded in the macro - but it's not
an especially robust macro and I'm not convinced it's more readable.

I'm happy to hear other suggestions on how to encode this neatly.

> I haven't checked the details of the encodings (life is too short),
> but I wonder how much of this exists as an MRS and could be
> automatically generated?

Automatically generating this would be good - I'm not sure whether we
have a (public) source available to generate from at the moment. I have
tried to methodically work through the spec when updating this file, but
as Gavin has already pointed out there was at least one mistake (in
currently unused definitions) this time.

Thanks,
Steve

