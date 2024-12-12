Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C54C1EEE6
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 13:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734010179; cv=none; b=Ecbn+lU3mbvWwCzcziYd1NEVxxAXBmdP5IZbNDTuniF6k/KbGpO9wQlMPMHhQjUt3zKdXim1p/LZruyFhqLmS+3aE9ft1ZQFK6hvIsHnLPTOC0FtASNjClileXf7PuKb4DgXUsh6pSIIXpDRfsj//eqDkdviOtC1iyHymLM816g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734010179; c=relaxed/simple;
	bh=y+MTHO5ILruYFtyk7+4rRJ5wb4EdgWEzjhT8+z3yK7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SjD0KkAtZKfBv/eO+JxqTlhi7kM7qH4OgJDVviYYPK6jMNJaRHC/jKnTCoH9s2sw6N3J9p5zy5KHGwy8fC+ZjjuC0CG8RUPWR0wjzb/vYfZlGpqfyn3ks1eRUKYPgr0W2YSgxc0Ah+aunf/Gp6xY7p1BAyR0d6WkR296N0fdsdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQLH9IsD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQLH9IsD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734010176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gwEJLU8VfEe4WpG6Kyyy8koTZmYNzH3QNWOlLWxrr8c=;
	b=EQLH9IsDNhhN9BPxTbm9f4Au8DhacMvhSIeSqZSEogy+eFXwRyUmAAnKdzJ1iSNVA4waNI
	IaFe/bZmmsPAomciVQEPMlcLJMBwzdRNFlTYMAjCsXbzk9k+lsnl+XWk4aySNSfFrW89Bj
	zcTJm8/1NVT2gO5tRfOJxpBORkBaQ8Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-CDWxhI8pNHeFzq321fmahg-1; Thu, 12 Dec 2024 08:29:35 -0500
X-MC-Unique: CDWxhI8pNHeFzq321fmahg-1
X-Mimecast-MFC-AGG-ID: CDWxhI8pNHeFzq321fmahg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862be3bfc9so354000f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 05:29:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734010174; x=1734614974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gwEJLU8VfEe4WpG6Kyyy8koTZmYNzH3QNWOlLWxrr8c=;
        b=SNtzRQp5jUlN+tQXh/n8bwzMzgTCcCxcxm/m1bqjWGZds4WeEprdGd76MdasB/fFOl
         dMxESn3J6WUsfdw433lxFlRUsfZRTDRZabWEsXSdxk/jiT3zjshL3PLNQctN3ucWUoPt
         Un/MUiN3pZHnT/1BqLlkMH69/X/WvcfU0yfb/18cSDOVk8Yi7nxrZHyXQDRkFgejy+SR
         tHex46kg2iydeuKrEO0inwkKpkS8pxmSsx7aus77BA4mEnRbpR7jp0MJ9jx6dsc0j6uT
         4bIziSOSk1/E4vcEex8TKBoyel3pS84+/kZ0LuHs+s2W43t/MiyzDYIf6nfKWFKtwEzq
         yGMA==
X-Forwarded-Encrypted: i=1; AJvYcCXs8SdIvdXaQWWThHGauFMvDBI+IcE2z9NUTR74NcMNLwTQFaUiQcA2J7YsspXH7Guf4seOg4A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaXZK4Wj3HuvLyGqzVbDWbKt+lC8SZka47mGDnk8eYDXkY16ex
	NgR7mfc8UW0fmJf1SW7yBSirGYBKvFyHniRmMrnLrLDWe+r2O+CcPtx0Ze1WnlH+Ix/MKld6gRK
	ePFZ42CFw82EcM9fce/nEK94OG3fxJDYtuOKUzTUoyauxdfTzc2T05g==
