Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F618367F5E;
	Sat, 19 Sep 2026 01:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781293; cv=none; b=vFHIyiwiBfdMmNAtySTVARyTDI4rjAfCSQkAZEXuCsOMUadsfwDdRMFSEm+dTwgOpYiyHTH2x6+IslM8M9X7NhCJNOhobIGn9ylDotKrNgqZ1qQPtvnAURxoAB2cGYzYj9gFY15WkXMoynukJWanhgGoAh2kVASWBd3UdPoaix0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781293; c=relaxed/simple;
	bh=01rCRyqgxnN3/mgu+0CrIgXsm4ZIWzg41CVlS8W84kQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=EB6BUL8IkeKg4hzmxqCgcHnsp1xBrSCSb60GE2FOY7wO8Bs1C6tx/XhK6TLMVb+LuosEl9SK3uwJcbDt428XbZ3jPVek/TGGthdHn4SG1boQl0na3m7tei5g4hoU8CUOh8l1nX3J6pwDKEXTiHHnbDp7utDl3dRF9Ybw2HniXuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XRBYKCG0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XRBYKCG0"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J0gfNV3380737;
	Sat, 19 Sep 2026 01:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jOszlEhsREU8ur26W/fzd1dwj4oC9vIW0wwZ2gdS9FY=; b=XRBYKCG03ZDE7OKa
	37tkcSV3RAH2dwH8vS1b1mmFeNHQUC2V1gNnC1vEmLZDMM9DABKnGcpIcz64r1sw
	keUXjaS/xJivNJVxou/NM+PClZIYQP8Uf3W9JZz4ggSh624UYUYpDyNSydR6wETb
	s9XYTDgBiqrH3U49zL26RBp7p4bpcnYBrE4f2skYa2iMuT6R4uZaipuC1wwk6sE1
	Dfo5Hl2Rrr1RVMQg0OWqpUC+e+mMWq1Q6C6tqYvdmZxpnKgLplq/5eB/rOFdj+qr
	cX4hDSA8k2US7cF6wKR92A38HsSC655dCrgIrYTjmWgeA9saRLOSc2Xiu94OF7Q8
	c7I2yA==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gsg3f032p-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 +0000 (GMT)
Received: from hu-devc-lv-u24-a.qualcomm.com (hu-jcameron-lv.qualcomm.com [10.81.84.69])
	by NALASPPMTA01.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTPS id 68J1RpGQ3476835
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 GMT
Received: from hu-jcameron-lv.qualcomm.com (localhost [127.0.0.1])
	by hu-devc-lv-u24-a.qualcomm.com (Postfix) with ESMTP id 10E27217B0;
	Fri, 18 Sep 2026 18:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
In-Reply-To: <20260912083611.2513845-2-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
Date: Fri, 18 Sep 2026 18:27:45 -0700
Message-Id: <178978126540.2352296.16845657485139032765.b4-review@b4>
X-Mailer: b4 0.17-dev
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX/1hOwdD6+6iq
 Pw8hk0+frowJlymXnPUvRhhUBfehc9oT8VYYPUbvyPiCm7uHhb/Zowtunud3zcIAlkInYS73JWd
 z0hpehnWFaE2Bny82vgFz10LqgHIde0=
