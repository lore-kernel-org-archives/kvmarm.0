Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B825486D
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761649261; cv=none; b=Tq+lw8AOk2R9/pgcZVhkFm9WFgFeb9nps27GtSfE1ZbJfMiUkNy7PTcLEwyXHMNgmHQLWFLBO72DP63bnwJlKV1Zl85SNv7yjxBRWBUob3glCC6hGMaK0KK5itGsRWPEUjSroPLEsZjoBSIj5TtNZmJp5+CIB286pGg2MC30HS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761649261; c=relaxed/simple;
	bh=TBcCwBBiRefOxaueoN9Psch/bKtJhqoQamxX5KSEkKc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rycqheDQ6rHyMKMC0mdSCRosP4qHCP1vxSj316iam64TXAC19u779oFdblHJWaXceigmhP488C8wlR36vLYtYBM5mcu0tA2CeplcrSdF0z0fILgZssgKwSjk4D2ZsbOQgv8bAuNIkIGbMLkZpMzes6WgQ59QnUTVhs1D99N5AME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6q9WV3+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6q9WV3+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761649259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nxmOHwHxmZMLpzf1uqdrSlEJ/+f2PvodAb00eauIdqA=;
	b=d6q9WV3+KdAkJcCjHcSyEAt1iybIs/nSuGocH8TX4DrMDH5L0TrtALJFPJNZJirzlisZeT
	yUH1SwjryOqpvCqQXdLbksx2O09iPFWT8oCykpfC1E9ivIXaJ/PUo2y/7ZMnU8rKc9ObpU
	sIZagfyqi8Pw7pNmDN8ovsmZpy2DhBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-ayo0arKzMgaavKqlV8VdlQ-1; Tue, 28 Oct 2025 07:00:57 -0400
X-MC-Unique: ayo0arKzMgaavKqlV8VdlQ-1
X-Mimecast-MFC-AGG-ID: ayo0arKzMgaavKqlV8VdlQ_1761649256
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471001b980eso36573835e9.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 04:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761649255; x=1762254055;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxmOHwHxmZMLpzf1uqdrSlEJ/+f2PvodAb00eauIdqA=;
        b=nu7RR2c9hS9x0B0KCjIwzH/yTcwK519rpRJfWngX+Es0sjkJx2scPqYbYtHotpRk+a
         n+e4u9MpF/XIPod6MNFgKPqreRisSMSS0OqsoJH0Sq5heN5COZGnw9nJTZm5TkAbOMQU
         naBT/up1vQ+v7T/q0srTRldutTk4zMtrKmdaFyuoqUDUA/YI0T90aoIjqYUMqDxIhzt5
         XuVrROgfc++Qfwix7CdOwOotqcM8Mj+2IA+iM1ThgFserfHmndgt0TAjZZBkbB3FDIbV
         nkzs8h5ldKU1Z8sS7OihMjpZP07vse4/2p6LnhcudWC+QWFBTQ1yQJ/pXbzjAQ+Yp/j6
         s1gw==
X-Forwarded-Encrypted: i=1; AJvYcCX6j5V7/cXk2KolIZSiN0oWcY2jrTc3AsZ9leMhTZupdEZ7q4o4+r/PcPh1VsKGEeKaDVhxpMI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlZwondLpxTYyGA01//N9vR7M11HWAQahhJuqjIiThT/r7lRI2
	7TSH1GT3Oj1DtXQ8ycgDYWl1duyCQ2hnXK7xBdwf1ROgoSC/jCEYw7oepKU0h22We/ZL34MVjEH
	zKOsNJhqF1n9KjDcpxtB4jzZGuUGjNIWUIhV6F8HQA1e13vUwXfajQn+qsw==
