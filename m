Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C947C8836
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 01:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713923696; cv=none; b=PTZ6of0v3B7o8DlZtTe0IL1XQZtDihPrlUap+Es170MOII/81CvuZraUi5EosyRzro7wKQrlaLttfQBbF9KB3K00zCfsNEotQh4q7ZR3JTQ66ziKlcsUOYbkhJJTnlu6r/zkHMmZSpaQF/SbjvGwwFjnH0EYHSspRoYrFHsUoJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713923696; c=relaxed/simple;
	bh=IJ51eedoyRVCcsH8Q1yxHeiSRcUiTyHiZGmLfnwWE+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Xdauq554JF8VnBuPs8jdHrPNAS5vmAG/BX2x0m207vpaJ/+KYK/DhNhGdlDqiEOSr2bPz334F2q7tKqbu2YBdmOmvsjcCJFrTU/gV2FrELpP+wzxhJeHMWfFDyBj4VPyPF1x0HP8ui4nXcDfz7cf3RFdDugraxBot3Kzs6jcxfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=Vmgf6BQ0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Vmgf6BQ0"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43O1ii3w028864;
	Wed, 24 Apr 2024 01:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=0ISaXgWhWlHZSt+CjOAAt1Ge/5goH3t3s4vIePpX2Aw=; b=Vm
	gf6BQ0soxWtrqeaFy12XJ5iCTFjGDgUxU7KMyKsHxKBA25IPw3LqKCO5R607Soxb
	6wj6FPUYCD8oTRDjX3+5KWXN9S+wjscfEEjOdd52/wBAly2UuOrfzZT7L8GBK+Nr
	n/+JLKJcX9u3HU1PnfkCmx3V8sxgjNxj5oqZ7ijcGrfwHc6LPduEjgrUaVkPZHVa
	QIVSz9nolm3oVqovcc43cvmoolY1OsBYVVrH7W3pXRmQ8MPoM90H0MgZ7owXaUSQ
	Ac0E5n6AAQRBr3G3brrZIj0AgNO7PIfIguwcdznRGviFVgHubEpLaeJWiqynz6we
	Yx3848A72EyzEHHudTrw==
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3xp9aa2wct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 01:54:11 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 43O1sAOt029221
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 01:54:10 GMT
Received: from [10.239.132.150] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 23 Apr
 2024 18:54:07 -0700
Message-ID: <71adaafe-5075-4508-b9a6-f009531cf99b@quicinc.com>
Date: Wed, 24 Apr 2024 09:54:05 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old
 toolchains
To: Marc Zyngier <maz@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        James
 Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, Will
 Deacon <will@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Linaro
 Kernel Functional Testing <lkft@linaro.org>
References: <20240422224849.2238222-1-maz@kernel.org>
 <fa6c31c5-9334-4248-aa89-a0951f1b13c6@app.fastmail.com>
 <0b970cf5-a880-469c-93ab-9a268ee4ea2b@quicinc.com>
 <87o7a0tha6.wl-maz@kernel.org>
 <a495bc0d-ff35-46fc-842b-368ce59a88c1@app.fastmail.com>
 <86le54qclu.wl-maz@kernel.org>
From: "Aiqun Yu (Maria)" <quic_aiquny@quicinc.com>
Content-Language: en-US
In-Reply-To: <86le54qclu.wl-maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Q6NWbo3MsEFIVcqEUMGAMtCUPZOElrtt
X-Proofpoint-ORIG-GUID: Q6NWbo3MsEFIVcqEUMGAMtCUPZOElrtt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-23_20,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 bulkscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2404010003
 definitions=main-2404240008



On 4/24/2024 12:15 AM, Marc Zyngier wrote:
> On Tue, 23 Apr 2024 13:37:09 +0100,
> "Arnd Bergmann" <arnd@arndb.de> wrote:
>>
>> On Tue, Apr 23, 2024, at 14:06, Marc Zyngier wrote:
>>> On Tue, 23 Apr 2024 13:00:55 +0100,
>>> "Aiqun Yu (Maria)" <quic_aiquny@quicinc.com> wrote:
>>>> On 4/23/2024 4:24 PM, Arnd Bergmann wrote:
>>>>> On Tue, Apr 23, 2024, at 00:48, Marc Zyngier wrote:
>>>>>> We still support GCC 8.x, and it appears that this toolchain
>>>>>> does not understand "pauth" as a valid architectural extension.
>>>>>> After all, it's only been 8 years since ARMv8.3 was released...
>>>>>
>>>>> Just to clarify: I'm fairly sure that all supported toolchains
>>>>> support ARMv8.3 and PACGA, the problem with ".arch_extension pauth\n"
>>>>> seems to be that it was retroactively made an optional
>>>>> feature for earlier architecture versions a few years after
>>>>> ARMv8.3, so most binutils versions we support understand
>>>>> pacga as an armv8.3 feature but reject the pauth name for the
>>>>> extension.
>>>> Kind of agree with Arnd here.
>>>> Shall the fix just remove the ".arch_extension pauth"?
>>>>
>>>> I've tried gcc 7 failed with the pauth name for the extension.
>>>> After I remove the ".arch_extension pauth" and use "pacga" instruction
>>>> directly pass the gcc 7 compilation.
>>
>> It really depends on the binutils version, not gcc of course.
> 
> Right. I'll amend the commit message to reflect that.
> 
>>
>>> And breaks with LLVM:
>>>
>>>   CC      arch/arm64/kvm/pauth.o
>>> arch/arm64/kvm/pauth.c:40:9: error: instruction requires: pauth
>>>                      "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
>>>                       ^
>>> <inline asm>:2:1: note: instantiated into assembly here
>>> pacga x19, x1, x9
>>> ^
>>
>> It works when building with LLVM_IAS=0, which we obviously don't
>> want to mandate here. The variant below works for both clang+ias
>> (including all still supported versions) and gcc+binutils, but at
>> that point it gets obscure enough that your .inst version is easier
>> to understand.
> 
> Exactly. Either we have a good way to abstract this behind the scenes
> (which I don't see right now), or we just assume control of the
> instruction generation, which is what my patch does.
Ack.
> 
> In general, I question the value of the ".arch_extension" requirement
> for something like Linux, where we already have a pretty fine grained
> control of what we want to see being output by the compiler. but that
> ship has sailed long ago.
> 
> Thanks,
> 
> 	M.
> 
>>
>>     arnd
>>
>> --- a/arch/arm64/kvm/pauth.c
>> +++ b/arch/arm64/kvm/pauth.c
>> @@ -36,7 +36,12 @@ static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
>>         __ptrauth_key_install_nosync(APGA, ikey);
>>         isb();
>>  
>> -       asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
>> +       asm volatile(ARM64_ASM_PREAMBLE
>> +#ifdef CONFIG_AS_IS_LLVM
>> +                    ".arch_extension pauth\n"
>> +#else
>> +                    ".arch armv8.3-a\n"
>> +#endif
>>                      "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
>>         isb();
>>  
>>
> 

-- 
Thx and BRs,
Aiqun(Maria) Yu
