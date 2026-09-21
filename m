Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C97516165
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027201; cv=none; b=M51yeSile8Nh76fmaln1gXjgAflXYiUDw9xw+H6WsG2XM7R0YVEfmN4ofwDRAKsny+M8Z4aCNXBssz2AGJ7ML3Ya7kNpPJ3rdVbaQJE/8n75MxjKbB0/PB6Bkvui7IEI1cffCmVxb0Y1vzJqIM23tsSgPmg24Um4M1dq0bg+vjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027201; c=relaxed/simple;
	bh=QShqD0mzsgr5KsP5VmTpDyoWzdUjfsO4sL+xZPZ8Kno=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEYiSJL0hIEFKcOuqmtJ4jOr4RwYbayrCOhYL4ugFi3X9SpXK6OeNE+PDY1V+d+H0v4sF6Ib2VFLcgeovPBXwQDNo0P5vycGEAW2sYyUbijDPX9t7YeZhYnmYjma5AynFmmBw4wl6M9T/J/itBV5leG5MCr002iSarMtqL+xvxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EFoJNMx1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P2VQYsZZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EFoJNMx1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P2VQYsZZ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LKf1Os2546608
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZfOg9XYdQ5/vxidE+9pPRR6RYjJCbLCLOIt2gCT+9Gg=; b=EFoJNMx1X6Pv4FDS
	tMUSGAa9LvqoGHZBedDqvdBcDA7Cvae9SnITto4f09jRtlbuekCrbMc/2MAKvf6x
	gy2p3mZ2bhW8HdOSvKsdo/MKLNoMpVqXD90eb3NjmicVlbPWXm3gn48rxPFjxWVd
	ccE3FYDFyB3GFotA+QlERyQZ16B85/XCfZXm5v3vSsXF7AER0i7zlTvSQHCun1zu
	nfalxcV7idp0hPZlhBnqfZke+HLmsbX2Sc7DCOy8jejO2OtTqVCkLWdLV1vBiXSp
	9DeQc19R9BUJCDEQgouChdIxMP4QiqIcIk83GTs5CpiOtWouC/iXLzm7qBgeMsWJ
	YRLYVw==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu011bh1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 21:46:38 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso6080752a91.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 14:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790027198; x=1790631998; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZfOg9XYdQ5/vxidE+9pPRR6RYjJCbLCLOIt2gCT+9Gg=;
        b=P2VQYsZZa1ytzTWoBdjszmF1yT5vx9VbfPC0lJpSrVH6I+yrC7V9GIx2Fdy9xUECB3
         zp48zlJybqMxzdj92PILEI21k5GJ96QHJqTnIzuH4Isdy+inSI6/1HWaJGJeUi6+ovoH
         F04YRGGu0Bef2DOWXFpaFsX/ACwsXu404WVElGEwNoEKcUI+5GEkac5tos4s7u8lR8Hk
         stuut9HM6Slsa1ML+JTWj4gDaSIVS34OXEnFWjxTU58J5A5+WB3PYcZZ0r84p1S71JFN
         ouUKmKXuePx6TzZWI/pmb6x7qmNfKOEEWQIO9VoOMiyHWJshsc/3k2f6ZFzHXH+Rz9vi
         W/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790027198; x=1790631998;
        h=content-transfer-encoding:content-type:mime-version:organization
         :references:in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZfOg9XYdQ5/vxidE+9pPRR6RYjJCbLCLOIt2gCT+9Gg=;
        b=pLUoh4i8WceQyKwUvqFBh3ZpzxXD09RZQCPnoLpFYqnaA/xGanoRDY1/vWsrvkVTVt
         glH0O2d94hpoA8JsYaXUBxAN9mCos2r6EVmi1ABY7h0IQjN01iDobtW5QBuEwSLnY5B0
         0e6hwlV/gcxYmB/BZLukiqHlwcPp4WqHn+X6OQLfDKTdPCDKZQhGwFbIKIJx8Ne1Knk8
         kFfnV0+CkEVPCkCgsiczgzbYITB2RT4BWDyea6iRhW3MVEvI0Qg1ek7lMvS6U0Glu4lE
         0zmWRTbTFIjPo0Ram6pRX3/WH7fucmnK5P+EczcCpTMyLHz7SwQM7a1MTMVxwAXw/o/u
         tz+g==
X-Forwarded-Encrypted: i=1; AKwUvBxku1OGMAAly1v/ho73u5084BbW/6l8pLkx746NeYEPPG0bUy5nwt8iPy8mbU/bsxxhQgabbTw=@lists.linux.dev
X-Gm-Message-State: AFuF++mVF7Wc3cAAEUT3XC+Ftr3QWDRG4id2xpYkVn9T+BW3qjFerjHw
	cfgXjgc0hk1e1PePoQChelpQe3hZiMGJZiOPRciXikQs/OCN+VFnERNbQW7Gstp0UWMkOS5q41c
	ls3bXKqGjyfZ/08MymauACq5A2h+HEDs1u9w9wtfcp5ewBvwI5kS4YyosDuU=
