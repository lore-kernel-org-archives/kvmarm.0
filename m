Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAF1382377
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898789; cv=none; b=iycZoFejYZqJOf23zJYMcnz3Xgg8rT8d5LpGOuQy0xVRYC/ey8G7SUM/Uh1vTKzkWAbbKhpQYwebjjuzNoZk6zqxN90X2UmyvWO+rASouMbXsT73dwuUxa8wheO//4ortAa9qVcbvoCFIaTYGSK9+yPm03dC5EtPAR1unxDwsio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898789; c=relaxed/simple;
	bh=U4WM6xt5tbEm4HnjZ5FtCAEPKsvnOC7JFV44iN8S6aQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tX8N0PumYrDvZiJWplO12sn/u5ynOowOKyGeWQwc+26kk9fhEVYoqScLRguJ6TXNxMf6owOJLVeHSBDbvNv+IsygLh/D/rLsgwkPmN2SMqaLZA+QAFoMGAsHt8/luxCuKQ/d3YVswR3Nj8EYp2sjrkK3jf4iPaNG2l9zmbn882A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZP2dZIZE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZP2dZIZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779898786;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWehKC6VzlOi12pDotLZu0gXRvyJlSMzVrHQdPkljoo=;
	b=ZP2dZIZEUCtEL7Ix1quDguWxPTP01GHqXxM5FLQRNb8MbjW/3N4evS/d/YaGllem7c9fWR
	4zUTrulCQAxVOsZUC9M7EM2KWaH6ZvLCwO7mJPM+VSo0sva+KnBTmqbclt+cQwE3UEpLZe
	GvhJwA9qc5XJJf79Zwo0YtzBTGWoFJQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-JP1GmjIRM4O5y6DBn3HxQg-1; Wed, 27 May 2026 12:19:45 -0400
X-MC-Unique: JP1GmjIRM4O5y6DBn3HxQg-1
X-Mimecast-MFC-AGG-ID: JP1GmjIRM4O5y6DBn3HxQg_1779898784
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49045243094so77036575e9.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 09:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898784; x=1780503584;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWehKC6VzlOi12pDotLZu0gXRvyJlSMzVrHQdPkljoo=;
        b=Da7D7I1/tokh4LfeV5LYge4V87eak7Tu4S8FHUxrxnW3pmZjy7icLCuIaZgvvDdEex
         WftMV3nprVnMzbjqqO5zMqMMikPZ7n9kBdP/yxSZPTYf63WaYIeOkr3j0c4Ri06U3lUH
         9lgL6tyRFMSoVSfYN83z5msyuxB0RlnU69EQCAocYbXb5MMlL2H52IdSFgTs2mgxVd73
         tQS8Xx1C87YVfKa0p25osrL8+DNc6+ACxPUj68G4lGwv6JHjUbnqfbfk7JkFXzj7aBNi
         BGzPkdXEVIlEINtjX++fTXsN1vjU5kFtrpL8xrDT2jKQImwujtAggitcVyXfu/osXCaJ
         WAKA==
X-Forwarded-Encrypted: i=1; AFNElJ/5sQiRfVmSQObLZ6uR2t1uIHAmtjM19hl7kGxIGyqo4JyIz8LwT+vaISHjgINUg8A77e49i9o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcPta8EEF89FV69EJ0vETjTnXgsskDzc4k7HQ+B9YwO4Y2nD12
	miGkbIQt3pvjW8aEkf32XcE2s/l4oaxku8125qCT26a52REooRGrFLlGJiaCGu2sk5cxTddMjSs
	WyajAJdQ99CAsidZWNOmWMZrIWP8BW/Cc9I/tpeIRhIw4HLZP/ygd/JfTXQ==
X-Gm-Gg: Acq92OHRpsossfrYlEWXig2rUM6B9bcguHGVruarEXvYmgYbz8pCGM864gY/o3FAi6J
	kyXGByyoSmx1G9vNEF0hcGjd6rMPgN3NKt8UCuXZ6h5MKmC7VQypyx0NZ0WUQtSh8aAefgkZ3r6
	S0VdwfceSgGGTgQwC6t3p7Df4YkfTghmYpQmYZbJ/vTq5BrjdrTKKX4OuKYXnRnDIu2k7wW0nI8
	uopDkjczzvaDggZuiVy6E0sZfvZhs8Ims4puZFLcGeHJVhN2abkbTgJoszEre4YJaQOS0H0WBYu
	kHOyk2UexIqVX5/hGec8SIFasYDVvlWbLwisGW5aSY8sqD02aUfcsxsII4i48+GC/UyPX94QHZ0
	cWRt+V90WXsSwHZuTQlUASUtRp1fEh7gH0bTkU880sH1wJ8W9jrF9TBkOmbwo+0sX+ZLGlVubfS
	2g5L2W
