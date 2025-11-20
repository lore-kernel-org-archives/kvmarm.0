Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7750B2727E7
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633434; cv=none; b=nSeOrzI2d4v6XldouXmtsxQtqV1Ozv1l2w2DkH2YZJal6UFRFcCZkGsdPyJOZGsSaEi1ohMM4K7L0R1Y1VOzEPEOlwhQD1kEwNQLIDIctR64vtLKb9+BuYoIZVzuhUgOBRk/37rR6+aHAHTAaFZD4tgJu7SCrDyxAmkKrnBfoSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633434; c=relaxed/simple;
	bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FJipiT+IG+3dSPAeiHqc2i1Xa+8Y53XXsxhR5Jgjvw91ewHMsmgarDAT+GfsrYrszUepDhkWKonckktw32zXCDaqYlV7j7Z6MHZzAQPAkaZsFXsPpSF3GjiMVICTdLq7xaFWDjl9ZTtcYkclHqjW3eHuD2BZiS6SzMrxv2S+UQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJdJPavz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJdJPavz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763633431;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
	b=IJdJPavz+Az5rLY4+oSBtsLvR+AiDmKSWBIoOhQcoxNgdaNw0RaH2dqZO4x65Lda3YcE5z
	4b6GZMOhVj0i2ElW8edx42slOzheHspVviwquG3gRN9gyDYE99DY29DrUQaaiYI+ErTemu
	WQWbLAMrOolTWJF7VEN9I8Vopj4c24s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-LyKWJs-8MXycr29JQ5_ufA-1; Thu, 20 Nov 2025 05:10:29 -0500
X-MC-Unique: LyKWJs-8MXycr29JQ5_ufA-1
X-Mimecast-MFC-AGG-ID: LyKWJs-8MXycr29JQ5_ufA_1763633428
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775d8428e8so5328785e9.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 02:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633428; x=1764238228;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
        b=A93bUEW5wF/QCvft18pZIZV+ia09wfBlEGMT6hFdqjt4+S8u56XbR4qUPjcY0PaCRv
         svey9LSMGT/dNleyqXKJmx+MOrrxAkcR2Ly9zxrQ87sE5Ah7RQ90k42fU7T0THnAtEvX
         ruVaT20dnouRPbPWuMDPg6a3G0lXmEij5GJxtqj8QB+UOGXs1/vLkG3rN24wukEWvxyA
         3JHeEA70YcMX/MZoHm8ykcBN0lsnWrSFuy+NIuguqAFGqwb8WlXMdc8ywAHc3i0/MofR
         Szjnvchhtltwm8EqCjJCyyZIRk+Ekoq6CknAs1HywZkZSrYRQa2a5/PvcIZaMwW49d8e
         wSpg==
X-Forwarded-Encrypted: i=1; AJvYcCWx1YQJtIxg7y2uN0J6E65caWfJPamrF1GYcPOW/N3U3NM+fYkDWTaFe8WDqL6xsbLBKub1NYo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXpxhrB0jHBNNyo2pJ3OqBN1QBceQp+HPMVgOFR2hNiUWeYwIa
	A3ogZxvlN7c2ai2hZ8FCQlnxcw83floMtxMgNB9/P+osTqTCjVkE1RrUdpCc+WCOap9vhxZ4gP4
	UssboR4/WXjkPQkcEPbX8XYy1PATajXQmxgkuqFj6WulLNcZoDhtHZzYMvg==
X-Gm-Gg: ASbGncvzxG7Jul6JdA4L6wYU2Yaise3guy8YjPl1LD0HsHHZ/8fJCs1EsJ0kJvcXWOg
	NjeUTIFGbaBj6RPL4gKE7QWvHOf4FUl+n+JmDYlnoPB+tgFWazbN4yHFHV1q762N8O2Qe8MZ97r
	4bMFaczAQ5FgT0L3MqUD0y4DGgonCtumPv3lo2FLOqfKWc2IoynaMUkgIgdwTLd+N1HK8+b0+jE
	RuD79ooC/qpNGpPiy1wDMki1/pyVF0YShRPLp8zAlqZbXsri8DaoHR0h7nDLbeJaCmjKGaY3elY
	cgtPp+ZqcJTozg1IXQI5B8LnjSmTUpaRIp2sIFkVRhnEOaN/DfsdgF6vxDksGb2w1adIWasEFkX
	voevwS8HSqEIolyK86/9cb9Jfd6AkaE3EsqCvHgoO6rxV+6n2Z+m/5Mfjnw==
