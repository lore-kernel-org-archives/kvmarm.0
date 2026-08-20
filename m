Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C832A3769EC
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241703; cv=none; b=efLfiLzv98jS0jjO1Oj1rCJjXZaK2zF5ypTwc46RhWCAL/OChs+3kI1DO+cWkZeZXkslMIqM+smMjwfS4kVJyRuEnpH9kNO1oRo1BzlXF0AUR7CvDm1BSQu9W2Y26twXmV6VjZiNGfbniERys/URlxqIBtx0+Nf00GXslZ5T2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241703; c=relaxed/simple;
	bh=06zNG42WM3X72PodobOxO1H8B5AUDdr2RGkI9CpyyKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t3+LFueE6sIgZ3mSTYxN2MzzXU/YC9fykcNjhU/kFdxbkmwU+/1fvfduhJtaAHNhpEjtQNBYSqarINLK2GFU65UV0cWgtYIaahO/7QPUR0R5Z/RByHoz5YpshgTI9DmrDtFlxy3mmTrCVIAGNpAELlcCOM5aJI4ND33KGkSjRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LzxFGFwv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzxFGFwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787241700;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgxfJA5YmAPMWiGBYOTfNd4f6lfx0My1rIrOn4iPbsE=;
	b=LzxFGFwvrMyTuCDnf+WMNUjClqJLp3x5zKkbxhZZ3DWGt8mFu2IsxRwMBZqdL4SUjNgaWJ
	jLslVU2whBaOZS7lCPUmeoCYVa7QYC3+I3KH6iZSMNyeuLJLFdFMquZ5vzEJjn0ryMgYfw
	++sYmMdeYgjhvy5htqqRPsXH0pZUAbk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-KuDz6SYWNsWAHum1O1NfCQ-1; Thu, 20 Aug 2026 12:01:38 -0400
X-MC-Unique: KuDz6SYWNsWAHum1O1NfCQ-1
X-Mimecast-MFC-AGG-ID: KuDz6SYWNsWAHum1O1NfCQ_1787241698
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4814806ab89so760447f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:01:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787241697; x=1787846497;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jgxfJA5YmAPMWiGBYOTfNd4f6lfx0My1rIrOn4iPbsE=;
        b=pcYxJWYIBnD2QbyC3IFmwonz0L+rCerV4XOj75RN87IBYsDd5Oxco7Wd6OYpC2B5KY
         W7CSoqbkDPpP5qzAieoF0tlG1c6fTMTi2GcJxQ+ZfySrBcp7lH1roC02KhhUmjW5RIVJ
         ITkXRH4Eywvil23nqXxlbeVjaFUNyuEToJRuXi0RClZ+m0bnhjgBHmNBp9eaOFGL8oiO
         Un0Dd0gyzQ5sAlzO41FCIspmpIb/+PFXp5tu/GkTzUTjSRc5KA/9jA/+W+fl5HArKfsY
         g6XzT8glnjPcEILHRa3GsRdti0N5wu7YY4B2svTJB5kOlgDEbaytLJiRuxVCAgkt+f8u
         3bDg==
X-Forwarded-Encrypted: i=1; AHgh+RrXkhNfiJrdmct3lopqTImi6QCuT/8qLoSsG8SHODgqniiac34lzXbAOCIbmiDsHBnWtxw7cGs=@lists.linux.dev
X-Gm-Message-State: AFuF++n6p1Cm7npF9O9dvgq17o7TGsBfJsGneWCZKrRnoA5+9OKoTZFt
	sIAFYxy/BXtkrsk+ng/LCpkQpM9btqowaPm3dO0gQpJBj5KrsqNdnm3wfT1v8eDfnvHE+4LbuFH
	tNIWDnv1a5J7+ApyXkaDrgkhoPmxie7mYgtQGRwWhhpG+bagY0QKtPmtlXg==
