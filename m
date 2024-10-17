Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854231DE4E2
	for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729185377; cv=none; b=cwNKTpUjGogtRKnR2vpfbFpLT5vmzDFb/cgrrGb8xO2xn2fQ46MgiNyqQnxJOPmOsYHYyoPxfUEh7OHpDloRlKVz8QaPipCFR/gEzpNPfv5q0BR2aDuMjmCizCLQtH3Q/YQYnFz5WZelNlCygQKZIM0H1mbcbPqf2U2f2nWyGBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729185377; c=relaxed/simple;
	bh=hlCo3bm0P6xJXkHFjtHXXGfdsYq6Yg1YCgwf/DFYOZM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWn1PfewvC3NB/psph+RD3WzuLfLns2L/cH7E/rsL0MWhcZ2rheZpkSmV7ZL7WWOdv1kiRKTSqihuEfdfy97Ytj1E4TvPJ2Y3ubqDlOlESh8lmW/s2cgDMwc8DBSnmy2Wgswg6D0wLUBsKw7LioLkkFmREO+ZUGLV2bKBW3erxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UWD6PG6h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWD6PG6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729185371;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ENaTEpgm02bGn7COCDFjb/2EsQJ40kySHYJqwg00Er8=;
	b=UWD6PG6h4YmDj+6IZ1QFr2MPGHm+dpGKIk/Zy86fxAWKSJ35eZ+7aoqFWfXIVw0hX5sMhc
	wsGEaPx/3J/BxoigG3oSMswRlGaPW/j0umyxMnd5qGFwRy/LP9AG+6i+JaKEC8NqJquLK5
	PxXm0YLF/eFH81BVCiGqgPSG5kLOHQ4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-al0Vn0bcN7uhVRZlrI0jjw-1; Thu, 17 Oct 2024 13:16:10 -0400
X-MC-Unique: al0Vn0bcN7uhVRZlrI0jjw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43056c979c9so9359225e9.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Oct 2024 10:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729185369; x=1729790169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ENaTEpgm02bGn7COCDFjb/2EsQJ40kySHYJqwg00Er8=;
        b=ZxUhYMhfxqRb3mhKjr2D7EpGMZ40r8QTm9RGPbv3Bk/ax3bSr5lIG6qGjFlEqPvWZn
         F70OSX4MVsv4/fAx6RnKb2wDWKxELjOSxEScJKwoyM1P2rhGnqREdeX2KF62sZMQRjnq
         +Pgrwh5/TvtzXyeSWxaEZcI2dldfR5NZbM9mSkqo9mYT2Eft6fEVyhvnDPKCDT+7fW+L
         5n3socf4i+w+W5eQMauTi2M5wNwSspoBNV6oCrsLyJAI32YVXkANICXv+HeTYkBMSRyD
         3kr6m9+wIx7WN8zxPV6sDH+V5linTKjjVFWnN/uOaSLiPZpThu+zpSDW8apw6NIcrZ3f
         UaPw==
X-Gm-Message-State: AOJu0YwC4rMJCm6L/ElQSJhEinn/lr0kQPp99YR0miXp0UQvFSoBsxlG
	mJFklY9G3N+mCJW7ueQgZUvIaxwVFiYm6A5F3mhBjQyVs6avk8qp+p1n3Pu+5dDqL6yqOaj6tk/
	1PYR1JWitGV6oPi3bu4NpSMQEDlivOE6eetRsbbaeMG8+NFV4Q1+TLg==
X-Received: by 2002:a05:600c:1991:b0:430:5356:ac8e with SMTP id 5b1f17b1804b1-4314a284384mr72444255e9.5.1729185369062;
        Thu, 17 Oct 2024 10:16:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0sQGSbxKn0Ms5Xb0WJC5Uq5JPLoScRH9NzVt+1cvDKYYLZHxYtRLwbPTzkjX7X6+8IVcDwA==
X-Received: by 2002:a05:600c:1991:b0:430:5356:ac8e with SMTP id 5b1f17b1804b1-4314a284384mr72444015e9.5.1729185368624;
        Thu, 17 Oct 2024 10:16:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316069e12dsm1549215e9.22.2024.10.17.10.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 10:16:07 -0700 (PDT)
Message-ID: <7df21c56-0b07-4112-839e-ef90c5999fcd@redhat.com>
Date: Thu, 17 Oct 2024 19:16:04 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
 migration
To: Cornelia Huck <cohuck@redhat.com>,
 Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>,
 yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 jiangkunkun <jiangkunkun@huawei.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Anthony Jebson <anthony.jebson@huawei.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Linuxarm <linuxarm@huawei.com>
