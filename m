Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBE72BFC60;
	Sat, 19 Sep 2026 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781295; cv=none; b=APBA3MlXsV2dZeGtuxgVJppAVfNXTThtunv1rNoDKg4RkGLOj058eL1qxG9isa/yGlW2oKyrUzevhq1uN7ofZJpR4QVhiO24qCUQZLxWDRxoXjcwS+km2axjkdbnrVuAAKPWQoEOvbvLrATZpxf+kZGaGd6Xa/CKVZQkL2oUoPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781295; c=relaxed/simple;
	bh=TDckzYcPQFRtAhJQqOo2HQDMM0SVUuf0EC865DBBpYo=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=mf9apRZpcvWjxBJqoun2VUELXgde5idWFgtPakXFeIlKeIqV5GblWTw35sW4ZvYfdmQ4qdLml587h6/RCuCvSMwH+2Wh9/UoIQ/kDbcpUK5gKlJJ9L4roWymEnG5CCsqGBh9rv3x4bUOvXdpwfYDl7AikWBu4xDZCgw2HNDiarw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YqMpfmQM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YqMpfmQM"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68INwF213107001;
	Sat, 19 Sep 2026 01:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gOMfiWikPcmiAlM8lrGHBGFDcaUdadddDJDHEifhXT8=; b=YqMpfmQMEuiskSDN
	KZarNYSbVkoHjpw95ah96UdtXdnidAwTBaHQtjNe1LZ46+ZwMP7UFRqqzZIGJcue
	SCo23l7OrX7fEcHFWutm5apEw0IlHTx0rViyp4Jxo61gGLAsjh92qguupAgsjIBH
	GYIwkMbkWLI7QxJoh891jAT1bKsIiz4zIXNxkdj5Lo+TgIJRN8aq7ZdtaL117mE0
	2tEjVxsZoh8PtLzhnXSxhSDgp12Sh6Vx/9f6hBjAc7z5EFTY+zyeyFU29i5eU4wn
	/vkR9+OqvnToCXgBS1oRBy9KZay2j3lfS/MFApsZIHQ4cRu+PUtptP1UwiGFoHGo
	1jgqyA==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gs8gyhtxj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 +0000 (GMT)
Received: from hu-devc-lv-u24-a.qualcomm.com (hu-jcameron-lv.qualcomm.com [10.81.84.69])
	by NALASPPMTA04.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTPS id 68J1Rp983490811
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 GMT
Received: from hu-jcameron-lv.qualcomm.com (localhost [127.0.0.1])
	by hu-devc-lv-u24-a.qualcomm.com (Postfix) with ESMTP id 1779424DD6;
	Fri, 18 Sep 2026 18:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
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
In-Reply-To: <20260912083611.2513845-5-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
Date: Fri, 18 Sep 2026 18:27:45 -0700
Message-Id: <178978126542.2352296.15676256806777454164.b4-review@b4>
X-Mailer: b4 0.17-dev
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX9EKNv0Kha0FC
 gZ4PVQYW7PmxMqbrF/aBJcFWiS4Ze/z9L2Ou7NfaMWUpkctX/v3JrKziyYJ3is6k77Lc7hlQLop
 YSzYI2lh18IIkcHnqnkgNG9W//OOqAc=
X-Authority-Analysis: v=2.4 cv=Tq5zFzXh c=1 sm=1 tr=0 ts=6aade517 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=7CQSdrXTAAAA:8
 a=EUspDBNiAAAA:8 a=J1ZjCe3lCUVqSFJHhOAA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX6d3w91RC/8cH
 nsP6gK7lVdRz00GsWNNaSHW6edWB0W3JwDSSGHory7KXdydWIqNnOj8B3lprnRQATagHrJ722Ov
 2Z/Vx2Pft0zT17hfcLAxN6bgBt4TEmKr1h+Z0fLJq/Ln1P0EoNba9Wo5KYl6ZqIld+lYrSK08WZ
 juW5WlnGudZCuJDpGfGLld/NV0qaPZys4UkcgrpmEH0NaniAp3RNqj38+aQVR8vPNZL7+3sn92o
 WebkzRFc7+t4twDlp5qbWfxsPaneru0ZoKgeid/7IWzF0OJxcNXb4X0ekrtQHxryokFOXOV5s9I
 7hA2YKn2uthJhkWlmWaK1ih8MAmQbpKfvFLnopdlvF9lQt+2QbBsIqIgWFKXCaB/6XgiBMAzbnn
 qdCJ5MjF0z6I2jt3CMYzyAF83cR32WFTndPzoGUD02RCf10abkxsSbIHP+3t8GVBFu+kgICXuG8
 QGjvBNVDX9b54BXGJUw==
X-Proofpoint-ORIG-GUID: ykRMeUVC9vLtkyXvvpaqv3PVOCEWCorb
X-Proofpoint-GUID: ykRMeUVC9vLtkyXvvpaqv3PVOCEWCorb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190016

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
> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Hi Suzuki.

A few comments and questions on the array for the cache of
allocations.

