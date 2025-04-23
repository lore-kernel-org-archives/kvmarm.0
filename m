Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2951738DF9
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413580; cv=none; b=PF6P0jx8F4QM1iI9DSWNbnXcas4m8s5Ki4j2aRTA9ExsRBzDhOSMz1ly7N0aGlpSKXYujknBGub04OhtAOqi9B5bJ/F8jzYZJDvWCMo9xtCN5ih+yKtr0H7ttDVQcxCTVCkWfubZ95qjXR1tApby1GhJlzYbVm6K/Te44Hym3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413580; c=relaxed/simple;
	bh=QXZOXiQoVte68E+OhfrEVya/2C3HhWKA9wuEqFHja0o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=gS5bG0OolQFcZ8kWA+PKwM2mZDiUbnt42vUQw6BBi25+m7izVythu77N7t27p2NfxhzcJrF6YtgQ3DOrIAIVi4qBvEae+swXC7frTx+vADDJc2vp6oYo6HVk4VkNHR+Z7pqt1q4LSHQP4vvBnJncWv1Qx/72WidDdE5zzK3p2XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=EGU1V1Ro; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="EGU1V1Ro"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAbfrI003028;
	Wed, 23 Apr 2025 13:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dbiIO3r1xFAtnDUD174p9j71UWbTGBeWLa/ZZ2MHI7s=; b=EGU1V1RoPpwTV0Dk
	HtZuXkiX6YSS+gkHqMVgolOvgdsC77YqlkSZRSFMt2SznYLQ6/3DjUf1HAuK90bL
	ghxCtT1U82C4Aj17XPCcka0NbFrM3sVBfsqO25GTNy9p7OxVQ31KuOQ6NJElm+Kg
	0HBuwiWU/9Y/We/WCijRC8/6VJkw53orwUz3ID8JKeCT0cUpH5VOvg/Ed7+8Scej
	FGXtqp0BmVycauebqUquqWHYiY0Hu6scLD2utCGX6ZHsC6wOmjpGLixYrPl+3s3m
	KlOp49MS7EBxFjWaJBRgljOVaUlvAqaxzmHto1kFLQuVbLEmMUEnNF2UWQ2RUe8e
	NNp7/w==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jgy26fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:05:56 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53ND5tvn030684
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:05:55 GMT
Received: from [10.253.74.233] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 23 Apr
 2025 06:05:50 -0700
Message-ID: <968d21dc-437e-4909-bca8-fac4402f515d@quicinc.com>
Date: Wed, 23 Apr 2025 21:05:47 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jie Luo <quic_luoj@quicinc.com>
Subject: Re: [PATCH v3 1/6] bitfield: Add FIELD_MODIFY() helper
To: Yury Norov <yury.norov@gmail.com>
CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Julia Lawall
	<Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        "Catalin
 Marinas" <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly
	<joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
	<yuzenghui@huawei.com>, <linux-kernel@vger.kernel.org>,
        <cocci@inria.fr>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.linux.dev>, <andrew@lunn.ch>,
        <quic_kkumarcs@quicinc.com>, <quic_linchen@quicinc.com>,
        <quic_leiwei@quicinc.com>, <quic_suruchia@quicinc.com>,
        <quic_pavir@quicinc.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-1-6f7992aafcb7@quicinc.com> <aAKH37xa1brIAXfs@yury>
Content-Language: en-US
In-Reply-To: <aAKH37xa1brIAXfs@yury>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5MSBTYWx0ZWRfX4TP2GyrZl2bD j6o5xqwG5uolOPgkZM7X1CKnS3GuJhM7tmWZix521YhiWNBerHYtIC/RZvjJiA++wdsHc6KXOGt feGfqf4d6AripWWplDXnKv7Oypre9uFe4B6+sMxjpyPEJl2LijTok5gAwh2Det6EPBt3J2sdRQ8
 Zc8IjH8SKi/vzkFTVXm3+VeegMXCT3hBOwUKIbP2Md5+fKa9ILG31larC7qKAC2cfmKmRiiBPn9 DQgTD61eDfJQwnBWaWcnY5bsTWG8thxvLzKduoFuysR+TcbBDSJ8UC0pU8vg5utqoo6D8kE6UIn svdbAbkln7Bg5GnhWhlR4/HuSqTNcfi7ZZGVV5mexmUnPlV8Bj+HSg1lcTjU9bXj+Lx1mQ3AgjG
 UWl+1TbHzvTDaHFvaAZyVaYBtDl7P3lK5bCmdPezLva7IedogMgr39gBX9hg71Hb9AO4au6u
X-Proofpoint-GUID: R4LFE6L8_KJPKtN4i2COLAGKmLFNWmG9
X-Proofpoint-ORIG-GUID: R4LFE6L8_KJPKtN4i2COLAGKmLFNWmG9
X-Authority-Analysis: v=2.4 cv=M5VNKzws c=1 sm=1 tr=0 ts=6808e5b4 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=UqDml5D6FPZDCTgpU1gA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=928 malwarescore=0 impostorscore=0 clxscore=1015
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230091



On 4/19/2025 1:11 AM, Yury Norov wrote:
>> Add a helper for replacing the contents of bitfield in memory
>> with the specified value.
>>
>> Even though a helper xxx_replace_bits() is available, it is not
>> well documented, and only reports errors at the run time, which
>> will not be helpful to catch possible overflow errors due to
>> incorrect parameter types used.
>>
>> Add the helper FIELD_MODIFY() to the FIELD_XXX family of bitfield
>> macros. It is functionally similar as xxx_replace_bits(), and in
>> addition adds the compile time type checking.
> This paragraph duplicates the above. I'll drop it and take this
> patch to bitmap-for-next. Regarding the rest of the series - it's up
> to ARM64 and Cocci maintainers if they want them or not.
> 
> Thanks for the work!
> 
> Thanks,
> Yury

OK, thanks.
