Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD34F1D86FF
	for <kvmarm@lists.linux.dev>; Fri, 27 Jun 2025 04:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750998837; cv=none; b=MgAiaBXpcmombw4L8AlM53eDA8Cx/u6OmOD64i16DAQjp/aToqayQcX3bFds3vIygrWaRY4uiritt8658dsHMgzY/pQMTOpCEm40GK2a1hGYIBUa6yf4LEKj4wWTUDca67OyeERu7lIX9rJrMIng7xQfdtd8FXcfdW0iRbL/w3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750998837; c=relaxed/simple;
	bh=eZ0Rf9mlp7Cj3j+IUsCW0PLrSzyzYNYVR0q4LVXX8Og=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hXILIrjGktJSZKLDc2tXtXKmCZ37SwtkZt4RmqanxlR4udipn8JwNwUk/D7y6Xog1bcU49z1V43OgZdzsRJGwy4tAgFiicphpupgaoD489UFOy0LeMUrw+GAzlyExbNYAkr6S5kaYEq/AOrGEqxJX2vlzanKpz+TzsfxnzBXNps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=NhJtW8tY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="NhJtW8tY"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55R4DCeF014521;
	Fri, 27 Jun 2025 04:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K6Br1bux+uto34hrOpRBdkZiWcPdqetSr/kBiy2hggA=; b=NhJtW8tYUV3h9F0r
	YCdxz84zFOeQJf1e+1KSouF5SmwRMEsmBG4odOI7tzjpxde0qM0x9R08iN6OLH7d
	Y3zr2Q6UwaJ1k1OoqUs4WMuiuAmrsR5MstnSvesDvrxJ11FKFbVCTvb5yh5toQO8
	q5y8G9mswFqvKYt5TQ/MrE3+1KwvweKMKasPej89J+dQ4RKbeMOQVOBzPvkyth3T
	XL1voXrJLgsXa8M5TAFxtxUNDuFBNotPD8XOHQJjEkEcZ6HH4u5QQm0wFD9YHsp7
	0QAb9Y+LuIu7LxyT6g3NokiAmOfNriVoRKIppda7+wkQyyB+bz1eum6092MbPweT
	YI6MUQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47fbm241rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 04:33:23 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55R4XMC2030809
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 04:33:22 GMT
Received: from [10.253.36.2] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 26 Jun
 2025 21:33:17 -0700
Message-ID: <a3498578-e3ef-4c63-a132-56ba6ac24900@quicinc.com>
Date: Fri, 27 Jun 2025 12:33:15 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] coccinelle: misc: Add field_modify script
To: Markus Elfring <Markus.Elfring@web.de>, <cocci@inria.fr>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, Julia Lawall
	<Julia.Lawall@inria.fr>,
        Marc Zyngier <maz@kernel.org>, Nicolas Palix
	<nicolas.palix@imag.fr>,
        Oliver Upton <oliver.upton@linux.dev>,
        "Rasmus
 Villemoes" <linux@rasmusvillemoes.dk>,
        Suzuki Poulose
	<suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Yury Norov
	<yury.norov@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        Andrew Lunn
	<andrew@lunn.ch>,
        Kiran Kumar C.S.K <quic_kkumarcs@quicinc.com>,
        Lei Wei
	<quic_leiwei@quicinc.com>,
        Pavithra R <quic_pavir@quicinc.com>,
        "Suruchi
 Agarwal" <quic_suruchia@quicinc.com>,
        <quic_linchen@quicinc.com>
References: <20250626-field_modify-v6-1-200dffa38a07@quicinc.com>
 <e52cb86b-01be-4560-a1da-a6b07108d651@web.de>
Content-Language: en-US
From: Luo Jie <quic_luoj@quicinc.com>
In-Reply-To: <e52cb86b-01be-4560-a1da-a6b07108d651@web.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=YYu95xRf c=1 sm=1 tr=0 ts=685e1f13 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=8AHkEIZyAAAA:8
 a=uPLpxg-qKf-oJQXuHx4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=4NdJUZNqX0cA:10
X-Proofpoint-GUID: 1615e4W39KXNXAtpa1cLcQpMTxbj-kP_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDAzMyBTYWx0ZWRfX0MTFlVem0EDG
 qYepEKcTPilRd4UMCp9Wrc3DLOqGO7a4axgWd0j3W29rPtxkTxv/XtVpLIz3SubKFxEpnQzZI+l
 ME85y8Ho32cC+7l7/CvpiSXZhSmN/wbtiyp5dFB0I7Bgh2h6krzZ/Yc6ZxCOPLV0EXi9L9dsFTA
 UFv3AMpuiX3C1/UsWIBOgXrSnsZqC2nhp6bfdEgoTzkyzYARWLMzUgSgXL/QDTD8bpbDpcYhv6q
 9REWwd34mYZNo9lLuQEnqxXbo2Vv4ekhZoAG7QXIQNgy2PRs+GBt7mwp8uj+qMtF3pa6+9UETuG
 sVcm7e4XSJJKw6EhMYWh2gsh//v2wlL1/pgffVf6Jo7bMihC0qEn4nPd1xFyDVVUjNN4BExqyOT
 9TSrAZaDmG4/Lv1a5EWRAvMLHJ8AFm9mTWAaRurNsRPq7otpg4yFFDR0uku92cQgfTU2B3gs
X-Proofpoint-ORIG-GUID: 1615e4W39KXNXAtpa1cLcQpMTxbj-kP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_01,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506270033



On 6/26/2025 3:43 PM, Markus Elfring wrote:
>> +coccilib.report.print_report(p[0], "WARNING: Consider using FIELD_MODIFY helper on %s" % (x))
> 
> Would you find it a bit nicer to use also another formatted string literal
> as a function call parameter?
> (The recent code adjustment indicated something for the operation mode “org”.)
> https://docs.python.org/3/reference/lexical_analysis.html#f-strings
> 
> Regards,
> Markus

Sure, I agree that using a formatted string literal as a function call
parameter will make the code cleaner. I will update the function call
as shown below in the next revision.

coccilib.report.print_report(p[0], f"WARNING: Consider using 
FIELD_MODIFY helper on {x}")