Jonathan

> ---
>  drivers/firmware/arm_rmm/rmi.c | 586 +++++++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h   |  41 +++
>  2 files changed, 627 insertions(+)
>
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 5b0e342ce3d5..4f9898ece754 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -15,6 +15,59 @@
>  #define RMI_FEAT_REG_COUNT	2
>  static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] __ro_after_init;



> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long size = block_size * count;
> +	unsigned long addr_range;
> +	unsigned long donated_granules;
> +	unsigned long donated_size;
> +	int ret;
> +	void *virt;
> +	phys_addr_t phys;
> +
> +	/*
> +	 * The RMM specification requires contiguous allocations are always a
> +	 * power of 2
> +	 */
> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
> +		return -EINVAL;
> +
> +	/* Reuse the cached address range if we have one */
> +	for (int i = 0; i < sro->addr_count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto out;
> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		return ret;
> +
> +	virt = alloc_pages_exact(size, gfp);
> +	if (!virt)
> +		return -ENOMEM;
> +	phys = virt_to_phys(virt);
> +
> +	if (state == RMI_OP_MEM_DELEGATED) {
> +		phys_addr_t delegated_phys;
> +
> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +				free_pages_exact(virt, size);
> +			return -ENXIO;
> +		}
> +	}
> +
> +	addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +	FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, count);
> +	FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +	sro->addr_list[sro->addr_count] = addr_range;
> +
> +out:

This doesn't smell like an 'out' - as the real works is done down
here.

> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +	donated_granules = out_regs->a1;
> +
> +	if (WARN_ON(donated_granules > (size >> PAGE_SHIFT)))
> +		donated_granules = (size >> PAGE_SHIFT);
> +
> +	donated_size = donated_granules << PAGE_SHIFT;
> +
> +	/* All granules consumed by the RMM */
> +	if (donated_size == size)
> +		return 0;
> +	/* No granules were consumed by the RMM, cache them */
> +	if (donated_granules == 0) {
> +		sro->addr_count++;
> +		return 0;
> +	}
> +
> +	/* The granules were partially consumed, reclaim the unused ones. */
> +	free_addr_range(sro->addr_list[sro->addr_count], donated_size);
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
> +	unsigned long block_size_fld = RMI_DONATE_BLOCK_SIZE(donatereq);
> +	unsigned long block_size = rmi_addr_block_size_to_bytes(block_size_fld);
> +	unsigned long count = RMI_DONATE_COUNT(donatereq);
> +	unsigned long state = RMI_DONATE_STATE(donatereq);
> +	unsigned long found = 0;
> +	unsigned long donated_granules;
> +	unsigned long granules_per_block = block_size >> PAGE_SHIFT;
> +	unsigned long consumed_blocks;
> +	int addr_list_start = sro->addr_count;
> +
> +	int ret;
> +
> +	for (int i = 0; i < addr_list_start && found < count; i++) {
> +		unsigned long entry = sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
> +		    RMI_ADDR_RANGE_COUNT(entry) == 1 &&
> +		    RMI_ADDR_RANGE_STATE(entry) == state) {
> +			addr_list_start--;

I guess putting that as a predecrement in the swap is a little
too obscure.

Maybe a comment for this whole loop that it is gathering up
useable entries by moving them to the end of the bit of the
array that is already in use.  Neat little bit of code but takes a little
more thinking about than might be ideal when we look at this
10 years down the line.  Maybe it's just that it is Friday...

> +			swap(sro->addr_list[addr_list_start],
> +			     sro->addr_list[i]);
> +			found++;
> +			i--;

Rather than decrement the loop variable, maybe a goto and a label
for try_new_entry or something like that?  Even a comment might
be useful.

> +		}
> +	}
> +
> +	ret = rmi_sro_ensure_capacity(sro, count - found);
> +	if (ret)
> +		return ret;

Will this normally succeed? Feels like we could have a lot
of useless entrees at the start of the storage, so no room to
enough extra ones.

