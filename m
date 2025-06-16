Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA120C030
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 16:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750090845; cv=none; b=D02U9UYrQ639Qlw3t/KB43iZk3vGcYCF0QQ2nIzVv83cGHADTPWTcI3ESpVuHTb4RZHl2PgFcimSZ+ryo5WrYw2gusKaVifjBraEv00VTtCwknFDEkIZXBsboXCpAX0M+20e7CMo972ecNoPOuyLbxED9uKtCE4YdxGQlSEiXVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750090845; c=relaxed/simple;
	bh=7/6Zk5ECIk3ufJzj3zBNdmjp956e/2BkawTbTwbQ77I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qHO9PVLl8uyw3xX41vF4yGuf2IzROf5dtgoaBUUCbRLK7QggApchz21cz5BgdyRqKGK80HqB599p+YGaUsVcfqDmpZreAkpTgTjGAdfDlUHbMwvqV1vvstp2RsyuJs2uEsyLTBirgRqYh/6FDYJpyONDaDNBQKmkbJfBzaUmatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=oz+rVnva; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="oz+rVnva"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55G8knX0003269;
	Mon, 16 Jun 2025 16:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T9tIP/nA/ojXJcuyJ7abvo5FqmtLH8FMyCSjTHFOwIo=; b=oz+rVnvay4RqXGaS
	su8jq0wu9WXgxbf9OoseSyuYta6ZWUAJSPlLeM58oqxumqdhqscJ0Pv8gVNkoOKe
	Q2FbHkEUSELviRgZd8coHNHpuClo6vXzerTWu2drelH23T+C5eZNlHYjELedcVd6
	wLVBSMSYaBFBtmOPn4D25VoQ0gf3wYNHKMpg2LjrMw6wqlrzh04FWZfNA0w/vIuA
	1v6J1VpHHDrMPYsdS5H33Ac4eVhRxi+5czLsoIb14u2lbXp704FdKraw3XNcV8gC
	hvlrrYlMFQio/KiaLUbC9FUiw4L+rlmVJsTKIkYAWOxOg8KXf5oW2fiXUgCSZUEo
	oh+Mkg==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47ag231bbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 16:19:19 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55GGJI4h019496
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 16:19:18 GMT
Received: from [10.253.36.28] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 16 Jun
 2025 09:19:13 -0700
Message-ID: <79355a26-c901-40a4-8a90-096da1380d9f@quicinc.com>
Date: Tue, 17 Jun 2025 00:19:11 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v4 2/5] arm64: tlb: Convert the opencoded field
 modify
To: Will Deacon <will@kernel.org>
CC: Markus Elfring <Markus.Elfring@web.de>, <cocci@inria.fr>,
        LKML
	<linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        Andrew Lunn <andrew@lunn.ch>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, Julia Lawall
	<Julia.Lawall@inria.fr>,
        Kiran Kumar C.S.K <quic_kkumarcs@quicinc.com>,
        "Lei
 Wei" <quic_leiwei@quicinc.com>, Marc Zyngier <maz@kernel.org>,
        Nicolas Palix
	<nicolas.palix@imag.fr>,
        Oliver Upton <oliver.upton@linux.dev>,
        Pavithra R
	<quic_pavir@quicinc.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Suruchi Agarwal <quic_suruchia@quicinc.com>,
        Suzuki Poulose
	<suzuki.poulose@arm.com>,
        Yury Norov <yury.norov@gmail.com>, Zenghui Yu
	<yuzenghui@huawei.com>,
        <quic_linchen@quicinc.com>
References: <20250612-field_modify-v4-0-ae4f74da45a6@quicinc.com>
 <20250612-field_modify-v4-2-ae4f74da45a6@quicinc.com>
 <3537a4ce-b5e8-44d5-a884-70a81562068d@web.de>
 <94b40ff2-9e9e-4eea-8a66-87d8976aeb70@quicinc.com>
 <20250616104109.GA17500@willie-the-truck>
