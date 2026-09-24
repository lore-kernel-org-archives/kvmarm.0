Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744214CC620
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790285916; cv=none; b=L3bkJ86PKA/i5K2T47L0GjU8u6YyDzxP5t/qBmB8LWWtx99rc+WQ6WuPd/t/mPZ0P1zLZLVAhl+mR7WjiIsTYLkt36TUONrtbJx/2iftTPcRPlpXt4mPw/B/y9FPe/Ez1GM2W41nfcm0N7dyXReNTr+T2xydleiyOWBhvLXKqQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790285916; c=relaxed/simple;
	bh=wWkj0DV/RGxV8HhwtwWyQ7dXRw1tyCgB07k8nLpBO6o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEEfIpkQRiTi7zAGxwpbP3q+z+DtNw0JzDppiAN6JCsQyx4VWTDgj6Zyu51e8KULwC/x9MbhW+ByqXRpr5e0rpag5KJq04aJg16PW4UxAGFVK8PvlXjqCFh0rWU3vZEmfs/E8EIxSRNhlqUJIL+T39u0L/PgsnshlRHoYwebHL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PNrEf8JF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fQRxZzjT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PNrEf8JF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fQRxZzjT"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OIe1Ph3153468
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 21:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FPuI30IW6HSkIQ0WfYplqjAWQJEIGM7YwNUkDQocFtY=; b=PNrEf8JFzkwn7FZr
	UsqWaAdE1hg1luh+Xq1u26Yaac6StZiDKKxCzlUZfFeRBLkft36AJqiJpwQjlmva
	+TxLaCkUKfQFKtIiotRuLu+RuUouNU/0ut2Gd7+TIx0sj++94mT4AKaA+psLINM2
	qYd4wzqywaltdpxqlYX1qGIWOdtz1Yx1WJkgsvvqK2hP/NyeJvOz/QjSwlO03dlA
	Zd5PyoJApHtNT7En2tEmm7sJjLC/zLd1EfyNrtVRZ6pkDLhtPDzQrw25UfFCv4fn
	qoSNt5bAI01OvfB9c6GqAqaZcuS97obyt7VzDZfQmLr3C9XoFekVnXkDcz1zhrpv
	6cwN0A==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw898ryfc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 21:38:28 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-143803143c4so692758c88.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 14:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790285907; x=1790890707; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FPuI30IW6HSkIQ0WfYplqjAWQJEIGM7YwNUkDQocFtY=;
        b=fQRxZzjTVF9RJtXn3cUpNe2zl/oPem287uuw+AsZObNdM4jedq8POmRDjAbxFt0j8p
         utIfZqDG05gO+mEwYMYBCaVTvSfBhmU2YuM3OAJbw5/ORSfsDEuGBbBn+7E1WSELe1gX
         NADBe1p89FPDSZ5jb2qpLseyZKYBFqmYBk8eIlN6MyVxKBDfNpPikG+2+43c5cICrv30
         1HJlYGEoA4pEUnmOk4R/Duliy/lVQwBZbmdEJi3Hc+AcqGVAEv/9VQzNf6YW0r3+hDip
         DE4LxxQhYOi5SucNVKXYl5WxheyNttv8/Yl3nQe32i+h+3cqo8eJizUBtmAEo0B93H55
         Knww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790285907; x=1790890707;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FPuI30IW6HSkIQ0WfYplqjAWQJEIGM7YwNUkDQocFtY=;
        b=YWFR89B1FSgf0HPHsFurJA3Ua3RiXFzZLQ2RiFiGlHY164dJnLC9yHhBDYEvWPE9P2
         G/B1gBaL/4oNM88oCPsS6z/BGFdH+RC8P5Ep8YypIOUbizod8t0LymZwIJ5kJI1rk45v
         TtE74yzZam5CoeOgSChmhvSvlkjBkfXhqJQnme/IXQnY5Mj2BVMvqDxJ1+2iqwN13Mg4
         KanUw24UcJ+qDU2xkRWLgKdVKopte+tDRKmIQaMeoIyN+PfVmgNDHRwEbmwO+k+k7BxQ
         8de0/CaFQboeF95ZGDm8mkezDRbre+SGoX/NBBTpTXIKEsRSlCNblYEZTub40qMRgRVz
         lVYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGl8XYUY/O2S75pixB95SaqJgkmXLZm9yAGIeGxvoSwNby1QNJwdbZID4eLhUle6H1YW2VRxw=@lists.linux.dev
