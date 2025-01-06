Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FC71DC991
	for <kvmarm@lists.linux.dev>; Mon,  6 Jan 2025 10:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736161074; cv=none; b=ObNFSxklmOvii2rvZMnI5cjeJgBfwSdoFAnRWP0CvOLXmz5SrHXI3J6818xYybCdC1j1H09j4BsPnLXvYdurpGHQJ0EsAUGREzFOWGyVRAvMov7CAWpvpkYprs7odFZFWWB4aLx7YdpS1Ak/T9kJe7Eqd+ETrEaV5LEXkN8Y6mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736161074; c=relaxed/simple;
	bh=0HPjyIMcS44C+BDPMKqNONf/Zff0hoZdM9xKSHxcZLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSXktONbt8y45+PxlXzp0tw2VWEM9h8SJqbKJvr897I1TpbZ1vtOJtYRmWgIwwcjvqEkcdD9iQvFQJBbumiBq7EYLv1M5hn/ZdYc86LVuMUlDsXpASOMTTszQIdYLTrtUMbFjnLSXNvd2b2afIdPJ938WYSUTSEee5eTm7sm+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GthwMXBK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GthwMXBK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736161068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xelBfWSODcxsrEcjEs1BiG8WTAMva9NkWAeUvbujNUA=;
	b=GthwMXBK6YuehXGLLAmNS/PINtdzdyxH6LyE2QIPdmIX3GF2xkE+YzvQjQ3Tv3KPY16dMl
	cfFnW+DnK3rH0RINDoFoy1g7Yi0owjBbvH1/N0G6/1VIx66ZaBao0MuEh9NJDmovitm9zH
	YX3N6omZGX3cn3A7ujIdZjbExTi++0s=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-538-o-OZRUrnOwOKN6WgqkL2rQ-1; Mon, 06 Jan 2025 05:57:47 -0500
X-MC-Unique: o-OZRUrnOwOKN6WgqkL2rQ-1
X-Mimecast-MFC-AGG-ID: o-OZRUrnOwOKN6WgqkL2rQ
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d8f8b9d43aso309289926d6.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jan 2025 02:57:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736161067; x=1736765867;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xelBfWSODcxsrEcjEs1BiG8WTAMva9NkWAeUvbujNUA=;
        b=C3yHG1HvREh70+bECh2iV2G45Wg0xNwSR/TM/MUkgnUu0hBHqmsYJJ5Tjk5XIKNJU8
         EcAHsEEvFzobTSou+uVbsaOHve2ci2SevCummasrUKqPhPmnMBK2mwvEWwyf4rw7e5EN
         3aCUJKJ5NQvXMhFZQYrXW5ORF1A+LvjQRiwiwuNP2WfPQlYz/KoO2C1tP06ytOtFxlms
         y0ZxuTJR7/n699Tu8Bf6CMNJxi4bS0HaIpeFL6tkKrU8zpqcjAaMEz89UWuaPop0/5yk
         tOQ9KRSpV+A1vUPejrS80ewRnMq66j1c/kpggnNk12v7roPKpHBCbTGeiuEJnZUvFUAn
         fqZA==
X-Forwarded-Encrypted: i=1; AJvYcCVPKBtHPl37FzKCBhvlKIsyr9vGGvEVdUHmBp5W6jDersCwLENvvKUx8UXrESsQzCD/M3bONEU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhuPin0+v9Z86qBeRKylKVwHdCKlFq5h2uG8PQ0dtJwJTrPhMs
	BqDhkNsirkvn1fZCf8ZaR6jPs2bzh3yH+0M57ItY0FLGWKHZ/yLb55NdqZ0ULXzNlYqX9bdUCXk
	uOEnkOFT/uwHp2ETGcV+QvGZAf8EfIA3lV5Xee5mcykbJ8/axAA4/SA==