X-Proofpoint-ORIG-GUID: ZTHL2QsPlv_fHuiNBqdX6jLD1y1Ca2wX
X-Proofpoint-GUID: ZTHL2QsPlv_fHuiNBqdX6jLD1y1Ca2wX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfXyA3Z0OHKJ2Mw
 ClnMwM+k3RViVgDM2x2t2Mc6rdD+mnKMfh4F/cvunZvZcZkIHMWKzvl3QOPTxZ06AW4KP6YKK+R
 tXKlKdvn8SEAERWaVDKsJTRwoVTWZIv6FJajfQSQoC1pom4qDMTxhyxLz47BfPPpuw9DD9G+tG9
 AewsFk96lwux65eY6UFMrcKZMqo3bBZPHOxyan29zDomZXyVWwxKpsFQlLYxJVnZbZNquJI4x/S
 G4jNmTfbTJdbQDf7gV+9VQoD5E4TN/dXcmlSbmPWhp4q35rJWJH2gTZcpj2yLKOsyycxyCdv1Pt
 gVVPz1WTHV26WKBJeBPTpH7G22+FgtUlBYNjuyFucSuwVxJTzHiWQOzT78J40QOE4u07l2R61Us
 Nbwj8FWaEyhcbQZsYr7iKiFQcUvCxLy4kpnkuagbRW6C+v1POWA+562ifEejnEt8dlVeQbEgpiz
 cP+rZAgAK7YQ9CUKSSg==
X-Authority-Analysis: v=2.4 cv=N6S8hG9B c=1 sm=1 tr=0 ts=6aade517 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=7CQSdrXTAAAA:8
 a=EUspDBNiAAAA:8 a=dlddJRs0OWu8TNdq08oA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609190016

> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 2.0-bet3
> 
> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
comments inline.  Mostly on subtle inconsistencies that really don't
matter that much.

>  include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
>  1 file changed, 497 insertions(+)
>  create mode 100644 include/linux/arm-smccc-rmi.h
>
> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
> new file mode 100644
> index 000000000000..214d6228dfc2
> --- /dev/null
> +++ b/include/linux/arm-smccc-rmi.h
> @@ -0,0 +1,497 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2026 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 2.0-bet3:
> + * https://developer.arm.com/documentation/den0137/2-0bet3/
> + */
> +
> +#ifndef __LINUX_ARM_SMCCC_RMI_H_
> +#define __LINUX_ARM_SMCCC_RMI_H_
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/build_bug.h>
> +#include <linux/sizes.h>
> +
> +#include <asm/page.h>
> +
> +#define SMC_RMI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD,	\
> +			   (func))

Obviously it is v18 so probably a future thing but nothing about this
is RMI specific.  Could be used for ARM_SMCCC_TRNG_RND64 for instance.
I'm not entirely sure what we'd call such a macro

ARM_SMCCC_CALL_VAL64_STD() maybe?

I'm not just not keen on macros whose names to me hint at something
special. FWIW this also matches SMC_RSI_FID() and FFA_SMC64().
Isn't it nice when we have a predictable naming scheme :)

FID (for Function IDentifier) is in the spec, so maybe?

Anyhow, I don't really care that much.

> +
> +#define SMC_RMI_VERSION				SMC_RMI_CALL(0x0150)
> +


> +#define RMI_ABI_MAJOR_VERSION	2
> +#define RMI_ABI_MINOR_VERSION	0
> +
> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)

I'd mask it.  Mostly because that would shout that it is only 15 bits.

> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))

I'd go all in on FIELD_PREP() / FIELD_GET() + GENMASK just for the
sake of consistency + not having to be careful that everything is
checked for fit to keep the LLM bots happy.

> +
> +#define RMI_RETURN_STATUS_MASK		GENMASK(7, 0)
> +#define RMI_RETURN_INDEX_MASK		GENMASK(15, 8)
> +#define RMI_RETURN_MEMREQ_MASK		GENMASK(9, 8)
> +#define RMI_RETURN_CAN_CANCEL_MASK	BIT(10)
> +
> +#define RMI_RETURN_STATUS(ret)		FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
> +#define RMI_RETURN_INDEX(ret)		FIELD_GET(RMI_RETURN_INDEX_MASK, ret)

What's this one?  I can't find anything in the spec that matches it
and as far as I can tell you don't use it in this series.

> +#define RMI_RETURN_MEMREQ(ret)		FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
> +#define RMI_RETURN_CAN_CANCEL(ret)	FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)
These are obscure enough to find in the spec I'd give a comment just
to save the sanity of anyone looking for them.

