Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB4C20ADFF
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733997880; cv=none; b=qHwjz209SCJYy1zconNI26yriUkDMnDJ3f+OlE/VQ2ipOObQ56kxZyGpdd5F7/j+y7/FsG7oBzy2urT/42zIZZ0oQDydsSv1c8w2dvJuMrLe2JDzIr4O9d0FJ0eorbQmsaEcnlZ7CK9GX7qrB64kU9EuPEYVlWgybHjpdGdNXf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733997880; c=relaxed/simple;
	bh=OIJaZaO1VzpCt4Doe1UX4ZPBiVkp5y2c4qkf7E4BP7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvScK+0tosizCNz39DU9sDJlgr/pynFbBu+BF+H0wwYobxRPK0pdEdAkJThrxDhkp1lXJvvSTJgbhxdnlV58SHzkQ1Q2VZiw8V6VLTUK0uXmcjlotGZ/qMI67Z3QEXFPuXn3qIhTuxGgv7r5NOqGrnsgNIU7c6RAmzxc0XxftYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXq1HPKv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXq1HPKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733997877;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xuef9j19a6S4cy5t3jz7hMtr1tGA8HyHJRgE1u6fNo8=;
	b=CXq1HPKvk7OtffVY7smyrWYhdthDjDJVxxk14cWX6kJoKwxBrXqy17seXnKaJfZn765k1Y
	rSpnD0qR1zUkyTewM0rpmzeMqqLffqr24aBUH8MZqoua1ikG0OHGNR04e5zS13RdIwKcxC
	AUgVlME45KKKdjHAESaNWmA8Fnz0/wc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-JkwkedYRN5K2QLnJFbCReA-1; Thu, 12 Dec 2024 05:04:36 -0500
X-MC-Unique: JkwkedYRN5K2QLnJFbCReA-1
X-Mimecast-MFC-AGG-ID: JkwkedYRN5K2QLnJFbCReA
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d9135afda3so7410066d6.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 02:04:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733997876; x=1734602676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xuef9j19a6S4cy5t3jz7hMtr1tGA8HyHJRgE1u6fNo8=;
        b=j8nSuTHkFNRhionvfXr0TvJUfhPEnYYppCVqxQIG/qbx+Kwt0rZwGA2Nq75JSlfKs1
         IK6BmCS7kiBZbfHIvhBPoFKeL3MhXckthYqTQmBWsTuySmcEBUUiHIRpQ25VzSSLkwKY
         webmkBY/RIuzo1Wz1XW1weM9nNiV8NLJKMnCxD3KqnRGwa7IMtJXqoWBm5/vrCH6D2UF
         bSElLa8GSI8VZxDk3Y4gypsfY1L264TDndyP5kDQGn7oFxaMy2hUf0XQZAIEOvFJeSSz
         2NAXxipiwia4k+lFfkr2c7aXdp5cwYHzztJKPOjsANCAStMQAuI7vRohSTS4i5g+Txdu
         csgg==
X-Forwarded-Encrypted: i=1; AJvYcCWsGJrMMwNI0tKyUSL+B2T65TIdM4ATVBmv1QzFIyesIkajpoerZi1bEd7GT87A+Q8Ls0PBQic=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8lI6RNuiTlqVYV3moqVP4uFFEdffL6zW3YZr9P4njIBhPko51
	mfydfquHBTMDQXLCAQfQS8xdp1EeC5SfZrNItvaBhy1zQ86QWC0OTzK87RAlQhJVoz2RuAYt3Bd
	uoV5bmqKXQeSCmNN6BrwUVLYsWX8+jt+LGFfJLA8/9W8/9v5lHsUmKg==
X-Gm-Gg: ASbGnct5c1/J/FvR9SuhIb7Oic5Xl8260xo9WlgnWXgPQerBeVT85tYfgy47Xr+3lG7
	eEtIgqy2U+ydcG3Ojx0cfWYjqe++dM/5N91ebrxpi4++sgjlZSH2kkYzS6xHB9MSHRT4J/pQBGZ
	O57ImRdCODcL+9G8kecbDeQWyIEkj4GDslrYZeynaKZbmXvYTZ3NpqMXUEmxjbykdt+5DpSXswN
	fnZ2/f9QJuYvw0OtgFQjntsDvgukbPkNb23zLJ0NdTnS8LCp02CQ0qaihetF9rASVy/ixpCw7R0
	83RCmk+V0OSo1cFwbqCZlVeKpD7j