X-Received: by 2002:a05:600c:4746:b0:490:469c:556b with SMTP id 5b1f17b1804b1-490469c56d6mr377120195e9.12.1779898784031;
        Wed, 27 May 2026 09:19:44 -0700 (PDT)
X-Received: by 2002:a05:600c:4746:b0:490:469c:556b with SMTP id 5b1f17b1804b1-490469c56d6mr377119545e9.12.1779898783505;
        Wed, 27 May 2026 09:19:43 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904561a198sm396774325e9.10.2026.05.27.09.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:19:43 -0700 (PDT)
Message-ID: <63a8bd66-c324-4d2f-9d6b-1ea35e72db5b@redhat.com>
Date: Wed, 27 May 2026 18:19:41 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 13/18] target/arm/kvm: Introduce
 kvm_arm_expose_idreg_properties
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <20260519132905.145643-14-eric.auger@redhat.com>
 <3344B74E-39B1-421D-8417-373A688DB372@nutanix.com>
 <c4a38526-a803-4e69-b6ca-f6bf0583198a@redhat.com>
 <F50EB764-5F22-42AD-89E2-677BF7DB453B@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <F50EB764-5F22-42AD-89E2-677BF7DB453B@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iCQfSnqDu_ZRjcjYEEvfQASlIKVrTxVwOn7LQYwPWFc_1779898784
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 5:44 PM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:02 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> I replied separately to this on your series thread. I am inclined to do
>> so but this raises another problematic for the layered products to know
>> which mismatch can be fixed
>>
>> Thanks
>>
>> Eric
>>
>
> Hence the safe-value tags :), sneak peek to v2 of RFC, with safe-value tags.
> For each prop we can say:
>         ...
>         {
>             "name": "feat_RDM",
>             "supported-values": [
>                 "off",
>                 "on"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_ATOMIC",
>             "supported-values": [
>                 "off",
>                 "on"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_CRC32",
>             "supported-values": [
>                 "off",
>                 "on"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_SHA2",
>             "supported-values": [
>                 "off",
>                 "sha256",
>                 "sha512"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_SHA1",
>             "supported-values": [
>                 "off",
>                 "on"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_AES",
>             "supported-values": [
>                 "off",
>                 "aes",
>                 "pmull"
>             ],
>             "type": "string"
>         }
>         {
>             "name": "feat_NV",
>             "supported-values": [
>                 "0.0"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_RAS",
>             "supported-values": [
>                 "0.0",
>                 "1.0",
>                 "1.1_base"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_MPAM",
>             "supported-values": [
>                 "0.0"
>             ],
>             "type": "string"
>         },
>         {
>             "name": "feat_CSV2",
>             "supported-values": [
>                 "0.0",
>                 "1.0"
>             ],
>             "type": "string"
>         },
I am not sure what the above represents
>         …
>
>
> 	I am inclined to do so but this raises another problematic for the 	layered products to know which mismatch can be fixed
> 	
> I am tempted to make the same argument for writable fields: how will the
> layered products know which values are safe (or effectively can be set?)?
>
> I know right now we don’t agree on keeping safe-value tags or default values.
> But, I hope the above inclines you towards keeping those :) 

OK I think I now understand what you plan to do with safe_rule (which,
as far as I understand is not currently implemented in your v1). With a
"tool" like 

query-cpu-model-expansion you would be able to retrieve the host value. If it does not match your named model default value, you can use the safe_rule to see if it could be applied, without relying on any scratch vcpu instantiation. This makes sense in the context of providing ways for layered products to see which vcpu model can be used, assuming there is no other way like scratch vcpu instantiation.

Is that a correct understanding?

I think this implies that we need to return more information though query-cpu-model-expansion than what we currently do (at least in [1] we only return the value). We would need to return whether the prop value can apply on this host (its default value is same as host value or OK with regards to host value and safe rule and the ID reg field is writable). This most probably means we need to enhance the prop value to contain more fields.

Thoughts?

Eric



>
> Warm Regards,
> Khushit