> +
> +	while (found < count) {

For loop seems more natural to me given the bounds are known
and found is only incremented at the end.

> +		unsigned long addr_range;
> +		void *virt = alloc_pages_exact(block_size, gfp);
> +		phys_addr_t phys;
> +
> +		if (!virt)
> +			return -ENOMEM;
> +
> +		phys = virt_to_phys(virt);
> +
> +		if (state == RMI_OP_MEM_DELEGATED) {
> +			phys_addr_t delegated_phys;
> +
> +			if (rmi_delegate_range(phys, block_size,
> +					       &delegated_phys)) {

Go long. It is shorter than the line that follows anyway!

> +				if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +					free_pages_exact(virt, block_size);
> +				return -ENXIO;
> +			}
> +		}
> +
> +		addr_range = phys & RMI_ADDR_RANGE_ADDR_MASK;
> +		FIELD_MODIFY(RMI_ADDR_RANGE_BLOCK_SIZE_MASK, &addr_range, block_size_fld);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_COUNT_MASK, &addr_range, 1);
> +		FIELD_MODIFY(RMI_ADDR_RANGE_STATE_MASK, &addr_range, state);
> +
> +		sro->addr_list[sro->addr_count++] = addr_range;
> +		found++;
> +	}
> +
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[addr_list_start]),
> +			  count, 0, out_regs);
> +
> +	donated_granules = out_regs->a1;
> +	/*
> +	 * The RMM shouldn't report more granules than we provided, but clamp
> +	 * just in case.
> +	 */
> +	if (WARN_ON_ONCE(donated_granules > found * granules_per_block))
> +		donated_granules = count * granules_per_block;
> +
> +	/*
> +	 * The RMM reports the consumed memory in terms of granules, but we
> +	 * track in the address lists in block-sized ranges. So divide to get
> +	 * the number of (complete) consumed blocks.
> +	 */
> +	consumed_blocks = donated_granules / granules_per_block;
> +	if (donated_granules % granules_per_block) {
> +		/*
> +		 * A block has been partially consumed, the start is owned by
> +		 * the RMM, the tail is owned by the host
> +		 */
> +		unsigned long entry =
> +			sro->addr_list[addr_list_start + consumed_blocks];
> +		unsigned long donated_size =
> +			(donated_granules % granules_per_block) << PAGE_SHIFT;
> +
> +		free_addr_range(entry, donated_size);
> +		/*
> +		 * This block is now fully 'consumed' (either held by the RMM or
> +		 * freed)
> +		 */
> +		consumed_blocks++;
> +	}
> +
> +	/* Keep just the blocks the RMM didn't use in addr_list */
> +	for (int i = consumed_blocks; i < count; i++)
> +		sro->addr_list[addr_list_start + i - consumed_blocks] =
> +			sro->addr_list[addr_list_start + i];

Maybe memmove to make it clear you are shifting a chunk of the array
down.  This might be worth some asci art showing each step in brief.
Anyhow, something along these lines:

      memmove(&sro->addr_list[addr_list_start],
	      &sro->addr_list[addr_list_start + consumed_blocks],
	      (count - consumed_blocks) * sizeof(*sro->addr_list));

Obviously doesn't save code, but maybe simpler to understand than
the loop.
		
> +
> +	sro->addr_count -= consumed_blocks;
> +
> +	return 0;
> +}
> +
> +static int rmi_sro_donate(struct rmi_sro_state *sro,
> +			  unsigned long sro_handle,
> +			  unsigned long donatereq,
> +			  struct arm_smccc_1_2_regs *regs,
> +			  gfp_t gfp)
> +{
> +	if (WARN_ON_ONCE(!RMI_DONATE_COUNT(donatereq)))
> +		return -EINVAL;
> +
> +	if (RMI_DONATE_CONTIG(donatereq) == RMI_OP_MEM_CONTIG) {
> +		return rmi_sro_donate_contig(sro, sro_handle, donatereq,
> +					     regs, gfp);
> +	} else {
> +		return rmi_sro_donate_noncontig(sro, sro_handle, donatereq,
> +						regs, gfp);
> +	}

I'd go longer than 80 chars in a few places to help
readability. Up to you.

> +}
> +
> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
> +			   unsigned long sro_handle,
> +			   struct arm_smccc_1_2_regs *out_regs)
> +{
> +	unsigned long capacity;
> +
> +	if (rmi_sro_ensure_capacity(sro, 1))
> +		rmi_sro_free(sro);

Maybe a comment on why you free the whole lot rather than a smaller
amount to make some room.

> +
> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
> +
> +	rmi_op_mem_reclaim(sro_handle,
> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
> +			   capacity, out_regs);
> +
> +	/*
> +	  * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
> +	  * input parameters were invalid.
> +	  */
> +	if (WARN_ON_ONCE(RMI_RETURN_STATUS(out_regs->a0) != RMI_INCOMPLETE))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
> +		out_regs->a1 = capacity;
I guess this should never happen, but bit ugly to fixup the register
return rather than perhaps using a local variable instead.
Obviously doesn't matter in practice.

> +	sro->addr_count += out_regs->a1;
> +
> +	return 0;
> +}

> +
> +/* For RMI commands that are stateful but not memory-transferring */

Given this is exported, maybe some docs on return values etc?
Similar for the other exported funcitons.

> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	bool cancelled = false;
> +	unsigned long sro_handle = regs->a1;
> +
> +	rmi_smccc_invoke(regs);
> +
> +	sro_handle = regs->a1;
> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> +
> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			if (!can_cancel)
> +				return regs->a0;
> +			/* If we have already cancelled, don't retry this */

Maybe expand that comment a little to say if we can get here under a
valid sequence and if so are we guaranteed that cancel is complete
given that is what caller will probably expect if it gets -ECANCELED.

My reading of spec would suggest we can't hit this path for the
calls that are not memory tranferring. Then again we can't hit the
first cancel either so all bets are off.  So maybe this is the
bet we can do.  Also can_cancel shouldn't be true after
rmi_op_cancel() as I assume you can't cancel a cancel.

-- 
Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
