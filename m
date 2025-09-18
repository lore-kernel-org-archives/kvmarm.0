Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0A23BCFF
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758205509; cv=none; b=GjwRyFAcJAjLsRK8eBxPjOHP3dbw6VJ0amzwkigcDDvBroaOo0l0l/z4AuhzF2m2VGzbW6GMf7B1iJngSmjfenoyykXnsr+1CcYOi7ydktmLiCB4tPMQQ+ETDVBugnGK4/unm8bFctVNKI8dLRMS+tSTCMdrikqKJXaXyCcwQe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758205509; c=relaxed/simple;
	bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwqSx+Bbbsel+8aIzGU4Q182NVKKRkWrc4DNt/j7LHUaWND0hExhtUkmG1sPG9u4vN7DUgcFgDqobSqOqI+YSp1KdonFMcHgpQZGJ1y6E7DdWKXPH5TnZbq97ZDLnybXqN36O8944rrPDmzgb9gU6hG2EWp/4T57ByuyoyxVi8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5phJxfR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5phJxfR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758205506;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
	b=K5phJxfRtqXxYOZo2w3t9X2iJWuTHaedtnfT/aFyEsn/gHQAXQFmpdKhXDKripa9UKPMEp
	OXrHz5FpxPKHNHl71C86T+uGP55T2VhySk/abJlR75BPa3i4O4Pa74F3BbGfjGxadLLTPV
	7v89JwYsVcpW4j9fb/7o6UnEsUBKIWs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-Jxx4_e3FOnW_hc5NDUt_FA-1; Thu, 18 Sep 2025 10:25:05 -0400
X-MC-Unique: Jxx4_e3FOnW_hc5NDUt_FA-1
X-Mimecast-MFC-AGG-ID: Jxx4_e3FOnW_hc5NDUt_FA_1758205504
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2c1556aeso3904705e9.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 07:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758205504; x=1758810304;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2G7vCS/dq3lMHpDvsFlhCHpysVPfG96RFQkuvStkzk=;
        b=BoukObeNAF3ravXFS5KrKj5uctLGS+XfFhuWdp9MJr4WuhLodIVdEgbPJIlzTUYIIT
         IOKt8IJLrvxItKRdgMgZWmBq+XrbYipZ/KHpUfuPzI9En/fiNpfKLfwsGL34sWrA7Rgb
         SFwRnytX1WbotizxOhFaNRtuiwntffmv41gcf4PQrOsVCpVgoc61YOXih0q9ZOV05E2n
         gkAUEiamcSNqGLvdg8kmWk/082Ku1fr37grKGrrSYEKIFcK20zp0DVaR3B36jQVFnn62
         zDPNRXcr9C3wdKL20V5c5JrebP0z9HfRVwui9PPoZ4JjuxAY67ffaR+VRdTI2QAqcV1x
         Z7PA==
X-Forwarded-Encrypted: i=1; AJvYcCXRE3JufkOwYgHSkLiBi1FpYXCmA5z2OjEg6mzvFXKFek0g93kDY7kqqTb/1OqJ25feVd0rP+g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwM1zqEnKmGBMHeHV/Sd557eh6YYMsPUrglCJvq5aII1Ck8A8/s
	BKS0z4x/J2LDf7lHe3AnAHYxDwQmjvdb59Azjz29aAdEahA+mgukNVizRXrycs4YYbx4vabTF0h
	LUrJJR2du6WRCuJzQB7DVLRUCopSWGIzXjLjINA8af3pBX5opGgLsms8xOg==
