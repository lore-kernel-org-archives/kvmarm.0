Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFE921348
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 12:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035546; cv=none; b=cJdz/5dQnOm3YlBsaWicMD0IfPrR8MLR34ufCSCabwWJkFOqV+PXjwwhU3JqZVwbO3V4JIJSbs0tlPXxSSOwKaqJDILWPvVNTAUbiwMEwm1HWX/CXAo2EC0UjFsV4/tVXGIysKX7ezy/NrDtZzDz5LNRLYa86VNE5WDv6eBOfrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035546; c=relaxed/simple;
	bh=1DOX3pdOF+OPXzuS2flwxPO8UkmLiGftFIO4KEG+Lt4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XpVXliwC40IV9P+TRk4RYVdmgTigEK+Zj+lOt5qpXl3qrTQQ6/rBNqD7iwLK0YCVXDl49Gdo0Ie41rFs+odYqsrlC22W/LIs076gEwHQPDUz/xKDhSETe45pCpSCAmMcrGD+mnDqHNH0pWHCIVact1JqNaVBkW8TCKm2ABAt6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OfKJxU6L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OfKJxU6L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763035543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XXe30AvAgod46okaWpXEOT8NCg0lGaJYsjemG6fav+k=;
	b=OfKJxU6LumD9ER5gP2q9KKvqrhyzEEP18SHTIPns4cSkM9UfnDZYgob99IJmhWSw+pXlre
	RwBsp+MA8C+lWhoGHbR+4v9BiddM/SmsjzgBy1jrZxpwDxVFxJJgvPX3rai6KGLnALgYgD
	ti/z4gbwIVRJAp/sjdnMyFX7lgW/E2Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-UE7xjv4iM0CQSejIq7vxgg-1; Thu, 13 Nov 2025 07:05:42 -0500
X-MC-Unique: UE7xjv4iM0CQSejIq7vxgg-1
X-Mimecast-MFC-AGG-ID: UE7xjv4iM0CQSejIq7vxgg_1763035541
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429c76c8a1bso557158f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 04:05:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035541; x=1763640341;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tI2/OYtW6mgwxijeu2yFHVnaEg8ys2MTvM8mvkzh7dM=;
        b=uRBiiiaoLCAH1FtCTHvI5e4glf8mTQPU6fHtiJiiDKuX31wfrSqEr6LulSpNtVNBBD
         MvsYzmIBdcetD45RhfiUMJpEgGbsZP7TXX2FjDMy0KDzpZYiU8uox+/Lbysmp7lv+jVo
         uu184KSGNV7a8gFLrz/1SHP17X5z5LbGqqNNVlCn7qN5zDMfMORij1W1TCjB55XXEn/a
         NTZlztyk31TZSw0LjrHC6k8bdrVE83Civ0/IRp3i3ifGRe0EDCRaKP/4XeTvUpA+lmBt
         E84CD9gKPPw6g8NHFghlPwvE7PHlocvuysshsH7W472byFQwH/JSGj/iEdFepzigoawL
         wkVA==
X-Forwarded-Encrypted: i=1; AJvYcCX6U0wdY/iFuMasDlxait2zoaZDDuLl91Mt/wgzpAk2sIXNObUGlJZUzsoi/DgKAmA66Hmfif0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlUE2k01/S+eKpEvRchp6WId4vti5O0ZZFv3XxIH1KlM936wDH
	CK/Sn0PRvJgRzZhKb9PuRnzMM31mepLfE63pbLwdMjXPTvA/bV0KpjM2PZbIzbM0r9uajQ4hb9M
	pr27BtIPLy0B8Qcw98BsKM/9I2MkD+OAW+O6sm0wTL1EGip1TAvZMo2fSog==