X-Received: by 2002:ad4:5748:0:b0:6d8:959b:c307 with SMTP id 6a1803df08f44-6dae38dd832mr47255636d6.10.1733997875830;
        Thu, 12 Dec 2024 02:04:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFF3KTyI2FwWZR0PYcTNWutT+SOIZjlczitRUUPCpTiP/v5+N6XDYRHA8yRBfMoXEZbgHkVOw==
X-Received: by 2002:ad4:5748:0:b0:6d8:959b:c307 with SMTP id 6a1803df08f44-6dae38dd832mr47255336d6.10.1733997875470;
        Thu, 12 Dec 2024 02:04:35 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d9162133aasm39276806d6.129.2024.12.12.02.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 02:04:34 -0800 (PST)
Message-ID: <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
Date: Thu, 12 Dec 2024 11:04:30 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com> <8734it1bv6.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8734it1bv6.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hfCIIoUEm6p6s2bZ9bljDpRD8HO9aX-rM7XIZzsr4-I_1733997876
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 12/12/24 10:36, Cornelia Huck wrote:
> On Thu, Dec 12 2024, Daniel P. Berrangé <berrange@redhat.com> wrote:
>
>> On Thu, Dec 12, 2024 at 09:12:33AM +0100, Eric Auger wrote:
>>> Connie,
>>>
>>> On 12/6/24 12:21, Cornelia Huck wrote:
>>>> A respin/update on the aarch64 KVM cpu models. Also available at
>>>> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>> snip
>>
>>> From a named model point of view, since I do not see much traction
>>> upstream besides Red Hat use cases, targetting ARM spec revision
>>> baselines may be overkill. Personally I would try to focus on above
>>> models: AltraMax, AmpereOne, Grace, ... Or maybe the ARM cores they may
>>> be derived from.
>> If we target modelling of vendor named CPU models, then beware that
>> we're opening the door to an very large set (potentially unbounded)
>> of named CPU models over time. If we target ARM spec baselines then
>> the set of named CPU models is fairly modest and grows slowly.
>>
>> Including ARM spec baselines will probably reduce the demand for
>> adding vendor specific named models, though I expect we'll still
>> end up wanting some, or possibly even many.
>>
>> Having some common baseline models is likely useful for mgmt
>> applications in other ways though.
>>
>> Consider you mgmt app wants to set a CPU model that's common across
>> heterogeneous hardware. They don't neccessarily want/need to be
>> able to live migrate between heterogeneous CPUs, but for simplicity
>> of configuration desire to set a single named CPU across all guests,
>> irrespective of what host hey are launched on. The ARM spec baseline
>> named models would give you that config simplicity.
> If we use architecture extensions (i.e. Armv8.x/9.x) as baseline, I'm
> seeing some drawbacks:
> - a lot of work before we can address some specific use cases
> - old models can get new optional features
> - a specific cpu might have a huge set of optional features on top of
>   the baseline model
>
> Using a reference core such as Neoverse-V2 probably makes more sense
> (easier to get started, less feature diff?) It would still make a good
> starting point for a simple config.
>
Actually from a dev point of view I am not sure it changes much to have
either ARM spec rev baseline or CPU ref core named model.

One remark is that if you look at
https://developer.arm.com/documentation/109697/2024_09?lang=en
you will see there are quite a lot of spec revisions and quite a few of
them are actually meaningful in the light of currently avaiable and
relevant HW we want to address. What I would like to avoid is to be
obliged to look at all of them in a generic manner while we just want to
address few cpu ref models.

Also starting from the ARM spec rev baseline the end-user may need to
add more feature opt-ins to be close to a specific cpu model. So I
foresee extra complexity for the end-user.

But again I from a dev pov it shouldn't change much and we should end up
with a proto that illustrates the working model

Eric