X-Gm-Gg: ASbGncv8qlMQE/lGa1C5R9WOhkBVE2t6IwMI6Ui0JJGzH33pLuULllQLt730LjS4ix+
	02edjut8KNebZ4gqlJOSkiUh1aLufyux/gn0+4903dpLtrMlO1Tn6RzAr13v0OxF4LqLTWb2uoI
	Vk23qoVK+7+ra7SbEdyHKoinkUk6QSuJ63bC+PaIwQYlQILpHcrIX2xckWl2Cin4x3FjGNn0oXG
	7pqcba3YyvFVbZMKVZCISVrJb2229AN+xbzHPFZqfcdiWzGWhZ0cWgqIi8hW4be3L0u5iTCzbiP
	ueLgFtdsWHBG62tU7cntMw7YEJm2ch8J1CNq/31kJ4x+VsZ00244bR5ub00sqmIGWc1kBbNf0t+
	eaPL+2+KF354=
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr46109975e9.36.1758205504156;
        Thu, 18 Sep 2025 07:25:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMq4Lq58qPJkEx6oekmJdG1VjWks1gpE5xrvTqloRglPEvekf9jxRLASR2o5eHIbj094/fAw==
X-Received: by 2002:a05:600c:4eca:b0:45b:79fd:cb3d with SMTP id 5b1f17b1804b1-4634c528acamr46109655e9.36.1758205503707;
        Thu, 18 Sep 2025 07:25:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f64ad359sm52761595e9.22.2025.09.18.07.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 07:25:03 -0700 (PDT)
Message-ID: <60b78889-79b6-4efd-aacf-48e7b9456db2@redhat.com>
Date: Thu, 18 Sep 2025 16:25:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Cornelia Huck <cohuck@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com>
 <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
 <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
 <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com>
 <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
 <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cZva023GYM7Cwi0fjfpGC6_X1cV9Mte3B2tqoUPoH4c_1758205504
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Peter,

On 9/11/25 6:46 PM, Sebastian Ott wrote:
> On Thu, 11 Sep 2025, Peter Maydell wrote:
>> On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>>>
>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com>
>>>> wrote:
>>>>>
>>>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com>
>>>>>> wrote:
>>>>>>>
>>>>>>> This series adds a vcpu knob to request a specific PSCI version
>>>>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>>>>
>>>>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>>>> Alternatively we could limit support to versions >=0.2 .
>>>>>>>
>>>>>>> Sebastian Ott (2):
>>>>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>>>>
>>>>>> Could we have some rationale, please? What's the use case
>>>>>> where you might need to specify a particular PSCI version?
>>>>>
>>>>> The use case is migrating between different host kernel versions.
>>>>> Per default the kernel reports the latest PSCI version in the
>>>>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>>>>> when that differs between source and target a migration will fail.
>>>>>
>>>>> This property allows to request a PSCI version that is supported by
>>>>> both sides. Specifically I want to support migration between host
>>>>> kernels with and without the following Linux commit:
>>>>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>>>>
>>>> So if the destination kernel is post that commit and the
>>>> source kernel pre-dates it, do we fail migration?
>>>
>>> This case works with current qemu without any changes, since on
>>> target qemu would write the register value it has stored from
>>> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
>>> on target to emulate that version.
>>>
>>>> Or is
>>>> this only a migration failure when the destination doesn't
>>>> support the PSCI version we defaulted to at the source end?
>>>
>>> Yes, this doesn't work with current qemu. On target qemu would
>>> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
>>> register but that kernel doesn't know this version and the
>>> migration will fail.
>>
>> I was under the impression that trying to migrate backwards
>> from a newer kernel to an older one was likely to fail
>> for various reasons (notably "new kernel reports a new
>> system register the old one doesn't") ?  Perhaps we should
>> think about the problem in a wider scope than just the
>> PSCI version...
>
> Yes we already are ;-) See this series from Cornelia:
> https://lore.kernel.org/qemu-devel/20250414163849.321857-1-cohuck@redhat.com/
>
>
> And this from Eric:
> https://lore.kernel.org/qemu-devel/20250911134324.3702720-1-eric.auger@redhat.com/
>
the above series especially handles a class of migration errors where
the source host kernel exposes more KVM regs to userspace than
destination host kernel. In that case, currently, the vcpu state cannot
be migrated. I should have called that: mitigation of* "failed to load
cpu:cpreg_vmstate_array_len" migration errors. Sebastian tries to handle
a change in the default value of a pseudo FW register. We would like to
have a compat to keep the old value for old machine types. Thanks Eric *
>
> Both will help mitigate register differences for a backwards/downgrade
> migration.
>
> Sebastian
>

