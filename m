Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AFD3783C6
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779899428; cv=none; b=d3iD5FayuKdynTmoyHHiQnesekJCBz2if7v4oWnxwtRXaSzs8VHYcikMIKqdN37kbN9aUoO2dl7Szb8+/gIWoEZxp01mSbdLLKhVIBjXKvy2mV9Om6a17oe32lOOIhAqWmLCGv7H1TU8tt69l4vyOwpchiq0WI+992T5N3zdg1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779899428; c=relaxed/simple;
	bh=/wtAM32dVMZaj/N+m1CAUtxxJJwrOu0osqCczOo7k6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D6hpVhfC3F9/cjFn+f9ehnW9K784fLyU99SXcTsMYoJ94PKHMsoMKsDAdB/dFA5JNsUlWVAgqmoqosiWTOVZ2NLuBi1yRk0jPe1wSStV+sekM9g6/AVXtBB2WN9IaPYYfclpvXh9nogw4n+TrfqVUHGJ4rSNjMnKNTfY3MuNfX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M11P5wze; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M11P5wze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779899426;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vmaVEarjl+29HjUmp4g0LDPMRPfL+U1HfCPbEe43AKU=;
	b=M11P5wzeaIbCUb+iix9A+OL6d8Kv/Vu8eIXCckcZAY9/ZSeRmUd1y6kByTPDtSiFIWFRMF
	GbKVDVAgEbD6fXGqkQif6dEU/KXLiz1kpjI884vomTsVjMUEWQtqOK+1wmA+sV/A8RjUNg
	lNZYUaz+VP0V932Nt/St91ebwMkXoS4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-fOgEYgd9OPGXWQnSYQtTbg-1; Wed, 27 May 2026 12:30:23 -0400
X-MC-Unique: fOgEYgd9OPGXWQnSYQtTbg-1
X-Mimecast-MFC-AGG-ID: fOgEYgd9OPGXWQnSYQtTbg_1779899422
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fd64c32e8so82149775e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 09:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779899422; x=1780504222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmaVEarjl+29HjUmp4g0LDPMRPfL+U1HfCPbEe43AKU=;
        b=IOb/4zAkaoXL7na09PVH5w5Kw88gL3fMkhHI0wWwtEBsg7j/q/iuz9GMapqw9FLCxR
         Py840eVuyYdaUtoknKSt1XRU/+/RpoZ1JYcd09ycRuUFgrhRAGrxvdYhR+NwzZvocL6/
         A83C5TeELJs+mfe9o11ezGwxnSP6Xgthd4Ge+ye15CFo9nDrJOwZ1WzlcFYgyzXnuG/3
         3IOPqn8Uwcu14wImjCtbfagS9Jk7vo1cao4A7Lgpa3L4EJ+Jj57W9QZoGSHr9JdNeAX1
         RN2TW0zil7uKGYNexodpiyeTu9f5wF12wuMvhopomOmg9eRKFQ4XGxCqgH/zu5KFZdMj
         OZsA==
X-Forwarded-Encrypted: i=1; AFNElJ+KsUDb9f7C9VaBZIqzcEWMp7xaU0UBDSJqGxdVYDUy5Q7XftF90+NnHgaU4UMRIjSBGv40bQ8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9y1Yo9YvHvgX6N7f+m8MLXVh9lVtngNN9lBd+v5veTY26HPG5
	8jCmT1tWg1vC0eyzHbnIfdV6an3GhVRzy5x8O6mgS208o12e+BkVXcrIzgYN6te44mp59OR1ARD
	4pikV4Ys3kbt98aJ0nXsIb6Ad+f2GvTstVim3zUYf79r13wipq/5UuK+T7A==
