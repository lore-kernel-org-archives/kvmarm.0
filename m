Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558134216C
	for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 12:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771589569; cv=none; b=hHhgRzc3HypN0Fa8zSA/ptiCc4Nw2cubtj7xKXitu+NU2QTjXGKwtRC8wnEm3X/TfTrELFnHXuzPLBqq2s2rWFEkag6d6rnVi/92aw5KjxDs+OmjQmJg2QL0l0eTJXJ7lFB117l7lb7RN+tU1a1wAATiYvIjfB+SSKAU2OwW470=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771589569; c=relaxed/simple;
	bh=nCHPyfglxdRriYc9YqLZ0QhFT6ATlTe18O5vbwZW1Rs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mWipTuzuXSdSDk8WG27SrMQbYLhWBHFKiiQQp4lYY2C2fZa2BrUbZUPRKGK2iZ5XDnT+1lHCCPb8JecsSn6pE6hHykIq3W6Af12MtiHdhhV57lcKor7J7UGgZBi6gihlx7qt77KGvg7u23GO95wV8YTABrzQ893cywEyABwRc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RQA5LcYi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RQA5LcYi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771589567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a6WnYkUv+1p2RXUoYer9jX6Ro906Av76rOQTzY8hn48=;
	b=RQA5LcYiquEiuV3yr6KMg2yaxT3olW/TQ6RsqCFzfL8+/8NESH1zoJHjifMq+hU+k9DBCV
	mSMA/AMxEz/c+6cSpI6MZRZJZGOcsvHDdfc32nZs53+pNi4dLZwHeSY9ihuBQbriOMOk03
	Z7ydDns6Sa6ltq0LqGRVpwYJ/BsNrEM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-8ERL5jaoPOmUmOpyGJGTZg-1; Fri, 20 Feb 2026 07:12:46 -0500
X-MC-Unique: 8ERL5jaoPOmUmOpyGJGTZg-1
X-Mimecast-MFC-AGG-ID: 8ERL5jaoPOmUmOpyGJGTZg_1771589565
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4836cd6dfe6so15838435e9.2
        for <kvmarm@lists.linux.dev>; Fri, 20 Feb 2026 04:12:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771589565; x=1772194365;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a6WnYkUv+1p2RXUoYer9jX6Ro906Av76rOQTzY8hn48=;
        b=Dl4zzmm5PJyv+nk9Tz5LJ3mtX3GowHxsGqhsi4JuetTD4qSeR94TXpkcXJwqrlQKYd
         7KMvBwdG+OO46UtsJuuixEjVs+ycjX09DgttEIpSHr7gktXsgXnDdyt8ZABbfKUAN85J
         Vmb6zCU0r4jGSW70ffyk/RMJQ5zDjX8mGBu155EOGCsgGqSDBD+5AHMRdKpHpcCJlbXN
         tgCDcnRJvLdIpIJSUg/PYKLoFgaFLgC5qGsU48XWr63apm8g33yPs+kgfU/BZE+H1EAu
         4rrRQzH+HBkP36owBfeL5+xMx/ClYLKPb1ReSahvD/D+ExXZvzX6QO6Xq0k43P//XkE5
         ne/A==
X-Forwarded-Encrypted: i=1; AJvYcCVqKgdcPk1Wn5CmwbCHbBOVvlDsgyXccmCrEVk4Fo1wQjVJXeMpiCRVpafft3kY3ex3SeZs7Bc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/sRuwHfQeKsmcO9QgqTK6NT4d/ADlYtpAKrViod4iNc4FKax+
	FScHrPs8S9kTcAUzqeBiZ6fRhyz+JgBqyKB3MwYbHDmlF3xWwnkPVvONsGSCAdVpa+9B/B9mlIp
	qOuzgnHIDo+XlCf8bt7KIeeVIjIdnfjpOauRrClmvbUaHI7C2kPEMElGRCw==