> +/*
> + * Note many of these fields are smaller than u64 but all fields have u64
> + * alignment, so use u64 to ensure correct alignment.

Obviously this is only going to run on arm64 so it's not critical, but
more generally u64s aren't always 64 bit aligned.  So if you 'really'
care aligned_u64 is there to ensure it.  Meh, arm64 so fine.

> + */
> +struct rmm_config {
> +	union { /* 0x0 */
> +		struct {
> +			u64 tracking_region_size;
> +			u64 rmi_granule_size;
> +		};
> +		u8 sizer[SZ_4K];
> +	};
> +};
> +
> +static_assert(sizeof(struct rmm_config) == SZ_4K);
> +
> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
> +#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
> +#define RMI_REALM_PARAM_FLAG_LFA_POLICY		GENMASK(6, 5)
> +#define RMI_REALM_PARAM_FLAG_MEC_POLICY		GENMASK(8, 7)

Tiny bit inconsistent. When do you decide _MASK is needed and when
not?  Seems a little too random for multibit fields.
> +
> +struct rec_params {
> +	union { /* 0x0 */
> +		u64 flags;
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		u64 mpidr;
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 pc;
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		u64 gprs[REC_CREATE_NR_GPRS];
> +		u8 padding3[0xd00];
> +	};
> +};
> +
> +static_assert(sizeof(struct rec_params) == SZ_4K);
Whilst the assert works and is need to prevent oversized the
dos never seem to provide any indication of the final trailing
padding other than indirectly and I don't like maths on Fridays ;).
Maybe union the inner union set with a u8 [SZ_4K]?

> +
> +struct rec_exit {
> +	union { /* 0x000 */
> +		u8 exit_reason;
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		struct {
> +			u64 esr;
> +			u64 far;
> +			u64 hpfar;
> +			u64 rtt_tree;
> +		};
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 gprs[REC_RUN_GPRS];
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		u8 padding3[0x100];

Why does this one exist rather than padding above
by 0x200?  Other structures don't seem to keep
to a specific stride so I'm not sure what this gives
you here.

> +	};
> +	union { /* 0x400 */
> +		struct {
> +			u64 cntp_ctl;
> +			u64 cntp_cval;
> +			u64 cntv_ctl;
> +			u64 cntv_cval;
> +		};
> +		u8 padding4[0x100];
> +	};
> +	union { /* 0x500 */
> +		struct {
> +			u64 ripas_base;
> +			u64 ripas_top;
> +			u8 ripas_value;
> +			u8 padding5[0xf];

In various other places you just use a u64 for a u8
+ padding. Why is this one special? And for that matter
various other fields later in this particular structure?

> +			u64 s2ap_base;
> +			u64 s2ap_top;
> +			u64 vdev_id_1;
> +			u64 vdev_id_2;
> +			u64 dev_mem_base;
> +			u64 dev_mem_top;
> +			u64 dev_mem_pa;
> +		};
> +		u8 padding6[0x100];
> +	};
> +	union { /* 0x600 */
> +		struct {
> +			u16 imm;
> +			u8 padding7[0x6];
> +			u64 plane;
> +		};
> +		u8 padding8[0x100];
> +	};
> +	union { /* 0x700 */
> +		struct {
> +			u8 pmu_ovf_status;
> +			u8 padding9[0xf];
> +			u64 vsmmu;
> +		};
> +		u8 padding10[0x100];
> +	};
> +};
> +
> +static_assert(sizeof(struct rec_exit) == SZ_2K);

> +
> +/* RMI_RTT_UNPROT_MAP_FLAGS definitions */

How this counts as a 'flags' field is slightly beyond me, but
indeed matches the spec naming even though it's a grab bag
of small fields...

> +#define RMI_RTT_UNPROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR	GENMASK(18, 16)
> +#define RMI_RTT_UNPROT_MAP_FLAGS_S2AP		GENMASK(22, 19)

Nothing signficant enough in here to absolutely require changes so
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

-- 
Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