References: <20241011075053.80540-1-shameerali.kolothum.thodi@huawei.com>
 <86jzef53iz.wl-maz@kernel.org> <3f4469c49625413f9ab2c224d0d3fbea@huawei.com>
 <86ikty6f1b.wl-maz@kernel.org> <ZwlADbp-HjkijElX@linux.dev>
 <08261a41b9644f5ab49063824e4060c3@huawei.com> <87bjziraou.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87bjziraou.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shameer,

On 10/17/24 17:49, Cornelia Huck wrote:
> On Fri, Oct 11 2024, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>
>>> -----Original Message-----
>>> From: Oliver Upton <oliver.upton@linux.dev>
>>> Sent: Friday, October 11, 2024 4:11 PM
>>> To: Marc Zyngier <maz@kernel.org>
>>> Cc: Shameerali Kolothum Thodi
>>> <shameerali.kolothum.thodi@huawei.com>; kvmarm@lists.linux.dev;
>>> catalin.marinas@arm.com; will@kernel.org; mark.rutland@arm.com;
>>> cohuck@redhat.com; eric.auger@redhat.com; yuzenghui
>>> <yuzenghui@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>;
>>> jiangkunkun <jiangkunkun@huawei.com>; Jonathan Cameron
>>> <jonathan.cameron@huawei.com>; Anthony Jebson
>>> <anthony.jebson@huawei.com>; linux-arm-kernel@lists.infradead.org;
>>> Linuxarm <linuxarm@huawei.com>
>>> Subject: Re: [RFC PATCH 0/6] KVM: arm64: Errata management for VM Live
>>> migration
>>>
>>> On Fri, Oct 11, 2024 at 12:43:28PM +0100, Marc Zyngier wrote:
>>>> On Fri, 11 Oct 2024 11:57:10 +0100, Shameerali Kolothum Thodi
>>> <shameerali.kolothum.thodi@huawei.com> wrote:
>>>>>>> Please take a look and let me know your thoughts.
>>>>>> Having eyeballed this very superficially, I think we can do something
>>>>>> simpler, and maybe more future-proof:
>>>>> Thanks Marc for taking a look and the quick feedback.
>>>> No worries, that's the least I could do given that you put the effort
>>>> implementing my silly ideas! ;-)
>>>>
>>>>>> - I don't think KVM should be concerned about the description of the
>>>>>>   target CPUs. The hypercall you defined is the right thing to do,
>>>>>>   but the VMM should completely handle it. That's an implementation
>>>>>>   detail, but it would make things much simpler.
>>>>> Ok. So does that mean the hypercall will use some sort of shared
>>> memory
>>>>> to retrieve the list of target CPUs from VMM?
>>>> Two possibilities:
>>>>
>>>> - either shared memory, in which case the hypercall would require the
>>>>   guest to give an IPA and size for the VMM to write its stuff into
>>>>   the guest memory,
>>>>
>>>> - or more simply return the data as an MIDR/REVIDR pair in registers,
>>>>   the guest requesting an index, and getting an error when out of
>>>>   range, leaving it with the freedom to organise the storage.
>>>>
>>>> The second option is a bit slower, but way simpler, and it only
>>>> happens once per guest boot, so it would probably be my preferred
>>>> option unless this is proved to be impractical.
>>> Also worth noting there's existing UAPI [*] for allowing userspace to
>>> register range(s) of hypercalls that it services directly. It's a bit
>>> weird that we'd allow userspace to do stuff in KVM's own hypercall
>>> range, but I don't think it really matters at this point since this is
>>> all prototyping.
>>>
>>> [*]: https://docs.kernel.org/virt/kvm/devices/vm.html#attribute-kvm-arm-
>>> vm-smccc-filter-w-o
>> Thanks. Yes and there are attempts to add that handling in Qemu[*] in the context
>> of vCPU hotplug support(PSCI related ones though).  Will take a look.
>>
>> Thanks,
>> Shameer
>> [1] https://lore.kernel.org/qemu-devel/20241009033704.250287-1-salil.mehta@huawei.com/
> Speaking of QEMU: Do you maybe already have some prototype code that
> tries to do something with the setup here? (I don't think QEMU currently
> mucks around with MIDR and friends when running with KVM; I wonder what
> it should provide to the guest and if it should care to set something as
> a base level that gives guests not using the hypercall a chance to work
> properly.)
>
As discussed during the KVM forum we are working on a qemu integration
for writable ID regs. The first goal is to be able to specialize the
host passthrough model (custom host model). Maybe this will trigger more
discussions on named models too. This is complementary to the
MIDR/REVIDR problematic and I hope we will be able to consolidate our
works at some point.

Thanks

Eric