X-Received: by 2002:a05:600c:1d26:b0:471:1717:411 with SMTP id 5b1f17b1804b1-477b9e2bcb6mr19350465e9.24.1763633428210;
        Thu, 20 Nov 2025 02:10:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHn8i/nIi7fng7vNcKrFRWxYoraaRwDoQuaqyZbsNoVahq6dZkJgw5xsH9XpdRKx7HNqjDlIA==
X-Received: by 2002:a05:600c:1d26:b0:471:1717:411 with SMTP id 5b1f17b1804b1-477b9e2bcb6mr19349995e9.24.1763633427742;
        Thu, 20 Nov 2025 02:10:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a96a58c5sm64071555e9.0.2025.11.20.02.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 02:10:26 -0800 (PST)
Message-ID: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Date: Thu, 20 Nov 2025 11:10:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
 <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
 <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K-ARF1Gzz2By1zYGyvSRgIL9ks7qM7Fdm_5bm2vwtL4_1763633428
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/13/25 1:05 PM, Sebastian Ott wrote:
> Hi Philippe,
>
> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>  Provide a kvm specific vcpu property to override the default
>>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>
>>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>
>>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>  ---
>>>    docs/system/arm/cpu-features.rst |  5 +++
>>>    target/arm/cpu.h                 |  6 +++
>>>    target/arm/kvm.c                 | 64
>>> +++++++++++++++++++++++++++++++-
>>>    3 files changed, 74 insertions(+), 1 deletion(-)
>>
>>
>>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>  index 0d57081e69..e91b1abfb8 100644
>>>  --- a/target/arm/kvm.c
>>>  +++ b/target/arm/kvm.c
>>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>  value, Error **errp)
>>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>    ON_OFF_AUTO_OFF;
>>>    }
>>>
>>>  +struct psci_version {
>>>  +    uint32_t number;
>>>  +    const char *str;
>>>  +};
>>>  +
>>>  +static const struct psci_version psci_versions[] = {
>>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>  +    { -1, NULL },
>>>  +};
>>
>>
>>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>                                 kvm_steal_time_set);
>>>        object_property_set_description(obj, "kvm-steal-time",
>>>                                        "Set off to disable KVM steal
>>>  time.");
>>>  +
>>>  +    object_property_add_str(obj, "kvm-psci-version",
>>>  kvm_get_psci_version,
>>>  +                            kvm_set_psci_version);
>>>  +    object_property_set_description(obj, "kvm-psci-version",
>>>  +                                    "Set PSCI version. "
>>>  +                                    "Valid values are 0.1, 0.2,
>>> 1.0, 1.1,
>>>  1.2, 1.3");
>>
>> Could we enumerate from psci_versions[] here?
>>
>
> Hm, we'd need to concatenate these. Either manually:
> "Valid values are " psci_versions[0].str ", " psci_versions[1].str ",
> " ... which is not pretty and still needs to be touched for a new
> version.
>
> Or by a helper function that puts these in a new array and uses smth like
> g_strjoinv(", ", array);
> But that's quite a bit of extra code that needs to be maintained without
> much gain.
>
> Or we shy away from the issue and rephrase that to:
> "Valid values include 1.0, 1.1, 1.2, 1.3" 
Personally I would vote for keeping it as is (by the way why did you
moit 0.1 and 0.2 above?)

Eric
>
> Since the intended use case is via machine types and I don't expect a
> lot of users setting the psci version manually - I vote for option 3.
>
> Opinions?
>
> Sebastian

