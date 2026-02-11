Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106B13C0C
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824265; cv=none; b=ntBovIIZLIQEG1AnqsAAogvn+uFeB4zXf52nFkADV/wl7azBAMCJPWrq8O5o/ebmuZsm/p6AygzrJ4rmPz2ba9S5MYcxG7qsRVUyKpGkDBHxAxafXU5barjEJBHQJz+o1eOCO4M4bpXK9qOrKMHDGWkaPoZ7CmI8OGB9eiLZnXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824265; c=relaxed/simple;
	bh=xHy9RX/mmBJnwO1e26QwOS7d3Cg1h3No9+gcl/OXM+E=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rKyeT9XllEN9ymshU9ACZZtYYL5Y6amhMc7exEMNgkaV/OOnd6wquga0mH5l6KxDBkr8t0PgtxuGFmpLT5MUIM42E5z970tjJKrX62qzjEaJcIh8MJrh5EtpBZXbLwFtFOf4pN72fIcPX154+r3jCLoV3H+CKwe79nM4drK3WTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ffGQCWvN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffGQCWvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770824263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0t2ls4USNVIXwkkL2q2g6u6o8wxKJkSwfzOXqzXvmPo=;
	b=ffGQCWvNQtGKImm9wsfCppiSQC6wT4qrnZsLz4kcFl0P8xogq3auFpLN0Y6j52EdTmLbrU
	Pnm7omW73Y8orORzbHllMia9tz8lWbKRjz4JecCFeXnxUUfdtkEu1RKFIKNZzGLzqdiZHd
	sSJjD2YauiX+J1y2+xQg8hDB0WzvhmQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-H-vuNOPsPkSVb9W1I_J2vA-1; Wed, 11 Feb 2026 10:37:42 -0500
X-MC-Unique: H-vuNOPsPkSVb9W1I_J2vA-1
X-Mimecast-MFC-AGG-ID: H-vuNOPsPkSVb9W1I_J2vA_1770824261
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4806fa4a180so49171545e9.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 07:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824261; x=1771429061;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0t2ls4USNVIXwkkL2q2g6u6o8wxKJkSwfzOXqzXvmPo=;
        b=XoUh9OPNP8Cx50OsxdjQQo/gRCjVHJ56PhRkM6Odyl5NEXpAeE2FgmhWlKgXF9IM4W
         L0srS81n/uNv1yDwKO3y8j0ej1i82tX9jm2BdMeB6awxF0qWG73u7JeCvKdnAghgjxUH
         ieCf80oeoVQanGFIwNiyt6xQQiiA3JpBTzFuCu518DZsu4bTKBiF2cgcJBCtwuDfFBzn
         GKcml/tGx6nHwYoghNfxA0PBIj86t74sKux4PXVqUTs70qqQoHcW97huD5YKdSB8RXIl
         eaYuxWlU5fneHGRD3p8wZ1vhnNWe4GUxseJUg+IqXrlZpuEc/ATDKGHffP62ZtXE/xij
         btlg==
X-Forwarded-Encrypted: i=1; AJvYcCUnNBzxJsK5sOHtcAoei228ZwyWIqQ+tWMjS+sMK/f4x3g4UgP/xUirMWnDgTiDtl0ppoJrwDk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRPffoKC6cdKzanNVuTK635a7YiGSQ9+fkNDEcd76Cf13E/F7s
	/XpTAcYqRlzwC73XVBc5lLtnM8d7sO0X/LYDNufJ5Tk46OqxW28Px7hstJ7bLmhuKaHMetPTe5n
	JttFCuvkqlj8JjdQ5kAcQmILTMoun+lf9TejRS+Kiojf+lypo+WfEN5iIoA==
X-Gm-Gg: AZuq6aINT8qqM57P1GPQ9Z4E2SX7FXpEs4MRjwSgFu20bPQHzS/ZTJ/3ajhGKj9eL/1
	bktdohYqa6Eni+QY9TNbmVtmWUU9MWH9duMSTTWW3mEVVxrrXUdtvC4R2cEhqpM8QcO8NN2Q9qN
	tXNvnzkoVWT5cgAwywp7jWds8mDjEFt8QyaemerW1oqttdblXuGLOU36SacB9eJAIv8wgtKGRZP
	rRGdek0VTDcEbNjaNOiQO183c+N8HJ93s8AfLPShOlJzm+mYGLzZ6WY04fpYIX77zPrrQc8eock
	LClI4STEdHEZOtTxSeVh5v1Va5qh7O+mHKDr/R0BMLeFtTek+9Z0TbXEwqNLYReksS9oco54wuW
	OhHwT8zB5dWYRpkCAeNF8SPhzLfCQQRsh9YVUgztoXNTE+7dh1bzlDHQJTZBAMTNNudsT9is=
X-Received: by 2002:a05:600c:638f:b0:47f:1a8d:4f30 with SMTP id 5b1f17b1804b1-4835b936b47mr41117165e9.26.1770824260599;
        Wed, 11 Feb 2026 07:37:40 -0800 (PST)
X-Received: by 2002:a05:600c:638f:b0:47f:1a8d:4f30 with SMTP id 5b1f17b1804b1-4835b936b47mr41116775e9.26.1770824260146;
        Wed, 11 Feb 2026 07:37:40 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4c4sm245868605e9.10.2026.02.11.07.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:37:39 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:38 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Message-ID: <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OuvF6p_2rV2D-SX5mIQq_8Y9WWybAvCpDls8eRrL0Mo_1770824261
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Peter,

On Fri, 6 Feb 2026, Peter Maydell wrote:
> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Provide a kvm specific vcpu property to override the default
>> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>
>> Signed-off-by: Sebastian Ott <sebott@redhat.com>
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst |  5 +++
>>  target/arm/cpu.h                 |  6 +++
>>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>>  3 files changed, 74 insertions(+), 1 deletion(-)
>
> Hi; this patch seems generally reasonable to me as a way to handle
> this kind of "control" register; for more discussion I wrote a
> longer email in reply to Eric's series handling other kinds of
> migration failure:
> https://lore.kernel.org/qemu-devel/CAFEAcA-gi42JObOjLuPudABX8WRdWf5SzSbkzU-bd06ecF1Vog@mail.gmail.com/T/#me03ebff8dbd8f58189cd98c3a21812781693277e
>
> Unless discussion in that thread reveals that we have so many of
> this kind of "control" knob that we would prefer a generic
> solution rather than per-knob user-friendly names and values,
> I'm OK with taking this patch without completely resolving the
> design discussion on that other series first.
>
> My review comments below are fairly minor, and patch 1 of
> this series has already been applied upstream now.

Thanks for your comments! I've addressed them all and sent out V5.


>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>> +{
>> +    ARMCPU *cpu = ARM_CPU(obj);
>> +    const struct psci_version *ver;
>> +
>> +    for (ver = psci_versions; ver->number != -1; ver++) {
[...]
>> +        if (ver->number == cpu->psci_version)
>> +            return g_strdup(ver->str);
>> +    }
>> +
>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>
> Is this ever possible?

Hm, not sure actually - what if there's a new kernel/qemu implementing
psci version 1.4 and then you migrate to a qemu that doesn't know about
1.4?

Thanks,
Sebastian

