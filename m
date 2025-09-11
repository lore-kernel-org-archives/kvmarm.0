Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F6D236453
	for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 16:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609211; cv=none; b=Mt6yt+yU0QpKYbdicVgutAUxW7KZtRAyKP/9HAPFFjheLpo2sGmJht2frYnssHfocBzSfvVlylGT199UrBp5n/geXwG+Ii/FiA31JNa2mSmxGuBHVxhKokBz1zYYWUO9ew2t5yTQvU+Be2efV1OUnCBOm1FRnnuHjRNuuEoqQDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609211; c=relaxed/simple;
	bh=Qxo0B09NTnHspuzv4ArFG5GlK+5CwYc07R5WImThL94=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Rp9v+YItr/YkVqhgu5mRkcQAqVGFKuTeDAKvMm6mTe1yo2+fEOLIeyHBLYM8/9U2Brmf4gPK4Jr6bz5WoB9cRCvHZAdWpUrUll5VXAUBoZLN92tzis7dJxsg5kXfj+49JUU37B/f2ykdXhkT3l3A/oQQGL8eNBgJqJq3KzUID4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ftGUoPmp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftGUoPmp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757609208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NfLhSbNYEBMsg+7tun6uGQtYpAPcwFglJcubTMzrz7A=;
	b=ftGUoPmpUO7cfLQ7xvpKMOTvsJOCI4a2MknQYgWWB8Cjvhr+otXWUcRarvETtpwb8P1wEW
	HYB61xRftfyahkCWDXX0PuulpTeSAtnwElBnc13PqHMMvVJKI+5pf9m6dsOjfCg8cF5cbX
	CCNAzdxfzq3sQn0J/XjfQnCgi1/12yk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-Oq4pTnb8M2uMghDCUD219g-1; Thu, 11 Sep 2025 12:46:47 -0400
X-MC-Unique: Oq4pTnb8M2uMghDCUD219g-1
X-Mimecast-MFC-AGG-ID: Oq4pTnb8M2uMghDCUD219g_1757609206
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso5975845e9.2
        for <kvmarm@lists.linux.dev>; Thu, 11 Sep 2025 09:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757609206; x=1758214006;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NfLhSbNYEBMsg+7tun6uGQtYpAPcwFglJcubTMzrz7A=;
        b=Mf/gNl2oMMyrYByBOlmu/WRWe0L066mVDGPeCtGz5ErjudMd3s1+t3EWn1zxY9Zp8V
         LEzUhbBCeOSe6XzO6o+AoWNZnLH3rWV+TaylBkZ8FmdyUtfKRL54zLWvHAdYFDU0LkKO
         5uklQN39muhRrnQSkL34w2Zlyxqfy3t8HEw36gjzsAsWTPUF+LaND1ImFyeUOaq8TGnT
         FTMeWGoJ28u765fxQcqw/DRLk+xaupzritd9jqnBSGnVC3FcTOGXfGhkq5Korx0fgdHE
         GS49X/DHPFYt82S5Axu0uR6tUQOOf4D8bLkYZpwrx+uOXL+YHg7qw4Bd8vPhjAFDS50J
         W0ng==
X-Forwarded-Encrypted: i=1; AJvYcCV6cXbgYGyTHo64O79wgvu68Jq4DGY/TEmJ6x+fP5oN487wJ/Z3JaY4Pm3ROiEJbkoHBvoS8Qk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRmZsgk1IzvPcQRVYcVtGEeHAAX4b1Ptcwn3upxkUqBOS8mOga
	s8zmhgs9gvm2yDJbgnlHHY6zSNWjyccP3cG7crBIr+s9cmK654p7AfDOOfooXlR1UFH1hjGB0+X
	7exGRcdqqAR2YHFgi+zvp7UVcE5S6BW1bpSNif2fSb07APXRCoO5VIeMLBA==
