Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757143A1C7
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 12:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707742129; cv=none; b=mFmQW+cIP7SKPuBbe7gcqw5o+hL57s7y9vwUp2ztq7ycO7IH9UE3SXyuwEsfl1PYdGt7AytxFB/TnGNzZH/usdHV7QgzCAf0IitIYLKHRSrC9RVkIKeGRmMnK/jpV0C/Q4vsGFfcc5GqKz/jHHy/KFIvY38jGJGHyxTucgYffTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707742129; c=relaxed/simple;
	bh=5FQ3NiAdyEkTEr9w+FtaAYvNtplWskRxrnlkdh+9bJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=IBQ1sMCDZTN0i1J6u4fvzMG7A4oEJd+kCXU4MIPpM4IUpcpoAXaCupsv+0OKDI8WD9dUolYi3xHuDGLB37x4Y6LsAlgDr5Woq95tvjO7dzspXVY+P1GbSPykbKW8dpPTHAAkp8W8e+HO4EY5TKmVPMZATIPU7SgMLFqADo4Bgrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rtvTyLpv; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rtvTyLpv"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240212124837euoutp02206f72a97c8e179e082967b4b56d9633~zHmh8N0c41761417614euoutp02Y
	for <kvmarm@lists.linux.dev>; Mon, 12 Feb 2024 12:48:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240212124837euoutp02206f72a97c8e179e082967b4b56d9633~zHmh8N0c41761417614euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707742117;
	bh=d44lPDARd4ZiU6xOkjZaGnKZQJFHYJ/v3YSgkLgTRoI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=rtvTyLpvZ0zmVc3Aoi4GYHoJ4eOYp2qkVFJe3PfUSJsag7dZ41g945W4DS05zdX0P
	 iKd9R4uRqPJwaNBNkg6lkoBM7vUQxsfePcdrwqyJJcpMiFNxymNTptggqPVi9JynFo
	 4k3RDBX3+wBXPFotUfwDkWmQFJs9dbJF04svY1gI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240212124837eucas1p1fe5faa2b5f0fa9cdeefd472d1e8d0abe~zHmhrCKFo1096910969eucas1p1P;
	Mon, 12 Feb 2024 12:48:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id A1.43.09814.5A31AC56; Mon, 12
	Feb 2024 12:48:37 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172~zHmhLxeUs0420104201eucas1p2o;
	Mon, 12 Feb 2024 12:48:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240212124836eusmtrp2e9594420af1de918f494e64814f06127~zHmhK1ay52716027160eusmtrp2M;
	Mon, 12 Feb 2024 12:48:36 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-e6-65ca13a52e93
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id A2.C7.09146.4A31AC56; Mon, 12
	Feb 2024 12:48:36 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240212124836eusmtip275f391299e69bba1f770809a1f9b5b1e~zHmgdE7NV1065510655eusmtip2P;
	Mon, 12 Feb 2024 12:48:36 +0000 (GMT)
