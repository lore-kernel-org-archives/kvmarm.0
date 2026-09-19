Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC77363089;
	Sat, 19 Sep 2026 01:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781293; cv=none; b=tU/0P3Z52gONAg7uyiu7AidWFM9yRO4932+r4/O/48IXphQ8Lu6W4XfjFz8z7S/t8VUXswV+bZWG/257rnRN2tow1547ZFmf6H9JTyOR9eNF6Pd8EniXEyDziu9J8feR+rePB4ptZpf7tm3PELYva7pVfKDKm+2+mwtrgiqfxgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781293; c=relaxed/simple;
	bh=ZpNfCwWo9Cp5QuAglZNjQeM/moqz1idRiysr3l/sJQM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=GpcPYx5zE6aHJ+zq76tkqfpinB28xix1m34RWtck/NmHPCLy+Fx/dZC4GOX6eaBF+Cqm3vLcSGuHoowEEOcTBH0ioL1oBrlXwvsHDJG31dgBYxnEsK35HlkbDDk42tZVwwFZxvarAQQl9K391yyNXJ+6sxtgF+UrxPmJKoTXqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dNAyCRGf; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dNAyCRGf"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68INvnbY1420671;
	Sat, 19 Sep 2026 01:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IJbeOC5P7CUlCHlbrCCH2eu4B712uwW8R+WMUfDTt4I=; b=dNAyCRGfrsxac/A+
	WEkGlYlPp60psM7pbG6YriRDXCApI4wsIgmqSeKGsbAMnl2vMquZCiq1HvFfn9GM
	aC23B2roWjqBFmkNV1Xl2BbwJOB6GGQOJHI6p3AYiYm1ku35MCTxFuxSrsHbfkvo
	LLmFWhTqpFuqzq8zJF98XDr1r3bddriCCm8kzA+ZpBQd3TCEC6JgxoA46HoNgq/Y
	5l1UY6bZ+6gui3taJvgnxIIray3c+nk3ckwhDb0LrWJLsk5U/Yj34PT0U9JKSqFg
	Z3AkbF9/gAnhDtfAeU4qaMBnl0WHsZf275Yq9hMbhRL1+SRLoiexX862z1QidJtz
	SU1wgg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gs84a1xr0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 +0000 (GMT)
Received: from hu-devc-lv-u24-a.qualcomm.com (hu-jcameron-lv.qualcomm.com [10.81.84.69])
	by NALASPPMTA03.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTPS id 68J1RpeB3483928
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 GMT
Received: from hu-jcameron-lv.qualcomm.com (localhost [127.0.0.1])
	by hu-devc-lv-u24-a.qualcomm.com (Postfix) with ESMTP id 1906F24DE1;
	Fri, 18 Sep 2026 18:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v18 5/7] firmware: arm_rmm: Activate the RMM
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
In-Reply-To: <20260912083611.2513845-6-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-6-suzuki.poulose@arm.com>
Date: Fri, 18 Sep 2026 18:27:45 -0700
Message-Id: <178978126542.2352296.10527413259157627665.b4-review@b4>
X-Mailer: b4 0.17-dev
X-QCInternal: smtphost
X-Proofpoint-GUID: 302lZnfJ4GkCbMvsWeOukSS38_6TSES3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX6TKTc7X/tDu8
 wXCA3awHo8CyoLuusdY2vhGJU5UIyuMXXjxC17wt/VRdQwh9iOo5/e0H2wQOuG4Dn8BtjPEPv3q
 Rj1Ltu4yKl6CH84LtU1BUbmj9i7H5/8=
X-Proofpoint-ORIG-GUID: 302lZnfJ4GkCbMvsWeOukSS38_6TSES3
X-Authority-Analysis: v=2.4 cv=MLD1C8Zl c=1 sm=1 tr=0 ts=6aade517 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=7CQSdrXTAAAA:8
 a=EUspDBNiAAAA:8 a=sr4bC4xs5gVJGtrCXjkA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfXyalYluVoXgps
 jqoI/tlDqUsuotTAtSN1mXpl9e+DrAtKfi4eX8brkvpOOug5mfTvuWtbxSxSCYdlLzE3YMDRkxl
 gfyP1aS8GpLsJT5dipmOcsQtCegZ51B6osS7MrZ6Yo9oNUWsMDFm3sqnby5q0ly36S5WkW6n8ZI
 hDu2GPDkbod0HuiDdUY/lD7EbNNwx5EfyUZVFDkWs408o5dHwtuH6z933mKdoSs045Ej31k2VWj
 z5L6aQVd3uw57a3jtY2OplJBtwkAzAp1mjbYj65NC237BcIU/xDxR4YmKgTlZX4tQvqh+R9PcFo
 uLg/jvLkaBHadNHNdLU5o2TCUkyVcoVz4sY3Y8xM9pV0hSnvs/DBqnd8oJIPdVATAI7dUQnW12C
 XznvmDZ/ccHEFJ3Zf7Af1SyJhx/yjjKLKjq1VBe4KrkhgpwmJ7Pfn4JlW/HcJeJIHZbBym5qCiY
 nl0PzwSMVcJZ8Uo9LHw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609190016

> Activate the RMM after the basic configuration. This is a memory transferring,
> stateful operation.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

With the declaration moved as per standard way of dealing with __free
magic (there are docs in cleanup.h on this)

Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

> ---
> Changes since v17:
>  * Inline RMM_ACTIVATE command and remove the definitions from arm-rmi-cmds.h
>  * Use scope-based cleanup to free sro object
> Changes since v16:
>  * Split into a new patch
> ---
>  drivers/firmware/arm_rmm/rmi.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
> index 4f9898ece754..ecc89e91d264 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -762,6 +762,7 @@ static int rmi_configure(void)
>  static int __init arm64_init_rmi(void)
>  {
>  	int ret;
> +	struct rmi_sro_state *sro __free(kfree) = NULL;
>
Read the guidance in cleanup.h

This is a path to a potentially grumpy Linus.  He's made the sensible
point a number of times that putting the declaration of the destructor
anywhere that isn't right next to the contstructor is a recipe for
hard to read code and odd bugs (this one isn't buggy,
but the principle is more general and the readability thing does hold!)

>  	/* Continue without realm support if we can't agree on a version */
>  	ret = rmi_check_version();
> @@ -776,7 +777,18 @@ static int __init arm64_init_rmi(void)
>  	if (ret)
>  		return ret;
>  
> -	return 0;
> +	/* Activate the RMM */
> +	sro = kmalloc_obj(*sro);

struct rmi_sro_state *sro __free(kfree) = kmalloc_obj(*sro);

> +	if (!sro)
> +		return -ENOMEM;
> +
> +	ret = rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_ACTIVATE);
> +	if (ret) {
> +		pr_err("RMM activate failed\n");
> +		ret = ret < 0 ? ret : -ENXIO;
  		return ret < 0 ? ...
> +	}

return 0;
Perhaps to make it more obvious that any non 0 return means error?

Doesn't really matter

-- 
Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
