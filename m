Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F418460
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779887940; cv=none; b=EVuDNyGou0SOt0yhbnSZBpBdqYNiaBWryzVP3vFj9DQ3dfLq64q+2FeqBpPXYStvRZrM62Rf1tg1pJ/shjEL8Ts71jfm28QTa8SSwUZgs0+okuhcNyI6MkaFcSEaZgJagAg7kmr0Rl02AHXGg6VD3/DflSylh9QP2KX91L4EL0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779887940; c=relaxed/simple;
	bh=KSDCuzi80VXnso1HFcGdqtND3O7cmPwKqLA8sZiAINY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dmwaZvLqJwV1KTfj1ZJxX/wmkDOY4P9G2MPNuqs/E8Iud8ob+YuzQx7t/d7s0nUUhmWrJ5qlneEWR1vjBvo/kDCNZvYvtiiR9VJtUSyxTDkihzHJw7QbxaDzbMdHPFYWtq9zKFnliIXsFg+nVo6dbEdxa8+BgMQhC8V5eyLr3TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSe4XLwv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSe4XLwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779887936;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2Io4MP4kG86KiNEjyBD1gl5IoTBoLzyxcVs+R99hOk=;
	b=bSe4XLwvRjidBmBrECKqOn7xADXBt1ii99kyabgkPa8QfHOa1627/o8ZMarg+VQ+S6u6/n
	dIscoNQ9AG/gOW+5yY6mRCenv76a1JV1FthSw1R/+JW08UUfnvdoZ2zOVDfWHf0e8AIjwN
	4v2TFw4Lub7Tz++SSeh+JhlixHbSXHo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-7rJ2405xPxiWPvlexActQg-1; Wed, 27 May 2026 09:18:53 -0400
X-MC-Unique: 7rJ2405xPxiWPvlexActQg-1
X-Mimecast-MFC-AGG-ID: 7rJ2405xPxiWPvlexActQg_1779887931
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45e2f74da10so11101623f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 06:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779887931; x=1780492731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B2Io4MP4kG86KiNEjyBD1gl5IoTBoLzyxcVs+R99hOk=;
        b=aSQYzpnw+GC8pP19tMW5+5icmvrHxn7b7iq19ayUrgdtqabD4WIcLdifvW/dUpR8LF
         /1pkBB9PskwcFPOYjZGSStwzHx3raRNJU6N2S0+SCVhAYnJJw+SGhKe47V1VddzoFeSF
         Kd/lWqTI7QEy9l6mIjhkDNW2Qtw8nLa2vSTqWxfoY3GoGun7u7HvWDzMJNjEfGRX+QLA
         yx2cFsGXpDjGD3mEYepQ+gEnTeKmUqFYS5TY+1zJd5J6WoXtLW3gAPhT4ESkD17xk7j5
         f7ssV18wUFFZv9ndnCMGPlyv5QZ6JALWXRe5wHKff2TT1pLgBic94uA6QB+1VSl5irXv
         E1vw==
X-Forwarded-Encrypted: i=1; AFNElJ+o41r/ZCepO/GK2ttwRoAqkArQ2IAyxsgoqGs7OPGkOvpK+rM6o3AteRijRAycAzD3W/D0lBc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2Af858+yF44a8t5W4zEAiWMNfn2TcAc51/eV1ysBv+T8/zFNz
	y7gEOkg1gydQ6RFdRb2GrSPMKWwo9vLF4dhfd2oqUV66gzrC2tR70YwfOozajRD4CRT15cX+GMn
	U9N9BbGO6zVN6EppDPAGu9BBSBY9SuYT/qGi7SluA8UkHpsucEN4AimVhdQ==
X-Gm-Gg: Acq92OFfuQenCfhJ8wPUcreOxb12pFYENVNE+2Rvx6whP0rnVb/Equ6vbakl4kU4grj
	IadUUB7S2FlXH0AaA9MN5TEmIzG3SDS2rz1nxJ/k5+fxyHw7hVFcc35ns7Kv09++DasJt8WCdBl
	D1QuNA1a6RYTivYcJnaRlMGpR6rs+zQO2hFNVU+vMnO2I/12OCatIsen2lMbdX7E4rqBXr0Xfxm
	7neoJneVW7YeZRxAXgJR2JpHJrplq48dOrZiB996/maijfJ4LyC0EjE+Y+prtqbm1Bu66SbA3gr
	mSeCLgwIoRa7yvkKHn9Qd/1tYIbW3HYW06v1xNHSPlxuhy+qkqCFJIRlVqA9J2rzMw2ZgrGssGd
	xK0230DKOW9V8I9eIo3PqA23071qY6nVU6udWJ6CuZrgsV57+9sHdRQn6m/27PphTr/C1lRJZVb
	MNrtjR
X-Received: by 2002:a05:600c:4e14:b0:490:5cb3:e936 with SMTP id 5b1f17b1804b1-4905cb3eb00mr285899145e9.4.1779887930734;
        Wed, 27 May 2026 06:18:50 -0700 (PDT)
X-Received: by 2002:a05:600c:4e14:b0:490:5cb3:e936 with SMTP id 5b1f17b1804b1-4905cb3eb00mr285898345e9.4.1779887930184;
        Wed, 27 May 2026 06:18:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5b28absm6135205f8f.27.2026.05.27.06.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 06:18:49 -0700 (PDT)
Message-ID: <e5637cd7-8bfa-4e67-b34f-474e5d34e015@redhat.com>
Date: Wed, 27 May 2026 15:18:47 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v1 00/13] named CPU models for ARM64 on KVM
To: Khushit Shah <khushit.shah@nutanix.com>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>
Cc: Shaju Abraham <shaju.abraham@nutanix.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 Andrea Bolognani <abologna@redhat.com>
References: <20260513163356.3033159-1-shaju.abraham@nutanix.com>
 <dd4744c5-6f89-4377-b28a-24b2ebc23412@redhat.com>
 <A392F312-5956-4490-92FA-7C6E2211F37B@nutanix.com>
 <c4c3ee0c-7b27-4808-921a-5079095eedb0@redhat.com>
 <4660A09C-11BA-4706-A455-60DC536C018E@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <4660A09C-11BA-4706-A455-60DC536C018E@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dx7NebStdEdY_VRpJzHMZmLYfl7VPbKv8fyBKNrGGO4_1779887931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,