X-Gm-Gg: Acq92OF5MzvZsC9a/tNDPr4ifSizHe4DHV7P5nun2foty69SavuCt/ppWBjPKn6dpC9
	UzYzIqvVDZ0EFRxqvC0jOqlaBpXX0dp+xOAPsjeMWttshSzKk9chRrw9amlXXFNomLKQXnvYJgy
	D560Ii4lCaFAo2xHLmYSlnilGNe89S01E8dxm3DVFt0Pj6ckSDyUwq1Pzmo6U38osi3c8eJcKjV
	IFMH3fXzPaRDt72FBnw+3bBy6GZkwfccOHf+wlHUWQs8LaxkSwUi4kBU2QfHjOl8u4iwImL1omE
	DZ3nk1sKrn+I3oVLk6aNT2VpEcD1MLnfg2Of4B+mWBgBMYvYXqE3KQ90afwnO3g3I+G8ibu5Rgf
	wHty9Ajwi8tH33/Q2G9d6m0xKUoXfNCVTG3TN97+1YW2h7E2HDl5657pMWLshM/Vkik2E7A==
X-Received: by 2002:a05:600c:46c6:b0:490:4927:3777 with SMTP id 5b1f17b1804b1-490492738a4mr354193325e9.2.1779899421625;
        Wed, 27 May 2026 09:30:21 -0700 (PDT)
X-Received: by 2002:a05:600c:46c6:b0:490:4927:3777 with SMTP id 5b1f17b1804b1-490492738a4mr354192575e9.2.1779899421146;
        Wed, 27 May 2026 09:30:21 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490809b7619sm20632265e9.25.2026.05.27.09.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:30:20 -0700 (PDT)
Message-ID: <1cf36575-a542-49a2-a23f-2357184da8fc@redhat.com>
Date: Wed, 27 May 2026 18:30:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 15/18] target/arm/kvm: Ignore some writable bits that
 shouldn't be
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-16-eric.auger@redhat.com>
 <E5402D74-AE00-4088-801C-C87A749E17C9@nutanix.com>
 <80fa5157-2376-4010-88b2-deb6ab50f87f@redhat.com>
 <6CA1EBCE-BA44-42A1-81D3-1A723C6F0CC3@nutanix.com>
 <72f22825-d810-4fa1-8fc5-123ae06af91e@redhat.com>
 <3A56B398-0213-4962-B27C-96F716DAB799@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <3A56B398-0213-4962-B27C-96F716DAB799@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5hLfAsOOlLvY_5efHfPQjoModrzGB_mosN0zC5isbaE_1779899422
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 6:16 PM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:31 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> but if a field is RESx why don't you want to overwrite it? Are there
>> cases where a field is RESx depending on a condition?
>>
>> Thanks
>>
>> Eric
>>
> There are cases where fields are RESx based on conditions.
> but too complex to get into those (CCSIDR for e.g.). 
>
> What I meant is when we want to realize a model, 
> 1. If we don’t account for RESx fields how will we know which fields Res0 or Res1.
why would you care. Those fields are not exposed through props so host
has the good value, Res0 or 1, no?
> 2. In future what if RESx field becomes a defined field? Instead of maintaining:
>>
>> +    if ((!strcmp(reg->name, "ID_ISAR0_EL1") && i >= 28 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_ISAR5_EL1") && i >= 20 && i <= 23) || /* RES0 */
>> +        (!strcmp(reg->name, "MVFR2_EL1") && i >= 8 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_PFR2_EL1") && i >= 12 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_MMFR5_EL1") && i >= 8 && i <= 31) || /* RES0 */
>> +        (!strcmp(reg->name, "ID_AA64FPFR0_EL1") && i >= 2 && i <= 7)) { /* RAZ */
>> +        return true;
>> +    }
but you still have to care with old kernels which expose those fields as
writable. If the value becomes non RESx, you won't have any mismatch
anymore so I think you're just fine. Effectively either we keep this
patch for we just turn the warnings into trace points

Eric
> We can just maintain one cpu-idregs.h.inc and have RESx in that.
>
> Warm Regards,
> Khushit