X-Gm-Gg: ASbGncu48oeHi4LFE6jD7NzI3zHzuX2R2kaKssWUFpTcI1I1ndkBbHA4uzOYwoeAzCA
	7HJqpEqtoFirYUpdmW7vMdxeD8Pl1/uR/p4M57F0EClHjEtxxsh5Bkxeehasn0P5ta1hQXASa7B
	DIJz0gOP6E7IybfkOoPwfyMpasPv1WdmaGao/pvfbDCJN8kmovyWRyLUqY2g1iqedk3Xs5I/QAn
	jIVFX91yhfO0PTV0nxQlJ83JIpv0kbP36cKMXVt58Fob2m+4XDPFhGVMFl1IU7fDMcwG/TucEx5
	JNTQifb4STJ3LfUr8Oej1Lw=
X-Received: by 2002:a5d:64ab:0:b0:385:c511:240a with SMTP id ffacd0b85a97d-38787696b5amr2543349f8f.25.1734010174186;
        Thu, 12 Dec 2024 05:29:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTfSI/0zDLuU0Exc652J9apgcTbTgWAF7L89bL0PLGIQC9v8M+acncx/nDbCMCg2misxlIvw==
X-Received: by 2002:a5d:64ab:0:b0:385:c511:240a with SMTP id ffacd0b85a97d-38787696b5amr2543320f8f.25.1734010173698;
        Thu, 12 Dec 2024 05:29:33 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782514db8sm4103844f8f.84.2024.12.12.05.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 05:29:32 -0800 (PST)