On 5/22/26 9:59 AM, Khushit Shah wrote:
>
>> On 20 May 2026, at 8:57 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 5/20/26 3:08 PM, Khushit Shah wrote:
>>>> On 19 May 2026, at 9:21 AM, Shaju Abraham <shaju.abraham@nutanix.com> wrote:
>>>>
>>>>
>>>>
>>>> Get Outlook for Mac 
>>>> From: Eric Auger <eric.auger@redhat.com>
>>>> Date: Monday, 18 May 2026 at 3:57 PM
>>>> To: Shaju Abraham <shaju.abraham@nutanix.com>, qemu-devel@nongnu.org <qemu-devel@nongnu.org>, qemu-arm@nongnu.org <qemu-arm@nongnu.org>, kvmarm@lists.linux.dev <kvmarm@lists.linux.dev>, peter.maydell@linaro.org <peter.maydell@linaro.org>, richard.henderson@linaro.org <richard.henderson@linaro.org>, cohuck@redhat.com <cohuck@redhat.com>, sebott@redhat.com <sebott@redhat.com>, skolothumtho@nvidia.com <skolothumtho@nvidia.com>, philmd@linaro.org <philmd@linaro.org>, Andrea Bolognani <abologna@redhat.com>
>>>> Subject: Re: [RFC PATCH v1 00/13] named CPU models for ARM64 on KVM
>>>>
>>>> !-------------------------------------------------------------------|
>>>> CAUTION: External Email
>>>>
>>>> |-------------------------------------------------------------------!
>>>>
>>>> Hi Shaju,˝
>>>>
>>>> On 5/13/26 6:33 PM, Shaju Abraham wrote:
>>>>> Hi All,
>>>>>
>>>>> This RFC introduces "named" CPU models for ARM64 KVM guests. This
>>>>> is foundational for cross-host live migration and management-stack
>>>>> control over individual CPU features exposed to the guest.
>>>>>
>>>>> TL;DR Examples:
>>>>> # Boot with Grace CPU model
>>>>> qemu-system-aarch64 -cpu grace-v1 -machine virt,accel=kvm ...
>>>>>
>>>>> # Grace with a feature disabled
>>>>> qemu-system-aarch64 -cpu grace-v1,feat_SHA1=off ...
>>>>>
>>>>> # Host passthrough with individual feature control
>>>>> qemu-system-aarch64 -cpu host,feat_AES=aes ...
>>>>>
>>>>> # Neoverse v2 on Grace.
>>>>> qemu-system-aarch64 -cpu neoverse-v2-v1
>>>>>
>>>>> # Migration from Grace to Graviton3 (TBD)
>>>>> qemu-system-aarch64 -cpu neoverse-v1-v1 ...
>>>>>
>>>>> Relationship with Auger/Huck's customizable host model [1]:
>>>>> We have been working on this series in parallel with [1]. Eric Auger and
>>>>> Cornelia Huck's series [1] exposes raw SYSREG_<REG>_<FIELD> uint64
>>>>> properties on -cpu host, providing the essential low-level knobs for ID
>>>>> register customization. This RFC builds on the same KVM capability
>>>> Please find some comments/questions below.
>>>>> and can be layered on top of [1]:
>>>>> - Human-readable property names: feat_AES=pmull instead of
>>>>>   SYSREG_ID_AA64ISAR0_EL1_AES=2, with arch-defined named values
>>>>>   validated at set time.
>>>> From what I understand what you call feature here refers to an
>>>> ARM64_FTR_BITS definition in kernel arch/arm64/kernel/cpufeatures.c.
>>>> Named string values, safe policy and safe value are all extracted from
>>>> the kernel implementation and do not stem from the ARM ARM itself.
>>> Correct, a  CPU feature (that we talk about) is not the same as ARM ARM
>>> defined FEAT_*. As you say below, they really are much more complex to
>>> model. But `sve`, `pauth` defined by QEMU, are also not an ARM ARM
>>> defined FEAT. Because of the complexities of ARM ARM FEAT_s, we decided
>>> to go with ID register field-based properties with abstractions like (fractional
>>> and composites) on top.
>>>
>>> Yes, value names, safe policy, and safe value are taken from the kernel. But
>>> in most cases, value names already correlate with ARM ARM.
>>>
>>> For example,ID_AA64ISAR1_EL1.LS64:
>>>
>>> ARM ARM says:
>>> FEAT_LS64 implements the functionality identified by 0b0001.
>>> FEAT_LS64_V implements the functionality identified by 0b0010.
>>> FEAT_LS64_ACCDATA implements the functionality identified by 0b0011.
>>> FEAT_LS64WB implements the functionality identified by 0b0100.
>>>
>>> Named values in cpu-idregs.h.inc:
>>> IDREG_FIELD_START(ID_AA64ISAR1, LS64, 60, 4, EXACT, 0)
>>> IDREG_FIELD_ARCH_VAL(0b0000, "off")
>>> IDREG_FIELD_ARCH_VAL(0b0001, "ls64")
>>> IDREG_FIELD_ARCH_VAL(0b0010, "ls64_v")
>>> IDREG_FIELD_ARCH_VAL(0b0011, "ls64_accdata")
>>> IDREG_FIELD_ARCH_VAL(0b0100, "ls64wb")
>>> IDREG_FIELD_END(ID_AA64ISAR1, LS64)
>>>
>>> Values names are: lowered feat names with FEAT_ removed.
>>>
>>> For “on”/“off” toggle features: for example (XS, just below LS64):
>>> We have:
>>> IDREG_FIELD_START(ID_AA64ISAR1, XS, 56, 4, LOWER, 0)
>>> IDREG_FIELD_ARCH_VAL(0b0000, "off")
>>> IDREG_FIELD_ARCH_VAL(0b0001, "on")
>>> IDREG_FIELD_END(ID_AA64ISAR1, XS)
>>>
>>> ARM ARM says:
>>> FEAT_XS implements the functionality identified by 0b0001.
>> I agree with you on the fact that in general the association is fine. I
>> am confident that developpers who wrote 
>>
>> arch/arm64/kernel/cpufeatures.c did it in a sensible way. Still the problem comes when the end user/layered products have to guess those string values which are documented/defined nowhere besides in cpufeatures.c. How will they come to know which string values are supported and how they map onto any valid ARM ARM ID reg value? You cannot point them to any reference doc. Refering to past comments, Marc said he would even prefer not using
> We can absolutely point them to a reference doc, like cpu-features.rst,
> where we can document, property names, supported values and their meaning. 
>
>> kernel sysreg as a root of trust (hence the choice of extracting info from AARCHMRS) so I anticipate using arch/arm64/kernel/cpufeatures.c as input may be frown upon. But I may be wrong.
> Okay, will wait for community to reply on this.
>
>> I guess the usage of string values really depends on how many props layered products or user will need to set explicitly. Assuming we expose named models and this will be the main use case, my assumption is quite a few props will remain to be overriden on top of named model hardcorded values. And since the prop granularity is very low level anyway, if the end user has to identify and set an ID reg field, it can also set the associated uint64 value directly.
>>
>> My point is that compared to the original series Connie and I have been pushing,
>> - you still use the same prop granularity (ID reg field), somehow abusively called feature
> Not all are prop granularity are field level, FRAC and COMPOSITES (like
> sve, pauth for named models, will be in v2) are higher level constructs.
Currently only FRAC prop abstraction differ.
>
>> - you add significant complexity related to the string values (which are not referenced anywhere in the spec)
>> - you also add significant complexity related to different kinds and name patterns of props (FRAC, STRING, BOOLEAN, NUMERIC) while we only used SYSREG_REG_FIELD uint64_t props.
>>
>> While I am really interested in layering up named models on top of ID reg field properties, or even a real feature upper level abstraction, I am not sure the above extra complexity is worth while keeping the original IDreg field granularity.
>>
> Ignoring the prop names and value names which seems to be your main
> concern, our named model realization are not tied to those. They can
> work on top of SYSREG_<REG>_<FIELD> props.
Well, there is also the need/usage of safe policy and default value, see
below.
>
>>> There may be a few value names that do not make sense right now, but
>>> that does not de-merit the idea that perfectly works for most fields.
>>>
>>> Regarding the safe-value tag, I feel that it is the one thing that must come
>>> from the kernel; in the end, KVM is gonna validate based on that. If the
>>> static file feels problematic, another option is to introduce a new KVM ioctl. 
>>> We are fine with both.
>> safe policy and value are kernel defined. To be honest I still fail to
>> understand why they are mandated for named vcpu models. Please could
>> elaborate again?
> Use of safe-policy tag in QEMU: 
> - validate the configuration generated by named model or -cpu host,
>   with modified props are valid and not over promising host capability.
>   (Which you say to just delegate to KVM, x86 also validates in:
>    x86_cpu_filter_features, and blocks realization in x86_cpu_realizefn
>    if `enforce` is passed.). 
where is the safe rule currently used in this series?
> - Properly report blockers in query-cpu-definitions. Without safe-value
>   tag, it is not possible to report per ID reg field blockers in
>   query-cpu-defnitions.