X-Gm-Message-State: AFuF++kOy33CROhvpRuL+/0VqoSaFoZqzpKMROpzBRADrzq7Dzp6p5lc
	PNNiGy3SqGKzsMNHE1ZuBiJuCcI3dS63NGCnb57g44M9OnhPPH6gAhinGZmolm2KBdY/bmjz4cI
	pyX25lieLVYKvSpsFClPJiXIZLd+qetSZyAE6h9MpHMUa/5TgbEpGYj62QbI=
X-Gm-Gg: AYBFou2AIjngVOQEuH0AKWP5ZlnsuiNq+IbQU+mN5NIgJdcpJ1COeWOUW+4UL2aTsZv
	MmfyTjnJoQ7ln037H2vBhJ/Ukd/n3L9ymSI8WWqqf+G9So3tZTSsvf1oSZwSlmASzEjrE1I3kFr
	Trih/HUIBakBYK1vmzMBe/lsOPnrRbTxzq7YjaSKHIc6BSFysHy+IYEi1fIcGKjjhTjcNdWtOCp
	7Mm7T6sgtsvKzmwXIRO9YC5caH6lkTtoBq+3VisDULvUgTc7Zp+BE4uSt5hMhxhl48sWPSfzGhl
	pc1UDBdD2sJAAprIJwgbnMJGRnyjGyN+wiFN52t/OK2RmxWR8/rsPfNn2INltVVZ4O5H8Qgnf9Y
	tymtevQgbOApQ8CftDfUh2rH2CsHfIaJ6QrJ4+swwFp6/K5w6ER+3Yw==
X-Received: by 2002:a05:701b:4306:20b0:144:ed03:7c6a with SMTP id a92af1059eb24-14503fa40c4mr2958600c88.15.1790285907206;
        Thu, 24 Sep 2026 14:38:27 -0700 (PDT)
X-Received: by 2002:a05:701b:4306:20b0:144:ed03:7c6a with SMTP id a92af1059eb24-14503fa40c4mr2958529c88.15.1790285905117;
        Thu, 24 Sep 2026 14:38:25 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145ad9e097fsm1289075c88.13.2026.09.24.14.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 14:38:24 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:38:21 -0700
From: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
        aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
        joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
        linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
        sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
        WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
        sudeep.holla@arm.com
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <20260924143821.00003491@oss.qualcomm.com>
In-Reply-To: <20260924135201.850038-7-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
	<20260924135201.850038-7-suzuki.poulose@arm.com>
Organization: Qualcomm
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA4OCBTYWx0ZWRfXxuValjJvRwBz
 wTyPmnAjgGMW3XYbagrCB2BTp+pYRP5hrTvy3LSVgSkD50RVG/lo3ze7XfvAUNQjGu2LYNwI4UB
 gb74xiIbR07Tbrt0mgjuFAkHyZRUHqfDQRcWqDpsIo/fAZGwApajJXHsB1PaeSqS4POQhOvka4y
 J81r9MkjI9p8gF2aEOrZKWfCHkyq6qDEL1EHYVQIrBwE087MQibMZvZoky6qPv5vfRm+vDUonG9
 k5tmmqJf1OUd7BkDIFDcW+tj4gri4N/YKe6BVE5YZCcUsIKdb3LV2PVBtV6xNKncue/DEpXZnuS
 SMXVlWrc/gf73A/RIEMT9fwbSPG6nplUcnICVIZjDjuIC2YJGz5XgB76upJIDMhQkVyi00z+XZG
 Uycy8In98sQMfb2P94WfY0l2PVsLjnY2vmyL/8nhYHcXDrQrb0q8vR1tWSGl+6ycon7moNoDJjO
 Gn7+EoCHv2MgOow05bQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA4OCBTYWx0ZWRfX+s6+hOoRQ3WN
 n7autPlFTzfs0BjcLr7xMUbgzAyiXV+Fk+s+DPZC4N54milAJW0YJNq4Qd1lXH3sJwamBpoc9lO
 4UjoYy5FUeC2zfJcQz3Wdgw6QrVu9p0=
X-Proofpoint-GUID: 5NKiN94vU4mzV2ILOa0VTP5fq2IoNz4U
X-Proofpoint-ORIG-GUID: 5NKiN94vU4mzV2ILOa0VTP5fq2IoNz4U
X-Authority-Analysis: v=2.4 cv=EJWTQFZC c=1 sm=1 tr=0 ts=6ab59854 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=8d2wJ0fT7bLMqeC6Z9UA:9 a=CjuIK1q_8ugA:10
 a=Fk4IpSoW4aLDllm1B1p-:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240088

