Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F45D3074AF
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832850; cv=none; b=EX0ci14aMKa/A6+jpW8Z0Lfpeh8Z+BsDUQq0XaO4Yo3PZ2kJT7yDn0IPH08EXDch9zMUQ6jx7zx8xAES6AaXGKHfN46Q7oRiT3FwmFHgVtZtddGqsqj3y5ibtTTbM6ZVtXMsKRkH/FFufXOoMnBz5gvygPm6lGzMegHFm3Gq78Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832850; c=relaxed/simple;
	bh=nMHX+d333D5HPC8QcZ9mPWtUcYmnNGg92MSLZoyFgLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XBL9xUs/AgylnxE1+tWlNHP2Ie6NAAIPJpaoY/0prBrBqTJ9CG2kHAo3Od2kf5sXeyBUhp7RQEnGeJdaBzMGCPznJh9Edh4DzVU1ejQJ7smbKKSGyZ5zLFzNEDg6JOS93gu0JQSb/r9p3K2kqB71cPlNs1Dhjo1i0ppwMMMZaqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ewryUBMr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ewryUBMr"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55P54UMR022368;
	Wed, 25 Jun 2025 06:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hWkTTuqHbYqzXcJMzG5QmoHMtY37J1sZaXArJ5+zQbQ=; b=ewryUBMr41b8wis0
	JUGp5bkxXfHVgvuNAXeG5E3tDLAjTJPPk1poloH0CtbO4Vhhw2LXAk1/8P5iLvd+
	qiXSG4CxbZDpRqOB9aIsaa9QQScCEZldf9TmPcBhWu3e6eoHOx15dYtgIjNah41p
	xFuPpj7oCdncksgDZ4ES1v5xEBC/q/I+KaewcdPqd0RVQOJAzpfXC83orBnXmmld
	3cdiwaGPqcD9iS3C1c2cHHIzbPHcZJp/V8Cu6PGfZt4dBfY2qw5DjINImJH1ZSe3
	XYW1q2bB23nQ7P6NHqtnZqGURHSVF6vC2UqXkJ8EHHAnqmqLkD3bH3WR8pJewF5O
	RlCyew==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47f4b3xjnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 06:27:00 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 55P6Qxaj001894
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 06:26:59 GMT
Received: from [10.253.38.60] (10.80.80.8) by nasanex01b.na.qualcomm.com
 (10.46.141.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 24 Jun
 2025 23:26:55 -0700
Message-ID: <1e5c1c96-b76c-4e2a-ba50-f914e94b142d@quicinc.com>
Date: Wed, 25 Jun 2025 14:26:52 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] coccinelle: misc: Add field_modify script
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
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.linux.dev>, Andrew Lunn <andrew@lunn.ch>,
        Kiran Kumar C.S.K
	<quic_kkumarcs@quicinc.com>,
        Lei Wei <quic_leiwei@quicinc.com>,
        Pavithra R
	<quic_pavir@quicinc.com>,
        Suruchi Agarwal <quic_suruchia@quicinc.com>,
        <quic_linchen@quicinc.com>
References: <20250624-field_modify-v5-1-cd67127030e4@quicinc.com>
 <e694666a-ec94-4443-bae7-54ac2f0f0e7d@web.de>
Content-Language: en-US
From: Luo Jie <quic_luoj@quicinc.com>
In-Reply-To: <e694666a-ec94-4443-bae7-54ac2f0f0e7d@web.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDA0NiBTYWx0ZWRfXxvGrjqZaaCR0
 1FQqKirKVGGm1IX0qm8OajLNKgxIEJ6URBp/iN6OGEnJjPzKB4hpBVETvsflTkU4JnqfaN2bwpf
 QJVYLvrgWve4WgVNKFNC0yKRGaP/GbweIsQd9xIusf3EopsdyMPTQDnJxq3tKvRKRP/KQFxv1ft
 ocds7daSscOAIPdz+mtv5Jo5BK9P3I7d0RvMzQnHYBo3oOccKXN+Q3fqddizJBICuYBcuscfcyt
 Vf6+KTQbF9WqqFRE3W68tLPIxnvCqpjnEri0taBHbVQNMBkYygMKfmcF+Ws9CO/QVY+2/P+QT0O
 XH3LgbWMafY0gXIZxvjuZKMBL8YqIboMo6A0+DKDo0NY+WS8m+Vb2B1hb5Rj9Pe31Ejcb/oCr08
 S1pheYi+WyVoEK3+Ha3RTV4f0JwGp8i8Wjk8or7HTtNXAz4UGyn9MkEtWII65xl8vHqRuwuR
X-Proofpoint-ORIG-GUID: W2qJRLW0W0B1hDpsCof4incN1KLYlAeb
X-Proofpoint-GUID: W2qJRLW0W0B1hDpsCof4incN1KLYlAeb
X-Authority-Analysis: v=2.4 cv=A8BsP7WG c=1 sm=1 tr=0 ts=685b96b4 cx=c_pps
 a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=05oQ047nAAAA:8
 a=kZqaHTt7WJRbN11SuRcA:9 a=QEXdDO2ut3YA:10 a=vNAg3JWiabyzeNEprMgK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_01,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2506250046



On 6/24/2025 9:54 PM, Markus Elfring wrote:
>> +msg="WARNING: Consider using FIELD_MODIFY helper on %s" % (x)
>> +msg_safe=msg.replace("[","@(").replace("]",")")
>> +coccilib.org.print_todo(p[0], msg_safe)
> 
> How do you think about to use the following code variant instead?
> 
> msg = f"WARNING: Consider using FIELD_MODIFY helper on {x}"
> coccilib.org.print_todo(p[0], msg.replace("[","@(").replace("]",")"))
> 

I think your proposed variant is a better alternative. I will adopt
it in the next revision. Thanks.

> 
> Regards,
> Markus