X-Gm-Gg: ASbGncuzHYX7S9MKEccw/LF/uNFaYmLxzjgV3o2hyj/vvxHSXEiRtfwsSkpErqp4JUJ
	sRVn0QO21e+H7AX5X/EcWEDyniLIsGSEyCgvFz6oTO2fL4qjyOKU2auUs6TBKC6X95P6gOTtdvo
	0yc6SU0DtFaCs0ncQ1i20NylluhX5jhTR2mqJ6dkK/MtSihtj14ao+hLYBhg8KGkoGQ6nI6NJ53
	wO7bPLBD8sMA7LHJZYblTuHP59cecyvRXQ0KvdhQjRSs0PW1ragamYnMj7Rjo/hEIB1rkBeayxO
	GR+zgf9rWpsRUE7/mcuQoyItY9wbuxQWa4/5gkeI8mg5k3I9qJSQdTvuIuQnhNpB4v0+WxhxI+0
	Nv4dKfg9HxmvhZPWlI4S1zz0cDSL7ONEbq5OQZQgMi3Y3txZ+
X-Received: by 2002:a05:6000:1885:b0:42b:3680:3567 with SMTP id ffacd0b85a97d-42b4bb91b2cmr5895241f8f.18.1763035541153;
        Thu, 13 Nov 2025 04:05:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3IIBIBt8q03GbcoIy980NO1o7f47Eyz3eGrQw/lEHfvAJ2mJpS0tJ8SI1nFL6EYhPZo1J9g==
X-Received: by 2002:a05:6000:1885:b0:42b:3680:3567 with SMTP id ffacd0b85a97d-42b4bb91b2cmr5895217f8f.18.1763035540713;
        Thu, 13 Nov 2025 04:05:40 -0800 (PST)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f23a1asm3522001f8f.45.2025.11.13.04.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:05:40 -0800 (PST)
Date: Thu, 13 Nov 2025 13:05:39 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>
cc: Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Message-ID: <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
References: <20251112181357.38999-1-sebott@redhat.com> <20251112181357.38999-3-sebott@redhat.com> <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ffxXuG4PzMdyCXssvb0M_wWmq4xP-yAvfsFRZqJPJLs_1763035541
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-853068444-1763035540=:13840"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-853068444-1763035540=:13840
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Philippe,

On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
> On 12/11/25 19:13, Sebastian Ott wrote:
>>  Provide a kvm specific vcpu property to override the default
>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>  ---
>>    docs/system/arm/cpu-features.rst |  5 +++
>>    target/arm/cpu.h                 |  6 +++
>>    target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>>    3 files changed, 74 insertions(+), 1 deletion(-)
>
>
>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>  index 0d57081e69..e91b1abfb8 100644
>>  --- a/target/arm/kvm.c
>>  +++ b/target/arm/kvm.c
>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>  value, Error **errp)
>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>    ON_OFF_AUTO_OFF;
>>    }
>>
>>  +struct psci_version {
>>  +    uint32_t number;
>>  +    const char *str;
>>  +};
>>  +
>>  +static const struct psci_version psci_versions[] = {
>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>  +    { -1, NULL },
>>  +};
>
>
>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>                                 kvm_steal_time_set);
>>        object_property_set_description(obj, "kvm-steal-time",
>>                                        "Set off to disable KVM steal
>>  time.");
>>  +
>>  +    object_property_add_str(obj, "kvm-psci-version",
>>  kvm_get_psci_version,
>>  +                            kvm_set_psci_version);
>>  +    object_property_set_description(obj, "kvm-psci-version",
>>  +                                    "Set PSCI version. "
>>  +                                    "Valid values are 0.1, 0.2, 1.0, 1.1,
>>  1.2, 1.3");
>
> Could we enumerate from psci_versions[] here?
>

Hm, we'd need to concatenate these. Either manually:
"Valid values are " psci_versions[0].str ", " psci_versions[1].str ", " ... 
which is not pretty and still needs to be touched for a new version.

Or by a helper function that puts these in a new array and uses smth like
g_strjoinv(", ", array);
But that's quite a bit of extra code that needs to be maintained without
much gain.

Or we shy away from the issue and rephrase that to:
"Valid values include 1.0, 1.1, 1.2, 1.3"

Since the intended use case is via machine types and I don't expect a
lot of users setting the psci version manually - I vote for option 3.

Opinions?

Sebastian
---1463806286-853068444-1763035540=:13840--

