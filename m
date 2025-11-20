Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B7B372AC1
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763635430; cv=none; b=TaPDVVyGVa3dtKTFBLhpNHIp0MdwKzt1dBiFST+aDDPNLskrJR7+Ygw09mbsmaMuh/vctiuq9y8xgl/MoRyZI4L1aKiX0pFbSz3Mbv+5kkS1HOOAg0QL9EdaIH6JKPgtULc7slF7bhuzWAyFgkMmQAyMF89WwjUMY9XxSgP02kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763635430; c=relaxed/simple;
	bh=MbA9H+RwW5ZqdWuv+HONXve++UBdBrFLTUyzU+kGvVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAeJYTcIMbARVg/AwuYi2/z8Hc2FZLer8qJUegjE8XEOy0ATgPZSy6EnLfBWAWUFQeZeihkDccfg8JXyMhdm0UkSMv2IX489sZwX7BOOlStSXPMEu40Y2XREDFK2mABv4/SNIYGxKdaqbXjcTT1SMh9Q0KRzwEqvTcktIuuw3nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=a43OTxh/; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a43OTxh/"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477632d9326so4579385e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 02:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763635424; x=1764240224; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7oHOv6TarlQbLUVDxxSIUN/NgK6M7FvSaHEHJevpMjw=;
        b=a43OTxh/aFSc7QfiiLnkfRXSjeO8iKJHzjpxGBswo8RMCk1CO3VTpkLY6cnXgavKxk
         +5N/h/DekBALgDrEueIV883iEZaC60sp4i+6t54ZcSjBSJGLvEKmlrwE2GYWlNFa0c6z
         oO9f+eYxwcFT0vwlbX7dkJIRwIG5k5fIAT329/zDBZwoE3NEnb0VhFbMuMeYC2XgFtK0
         3tetCOdS2ZVWCklRCrO+rk/Y3BF+5jxSsg3PuiughTJ7yumJbhiT/6aa72OX6rX+Sbkc
         yrsZvL8OV2F6Hv63FrojJchwJE866ZcBNmJxKSBgmAIy2Kr7XmOKu7gyAvKWb9Ou29ha
         qVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763635424; x=1764240224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7oHOv6TarlQbLUVDxxSIUN/NgK6M7FvSaHEHJevpMjw=;
        b=kD7Qgj3yqFNdfqEpdsCF+sOzwf9HSqtz+9xsTjGIASQoXjGupn629uLsLSBUmvDAyp
         IoYEJSDWKHVCBuVm+S0Kh82gq8iZAvi2+EExvk1TFUxmPR9H3cGujHEEARIC8jKV+X5z
         AJLyrM0cuUT3IMnrSJrSJlefvLzM3G/6m+vlkxc9NAcWjHq+U2jVpwDOVQaFICgNGhSN
         xn6rqEioYQukZCfLg9Nk4VVg9w1l/G9hXC+oSfgbxnhBUT3WvH0mOIZSLDr/Dv5K0dwe
         uxuFYgFGqJkq4hIkR82MwjHeHAx2VIVnClBTn76uYKATki6wGWU4RjyCpKV92qp1gZKe
         L29A==
X-Forwarded-Encrypted: i=1; AJvYcCXieLcjEWBFN1Gn3Cl+IN9CK55aMbgo5+Lo4++Ms43r3iUTgHUY/DWx/Or8yUTlPE/BRb18rJk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxo5yYckh2wrCkDkNZblpjS/qay4Wc2FqhCfthNSHKYM+5INHX4
	bdhEX1u81lOLQd5dVM8bxtJoy4aJkWN8YmCU02zH3OyDoD+owRT8eoY52cuEFChJPts=
X-Gm-Gg: ASbGncv0nE6UoV0P+yTLownubeWNy9KXqrk0HaOIedfAKbYe6x0cTyrdbWk+whKOxfX
	uhk8dcaInFvv7WEd+F4eGZ5/JW1rtw1ihiPwHrXYoHvCKRpGr5B48OeUkuVeg+6Zjj+xK8HdGNK
	aC3GZVwt2UE3D/3YtG9ptjhxTjE6uMs5bF68AVrC8R2XHX5pY/CjvQKOXvXjMNWCH2898S/1k4c
	P1i5ZFA8ia9EX5HqTEOYEq1LPskIy1qQIH/bXyyZLGAQpeUtWOsSbcpitOo/hcpD/tCmmMBvPD5
	Wa/lPS68RTMxMkGGgo7FFPUrkVxg+W33jr6M3c6uOrtDnLx8QV+60USXWGHJdT9giFQndbofvJr
	roZxAI1ptBvbMeQeqH5OTVV7rSQ0RgFCTp/Wi2w4a6fY9x+YmzHDHqGErIa4JI4k10gCc206tvi
	05jLXWhu1l9Oy0O1joWty+YDEtYpo4wJmtSI2c2kaLPsvqfyulVYBNGA==
