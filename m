Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A09F35898
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981753; cv=none; b=YuykOuCmX4zIqMk6qALIafOWdfUXL0/XMyevuGx49g3IVfTv/E4iiwDz8wwujj8Wrbh1eAf6pwZHYbI1oSq31A0UhPVueLpJ0yJUJPMh9GOkqZGeL5inlUxUDZV8r+TOIqFeUe5ySWdWHudUpOxdMDzeBKE8u4Z+IuivqX3ujNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981753; c=relaxed/simple;
	bh=tR1RLrZH+YYSCUvU9faS8RudRldNvWUquE8MiVfpiSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WEf82a7D10EtkTY4dlYkSG/2khOObpQ5n121FLU0Xm/3ywCD2kpXv5dqhH3uKpVNxLx58aiNy1MIb7VSw+NIDgmMuvWt+tDjxqPoVaudBiSnP80uhKiLscF4D5gWSkwR1sg9Ok9lhuMQWp+Cib8bTR+7Fbl+sro+95a0eNKxPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jMrctJk+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jMrctJk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779981752;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWiwiiY+LDiQr0yd8VQcVqBy0PYAtYZ/fqvE6dB6fvA=;
	b=jMrctJk+4UHyCJbcpDQlGCJoxcvLT596rYYTL6IoIwEqs4Ow+AqJAwBgHBOIEdrB0GGgdA
	7CfkobKV5lrQdFGMOx9f85XkFdkTzrdGZpPXXhA9HGdx7kTpi8ClaL+M41Mbwcs7NFpTx1
	OwVxqPrRXQYgoP2K78ka7m3080n/TUc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-pB9EbIKAOEKqE22ko-qvTg-1; Thu, 28 May 2026 11:22:31 -0400
X-MC-Unique: pB9EbIKAOEKqE22ko-qvTg-1
X-Mimecast-MFC-AGG-ID: pB9EbIKAOEKqE22ko-qvTg_1779981750
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49048e21ea7so33390085e9.1
        for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 08:22:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779981750; x=1780586550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWiwiiY+LDiQr0yd8VQcVqBy0PYAtYZ/fqvE6dB6fvA=;
        b=AtFpojfi6lDtF9nP8wciRNp9PXeXncV2Zq+dHAyLU/qX1l74RVFA71Iw39onbc2not
         Qwq9/smtTi71a6yp7sjM6EJI4kHaq5moC8mEx7lXJTuENh+6lWAV0eyWlXPhntXv3yEv
         zWIqO5SwzanI9rWEh7msSpCQEDZKQcFHddPJoPEyN/zebuh2AzUPJN11IVV2SUrF6S3N
         sb0e8f+KOhdw734kDK0cxv9sgp4Zb9cxWpFdi0ECZ2WOLbp02PuaVvloZ3lsrFKTyjFH
         GCzPiOw+90vOWByEbf29ggduVlXfSXX6H2WlMKHwY1hxzJpdc4H0hzZOlE9jBOZWvH9y
         hbZw==
X-Forwarded-Encrypted: i=1; AFNElJ9kj6vTb6a7qjg5B0XzivZWbr/EsCuOKvA6e3YDwfoyIqEmZ4BuzcacSci2WJJwVbS3E57T/3s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqgjSh1yFi3iT4I0TTVlTXPUFctdA8wfHD8anzc26YMfagvv6f
	eDpCK0OL7U/0/+MWssoXhlD5LFOsvMNOqWCsNOy/ME6ksM3E5/ZbpcubyAZEG5hkU0WeYf0nJSW
	wJOGjn7VHMd/D3qxzVsuXXhja+mSwAdzw0qJQb5P5hEzVlzpKnHYqlM8tCg==
X-Gm-Gg: Acq92OHWu1ry9tyodkeHfzP3g0nuo5HkDLxMReoeMWhWZiGpQzjtuqg0mThtFVhq/oC
	RKKFL2gn6mwAym5UTVwwtmcy5YzNrKbLGmUcc+FNx19aLVzaWmpuGknXvYkyxhgT33bCh3Ve7zo
	7jApmfrsRa3spsp0di08qbQWdmtalvuWZQzVLpbci4qSwk3SXVjb4KnZfO14LsIiY2xE4JKwSCU
	inzsoYTXdAspWihTw3m3LBupGWfkjP7BSKEOVkW1e4yeEB0vkEEb4jgWl0Lolxd5B+PgOa5sLUp
	7EnQvm11SotfDZnA+LYePTtRzOHUyb0maUqWhXltAWyui8pgWlk4JqS9TKGaZoYrS3HqhqTQLix
	41Movkhdpk6/q66V3tdDJBuoz7tpai/JWLAfzBtXzrDNaC9jJdZ90Wm9vTahG5uA3wV7L3Fmszh
	uo5eRY