X-Gm-Gg: ASbGncs6yilOaWGqz1zDBiRhWUdU+0r0tQR1wIzra8EJGTXlO0mwiDchY/oW/4VFjYF
	A58etL+PFa+YGsV2Qcxj/1r+MbMzUoVG3Ra+b0PHLrQX/HDPFenb2QBmjyz/EH08yvJ/4OzYMwT
	c9QDC7Vmh8jRrIVOUaeHMRPPyizxwI3XDDMh0NiUuMZzhzWa8HG99STP4p0MmEv77snvAQTbs6O
	uVXVAVgbNou+nDhl4LzHdvIjFpZ2c11fY6sHLQfkAvysQh1gCGhL37U3TngCbqF/yIDwz7c78qA
	peQDqKjltIO6cFdThI/1qRM=
X-Received: by 2002:a05:6214:20aa:b0:6da:dbf0:9640 with SMTP id 6a1803df08f44-6dd2332ed7cmr917796836d6.7.1736161066977;
        Mon, 06 Jan 2025 02:57:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHLwbrQGbMn9NL9Ah4F4vcDj6k2WKY2Yw/cnHzXjmWPCRq8m97NVu8ZZRP56C6MfG+D7akdOA==
X-Received: by 2002:a05:6214:20aa:b0:6da:dbf0:9640 with SMTP id 6a1803df08f44-6dd2332ed7cmr917796606d6.7.1736161066729;
        Mon, 06 Jan 2025 02:57:46 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46a3eb178a7sm174272571cf.62.2025.01.06.02.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 02:57:45 -0800 (PST)
Message-ID: <690b7702-42be-4c23-a9bd-c1e8f09b0623@redhat.com>
Date: Mon, 6 Jan 2025 11:57:41 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 15/46] arm64/sysreg: Add register fields for PFAR_EL1
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-16-anshuman.khandual@arm.com>
 <5203176c-2646-425b-b375-edb7931ef54f@redhat.com>
 <c707ecfd-6f1f-47d2-93ec-116f5dfd419e@arm.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <c707ecfd-6f1f-47d2-93ec-116f5dfd419e@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RGEopULm-IXNYY557f4iuZL43ujzDsPEljY3uRgiFDU_1736161067
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Anshuman,

On 12/19/24 4:13 AM, Anshuman Khandual wrote:
> 
> 
> On 12/18/24 21:12, Eric Auger wrote:
>> Hi Anshuman,
>>
>> On 12/10/24 06:52, Anshuman Khandual wrote:
>>> This adds register fields for PFAR_EL1 as per the definitions based on
>>> DDI0601 2024-09.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Mark Brown <broonie@kernel.org>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/tools/sysreg | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>>> index 18b814ff2c41..e33edb41721a 100644
>>> --- a/arch/arm64/tools/sysreg
>>> +++ b/arch/arm64/tools/sysreg
>>> @@ -3533,3 +3533,10 @@ Field	5	F
>>>  Field	4	P
>>>  Field	3:0	Align
>>>  EndSysreg
>>> +
>>> +Sysreg	PFAR_EL1	3	0	6	0	5
>>> +Field	63	NS
>>> +Field	62	NSE
>>> +Res0	61:56
>>> +Field	55:0	PA
>> Just wondering: part of the PA definition depends on FEAT_D128 or
>> FEAT_LPA and the reset field value is UNKNOWN if the feature is not
>> available. Shouldn't introduce separate fields directly?
> Generated PFAR_EL1_PA_MASK aka GENMASK_ULL(55, 0) should cover all the
> cases for PA i.e 48 bits, LPA, D128 etc. Although individual use cases
> will have to trim the mask subsequently as required.
> 
> Are you suggesting something like the following instead where the user
> will have to concatenate these fields selectively to find the required
> PA mask ?
> 
> Field	55:52	PA_D128
> Field	51:48	PA_LPA
> Field	47:0	PA
Yes that was my suggestion.

Thanks

Eric