X-Gm-Gg: ASbGnctJp5Ke2DpxNVqL4PqsxSY5+ImXE4dFiqeOW90qp62AMBkvuqG4csX+3M7cEG9
	LSb0t7xe/arENaEcyrkmQb5p/aRfe86uhsnCecv3Kez5KWcJmsYOmJe5XapUtOqugMrd/bfCOh2
	sOsZtSfZvpafQxdYtwcz5hrhIEB2MZnqR5A5Waz3BYpV+iZOJ4KPHRUFZr7IerLRfmlPFoB/ztD
	qoUSKyRhc7Pv8CCTQvio2Z5pp14xp0K1qfSWI30yhOR7mgS+27XFwKSR6LoJMsFBYzJ+NRgL6FN
	jM4KdXROMS0ifCqfLsNRNs+YoNlEoHdQOT8GUzwIyMsaUp6a3xQMVQWhzb3vVX+ZPEclIgv4TlS
	QjW0Vwop3b3Wov8ahRuhS3GMYZNLeGaqgDtVe2+7VFKIieIFn
X-Received: by 2002:a05:600c:3493:b0:46f:b42e:edce with SMTP id 5b1f17b1804b1-47717e67cd3mr23266985e9.39.1761649255552;
        Tue, 28 Oct 2025 04:00:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFFVAEQZBrj6XxR1esAB3vvNknSrAGxc5wuX0loLWB2sKQiYoi+ajmuIkxNcYXcTJ8iSZx7ug==
X-Received: by 2002:a05:600c:3493:b0:46f:b42e:edce with SMTP id 5b1f17b1804b1-47717e67cd3mr23266575e9.39.1761649255026;
        Tue, 28 Oct 2025 04:00:55 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd48942dsm192647185e9.4.2025.10.28.04.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 04:00:54 -0700 (PDT)
Date: Tue, 28 Oct 2025 12:00:53 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Message-ID: <ba03c952-e567-eb2b-f4c8-b1818ee127d6@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <20250911144923.24259-3-sebott@redhat.com> <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: X4xJUEkPG1fY1-V65l97WbtLGRZEaa21pXTJnVlFjCE_1761649256
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 27 Oct 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst |  5 +++
>>  target/arm/cpu.h                 |  6 +++
>>  target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
>>  3 files changed, 80 insertions(+), 1 deletion(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>> index 37d5dfd15b..1d32ce0fee 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>>    the guest scheduler behavior and/or be exposed to the guest
>>    userspace.
>>
>> +``kvm-psci-version``
>> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
>> +  PSCI version emulated by the kernel. Current valid values are:
>> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>> +
>>  TCG VCPU Features
>>  =================
>>
>> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
>> index c15d79a106..44292aab32 100644
>> --- a/target/arm/cpu.h
>> +++ b/target/arm/cpu.h
>> @@ -974,6 +974,12 @@ struct ArchCPU {
>>       */
>>      uint32_t psci_version;
>>
>> +    /*
>> +     * Intermediate value used during property parsing.
>> +     * Once finalized, the value should be read from psci_version.
>> +     */
>> +    uint32_t prop_psci_version;
>> +
>>      /* Current power state, access guarded by BQL */
>>      ARMPSCIState power_state;
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 6672344855..bc6073f395 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>>  }
>>
>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const char *val;
>> +
>> +    switch (cpu->prop_psci_version) {
>> +    case QEMU_PSCI_VERSION_0_1:
>> +        val = "0.1";
>> +        break;
>> +    case QEMU_PSCI_VERSION_0_2:
>> +        val = "0.2";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_0:
>> +        val = "1.0";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_1:
>> +        val = "1.1";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_2:
>> +        val = "1.2";
>> +        break;
>> +    case QEMU_PSCI_VERSION_1_3:
>> +        val = "1.3";
>> +        break;
>> +    default:
>> +        val = "0.2";
>> +        break;
>> +    }
>> +    return g_strdup(val);
>> +}
>> +
>> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +
>> +    if (!strcmp(value, "0.1")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
>> +    } else if (!strcmp(value, "0.2")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
>> +    } else if (!strcmp(value, "1.0")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
>> +    } else if (!strcmp(value, "1.1")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
>> +    } else if (!strcmp(value, "1.2")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
>> +    } else if (!strcmp(value, "1.3")) {
>> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;
>
> We already have six values here and it's not implausible
> we might end up with more in future; maybe we should make the
> mapping between string and constant data-driven rather
> than having code written out longhand in the get and set
> functions?

Yes, sure. I'll send out a V2.

Thanks!
Sebastian