Message-ID: <7b29665f-a9b5-4f51-ace1-7bad4eaba10c@redhat.com>
Date: Thu, 12 Dec 2024 14:29:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "alex.bennee@linaro.org" <alex.bennee@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
Cc: "shahuang@redhat.com" <shahuang@redhat.com>,
 "mark.rutland@arm.com" <mark.rutland@arm.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Wangzhou (B)" <wangzhou1@hisilicon.com>, Linuxarm <linuxarm@huawei.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <38604260-6f92-4f16-9a4d-c310cbc52d77@redhat.com>
 <4fb49b5b02bb417399ee871b2c85bb35@huawei.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <4fb49b5b02bb417399ee871b2c85bb35@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WJP4--ttO3fs0aWDQ2XbM7nqFvcs1ijJDkHor9XPaYs_1734010174
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shameer,
On 12/12/24 14:09, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: Eric Auger <eauger@redhat.com>
>> Sent: Thursday, December 12, 2024 8:42 AM
>> To: eric.auger@redhat.com; Cornelia Huck <cohuck@redhat.com>;
>> eric.auger.pro@gmail.com; qemu-devel@nongnu.org; qemu-
>> arm@nongnu.org; kvmarm@lists.linux.dev; peter.maydell@linaro.org;
>> richard.henderson@linaro.org; alex.bennee@linaro.org; maz@kernel.org;
>> oliver.upton@linux.dev; sebott@redhat.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
>> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
>> Cc: shahuang@redhat.com; mark.rutland@arm.com; philmd@linaro.org;
>> pbonzini@redhat.com
>> Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable
>> aarch64 KVM host model
>>
>> Shameer,
>>
>> On 12/12/24 09:12, Eric Auger wrote:
>>> Connie,
>>>
>>> On 12/6/24 12:21, Cornelia Huck wrote:
>>>> A respin/update on the aarch64 KVM cpu models. Also available at
>>>> gitlab.com/cohuck/qemu arm-cpu-model-rfcv2
>>>>
>>>> Find Eric's original cover letter below, so that I do not need to
>>>> repeat myself on the aspects that have not changed since RFCv1 :)
>>>>
>>>> Changes from RFCv1:
>>>>
>>>> Rebased on more recent QEMU (some adaptions in the register
>> conversions
>>>> of the first few patches.)
>>>>
>>>> Based on feedback, I have removed the "custom" cpu model; instead, I
>>>> have added the new SYSREG_<REG>_<FIELD> properties to the "host"
>> model.
>>>> This works well if you want to tweak anything that does not correspond
>>>> to the existing properties for the host model; however, if you e.g.
>>>> wanted to tweak sve, you have two ways to do so -- we'd probably either
>>>> want to check for conflicts, or just declare precedence. The kvm-specific
>>>> props remain unchanged, as they are orthogonal to this configuration.
>>>>
>>>> The cpu model expansion for the "host" model now dumps the new
>> SYSREG_
>>>> properties in addition to the existing host model properties; this is a
>>>> bit ugly, but I don't see a good way on how to split this up.
>>>>
>>>> Some more adaptions due to the removal of the "custom" model.
>>>>
>>>> Things *not* changed from RFCv1:
>>>>
>>>> SYSREG_ property naming (can be tweaked easily, once we are clear on
>> what
>>>> the interface should look like.)
>>>>
>>>> Sysreg generation scripts, and the generated files (I have not updated
>>>> anything there.) I think generating the various definitions makes sense,
>>>> as long as we double-check the generated files on each update (which
>> would
>>>> be something to trigger manually anyway.)
>>>>
>>>> What I would like us to reach some kind of consensus on:
>>>>
>>>> How to continue with the patches moving the ID registers from the isar
>>>> struct into the idregs array. These are a bit of churn to drag along;
>>>> if they make sense, maybe they can be picked independently of this
>> series?
>>>>
>>>> Whether it make sense to continue with the approach of tweaking
>> values in
>>>> the ID registers in general. If we want to be able to migrate between
>> cpus
>>>> that do not differ wildly, we'll encounter differences that cannot be
>>>> expressed via FEAT_xxx -- e.g. when comparing various AmpereAltra Max
>> systems,
>>>> they only differ in parts of CTR_EL0 -- which is not a feature register, but
>>>> a writable register.
>>> In v1 most of the commenters said they would prefer to see FEAT props
>>> instead of IDREG field props. I think we shall try to go in this
>>> direction anyway. As you pointed out there will be some cases where
>> FEAT
>>> won't be enough (CTR_EL0 is a good example). So I tend to think the end
>>> solution will be a mix of FEAT and ID reg field props.
>>>
>>> Personally I would smoothly migrate what we can from ID reg field props
>>> to FEAT props (maybe using prop aliases?), starting from the easiest 1-1
>>> mappings and then adressing the FEAT that are more complex but are
>>> explictly needed to enable the use cases we are interested in, at RedHat:
>>> migration within Ampere AltraMax family, migration within NVidia Grace
>>> family, migration within AmpereOne family and migration between
>> Graviton3/4.
>>>
>>> We have no info about other's use cases. If some of you want to see some
>>> other live migration combinations addressed, please raise your voice.
>> In relation to [1] you seem to be also interested in the migration
>> between heterogeneous systems with qemu.
> 
> Yes. That is correct.
> 
>> Do you think targeting migration within a cpu family is enough for your
>> use cases. How different are the source and destination host on your
>> cases. Do you thing feat props are relevant in your case or would you
>> need lower granularity at idreg field levelto pass the migration?
> 
> I think, from the current requirement we have for migration, the source and
> destination mostly can be handled by FEAT_XXX. But like Ampere, we do need
> to manage the CTR_EL0 differences[1].
OK
> 
> Also we do have differences in GIC support as well(AA64PFR0_EL1.GIC) which 
> I am not sure how to manage with FEAT_XXX.
interesting. We need to further look at this one.
> 
> And we are checking with our Product team whether we need to support migration
> from an old CPU type in which case we have to do a bit more analysis.
Sure, please come back to us whenever you get more insights. It will
help us define the scope of this upstream work

Thanks!

Eric
> 
> Thanks,
> Shameer
> 
> 1. https://lore.kernel.org/kvmarm/20241022073943.35764-1-shameerali.kolothum.thodi@huawei.com/
> 
> 
> 
>  
>  

