Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CD033A015
	for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 13:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763644305; cv=none; b=WcVcUDVRp2a3n5rE/honQuRu8BdsOz9Sywop37xNMbiDjpIlj4rl7yMn16sRzFdcktsf67c4hdGoijVvbjSYPv30HpqEJfq3UjrefdJ0IJSEGzBVlnUzpBAu/32tkftmG5PMPa1LAuBXbsXhkAATKQsg/c0+k0QfU1dgLRCDh/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763644305; c=relaxed/simple;
	bh=EMzTjSiW/fV6SRrNUbhLwgiLWZOMqj8RZCFA+JXh2VE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hFsomTxTXY50QQGJxAPGbwWgdzwN6fuAmkNMCCkQvTq3QaLv2p994SCXb1AfFyqhWqIBfKn4qSzQE9jBjPVGp1KZF5T6GnToNGUkst5Cpd/MyeWgpQXj0XljtsctlebiI/nbaqv+BaRmxCeTed2lOvnsVRrCx29JS2u/ml4XmyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EWvycMwe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EWvycMwe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763644302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lNokjBKS+boqENyu8vDvamOumJO+uz2YwBPpi6H3N6U=;
	b=EWvycMwetzpW1UqQ9bh7Xv9tGjGGSPl006jaV+PN+oQh0t/q594PyKXw8GRgEqtAPgkuEc
	w9oyDgJgp6fcaybqk9osimkMwyhHJR2UiXCMQwGqS0aWhDgy7Q6FSXwdhbNLMibVXaYm4t
	HT3QbgCuRCV43WGXV1ZD4jz7rNypq4k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-5vcd6QMsPdWRLFcWHXa-KA-1; Thu, 20 Nov 2025 08:11:39 -0500
X-MC-Unique: 5vcd6QMsPdWRLFcWHXa-KA-1
X-Mimecast-MFC-AGG-ID: 5vcd6QMsPdWRLFcWHXa-KA_1763644298
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4777b03b90fso5429575e9.1
        for <kvmarm@lists.linux.dev>; Thu, 20 Nov 2025 05:11:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763644298; x=1764249098;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qyhhdzn0BYMbkUVey/n2YMFPr5fhLGbTZAGvpz5pi1c=;
        b=NGZ+KhShAosRaulDYYwfZARgArE6qG9Rf64SzLPZrr6NinSTO1m8b2g8m4BlsodMPv
         vBBjttiRENEPwnOYNMWF1LcfMau6QoWkAm1cbgfxY51kpGy/9slaUeCXR4z+Z7nOBENY
         OABVBCH8UGzWoWcIWOm6LPR0mx3RH1+B9GJEXmpkawDQYlKtFqyfF6EXkcrvRL1zPZuU
         Ss2AG75TJjMr6St0Q/75I4OOk0zxUf7ExBbI6pHjN5nAdOBRmHcJgQWZ89We3v1pTSoh
         VEIq8Qsd85BFid/xGQdHORqmKUBV0GmeRGDQLNzeFsI04R6wujpqzIhyQK8jSW/grhgy
         +mLw==
X-Forwarded-Encrypted: i=1; AJvYcCUzkFebCuLBGIjiTwoxsYZ7vx/tCV9aU6Yw5QYZBKyRpKzjL7OipjaSvZ/IExbnzRyzY+PEnBQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywcs2VTYPUQkZhKc35YSHRObJJzMkIsfMfZgpzqEYg+VdtJ0P5N
	QjXMFvWUfvcw6nCeRfeJjbwIX7dneZuc4dHeUJ8xXdfTVcTkHGGjF4ksXL0sn6miqqVIXYwRXDQ
	4R8Oz57HefkoSmCUwpPbTz4D2bSZ9bnn+Bc0+I7yEhKTGfqsr8Kud9yriQQ==
