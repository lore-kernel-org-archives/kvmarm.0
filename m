Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A2333F9
	for <kvmarm@lists.linux.dev>; Wed, 23 Apr 2025 13:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745413495; cv=none; b=uLBhYqs0Aq+/EMzZ+hgIjmOP+1K7Pl4N9WZluZ4T5uF9+uuygGtSf5WTnyWAaWJMqCCsfOafcBwyc9NNhlIOrblC5MZJcdlx2EYHNOJOQrPCh6RM8GC66hBJuYih2Th/mwQhP7LJEa7TP1RD5BG8ba8WM4WV530YJM2Ul09sCLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745413495; c=relaxed/simple;
	bh=Uy02wVdhD61fwpKCpvdDIBbR7OoR00YFzmhx9wQmIFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IaEib46v9gvkk1NgQCTNX1gVzSRT42AnsxTy5U2YLmw++Esp1PPxJ27kMazIJfW0Htwn0wDkQDBrNJxIqta8kJBT69F7szbph5Um93aK1vVbGEPEfW4p7T6JwWlnTsQlWeLFZz1VD3rerS2v3zwEZSZa1WVeCMrXnkLBXH00jvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=iahpS7n/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="iahpS7n/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NAIXvJ017291;
	Wed, 23 Apr 2025 13:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Phbedu7xpyuH5nYJsAMb3poKKBwNLxsZinqwYSuHzUE=; b=iahpS7n/F/bDarVN
	E3ZgF4vG03KNPbYQZbzTR7ZVrZ6f7spf+ve30cp9n1a94p3PuxUqi00n3y8lRvvI
	wYeT6TdPvqFQw/elaCyTxG2NvtzNFHv0dqQYUQ7cXRZGTkObQ48IsB+uRVNE4BU5
	GUPowKohVHSJ7erHRx5C6yCDdCjFfHNgdduSisW+buhWeTd/EoBg05mc7CZMJYsQ
	3Nde65fRdfjE+0C300JVsYGeCqGquQfr7QNCB/k95lIugHLJLRhDTN7ddoVKHqwk
	LebYGTZAj84zWJHKJ88R133kfCjcQEZzKNEwLLZMQ8FhtEKfnz/1iN44XnnNHCKb
	QqIohw==
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh3j5y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:04:29 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53ND4S04016458
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 13:04:28 GMT
Received: from [10.253.74.233] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Wed, 23 Apr
 2025 06:04:22 -0700
Message-ID: <0ee48e2f-58db-49b0-b651-dcc0e517465e@quicinc.com>
Date: Wed, 23 Apr 2025 21:04:19 +0800
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
Content-Language: en-US
From: Jie Luo <quic_luoj@quicinc.com>
In-Reply-To: <a1be0efc-a4c9-461d-a01a-8fb830b2c68d@web.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: d1C-_VtA2se0ltPj1-LpCYtqKYl_3Kko
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA5MSBTYWx0ZWRfX2HoPaNVS9Rs7 skvMbPo1O3/lDaMF3Rx3zRJoaEiSWBgzeVDMxsZJJO2e9jxt8qfRvlI5KD8g0tcaAR5W59oIxT+ HbBNVqMHeINLSNyJEZrhMSINbaakgbrmZ0ZiDWmSNbyHPI+R2LL38UK371n8IX1nZ6zOg0ZrD+I
 qh7h1Y/9oTycKb5NEkF7+MN42ZHOBl0ZLWDEXlfTm4PK2nG48KB76GjHDlzt4mph4wRmXS4D5+4 DNajvL7sbg8WYHwyZ/Eo3L8lzNDzj2dMZFcnpW+ZPWPJ15WlnizmFQKiI1TItPgf57CKGuKUy/5 JP1wSn2OXVEeDpkISxi9dbaxR9IVqixTVflxlExmCrIw93KqGsirZTE/jH8XwEkdbxTJcT9YjLR
 Fs4Cq/DHFYwvzw6HgDHY4XwnEp7yE8FJZj912d+vyIMPObrHmV3lzNcAIIouzKAnJlaIxQKN
X-Authority-Analysis: v=2.4 cv=ELgG00ZC c=1 sm=1 tr=0 ts=6808e55d cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=ZOzjf2MOAAAA:8 a=Tm5InjWKXzpK7Ii0gWsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1Mhi-5-LkjG4w5oc0yAU:22
X-Proofpoint-GUID: d1C-_VtA2se0ltPj1-LpCYtqKYl_3Kko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_08,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230091



On 4/23/2025 7:01 PM, Markus Elfring wrote:
>> This script finds and suggests conversions of opencoded field
>> modify patterns with the wrapper FIELD_MODIFY() API defined in
>> include/linux/bitfield.h for better readability.
> 
> See also:
> https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.15-rc3#n94

OK, I will update the commit message with the imperative mood.

> 
> 
> …
>> +++ b/scripts/coccinelle/misc/field_modify.cocci
>> @@ -0,0 +1,24 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +///
> 
> I suggest to omit a blank comment line here.

OK.

> 
> 
>> +/// Replaced below code with the wrapper FIELD_MODIFY(MASK, &reg, val)
> 
> Replace?

I will correct it.

> 
> 
> …
>> +// Copyright (C) 2025 Qualcomm Innovation Center, Inc.
> 
> Copyright: ?

I will fix it.

> 
> 
>> +// URL: https://coccinelle.gitlabpages.inria.fr/website
> 
> I suggest to omit such information here.

OK.

> 
> 
> …
>> +virtual patch
> 
> How do you think about to support additional operation modes?

Sure, I will update the patch to support other operation modes.

> 
> 
> …
>> +- reg &= ~mask;
>> +- reg |= FIELD_PREP(mask, val);
>> ++ FIELD_MODIFY(mask, &reg, val);
> 
> Would you like to integrate the following SmPL code variant?
> 
> -reg &= ~mask;
> -reg |= FIELD_PREP
> +       FIELD_MODIFY
>                    (mask,
> +                  &reg,
>                     val
>                    );
> 
> 
> Regards,
> Markus
> 

With this code variant, there is no space prior to &reg, here is the
example code changes generated by the SmPL code as below, is this
expected?

Thanks for the review comments.

--- a/drivers/phy/starfive/phy-jh7110-dphy-tx.c
+++ b/drivers/phy/starfive/phy-jh7110-dphy-tx.c
@@ -244,8 +244,7 @@ static int stf_dphy_configure(struct phy
         i = stf_dphy_get_config_index(bitrate);

         tmp = readl(dphy->topsys + STF_DPHY_APBIFSAIF_SYSCFG(100));
-       tmp &= ~STF_DPHY_REFCLK_IN_SEL;
-       tmp |= FIELD_PREP(STF_DPHY_REFCLK_IN_SEL, STF_DPHY_REFCLK_12M);
+       FIELD_MODIFY(STF_DPHY_REFCLK_IN_SEL,&tmp, STF_DPHY_REFCLK_12M);
         writel(tmp, dphy->topsys + STF_DPHY_APBIFSAIF_SYSCFG(100));