How does query-cpu-definitions help today?
query-cpu-definitions does not seem to return that kind of info.
Filtering host cpu model it just returns:
{"name": "host", "typename": "host-arm-cpu", "static": false,
"deprecated": false}


>
>
>> Why can't you start from the host values and override them with the
>> named vcpu model settings? If the new value cannot be applied by KVM, it
>> will reject it and fail the vcpu init.
> I think you are mixing up two things. For safe-value tag argument, Yes,
> but then what about proper query-cpu-definitions integration?
See above, what do you mean?
>
> For named model we cannot start with host-values. As different KVM versions
> or host might expose different set of fields, or ARM ARM defining a new
> ID register or a new field in existing ID register.
I understand a named vcpu model shall be fully determined, ie. all ID
regs shall be set to a relevant value determined by the vcpu model.
To me those default values rather depend on the VCPU model. a v8 default
value may not be the same as a v9 value because a feature has become
mandated. So why aren't the default values set within the vcpu model
definition instead of intarget/arm/cpu-idregs.h.inc?

Then you have 2 categories of fields: writable or not. If you want to
try and set all field values, effectively you may need to define props
for fields which are even not writable. This can easily evolve from the
original series [1].
>
> A model needs to be future compatible and provide exact set of ID register
> values on any host/kernel it runs on.
I am not really sure this is always feasible. Assuming there is a bug
fix in the kernel that changes the way an ID reg access is
sanitized/accepted/rejected, you may break the vcpu model. ie. a former
ID reg value may have been accepted and is not anymore or conversely.

