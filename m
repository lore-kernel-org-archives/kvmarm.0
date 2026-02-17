Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C863254A8
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 10:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771324998; cv=none; b=R9AwsG8Yomi5pdvbyrOoaXdK0/frZJxECclQxOl2vykf9stsq00Aogky33mymtLer3bqQxGfBlmktucTuELKzrrR/dWh0sSBpQ44+Spa68iKo/1VSNflYZWCSEwNSybJ0MurcPszI0ajdqHSkHbqHhO8vrCweskZx5TF87nCyRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771324998; c=relaxed/simple;
	bh=dORgjL9wixuOF2FKQTPZqZXz0qsBa0bANzNtXUEZGMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmH2dz9oW8kMagioaHsq3Qhp13Zn1rB1YM+rtD4zxVMn1BDknMdcJ19gkdZq53nuK3zi0nvudlXiFDYVRHQCXr1B6Bu+I4r9NH4j4nGMhasTxRATFfvu04UrLR8zgoQDxKiDpI8wanquOxAgl4ZKFZOrntzUQ/Bm6bNPJYz5mwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EE+UoIXh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dXhVteR5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EE+UoIXh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dXhVteR5"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61H54d5M2111841
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 10:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	V+/JvRtAe7W6SXMnT8BD5ObjmKH2oFAc1EBFvqqazsk=; b=EE+UoIXh2LMx+AJB
	glmDwFL4ppO8lSmJTteK2V7bWWKkOVkrg+d8AnZhtvO7eXeDcJQlxXjMqSl99NVV
	mj6I+TTUewbk851LVzDdc2E5qdBkoqFrJ5RmO9kA5wn9s9efGSGUNV+9y6EbU9PD
	GRKP6CrAPr2TfCZQ0hdwI7GipWb9UmxvEwyAZ+uPnKtJdWHBpo0WAHyM4hS/wCn/
	FSvbYZQg4vyQtfDXDbls13cy3Fk1bIQnoGs6HPG5JJSx7NI0Hox47aKeCGjqSOwA
	HJ/LRwOq5dIse8iwImMwR5WgLMy71iTrnWq5bjTG1bxq4Dl3tl/eUPIrKeiPm4S0
	P0o2xg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cchv4gqf0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 10:43:16 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aaeafeadbcso47894995ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Feb 2026 02:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771324996; x=1771929796; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V+/JvRtAe7W6SXMnT8BD5ObjmKH2oFAc1EBFvqqazsk=;
        b=dXhVteR5c3WckjGFGcx7XcBIkrf3wZVxMUoFYa3pwiub88WydsQuGUY/xh/oyV6oEB
         vqely74Y4XUq03R0/GwL8pAW7Ez+jd9hJJqRORAdOcWPfyfOw6PzmRIKT9EfLLANrJNJ
         rSyNX9rke5RDpu+9RocCp5wyC5hQOQoYQhr75JyvpJ3iJPMp4z07p5D31S6weCA52fGq
         VUzqbL3GWbc6LyxoLb+7Qw0cjxEn6/3BjjFU+WbzQFAy5uRdETeVHcvIM+4AcMk52j6u
         7XkLweZH+ZNNiAEBKqmZRZyOJq8LqPoaQnwdMwwesB+AMoCb+EE0QBDGggqDRV/Fm1ak
         AekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771324996; x=1771929796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V+/JvRtAe7W6SXMnT8BD5ObjmKH2oFAc1EBFvqqazsk=;
        b=Z+b7L1E3P38sDb2L/CyWcHnPTizry8KxIy2avrtB29PbLKxi8nBB4JMxUOzhopxAPp
         E+rAE9l9yoOiEEeBx/zSqosEJfNw+giyL6j026bjTY/ZPsMsOvLDVzdohny1cbAK1bQF
         7hD2qHD4McAFJY4pmBNkZj3OWs6vd4kgziDKmNHvLWomNnwTWTXl5sazpKP328hnX2XW
         J07L4yp89LDFgVW3v5a9/wLrygnD+GKHGqkcLIXUvZPFNH41PsONvWLa/rQMoctPPw2S
         nmikH2iqYLaSUZf7dcQCmfWXBbgPYPnOcFoIf8MIBPyWj87tBYqYfCtBb4Q3G7fkUAld
         pjaw==
X-Forwarded-Encrypted: i=1; AJvYcCXbMWLkN3l0ULyaNffD3LvRApTGMpFmPXBkYjOjEmLJx6T2CVhLBfeCNdcZ7ARobTZNhpwx468=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyUGQLjo/zAcM7MhNZSDY3Ay2zfeOKvuynG7eVFYu3O2ySo9Zq
	zmQfGmFJMIDPrA+6tR404ShyBT1tM4XAmXBEKACIkgEzaHjmR6sfiT8Bile5INUrlofXeny/f6J
	Z7GShCyuJ9c8HKX8jwxC6dGPtnUG7+SRAp/b9XwVSeRqrXxe7BLfF+9O7iOM=
