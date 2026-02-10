Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B51E3254AC
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 18:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770749901; cv=none; b=phGakznm7Vp7QZnUbCQv0Su1lGxQTyRkSIssNxtdArD8kcptn4fPjqCfYCzdsPdHZ5pPCnV1Q4E8LZ++Eo71/bB3GobWdB0VsZdSwbzc0cbhrDoOKyziQPoOwP6id5UkNYEY0Wjx60q3ZlWO5vtmKVT4me06HjhOjByiuB4KOKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770749901; c=relaxed/simple;
	bh=vXJFED48AEYUv5Qr9XiM2EkI8I9AqVF3E7+xlXIpdqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DWTPs8RpJYfEhcvm/JL0tc/0BLfsNyssgE6tKl1imhligyHyoEFM01ipPjfvkQ5UeMffUkZANiYrMg2dztxOtza6O/ORRK+wddKssparCwpsBTsQrEvnQ+FLU+nG/Uv6BrKvGDGTzBkYhz/5C2jDZdfgztY06c1IeMMLM9/IsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bbBsxj8d; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RS277EYs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bbBsxj8d";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RS277EYs"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AFJg5V2823173
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 18:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JKIUStnyR1RHKjtab0jKusCwDIO6oXe4Ewa6kn0Y0TY=; b=bbBsxj8dml/vd+UA
	n+VCNCAU/5ceLksVgXSXee1tqX+4HAtTaa4wpN8p+FO45hRbf3K6dy6S787gRL8M
	PkkUMqBYk6Oqvp/Q/u56zytBYAE5kGaCSsjjwp8x/tJ3leZqR75DyXhWmzk7ulf+
	R0C3vTTKwEyPPhoX0KTD2iNgWnosLmWbrhCcTpF4Ot+lCQ/ziNLPpZFiSMT8e/os
	ed8CuU4oHD7+svfCNqqXCsu0JNJ3vYk1MXwnopzXJcVjMBsb2XWqR0TDBtzjTT85
	np1lUY2twt8Hk9GxsVIJLk6xCGty2+MEJn69UYclz3cDrwHnAL1QLAg/WZIHcybf
	4Ew/DQ==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c877hgqnw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 18:58:14 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2ba6ad2ca1fso14252081eec.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 10:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770749893; x=1771354693; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKIUStnyR1RHKjtab0jKusCwDIO6oXe4Ewa6kn0Y0TY=;
        b=RS277EYszeAwRjkLUCTkU8B+VjJzzE7EnGYecrEc5nQQ5PeLAnHXEfLlHGova3fHpY
         V6basedwH9+6uzXIyZK3usmhAg3J/4S/0WGlDT7qxs7jFkA6J5VFl12q12D8VZJEuESY
         xq9GNFUpZZxspyAWLTf9kIR5JMTxZX8J8LYHOswFl+5uupuXGJh5e3aQYD7SRKxS6KJx
         +O4VXYqQsaDwfdKL1lwz6Sq+YMA7rtkrbJNIoB4Bek7s8ltm/E5NVRjAaUf3mJmaIASV
         5zRkQQxEy1+HRDUJJ3lR0a8g02qd6taP8IlkvmkKr5sshkqy5VTdd5iFOIf9H5ymm1fP
         vN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770749893; x=1771354693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JKIUStnyR1RHKjtab0jKusCwDIO6oXe4Ewa6kn0Y0TY=;
        b=FZka4cJHFA7cRfhZ5fui2Db+fWdKms6TdRBZk63HH5v2Kw+op8yzib3CCv7J2aDm7H
         5yDqxGtSDOvRIE3Hjdy5S2cHtysWcdKZTPSTspOACMwk92eAGonElFxHZcOXGI4x3Nej
         Jp06z4Ax9HiSSWfsm7//JSeK/DhWzXdmrPVpKkmfyZq3t3ynhYn7NNWjC41obfS8usJ5
         C4nh/Jh9ABxAAC+9aaLKW6s04VWfSoIFdrEeZ9hdjhq9udm5LRvCHupJuIu2QbzShBJC
         okt8m8oT0uc9im4wGI/CZCo4Lsf58RyUoofTe9rcrd+2Ql5c/ECawYtb6H9TpZS18alK
         JTVw==
