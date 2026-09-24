Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDCF4BC018
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790277246; cv=none; b=U2pOg8rPeK8a979+UPnnoZQEuhaxIPbbFlF8C6nhhycxtNqOBAUHlLYcVMJZCo8yLvNHypxqGYhxZZ6Byb+K2pGTS/k8wNRVYtsf9YecHZnn1mr6m3ZqecvUArGwtJnqxNUNTWZWpFdniOAYZ8FyWyf7WzT58itA2S6gw0yXWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790277246; c=relaxed/simple;
	bh=EwBJUIoyp9JY6RVbxRaq5HHhHm5yl1iuR6dtegQ7JlA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FO5zW2mY+aLBvrvq2Mv47Z+zrcwuSXH/HIui8tL8oWwoQuWm6Z3WCfGPXVqXq/4m0gB+I5fVijvIqrMKH+m2qMhc6MDZ9kidqvtkLDDTiP1vG6kLLytyDBAN7YjJJUU4TnV0Tcbm/8yUB1TGuo4N9SMMPbl/YcvVT4Mo5i4deqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=grAZx5ct; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gQRNFoAz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="grAZx5ct";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gQRNFoAz"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68OIdjdW4001896
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 19:14:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7v7mwV3kL+pNqZlpuPeN3iMHS9Dj14zbCE44HBuwDdc=; b=grAZx5ctnOkhdTlJ
	Tbx3UTtNyuHD/sr5o5S9iAosrcwL9vTgFX5n+qgkBa8eJlCDluGlJmxRGLzQFDp9
	DNTotWQ7bej5dT0xfn70EAehqKhfhEvCn3M9xVQrr3bE6g8+ythywAZx/OeJitpd
	N58VTQPEmBCKldJPszmeAMbxozdDm3HfnGTEFFMBUwRnLZP+l9asNVg8vEV0aBhS
	B47EBSt9mP94NZbIGO1X1Y/YrRm6XrQwu8J4zQDrIgiYlXT/tP86H8pL55G7Lf8f
	e22DjROzCJFkF16UcHQcoqsBhj2kMOts7bn6k0M/hwe6kJItxVTabXAQga7Wyqm6
	eidmPg==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw1raje5p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 19:14:03 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33310847fcaso134362eec.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 12:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790277243; x=1790882043; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7v7mwV3kL+pNqZlpuPeN3iMHS9Dj14zbCE44HBuwDdc=;
        b=gQRNFoAzxDr2rQenVNnuqYmpuEnniJYsJJfVE4K+JltxJ43tLdJrqoXs4T9og01uVU
         zglrlPYoWKlXqz22hElD1imUD6/x/inFXMr1EeMWYos8HgKocnyq42rZ1wFrEmHWsB+I
         ZygqXu6s/NZR5TsYlKzdqceIlFjGQugaoZYCwSJ46ODzsj0io6eBlVlKGOhfMA32syu4
         FFFKO/3StWvsjBiE7nFNY3BKzi8NZSmxLoxQ1hS64IDnU54Z51aTBXXWiVBT9cVQUj2i
         4ohRkLJSxH9qFvaNWGF1Iu9WoK8Ags9c31BzDMAjutW1n8XAF+neK+c8//2Z9LXmA37u
         E1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790277243; x=1790882043;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7v7mwV3kL+pNqZlpuPeN3iMHS9Dj14zbCE44HBuwDdc=;
        b=i75Oe282TX6Rr1axUQpabmOMYf9N9Du+naX+OCIQAZJhesmJOxnJ7kgf1ZrsCwn5m7
         46YrXhcJWmzHzGtDIzKVPhIHC1xMkbWdiB3rcsG53llHiBeKIi6C7z3eCbnTO9xqibfc
         FVISuCDncnh5B5r5ceADlNsfAfATVN2KbBLVW1G5dIC1XlTaAXzyKsUtUVO9ODKTxpiT
         I9f3uizcDnwve3e95tly1kkaJrwCgOFF+CoouYUYpUz4hBVVnSAXfww4SNp4DySFH1MD
         QVg8j2zpMOh65503uJMHVZg23wCR/uWkDsvEPy1/r8spJPCAsvIQpQtjxlUMBdFjuWAn
         aj2w==
