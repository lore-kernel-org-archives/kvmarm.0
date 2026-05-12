Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18434DC54A
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778567070; cv=none; b=GnT9fLPGW6rckNwGQgLrgJi7AsGDxzvgZSG2rhfYBolZpz2F8ULdBMX60rKFschfMZNSbZn1h5yfa1TohzHGLgeGQFgobO58ZcKLaI+jEjhuVSHhzena41qhy2Jl1OZuwiWyzmpa+PsaCOL6nxlxnilCJ8MBLOFB5lhfAzaZL6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778567070; c=relaxed/simple;
	bh=Pg7xz0BmChAqpED6p/5T8s+/y9BDQRWWCHfCXjwhadc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lSmjuhu563QibhDL47zQZ23ckwoqvfZsNtZzRdkz7hxDNOxd7XnbTAMS2CuDkCBYA4iopfKUUvdySxi2Djcqdd1GTBiEIg6Zdjx61A6GR4Yeoo2aGXsV6kttLosPP+4bksA6tLx5IkLc7D2EGudUc6db32puDoenqs2BZ/2GNF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hN8KlDdr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hN8KlDdr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778567052;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dAxdg8ECUy7638umgau+fD0qEUtkUi+NySXn2MqQUms=;
	b=hN8KlDdrJ93Xz0G1hdQeLGTicMvhKwtoNaHLVW47UME5QhCeKIAy+Q7oMpA037bHmUNlJk
	EZ2l1e8CJxGQbJpxZDCIOoq6eYYUI63XuKnc74N2axt0NwWkNB4L5DhBDCuWh9FTGEI4SM
	ALFsySTS7KjLYSVju5LcYeVXJnF9V4w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-inuF71agMS-lJJQ-ggsyZw-1; Tue, 12 May 2026 02:24:10 -0400
X-MC-Unique: inuF71agMS-lJJQ-ggsyZw-1
X-Mimecast-MFC-AGG-ID: inuF71agMS-lJJQ-ggsyZw_1778567049
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d05e7b117so40412335e9.0
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 23:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778567049; x=1779171849;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAxdg8ECUy7638umgau+fD0qEUtkUi+NySXn2MqQUms=;
        b=MmvdO7yZ9tY0MB8Z6Kz/sW5f5kgeYpdsQZM35OiSf+plZADOL1OCW5KQr5AQiRs+7+
         5g2qLfkI1JpzxxT24R1n7RKh95dYDQmfxFtoMud0BnCrRwAJWLFAivDiJUjwfNQ+leWq
         HKkot+Z0AwZUs0cm/bLHk+ak86G8qmyIIRomY59BbvFoABmva6MM6+fw8oB0aDooimdT
         Cim9EU+5Cb+ewzPMFmuHm5DfMxd4PgZmNrhSO7eu5JMNlvjwdKmEAl++Mfmd9JshcHrA
         hl8Okru+x/DU+kyTu1iZR4vWGKdVypWx4mMlMsHsmiHjZonWQQr1X44zJ/i1ON4c9Sng
         c6+A==
X-Forwarded-Encrypted: i=1; AFNElJ97aLenVIEkdUNi/wSfZHQpiT44mkb+lm8blrrue7s2RfVv+h6GjCmAAslMQ9ccwPR+3nf+KxY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwcywjCLm5B9EAJwwePGIH2JkCGinXBysEMTAIZBTbyhgnv56zp
	JgfRUxeCeUxRer8GMzBQnVS+mWkp0ZBRXTLyiQLdYwNjB1Kscm1En83rkl1QoqFi0T3fBji0ROd
	sKAXRoqWd3YVxbTAHJzPoPG9KQLFWzBCcDN/CAW3f4hgOcL6/NuVIA0DOow==
X-Gm-Gg: Acq92OHEJjiMIaGdDFa2l7QGRyTXjNX6XUSW/5WkzPg314t/qe+on+k4g/i6URcexyq
	CZnMGAt22c1sw4WB8ub9ifh1dmYo4JWMk+lhJuYyg7ovESMtJsXhgsex8fgWSnyFPDT6JoDWQ76
	ELSVTuMIRazMusYXkSDRKg8XPWhNXZDU5bGyLrHIXg2+Orxg4+0qHSqGqqg1fSKjIiRxKDApfc3
	fLgg+YGeRC8buagD16lAf2Kz6qHibxOfBUfX0gEXjcohh1N6EVHPKD0tcik11MkepfXAvFyXKkh
	uPxi51w89yHisazdqSwKZTp0C3+BUpyVW7FykM14uclulLDZgMY32CEeYgrxljuXEpnyYtrlzaZ
	x9/ICqJARW6CdWJbuiyMiTrg8W0MqJ9OrtZPV/qMRBTTV2r8IJ6TKApW/+PG+dl27O2Xg+g==
X-Received: by 2002:a05:600d:18:b0:488:b811:51c4 with SMTP id 5b1f17b1804b1-48e51f3c4f4mr354628825e9.25.1778567049033;
        Mon, 11 May 2026 23:24:09 -0700 (PDT)