But on the principle I agree with you.
>
> This is the exact reason why we have default values. Simply 0ing the whole
> idregs[] does not work because of SIGNED_LOWER features like FP (and more)
> or RES1 fields in CTR_EL0 etc; Something should say what the default value
> of a register should be.
yeah but still isn't it named model specific?
>
>> Moreover if one ID reg field that needs to be overriden is not writable
>> with that host kernel, the prop won't exist and the named model won't
>> work on that host either.
> Why only add prop for writable fields in [1]? There must be props for all
> fields. Anyway if non writable fields differ, it will be caught by KVM.
Up to now the goal of [1] was slighly different, ie. allowing to slighly
alter ID reg values compared to host passthrough values so that the
model becomes migratable between 2 machines. We had cases where only
altering one CTR_EL0 field made it migratable for instance. Also in [1]
there was not real point exposing a property for an ID reg field that
was not writable. However I agree on the fact that for named models
things need to be more determistic and you also need to try applying
values that are not writable and see if they are the same that host
default value.
>
> For example, a named model might be blocked because of a non-writable field
> is differing from host and the prop for the same is not present. (Let’s say
> model abc, wants field FP=fp16 (not writable by KVM), but the host has value
> FP=on).
>
> But user should be absolutely be able to make the model realisable by passing
> -cpu abc,FP=on.
agreed
>
> Even without named models, I assume end goal of customisable host models would
> be a way to see if on a cluster of slightly differing cpus can we have a common
> denominator of features to expose to enable migration between hosts. If we do
> not exposes non-writable fields, how will higher stack know what are the values
> of non-writable fields on a host? And if non-writable fields are ignored, we can
> not provide a strict migration contract.

At the moment it was more a trial and error process I acknowledge. You
try to migrate. You get what's wrong through traces on destination side.
Then you alter the ID reg fields that cause trouble in case they are
writable (ie. props are exposed). This is not production grade I agree.
But even with your current approach you still fail to provide tools for
layered products to understand what named model applies to this host and
can be migrated to another one, I think.

Note that if we expose everything through props, you well get all the
values on src and dst that mismatch but you will fail to know which
mismatches are correctable (because you don't know whether fields are
writable) ;-) How can you eventually determine the mismatch is fixable?