X-Gm-Gg: AZuq6aKwayzENGNnisW4yUdZoVgfrS/dLgNoU8uSPudRkSAc4UTjUHshT9vlLKbEaud
	R6UPzzPjTUWcWyKQS0sZkRQUEaVI79tPgUZF9s50kQfJIMxe2qD1TOLHkqzYMVnuxxppdBtF3lM
	P/Y4KUN2LSdsVT5qoGZAaIxDvo5qtb98SdesEbY2rLtUSrH1vFH3KymSSaEXMV1PuSn2G2cAj7d
	ZEMlSmOHmpK/g+8qm+fQ5erbaTSjAXciNPjDG+EWL6Mx+JYKB76RpHGHrX9NOcKbi7F56yXiFmG
	o6NZ/91Ch2xahLiS1DHmA+9TkPH1+RSz5NNsHyXg/JET/S4QGuqKSqqYJ6ibpfrBbPYrLkKxcnz
	qPJg6v2bT9/OsspbGTZOOdPHdGdNImWx49jIdm0+w38khCkKbAv3BgeqI6SaUBibLohKoMTs=
X-Received: by 2002:a05:600c:5491:b0:480:1c2f:b003 with SMTP id 5b1f17b1804b1-48379bfd732mr370818665e9.20.1771589564988;
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
X-Received: by 2002:a05:600c:5491:b0:480:1c2f:b003 with SMTP id 5b1f17b1804b1-48379bfd732mr370818155e9.20.1771589564568;
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316eb08sm77575655e9.0.2026.02.20.04.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 04:12:44 -0800 (PST)
Date: Fri, 20 Feb 2026 13:12:43 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
Message-ID: <a4fffa2d-119a-cd78-44b6-b0c53d873833@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com> <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
 <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com> <CAFEAcA8V9bjQUzUYAW7qj5fEn_f9xaPJAYpTRgvdaFq0cY3pRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kKzl9egkgpw3sF90JI4VvEEitFMnfCJQvUgyX2UYE1E_1771589565
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 16 Feb 2026, Peter Maydell wrote:
> On Wed, 11 Feb 2026 at 16:04, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> On Wed, 11 Feb 2026, Peter Maydell wrote:
>>> On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>>>>
>>>> On Fri, 6 Feb 2026, Peter Maydell wrote:
>>>>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>>>
>>>>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>>>>>> +{
>>>>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>>>>> +    const struct psci_version *ver;
>>>>>> +
>>>>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>>>> [...]
>>>>>> +        if (ver->number == cpu->psci_version)
>>>>>> +            return g_strdup(ver->str);
>>>>>> +    }
>>>>>> +
>>>>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>>>>>
>>>>> Is this ever possible?
>>>>
>>>> Hm, not sure actually - what if there's a new kernel/qemu implementing
>>>> psci version 1.4 and then you migrate to a qemu that doesn't know about
>>>> 1.4?
>>>
>>> Oh, I see -- we're reporting back cpu->psci_version here, which
>>> indeed could be the value set by KVM. I misread and assumed
>>> this was just reading back the field that the setter sets,
>>> which is kvm_prop_psci_version (and which I think will only
>>> be set via the setter and so isn't ever a value the setter
>>> doesn't know about).
>>>
>>> That does flag up a bug in this patch, though: if I set
>>> a QOM property via the setter function and then read its
>>> value via the getter function I ought to get back what
>>> I just wrote.
>>>
>>
>> Meaning this should be something like below?
>>
>> static char *kvm_get_psci_version(Object *obj, Error **errp)
>> {
>>      ARMCPU *cpu = ARM_CPU(obj);
>>
>>      return g_strdup_printf("%d.%d",
>>         (int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
>>         (int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));
>
> I guess we need to define what we want. Things we need:
>
> - user/QMP/etc setting a value and reading it back should
>   get back what they set
> - QEMU needs to keep working on a new kernel that defines a
>   new PSCI version in the future
> - user reading the default value and then writing it back
>   should succeed
>
> Things we might like:
> - ideally the setter would fail if the user picks a version
>   KVM can't support, but I don't think we can conveniently
>   determine this, so "fail vcpu init" may be as good as we
>   can get without unnecessarily large amounts of effort
>
> I think this probably adds up to:
> - setter should accept any a.b value (for a,b fitting in [0,65535])
> - getter can handle any value and turn it into a.b
> - make sure that setting it to an invalid value gives a helpful
>   error on vcpu start
>
> Doing it this way, do we need a separate cpu->kvm_prop_psci_version,
> or could we directly read and write cpu_>psci_version ?
>

Thanks for your suggestions! I've implemented them all and sent out a V6.

Sebastian