X-Received: by 2002:a05:600c:528c:b0:490:3b8a:b0c with SMTP id 5b1f17b1804b1-490947779d4mr37582215e9.3.1779981749904;
        Thu, 28 May 2026 08:22:29 -0700 (PDT)
X-Received: by 2002:a05:600c:528c:b0:490:3b8a:b0c with SMTP id 5b1f17b1804b1-490947779d4mr37581675e9.3.1779981749452;
        Thu, 28 May 2026 08:22:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eed49f19bsm2222373f8f.14.2026.05.28.08.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 08:22:28 -0700 (PDT)
Message-ID: <294d4e4b-6ddf-412c-9a47-24aab232a2b8@redhat.com>
Date: Thu, 28 May 2026 17:22:27 +0200
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
 <63a8bd66-c324-4d2f-9d6b-1ea35e72db5b@redhat.com>
 <47CCCA9C-EE35-4314-9619-50F28BFFB0AD@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <47CCCA9C-EE35-4314-9619-50F28BFFB0AD@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GgveUSEKyz-kwIJ5C-waqgRkv9eYz5RnxGc9GIL00bM_1779981750
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/28/26 7:07 AM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:49 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 5/27/26 5:44 PM, Khushit Shah wrote:
>>>> On 27 May 2026, at 9:02 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>
>>>> I replied separately to this on your series thread. I am inclined to do
>>>> so but this raises another problematic for the layered products to know
>>>> which mismatch can be fixed
>>>>
>>>> Thanks
>>>>
>>>> Eric
>>>>
>>> Hence the safe-value tags :), sneak peek to v2 of RFC, with safe-value tags.
>>> For each prop we can say:
>>>        ...
>>>        {
>>>            "name": "feat_RDM",
>>>            "supported-values": [
>>>                "off",
>>>                "on"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_ATOMIC",
>>>            "supported-values": [
>>>                "off",
>>>                "on"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_CRC32",
>>>            "supported-values": [
>>>                "off",
>>>                "on"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_SHA2",
>>>            "supported-values": [
>>>                "off",
>>>                "sha256",
>>>                "sha512"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_SHA1",
>>>            "supported-values": [
>>>                "off",
>>>                "on"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_AES",
>>>            "supported-values": [
>>>                "off",
>>>                "aes",
>>>                "pmull"
>>>            ],
>>>            "type": "string"
>>>        }
>>>        {
>>>            "name": "feat_NV",
>>>            "supported-values": [
>>>                "0.0"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_RAS",
>>>            "supported-values": [
>>>                "0.0",
>>>                "1.0",
>>>                "1.1_base"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_MPAM",
>>>            "supported-values": [
>>>                "0.0"
>>>            ],
>>>            "type": "string"
>>>        },
>>>        {
>>>            "name": "feat_CSV2",
>>>            "supported-values": [
>>>                "0.0",
>>>                "1.0"
>>>            ],
>>>            "type": "string"
>>>        },
>> I am not sure what the above represents
> This is truncated output of similar qmp command as cpu-model-expansion, which returns for each prop what
> values can be set. For example MPAM is not writable by KVM, hence only one supported value “0.0”,
> CSV2 on the host is only “1.0” (architecturally, 2.0 is also valid), hence only “0.0” and “1.0” in the supported values.
>
>>>        …
>>>
>>>
>>> I am inclined to do so but this raises another problematic for the layered products to know which mismatch can be fixed
>>>
>>> I am tempted to make the same argument for writable fields: how will the
>>> layered products know which values are safe (or effectively can be set?)?
>>>
>>> I know right now we don’t agree on keeping safe-value tags or default values.
>>> But, I hope the above inclines you towards keeping those :)
>> OK I think I now understand what you plan to do with safe_rule (which,
>> as far as I understand is not currently implemented in your v1). With a
>> "tool" like 
> Yes not implemented in v1.
>
>> query-cpu-model-expansion you would be able to retrieve the host value. If it does not match your named model default value, you can use the safe_rule to see if it could be applied, without relying on any scratch vcpu instantiation. This makes sense in the context of providing ways for layered products to see which vcpu model can be used, assuming there is no other way like scratch vcpu instantiation.
>>
>> Is that a correct understanding?
> Yes!!! 
>
>> I think this implies that we need to return more information though query-cpu-model-expansion than what we currently do (at least in [1] we only return the value). We would need to return whether the prop value can apply on this host (its default value is same as host value or OK with regards to host value and safe rule and the ID reg field is writable). This most probably means we need to enhance the prop value to contain more fields.

I imagined we could return all the data
through query-cpu-model-expansion but it seems you plan to use another
qmp cmd. Let's see what it looks like in your v2

Thanks

Eric
> Sorry, did not fully understand this.
>
> Warm Regards,
> Khushit
>
>> Thoughts?
>>
>> Eric
>>
>>
>>
>>> Warm Regards,
>>> Khushit