X-Google-Smtp-Source: AGHT+IEMgQ5A/ngM4oB7aYVi/VQg/3amHDLzSn7jIdobyyplBkmG3dA8rWbfZr7EIB9azrG7yf2qjA==
X-Received: by 2002:a05:600c:1550:b0:477:a54a:acba with SMTP id 5b1f17b1804b1-477b9e1cbe5mr23604595e9.17.1763635424278;
        Thu, 20 Nov 2025 02:43:44 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b831421fsm40121035e9.10.2025.11.20.02.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 02:43:43 -0800 (PST)
Message-ID: <43427fac-db73-43af-bbf6-93bc3d978706@linaro.org>
Date: Thu, 20 Nov 2025 11:43:42 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: eric.auger@redhat.com, Sebastian Ott <sebott@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
 <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
 <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
 <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/11/25 11:10, Eric Auger wrote:
> 
> 
> On 11/13/25 1:05 PM, Sebastian Ott wrote:
>> Hi Philippe,
>>
>> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>>   Provide a kvm specific vcpu property to override the default
>>>>   (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>>   by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>>
>>>>   Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>   initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>
>>>>   Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>>   ---
>>>>     docs/system/arm/cpu-features.rst |  5 +++
>>>>     target/arm/cpu.h                 |  6 +++
>>>>     target/arm/kvm.c                 | 64
>>>> +++++++++++++++++++++++++++++++-
>>>>     3 files changed, 74 insertions(+), 1 deletion(-)
>>>
>>>
>>>>   diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>>   index 0d57081e69..e91b1abfb8 100644
>>>>   --- a/target/arm/kvm.c
>>>>   +++ b/target/arm/kvm.c
>>>>   @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>>   value, Error **errp)
>>>>         ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>>     ON_OFF_AUTO_OFF;
>>>>     }
>>>>
>>>>   +struct psci_version {
>>>>   +    uint32_t number;
>>>>   +    const char *str;
>>>>   +};
>>>>   +
>>>>   +static const struct psci_version psci_versions[] = {
>>>>   +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>>   +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>>   +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>>   +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>>   +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>>   +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>>   +    { -1, NULL },
>>>>   +};
>>>
>>>
>>>>   @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>>                                  kvm_steal_time_set);
>>>>         object_property_set_description(obj, "kvm-steal-time",
>>>>                                         "Set off to disable KVM steal
>>>>   time.");
>>>>   +
>>>>   +    object_property_add_str(obj, "kvm-psci-version",
>>>>   kvm_get_psci_version,
>>>>   +                            kvm_set_psci_version);
>>>>   +    object_property_set_description(obj, "kvm-psci-version",
>>>>   +                                    "Set PSCI version. "
>>>>   +                                    "Valid values are 0.1, 0.2,
>>>> 1.0, 1.1,
>>>>   1.2, 1.3");
>>>
>>> Could we enumerate from psci_versions[] here?
>>>
>>
>> Hm, we'd need to concatenate these. Either manually:
>> "Valid values are " psci_versions[0].str ", " psci_versions[1].str ",
>> " ... which is not pretty and still needs to be touched for a new
>> version.
>>
>> Or by a helper function that puts these in a new array and uses smth like
>> g_strjoinv(", ", array);
>> But that's quite a bit of extra code that needs to be maintained without
>> much gain.
>>
>> Or we shy away from the issue and rephrase that to:
>> "Valid values include 1.0, 1.1, 1.2, 1.3"
> Personally I would vote for keeping it as is

OK.

> (by the way why did you
> moit 0.1 and 0.2 above?)
> 
> Eric
>>
>> Since the intended use case is via machine types and I don't expect a
>> lot of users setting the psci version manually - I vote for option 3.
>>
>> Opinions?
>>
>> Sebastian
> 

