Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4792784052
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 12:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713873743; cv=none; b=UN/mSZK4d56AOxBMIsmvytEslnE2Nm4jjboF/fR5TTWSbk7aRdcSyTOWCLlKj+adof2R3Sb0SBs/+AnAu9MAJgTK5NwMoDq0WhVY5kibvmkOq6T26ykSJavfqyLhE2tAxIt4qG9WS6/6mGsbHrESGh1Cpku37Ygc1Ut8KehNTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713873743; c=relaxed/simple;
	bh=ix8m48bfDGfjre7jlUCapS4rl64abaDpRtFjZGN6h0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=K/5VPORFhV6n7Tr/LpW1cfVJl6lGJqayFOfpk/++t+rmsMwck9WBzn/e6ORR7rRMFgrCWA2ifKNTnHGjSwW+25bPfAA39B4Ki617keV3jN3NQC5Zr8JZanGOsH3KnSbV58rpNt54fybSZvLqeswrhkd5l2L50MLEPGVf3gDJlmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=XjYZsWWP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="XjYZsWWP"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43N7uMFp019461;
	Tue, 23 Apr 2024 12:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=fi2lmleRd690v3hCdlvKA9XcNylnspGVxVWKuGObdeo=; b=Xj
	YZsWWPzYZ7wIODrT5cEdl53zHAcY4KqggV90FY09DNHzniKsgiXvRRcBvOoCf35B
	IqP0SkLIZLUBMHdR8NxAo8sSXIKrvcw12YtQ9Lf/cXmIXoVP/8EGdXkPsvADf4QN
	jRUGjuaffBlVMEh2rp/xdlecfF3iZ0QrpIDnr42GzZ/cK0E2dH7mRR678k6etheW
	4ZWBcCdQYARZuQmkjuBxCGdObTKDqG7fh3kYq33MTte5JGhCOkjQ7YSuibwa8amO
	rAJFxETPmiEl3OEd5AmjR4p1AVngjpzTFyMEjAo/u7md1pqeMAI8QGBl1g5l/J7l
	dzTXO/xD0rCI7xq57lMQ==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xp91rrkxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 12:01:01 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 43NC10JS007750
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 12:01:00 GMT
Received: from [10.239.132.150] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 23 Apr
 2024 05:00:57 -0700
Message-ID: <0b970cf5-a880-469c-93ab-9a268ee4ea2b@quicinc.com>
Date: Tue, 23 Apr 2024 20:00:55 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old
 toolchains
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>,
        <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
CC: James Morse <james.morse@arm.com>,
        Suzuki K Poulose
	<suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu
	<yuzenghui@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>, Joey Gouly
	<joey.gouly@arm.com>,
        Will Deacon <will@kernel.org>,
        Naresh Kamboju
	<naresh.kamboju@linaro.org>,
        Linaro Kernel Functional Testing
	<lkft@linaro.org>
References: <20240422224849.2238222-1-maz@kernel.org>
 <fa6c31c5-9334-4248-aa89-a0951f1b13c6@app.fastmail.com>
From: "Aiqun Yu (Maria)" <quic_aiquny@quicinc.com>
Content-Language: en-US
In-Reply-To: <fa6c31c5-9334-4248-aa89-a0951f1b13c6@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: BhKn0f0MysDdQRCdw6W7E_FxVpCgnzSU
X-Proofpoint-ORIG-GUID: BhKn0f0MysDdQRCdw6W7E_FxVpCgnzSU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_09,2024-04-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2404010003 definitions=main-2404230031



On 4/23/2024 4:24 PM, Arnd Bergmann wrote:
> On Tue, Apr 23, 2024, at 00:48, Marc Zyngier wrote:
>> We still support GCC 8.x, and it appears that this toolchain
>> does not understand "pauth" as a valid architectural extension.
>> After all, it's only been 8 years since ARMv8.3 was released...
> 
> Just to clarify: I'm fairly sure that all supported toolchains
> support ARMv8.3 and PACGA, the problem with ".arch_extension pauth\n"
> seems to be that it was retroactively made an optional
> feature for earlier architecture versions a few years after
> ARMv8.3, so most binutils versions we support understand
> pacga as an armv8.3 feature but reject the pauth name for the
> extension.
Kind of agree with Arnd here.
Shall the fix just remove the ".arch_extension pauth"?

I've tried gcc 7 failed with the pauth name for the extension.
After I remove the ".arch_extension pauth" and use "pacga" instruction
directly pass the gcc 7 compilation.

By the way, have a glance for gcc7/8/9/10 manual, from the gcc 10 manual
[1], seems gcc 10 was the first introduced the pauth as the extension
name support.
https://gcc.gnu.org/onlinedocs/gcc-10.5.0/gcc/AArch64-Options.html#g_t-march-and--mcpu-Feature-Modifiers
> 
>> This results in the NV ERETAx code breaking the build, as it relies
>> on this extention to make use of the PACGA instruction.
>>
>> Work around it by hand-assembling the instruction using a mind-bending
>> trick lifted from an old patch by Will. Magic.
>>
>> Fixes: e09faab353a6 ("KVM: arm64: nv: Add emulation for ERETAx instructions")
>> Reported-by: Linaro Kernel Functional Testing <lkft@linaro.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> I usually try to enclose these in a version check like
> "#if CONFIG_AS_VERSION >= 22800" so we can be sure we clean them up
> whenever the minimum version changes, but I assume you'll remember
> this one.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Thx and BRs,
Aiqun(Maria) Yu