On Thu, 24 Sep 2026 14:52:00 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> The RMM maintains the state of all the granules in the system to make
> sure that the host is abiding by the rules. This state can be maintained
> at different granularity, per page (TRACKING_FINE) or per region
> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
> all pages in the region must be of the same state, this implies we need to
> have "fine" tracking for DRAM, so that we can delegate individual pages.
> 
> For now we only support a statically carved out memory for tracking
> granules for the "fine" regions. This can be extended in the future to
> allow modifying the tracking granularity and remove the need for a
> static allocation by the firmware.
> 
> Similarly, the firmware may create L0 GPT entries describing the total
> address space. But if we change the "PAS" (Physical Address Space) of a
> granule, then the firmware may need to create L1 tables to track the PAS
> at a finer granularity. Linux therefore checks if the platform firmware
> manages the PAR region. i.e., the firmware is in charge of managing the
> L1 GPTs (creation and the required memory for the GPT tables - via static
> carveouts) without host intervention. Support for dynamic GPT creation by
> the host will be added later.
> 
> If the firmware requires us to manage the tracking or GPT memory,
> deactivate the RMM and reclaim any memory donated at RMM activation.
> 
> Apply the same checks when hotplugged memory is brought online.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

A few trivial comments. Either way on those
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
>  drivers/firmware/arm_rmm/rmi.c | 218 ++++++++++++++++++++++++++++++++-
>  include/linux/arm-rmi-cmds.h   |   2 +
>  2 files changed, 219 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 0859f256e192b..1a8f3debd844a 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c


> +
> +/*
> + * rmi_gpt_info - Query the GPT info for the given PAR.
> + * @start: Base of the physical address region
> + * @end: Top of the physical address region
> + * @out_top: Top of the physical address region for which
> + *		the GPT @out_gpt_par_state is valid

wrap to 80.

> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
> + */
> +static long rmi_gpt_info(unsigned long start, unsigned long end,
> +			 unsigned long *out_top,
> +			 unsigned long *out_gpt_par_state)
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
> +
> +/*
> + * We do not support creating L1 GPTs yet. So, make sure that
> + * all the regions are managed by the firmware.
Wrap to 80 chars.

Not relevant to this patch, but when are you thinking we will support that?

> + */
> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
> +{
> +	unsigned long l0gpt_sz;
> +	unsigned long next, par_state;
> +
> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> +					  rmi_feat_reg(1)));
> +	start = ALIGN_DOWN(start, l0gpt_sz);
> +	end = ALIGN(end, l0gpt_sz);
> +
> +	while (start < end) {
> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
> +
> +		if (ret != RMI_SUCCESS)
> +			return -ENOMEM;
> +
> +		if (WARN_ON(next <= start))
> +			return -ENXIO;
> +
> +		if (par_state != RMI_GPT_PAR_PLAT) {
> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> +				start, next);
> +			return -ENOMEM;
> +		}
> +		start = next;
> +	}
> +
> +	return 0;
> +}

> +
> +static int rmi_init_metadata(void)
> +{
> +	phys_addr_t start, end;
> +	struct memblock_region *r;
> +
> +	for_each_mem_region(r) {
> +		int ret;
> +
> +		/* Firmware-reserved NOMAP regions are not usable system RAM */
> +		if (memblock_is_nomap(r))
> +			continue;
> +
> +		start = PAGE_ALIGN(r->base);
> +		end = PAGE_ALIGN_DOWN(r->base + r->size);

Add a comment on why rounding down.  Doe we expect that to ever be relevant?

> +		/* Too small ? */
> +		if (start >= end)
> +			continue;
> +
> +		ret = rmi_prepare_memory(start, end);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}


> +
>  static int __init arm64_init_rmi(void)
>  {
>  	int ret;
> @@ -843,9 +1049,19 @@ static int __init arm64_init_rmi(void)
>  	if (ret) {
>  		pr_err("RMM activate failed (%d)\n", ret);
>  		ret = ret < 0 ? ret : -ENXIO;
> +		return ret;
>  	}
>  
> -	return ret;
> +	ret = rmi_init_memory();
> +	if (ret) {
> +		/* Deactivate the RMM */
> +		WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
> +		return ret;
> +	}
> +
> +	arm64_rmi_is_available = true;
> +	pr_info("RMI configured\n");

Blank line nice for the eye to spot the return.

> +	return 0;
>  }

