Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B873A1C07F1
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740052; cv=none; b=AB2U5e0ZxUz/ICEKR63Qr1ttu4H2DpcNyjTwdp84VZHIuDuvnu1gX1D1CKekWuijsLPg1idQ9Ke/589An9+PwWljVgZL/KXiAesqbcof0HpLWyCO7NHTqMv88HV76TlsWxRnFNjEprqJucCqjmKSHskjuwIWUsZPLD8nIkl2L7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740052; c=relaxed/simple;
	bh=+voOXbsiIr8SDrMT0/yGA8Le33ER91Sj69OlqT6rVmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZwIjbBlHDpa9mXYEzk+jFSdUyjre1kVXFGDPfkWZiJOcAA35FR3UHesgtmAfxdq6aX5uoIdaPs4Fh9IfUKxsGQ2iNFvVipTzmJ7d4Nm22hEE/YGn0t/nMiQByK+G3slSrzZpSBnPT7Co9vJXGYRi6nwqHi1g7YGmteXF2T9HxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aU7+zJJe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aU7+zJJe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730740049;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9kd/SLSKtmTJFWvEeiYbH/ZTYsZ9MzO/O/GCUBVtKaw=;
	b=aU7+zJJeM/bm0loyJJaYshsgvC5j/Wk4EGa/xwk09Lcl72sTpG4Xzu7ndEljSL6LwB/g89
	A4aaMafsoqw8+qMKPcaTCl655S/YJzt03geuqkZWUNF9BoAOpbm0TNOLTHl+pTdsA2MRjc
	B5uxWpP3XFody+ISbvjXBSr84AtDguU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-140-h2lYUZMTNYa8mtxnF-APfA-1; Mon, 04 Nov 2024 12:07:26 -0500
X-MC-Unique: h2lYUZMTNYa8mtxnF-APfA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315b7b0c16so30673715e9.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 09:07:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730740045; x=1731344845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9kd/SLSKtmTJFWvEeiYbH/ZTYsZ9MzO/O/GCUBVtKaw=;
        b=EZ4O1g7WjyxAUSZWl32FL3FndFRBta2cnA+Z6ltwLPiA0Nk4chGHQ2slgWptH6PCzv
         snDQlrB8GSYvl6HCyfnnUaA194ZK/Z0xS0P0AWZQiN+rhyx1Sc7yH+k4CueoV38ChmGs
         z+b8Vt5nQIcks0dp3sHkmj/5nbSiGoyyu/hcyT6qkJQxt8ZQzAzLK4OcY/4hEiTQb/hR
         sAtpmXiiX3qLMnNqWnci90xHYAkjXw/Gdl91URXDMrT5vKKFjMkkPDrJB1YvsEoA/E8H
         BW6SANKSkmJzc2P38BuNXHHMeFCeXadi1lJ6innJXRQSSlFVDeZR8GH6219FeDLs/3iE
         KW+A==
X-Forwarded-Encrypted: i=1; AJvYcCXoDWDKU3vlPIa1Dbsc0yQo3Tf4nsU9qcfIyTrOUOuegbqJ30SXarxjQ9xIm8TroxeB9h2Qgkg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPyMB3015nvdG0XQ86IBNxTLtN76uks2t+I/CAkLKWtMoDYuRL
	3CVa8iqtWvjLbfMYwTXlHoSQbuvrb2lqTzm4p3fHkrEXUqipp9AqLJNWoQZXC3MFwm2GqyFp0uY
	9BfspsdCm034cbHbUT+eTM/h2n+kQV8EvHZz8x7dq7zX70Uv6Tzi5FA==
X-Received: by 2002:a05:600c:3b07:b0:426:602d:a246 with SMTP id 5b1f17b1804b1-4319ad361dfmr283157415e9.32.1730740045194;
        Mon, 04 Nov 2024 09:07:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZvDg4fTtX5ZmRLfNudb/l0TZaDxUkgWzH2OS49xWRILUJ7G0tKC0AXxSffyMyeP9Iy/9AXg==
