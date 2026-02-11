Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BFD332911
	for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770825872; cv=none; b=jl9rhgAHifbk3ZPy76M4SGogK+OEgv3spUA1AzIdt28/eI6Yr2FfA+ieQ3b9xR8pw6E1F0bQQ7hbA6WxJbU7GN8uiAcrQrVT3LahFWwSuhtHk6esUcqtmwvICxMRKnCOraeu38CO7KRTpoG2y5PvQi8C0HLavO29xsapgMf+jSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770825872; c=relaxed/simple;
	bh=EUVf2wna+dYhtI7Ucp0MB7m/uxN4DU5He2QHJ0gJeQQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lcM694wiOPEFMu0f6qFoX4fMJ7onY5Y1HOgOH9KP/Y5Tr6RQDTZkIQyTTjMKHEwzcBpGIHHuXdFFMQV8Lzgr6GDriB4+wKM+leRIpluqjUiHp1hOXS4mEPAQw9+nxM+vAWLusNUI8kZI+241oXIeLaWxAsTa3szevKw77ziSeo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVQus8uq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVQus8uq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770825870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5KpC7yaqnmPgfObvDWEmIArdNjIVjuTr6fFxuFr8Hdk=;
	b=FVQus8uqgehpxXP2IYKnvBMGDF4XTCcAP8/TKS2qmaaNsAqxKjJys3OxMYn8GQfGduQ4wj
	uDZn/u7SCVer1Ld4BOfHT5oAr4uVOgeQadZjULcrzblRFtcS45OdIaAcRX+xyANAw7a5ZM
	qFH6Wl0Jn2UKWr1x/BEQXIv0BNoaGFU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-ms2Cv5mLO_KR7gwXGSaknw-1; Wed, 11 Feb 2026 11:04:29 -0500
X-MC-Unique: ms2Cv5mLO_KR7gwXGSaknw-1
X-Mimecast-MFC-AGG-ID: ms2Cv5mLO_KR7gwXGSaknw_1770825868
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47ee3dd7fc8so49595245e9.3
        for <kvmarm@lists.linux.dev>; Wed, 11 Feb 2026 08:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770825867; x=1771430667;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KpC7yaqnmPgfObvDWEmIArdNjIVjuTr6fFxuFr8Hdk=;
        b=aRFcwTmiRoEeT+OkRuaBBgsRmOmtQXx5jG8x6gA/tBOWQUlXFH/RsCrfDO7/K16OOC
         SIw9mj3Y58D4RNxXwsS2bL2HPvlEOhQosrjvDwajadQ2PkMXguzZch5AWzk/uIOmb7PS
         PLPAIiA1SUApzyr9ZQgSu2UnFCpGcLApARTFmUVme1wps+wkQcFFUqmi4ApUoyPpXn0V
         gJOgU73d4gnbcRZOwbYpgVt+5Tv//SYTWe8xphzECcvbkPrz+WQSJdDH3RkBYha7CVyT
         jEA2LiAF9MW43rubqYOmyqP+RqeQ1mJZ8kJJz/E85GTjuiuig1NCgA1L/wmjMW4Dz2Tu
         SgLA==
X-Forwarded-Encrypted: i=1; AJvYcCWQseHPOA3CkiToLKQeiNahTyy61O8h5o83F/dN698tyNE8lHcGVMXcU3QbUactbB5XLqJO/cw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFKdL+m7sQplGZrDsh56vngYiXmG0w4+2YVBr/kBc9isw6kXQN
	jG0S7Q5Sy2RPoXCTqFF6BnPZqDVRCtiwS3uJcUtdOYRVjLq9oD7GcenY6ygo1EK52sHt/51PEQg
	pHSSi7yi1HQ5MFMupkXIE2MdbKruc0lAdfWwdshJhbkSmNWRofY9I0NYM+psfiT3qKw==