X-Forwarded-Encrypted: i=1; AKwUvBx1jGIcZs1ZnbIDMOTJ8d+I1goZeHY7/fGpo7cc/+tTY/UA893hPR4GqByWkABdrRgcOLyY76g=@lists.linux.dev
X-Gm-Message-State: AFuF++lDB0IpjDp2mV5g7JVjBgFlqBTsL8dsHcme6AV52WU/uYtIvu7a
	EyA9owQng7/Z8mE0arWwWdCHf5PLJantPi3HLXju7H339MxDeif5UpfG4YtNfoqHhyMgtQ6I1Vj
	IJjDtT7aJYthtvPSv1KOiXF5eAiJfw6qtP2wpOgXwvQdtVvYFb1EHSc5aFYk=
X-Gm-Gg: AYBFou1ucNknULukHP2+hNTZOtgdJmf8+pIFgDmwzT2dA7FRr5Soyd2jHap9kjMbe/K
	9O9qPcamnjSrUHkOirzc+ybdGyxAGxvq5K63gOB/QHKCLjid7+xifeGOKqrlnHUJaqJ00zClGIT
	qlQycduTd8FYVWi7y9xGtv+J9nvZtcsq3cjlmvQDOTDeqMmV7gOEyYAjKRJXdYUrntA7bg0Jgf/
	t0TyIY2yEYO2vtgbQbveWSQs279asbI0Zri8Vcg1CZxVg1eGU6eU5IHsuESGLjztwd0oP5QNenq
	HupAYl8t1/IxScctl3e7z7Lw7y9SLvDL85E1MqoXVqNrqQD/1Qeloc1oNT3bFEsdrfDiWevlEPm
	MzaDSfpaRtJnlEhYvAQyqVDbyr762sZHZcsdXU3QlHtpvqsmha7aydA==
X-Received: by 2002:a05:7300:1905:b0:33b:fc17:e786 with SMTP id 5a478bee46e88-33fff65015fmr3559975eec.16.1790277242539;
        Thu, 24 Sep 2026 12:14:02 -0700 (PDT)
X-Received: by 2002:a05:7300:1905:b0:33b:fc17:e786 with SMTP id 5a478bee46e88-33fff65015fmr3559927eec.16.1790277241676;
        Thu, 24 Sep 2026 12:14:01 -0700 (PDT)
