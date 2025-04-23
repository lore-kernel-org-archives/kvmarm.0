Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0B313BC0C
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414418; cv=none; b=VJuSt8+Q2MFZZCnVYpcyKvTTiQEBQ/PfAZXHPR7tTbH5J21vVjhxqeSU6P5hYk5y1l7r3iMaNWAFcpM+kjJT8IOSCAqvJXjw8IZcRV3NZcZYKx9M0wN4sXqB7HNn9RLdS98XRIxlyjx6VhO9ThC+ORYqNLO3jHzebjKWFXTAulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414418; c=relaxed/simple;
	bh=U3cYqloLbOvSFdJSZqoFl4F6R+8xGjc2XYOjlukdhjk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=ZqJlN5siExiiIbjSAhv9d0Gaq21NeoWEtXJ1Oz4Jf9J9R/pbc/KymJPKFGGkMRtgdiZC2dnKyPxxi699h1u4eoA2rVVwSgQBAgy1GUt0jnXy/bLiFH003oHBDOoFaEKhuVnxdRuu6+B17M44x9RLHp0g7z1+ylD6TM0ca6tZN8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=hVnOWRe+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="hVnOWRe+"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAkwud014559;
	Wed, 23 Apr 2025 13:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Kg/vqusO5+9W7QqebKB1OKeumLCf6lCb0QG3HEEF26k=; b=hVnOWRe+nd9oYO9w
	DgxmuwBnT9myycawSDCOJpWaBYUVC1I3pD+hsrzSu2chKJsFwBT64UcTfB24JvQL
	ODogym26to60pHPUZaG7VOun4f5AvE5JtHmQ8JtaZag/9Yi8SHzM8iFDamioGttp
	wFWDXJ+9BzhjiAytculd8UbR/5QFB5ssjWcBi05hz9iIPPLwM6ZA1yiJWnBGRaPP
	parz4ErjCB09XbP3B+1e18v9ZhZr3vMNepQQKKzDUDH/h4lhfyeAYlpsEC22WJwE
	anyuqxp+tvxUYUUC/aNYnaVciMKyQ/VcJk6cs3P7btSpiIdEMioW5RSwLsiYwFZc
	0apilg==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh0j7jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:19:52 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53NDJpRS022364
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:19:51 GMT
Received: from [10.253.74.233] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 23 Apr
 2025 06:19:46 -0700
Message-ID: <1d70b1c8-f5f7-4027-a0cb-b1638e309a48@quicinc.com>
Date: Wed, 23 Apr 2025 21:19:43 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jie Luo <quic_luoj@quicinc.com>
Subject: Re: [PATCH v3 0/6] Add FIELD_MODIFY() helper
To: Yury Norov <yury.norov@gmail.com>, Marc Zyngier <maz@kernel.org>
CC: Andrew Lunn <andrew@lunn.ch>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cocci@inria.fr>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.linux.dev>, <quic_kkumarcs@quicinc.com>,
        <quic_linchen@quicinc.com>, <quic_leiwei@quicinc.com>,
        <quic_suruchia@quicinc.com>, <quic_pavir@quicinc.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <86sem7jb5t.wl-maz@kernel.org> <0c97c659-bd28-45e0-8537-d9be2637cb22@lunn.ch>
 <86mscek7h3.wl-maz@kernel.org> <aAJq9mGswYsnAOS8@yury>
 <87plh9xz2d.wl-maz@kernel.org> <aAKGHIssRW5jXvdA@yury>
Content-Language: en-US
In-Reply-To: <aAKGHIssRW5jXvdA@yury>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: BN88jDYWGmli4vHQcBNP_g8Tvmp6cMeZ
X-Authority-Analysis: v=2.4 cv=ftfcZE4f c=1 sm=1 tr=0 ts=6808e8f8 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=rL1jKAeQPVWMZnSF2k8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: BN88jDYWGmli4vHQcBNP_g8Tvmp6cMeZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5MyBTYWx0ZWRfXzbLcmo1j7n+4 cF/GKqx6vJwZDlKbABC0g/aYzHPNypSuZSbOqMTAGBxJlyZT1Va2fq8JoWHfI4+e7mq9M0Mt8eb 0yngKZ46t89+aaOz89gEWnUJ+9IVWPetjBnmd85XfbutXZZuclw99xOQikSTs0rOeVHCmuN28fI
 V7Q2k+Kyatbom3i9iWEQ6aWEumOMFP9prMv2aFduU2EXKOaUMpKvR2m7oF0Sz1fDUXfoJQbZc2m SKr4s9UAp1Jxcks8AfxlOYUlVADDhZ/qyb+BslC6zDZVXhY1juhIJJdzdR0JtltLXzvPNj5zA5h VEXGLprWpwE5Ctdqty/M+7DO3xFk5/S5+GWq/GFX/CSaRR15f5Dq+dSVgaCxQ1ENHXT/nn3sKxf
 D2g+34XwZg5izFbfxo5Ltkf5JFVZpy6hoOJzVyI/Zqh40tr6j+kZqw++/jtAh0okhNIvnBi4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=884 lowpriorityscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230093



On 4/19/2025 1:04 AM, Yury Norov wrote:
>>>> I think a bunch of people have found them, tooling notwithstanding.
>>>>
>>>> As for the documentation, the commit message in 00b0c9b82663ac would
>>>> be advantageously promoted to full-fledged kernel-doc.
>>> The FIELD_MODIFY() and uxx_replace_bits() are simply different things.
>>>
>>> FIELD_MODIFY() employs __BF_FIELD_CHECK(), which allows strict
>>> parameters checking at compile time. And people like it. See
>>> recent fixed-size GENMASK() series:
>>>
>>> https://patchwork.kernel.org/comment/26283604/
>> I don't care much for what people like or not. I don't see this
>> FIELD_MODIFY() as a particular improvement on *_replace_bits().
> Sad to hear that. Those people are all kernel engineers, and they
> deserve some respect.
> 
> We are talking about tooling here. People use tools only if they like
> them. Luo likes FIELD_MODIFY() over (yes, undocumented and ungreppable)
> xx_replace_bits() for the reasons he described very clearly. He's going
> to use it in his driver shortly, and this arm64 detour has been made
> after my request.
> 
>  From my perspective, both functions have their right to live in kernel.
> They are similar but not identical.
> 
> I'll take patch #1 in my branch. Regarding ARM64 part - it's up to you
> either to switch to FIELD_MODIFY(), _replace_bits(), or do nothing.
> 
> Thanks,
> Yury

Thank you for reviewing and discussing this patch series. The newly
added macro FIELD_MODIFY() will be utilized by the Qualcomm PPE (Packet
Processing Engine) Ethernet driver. Regarding the ARM64 core files,
could you please provide guidance on the preferred approach?
