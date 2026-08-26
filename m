Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063C36CDFE
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 06:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726741; cv=none; b=nH0peRl2qty6BCi3iVqoLM8E02cCB5x5NGYCkvf7cg1nrrqRkkXhsC69fgXtkh/aCSieIlZi0BUIbc0SzThIqnC4VfVsc+CC7b3iSExLAkwv+Ur/D/9CVEe/govvE738h+0gi1N9A5TyihkkYg8Tf8jacp1Cl1CQIzAOd/xBwB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726741; c=relaxed/simple;
	bh=vxxm7i6H114ePmqfmmqvPUtgT+DP2dGnPzjFRjqr7S8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcVwmAu2CFq5znG6SufsEofMiSVew3EAcLUEVPGlFCTCPvoloNs96A5gxf7KLakr/cIltvbijeZYZ9jnAEtp+3QyBApupNVNmzrxJfWkUbhFWFg3yq+IEYhZTDIkuNy95LZxoj9p2O45OZTfsBAS8m2uvC4ODWWykFHRskh/JEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CjVXxML5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CjVXxML5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787726738;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dmD553i3R7mbHOfNOQTqDSWokZ9awtN325Ww0u7K5HM=;
	b=CjVXxML5HpC5E/IZ5W/QUOJkOmyLSmcXUfCiFpz+WSeDm2DdMynIqrqIDQylyGjY+iHf8p
	OTXcU+VKtPAtsoCbaKf3aq0Ktv/OkLz3irE9f4Cb2k+eCEyYLNd0CKF3p6GebQNRJM7WiV
	n4B0OMpKigdB4e2uJFymreiooVlKPms=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-ovYovAwPNruwmcfJ46Nbeg-1; Wed, 26 Aug 2026 02:45:34 -0400
X-MC-Unique: ovYovAwPNruwmcfJ46Nbeg-1
X-Mimecast-MFC-AGG-ID: ovYovAwPNruwmcfJ46Nbeg_1787726733
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c15ff68c858so51239266b.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 23:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787726733; x=1788331533;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dmD553i3R7mbHOfNOQTqDSWokZ9awtN325Ww0u7K5HM=;
        b=ZxaoJUeSWLLlxT6CaQdJhVBsOZf42UKqu9SB6KL8VWaN5hyJQmLf68//OUkhlaI6a1
         kelfsfds7mjb7Rzkwfg7M6ISbUzgtlK+9gEWmwq201NXaSau1LZu67XwtvD1bfPbEOt+
         NqTvGlmhIGvY++s+cl8zXLtjmzXN1ssQPxkxmZ7aqZO7bpXbv3N+d1/Q1LxWTmgwYHhb
         s1UVT7ZdO0BWKbVl4LyHj+8AKMccoCqmMhS8sraDsWGMSMaXaRdPWpEiNUy4TJnjdXdC
         N8lwpmMmddlZGdZFSpWRRKgnmZW45csjNCycx07up8wWnuvFvDkwKVYK0i7IRxSogg5W
         GfAw==
X-Forwarded-Encrypted: i=1; AHgh+RoMRNYOzL0TOqzLZUmpAlFDEBquFV/IWXNlH12+AJDT6a1sTYuk0ezgvhsHNxeS/Lk8boXSo2U=@lists.linux.dev
X-Gm-Message-State: AFuF++k96N0jZ+T+GDBvdA1F7e9gGoW1EfGMnFy7L9FFkT68pzGHac54
	i4mbqMT3o6Rfc5Nx/Cu2dJeRKDRTrTBN+G1GmjyWn7q0f+d2t9OKVH1ucT6p5gcaRp1jyXiEHB7
	G8edfoHlk9PvLJnJZ31YPPMiX79bUfmGVK+adg1sznVUb/C913RaZLnzLCw==
X-Gm-Gg: AR+sD10nl/cf6kJn5WnmksFvE69xgtBjZgDgAGC4lHfWLUk4PfXqaUcIjB30q3dY74m
	s3hcBpYnOJCxoP2sm/8b5J3G+deKxqjhFscrg2klo9D62Nb5boQzD9aA1Mg/x55joq8/0Ja8Yid
	IDnAzJPdsGdL5Di6djhGz7zpfmSJ/CXclp+DoBOQMlObG0xy9stt7f35K9IOrsMJzVmn040Q1fm
	7AUhseWXmfU5h6aTFbZKfbfeUoWCrEwPP0UypagACxgxA9IcKZttqOtRievLrvHmEq9KENjjg+I
	oZqRGPPtgSe23t0p18FWjw3smAFuNwHxIqXyf+UXXmw2UykNj1lf39ffB2Us776MMrfu46c54nz
	mGPM5MQPchLV+FyIOPIzCbMw+x5AQzSwTaZXln4xCJeThmkZU