X-Gm-Gg: AYBFou3hms+HEsTY5MMQWW+47jHBVRvHYEr1ksTmIJ2L+8pS9EkEA8R0jnUJOvmZipn
	WlDSlrRnBWDlj/r+kQP6pw5lbkh6je+BINVPfCzC9OErAWQbqQrbALFNz0EJ/lKn3BcPa4oDa8f
	w5yQ+lse25XbwsOTQuoIUTXRBCs58I0njBbyuiCAY8Vs2xkC0zpR4v5/gHrANsLWoOARzHP9hC2
	OhG5LS1vrNQNjYjj4FHlFSHrC2ogp7tFT8zCQDKrGeTG047qlS6lKRmXt9hCEJpFIrpiL0YwllO
	7gCr3VGgBfXEcIV/5uM6/78eFbPAMU7eMg89vBDLg8hn7lCz9itkJpB+NoNmx3DW9Uf/qVi9wCz
	OgyxDwpLFJEdtI/3q+kmOkAwWwg==
X-Received: by 2002:a17:90b:2dc3:b0:39e:3ce1:d22f with SMTP id 98e67ed59e1d1-39e54d3674bmr17166000a91.16.1790027197651;
        Mon, 21 Sep 2026 14:46:37 -0700 (PDT)
X-Received: by 2002:a17:90b:2dc3:b0:39e:3ce1:d22f with SMTP id 98e67ed59e1d1-39e54d3674bmr17165954a91.16.1790027197022;
        Mon, 21 Sep 2026 14:46:37 -0700 (PDT)