X-Received: by 2002:a05:600c:3b07:b0:426:602d:a246 with SMTP id 5b1f17b1804b1-4319ad361dfmr283156685e9.32.1730740044307;
        Mon, 04 Nov 2024 09:07:24 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d698144sm163984475e9.39.2024.11.04.09.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 09:07:23 -0800 (PST)
Message-ID: <48637795-14b9-4b0c-9fb5-46b387be4fd0@redhat.com>
Date: Mon, 4 Nov 2024 18:07:21 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Kashyap Chamarthy <kchamart@redhat.com>, eric.auger.pro@gmail.com,
 cohuck@redhat.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com> <Zx__Zi3Zpg1AspnE@pinwheel>
 <52690aae-55b6-47d5-a308-dd75475f8377@redhat.com>
 <CAFEAcA9y5ooPNZ7JbGmRyTKbZn5XPK+5zZgVAvnER=++kWuBrg@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAFEAcA9y5ooPNZ7JbGmRyTKbZn5XPK+5zZgVAvnER=++kWuBrg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Peter,

On 11/4/24 17:30, Peter Maydell wrote:
> On Mon, 4 Nov 2024 at 15:34, Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Kashyap,
>>
>> On 10/28/24 22:17, Kashyap Chamarthy wrote:
>>> On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
>>>> From: Cornelia Huck <cohuck@redhat.com>
>>>>
>>>> Add some documentation for the custom model.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>> ---
>>>>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
>>>>  1 file changed, 47 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
>>>> index a5fb929243..962a2c6c26 100644
>>>> --- a/docs/system/arm/cpu-features.rst
>>>> +++ b/docs/system/arm/cpu-features.rst
>>>> @@ -2,7 +2,10 @@ Arm CPU Features
>>> [...]
>>>
>>>> +Using the ``host`` type means the guest is provided all the same CPU
>>>> +features as the host CPU type has.  And, for this reason, the ``host``
>>>> +CPU type should enable all CPU features that the host has by default.
>>>> +
>>>> +In case some features need to be hidden to the guest, ``custom`` model
>>>> +shall be used instead. This is especially useful for migration purpose.
>>>> +
>>>> +The ``custom`` CPU model generally is the better choice if you want more
>>>> +flexibility or stability across different machines or with different kernel
>>>> +versions.
>>> Does "more flexibility or stability across different machines" also
>>> imply "live migration compatiblity across host CPUs"?
>> yes that's the goal
>>>> However, even the ``custom`` CPU model will not allow configuring
>>>> +an arbitrary set of features; the ID registers must describe a subset of the
>>>> +host's features, and all differences to the host's configuration must actually
>>>> +be supported by the kernel to be deconfigured.
>>> [...]
>>>
>>>> +The ``custom`` CPU model needs to be configured via individual ID register
>>>> +field properties, for example::
>>>> +
>>>> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>>> If possible, it would be really helpful (and user-friendly) to be able
>>> to specify the CPU feature names as you see under /proc/cpuinfo, and be
>>> able to turn the flags on or off:
>>>
>>>         -M virt -cpu franken,rndr=on,ts=on,fhm=off
>>>
>>> (... instead of specifying long system register IDs that groups together
>>> a bunch of CPU features.  If I understand it correctly, the register
>>> "ID_AA64ISAR0_EL1" maps to a set of visible features listed here:
>>> https://docs.kernel.org/arch/arm64/cpu-feature-registers.html)
>> Not all the writable ID regs are visible through the above technique.
>> But indeed I think we converged on the idea to use higher level feature
>> names than ID reg field values.
>> However we need to study the feasibility and mappings between those high
>> level features and ID reg field values.
>> The cons is that we need to describe this mapping manually. Besides
>> being cumbersome this is also error prone.
> You might be interested in "Arm Architecture Features" on
> https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
> which includes a 1.8MB Features.json which is a machine
> readable version of the "what are the features and their
> dependencies and ID registers and so on" information.
thank you for the link.
>
> But note that (a) it is alpha quality and (b) I am not personally
> going to try to interpret what might be reasonable to do with it
> based on the legal notice attached to it: that's a matter for
> you and your lawyer ;-)

Thank you for the notice. This may be similar to the ARM xml mentioned
by Marc...

Eric
>
> -- PMM
>

