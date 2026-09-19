Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F07363089;
	Sat, 19 Sep 2026 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781292; cv=none; b=jnB92XJc3xx/RJHLoUSwKF63DsGQ9SV0VcKZb6y8zNwenaCZK/f0XIhE8iu6zpVZkYOC8Ds3yhFSq9kFQNYNpP5mx5iXGQe9An5UDe91EAR49vMqZvv/PrFpnax2jyKdqf9CjNRf1Z+SwK1nNhOgGY4RTBSSdfbae9RYC9pMf/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781292; c=relaxed/simple;
	bh=xBkyZH6iSdSNdymCclTI0r6wLkOufX0u7rLgRDfRSAQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=JRsseZrgmayFB6Anx5uieyb0NA13XRMhe03C2MOnnGM5jYxxPYapfC+dXRn5/PE/WW2Rlfu9oTh+btNXS+RUnX/cudaOP474+t/KaB3c5G7VZMnlDTabpTXHlAldw9cPC6FUCd/pNjSzWe3I66KnqEGXFo+6wRMbs5xwQcAPwcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CtZTTJsN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CtZTTJsN"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68INwXdt2267664;
	Sat, 19 Sep 2026 01:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SWy/LsEtrczjIIVigdhZqWco2xuU9StAi1HysiyiSHk=; b=CtZTTJsNUNQt+rP4
	yP7Vv86AgmvcgvJ152qKl4CIqEbHPntz9nDIrJe9ZBbTvbcU2IFDiGR3UnZDDd+R
	Hqq43wxdv17ZxxurFvsz0ue28qtoI98OKEbYc0/Cqljl+5ioEcYj3or41jJ1sSAP
	G8ubNzGhaI5yxA6vVtTad/NQRnRtrObdHZRG7C9GJzgDBikFjoTjUQh4Y1DPTHV6
	StOqWS/PAUbE0DiP33byaTFWxWkW6c/5Lf7z4BfeVHKnD2JF5D7VheprUEd0N+DZ
	ZL94zIsVhK054kAUCc/KnHwijkSlsmi06acFOFxMnuMWv27dc7sE+CQ7Uv8mSOKV
	coVyUw==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gs72u281g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 +0000 (GMT)
Received: from hu-devc-lv-u24-a.qualcomm.com (hu-jcameron-lv.qualcomm.com [10.81.84.69])
	by NALASPPMTA02.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTPS id 68J1RppH3471038
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 GMT
Received: from hu-jcameron-lv.qualcomm.com (localhost [127.0.0.1])
	by hu-devc-lv-u24-a.qualcomm.com (Postfix) with ESMTP id 1AAAE24DF8;
	Fri, 18 Sep 2026 18:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
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
In-Reply-To: <20260912083611.2513845-7-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
Date: Fri, 18 Sep 2026 18:27:45 -0700
Message-Id: <178978126543.2352296.12214136703168879825.b4-review@b4>
X-Mailer: b4 0.17-dev
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: FGz3-zyLI-E1WYi31zj9H_PjW-jtmjH_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX+OGK14wbLIFE
 4FcADTlI6cQIrwnz4K/3OUFsAwE+yD86FEr2QQXZATQik8472EqKg+O+0dJIlv3aFdi+5kjMiqi
 AsDX9+yyimwZNz7aM157X0+VbEdmKOs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX9/wNJxj4wJbb
 +cJI2epfBASP2611cG46ZRhY+q0rAVp5PPpWrv/J6+q1W+Vwf4AruR5IhaXttCotEouuomMy4Mg
 0h+mNfKzo9c9WWEZSpuj2rexnk5pexaXThTLEE+OQQ6Vo1RPVkA4MW+AvGHpbL3CvKCHdaxQvxF
 6sWUqugH6Smhshw/kKNxH5ZFHBH4oq7C94t8jHC7Vo9PgmqrUvxiqsDgZKShENYPygYVoDNQMtr
 62d+gtRhqtS1joaVrFzbbgK+XeM6P3Z+/JYjx4JyLJptgXekSpHMCFdVBpVh7msVpM4U/rdYZeh
 0i7f2NTjUDyBum0bMgBL6Tvu2OEzKLvkf1BO1o6CDRxmS63DQ31f38y9AeQBn+p/k2OGJfoUf8x
 WOzNha0YBdl7+N2FJGjkjXnFZIijwRccu3bHWBdn1fCO348tha3ErEkcUQg+nuoL5gedW8jTK1e
 HQu8uvCIlWJybhu+uwg==