X-Received: by 2002:a05:600d:18:b0:488:b811:51c4 with SMTP id 5b1f17b1804b1-48e51f3c4f4mr354628315e9.25.1778567048620;
        Mon, 11 May 2026 23:24:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8e5d3107sm19165665e9.1.2026.05.11.23.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2026 23:24:08 -0700 (PDT)
Message-ID: <29c49ead-c8d0-43e0-92de-a51c82079cd2@redhat.com>
Date: Tue, 12 May 2026 08:24:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 02/17] target/arm/cpu-sysregs.h.inc: Sort by name
 alphabetical order
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-3-eric.auger@redhat.com>
 <CH3PR12MB75485D446DD0633DF463A415AB3F2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB75485D446DD0633DF463A415AB3F2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SNxI_pllTobmReRnWu-eUkuEC8tu3Vjn_HqxCkJpybc_1778567049
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shameer,

On 5/6/26 6:10 PM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:33
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 02/17] target/arm/cpu-sysregs.h.inc: Sort by name
>> alphabetical order
>>
>> External email: Use caution opening links or attachments
>>
>>
>> target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
>>
>> Sort by register name alphabetical order. This will allow to
>> easily diff with the future content, automatically generated.
>>
>> No functional change intended.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Message-ID: <20251208163751.611186-3-eric.auger@redhat.com>
>> ---
>>  target/arm/cpu-sysregs.h.inc | 43 ++++++++++++++++++------------------
>>  1 file changed, 22 insertions(+), 21 deletions(-)
> Took a while to figure out the extra addition 😊
> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)

Hum I missed this spurious addition during the rebase. I will remove it
as the goal was just to sort the file without adding anything. Next
patch is supposed to add some new stuff.

Thanks!

Eric
>
> May be worth mentioning in commit log.
>
> Thanks,
> Shameer
>
>> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
>> index 3d1ed40f04..d61f0d0a19 100644
>> --- a/target/arm/cpu-sysregs.h.inc
>> +++ b/target/arm/cpu-sysregs.h.inc
>> @@ -1,12 +1,12 @@
>>  /* SPDX-License-Identifier: GPL-2.0-or-later */
>> -DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
>> -DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
>> -DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
>> -DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
>> -DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>> -DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
>> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
>> +DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>> +DEF(CTR_EL0, 3, 3, 0, 0, 1)
>> +DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>>  DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>>  DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>> +DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>> +DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
>>  DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>>  DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>>  DEF(ID_AA64ISAR2_EL1, 3, 0, 0, 6, 2)
>> @@ -15,29 +15,30 @@ DEF(ID_AA64MMFR1_EL1, 3, 0, 0, 7, 1)
>>  DEF(ID_AA64MMFR2_EL1, 3, 0, 0, 7, 2)
>>  DEF(ID_AA64MMFR3_EL1, 3, 0, 0, 7, 3)
>>  DEF(ID_AA64MMFR4_EL1, 3, 0, 0, 7, 4)
>> -DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>> -DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>> -DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
>> +DEF(ID_AA64PFR0_EL1, 3, 0, 0, 4, 0)
>> +DEF(ID_AA64PFR1_EL1, 3, 0, 0, 4, 1)
>> +DEF(ID_AA64PFR2_EL1, 3, 0, 0, 4, 2)
>> +DEF(ID_AA64SMFR0_EL1, 3, 0, 0, 4, 5)
>> +DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
>>  DEF(ID_AFR0_EL1, 3, 0, 0, 1, 3)
>> -DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
>> -DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
>> -DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
>> -DEF(ID_MMFR3_EL1, 3, 0, 0, 1, 7)
>> +DEF(ID_DFR0_EL1, 3, 0, 0, 1, 2)
>> +DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
>>  DEF(ID_ISAR0_EL1, 3, 0, 0, 2, 0)
>>  DEF(ID_ISAR1_EL1, 3, 0, 0, 2, 1)
>>  DEF(ID_ISAR2_EL1, 3, 0, 0, 2, 2)
>>  DEF(ID_ISAR3_EL1, 3, 0, 0, 2, 3)
>>  DEF(ID_ISAR4_EL1, 3, 0, 0, 2, 4)
>>  DEF(ID_ISAR5_EL1, 3, 0, 0, 2, 5)
>> -DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
>>  DEF(ID_ISAR6_EL1, 3, 0, 0, 2, 7)
>> +DEF(ID_MMFR0_EL1, 3, 0, 0, 1, 4)
>> +DEF(ID_MMFR1_EL1, 3, 0, 0, 1, 5)
>> +DEF(ID_MMFR2_EL1, 3, 0, 0, 1, 6)
>> +DEF(ID_MMFR3_EL1, 3, 0, 0, 1, 7)
>> +DEF(ID_MMFR4_EL1, 3, 0, 0, 2, 6)
>> +DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>> +DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>> +DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>> +DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>>  DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>>  DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>>  DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
>> -DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>> -DEF(ID_DFR1_EL1, 3, 0, 0, 3, 5)
>> -DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>> -DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>> -DEF(ID_AA64ZFR0_EL1, 3, 0, 0, 4, 4)
>> -DEF(CTR_EL0, 3, 3, 0, 0, 1)
>> -DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>> --
>> 2.53.0