Message-ID: <e3cc70fb-16d9-4e4e-aa35-f0eb2baaf166@samsung.com>
Date: Mon, 12 Feb 2024 13:48:35 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/10] arm64: cpufeature: Detect HCR_EL2.NV1 being
 RES0
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
	<will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Ard Biesheuvel <ardb@kernel.org>, James Morse
	<james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20240122181344.258974-7-maz@kernel.org>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsWy7djP87pLhU+lGtxYI2Hx88t7Rov3y3oY
	Le7vW85k8WrLYRaLTY+vsVosvX6RyWLnnJOsFlN/vmGzmHn7NqNFyx1Ti5tLN7A7cHusmbeG
	0aPlyFtWj02rOtk8FjZMZfbYvKTe48XmmYwBbFFcNimpOZllqUX6dglcGQ/6zzIV/JCv2HL3
	CHsD42upLkZODgkBE4mLc4+zgNhCAisYJba1aXcxcgHZXxglvvStZ4JwPjNKzG3bzwrT0Xdk
	KVRiOaPEr/mPWCGcj4wS81b9YwOp4hWwk3hyaz5YB4uAqsS9rVcZIeKCEidnPgHbJyogL3H/
	1gx2EFtYIEDiReNisDizgLjErSfzmUBsEYFEide31rGBLGAW2MwkcezMXmaQBJuAoUTX2y6w
	ZZwCphJTe24wQzTLSzRvnc0M0iAh0M4J1LCTGeJuF4lL7dsZIWxhiVfHt7BD2DIS/3fOZ4Jq
	YJRY8Ps+lDOBUaLh+S2oDmuJO+d+Aa3jAFqhKbF+lz5E2FFi27cPYGEJAT6JG28FIY7gk5i0
	bTozRJhXoqNNCKJaTWLW8XVwaw9euMQ8gVFpFlK4zELy/ywk78xC2LuAkWUVo3hqaXFuemqx
	UV5quV5xYm5xaV66XnJ+7iZGYNo6/e/4lx2My1991DvEyMTBeIhRgoNZSYT30owTqUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5VVPkU4UE0hNLUrNTUwtSi2CyTBycUg1MLMJL30xYfiRL+Ij0
	rmnBOnwWU5OkLqjpZpjcCE+/YSwY2xX4dsOHJQw57Ncdlx4Qyl+4y2uN3QaNiweENzhdPPtb
	yqn8oNfmdPGiz5zbgyeemiuTkvjLOPtgaPe3buWyAzssFvo+36QrX7nB67fr5VrpjqPp4uc/
	Ob5Iy/ueqhbF+m7uvyWMzx2KLqbc6GOYt+D/JiumrYeaNeVPH1+/5auiyIb/anXb/wYf6Fc7
	Htb+z8WsfctyA7a/qh0L3U582feeb+ux8+7Fqo/PSj15Vsx9nV/aIHpVvPLN+zMF9yl/U/C+
	t1NvkaRH75lzCRcZ5JOKJE095zzemvj97byTLGXXL6y3u+UbIs7XwLtISImlOCPRUIu5qDgR
	AHOn6yrKAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xe7pLhE+lGrz9YGHx88t7Rov3y3oY
	Le7vW85k8WrLYRaLTY+vsVosvX6RyWLnnJOsFlN/vmGzmHn7NqNFyx1Ti5tLN7A7cHusmbeG
	0aPlyFtWj02rOtk8FjZMZfbYvKTe48XmmYwBbFF6NkX5pSWpChn5xSW2StGGFkZ6hpYWekYm
	lnqGxuaxVkamSvp2NimpOZllqUX6dgl6GQ/6zzIV/JCv2HL3CHsD42upLkZODgkBE4m+I0uZ
	uhi5OIQEljJKTDx8lAkiISNxcloDK4QtLPHnWhcbRNF7RomWDXvAingF7CSe3JoPVsQioCpx
	b+tVRoi4oMTJmU9YQGxRAXmJ+7dmsIPYwgJ+Enf+dIHZzALiEreezAebIyKQKHHx+k6wBcwC
	m5kkJhyaBDSUA2hbvET39HqQGjYBQ4mutyBHcHJwCphKTO25wQwxx0yia2sXI4QtL9G8dTbz
	BEahWUjOmIVk3SwkLbOQtCxgZFnFKJJaWpybnltsqFecmFtcmpeul5yfu4kRGKXbjv3cvINx
	3quPeocYmTgYDzFKcDArifBemnEiVYg3JbGyKrUoP76oNCe1+BCjKTAsJjJLiSbnA9NEXkm8
	oZmBqaGJmaWBqaWZsZI4r2dBR6KQQHpiSWp2ampBahFMHxMHp1QDk3bHhQZd6fn2ggU3+J5O
	khQTMZ2y2Et6g2B5ffa16aVfgtSOlPIzcC0K0J96J8awIf/GMtdehY3a8+Lr/p/8tCJw+zof
	6Zr08tK7nz//mjn5TUjwMZMTXyr1Ny1Ru3gnimXqxO8rN5Uym0hOP9rx+mLaJ6FX224v0WJU
	k1vk1FZieG3v6VMbLjfnf1uksTb50rWFSrF/wpPF1+jLtEdv/aXy++etk1O3P55bFbKyMaT+
	1PULBooHfUMijU9qy3vEXDb7E6u7RXtTZrmG5rTq9rcicgvLHkqIb1ZwK+l7nPTH4N47pQfr
	zbYUVilp7We7uGWu/37eumm/k98J5M+b6PT/grWQX61Iz7/za2LvzVdiKc5INNRiLipOBABQ
	KiVHWwMAAA==
