Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C31523B60F
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750068437; cv=none; b=SsGuLNrKN4jUINojQAI+lxTeeHPAVq+MizohYTLrU6bgaOCvFlOUpRCGHw5eyzgWFx4H5RpIWSYd+A2kyztzCMw3Gj5LjUy+496/fg6IXxwJn7NrmD9tGyU50g1PqI+kaNwoE73zhq9YvqugCSDjxuq6PJ2A36HreB1LCoSlYPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750068437; c=relaxed/simple;
	bh=Lq8cqU8VINtW1dQLGxAYS6afiJNutTYBDkfPOaltG2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HeKlKF3KEwtHqahAY2kPI2vv3465W5iaQzWK7dzhWyf5R9tXzlYxzaA52dyIVTN887g+lN36w7KNXTQjaRExFwE5VFNezpBfC59xSbw8Vita9obsPmmk65CeeulfioO6oKJEWr7JAXvc3VcAQcTp74CuaGZtexo33geFmHLbCcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=AoX6/She; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AoX6/She"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G8RdQC011453;
	Mon, 16 Jun 2025 10:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UWZKq+facjiaX5VfIZfoLXvS21EBNXNgcqPrsZk1JJM=; b=AoX6/ShezdTds7wN
	yxpRHPu32orf1q3lL+KUAAiRIBWKh1zpp6fok/TRhDb0pja9VsVyQ9RBNUrZY+rV
	EvuGGSc5maMpBIF3X2pZyoe3p4PaihhJArw+0ykn6kHjXHnX+12DDbibTc1S+vSY
	eyl1uFFJJSxa6MzUpiaX32KQQAoSZsL09vNPpE5XsGeZ/gkrRl7B8rKKgUbTXRxy
	q10OaE90DHdyrsY7sQXohkxVC5AnRrfbYyDl2pA02M9Qayb0UK1jEFmh6Bn9KhjX
	8AmNt9UnLESAPGeU0OudDKXm8uCC5QlzOIzOsDRLUWtWzf5W9HrNEI3yuhZ/XwFz
	yDaGzQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 479qp5jnbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 10:06:44 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55GA6itq030847
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 10:06:44 GMT
Received: from [10.253.8.97] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 16 Jun
 2025 03:06:39 -0700
Message-ID: <0c0a9c7a-f36e-4500-bbea-3a22a04431b3@quicinc.com>
Date: Mon, 16 Jun 2025 18:06:36 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Add FIELD_MODIFY() helper
To: Marc Zyngier <maz@kernel.org>
CC: Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes
	<linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        "Nicolas
 Palix" <nicolas.palix@imag.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        "Joey
 Gouly" <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cocci@inria.fr>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.linux.dev>, <andrew@lunn.ch>,
        <quic_kkumarcs@quicinc.com>, <quic_linchen@quicinc.com>,
        <quic_leiwei@quicinc.com>, <quic_suruchia@quicinc.com>,
        <quic_pavir@quicinc.com>
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <86sek5cane.wl-maz@kernel.org>
Content-Language: en-US
From: Luo Jie <quic_luoj@quicinc.com>
In-Reply-To: <86sek5cane.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 9SYfzjF3RGzccne1WkjDRTBZRqXR4qMQ
X-Proofpoint-ORIG-GUID: 9SYfzjF3RGzccne1WkjDRTBZRqXR4qMQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDA2NCBTYWx0ZWRfX7UrecK1eCq0L
 8jXrAGXhthDm1V6AVytgr3qliiXHjBZaL76sRZ3phJrAmJasaSNIHGzGBFhBFi9o5IyFk+xr73/
 IhE0N4gFcbqzn7S0S7Y52KjoBgJTd6vDBFJ3S0u8Ezjm7BywP5onFsmIJfz5KtGQHVhXmdvLKDh
 HhVLEaxXzBMod9Q38nM1Mu16s4l1HX+23Cpf2phN6fdQqmVOmOQE77cCrvquRNryXNGm2E0cfrJ
 YsohgekeAGt6tReiCse3CCm8omb3spIjoUQVI38+9g6ghiU4z1+Vb7SKKDrKHKR/oxWt1t89JMq
 Y7xkqAqi8zKGKRpOOG+X+UF8egA/sye8lBvBpkwGGcAPhX1Ivjfo7H2hFERpSSFfMKN+oAUW6CB
 cjdJ4ljTU/jmgXd3d51GgsVlOh8j6vcM2f64dVA3ksVJFgMn0VPWdcBpNXSVQsIQoxGFMit0
X-Authority-Analysis: v=2.4 cv=fMc53Yae c=1 sm=1 tr=0 ts=684fecb4 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=COk6AnOGAAAA:8
 a=r701-TsZq3b5Q2E7mLQA:9 a=QEXdDO2ut3YA:10 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_04,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506160064



On 6/12/2025 10:11 PM, Marc Zyngier wrote:
> On Thu, 12 Jun 2025 14:46:07 +0100,
> Luo Jie <quic_luoj@quicinc.com> wrote:
>>
>> Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
>> macros. It is functionally similar as xxx_replace_bits(), but adds
>> the compile time checking to catch incorrect parameter type errors.
>>
>> This series also converts the four instances of opencoded FIELD_MODIFY()
>> that are found in the core kernel files, to instead use the new
>> FIELD_MODIFY() macro. This is achieved with Coccinelle, by adding
>> the script field_modify.cocci.
>>
>> The changes are validated on IPQ9574 SoC which uses ARM64 architecture.
>>
>> Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
> 
> I already indicated that the *pre-existing* set of helpers are enough
> for what we want to do, that we *already* use them for KVM/arm64, and
> that I didn't need nor want two ways to do the same thing in the same
> code base.
> 
> My opinion hasn't changed on that front, and I don't see a point in
> these patches.
> 
> 	M.
> 

OK. I will drop the ARM64 patches and only keep the coccinelle script
patch in the next version.