X-Gm-Gg: ASbGncu+1uZQjfpNMwGc618tUuKZUF6V7uFutaWovafIS8Obm0J0/QDd2FQdPsMvGMN
	5a1Ndz8xKYlu9VbZsi7GQz1Y/5gtvERcZSXxENyNsXGoI0rPQt/wRU21Oi766xq0aWB/335uUqo
	5oWXj/uzk1BYI0Uc9h3/VdtvhvNaCfPPLtH1SQ8oxwEg0euZO8Y+w1G+ihLIkiMqzo1unlNxrTU
	vscWcYZh1f5nFiA5ltKN8RomhuAYLGbTXFIQ301Mk9gZ5ahgz/VHPLWtsGR50bbVj/Fi0RIu9ud
	Ui65wIoBAVpOafXBpuvjBy3KRhckk0raJr/vEwH4lcDAvO3ydgSncRsRCsgrIOatM0LPCJsJ6c7
	uQTOb4GZAtJ43b/yYpx0YL4orJ2GtyDytBeRu8daZo+LYvq2iVKKXwuU9eJI=
X-Received: by 2002:a05:600c:19cf:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-477b9deb5fcmr27550985e9.10.1763644298190;
        Thu, 20 Nov 2025 05:11:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqk0rLj6ifgE7tCamOIWPRaEiyBBbqDGCq1Uha6rrPDrmf26u75w870PL6lQD0kcpOCi1brA==
X-Received: by 2002:a05:600c:19cf:b0:477:7725:c16a with SMTP id 5b1f17b1804b1-477b9deb5fcmr27550685e9.10.1763644297761;
        Thu, 20 Nov 2025 05:11:37 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a974cdc8sm67987845e9.2.2025.11.20.05.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 05:11:37 -0800 (PST)
Date: Thu, 20 Nov 2025 14:11:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Message-ID: <8c679736-a168-0a33-e44a-4367e9e7b8d4@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com> <20251112181357.38999-3-sebott@redhat.com> <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org> <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com> <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kE8GZCjv6DJ19qPmPnko1Pd7VUgr1h_isnnxJFL3ef0_1763644298
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-370073406-1763644297=:54158"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-370073406-1763644297=:54158
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 20 Nov 2025, Eric Auger wrote:
> On 11/13/25 1:05 PM, Sebastian Ott wrote:
>> Hi Philippe,
>>
>> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>>  Provide a kvm specific vcpu property to override the default
>>>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>>
>>>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>
>>>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>>  ---
>>>>    docs/system/arm/cpu-features.rst |  5 +++
>>>>    target/arm/cpu.h                 |  6 +++
>>>>    target/arm/kvm.c                 | 64
>>>> +++++++++++++++++++++++++++++++-
>>>>    3 files changed, 74 insertions(+), 1 deletion(-)
>>>
>>>
>>>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>>  index 0d57081e69..e91b1abfb8 100644
>>>>  --- a/target/arm/kvm.c
>>>>  +++ b/target/arm/kvm.c
>>>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>>  value, Error **errp)
>>>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>>    ON_OFF_AUTO_OFF;
>>>>    }
>>>>
>>>>  +struct psci_version {
>>>>  +    uint32_t number;
>>>>  +    const char *str;
>>>>  +};
>>>>  +
>>>>  +static const struct psci_version psci_versions[] = {
>>>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>>  +    { -1, NULL },
>>>>  +};
>>>
>>>
>>>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>>                                 kvm_steal_time_set);
>>>>        object_property_set_description(obj, "kvm-steal-time",
>>>>                                        "Set off to disable KVM steal
>>>>  time.");
>>>>  +
>>>>  +    object_property_add_str(obj, "kvm-psci-version",
>>>>  kvm_get_psci_version,
>>>>  +                            kvm_set_psci_version);
>>>>  +    object_property_set_description(obj, "kvm-psci-version",
>>>>  +                                    "Set PSCI version. "
>>>>  +                                    "Valid values are 0.1, 0.2,
>>>> 1.0, 1.1,
>>>>  1.2, 1.3");
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

OK, thanks!

> (by the way why did you
> moit 0.1 and 0.2 above?)

Just to clarify that this is an incomplete list of possible values
that we don't have to change when a new psci version is introduced.

Sebastian
---1463806286-370073406-1763644297=:54158--

