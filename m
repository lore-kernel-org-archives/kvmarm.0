Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5A31632F7
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729862927; cv=none; b=kBYGcjLj3E/coSCDaASKH8odCjcYYjxQPgSzmhTGIOvD0RP0uB/4sKVoHYGN0trFH5hY0h++ev/Vc+8PYSSS/x6SSReuEmWZIWhRwzyD/dncuqBO94MMO1kDICExfM3gF0TkUzSS1B73KQJqpOlbmyhffRrqXFmiaexx1M06hDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729862927; c=relaxed/simple;
	bh=cR7AS9k2o5tP7JXo+ZZQXRsP1KRv/9M3LBQEbW+FKT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxf6bIkaDXtZm56CEzs+SKaxJOiYtrUByhBIR7fr6kAixZavpusBpLU/rynBW6hYNYwj+hvCJXRzymS7pmfMPN+CM0R0zzDVrblhlUsNWfIhp6JfYQPytq8RLBpYgnGRlEb9mfkEmyPau4XPQmkVZAUAwNI0D8SLKreIuR7svEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYhSyjPk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYhSyjPk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729862924;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfuBxxkO8cV8uPIqOpQfVwuiKiP8AV2qLKYZ7Y6yiag=;
	b=IYhSyjPkTHSuLssnr5zcF5xGbhjThmjyplxferq7krMGezAmFpN9PX9O3+U0uJaOSoXX0x
	sANmnqQfksBYZKab43E4uWy60wJpQ5jd3ZizxeHUBGiJCMYrrBV3Hbk0PIC+6oqN2a3B9M
	u+TLCLH+auFrVJpzuv990VyWRNCH5bw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-5TkQnWxdPpWTFdtiBQWsnw-1; Fri, 25 Oct 2024 09:28:41 -0400
X-MC-Unique: 5TkQnWxdPpWTFdtiBQWsnw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-539f7ed336bso1591297e87.2
        for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 06:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729862919; x=1730467719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfuBxxkO8cV8uPIqOpQfVwuiKiP8AV2qLKYZ7Y6yiag=;
        b=TRwyoq/9w6MfV6ZaQERCga+BKnE6gDHPaesboozjwUK69tafRwfQJvEpGIE4yd8Pm1
         277Kmay6j1YPM2J3Q2SaXL2ltW7CtqrdQtTm66TZZaQZBHgg0rJCpdFNdNQ81DfghKSK
         C5Rw+2PD14CdWmE61puwomjajHFb1m3ycm9IF9BUOe+b7MrYGuJMT5g5aV/4oC6XJG/j
         /EqfssASkdLEw61rZV9xu0RtnzXbMLtoYjtJfnuXUBm5Aod66D3uUT+IaCsukhFwQtEY
         S5vtgPtbOyMl9X+lmKMi7o1pHnvawCKf2V0O6fTHPVU+VKiUSVx/M+ZAX3wDogu6OPsQ
         Ol2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtsZ/ZCQlGLmZ5AkN/bYatLhMmza/IXXQU2du3eeGS73HaoABWdaLuyzcEPRid9jQJAzFS+ZE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5WyXzb7zUTc0fiuXe2abpGXVUxqf6xWwuYD48hTGHB9fEMP/Y
	yMVyGxsMU6pGtHeBh8ZO4vMUF5T5ErDSd3icQWABYTimm8d1Yuu/bMJP/M+bq9sRHnkLbVYtg7I
	B+Z2uKfBJON4Z9hsoIYDuBJ4vaHDyigV/jAK1oBfA/+cAIMCR6h3diQ==
X-Received: by 2002:a05:6512:2305:b0:539:e88f:2398 with SMTP id 2adb3069b0e04-53b23e8ec21mr3935991e87.39.1729862919478;
        Fri, 25 Oct 2024 06:28:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF38/JwpTvN+i+PqB6gp8UXbBdtyfsmOOwXFBBS3WTo0y8Vn7BqQnx8AhOIgGqem4PRWrP/zg==
X-Received: by 2002:a05:6512:2305:b0:539:e88f:2398 with SMTP id 2adb3069b0e04-53b23e8ec21mr3935965e87.39.1729862918950;
        Fri, 25 Oct 2024 06:28:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43193572932sm18131515e9.1.2024.10.25.06.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 06:28:38 -0700 (PDT)
Message-ID: <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
Date: Fri, 25 Oct 2024 15:28:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZxuZkUFz_bwAA1pf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 10/25/24 15:13, Daniel P. Berrangé wrote:
> On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add some documentation for the custom model.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
>>  1 file changed, 47 insertions(+), 8 deletions(-)
>
>> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
>>  properties have special semantics (see "SVE CPU Property Parsing
>>  Semantics").
>>  
>> +The ``custom`` CPU model needs to be configured via individual ID register
>> +field properties, for example::
>> +
>> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>> +
>> +This forces ID_AA64ISAR0_EL1 DP field to 0.
> What is the "baseline" featureset implied by 'custom' ?
there is no baseline at the moment. By default this is a host
passthrough model.
>
> On x86 we have the named CPU models each setting a baseline that matches
> some corresponding real world silicon. Arm has that too, with TCG at
> least. So that way you know what the baseline is that you're toggling
> features against.
Having named models is the next thing. custom vcpu model is not a named
model. But we don't want to TCG like CPU model (like A57) because we
want to be able to migrate between different machines like Ampere to
NVidia or different Ampere systems. So the baseline must be something
usable by both hosts.
>
> Experiance on x86 was that making arbitrary feature changes on top of the
> named models could often backfire, as there are too many scenarios where
> code will check for feature "Y", and assume that existance of "Y" implies
> existance of "A", "B" and "C" too. So if you invent custom models where
> Y is set, but B is missing, there's decent risk of things going wrong in
> horrible to debug ways.  With that in mind, best practice is to try to
> just the vanilla named CPU models to the greatest extent possible, and
> keep feature toggling to an absolute minimum.  This 'custom' model does
> not seem to give us such ability for arm.
The custom model is not yet a named model. This is rather something to
start this kind of discussion.
The code used by the custom vcpu model allows fine tuning of the ID reg
fields. This code could be reused by named models. We can also imagine
that libvirt does implement the named models, ie. hardcodes some IDReg
fields and thus implement the named model instead. Libvirt could
identify what is the baseline source and dest are the closest to, choose
this baseline and tune few reg id fields if some additional tuning are
needed.

Thanks

Eric
>
> With regards,
> Daniel