X-Gm-Gg: AR+sD10fe6uRgLHILA1plxxrnvm48ytun7mDzW0xEz9RaUBxMNoImFT5sNlbcpW3Yih
	pNyordRBCETl8Lh7w8nm6uT1m6u6Pva0V8UQOWAkAZTzYvVf1k3hUYMBNtYeVUw8uYiXFDdBgii
	jfszg/JKg6xvFWr11lPhhh1jg75QenK7vaEjf2Ub1L8BJ6/6/7RXfAPWt8JthzFcLhiTV25XrMv
	BbKy9w4iNm4Aeq5LZJqjREU+9ssV85B0eTgJf69IymEYj3vl8HfiXYB9+UhYp7tdKkHQx46vaLZ
	HoDU08mjP92n9gO4xbV3QbEz5KCq0Y5U96zA+dKCDVW4PanuMwi9swl9PGXDl1b6ZS98jKNx5SJ
	IgHyieBT0JZcza4JKcxlx4GeyFuHRXwC0emAiL1noYGG35sHs
X-Received: by 2002:a05:6000:4b06:b0:47f:e746:dcab with SMTP id ffacd0b85a97d-482b785dc08mr13918660f8f.10.1787241697509;
        Thu, 20 Aug 2026 09:01:37 -0700 (PDT)
X-Received: by 2002:a05:6000:4b06:b0:47f:e746:dcab with SMTP id ffacd0b85a97d-482b785dc08mr13918516f8f.10.1787241697127;
        Thu, 20 Aug 2026 09:01:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482bf82594esm267911f8f.29.2026.08.20.09.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 09:01:36 -0700 (PDT)
Message-ID: <9ac6089a-2dad-441b-8ec7-f6c03cdad312@redhat.com>
Date: Thu, 20 Aug 2026 18:01:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: Markus Armbruster <armbru@redhat.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-17-khushit.shah@nutanix.com>
 <878q6m5qox.fsf@pond.sub.org>
 <3099C064-6051-4B93-BE0F-C54B7FD91D82@nutanix.com>
 <9909725f-7dd8-4f88-b016-2a6134906a60@redhat.com>
 <676C0BA3-A842-4784-84D2-8B446E8CAB67@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <676C0BA3-A842-4784-84D2-8B446E8CAB67@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jX_0s8KTjF0yCIqihQsD4NyuOKhywYArwAnVnkyTCwM_1787241698
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/18/26 11:46 AM, Khushit Shah wrote:
>
>> On 14 Aug 2026, at 7:08 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 8/5/26 8:47 AM, Khushit Shah wrote:
>>>> On 4 Aug 2026, at 12:15 PM, Markus Armbruster <armbru@redhat.com> wrote:
>>>>
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>
>>>> |-------------------------------------------------------------------!
>>>>
>>>> Khushit Shah <khushit.shah@nutanix.com> writes:
>>>>
>>>>> Introduce the 'query-cpu-props-info' QMP command. For CPU model
>>>>> properties it reports the type (boolean or number) and the set of values
>>>>> supported under the active accelerator and host.
>>>>>
>>>>> For numbers the supported values are expressed as a list of inclusive
>>>>> {min, max} ranges; for booleans as the list of allowed true/false
>>>>> values.
>>>>>
>>>>> The command and its return types (CpuPropertyType, CpuPropertyInfo and
>>>>> friends) are defined in qapi/machine.json rather than an Arm-specific
>>>>> schema, since the concept applies to other targets (e.g. x86, riscv)
>>>>> too. Target that do not implement it return an error.
>>>>>
>>>>> The Arm/KVM implementation spins up a scratch "host" vCPU object,
>>>>> walks its QOM properties: SYSREG_ ID-register fields become 'number'
>>>>> properties whose ranges come from arm_field_get_supported_values(),
>>>>> and the advertised feature toggles become 'boolean' properties.
>>>>>
>>>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>>> This explains what the command does and how it's implemented.  It's
>>>> silent on the most important aspect: why do we want the command?  What
>>>> is its intended purpose?
>>> Will add something like:
>>>
>>> This helps the management stack to discover which values are supported
>>> for a given CPU property. This is especially important for non-boolean
>>> properties, where knowing that the host has value 'x' does not inherently
>>> reveal the full range of valid values supported on the host.
>> How does x86 handle this at the moment, they don't have the cmd either?
>> How do they currently introspect what are the valid values for a
>> specific host? Is it easier for them?
> x86 is much simpler, all the cpu features properties are backed by cpuid bits
> and assumption is simple, if host value is “true”, “false" is supported, and
> if the host value is “false", “true" is not supported.

OK thanks!

Eric
>
> Warm Regards,
> Khushit
>>
>> Thanks
>>
>> Eric
>>>
>>>

