Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF6C3BB106;
	Sat, 19 Sep 2026 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781295; cv=none; b=TEPxLandMgYH7onIBZcMMm9u6x2lcQnjJTIAVm1Woc+zUL1j18zFJ6EV3EbOlgbCvZUYqZGDadVBGY0Bl3uQLpaaP4D/t5gXD5kj869Otj3HUvXHM8HBkKgEwxsniatFbuzjdkARHb14QYJJ2I1iaA9V9+5BJgjdlVlXX2D3XAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781295; c=relaxed/simple;
	bh=4aaRdjQ4Io1FoQmUn23Mq20HORFh6DSbo7lbscyxtZc=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=fpOQVah3OYDOtgnLXxRlMUUWIHwVjAlPJIRcTmZSp+7DfEhRQPxqs3kVuU159UpQ5EwGQBfV7+Bj+/373y3DwZHf74l+e5my8PtfaqYe6Zyf3AjDTPj0vJYkovAXVwpoLLUdU+941Nsyp/pYaniPtJ1E8gtBNNCJWyUxm78a4gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Okj1BylP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Okj1BylP"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J0Jgaj2182706;
	Sat, 19 Sep 2026 01:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GmEokH++yRwcBwWlKo0t6cwFvtc6C94Yt4h2XzEjbmU=; b=Okj1BylPpj1HIvqN
	IY4hpvtiD9jmjRtD18BsChRd2jt62zQ0Cdcbcv0WKaZp6jGuC4DE58aznqcdKBEp
	tUK5tdHE2Do79ZcmRaupcvQ4fvtQt4RIA92YBstU20BOCLBf22D1sv3gQ24HsL8S
	zyMhAYpdzWzgrn00x+rYZjrHiwYS4KjKuQVoMkjApOm3KCeYQaH+6jbDDGQH9Qca
	YWqbgqAzkSb6csivtWHCdXcp5RNcifk0z6rF3UmVbjE2uw0MZ1KKI0MPIF38eppC
	GF+sZaGfQNpYi5dYEIzBtsxMr+uyxTbQsY9jAjvQiUt2ijQuqUeFS+uoO0Cxb1iT
	MlKBDg==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gsfrnr51d-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 +0000 (GMT)
Received: from hu-devc-lv-u24-a.qualcomm.com (hu-jcameron-lv.qualcomm.com [10.81.84.69])
	by NALASPPMTA05.qualcomm.com (8.18.1.11/8.18.1.11) with ESMTPS id 68J1RpOD3460797
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:27:51 GMT
Received: from hu-jcameron-lv.qualcomm.com (localhost [127.0.0.1])
	by hu-devc-lv-u24-a.qualcomm.com (Postfix) with ESMTP id 1432924CDD;
	Fri, 18 Sep 2026 18:27:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v18 2/7] firmware: arm_rmm: Check for RMI support at
 init
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
In-Reply-To: <20260912083611.2513845-3-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-3-suzuki.poulose@arm.com>
Date: Fri, 18 Sep 2026 18:27:45 -0700
Message-Id: <178978126541.2352296.3637463397103730192.b4-review@b4>
X-Mailer: b4 0.17-dev
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=W9mtxhWk c=1 sm=1 tr=0 ts=6aade518 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=7CQSdrXTAAAA:8
 a=EUspDBNiAAAA:8 a=fwO9cvh01lKeBat_3SIA:9 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX8+NvaUsVIw2D
 6np2PAPzBDNPfPLuLmHFh9KqokgPPaDsXYY+ingQ4cugGtpVFLclgifP2APyVuGSY7HW5X6U0ep
 F8d06u/gjX4T6xW/0wml2t3ywHThmmQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxNiBTYWx0ZWRfX+WvYSF/JVCd+
 cEfAqbwrgTh1EPZLoU0mGnjP6XX4VDAweqXq5v/H9Zuy5bIlJQ8Y3cRceymPo8hNGg8rvXP62vC
 QreFBHo0dyHJsCS+In8SOXeEubXyuRdCayWwADYIOzypnmL1DmVaOT7f3Sj32d6BcVpFC8/fHxV
 E9pXdQ3mJQtbQlV+JX+3ryaqS23ls6jBvZRYQawefI1gTYUTwl/fR95ebMC74R7BK/zPcSohkWx
 HiVWaBpTO7dWetbkZdxn0StjDD4C+ac64bZuFY2rjTRT3GVZDQ4NI+WYe2IOGAnT1Lq1LK5WYMH
 FEdwG2T+lQ1jkf9cluRuKYTe63yzS7RbIu1rM9n39qR8Is+adpmPEYofmSIVKkb1hFfi/JUmVfR
 JLYDANcKxmVlfgMUJ56z12IKw5Oi6g4m0rkLzpLjp7w9wZ0B///HTD1XTrn3qhYaeyJjCcjwLoa
 +XlDAUQjHQ+ZvFZD+bA==
X-Proofpoint-ORIG-GUID: ZLs6Xbddowb1c3a90KA2fibWzYHLB6i6
X-Proofpoint-GUID: ZLs6Xbddowb1c3a90KA2fibWzYHLB6i6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190016

> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> We only support this for Little Endian kernels, the Big Endian kernel
> support is anyway marked BROKEN and is being removed.

Can we have a small comment here on why the default is y

It's a big thing to opt into by default.  Feels like defconfig
material maybe but not in the Kconfig defaults unless I'm missing
something.


> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

> diff --git a/drivers/firmware/arm_rmm/Kconfig b/drivers/firmware/arm_rmm/Kconfig
> new file mode 100644
> index 000000000000..82724ee23186
> --- /dev/null
> +++ b/drivers/firmware/arm_rmm/Kconfig
> @@ -0,0 +1,26 @@
> +
> +config ARCH_SUPPORTS_RMM
> +	bool
> +
> +config ARM_RMM_RMI
> +	bool "Realm Management Interface (RMI) Support"
> +	depends on ARCH_SUPPORTS_RMM
> +	default y
Really? Why?

-- 
Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