Received: from localhost (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341447576b9sm641843eec.15.2026.09.24.12.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 12:14:01 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:13:56 -0700
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
Subject: Re: [PATCH v19 4/7] firmware: arm_rmm: Add support for SRO
Message-ID: <20260924121356.00000d4d@oss.qualcomm.com>
In-Reply-To: <20260924135201.850038-5-suzuki.poulose@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
	<20260924135201.850038-5-suzuki.poulose@arm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDA3OCBTYWx0ZWRfX9+Uhof96QyAA
 3lk5TzH8Tou54Cm10d3QlyQnUH9q/MviAco2VFTGvxEvX/bdjqAddp0OMfKBhqegNzVxFJYkI5X
 mExBSWEW6/I8v+3GBrmjHjrBYYrx3vkKznQ693GoaOrepUUilP2Uf4iqizl+zfhYbBeCOluTPkG
 b8+T/6dK+WY0KARS3p2XH9kTJConGMde0llJY+rXNIoUlxXJYXHLFZKh5xV8jxTbzsH59+6Ytwa
 T7r/GDZTMO+oHsCc+0YyiMatyy3hrypX7VzCWu1ELO6rDUT49ibBnWe/0x+isLb65opUcCKp6eN
 ihIwNiAmYgygw8ygbZnbQVb/MbL7RSqOuxkCwbwqJCcw1NOKwVxlnmQVMWFTYRcxij+gl9o4S4t
 ISO4iCxNVE7ZgHz8JtT0NcZT73ugxzfuTBHspriY1pykybtKQNb8JVvpUrWX6+aX8d0B7BSVQ/2
 PcxGY/DPhTEhlDTmQMg==
X-Proofpoint-ORIG-GUID: lA08bm5b6FaaNzUzFn1C3pveape0435u
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDA3OCBTYWx0ZWRfX5zSx4C3dCnoj
 tvNfWm6E9zgEFYo62hvAdojheo0nPF/igrGuFr8XHoe9pltcLbSutnmGVlzVoeRzCmq6rNCWRfa
 2rz4aL2s3eLlmgQUmRRkD0N6eCeaGas=
X-Authority-Analysis: v=2.4 cv=fvpJ914f c=1 sm=1 tr=0 ts=6ab5767b cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=7CQSdrXTAAAA:8 a=EUspDBNiAAAA:8 a=g7tT_HrEe4iQpSKoiZcA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: lA08bm5b6FaaNzUzFn1C3pveape0435u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 adultscore=0 spamscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240078

On Thu, 24 Sep 2026 14:51:58 +0100
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> From: Steven Price <steven.price@arm.com>
> 
> RMM v2.0 introduces the concept of "Stateful RMI Operations" (SRO). This
> means that an SMC can return with an operation still in progress. The
> host is expected to continue the operation until it reaches a conclusion
> (either success or failure). During this process the RMM can request
> additional memory ('donate') or hand memory back to the host
> ('reclaim'). The host can request an in progress operation is cancelled,
> but still continue the operation until it has completed (otherwise the
> incomplete operation may cause future RMM operations to fail).
> 
> The SRO is tracked using a struct rmi_sro_state object which keeps track
> of any memory which has been allocated but not yet consumed by the RMM
> or reclaimed from the RMM. This allows the memory to be reused in a
> future request within the same operation. It will also permit an
> operation to be done in a context where memory allocation may be
> difficult (e.g. atomic context) with the option to abort the operation
> and retry the memory allocation outside of the atomic context. The
> memory stored in the struct rmi_sro_state object can then be reused on
> the subsequent attempt.
> 
> Wrappers for SRO RMI commands are also provided here because they depend
> on the rmi_sro_execute() implementation added by this patch.
> Delegate/undelegate handles are also added here because they now use the
> SRO/stateful command infrastructure and are also used for the memory
> DONATE/RECLAIM flows.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Nice.  Everything I spotted this time around is pretty trivial.
So assuming you'll clean up and bits that make sense to you for v20

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>


> ---
>  drivers/firmware/arm_rmm/rmi.c | 666 +++++++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h   |  41 ++
>  2 files changed, 707 insertions(+)
> 
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index c9ea964fd9081..035f21d3f26b6 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

> +
> +int rmi_undelegate_range(phys_addr_t phys,
> +			 unsigned long size)
> +{
> +	long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_undelegate(phys, top, &out_top);
> +
> +		if (ret == RMI_SUCCESS) {
> +			/* Buggy RMM ? Let the caller leak the pages */
> +			if (WARN_ON(out_top <= phys))
> +				return -ENXIO;
> +			phys = out_top;
> +		} else {

Similar to below, why not deal with error case first and reduce indent of
the good path.

> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);

> +/*
> + * rmi_delegate_range: Delegate a physically contiguous range.
> + * We iterate over the range until we hit an error. So we may
> + * return an error, but with a partially delegated range. The
> + * caller must always look at the @out_phys to figure out, how
> + * much progress was made.
> + *
> + * @phys:	Base of the physical address range
> + * @size:	Size of the physical address range
> + * @out_phys:	Top of the range that was completed. This is always
> + *		valid, irrespective of the result.
> + *
> + * Returns RMI_SUCCESS on successful completion. Otherwise, returns
> + * the Linux error number or the RMI status code as described
> + * by the RMM spec for RMI_GRANULE_DELEGATE_RANGE or RMI_BLOCKED.
> + */
> +int rmi_delegate_range(phys_addr_t phys,
> +		       unsigned long size,
> +		       phys_addr_t *out_phys)
> +{
> +	long ret = 0;
> +	unsigned long top = phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret = rmi_granule_range_delegate(phys, top, &out_top);
> +
> +		if (ret == RMI_SUCCESS) {

My instinct here would be to flip this and have the error out of line given
it breaks anyway and that gives you smaller indent for that ocmment block.

		if (ret != RMI_SUCCESS)
			break;

		/*
		 * Buggy RMM ? Let the caller handle the failure. We can't know
		 * how far the RMM delegated in this iteration, so we return 
 		 * the best known good limit. RMM can deal with granules 
		 * already in "undelegated" in a given range. So, it is fine
		 * for the caller to try the range we return.
		 */
		if (WARN_ON...

> +			/*
> +			 * Buggy RMM ? Let the caller handle the failure.
> +			 * We can't know how far the RMM delegated in this
> +			 * iteration, so we return the best known good limit.
> +			 * RMM can deal with granules already in "undelegated"
> +			 * in a given range. So, it is fine for the caller to
> +			 * try the range we return.
> +			 */
> +			if (WARN_ON(out_top <= phys)) {
> +				ret = -ENXIO;
> +				break;
> +			}
> +			phys = out_top;
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (out_phys)
> +		*out_phys = phys;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_delegate_range);

...

> +
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{

...

> +
> +	/* Gather the suitable entries to the end of the list */
> +	i = 0;
> +	while (i <  addr_list_start && found < count) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
> +			addr_list_start--;
> +			swap(sro->addr_list[addr_list_start],
> +			     sro->addr_list[i]);
> +			found++;
> +			/* Continue from the swapped in entry */
> +			continue;
> +		}
> +		/* skip past the entry */

Bit random on comment capitalization.  Have a quick final look through.
For instance I think this one is Skip to match Continue above.

> +		i++;
> +	}

...


> +
> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
> +			   unsigned long sro_handle,
> +			   struct arm_smccc_1_2_regs *out_regs)
> +{
> +	unsigned long capacity;
> +
> +	/*
> +	 * We don't do a partial free of the entries. So for
> +	 * now free the entire address list as we prepare
> +	 * to reclaim more from the RMM.

Rewrap to use all that nice space up to 80 chars!  I guess a refactoring
side effect.

> +	 */
> +	if (rmi_sro_ensure_capacity(sro, 1))
> +		rmi_sro_free(sro);
> +
> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
> +
> +	rmi_op_mem_reclaim(sro_handle,
> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
> +			   capacity, out_regs);
> +
> +	/*
> +	 * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
> +	 * input parameters were invalid.
> +	 */
> +	if (WARN_ON_ONCE(RMI_RESULT_STATUS(out_regs->a0) != RMI_INCOMPLETE))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
> +		out_regs->a1 = capacity;
> +
> +	sro->addr_count += out_regs->a1;
> +
> +	return 0;
> +}

> +
> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	struct arm_smccc_1_2_regs *regs = &sro->regs;
> +	bool cancelled = false;
> +	unsigned long sro_handle;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;

For a flag that is "can" or "cannot", do we need the RMI_OP_CAN_CANCEL (1) / RMI_OP_CANNOT_CANCEL (0)
defines?  Doesn't feel like we'll ever get RMI_OP_UNKNOWN_IF_IT_CAN_CANCEL and I can't think
of any other more reasonable options that would justify needing the explicit field value
match.

To me

		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0);

is obvious enough.  I don't care that much though so up to you.


> +		int ret = 0;
> +
> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret = rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> +					     gfp);
> +			break;
> +		case RMI_OP_MEM_REQ_RECLAIM:
> +			ret = rmi_sro_reclaim(sro, sro_handle, regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			ret = -ENXIO;
> +			break;
> +		}
> +
> +		if (ret) {
> +			/*
> +			 * All memory donating SROs must be cancellable. So a
> +			 * failure in memory allocation shouldn't be an issue.
> +			 * However, if we encounter a random failure (e.g.,
> +			 * buggy RMM), don't loop forever, just give up.
> +			 */
> +			if (WARN_ON_ONCE(!can_cancel))
> +				return ret;
> +			/*
> +			 * If we have already cancelled, and came back here due
> +			 * to an error in MEMREQ, then there is no point
> +			 * in going in loops.
> +			 */
> +			if (WARN_ON_ONCE(cancelled))
> +				break;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled = true;
> +
> +			if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) != RMI_INCOMPLETE))
> +				return ret;
> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
> +
> +/*
> + * rmi_sro_execute: Execute an RMI command that is Stateful but not memory
> + * tranfserring. Takes regs, filled with the FIDs and the arguments in place.

Spell check. Transferring.  Also why does Stateful get a capital letter and
Memory Transferring does not.  They seem to both be properties of the comman
so I'd expect some consistency.

> + *
> + * Returns :
> + *  -ECANCELLED - If the operation had to be aborted and SRO was cancellable.
> + *  Otherwise, returns the result of the RMI command.
> + */
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled = false;
> +	unsigned long sro_handle = regs->a1;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RESULT_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RESULT_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> +
> +		switch (RMI_RESULT_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			if (!can_cancel)
> +				return regs->a0;
> +			/*
> +			 * We can't get here normally, but handle this anyway
> +			 * for a buggy RMM implementation.
> +			 */
> +			if (cancelled)
> +				return -ECANCELED;
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled = true;
> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_execute);

