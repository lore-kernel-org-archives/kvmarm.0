Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904533B97D
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596983; cv=none; b=t02cPkawa8Vk8PJrgBKLnHcuKLltjchunqRVhnXz9dN3NnS+gCT0ImwKvaNmW5m2doHf92ehJEh+v2ug+za8HuuxFtjIyrtEDbNt0bsR7jhT+luiDkZmsmGN1Pv3u9oBBGbbQ2nSzDaHC0W1g5LJIcMUio1UptuktMC5A7spEKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596983; c=relaxed/simple;
	bh=kN2kbp0ZO+hLE5oZ/5WuYNrtaRI3M4w+bQORE2OJafs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZwC2zGVPFSi0Q39KcUbAc9k3VKiFKdYp3Cyl8INwEABplXwPTpzf3E3FfVj4DtfABPOnZno+AlPJQ7To7ynTap8lU5c7crj6yBTGnBfGeJuXfcdi1OYQz1jLO1qGx0FIq3D7s7rCV0LVm0txePNKc50pm//pgV/2Gb93Uxe91pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWiwTFHO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWiwTFHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781596980;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kN2kbp0ZO+hLE5oZ/5WuYNrtaRI3M4w+bQORE2OJafs=;
	b=NWiwTFHOFDrGzjCtE1LGaPcofSzPSnRHuVCaug1M9zYeXzeOO/A+r6ZHy/QWNfre0PE3WM
	N7sh+g6GuheDL5azgNl3g5NnjHqQBdXG3vrPDncBYqAYwrXmPdqxioKfdQLjgk2vt6guI0
	WjDeaiJaEQxkNIqjomp0s9UylOuu+CA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-Ih3P4Q5iN1GH0dMlNVe_Fg-1; Tue, 16 Jun 2026 04:02:58 -0400
X-MC-Unique: Ih3P4Q5iN1GH0dMlNVe_Fg-1
X-Mimecast-MFC-AGG-ID: Ih3P4Q5iN1GH0dMlNVe_Fg_1781596978
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-bec440e6b9fso360192766b.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 01:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781596977; x=1782201777;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kN2kbp0ZO+hLE5oZ/5WuYNrtaRI3M4w+bQORE2OJafs=;
        b=hj1oScZTHmxAd3Hei0YA28G98i37D5KyDsPAGRBsVHpwTU3CtMbKDSxiVh36xkCuo8
         i13vgE4oL6JGrunRjkQIYa25ALkQmn1D/XSzOF2bkSbC6uc8OYeZ6hbsH+m0jVHrOGf+
         XugbpUqscZvc5W2NlENH8VvR+06RHV+hQ7Gpb/LzUUDjQD4dMkv+QdgX5eI4G4DIpNUp
         LHkmkf+d9FuxxXkAMpVFrIzas23SfTkX0HG9pxjvrj7+XXylc6fXssalwpULi8fGdmaF
         YkCSrHFG2daEss9pXwBsKW5GonqvHEf2d2ad3St1h2X7P6CdvyXJBuJRI5smD6ku6p6C
         zsFQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Ju/unFUKKwCiknEAOVtRi/182AzIgqx8XgZHoOD7VpnXYthCEy2sZAzWAJa7egJmcP422wrw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj8MGNrhWAxyjsFH8vG8+eOawi21ABuFryWOiDGCeFhyShm/kj
	X1fOyXSF7e5pV09BazZoZ8Dcu3XDsllx5LXHn28A6nrh5lxWoDUqFY+dGARx7vnaPOM+cpdHHZq
	XAgMeiA74qKUw+CWUyT7gCqQ12pVKtoMToqiaGaakW/4KEfC5SQNhz5LMqw==
X-Gm-Gg: Acq92OFfv9QlyxXtlECiVVj0zAcOvtH2LXfSdwTc4NyFLUWMZ58kAybv58yighb0zSG
	HjsaavokPHgeHebsxMbLKGeKsPS8fpixuzgjy3Z7vYRFXy7SEWPy+1f9YOXilQT6UYCfpKDTehQ
	lP8+B/Z4JDuhAPMiE9122mIzTcqHfy+SOo9pm9gCkun1rQYogZC14WTd61NM9annVGbIczV6qXW
	iWXqQ+B6yURVWyynTcQJ/qKGYpY1fUN4wUntAn/9+SN7AfRCtAKiN5G8r/zPJ6M6X9BFqfNS3pg
	b+AcMNbqLXroC2rvP4XhvcveeW1aKHZXOphpESZ9ajtvva1EkkwVLJa+bA9bstN/ceV17l1zfkG
	qIiX8K0bSR0gRlLuqf6AzQsb15AcZmh4R/knYwG/HrMa/46GxpWZERfMtA0+q7ulgBCWV4g==
X-Received: by 2002:a17:907:1c9f:b0:ba6:e18f:1568 with SMTP id a640c23a62f3a-bfe2a2195a4mr925276566b.32.1781596977407;
        Tue, 16 Jun 2026 01:02:57 -0700 (PDT)
X-Received: by 2002:a17:907:1c9f:b0:ba6:e18f:1568 with SMTP id a640c23a62f3a-bfe2a2195a4mr925270166b.32.1781596976848;
        Tue, 16 Jun 2026 01:02:56 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb522167dsm592049266b.25.2026.06.16.01.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 01:02:56 -0700 (PDT)
Message-ID: <4c1bdb4a-2d9c-4a01-87c9-da2ad2c8f254@redhat.com>
Date: Tue, 16 Jun 2026 10:02:53 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 17/18] arm-qmp-cmds: introspection for ID register
 props
To: Sebastian Ott <sebott@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org, shaju.abraham@nutanix.com,
 khushit.shah@nutanix.com, yangjinqian1@huawei.com, cohuck@redhat.com,
 richard.henderson@linaro.org, skolothumtho@nvidia.com, philmd@linaro.org,
 maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-18-eric.auger@redhat.com>
 <10ae56f5-6fc7-fe58-1e17-7c3b968045be@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <10ae56f5-6fc7-fe58-1e17-7c3b968045be@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R77fsoSxFNTiIxEE7Z7_Qb0ETY02uxS_hjoKJOAb730_1781596978
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 8:29 AM, Sebastian Ott wrote:
> On Tue, 19 May 2026, Eric Auger wrote:
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Implement the capability to query available ID register values by
>> adding SYSREG_* options and values to the cpu model expansion for the
>> host model, if available.
>>
>> Excerpt:
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>> {"return": {"model": {"name": "host", "props":
>> {"SYSREG_ID_AA64PFR0_EL1_EL3": 1224979098931106066,
>                  ^
> This looks wrong - more like the full reg value and not just EL3.. 
effectively! Fixed.
>
>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
>> ../..
>>
>> So this allows the upper stack to detect available writable ID
>> regs and the "host passthrough model" values.
>>
>> [CH: moved SYSREG_* values to host model]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>
>
> Reviewed-by: Sebastian Ott <sebott@redhat.com> 
I added the write part now

Thanks

Eric