X-Forwarded-Encrypted: i=1; AJvYcCVeqLur5CONjKB11U/nVpmaRZR4AHOwpz/krGMCHOK8XPUJuSqVvNAGh0Sy1sivrmPCywnjbEw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyAZAWmDf4Xif7FCaRtmxsdH9N1sjN8j1AoCBHSAS6GVk/qSTmN
	ZOejEdr1SGz2o63+ZTNptgYk48cfUe+3G005n819HXtpDSqpTgErVXp47hIyuz2+EC0e4Q9+Kv4
	ZNgIGP2+xnEpL/lkWFarpaWLOMfPxnXYN8rMgzNukSKBZrwjahIXB9hOX2lc=
X-Gm-Gg: AZuq6aJDbPX5pCEgQGUW3OaGmNprL3Ot7c8i22+4ZVayAXpjY/c3FmqO4ElQMdzMvar
	C3ub/BFrgvLVF3B2OMuEOWGYFIMdJKyBaepDudoNCB+LG8jlxKGdAvwBH7ZDNk/HC2HJfeVQ93b
	mV4vZ8TRgFGwN7YvvWbzy1MWqlrHKgC8fgSRuhPXaTgNXgQm4tVUkVCbWuNAcFZ4tc80K2UUY1l
	neDBKtm1K4dk2RbB/GmZqhGtMatXO6R4viMwUFWApHanIlICLAYkmSLsofbJahLj/cNhIGC+/go
	aPduCky0dQw5J0GikOE9ZSvOpEA0QxVoUEnzhrp+kAHb3ml9aWODZoNOWjGQYiNYQyfk7HJwit3
	WDPFbXJAn6tF8Qcgyfk0PpSX/BQv6H83vOHG5lEnKNpAyKLF+8vAa0Xc=
X-Received: by 2002:a05:7300:fd03:b0:2b7:ffc4:ee45 with SMTP id 5a478bee46e88-2ba8a847312mr1284646eec.28.1770749893204;
        Tue, 10 Feb 2026 10:58:13 -0800 (PST)
X-Received: by 2002:a05:7300:fd03:b0:2b7:ffc4:ee45 with SMTP id 5a478bee46e88-2ba8a847312mr1284561eec.28.1770749887816;
        Tue, 10 Feb 2026 10:58:07 -0800 (PST)
Received: from [192.168.86.165] ([76.176.48.107])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b86b800c47sm7896914eec.12.2026.02.10.10.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 10:58:07 -0800 (PST)
Message-ID: <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
Date: Tue, 10 Feb 2026 10:58:03 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/35] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Mostafa Saleh <smostafa@google.com>
References: <20260119124629.2563-1-will@kernel.org>
Content-Language: en-US
From: Trilok Soni <trilokkumar.soni@oss.qualcomm.com>
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=N+8k1m9B c=1 sm=1 tr=0 ts=698b7fc6 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=lsoD3MMNObdLvy1227ExmA==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=di51ST-lB5JxRLjaeOkA:9 a=QEXdDO2ut3YA:10 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-ORIG-GUID: XThAu-qhBPpI_iSTVqw4oGL1oPsGsCd-
X-Proofpoint-GUID: XThAu-qhBPpI_iSTVqw4oGL1oPsGsCd-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE1OCBTYWx0ZWRfX1bD3u8caPm2O
 OSf8uhyywOnrCdQlxpeeltAvSua55dMGRrVGhql7XdLKsIg0530KuihXazjPYlPa5z4CsnjXVI4
 +HKryktfTXKKc8hbwgaVfk5QAn8dsEutGhbYtyywFO4lmGznZ537n8f23BJcfzihwrT0FSj6FqD
 YwTMJcq0Xe+NPWxrbKPq8qEGstDbt+65c+w4GO6d6NVKc2ff0jZdYv95zC2tc2n5t/cKuRjqaqA
 ASQzUIhqvnY0ouqQiwYx6c9nEk50RUi1FZyDOc0gds0rrpQ+PhzA6uqJo1Vqt5MY37u08i+hUJn
 KkMtmgQgPZaWe7rkjs+DnZ6ukGZX2J6wGbQN4+bZaKW8ij8XXb/HANw5oqOVj9YBYSnbo5o9Sm/
 TONE+88Wkp1Khy4rFvKGw1+yuFwEMClkQwmJNK/QtR3kh8Us6phRGw2pKq7Yt6ip9Nwc5etHWsp
 67CZAUZXLO0XY8JvhrA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_02,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100158

On 1/19/2026 4:45 AM, Will Deacon wrote:
> Hi folks,
> 
> It's back and it's even bigger than before!
> 
> Although the first patch has been picked up as a fix (thanks, Oliver),
> review feedback has resulted in some additional patches being included
> in the series. If you'd like to see the first version, it's available
> here:

Is it possible to test this patch series w/ the QEMU or it will require
real SOC platform? 

---Trilok Soni