X-Proofpoint-GUID: FGz3-zyLI-E1WYi31zj9H_PjW-jtmjH_
X-Authority-Analysis: v=2.4 cv=DO8acCNb c=1 sm=1 tr=0 ts=6aade517 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=7CQSdrXTAAAA:8
 a=EUspDBNiAAAA:8 a=ANFCpyTuUsUUZqEkrDcA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 suspectscore=0 bulkscore=0
 adultscore=0 spamscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190016

> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region, all pages
> in the region must be of the same state, this implies we need to have "fine"
> tracking for DRAM, so that we can delegate individual pages.
> 
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation by the firmware.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule, then the firmware may need to create L1 tables to track the PAS
> at a finer granularity. Linux therefore checks if the platform firmware manages
> the PAR region. i.e., the firmware is in charge of managing the L1 GPTs
> (creation and the required memory for the GPT tables - via static carveouts)
> without host intervention. Support for dynamic GPT creation by the host will be
> added later.
> 
> If the firmware requires us to manage the tracking or GPT memory, Deactivate
> the RMM and reclaim any memory donated at RMM activation.
> 
> Apply the same checks when hotplugged memory is brought online.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

A few comments inline.


> ---
>  Changes since v17:
>      * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
>  Changes since v16:
>      * Check fine tracking and create L1 GPTs for hotplug-added memory.
>      * Clarify the L1 GPT setup and move the explanatory comment.
>      * Switch to using RMI_GPT_INFO command for checking the GPTs.
>      * Deactivate the RMM and reclaim the memory if we can't proceed.
>  Changes since v15:
>      * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>      * Handle negative error codes from wrappers.
>  Changes since v14:
>      * Move the implementation into drivers/firmware/arm_rmm.
>  Changes since v13:
>      * Moved out of KVM
> ---
>  drivers/firmware/arm_rmm/rmi.c | 200 +++++++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h   |   2 +
>  2 files changed, 202 insertions(+)
>
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index ecc89e91d264..583e1aca9b15 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c


> + */
> +static inline long rmi_gpt_info(unsigned long start, unsigned long end,

Why inline vs letting compiler make it's mind up?
Same in other places

> +				unsigned long *out_top,
> +				unsigned long *out_gpt_par_state)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_GPT_INFO, start, end,
> +	};
> +
> +	rmi_smccc_invoke(&regs);
> +	if (regs.a0 != RMI_SUCCESS)
> +		return regs.a0;
> +
> +	if (out_top)
> +		*out_top = regs.a1;
> +	if (out_gpt_par_state)
> +		*out_gpt_par_state = regs.a2;
> +
> +	return RMI_SUCCESS;
> +}



>  static int __init arm64_init_rmi(void)
>  {
>  	int ret;
> @@ -786,8 +970,24 @@ static int __init arm64_init_rmi(void)
>  	if (ret) {
>  		pr_err("RMM activate failed\n");
>  		ret = ret < 0 ? ret : -ENXIO;
> +		return ret;

Why did this change?

>  	}
>  
> +	ret = rmi_init_metadata();
> +	if (ret)

And this is hitting another bit of guidance in cleanup.h.
Functions shouldn't be mixing __free and friends with
gotos.  Again, not a bug here but there are large ugly
monsters around this stuff, hence the blanket guidance.
I haven't thought that hard on how you avoid it here, but
usually it's a combination of suitable helpers and wrappers
and resulting code is often more readable as a result.

-- 
Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
