Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE99627F753
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 13:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662306; cv=none; b=aZ+5+bCKssW00GYmqkIUERChGskxsebuyjK253KEuSiw/meT4aSmRTclgus1QdXpcBNmXJO9eXccIlUzvGoqixxATl+tj8WqA4GyTvZugsFcI7qLE2QWQJbvih+ko1QIi/hdHLZURFUYnodcdQerqbdedUQ8EzRhy8PMyaUCt+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662306; c=relaxed/simple;
	bh=FN57vLe65C1svcmEj8o0ceeTxyA4BHTqUN3W2enYKdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iu2TKDyP/oiKibzZvMrXH86Ar2wucusawWHyR6kVqfXp/z1VuNV+hzg8eOl5SRg9rPmI+j6Lcv9lpxQpvGx6gv2ghFTnCgHaqJ0aIQWep53RtlD3F7BsKFfNd4AEdTdBgruauw634Sxq7m+svAPN31Ui2pK/74Kmau5BRX4rRwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=prEs2AZG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="prEs2AZG"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54J9IUfw028604;
	Mon, 19 May 2025 13:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PdV8uO80/mflHpZW6Zmyg39cv5SMy1ND2QAP2t8eHzY=; b=prEs2AZG6sM1zEGe
	VlkKyMnGGYxkLQMT3wdOmMthss1lBfNyEtDD15+kpRauYm9ctxxE1rtGyBG7Fv0f
	7mJCkiJOnbNqwy/6kx5b3EJw/fdr4USRKjSBQQZQ0jHR3qMi+DE0bCsRrQ4toQWM
	XQpE8v6IZupkHpPDe9Et6SnwT6edFLhvkgEDwG+tYmfYg686FX3HielgtSb5ymMw
	H/6iWbGkmnrSAkUBtyDQyIUB5N69MUsS4VuPSWbwetCUd2aJT9KZy84qdFiXZdPk
	mqWtVNNGCrWJyKA02Gb/R93mSzgTlfhvNmEC0JXDbA8nvT4pFil22EVufRp+SY2P
	LCv/Dw==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46pju7cgmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 13:44:32 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 54JDiVn1028686
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 13:44:31 GMT
Received: from [10.253.10.117] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 19 May
 2025 06:44:23 -0700
Message-ID: <1e3ba498-2bfb-4cab-ba13-5ab2c5b03ef9@quicinc.com>
Date: Mon, 19 May 2025 21:44:20 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v3 2/6] coccinelle: misc: Add field_modify script
To: Markus Elfring <Markus.Elfring@web.de>, <cocci@inria.fr>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        "Catalin
 Marinas" <catalin.marinas@arm.com>,
        Joey Gouly <joey.gouly@arm.com>,
        "Julia
 Lawall" <Julia.Lawall@inria.fr>, Marc Zyngier <maz@kernel.org>,
        Nicolas Palix
	<nicolas.palix@imag.fr>,
        Oliver Upton <oliver.upton@linux.dev>,
        "Rasmus
 Villemoes" <linux@rasmusvillemoes.dk>,
        Suzuki Poulouse
	<suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Yury Norov
	<yury.norov@gmail.com>,
        Zenghui Yu <yuzenghui@huawei.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Kiran
 Kumar C.S.K" <quic_kkumarcs@quicinc.com>,
        Lei Wei <quic_leiwei@quicinc.com>, Pavithra R <quic_pavir@quicinc.com>,
        Suruchi Agarwal
	<quic_suruchia@quicinc.com>,
        <quic_linchen@quicinc.com>
References: <20250417-field_modify-v3-0-6f7992aafcb7@quicinc.com>
 <20250417-field_modify-v3-2-6f7992aafcb7@quicinc.com>
 <a1be0efc-a4c9-461d-a01a-8fb830b2c68d@web.de>
 <0ee48e2f-58db-49b0-b651-dcc0e517465e@quicinc.com>
 <43712874-6f1d-435c-98b2-30ac44d25309@web.de>
Content-Language: en-US
From: Luo Jie <quic_luoj@quicinc.com>
In-Reply-To: <43712874-6f1d-435c-98b2-30ac44d25309@web.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=XKEwSRhE c=1 sm=1 tr=0 ts=682b35c0 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=NEAV23lmAAAA:8
 a=c3S3xlzBOW1yjAwqZsgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DDx5Kpyrf6pBeNUIV-O76BAavKioXic-
X-Proofpoint-GUID: DDx5Kpyrf6pBeNUIV-O76BAavKioXic-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEyNyBTYWx0ZWRfX8LBxompbvgoH
 3i7uWyfrxx5T3Tfgsvy7ubiVJ6v1qhIGwf4jf/Xj3Xy1N8bv6dH9EU/v4+YK8hk3EOZKpGwsXpO
 zKPXnFqYrqWOXyiJzvXGm6Lg+ocGxkUpkTDXJZ/O5AXvVsS8FpVHPcnvp90SgtTIkcdhMEupjQ2
 uOj/n9xXrmiGEGLnLbuK3/1L9NHPSOpmoaK3yrzHw6a5A4PoIXXRCzpq8QAa9ZmTuW4GdgZaAci
 EHCwTjF+Lk7iDIzSmtS2qgKhzHtqhTC9bWvgCDe3sDRnz3V+dDqppGyupxR8VK2WXx2IejHyv8w
 JFBhRBjRDa880TK7422aleYlIMa6BgheyGcrQ8t5EswA8UqaJ1amugbbjV7lOzAkyz96FklOAvx
 XIva8OfJHDHpw248ZP7AXaRVN54826XqkLx8ayhxETvYMM/RYgIieue2XoBPYKPK+9fivQ+l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505070000 definitions=main-2505190127



On 4/24/2025 12:35 AM, Markus Elfring wrote:
> …
>>> -reg &= ~mask;
>>> -reg |= FIELD_PREP
>>> +       FIELD_MODIFY
>>>                     (mask,
>>> +                  &reg,
>>>                      val
>>>                     );
> …
>> With this code variant, there is no space prior to &reg, here is the
>> example code changes generated by the SmPL code as below, is this expected?
> …
>> +++ b/drivers/phy/starfive/phy-jh7110-dphy-tx.c
>> @@ -244,8 +244,7 @@ static int stf_dphy_configure(struct phy
>>          i = stf_dphy_get_config_index(bitrate);
>>
>>          tmp = readl(dphy->topsys + STF_DPHY_APBIFSAIF_SYSCFG(100));
>> -       tmp &= ~STF_DPHY_REFCLK_IN_SEL;
>> -       tmp |= FIELD_PREP(STF_DPHY_REFCLK_IN_SEL, STF_DPHY_REFCLK_12M);
>> +       FIELD_MODIFY(STF_DPHY_REFCLK_IN_SEL,&tmp, STF_DPHY_REFCLK_12M);
>>          writel(tmp, dphy->topsys + STF_DPHY_APBIFSAIF_SYSCFG(100));
> 
> The Coccinelle software is still evolving somehow.
> Thus your test result can trigger further development considerations.
> I hope that clarifications and corresponding improvements can be achieved
> also according to such source code layout concerns.
> 
> Regards,
> Markus

OK, understand. I will keep the original patch as below for now, as we
need to ensure the script generates code with the expected style.
+- reg &= ~mask;
+- reg |= FIELD_PREP(mask, val);
++ FIELD_MODIFY(mask, &reg, val);

In addition, below case is filed to request this improvement on the
coccinelle project.
https://github.com/coccinelle/coccinelle/issues/397

Thanks.