X-Gm-Gg: ASbGncvBnRb9cH9qtNC5ZY2K9fz7G8on5r6VIOJ4tuYep0C5HEVcd5BKJkyEndDw6DU
	D/MKyhYzSC99AsCOkSElIZzhIeH0+qnBiOg9RBhnjp8P+DTF5vWfLuH9r5sGQ53qDmFyUOdAd1w
	gflREyeotePD+eLQAnErpFDDpsVL/STznsoysviX/XxUqUQDQzoe3kRJ/KHu4AYoXUzrVjfGAQ3
	UBt4U+OUQTZMiHcwg4awqeh1UoLfjd3e+E3ZflT/F1xlfQssE2dJEeqc9sipYmubD0lTu1sRmpz
	1vGdqIcFxEld5V+7M8dLE0hD0M2oCrMawwGdcx7UQBy3S0e7pSYHvbAf4MNlFuvso1PNTQcIjL/
	Bo0l8s5pjBjVL7g==
X-Received: by 2002:a05:600c:83cf:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45f21207be1mr1499095e9.35.1757609206250;
        Thu, 11 Sep 2025 09:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzF7xdwiuJNiKLKdPH1FNf4ped6tYssSHKKe16I6IF6tF5/rGaCdBMHdg5t+uJppxMHK84qw==
X-Received: by 2002:a05:600c:83cf:b0:45b:43cc:e558 with SMTP id 5b1f17b1804b1-45f21207be1mr1498835e9.35.1757609205837;
        Thu, 11 Sep 2025 09:46:45 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e04cf2870sm13652215e9.1.2025.09.11.09.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 09:46:45 -0700 (PDT)
Date: Thu, 11 Sep 2025 18:46:44 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
    Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Message-ID: <6f1eb1b8-29d4-cdcb-f379-9869d806a116@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com> <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com> <CAFEAcA8hUiQkYsyLOHFQqexzY3u4ZZZBXvi+DuueExGdJi_HVQ@mail.gmail.com>
 <3176813f-77c0-4c39-b363-11af3b181217@redhat.com> <CAFEAcA_ui7iyKx36fuhmOqizRWnNppb9B1iPc4nAxU2VnovMOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6_ZBvvJqg4w9uxCyyVBZtUgzwrt_-tmIQb6i4hCGx1w_1757609206
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 17:29, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>> On Thu, 11 Sept 2025 at 16:59, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> On Thu, 11 Sep 2025, Peter Maydell wrote:
>>>>> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>>>>>
>>>>>> This series adds a vcpu knob to request a specific PSCI version
>>>>>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>>>>>
>>>>>> Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>>> Alternatively we could limit support to versions >=0.2 .
>>>>>>
>>>>>> Sebastian Ott (2):
>>>>>>   target/arm/kvm: add constants for new PSCI versions
>>>>>>   target/arm/kvm: add kvm-psci-version vcpu property
>>>>>
>>>>> Could we have some rationale, please? What's the use case
>>>>> where you might need to specify a particular PSCI version?
>>>>
>>>> The use case is migrating between different host kernel versions.
>>>> Per default the kernel reports the latest PSCI version in the
>>>> KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
>>>> when that differs between source and target a migration will fail.
>>>>
>>>> This property allows to request a PSCI version that is supported by
>>>> both sides. Specifically I want to support migration between host
>>>> kernels with and without the following Linux commit:
>>>>         8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3
>>>
>>> So if the destination kernel is post that commit and the
>>> source kernel pre-dates it, do we fail migration?
>>
>> This case works with current qemu without any changes, since on
>> target qemu would write the register value it has stored from
>> the source side (QEMU_PSCI_VERSION_1_1) and thus requests kvm
>> on target to emulate that version.
>>
>>> Or is
>>> this only a migration failure when the destination doesn't
>>> support the PSCI version we defaulted to at the source end?
>>
>> Yes, this doesn't work with current qemu. On target qemu would
>> write QEMU_PSCI_VERSION_1_3 to the KVM_REG_ARM_PSCI_VERSION
>> register but that kernel doesn't know this version and the
>> migration will fail.
>
> I was under the impression that trying to migrate backwards
> from a newer kernel to an older one was likely to fail
> for various reasons (notably "new kernel reports a new
> system register the old one doesn't") ?  Perhaps we should
> think about the problem in a wider scope than just the
> PSCI version...

Yes we already are ;-) See this series from Cornelia:
https://lore.kernel.org/qemu-devel/20250414163849.321857-1-cohuck@redhat.com/

And this from Eric:
https://lore.kernel.org/qemu-devel/20250911134324.3702720-1-eric.auger@redhat.com/

Both will help mitigate register differences for a backwards/downgrade
migration.

Sebastian