Received: from localhost ([50.35.44.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-144f0c7e0d1sm439586c88.10.2026.09.21.14.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:46:35 -0700 (PDT)
Date: Mon, 21 Sep 2026 14:46:31 -0700
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
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Message-ID: <20260921144631.00007440@oss.qualcomm.com>
In-Reply-To: <bbb2f1db-5d42-495f-b34e-184a6cd894ce@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
	<20260912083611.2513845-5-suzuki.poulose@arm.com>
	<178978126542.2352296.15676256806777454164.b4-review@b4>
	<bbb2f1db-5d42-495f-b34e-184a6cd894ce@arm.com>
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
X-Proofpoint-GUID: b8i-bN57HlbkM5diPqXQXkVfIhvR4-QE
X-Authority-Analysis: v=2.4 cv=dPczC+Zb c=1 sm=1 tr=0 ts=6ab1a5be cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=aNnz9XPx1a4JIXSYt2cE/A==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=yke8hGA7Qea92797WwgA:9 a=CjuIK1q_8ugA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDMxOCBTYWx0ZWRfX5zR5bhZUODSt
 tSMXCc9xvh8LqfwReatSdShudN20dJXUY0GlNIR8njDiVvEzE5uOyqx7uottj7MDXbDck7Q0/QU
 eCdY2W4xU/3ll+9hS2pBR57a885UK5h5Ib+R6LLSQvXG4jMyQsRywnpAOoffY6u2vVlIKRMOYU8
 lXawvcT5VDxVFRbVv7To7nsGh6biRp0k8PgTtahLbx37Hv62Ss/I2u1MpCqtcx7LuR01aluy7//
 f4XRH1uh0KfZmrosGeEXNjuFqlyNu4wJx/RYIt1c1LHQoOtC277ppkq6VmG3Yn/nYYVhgGT6lZl
 AzWq4lrn0wDK2JqDD2CM94HSsVFXxJrzHpTxVn0FfhwURzgZveBPz+EJ+x3Ts1IHI7+cVma0lNh
 uElnj4TsEILas2i2A6NT0KRlOkT+m3jAZsQN7aD2Atb7+GtvHstUTI90bw576QOKLHdNMzJpFS/
 kQtTpK4sDrrNbgH1qJA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDMxOCBTYWx0ZWRfX0OQlN/bfA+3C
 j34sTx6e6wAoecb6tIeccxrGT3XrpEGtzp/1cKNFQ50vtt/5VSr7WZq+FvimpVI/jR8HZT8RRfu
 I8Jo7bNof6ZrPgpmfi9sdHCjJ+8caE4=
X-Proofpoint-ORIG-GUID: b8i-bN57HlbkM5diPqXQXkVfIhvR4-QE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210318


> >> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> >> index 5b0e342ce3d5..4f9898ece754 100644
> >> --- a/drivers/firmware/arm_rmm/rmi.c
> >> +++ b/drivers/firmware/arm_rmm/rmi.c
> >> @@ -15,6 +15,59 @@
> >>   #define RMI_FEAT_REG_COUNT	2
> >>   static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] __ro_after_init;  
> >   
> 
> Was there a question here you missed ? FWIW:

I think inaccurate cropping only!  Have been using b4 review tui
(which is excellent btw!) Not sure I've gotten the hang of it fully yet.

> 
> I have expanded this to cover all 5 RmiFeatureRegisters exposed by RMM, 
> and it looks something like this now, with the use of ARRAY_SIZE() to
> limit accesses.
...


> 
> >> +
> >> +	/* Keep just the blocks the RMM didn't use in addr_list */
> >> +	for (int i = consumed_blocks; i < count; i++)
> >> +		sro->addr_list[addr_list_start + i - consumed_blocks] =
> >> +			sro->addr_list[addr_list_start + i];  
> > 
> > Maybe memmove to make it clear you are shifting a chunk of the array
> > down.  This might be worth some asci art showing each step in brief.
> > Anyhow, something along these lines:
> > 
> >        memmove(&sro->addr_list[addr_list_start],
> > 	      &sro->addr_list[addr_list_start + consumed_blocks],
> > 	      (count - consumed_blocks) * sizeof(*sro->addr_list));
> > 
> > Obviously doesn't save code, but maybe simpler to understand than
> > the loop.
> > 		  
> 
> Does the following hunk look better with the comment ?
> 
>          /*
>           * Keep just the blocks the RMM didn't use in addr_list.
>           * RMM claimed consumed_blocks entries from addr_list_start.
>           * Move the entries left out at the end i.e.
>           * [ addr_list_start + consumed_blocks, addr_list_start + found)
>           * to the rest of the valid entries and adjust the addr_count to
>           * reflect the available entries.
>           */
>          for (int i = 0, src = addr_list_start + consumed_blocks;
>                  i < found - consumed_blocks; i++)
>                  sro->addr_list[addr_list_start + i] = 
> sro->addr_list[src + i];
> 
>          sro->addr_count -= consumed_blocks;

Good enough.  Not sure there is a perfect answer for this one!

> 
> >   
> >> +}
> >> +
> >> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
> >> +			   unsigned long sro_handle,
> >> +			   struct arm_smccc_1_2_regs *out_regs)
> >> +{
> >> +	unsigned long capacity;
> >> +
> >> +	if (rmi_sro_ensure_capacity(sro, 1))
> >> +		rmi_sro_free(sro);  
> > 
> > Maybe a comment on why you free the whole lot rather than a smaller
> > amount to make some room.  
> 
> We don't do partial free of the list today, and having that is
> unnecssarily complicating the logic/code. We are going to do a reclaim 
> anyways. Sure, I could add a comment.

Might be useful as a breadcrumb in future but indeed not vital.
That was what I was assuming was the case.

> 
> 
> >   
> >> +
> >> +	capacity = RMI_MAX_ADDR_LIST - sro->addr_count;
> >> +
> >> +	rmi_op_mem_reclaim(sro_handle,
> >> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
> >> +			   capacity, out_regs);
> >> +
> >> +	/*
> >> +	  * RMI_OP_MEM_RECLAIM always return RMI_INCOMPLETE, except when the
> >> +	  * input parameters were invalid.
> >> +	  */
> >> +	if (WARN_ON_ONCE(RMI_RETURN_STATUS(out_regs->a0) != RMI_INCOMPLETE))
> >> +		return -EINVAL;
> >> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
> >> +		out_regs->a1 = capacity;  
> > I guess this should never happen, but bit ugly to fixup the register
> > return rather than perhaps using a local variable instead.  
> 
> We pass/get the out_regs, so local variable doesn't work, unless
> I missed what you were hinting at..

Ahh. Indeed, I wasn't thinking ahead to it being visible after. 

> >   
> >> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> >> +{
> >> +	bool cancelled = false;
> >> +	unsigned long sro_handle = regs->a1;
> >> +
> >> +	rmi_smccc_invoke(regs);
> >> +
> >> +	sro_handle = regs->a1;
> >> +	while (RMI_RETURN_STATUS(regs->a0) == RMI_INCOMPLETE) {
> >> +		bool can_cancel = RMI_RETURN_CAN_CANCEL(regs->a0) == RMI_OP_CAN_CANCEL;
> >> +
> >> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> >> +		case RMI_OP_MEM_REQ_NONE:
> >> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> >> +					regs);
> >> +			break;
> >> +		default:
> >> +			WARN_ON_ONCE(1);
> >> +			if (!can_cancel)
> >> +				return regs->a0;
> >> +			/* If we have already cancelled, don't retry this */  
> > 
> > Maybe expand that comment a little to say if we can get here under a
> > valid sequence and if so are we guaranteed that cancel is complete
> > given that is what caller will probably expect if it gets -ECANCELED.
> > 
> > My reading of spec would suggest we can't hit this path for the
> > calls that are not memory tranferring. Then again we can't hit the
> > first cancel either so all bets are off.  So maybe this is the
> > bet we can do.  Also can_cancel shouldn't be true after
> > rmi_op_cancel() as I assume you can't cancel a cancel.  
> 
> Ack.  This was to handle a buggy RMM (and soothing an LLM bot)

Modern job titles: LLM Soother!

I aggressively cropped previous email. For avoidance of doubt
the rest all looked good to me.

> 
> Thank you for the review.
You are welcome. Thanks for pushing this forwards

Jonathan

> 
> Cheers
> Suzuki
> 
> 
> >   
> 