X-CMS-MailID: 20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172
References: <20240122181344.258974-1-maz@kernel.org>
	<20240122181344.258974-7-maz@kernel.org>
	<CGME20240212124837eucas1p231da54bb0ff8d46d38c6c7e627e50172@eucas1p2.samsung.com>

Dead All,

On 22.01.2024 19:13, Marc Zyngier wrote:
> A variant of FEAT_E2H0 not being implemented exists in the form of
> HCR_EL2.E2H being RES1 *and* HCR_EL2.NV1 being RES0 (indicating that
> only VHE is supported on the host and nested guests).
>
> Add the necessary infrastructure for this new CPU capability.
>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

This patch landed recently in linux-next as commit da9af5071b25 ("arm64: 
cpufeature: Detect HCR_EL2.NV1 being RES0"). I found that it causes a 
following regression in the CPU hot-plug operation:

# for i in /sys/devices/system/cpu/cpu[1-9]; do echo 1 >$i/online; done
------------[ cut here ]------------
kernel BUG at arch/arm64/kernel/cpufeature.c:1468!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in: dw_hdmi_cec dw_hdmi_i2s_audio crct10dif_ce 
snd_soc_simple_card rockchip_saradc industrialio_triggered_buffer 
hantro_vpu kfifo_buf snd_soc_simple_card_utils rockchip_thermal 
phy_rockchip_naneng_combphy display_connector gpio_ir_recv v4l2_vp9 
v4l2_h264 v4l2_mem2mem dwmac_rk videobuf2_dma_contig stmmac_platform 
videobuf2_memops videobuf2_v4l2 stmmac rockchipdrm videodev 
snd_soc_rockchip_i2s_tdm snd_soc_rk817 pcs_xpcs panfrost rtc_rk808 
rk805_pwrkey analogix_dp rk817_charger spi_rockchip_sfc dw_mipi_dsi 
videobuf2_common dw_hdmi drm_shmem_helper mc gpu_sched 
drm_display_helper ahci_dwc ip_tables x_tables ipv6
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.8.0-rc1+ #14563
Hardware name: Hardkernel ODROID-M1 (DT)
pstate: 800001c9 (Nzcv dAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __read_sysreg_by_encoding+0x38c/0x390
lr : read_scoped_sysreg+0x4c/0x70
...
Call trace:
  __read_sysreg_by_encoding+0x38c/0x390
  read_scoped_sysreg+0x4c/0x70
  has_nv1+0x18/0x48
  verify_local_cpu_caps+0x54/0x124
  check_local_cpu_capabilities+0x28/0x208
  secondary_start_kernel+0xb0/0x154
  __secondary_switched+0xb8/0xbc
Code: d53802f3 17ffff3b d5380253 17ffff39 (d4210000)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x1,80000000,80050295,2100721b
Memory Limit: none
---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

It looks that some additional checks are needed for the CPU hot-plug case.

>   arch/arm64/kernel/cpufeature.c | 12 ++++++++++++
>   arch/arm64/tools/cpucaps       |  1 +
>   2 files changed, 13 insertions(+)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index ad3753fbdcb1..91249d20883b 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1794,6 +1794,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
>   	return !meltdown_safe;
>   }
>   
> +static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	return !has_cpuid_feature(entry, scope);
> +}
> +
>   #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
>   static bool has_lpa2_at_stage1(u64 mmfr0)
>   {
> @@ -2794,6 +2799,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>   		.matches = has_lpa2,
>   	},
> +	{
> +		.desc = "NV1",
> +		.capability = ARM64_HAS_HCR_NV1,
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.matches = has_nv1,
> +		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
> +	},
>   	{},
>   };
>   
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index b912b1409fc0..65090dd34641 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -35,6 +35,7 @@ HAS_GENERIC_AUTH_IMP_DEF
>   HAS_GIC_CPUIF_SYSREGS
>   HAS_GIC_PRIO_MASKING
>   HAS_GIC_PRIO_RELAXED_SYNC
> +HAS_HCR_NV1
>   HAS_HCX
>   HAS_LDAPR
>   HAS_LPA2

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