Content-Language: en-US
From: Luo Jie <quic_luoj@quicinc.com>
In-Reply-To: <20250616104109.GA17500@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: WwhEiw-vE7EU9ByCs0vSwvvuPqtNiw5R
X-Authority-Analysis: v=2.4 cv=edY9f6EH c=1 sm=1 tr=0 ts=68504407 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=YgwN3AOMAAAA:8
 a=GpepFeYYm93ioQPZbdsA:9 a=QEXdDO2ut3YA:10 a=ztR1XV6QG-NWxUt1dNgd:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDEwNiBTYWx0ZWRfX2SsQ7Egy1Lgq
 3PaG3WWwqmwPWB7U2f/+vnv3tUT+SKiRLHYsRcjVhI4b8LiBO6MvmBJcjUH8ZJxHEb+gBAvI+s6
 iY4lCjthHgCoKlh2shbP4SevA2I8VNDkzN4s6TCFRYT6Zf04af2/ZM/RYTYT+fmFdEZBeJjrbGE
 qPRY7tX8guFGIL01aSHti2m0PxdfXLkVVYbqttNmJtQnqLPfP3i3YLdhP+AfCpc6vFSB6Q6dxws
 acstCiAVOYJ9Rcrx71lJeMui+AzbWvo7frgc0ARX5S8m0n2RIsLgzpAzBhWVLXdxf36WV9QpvCE
 Xjg8+4BoWsbJREsDLPgDjgqIDv4Lu0ObzneNCJ9zE6GSW8iYQw7U5kAnYpbbSXVKalp6bb36L9o
 ZpF3FCgP2wA2hpyqxf3/Nou54p4aGFtvzl26R/UmPXs7u0dApb+bmPdUQU/iFvK58rJGdGZr
X-Proofpoint-GUID: WwhEiw-vE7EU9ByCs0vSwvvuPqtNiw5R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_08,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=859 malwarescore=0
 phishscore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506160106



On 6/16/2025 6:41 PM, Will Deacon wrote:
> On Mon, Jun 16, 2025 at 06:37:41PM +0800, Luo Jie wrote:
>>
>>
>> On 6/13/2025 4:15 AM, Markus Elfring wrote:
>>> I see further refinement possibilities for such a change description.
>>>
>>>
>>>> Replace below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
>>>> - reg &= ~MASK;
>>>> - reg |= FIELD_PREP(MASK, val);
>>>
>>> * How do you think about to omit leading minus characters?
>>>
>>> * Subsequent blank line?
>>>
>>>
>>>> More information about semantic patching is available at
>>>> http://coccinelle.lip6.fr/
>>>
>>> I suggest to omit this information here (and in similar patches).
>>>
>>> Regards,
>>> Markus
>>
>> Thank you for your suggestions. The current commit message was generated
>> by the following patch mode command:
>> ```
>> make coccicheck MODE=patch COCCI=scripts/coccinelle/misc/field_modify.cocci
>> V=1
>> ```
>> However, as I understand, the discussion on the ARM patches (between
>> Russel/Marc/Yury) has concluded that the ARM arch changes may not be
>> adding value over the current code, so I will drop the ARM patches
>> in the next version.
> 
> Well, hang on a second. From what I can tell, the objections haven't
> been specific to arch/arm{,64}/. You haven't really explained why this
> new helper is needed and what value it brings over the existing set of
> functionality.
> 
> So maybe start there, rather than dropping the parts that attracted the
> comments to start with?
> 
> Will

FIELD_MODIFY is similar to uxx_replace_bits() for in-memory bit field
modification, but with the added advantage of strict parameter type
checking at compile time.

Previous discussions (in patch series v3) among Russell, Marc, and Yury
focused on whether there is any added advantage of using FIELD_MODIFY()
(possibility of size overflow checking) for the specific cases being
modified by the patch series inside arm64. For the one case where enum
was being used, it was originally thought that there may be a
possibility of size overflow due to 32bit size used by the compiler for
the enum. However it was identified that the kernel's compiler already
uses 64bit types for enum if the number of bits used with the enum is
more than 32 (the code in this case used more than 32 bits).So, it seems
that there is no additional benefit of using FIELD_MODIFY() in the
specific cases in arm64/.

Please note that the current ARM64 code using FIELD_PREP() also supports
strict parameter checking at compile time. Both FIELD_PREP and
FIELD_MODIFY utilize `__BF_FIELD_CHECK()` to support this compile-time
parameter validation.

