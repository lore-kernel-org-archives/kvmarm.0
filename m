Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602552701BB
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745414181; cv=none; b=P2/IyTz64UKyayUjR2hiMfOK/+0JRPYpza2BFnruolgR3v6d3BS+2RZ0h3ptBXuxRaC3AsJ7odu+2x1MJpjwuETSr1F4l5HpJtWhwD2Sxhvxa4+O0/FtnKYR3tjFR+XUUhSg4IRdsNiqpmvOKOFPvDjfExrW2H0OJO8PvO5y5mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745414181; c=relaxed/simple;
	bh=qLeRKf/Jfc/AzwqioY6YmW4pX8yerciiGgSZgLLBces=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=IhBxvN3JZwyIPGyPBYat2vxxzP8F/YBWM8iJzN8uC5bpHpmFmJIJH1bI0vSrL6znp34lMirt68o3SXeNJg2lvDg2QcgpQ2TAVBrx0lVmkl8vxvSRA0+rZ2PhPOxvjQgp0q2lgo+ioTdWEINr5t/jFLooox3bguKEq1ylq2viqks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=epr/TzqL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="epr/TzqL"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAbjfZ011429;
	Wed, 23 Apr 2025 13:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h9VplE0QC4aY1gR58x72U5ymrgJrPj0iCMqED0qOjtA=; b=epr/TzqLMbjdgAYb
	aqjECcYdB9xHMSlIJEnH+K2nZ9zREtawvRSPctcA4ZNZzuhSSZaWdUoV0GfwQ4Jr
	aqQfCmaeAca7jDw0/6FvtKZYappgVVgIyjImfMpGTpBdttd03vMHfQJR3jXxmoeO
	04vgxOTtGMP43qZNq5K2P8LDMu+KSiCXPMKKvC/JW/wkUqYJmDtYXe+kzxw3Pf4U
	4AJvywUUwVGcPdlJvxkKQSzIIBfKFfZWJroQdU2o8WeOhvSBQ/T7xtJXyfLpDaUp
	wZLpcpnMjS95LKl7uAmalekYmtRla7D78XVrGO9ThwghWxLB52FyXX9HwklWvv3c
	rlMosg==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh1j87e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:15:46 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53NDFkAl018230
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:15:46 GMT
Received: from [10.253.74.233] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 23 Apr
 2025 06:15:40 -0700
Message-ID: <2b7ca78e-18f8-41bf-979d-8d502f6f8fe1@quicinc.com>
Date: Wed, 23 Apr 2025 21:15:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jie Luo <quic_luoj@quicinc.com>
Subject: Re: [PATCH v3 3/6] arm64: tlb: Convert the opencoded field modify
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
CC: Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes
	<linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        "Nicolas
 Palix" <nicolas.palix@imag.fr>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton
	<oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose
	<suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cocci@inria.fr>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.linux.dev>, <andrew@lunn.ch>,
        <quic_kkumarcs@quicinc.com>, <quic_linchen@quicinc.com>,
        <quic_leiwei@quicinc.com>, <quic_suruchia@quicinc.com>,
        <quic_pavir@quicinc.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-3-6f7992aafcb7@quicinc.com>
 <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
Content-Language: en-US
In-Reply-To: <aAFEOr_PnZRH2ocR@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Zr3M8IAXwgtXp3BYAbPXMxX0KvqkQhtU
X-Proofpoint-ORIG-GUID: Zr3M8IAXwgtXp3BYAbPXMxX0KvqkQhtU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5MiBTYWx0ZWRfX7P6/H5f+henI G7IlHjHppUVsUsuEJVmbat7/+Zqx6yiHfDal02OxGIrVvJzemA80dkzmPAEpN5koc02+DO9qDm9 CPrvZqBIocUsJn0VAYfPnk0B+cbFcC/TTx7ajmDiSGX7ymx7H3LtkYPCpGeHGf99yRxo2Yinjf3
 g0c5dPQVZ9SdtSkS227NT/HjMd7vLRRJhl2ne6IbwkrFzybAAa6VLlX+1nW5JoxtYXm6SXoFpd3 VrwGom//9wcah4zQg1ivFK+uU65qUT6ig+HupDy3rwuIo8I3Dd0PDs++zGxu5vSbqvIBihGgIJu rGQ2CYXbxvS09+FkthDdldqx6yDsJ6CM3xdnahX1mjayKJvBzTUq2NxLmJgBagdDnSdCs5EXlbL
 6h0D1rqU2X/CHzQ2o/UAuFgE4/GR/q2EFz55YGzXof4R9QvjoWgDXUQdVlie2gnV7hLLzsJ7
X-Authority-Analysis: v=2.4 cv=ZpjtK87G c=1 sm=1 tr=0 ts=6808e802 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=ZOzjf2MOAAAA:8 a=COk6AnOGAAAA:8 a=8k5bqqvh19RxIrhT-ooA:9
 a=QEXdDO2ut3YA:10 a=1Mhi-5-LkjG4w5oc0yAU:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 bulkscore=0 suspectscore=0 mlxlogscore=867 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230092



On 4/18/2025 2:11 AM, Russell King (Oracle) wrote:
> On Thu, Apr 17, 2025 at 06:47:10PM +0800, Luo Jie wrote:
>> Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
>> - reg &= ~MASK;
>> - reg |= FIELD_PREP(MASK, val);
>> The semantic patch that makes this change is available
>> in scripts/coccinelle/misc/field_modify.cocci.
>>
>> More information about semantic patching is available at
>> https://coccinelle.gitlabpages.inria.fr/website
>>
>> Signed-off-by: Luo Jie <quic_luoj@quicinc.com>
>> ---
>>   arch/arm64/include/asm/tlbflush.h | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>> index eba1a98657f1..0d250ef4161c 100644
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -112,8 +112,7 @@ static inline unsigned long get_trans_granule(void)
>>   	    level >= 0 && level <= 3) {					\
>>   		u64 ttl = level & 3;					\
>>   		ttl |= get_trans_granule() << 2;			\
>> -		arg &= ~TLBI_TTL_MASK;					\
>> -		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);			\
>> +		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);			\
> 
> This could equally be:
> 		arg = u64_replace_bits(arg, ttl, TLBI_TTL_MASK);
> 
> which already exists, so doesn't require a new macro to be introduced.
> 
Looks like the new macro FIELD_MODIFY() is accepted by Yury, maybe we
can keep to use FIELD_MODIFY() with this change for better readability?