X-Gm-Gg: AZuq6aKiiizp3S3l9+t8pQWYtupm+vRkYqB4COlhVgFzEMxv4JmnRoQ42rq0VGJg3LT
	sdt4O4/YpjC/biisdJ50Pnt0gkvhux4Piuf3LThocjpGLV4+U2ASc+cmBZ6tAx04gg2eeR4N9Gb
	eUdmNMp/vUIc14KDqn/lBhsHLTeNuCgk96L6m+2TMRPFn20hwO71vgDsUNu3U+9gaC1eK7Q6U7Q
	Bt/4aplnDqZjz995x8Krhoqw1Y3BGVhkYVmS55nEjow0oQ34PVxZ2FVR8HWyZqS5SWdAADAs1Gr
	Kbb5JdD2eGcSp7CoAx/lQA/tczQ+jvfyjZ3GLjqJIangqzSAFwCCtpv+x6j5iJ6gVNCRJR2xM/w
	06EQysRlbShUO0R361KfP9W5/BhvH0089/iG28r9KUcCdX6tYtLOPJto8GvtFTOhwe6tCagQ=
X-Received: by 2002:a05:600c:46d0:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-4835b96ec32mr36898585e9.28.1770825867298;
        Wed, 11 Feb 2026 08:04:27 -0800 (PST)
X-Received: by 2002:a05:600c:46d0:b0:45d:f81d:eae7 with SMTP id 5b1f17b1804b1-4835b96ec32mr36897035e9.28.1770825865304;
        Wed, 11 Feb 2026 08:04:25 -0800 (PST)
Received: from rh (p200300f6af2d8700b4c2d356c3fafe63.dip0.t-ipconnect.de. [2003:f6:af2d:8700:b4c2:d356:c3fa:fe63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d92267bsm70932155e9.0.2026.02.11.08.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:04:24 -0800 (PST)
Date: Wed, 11 Feb 2026 17:04:23 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
    qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
    kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu
 property
In-Reply-To: <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Message-ID: <4e9470d5-ef3e-cf5c-4117-fb589d56323c@redhat.com>
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com> <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
 <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7FF1W0y17Ohlob7Nhegxl-Br4s-fHGIN0fCT9zE14xE_1770825868
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 11 Feb 2026, Peter Maydell wrote:
> On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hi Peter,
>>
>> On Fri, 6 Feb 2026, Peter Maydell wrote:
>>> On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>
>>>> +static char *kvm_get_psci_version(Object *obj, Error **errp)
>>>> +{
>>>> +    ARMCPU *cpu = ARM_CPU(obj);
>>>> +    const struct psci_version *ver;
>>>> +
>>>> +    for (ver = psci_versions; ver->number != -1; ver++) {
>> [...]
>>>> +        if (ver->number == cpu->psci_version)
>>>> +            return g_strdup(ver->str);
>>>> +    }
>>>> +
>>>> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
>>>
>>> Is this ever possible?
>>
>> Hm, not sure actually - what if there's a new kernel/qemu implementing
>> psci version 1.4 and then you migrate to a qemu that doesn't know about
>> 1.4?
>
> Oh, I see -- we're reporting back cpu->psci_version here, which
> indeed could be the value set by KVM. I misread and assumed
> this was just reading back the field that the setter sets,
> which is kvm_prop_psci_version (and which I think will only
> be set via the setter and so isn't ever a value the setter
> doesn't know about).
>
> That does flag up a bug in this patch, though: if I set
> a QOM property via the setter function and then read its
> value via the getter function I ought to get back what
> I just wrote.
>

Meaning this should be something like below?

static char *kvm_get_psci_version(Object *obj, Error **errp)
{
     ARMCPU *cpu = ARM_CPU(obj);

     return g_strdup_printf("%d.%d",
 	(int) PSCI_VERSION_MAJOR(cpu->kvm_prop_psci_version),
 	(int) PSCI_VERSION_MINOR(cpu->kvm_prop_psci_version));
}