X-Gm-Gg: AZuq6aLOCpz4MtC72NSu8Twb46k3j7NnfsV6ASzNhaS8++SH1wX19SNe5BWeYrCuciX
	ECazYtLAlZ+sBiMjNKLEpzR+svykRMxk7PMEZYNxl1fhjccMWsjaOOt44twGhtZS2wWEmp5sVkq
	iOnd89LLDIa2ncymz4JV0sEshrXc4HubakImQINxs4zHsGBU94e82PdW211lxycFudc7Rg7dKnt
	gi/756Rg3AZXzuV1WGm5JMIvaqewekZF2UYggMoNMYMaTlFyMcOpbt1SL4S2m0CB+L3e0U/qrTG
	UlrD7FQZZAGvSSAfq8UZ+2dh9FiXgu7tUrcdfQw9frongckyjqtaVC6f4lGfaL+G52HkdHcn0Pi
	smsArre6EI40SCRj2tNkYIlWUQ09gfamZBxb4t3aTsD/jwx/kg4y52kEZjzW8ZlXSgZZepTREjt
	KaKjjAyvr/J8Jols0woYvZm+d5sBiwpIHILVCEzZVRhg==
X-Received: by 2002:a17:903:3d0b:b0:2a7:a9e4:babc with SMTP id d9443c01a7336-2ab50647207mr149474865ad.61.1771324995730;
        Tue, 17 Feb 2026 02:43:15 -0800 (PST)
X-Received: by 2002:a17:903:3d0b:b0:2a7:a9e4:babc with SMTP id d9443c01a7336-2ab50647207mr149474455ad.61.1771324995265;
        Tue, 17 Feb 2026 02:43:15 -0800 (PST)
Received: from [10.79.196.238] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6fa21dsm94508805ad.12.2026.02.17.02.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 02:43:14 -0800 (PST)
Message-ID: <237a1d5c-46a3-4459-b0d5-21fe2cb57a83@oss.qualcomm.com>
Date: Tue, 17 Feb 2026 16:13:09 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/35] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Fuad Tabba <tabba@google.com>
Cc: Trilok Soni <trilokkumar.soni@oss.qualcomm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mostafa Saleh <smostafa@google.com>
References: <20260119124629.2563-1-will@kernel.org>
 <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
 <d2303150-5692-479e-9a56-11a52ba58c2b@oss.qualcomm.com>
 <CA+EHjTycHq7WkOfD7d+1-9A7HOAkGzBTmEm-6DB8Y0TNq-Aftg@mail.gmail.com>
Content-Language: en-US
From: Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>
In-Reply-To: <CA+EHjTycHq7WkOfD7d+1-9A7HOAkGzBTmEm-6DB8Y0TNq-Aftg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=eYAwvrEH c=1 sm=1 tr=0 ts=69944644 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=jh8-4IubPDD_rd732qoA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDA4OSBTYWx0ZWRfXxu4EqRzTaARm
 FzqndCYpDSvnJRQMXhtKiJLxQvc8zHc7XjRfM/aR5+TsD49I/CZ23gBLLicSvT4k2NfABmU/BVP
 Ez25KYEE4043sYT6IITXB9i7ieCAC1hfGlFbJsnMblBDQN6z53zCM2rJUHBW0LyDFYr0UVGAbqp
 A+0ApUQXTt9Y5pRDi1HYXYsIV8D8vhZWo3VJKFOaCUAY5b4B5hPtd4jJeQJVsTRGiXXN+5iI0gf
 EVziF6emKDQqXYZN5pCpJmykqtuQ5znTS9qio/UStwZqGXSZHkhJJPgcBSElTrbRO7kUGfu8LVa
 Z1uLzvj7k4iAPnZipzRiIicr/9WFNhwo3oaP7p5gl+VQ9LxhzDpfnNiGh377FLdNJshH0Prej18
 TUtepq3lhWUsjdn2Zvzfw63+qQCZFTkiI4UAHTIxlSl98wIvEhbE59QymxgTAHwtUj4sTfD4Ili
 xKRfA9y95+dWAru434w==
X-Proofpoint-GUID: BZtCiOKAC1UTjrVpSViVdyMtuLAHcsT9
X-Proofpoint-ORIG-GUID: BZtCiOKAC1UTjrVpSViVdyMtuLAHcsT9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170089

Thanks Faud, it worked.

On 2/16/2026 4:30 PM, Fuad Tabba wrote:
> Hi Venkata,
> 
> On Mon, 16 Feb 2026 at 10:58, Venkata Rao Kakani
> <venkata.kakani@oss.qualcomm.com> wrote:
>>
>> HI Faud/will,
>>
>> Can you please share tip of your commits to apply the patch series cleanly?
>>
>> I could not apply on tip of master branch.
> 
> The link Will provided in the cover letter above didn't work for you?
> 
>> As before, patches are based on v6.19-rc4 and are also available at:
> 
>>   https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=kvm/protected-memory
> 
> I just tested it, and it seems to be fine, based on Linux 6.19-rc4.
> 
> Cheers,
> /fuad
> 
>> Thanks - Venkat
>>
>>
>>
>> On 2/11/2026 12:28 AM, Trilok Soni wrote:
>>> On 1/19/2026 4:45 AM, Will Deacon wrote:
>>>> Hi folks,
>>>>
>>>> It's back and it's even bigger than before!
>>>>
>>>> Although the first patch has been picked up as a fix (thanks, Oliver),
>>>> review feedback has resulted in some additional patches being included
>>>> in the series. If you'd like to see the first version, it's available
>>>> here:
>>>
>>> Is it possible to test this patch series w/ the QEMU or it will require
>>> real SOC platform?
>>>
>>> ---Trilok Soni
>>>
>>