>
>>> Regarding default values, I do not see any reset values populated in
>>> AARCHMRS_OPENSOURCE_A_profile_FAT-2026-03/Registers.json, I
>>> may be missing something here. Is there some other place where we can
>>> find ARM ARM defined reset values?
>>>
>>>> If the named vcpu models anyway use hardcoded values I wonder if it is
>>>> so important to have named string values whereas a comment would do the
>>>> job in the named vcpu model definition?
>>> While true, for a named model, numerical field values will suffice as well. It’s
>>> just a way of representation. But for end users, I will argue, named values
>>> are more user-friendly.
>> to me, again, it would be if those values were properly specified which
>> is not the case.
>>> On x86, the user does not modify a specific cpuid leaf to turn a feature on or off.
>>> They have assigned a name to each leaf in the spec.  Our value names in most
>> in the spec ;-) That's a big difference.
> As above mentioned example of LS64 (in most cases) ARM ARM does say FEAT_ABC for
> a value ‘y’. and our name for value 'y' is ‘abc’. We can keep the value names same
> as ARM ARM (i.e val y = “FEAT_ABC”) if that suits better.
>
>>> cases already make perfect sense, as mentioned above.
>>>
>>>> From a spec pov I had in mind that a defintion of a FEAT could be much
>>>> more complex that just 1 field (for instance could be a combination of
>>>> several of them)
>>> Agreed. Hence, the ID register field-based properties.
>>>
>>>> It is not clear to be if you allow the end-user to overwrite a property
>>>> on top of a named model setting.
>>> Yes, the end user can change the property on top of the named model as
>>> illustrated in the examples. 
>>>
>>>>> - Default values and forward compatibility: CPU models start from a
>>>>>   known-zero baseline rather than the host view, so new fields/registers
>>>> [1]
>>>>>   introduced in future kernels do not silently leak into existing models.
>>>>> - Named CPU models with hierarchical inheritance: grace-v1,
>>>>>   neoverse-v2-v1, etc.
>>>>>
>>>>> The two series can coexist; this series can be rebased on top of [1].
>>>>>
>>>>> [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_20260503073541.790215-2D1-2Deric.auger-40redhat.com_&d=DwIDaQ&c=s883GpUCOChKOHiocYtGcg&r=sY-XeNqcuy_ruBQ9T7A2LmG6ktyYXXSxRB1ljkxMepI&m=fpNKdg99IJhj_lpxANCw1YCGZfWRAyz1YWNycq_dH0Rdg8U46NwjIJ3BvFyYb-e7&s=xzjnJMwOvSYbQjuaej-yNezaOn0DWWfAJho6IG_AEto&e=
>>>>>
>>>>> Problems with defining "named" CPU models for ARM64 KVM guests:
>>>>> * Features are not single CPUID bits. They are mostly multi-bit fields
>>>>>   encoding version/level instead of just presence. A single field encodes
>>>>>      multiple ARM ARM defined features (FEAT_s) at different thresholds.
>>>> would be good to provide an example for each challenge. I remember
>>>> Connie provided some in the past though her KVM forum presentations.
>>> Acked. Will add in v2.
>>>
>>>>> * KVM does not allow all registers and fields to be modified for a guest.
>>>>>   Some fields KVM does not virtualise at all (SME) or only support host
>>>>>      values (BRPs, CWG, etc.). This is evolving and differs between kernel
>>>>>      versions.
>>>> this seems to be contradictory to [1]. Do you have a mix of host
>>>> inherited values and hardcoded value or do you only have hardcoded values?
>>> A named model will not be realizable on a given host if any of the above non-writable
>>> fields differ between the host and the named model. We realize the named model fully
>>> from a  zeroed-out cpu->isar.idregs[] (no host features) exposed. A model is also not
>> why is it mandated to start from zeroed cpu->isar.idregs[]? Why can't
>> you start with host initialized cpu->isar.idregs[] and overwrite
>> everything that characterizes the named vcpu model.
> As explained above, we leak host features. 
OK understood. cpu->isar.idregs[] needs to be fully determined. My
assumption was that you are not going to run any vcpu model on any host
and there was minimal adherence between both, hence my original statement.
>
>>> realizable on a host if it over-promises features that are not actually available on the
>>> host (the need for safe-value tags).
>>>
>>>>> * ARM does not have a single natural granularity for CPU models unlike
>>>>>   x86. ARM has architecture, reference core and SoC levels each becoming
>>>>>      more granular.
>>>>> * ARM has dozens of vendors and it will be tricky to maintain models for
>>>>>   all of them.
>>>>> * Previous designs started from the host values and then subtracted
>>>>>   undesirable features. This is not forward-compatible; the design
>>>>>   should work when a new ID register or field is introduced.
>>>>>
>>>>> With the above problems in mind, the design has 3 layers:
>>>>>
>>>>> 1. ARM ID Register Field Table:
>>>>>  - This layer maintains all architecturally defined ID registers and
>>>>>    ID register fields. It includes:
>>>>>              * Field name
>>>>>              * Field shift
>>>>>              * Field length
>>>>>              * Safe-value tag: LOWER, HIGHER, HIGHER_OR_ZERO, SIGNED_LOWER,
>>>>>                                                EXACT, ANY
>>>>>                      This will be used to validate user-provided values during
>>>>>                      CPU realization time against the host's value. I.e., if the
>>>>>                      host only supports "aes", a CPU model that sets "pmull"
>>>>>                      should be rejected.
>>>> why isn't the kernel doing that job already. Setting a value not
>>>> compatible with the host shall be rejected by the kernel, no?
>>> KVM will reject. But how will management stack know which values are supported?
>>> x86 is simpler; a feature is a single-bit toggle. All management stacks infer that if the
>>> value of a property is true, false is supported. And, for -cpu host if the property value
>>> is false, the feature is not supported on the host.
>> Well I would imagine that a cloud vendor wants to migrate between
>> different hosts which call for a specific named model (so there is
>> minimal alignment between the vcpu model and the host cpu). In the worst
>> case it is always possible to instantiate scratch named model vcpus and
>> see if the vcpu init succeeds. We could even provide a qmp utility or
>> any other scheme that returns all valid vcpu models for that host.
>> Anyway I think this will be needed. or -cpu help may be enhanced to do
>> that, not simply returning the theoretical named models that are
>> available but the ones which actually apply on that kernel. I can help
>> you investigating that direction if it can come as an alternative.
> This is fine, we always want to know which model is realisable on host. But also
> want to know "why a model is not realizable?".
Practically what kind of tools do you bring to know that? which qmp
command to you plan to implement?
>
>>> On ARM, we don’t have that luxury; the management stack does not know which
>>> values are valid for a property. Ambiguity is:
>>> 1. How will management stack even know that a property is writable/modifiable?
>> this is already available in the original series through 
>>
>> query-cpu-model-expansion
> Again as the example above, I feel all fields (nonetheless writable or
> non-writable) should have a SYSREG_REG_FIELD prop.
>
>>> 2. For a 4-bit nibble, are all 16 values valid if it is writable?
>>> a) Lower values than the host?
>>> b) Higher values than the host? etc.
>> try to apply it and the kernel will simply let you know. Why
>> reimplementing this in qemu as it is done on the kernel with the safe
>> policy/value infra. 
> qmp query-cpu-definitions, users maybe okay with giving up some blocker features
> for a named model to run on a host. 
I do not catch sorry. 
>
>>> Having a safe value tag in QEMU allows us to provide useful information like
>>> named model ‘blockers’/‘unsupported-features’ and supported property values.
>> This can be achieved in a different way, relying on the kernel.
>> Instantiate a scratch vcpu model and see if it inits. Some scratch vcpu
>> inits are already in place in qemu.
> This is interesting, sadly it only gives us the faulting ID register and not the
> faulting field.
>
> For example on a non realizable named model, we just get:
> ```
> qemu-system-aarch64: Could not set register system register op0:3 op1:0 crn:0 crm:7 op2:4 to 100000 (is 0)
> ```
> We can find out the faulting register from this, but not the faulting field.
You have the host ID reg (0) and the value you try to apply. An xor can
easily give you the fields that differ but not necessarily the field
that caused the actual write issue if several of them differ.
But what are you proposing to improve that atm?
>
> Without per-field information, libvirt cannot translate this into a
> <blocker name='feat_AES'/> element. It can only say 'something in
> ID_AA64ISAR0_EL1 is wrong'.
>
>>> I feel the above should also be present for the customizable host model series [1],
>>> providing valid values along with properties is much more useful for management
>>> stack.
>> you can already introspect which ID reg are writables. You cannot get
>> the values that are valid for that host but any attempt to write invalid
>> values already fail the vcpu init. I tested that with kernel ID_FILTERED
>> id regs.
> Again, I feel there should be properties for all fields not just the writable fields.
>
>>>>>              * Default value: The value to which the field is reset. This gives
>>>>>                      CPU models a clean cpu.isar.idregs[] baseline instead of the
>>>>>                      host view provided by the kernel, as in previous designs.
>>>>>                      This also complements the forward-compatibility story. Given
>>>>>                      the "default" values, higher levels need not worry about new
>>>>>                      fields/registers being introduced.
>>>>>              * Architecturally defined named values like "off", "aes", "pmull",
>>>>>                      etc.
>>>>>              * These values are derived from the kernel's ftr_bits array and
>>>>>                tools/sysreg file.
>>>>>   E.g:
>>>>>
>>>>>    IDREG_START(ID_AA64ISAR0)
>>>>>    IDREG_FIELD_START(ID_AA64ISAR0, AES, 4, 4, LOWER, 0)
>>>>>    IDREG_FIELD_ARCH_VAL(0b0000, "off")
>>>>>    IDREG_FIELD_ARCH_VAL(0b0001, "aes")
>>>>>    IDREG_FIELD_ARCH_VAL(0b0010, "pmull")
>>>>>    IDREG_FIELD_END(ID_AA64ISAR0, AES)
>>>>>       ....
>>>>>       IDREG_END(ID_AA64ISAR0)
>>>>>
>>>>>  - This layer is the single source of truth for ARM64 ID registers.
>>>> single source of truth extracted from the kernel and not from the spec.
>>>> What if we discover a bug in ARM64_FTR_BITS chang default or safe value
>>>> for instance. How does the change propagate to qemu and existing models?
>>> Relaxation of safe value tag is safe, (EXACT -> LOWER -> ANY). Change in
>>> default value should not happen; instead, that should be handled with the
>>> “kvm-base” model, which is defined for KVM quirks. Same implications as
>>> ARM ARM changes the field’s semantics.
>>>
>>>>>    The default values and safe-value tags are manually derived from the
>>>> default value, if equal to reset value could be extracted from the spec
>>>> directly.
>>> Again, I checked AARCHMRS_OPENSOURCE_A_profile_FAT-2026-03/Registers.json,
>>> and the reset values were null. I may be missing something. Is there any
>>> other place  we can get ARM ARM defined reset values? We can modify
>>> the script in [1] to also have default values for named model infra.
>> I guess it is normal because those regs are ID regs. The minimum level
>> of support comes from the various revisions and reference core
> NI vals from kernel’s sysreg are very useful… I will let community decide on how we
> should maintain default values.
NI?
>
>> implementations. To me this is the huge job that needs to be done while
>> defining the various named models you drafted.
> That absolutely needs to be done if we don’t want to leak host features and provide
> strict migration contract.
>
>>>>>       kernel's ftr_bits array. Other boilerplate and arch-defined values are
>>>>>       script-generated.
>>>>>
>>>>>  - AArch32 ID registers are added with a single field so they can be
>>>>>    zeroed out on hosts that support AArch32.
>>>>>
>>>>>  - This layer also defines helpers for higher layers to extract and
>>>>>    manipulate ID register fields.
>>>>>      * arm_idregs_reset_to_defaults(): Reset all ID registers to their
>>>>>           default values.
>>>>>         * arm_idreg_field_read/write(): Read the value of an ID register
>>>>>           field.
>>>>>         * arm_arch_val_name/from_name(): Look up the arch-defined name for
>>>>>           a numeric field value.
>>>>>         * ...
>>>> this is a pity we have not exchanged on this earlier because that code
>>>> could have been shared instead of rewriting things and resetting all
>>>> credits.
>>> Let’s work together from now on :) 
>> yeah the problem is you reimplemented a different infrastructure for the
>> same prop granularity as you did not rely nor ever commented on the
>> original series. So the first thing is to converge on the base infra
>> (props) definition and then build layered named models on top of it. As
>> we do not agree for now, let's wait for other's comments...
>> I a bit frustrated you did not communicate with us before so that we
>> could have initiated cooperation before and even make the original
>> series evolve in the direction you needed for named vcpu models.
>>
> Our intention was not to reimplement the infrastructure, We first thought of
> implementing on top of v3 of [1], but that looked like not being actively
> worked on. For business deadlines we had to implement model realization.
You may have seen we did not get that many feedbacks either (including
yours) and some prerequisite series were needed ;-) I hope we will now
have more traction in the community.
>
> Our model realisation code can work on [1] if just default values/reset
> values are present.
>
> If complexities of safe-value tags and their advantage (as mentioned previously)
> are not acceptable by the community, we will rebase our model realization logic
> on top of [1] while also adding default values.
>> But anyway, my end goal is to get those named models in a decent
>> timeframe so I am obviously willing to cooperate, hence the time I spend
>> reviewing your alternative implementation ;-)  
> Thanks for the detailed review, I am certain we both can make progress.
>
>>>>>      - This layer creates the following tables using X-macro expansion:
>>>>>         * arm_idregs[]: Array of ID register descriptors.
>>>>>         * arm_field_locs[]: Array of field location descriptors.
>>>>>              (fieldIDx -> registerIndex, fieldIndex)
>>>>>         * ...
>>>>>
>>>>>   - The ArmIdReg struct also includes a writable_mask to track which
>>>>>     bits are writable by KVM. This is populated at runtime during
>>>>>     scratch VM creation, and is further used to validate that only
>>>>>     the writable bits are modified by the CPU model.
>>>> this is an interesting idea that could have been also used in previous
>>>> contributions.
>>> Acked.
>>>
>>>>> 2. ARM Properties Layer:
>>>>>  A small property layer on top of the ID Register Field table is defined.
>>>>>  This series defines two types of properties with plans for one more
>>>>>  in the future:
>>>>>     - Single field properties: These represent ARM FEAT_X features
>>>>>          that correspond to a single ID register field. Example: feat_AES,
>>>>>          feat_SHA2, etc.
>>>>>
>>>>>              The property name is set as "feat_<FieldName>" and possible values
>>>>>              are the arch-defined named values. This can be further categorized
>>>>>              into:
>>>>>                      * STRING: multi-bit fields (>=2 bits) with arch-defined named
>>>>>                                values, example: feat_AES, feat_SHA2, etc.
>>>>>                      * BOOLEAN: 1-bit fields only (true/false)
>>>>>                                example: hw_prop_IDC, hw_prop_DIC, etc.
>>>>>                      * NUMERIC: IDREG_ANY fields with no named values (raw integer)
>>>>>                                example: hw_prop_BS, hw_prop_DZP, etc.
>>>> I just wonder if we need all that complexity if eventually we hardcode
>>>> values in named vcpu models
>>> Then we are just delegating the complexity to the management stack. For
>>> example, without fractional prop, the management stack must know CSV2,
>>> CSV2_Frac relation, and not all value combination of <CSV2>.<CSV2_Frac>
>>> are valid. Rather than having different management software solving the
>>> same problem, we can solve it once in QEMU.
>> well, named vcpu models hardcode 90% of the values, aren't they. Scratch
>> vcpu init attempts can let management layers know what named vcpu models
>> would work on that host I guess.
>>> We also have very active plans to hook up cpu-definitions, cpu-model-expansion,
>>> and more.
>>>>>              String property values are validated against the arch-defined named
>>>>>              values.
>>>>>
>>>>>              ID register fields that are not covered by single field properties
>>>>>              are also exposed as a property named hw_prop_FieldName. These are
>>>>>              usually implementation-defined values like cache geometry, debug
>>>>>              counter widths, etc. (CTR_EL0.*, DCZID_EL0.*, etc.)
>>>>>              Example: hw_prop_BS, hw_prop_DZP, etc.
>>>> how do you discriminate between those and field_ props? Again do we need
>>>> that complexity?
>>> Ummm, there is no special code for these props. They are just named differently
>>> as no ARM ARM FEAT_ relate to them.
>> Yes but I mean for the end user, this ends up with different prop names
>> which does not make their life easier to me, instead of SYS_REG_FIELD
>> pattern. also keep in mind that FEAT_ props are not, strictly speaking
>> what the spec call FEAT.
>>>>>              Single field properties are defined as:
>>>>>
>>>>>              ARM_PROP("prop_name", type, reg, field)
>>>>>              Example:
>>>>>              ARM_PROP("feat_AES", STRING, ID_AA64ISAR0, AES)
>>>>>
>>>>>              * Validation based on safe-value tags is yet to be implemented.
>>>>>
>>>>>    - Fractional properties: These represent ARM FEAT_X features that
>>>>>          use two fields (base + frac) across registers. Example: feat_CSV2,
>>>>>          feat_MPAM, etc.
>>>>>
>>>>>              The property name is set as "feat_<BaseFieldName>" and possible
>>>>>              values are the arch-defined string values like "0.0", "1.0", "1.1",
>>>>>              etc.
>>>>>
>>>>>              Fractional properties are defined as:
>>>>>              ARM_FRACTIONAL_PROP("prop_name", base_reg, base_field, frac_reg, frac_field)
>>>>>              Example:
>>>>>              ARM_FRACTIONAL_PROP("feat_CSV2", ID_AA64PFR0, CSV2, ID_AA64PFR1, CSV2_FRAC)
>>>>>
>>>>>
>>>>>              When a fractional property is set, both the base field and frac
>>>>>              field values are set to the corresponding values.
>>>>>              E.g: feat_CSV2=1.1 will set ID_AA64PFR0.CSV2=1 and ID_AA64PFR1.CSV2_FRAC=1.
>>>>>
>>>>>      - Composite properties (planned for v2):
>>>>>         These will act as master boolean switches that control a list of
>>>>>         fields. Example: pauth, sve, etc. Setting sve=on with a named model
>>>>>         will set all the SVE-related fields (ID_AA64ZFR0_EL1.*) along with
>>>>>         sveNNN vector-length. Similarly, setting pauth=on will set APA, GPA,
>>>>>         API, GPA3, GPI, GPA3 fields based on the named model.
>>>>>
>>>>>      - cpu_revision, cpu_partnum, etc. properties are introduced to expose
>>>>>        MIDR, REVIDR, AIDR fields.
>>>>>
>>>>>      Exceptions to the property naming are made for ID_AA64PFR0_EL1.ELx
>>>>>      fields, which are named elx_mode.
>>>> yet another naming exception. 
>>> A better name is always welcome! We can iterate over both the prop name and
>>> the value name.
>> yeah but is it making end user life easier?
>
> We believe so.
>
>>>>>      This series defines over 130 single field properties plus 4
>>>>>      fractional properties. All properties work with -cpu host also.
>>>> Similary as with the host "custom" series, one needs to address
>>>> collision between legacy cpu properties and low level ones too.
>>> Agreed, This needs more thoughts. It is not a part of this RFC.
>> I have further thought on this when respinning the original series into
>> v5. I believe the props can follow a hierarchy. ID reg field props are
>> the lowest level props and apply first. Then come the higher level
>> legacy options that are likely to override them. I am waiting for
>> comments on the series but this is proposal I would make.
> Interesting, will look through the v5 code.
>
>>>>>      All properties change the cpu.isar.idregs[] values which are later
>>>>>      written back to KVM at the end of kvm_arch_init_vcpu().
>>>>>
>>>>>      * The arch-defined named values and property names can be iterated
>>>>>        until they make sense.
>>>>>
>>>>> 3. ARM CPU Model Hierarchy:
>>>>>
>>>>> A small named model layer is defined on top of the properties. An ARM named
>>>>> CPU model defines a list of property values and a parent model. A child
>>>>> model naturally inherits all the properties from its parent and can
>>>>> override them when needed.
>>>>>
>>>>> The initial model hierarchy shipped here is:
>>>>>   kvm-base-v1                  KVM-imposed quirks
>>>>>     arm-v8_4-a-v1              ARMv8.4-A architectural mandate
>>>>>         neoverse-v1-v1         Neoverse V1
>>>>>                  graviton3-v1         AWS Graviton3
>>>>>              arm-v9_0-a-v1            ARMv9.0-A architectural deltas on top of ARM-v8_4-a-v1
>>>>>         neoverse-v2-v1         Neoverse V2
>>>>>           grace-v1             NVIDIA Grace
>>>> Do you have a strategy for named model validation, besides code review.
>>>> At least each vcpu named model shall be introduced in separate patch,
>>>> overrides clearly explained and links to the reference spec shall be
>>>> precisely given for review.
>>> Agreed, each model should be in a separate patch, with overrides and new
>>> introductions clearly mentioned/documented with supporting ID register dumps.
>> Yes I believe it is a huge work to assess the correctness of the
>> definition.
> I hope in long term vendors will chime in.
>
>>>>> (kvm-base-v1 and arm-vX are not meant to be realizable unless the
>>>>> user provides values for implementation-defined fields)
>>>>>
>>>>> So for example, grace-v1 defines Crypto fields and CTR_EL0.IDC/DIC on top
>>>>> of neoverse-v2-v1, which leaves those fields vendor-configurable.
>>>>>
>>>>> The hierarchy reflects a deliberate trade-off:
>>>>> - Architecture-level models (arm-v8_4-a-v1) maximize migration
>>>>>   compatibility but lack implementation-defined values.
>>>>> - Reference-core models (neoverse-v2-v1) enable migration across
>>>>>   SoCs sharing the same core design.
>>>>> - SoC models (grace-v1) expose the full hardware feature set but
>>>>>   limit migration to hosts with the same SoC.
>>>> What kind of migration did you exercise up to now?
>>> Successful same host migration with named models and migration
>>> from grace to graviton3 with neoverse-v1.
>>>
>>>>> At model realization time,
>>>>>   1. a clean slate of cpu.isar.idregs[] is created using
>>>>>         arm_idregs_reset_to_defaults().
>>>>>      2. Then, a model's full parent-chain is walked and all properties are
>>>>>         applied in order from parent to child.
>>>>>      3. Finally, kvm_arm_writeback_idregs() compares the model's desired
>>>>>         ID-register values against the host-provided cpreg snapshot and
>>>>>         writes back the writable bits, warning on any non-writable difference.
>>>>>
>>>>> Models will follow a monotonic versioning convention (grace-v1, grace-v2,
>>>>> ...) mirroring x86's scheme.
>>>>>
>>>>> * Please take the CPU model property values with a grain of salt.
>>>>> They are added based on what the guest-visible values are with "host"
>>>>> model on available hardware.
>>>> I don't catch the above statement.
>>> They don’t match the exact hardware specs. For example feat_CSV2 is capped
>>> at “1.0” by KVM regardless of what the hardware says. On Neoverse-v2, TRM
>>> says FEAT_CSV2_2 is implemented (i.e “2.0”)
>> OK. This is effectively an important aspect that, despite the value we
>> attempt to set on an ID reg field, KVM eventually does what he wants
>> with it according to its policy. I think it can ignore, sanitize, ...
>>>>> Benefits of this design:
>>>>>      - General benefits that come with properties and named CPU models,
>>>>>        like cross-host live migration, management-stack control over
>>>>>        feature exposure, etc.
>>>>>      - Forward compatibility: when a new ID register or field is
>>>>>        introduced, CPU models need not change; during realization they
>>>>>        will be populated with the default values. Only ID register/field
>>>>>        information needs to be added to the field table.
>>>>>      - As CPU models are hierarchical, defining a new model is much easier.
>>>> I like the hierarchical approach but to be honest, at the moment, I miss
>>>> knowledge on whether it safely applies. I agree that named vcpu models
>>>> are the end target goal while [1] is rather an intermediate step that
>>>> was paving the way for it. I rather saw [1] as a tool box for enhaving
>>>> the host model and understanding issues when migrating. I wish we could
>>>> share the foundations instead of having totally separate contributions. 
>>> Definitely, let’s build a common foundation. We need to agree on safe-value tags,
>>> default values, and value names. We can build our solution on top of [1], if at least
>>> safe-value tags and default values are present.
>> To me there are several aspects
>> 1) decide which ID reg properties are needed/better (unique uint64_t or
>> your various prop flavours)
> We will agree on whatever community agrees on. If our names are discouraged we
> will move to [1]’s prop names.
>
>> 2) usage of safe policy/value (is it really mandated). Why can't we use
>> scratch vcpus. Possibly if it is proven to be mandatory this is
>> independent on 1
> Default-values/reset-values are absolutely needed. safe-value tags are also a
> must have if we want parity with x86 QEMU’s qmp capabilities.
>
> Warm Regards,
> Khushit
>> 3) definition of named models
>>
>> Thanks
>>
>> Eric
>>>>>      - The property names and values are self-documenting.
>>>> not really sorry (because it does not match the spec). I don't think we
>>>> can ask the end-user to read the kernel code.
>>> Acked, We will add appropriate documentation in QEMU.
>>>
>>>>> NOTE: ~2200 of the ~3300 added lines are declarative (field table,
>>>>> model definitions, properties, etc.)
>>>>>
>>>>> Tested with KVM on an NVIDIA Grace host.
>>>>>
>>>>> Relationship with existing code base:
>>>>> - It does not change any TCG-based code paths.
>>>>> - For KVM host passthrough it just adds property support.
>>>> with hardcoded reset values, correct? Instead of host retrived values?
>>> Reset values are not used with the -cpu host. Only for the named model
>>> realization, reset values are used.
>>>
>>>>> - Does not change any existing properties or other code paths.
>>>> yes but if it words along with legacy options, you share our concern to
>>>> coexist with them
>>> Yes, it requires some more thoughts.
>>>
>>>>> - Can layer on top of the SYSREG_ property series [1].
>>>> but in that case why don't you simply reuse it to build the named vcpu
>>>> model. I don't say the previous properties are the ideal solution but I
>>>> am not sure the mix or heterogenously named ones introduced here + value
>>>> strings retrieved from the kernel are better. At least the SYSREG ones
>>>> matched the spec with raw values, which bring simplicity in the code.
>>>> And since the end user shall be so much involved in provided extra
>>>> SYSREG values himself on top of named vcpu models, ...
>>> We can build on [1] as long as we have default values and safe-value tags.
>>> They are required for the proper model realization and QMP integration.
>>>
>>>>> Planned Follow-ups:
>>>>>   - Composite properties with handling of sve, pauth for named models.
>>>> yes this is needed and I am currently working on this on [1]
>>>>>   - CLIDR_EL1 and CCSIDR_EL1 handling.
>>>>>      - Safe-value based validation logic.
>>>>>      - QMP commands like query-cpu-model-expansion are not hooked yet.
>>>>>        Blockers and supported values (calculated using safe-value tags
>>>>>        and runtime KVM writable masks) will be reported through them.
>>>>>        E.g. libvirt could report:
>>>>>          <property name='feat_AES' type='string' value='pmull'
>>>>>                    supports='off,aes,pmull'/>
>>>>>        and:
>>>>>          <cpu type='kvm' name='nvidia-grace-v1'
>>>>>                      typename='arm-nvidia-grace-v1-arm-cpu' usable='no'>
>>>>>            <blocker name='feat_AES'/>
>>>>>          </cpu>
>>>> adding Andrea for libvirt inputs
>>>>
>>>> Thanks
>>>>
>>>> Eric
>>> Warm Regards,
>>> Khushit
>
Thanks

Eric