X-Received: by 2002:a17:907:6d1a:b0:c19:45e3:2f57 with SMTP id a640c23a62f3a-c250c4b3348mr459043866b.9.1787726733297;
        Tue, 25 Aug 2026 23:45:33 -0700 (PDT)
X-Received: by 2002:a17:907:6d1a:b0:c19:45e3:2f57 with SMTP id a640c23a62f3a-c250c4b3348mr459040566b.9.1787726732930;
        Tue, 25 Aug 2026 23:45:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a7303casm437391466b.25.2026.08.25.23.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 23:45:31 -0700 (PDT)
Message-ID: <7ce15b69-11bd-497e-9463-0745700fe6fd@redhat.com>
Date: Wed, 26 Aug 2026 08:45:30 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 03/18] target/arm/cpu-sysregs.h.inc: Update with
 automatic generation
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
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <20260726153221.24773-4-eric.auger@redhat.com>
 <42EB7A4B-9C09-4E31-B435-556C6020E451@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <42EB7A4B-9C09-4E31-B435-556C6020E451@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eMdYbeYS7vhcxu0jLm5uocZfkNPMG3AZjEyvHftIMrA_1787726733
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,
On 8/20/26 8:55 AM, Khushit Shah wrote:
>
>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Generated definitions with scripts/update-aarch64-cpu-sysregs-header.py
>> based on "AARCHMRS containing the JSON files for Arm A-profile
>> architecture (2026-03)" Registers.json file.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
>> ---
>> target/arm/cpu-sysregs.h.inc | 13 +++++++++++++
>> 1 file changed, 13 insertions(+)
>>
>> diff --git a/target/arm/cpu-sysregs.h.inc b/target/arm/cpu-sysregs.h.inc
>> index ec5a12b0f4..2188cd7be0 100644
>> --- a/target/arm/cpu-sysregs.h.inc
>> +++ b/target/arm/cpu-sysregs.h.inc
>> @@ -1,11 +1,20 @@
>> /* SPDX-License-Identifier: GPL-2.0-or-later */
>> +
>> +/* This file is autogenerated by scripts/update-aarch64-cpu-sysregs-header.py */
>> +/* DEF(<name>, <op0>, <op1>, <crn>, <crm>, <op2>) */
>> +
>> +DEF(AIDR_EL1, 3, 1, 0, 0, 7)
>> +DEF(CCSIDR2_EL1, 3, 1, 0, 0, 2)
>> +DEF(CCSIDR_EL1, 3, 1, 0, 0, 0)
> As CCSIDR*_EL1 are demux registers, a single entry for them does
> not make sense.
OK I removed them

Thanks

Eric
>
> Warm Regards,
> Khushit
>> DEF(CLIDR_EL1, 3, 1, 0, 0, 1)
>> DEF(CTR_EL0, 3, 3, 0, 0, 1)
>> DEF(DCZID_EL0, 3, 3, 0, 0, 7)
>> +DEF(GMID_EL1, 3, 1, 0, 0, 4)
>> DEF(ID_AA64AFR0_EL1, 3, 0, 0, 5, 4)
>> DEF(ID_AA64AFR1_EL1, 3, 0, 0, 5, 5)
>> DEF(ID_AA64DFR0_EL1, 3, 0, 0, 5, 0)
>> DEF(ID_AA64DFR1_EL1, 3, 0, 0, 5, 1)
>> +DEF(ID_AA64DFR2_EL1, 3, 0, 0, 5, 2)
>> DEF(ID_AA64FPFR0_EL1, 3, 0, 0, 4, 7)
>> DEF(ID_AA64ISAR0_EL1, 3, 0, 0, 6, 0)
>> DEF(ID_AA64ISAR1_EL1, 3, 0, 0, 6, 1)
>> @@ -40,6 +49,10 @@ DEF(ID_MMFR5_EL1, 3, 0, 0, 3, 6)
>> DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
>> DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)
>> DEF(ID_PFR2_EL1, 3, 0, 0, 3, 4)
>> +DEF(MIDR_EL1, 3, 0, 0, 0, 0)
>> +DEF(MPIDR_EL1, 3, 0, 0, 0, 5)
>> DEF(MVFR0_EL1, 3, 0, 0, 3, 0)
>> DEF(MVFR1_EL1, 3, 0, 0, 3, 1)
>> DEF(MVFR2_EL1, 3, 0, 0, 3, 2)
>> +DEF(REVIDR_EL1, 3, 0, 0, 0, 6)
>> +DEF(SMIDR_EL1, 3, 1, 0, 0, 6)
>> -- 
>> 2.53.0
>>

