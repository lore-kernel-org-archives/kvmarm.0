Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CE4F9E8
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730731525; cv=none; b=EA8RL2zq8hDl3aqYfXIJMmnETajdHF+NQotgxUDgx+gDQwIUf1YgAMLKXK1CeA+6anss/uEn9tBwQrC0qye0S3Hwc7A/wF4mrBRD1Nw+JyO69yWUvkYZSyFCZpRWxDZqkLHNekhxZSLbid6mfqpuKT18y81IHbPWOlqO9NuCzLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730731525; c=relaxed/simple;
	bh=N+FQV1Ef2HH4KvcdJu8D3jM/TLC09EfHd6a+tACTL/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cAp3AhIiZKW1qLI6JU8IhIA/4kJ6O+O22WtYGZWenJZIR5FQPsPx5675RO17ID/1/z/5nGWCVOZCuohl9t/Fg/TvJiXkdcu95GosiHd9Sv5xgksc++DlvY9pF4rvY0wUsLgla91VnsVS1pEouzNqBUtZV1FV7qZCyyr8GZe/10U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jOn+VJVm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jOn+VJVm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730731522;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhlNDrXlUzM5p8FZMA7dRiQzkSxBvDnj3EpKeGQ8LMg=;
	b=jOn+VJVmeUuqhJB+ZfL3s3W+2jFncd0Aap6T0Q+RRRumcS+WUNzI+Ayh0ydA8wdZWgBIMf
	arHesdhqFq9fUxLDnO6CfkdlKq+AysYnoks0NOUhM29eBgRNMT0ssdj2ZcCwISFJqVa2c8
	ZGszkl+iysXk3kI1xksZqpMtu8rZIYU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210--d0IvmUzNMyPcKjCL0U0xA-1; Mon, 04 Nov 2024 09:45:18 -0500
X-MC-Unique: -d0IvmUzNMyPcKjCL0U0xA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4314f023f55so29179375e9.2
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 06:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730731517; x=1731336317;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JhlNDrXlUzM5p8FZMA7dRiQzkSxBvDnj3EpKeGQ8LMg=;
        b=fiuNQKzm6zeU5UGb00YlmNrRUPZ4YfWCk8Cc2I5RfRfxximYA3aRZDgnN2T9qjWxkt
         x3euqKP/egxDYVvP32wmZtCaCUTrFgp/KHa+Ljocwy0fg1BITnrk1Fm+NLNgl/dAt0ay
         xDGueQn9k6hNS9NUsgtQpqVlbzoJFGJgk7DT9FR32myw4h4OE9n1AQQvVwsvI5SeQtTX
         zDyJKy96aJQcC8UZfAH14ERXxDX/b19OFTA834d8pPpzB1xRzgwHcjAoXGBABnlOSEJV
         9f/twknemY0HvIXeF/Fb9M88TDO8I//pXYOlic/+TTtH6Ycs0Fjz2gOpMOeBU+m0s5kR
         HkAw==
X-Forwarded-Encrypted: i=1; AJvYcCVWpl2mvqbkG7raLvpTzy3G5AAbRM6plRtnDB4h9HzEZinZjB4K4djFLvv5fXzoJ1eeL3xJxw0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxDxzy5Q0PMDlZy9+5odlWEx0L7AZM1gr9T2g1a0vqeceLA5c7
	TtMMkIOiy3TwmljU9Ca2soDuaz12TlRZcqE2T9PkoID8ro6cpZf7zHoQKGlmW/kXEy1nfajhwYa
	hkaf0ayf4ZNthczIWc534DghD1cMplKWCsgvj+igaAUNDYhX/dLHz6Q==
X-Received: by 2002:a05:600c:4f83:b0:42c:c28c:e477 with SMTP id 5b1f17b1804b1-4319ad089b0mr249763585e9.23.1730731517248;
        Mon, 04 Nov 2024 06:45:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEK7DnUTIUKjcmX0ueGziHtEgez9caMGryr8uN8uniSi+BuEypdN+ho4a6Av64MwJgDD1dOlA==
X-Received: by 2002:a05:600c:4f83:b0:42c:c28c:e477 with SMTP id 5b1f17b1804b1-4319ad089b0mr249763345e9.23.1730731516834;
        Mon, 04 Nov 2024 06:45:16 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431bd9180f2sm184056535e9.19.2024.11.04.06.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 06:45:16 -0800 (PST)
Message-ID: <24ca0278-5018-41e3-a097-ac560a16f8fa@redhat.com>
Date: Mon, 4 Nov 2024 15:45:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <ZxuZkUFz_bwAA1pf@redhat.com>
 <0700af51-a1a6-4b11-a4bf-0eaf6e279c6d@redhat.com>
 <Zxudl5-fZV1vIaEL@redhat.com> <87y128nrfr.fsf@redhat.com>
 <Zx-3OUioG1l47hW3@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Zx-3OUioG1l47hW3@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi

On 10/28/24 17:09, Daniel P. Berrangé wrote:
> On Mon, Oct 28, 2024 at 05:05:44PM +0100, Cornelia Huck wrote:
>> On Fri, Oct 25 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:
>>
>>> On Fri, Oct 25, 2024 at 03:28:35PM +0200, Eric Auger wrote:
>>>> Hi Daniel,
>>>>
>>>> On 10/25/24 15:13, Daniel P. Berrangé wrote:
>>>>> On Fri, Oct 25, 2024 at 12:17:40PM +0200, Eric Auger wrote:
>>>>>> From: Cornelia Huck <cohuck@redhat.com>
>>>>>>
>>>>>> Add some documentation for the custom model.
>>>>>>
>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>>>> ---
>>>>>>  docs/system/arm/cpu-features.rst | 55 +++++++++++++++++++++++++++-----
>>>>>>  1 file changed, 47 insertions(+), 8 deletions(-)
>>>>>> @@ -167,6 +196,16 @@ disabling many SVE vector lengths would be quite verbose, the ``sve<N>`` CPU
>>>>>>  properties have special semantics (see "SVE CPU Property Parsing
>>>>>>  Semantics").
>>>>>>  
>>>>>> +The ``custom`` CPU model needs to be configured via individual ID register
>>>>>> +field properties, for example::
>>>>>> +
>>>>>> +  $ qemu-system-aarch64 -M virt -cpu custom,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>>>>>> +
>>>>>> +This forces ID_AA64ISAR0_EL1 DP field to 0.
>>>>> What is the "baseline" featureset implied by 'custom' ?
>>>> there is no baseline at the moment. By default this is a host
>>>> passthrough model.
>>> Why do we need to create "custom" at all, as opposed to just letting
>>> users toggle features on "-cpu host" ? 
>> We could consolidate that to the current "host" model, once we figure
>> out how to handle the currently already existing properties. Models
>> based on the different architecture extensions would probably be more
>> useable in the long run; maybe "custom" has a place for testing.
> If you can set the features against "host", then any testing could
> be done with "host" surely, making 'custom' pointless ?
Yeah I do agree that we may not need to introduce this "custom" model
bus just enhance the custom host model with the capability to tweek some
features. For instance we have the case where migration between 2 Ampere
systems fails with host model but if you tweek 1 field in CTR_EL0 it
passes. So I think in itself this modality can be useful. Same for
debug/test purpose. As mentionned in the cover letter the number of
writable ID regs continue to grow and this enhanced host model gives
flexibility to test new support and may provide enhanced debug
capabilities for migration (getting a straight understanding of which ID
reg field(s) causes the migration failure could be helpful I think)

Thanks

Eric
>
> With regards,
> Daniel

