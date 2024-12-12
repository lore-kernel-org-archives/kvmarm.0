Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F8227561
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734027153; cv=none; b=NZsSRyoEnHHGvlsI8/BkRaXXvcCc8tY+AE5HOIIAtyXH1xPhi5+BK6sm/Ay0gNkZtkZcE2WfVlCvw4NLAV9knUOTbJB4L9XSF0m4VrKgcapH3rKW/QDoW1PJALZLA4+lwpNbbvjTZrCKW4zFfaMpDsJjZtauLDzXHny5Dtgq58I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734027153; c=relaxed/simple;
	bh=DAEmPqA2mieD9wermvpT3RVm7lFnQfFgbXpt7kXUMKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDzgCN71XdmbfiibKatHAO5CKjHfD62O4R2+4FjLec7K4Nm1CPykYecuIugkMiALVVKZDPkFLWSp0O26SpVwYXcUzzMaMOPUV/BttPW+ViMjnpS3LbEz+Z6aAYeJDSJi6s8h0FlW8skBnxFwGI1tyRQI+Cey9H7IjvUG7rknEb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=C5Mm8Cil; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C5Mm8Cil"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2161eb95317so8927825ad.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734027151; x=1734631951; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1lwMwykDY1Tdw7nrWT32NtYxImwWpTGpP8knmDCkmmg=;
        b=C5Mm8Cil0SFYYiRfDnKp+S8upPWOqWSN9BM6GTtB5MNwnk5A9VXAKx83T25W/AAb4+
         rlObeg3jG4wSX9ucUaO9JTc4jsG4mI2/tFz+X1ERQLAOn+0j5/7vJG3F0Sz4xpnAwDmi
         bwVMLN22yN6O+2MNTbPlqGj6EF+JB887+5UP/8WUKNqd0FZQIik3PGjak2lq+bTN5H0Z
         qbANeFIEz/1FE28VAFz/Sw5NAic2jAMwWIJSBPn3mU4QkYqV4jLiRwWx78sxYNSpxFCJ
         BbpbN3HBgc5wBxh3UpIZciXxRAj5gMjMbpl+3CDGVoXroSUWlXt5csucc32lkfXc2rT+
         +2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734027151; x=1734631951;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1lwMwykDY1Tdw7nrWT32NtYxImwWpTGpP8knmDCkmmg=;
        b=guF/CC4rjcjGz71sD5Rrb9paje92W7TcOVzI0hwNkhWzTkAz/HHpvOXqQn6Qp9XHLh
         EJGNAR8h3WOYOZgZ+YH3zBrWs2u97YfT4qhe0F/nVuDv2/v6smlrvgkeo7D2NE9cCkVq
         CM0O9G2oXqkyvigE2o2yIpos1+JMCJz0wU3GWurRMQ9aDNCeQnaCtdD7oNWkjtqB7pwd
         xBJ2tHkbkGLm0dw9yVGoNALhSueGo0KaPTNTv4YZ9GQ4ODEzk+bvPf5OLMwFSxIu6+u5
         MDp++k6kEzHLY/UB/TqI5PzsOKLei/EPdZ2Hsc2GS/H0eKEt304quTCto3sGexmRX9et
         hKnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkR6SHgpUzr2TcBO+z2Txt16/lzFevYIj8P7lKGalVwkjHp2iUAgfb8Ql3ZZ7Oowt09dEDw/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzK9XNoUWQUhYz1ng9TuG7jn/gLEb71LyJIPmCyjSKhm3FyDPcA
	I7mDSPwxJDEXu7Ud+bTR87ulUJu6TKJTZSrnKiugEZY49CJlnQaiDU7DdCeHZMg=
X-Gm-Gg: ASbGncvOc4P6wO2K9bcJON3R4kcQgUKNdVRJfdMFrisMPNMwY8NBcccjuFqblbTd1Qy
	hBkUncK4+3bLp2HB3CTnuNGfylhQ1lKK3zf3/zPcG1kegp8+4Ic7m7ZLXQgcf/2p/iqBBqU2lvB
	TM5v14FubgjhK735dDKLOmw1EefeFL0Yrc9TF/OsZEPwcpPZNMv/+U5jpCrSifWl67k9Be230IO
	AhD81EqOS4xZ2aAEf0cwJ5l8sYpauJmUCrpLK2sZDpaRg7bu/sHmiNAv6Bj0NH7PhaYQfhbuw==
X-Google-Smtp-Source: AGHT+IEZcRsK4rxunv3XsoZWTygWEUIuGKif2GawRfGtuigRWJOv9RGlKrwTQ2cl9TNHve+4gP8W1A==
X-Received: by 2002:a17:902:f54e:b0:216:53fa:634f with SMTP id d9443c01a7336-21778562039mr125516155ad.48.1734027151117;
        Thu, 12 Dec 2024 10:12:31 -0800 (PST)
Received: from [172.20.4.119] ([187.217.227.247])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2162e21321asm92376835ad.279.2024.12.12.10.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 10:12:30 -0800 (PST)
Message-ID: <bcc5e5a2-91d4-45b3-9f67-d6b49833a3ef@linaro.org>
Date: Thu, 12 Dec 2024 12:12:26 -0600
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv2 02/20] arm/cpu: Add sysreg definitions in
 cpu-sysregs.h
To: eric.auger@redhat.com, Cornelia Huck <cohuck@redhat.com>,
 eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, alex.bennee@linaro.org,
 maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
 <20241206112213.88394-3-cohuck@redhat.com>
 <2a83a49b-6863-4fb8-b5de-c3eacf3cdb77@linaro.org>
 <12a2ef7c-0ba3-49d9-9e08-733b8ca6a753@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <12a2ef7c-0ba3-49d9-9e08-733b8ca6a753@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/12/24 11:46, Eric Auger wrote:
>> Do we really need anything beyond the defined registers, or even the
>> defined registers for which qemu knows how to do anything?
> what do you mean by "defined registers". The end goal is to be able to
> tune any id reg that the kernel allows to write. So I guess we shall
> encompass more regs than qemu currently handles.

Defined registers as in "have an architected definition".

E.g. there's no need to set any fields in (op0=0 op1=0 crn=0, crm=0, op2=1), because that 
isn't a defined system register.  It's in id register space sure, and almost certainly 
RAZ, but there's no call to either set it or represent it within qemu.

Because you're working to a a symbolic command-line interface, with FEAT_FOO, ID_REG.FIELD 
names, qemu will (be extended to) handle every register named.

> Wrt op1={1,3}, tbh I initially sticked to the KVM API. Now looking at
> D22-2, effectively we have very few ID regs there. If we were to use a
> hashtable we may be more flexible in picking up the indexes that are
> relevant for us.

Yes.  And I'm suggesting the "hashtable" be defined by compile-time constants.

>> const uint32_t id_register_sysreg[NUM_ID_IDX] = {
>>      [ID_AA64ISAR0_IDX] = SYS_ID_AA64PFR0_EL1,
>>      etc
>> };
>>
>> struct ARMISARegisters {
>>      uint64_t id[NUM_ID_IDX];
>> };
>>
>> This seems trivial to automate, and wastes no space.
> 
> Sure we will study such rework. As long as the key (ID_AA64ISAR0_IDX)
> can be matched against the index used by the KVM API we should be fine.

I haven't looked to see what KVM_ARM_GET_REG_WRITABLE_MASKS really returns, but I see no 
reason that it should not be trivial to map back and forth between the spaces.


r~
