Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A8A37C0F3
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 15:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118051; cv=none; b=HVuQ8cIFbVrhWKqlNwt9r3vLWWmkxqmS1SpuUfD9WrDAnNFU2GrrBXtl8Ili7wY3DHYAQ9fBUZSDUkTKnjb0KLvreMISeTp8/X8UPbknnxx0Py/RFXFlUaE4+iaLHJEkfGD0JzQhJIAhnQ6dOWjSLP5pCHtgWXt3LIHABXoNO4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118051; c=relaxed/simple;
	bh=L2IVp49APP/gw5fX8M4RqEqcz9KEwf+ujo4/jB7A3Bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQZgB673M9wokO5Y7NKsDZ1d9gSiv7KusBPmSK9tvodsGEjw7PYL8S8LjR4chx+yCgKnwucdvwv8Yn2AVUamGN6EGaSJrNoWP6E7bHM+OokLsIqNWmd0VplmLnKBJIXBtHbcsGk+EXHyb8TX2Vp+4iQ1jxxBWPG1QBgGxmxZzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fTmiM6vi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fTmiM6vi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779118047;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fYsVpoOBf6XXsam9os2Tz9GCvPuyl3QZW1VNuAFzwuM=;
	b=fTmiM6vimZhrOEfoYWe3GCWPxPni4wrnjKouHrKmfqavdw3dGIt4rCYgEccyXE7xKAO/Pp
	6bNkuBrCV/LWbLHfpzWmui8cxCO127aW5YKn4tQJqoWVhT57O1a/n8f2rzUVVF9SqlE1L8
	HaJe0DNpvshu2bJ1gzwvkzgh3/aFw6U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-iwJos07wPd2ydgkaltaIig-1; Mon, 18 May 2026 11:27:26 -0400
X-MC-Unique: iwJos07wPd2ydgkaltaIig-1
X-Mimecast-MFC-AGG-ID: iwJos07wPd2ydgkaltaIig_1779118045
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48fd9c22b8fso20306475e9.3
        for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 08:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779118045; x=1779722845;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYsVpoOBf6XXsam9os2Tz9GCvPuyl3QZW1VNuAFzwuM=;
        b=r8FYdp6gDSH+LrN1A6wgbavZdCe1x8cy9vUxCQdx0OdTghYpNhaT3vaMC9dUDRSi+e
         nna8Xa0yvBZv8VMgcskAUfamCn5mHdhfrmPVoGl0hXMhKvuKBrDDKSF9imLpfNriirUO
         fvLPVfrjEBFU1jEDdLIjrAiIGVeMXBmDEZXSPEwj37J0E8sn7Wg0/HKk9jx+rmOpSvwC
         YrpAmvBbDF0r9yuiZ/GJFtiux8GzWgF17FbPiAFn6QhUWaLkAMYi0bYVl/mwvu/hOoxg
         Ob7fj8o5w2Yp/7Wfj/kHZpmhG0t+/+pcAHoz90fYoVbIelcZNeT0D7hl9i2WT7+qPFtl
         mB7w==
X-Forwarded-Encrypted: i=1; AFNElJ8Is/XgfIpMsT34QTAvMFx+lBRxf7E6c+/5CDOD+ac5YSdOK6ieVwKoyRkl8inVTRvV9nUaZgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbPOFAp74mv939iwCyesc3vYPNrIXYdyCXkvahojmUm/icuJum
	XkXFIEZDKjutYvG7gvkzECoB4LtUZo6o7DaOPZU5FEPz9JtnFz7S10WGf5Ox4lzM/ds24GoILcC
	/rNViXtcGf/A17pqS+xUdmNs9SXgaJczcv4KDkMOVvyX/uxDDFWnNSvojmg==
X-Gm-Gg: Acq92OE76e3+ivG36jEyMjRxLx/V9qh/4ssFZni4enbTOi3VnvsUeSFVMkjetVjioyJ
	tmokOcJqxnD8zj960Bj6m/zX8vULLPBfV6DRXSbws0pCa6kwbDPSLmBu9d/x2i6e3fBa28qi/n3
	A4ItXwbt5Y1Ib707HAXCc9LeBYB7980QDqc6x3Nifo9W3SXopm1XFcFhhfMgYikj04wM57dclSQ
	stqO6BXyQiEcrE4A4mDV9+e+K43dnBJoh1I9xbTCDhVcfvbOohvQEM+Ofdk7mMlttniPjLQ5w4U
	q9Zh4iPJCArOHD5ywteTgYR2zXyuhkqSKjjVNlWuNyiusZDdhhRCYOHCmNnsIihVlRjj5vwgqIR
	zvvTMMmmTdwcyb5yJT2vMTp4O+bUEepBNk33prwFmgWGklaT8Rjx+vcyrLWhGlWIb7odd7g==
X-Received: by 2002:a05:600c:8b0d:b0:48f:e230:2a26 with SMTP id 5b1f17b1804b1-48fe6631679mr249341265e9.33.1779118044787;
        Mon, 18 May 2026 08:27:24 -0700 (PDT)
X-Received: by 2002:a05:600c:8b0d:b0:48f:e230:2a26 with SMTP id 5b1f17b1804b1-48fe6631679mr249340395e9.33.1779118044244;
        Mon, 18 May 2026 08:27:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48feab2a23dsm84335135e9.5.2026.05.18.08.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 08:27:23 -0700 (PDT)
Message-ID: <07bc244b-3bf3-4e30-b603-ecf6d3a83b67@redhat.com>
Date: Mon, 18 May 2026 17:27:21 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 17/17] arm/cpu-features: document ID reg properties
To: Shameer Kolothum Thodi <skolothumtho@nvidia.com>,
 "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260503073541.790215-1-eric.auger@redhat.com>
 <20260503073541.790215-18-eric.auger@redhat.com>
 <CH3PR12MB7548322D7A29C8EC3EA0E49BAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CH3PR12MB7548322D7A29C8EC3EA0E49BAB3C2@CH3PR12MB7548.namprd12.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tVpk6kl7ENPD35icxmX5i3rfIIZtqsoEz5cFqPUoits_1779118045
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/7/26 9:44 PM, Shameer Kolothum Thodi wrote:
>
>> -----Original Message-----
>> From: Eric Auger <eric.auger@redhat.com>
>> Sent: 03 May 2026 08:34
>> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
>> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
>> peter.maydell@linaro.org; richard.henderson@linaro.org;
>> cohuck@redhat.com; sebott@redhat.com; Shameer Kolothum Thodi
>> <skolothumtho@nvidia.com>; philmd@linaro.org
>> Cc: maz@kernel.org; oliver.upton@linux.dev; pbonzini@redhat.com;
>> armbru@redhat.com; berrange@redhat.com; abologna@redhat.com;
>> jdenemar@redhat.com
>> Subject: [PATCH v4 17/17] arm/cpu-features: document ID reg properties
>>
>> External email: Use caution opening links or attachments
>>
>>
>> From: Cornelia Huck <cohuck@redhat.com>
>>
>> Add some documentation for how individual ID registers can be
>> configured with the host cpu model.
>>
>> [CH: adapt to removal of the 'custom' model, added some more
>>  explanations about using the ID register props]
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  docs/system/arm/cpu-features.rst | 104
>> ++++++++++++++++++++++++++++---
>>  1 file changed, 96 insertions(+), 8 deletions(-)
>>
>> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-
>> features.rst
>> index 10b0eff27e..22f671b15d 100644
>> --- a/docs/system/arm/cpu-features.rst
>> +++ b/docs/system/arm/cpu-features.rst
>> @@ -2,7 +2,10 @@ Arm CPU Features
>>  ================
>>
>>  CPU features are optional features that a CPU of supporting type may
>> -choose to implement or not.  In QEMU, optional CPU features have
>> +choose to implement or not.  QEMU provides two different mechanisms
>> +to configure those features:
>> +
>> +1. For most CPU models, optional CPU features may have
>>  corresponding boolean CPU proprieties that, when enabled, indicate
>>  that the feature is implemented, and, conversely, when disabled,
>>  indicate that it is not implemented. An example of an Arm CPU feature
>> @@ -31,6 +34,16 @@ running guests in AArch32.
>>  CPU features that are inherently specific to KVM are
>>  prefixed with "kvm-" and are described in "KVM VCPU Features".
>>
>> +2. Additionally, the ``host`` CPU model on KVM allows to configure optional
>> +CPU features via the corresponding ID registers. The host kernel allows
>> +to write a subset of ID register fields. The host model exposes
>> +properties for each writable ID register field. Those options are named
>> +SYSREG_<IDREG>_<FIELD>. IDREG and FIELD names are those used in the
>> +ARM ARM Reference Manual. They can also be found in the Linux
>> +arch/arm64/tool/sysreg file which is used to automatically generate the
> arch/arm64/tools/sysreg
>
> Anyway, I think this needs update as the scripts now uses Registers.json
> from AARCHMRS, right?
that's correct.
>
>> +description for those registers and fields. This currently only has been
>> +implemented for KVM.
>> +
>>  CPU Feature Probing
>>  ===================
>>
>> @@ -126,13 +139,20 @@ A note about CPU models and KVM
>>
>>  Named CPU models generally do not work with KVM.  There are a few cases
>>  that do work, e.g. using the named CPU model ``cortex-a57`` with KVM on a
>> -seattle host, but mostly if KVM is enabled the ``host`` CPU type must be
>> -used.  This means the guest is provided all the same CPU features as the
>> -host CPU type has.  And, for this reason, the ``host`` CPU type should
>> -enable all CPU features that the host has by default.  Indeed it's even
>> -a bit strange to allow disabling CPU features that the host has when using
>> -the ``host`` CPU type, but in the absence of CPU models it's the best we can
>> -do if we want to launch guests without all the host's CPU features enabled.
>> +seattle host, but mostly if KVM is enabled, the ``host`` CPU model must be
>> +used.
>> +
>> +Using the ``host`` type means the guest is provided all the same CPU
>> +features as the host CPU type has.  And, for this reason, the ``host``
>> +CPU type should enable all CPU features that the host has by default.
>> +
>> +In case some features need to be hidden to the guest, and the host kernel
> s/hidden to the guest/hidden from the guest/

yup
>
>> +supports it, the ``host`` model can be instructed to disable individual
>> +ID register values. This is especially useful for migration purposes.
>> +However, this interface will not allow configuring an arbitrary set of
>> +features; the ID registers must describe a subset of the host's features,
>> +and all differences to the host's configuration must actually be supported
>> +by the kernel to be deconfigured.
>>
>>  Enabling KVM also affects the ``query-cpu-model-expansion`` QMP
>> command.  The
>>  affect is not only limited to specific features, as pointed out in example
>> @@ -169,6 +189,13 @@ disabling many SVE vector lengths would be quite
>> verbose, the ``sve<N>`` CPU
>>  properties have special semantics (see "SVE CPU Property Parsing
>>  Semantics").
>>
>> +Additionally, if supported by KVM on the host kernel, the ``host`` CPU model
>> +may be configured via individual ID register field properties, for example::
>> +
>> +  $ qemu-system-aarch64 -M virt -cpu
>> host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
>> +
>> +This forces ID_AA64ISAR0_EL1 DP field to 0.
>> +
>>  KVM VCPU Features
>>  =================
>>
>> @@ -495,3 +522,64 @@ Legal values for ``S`` are 30, 34, 36, and 39; the
>> default is 30.
>>
>>  As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
>>  removed in some future QEMU release.
>> +
>> +Configuring CPU features via ID register fields
>> +===============================================
>> +
>> +Note that this is currently only supported under KVM, and with the
>> +``host`` CPU model.
>> +
>> +Querying available ID register fields
>> +-------------------------------------
>> +
>> +QEMU will create properties for all ID register fields that are
>> +reported as being writable by the kernel, and that are known to the
>> +QEMU instance. Therefore, the same QEMU binary may expose different
>> +properties when run under a different kernel.
>> +
>> +To find out all available writable ID register fields, use the
>> +``query-cpu-model-expansion`` QMP command::
>> +
>> +  (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>> +  {"return": {
>> +   "model": {"name": "host", "props": {
>> +   "SYSREG_ID_AA64PFR0_EL1_EL3": 1,
>> "SYSREG_ID_AA64ISAR2_EL1_CLRBHB": 0,
>> +   "SYSREG_CTR_EL0_L1Ip": 3, "SYSREG_CTR_EL0_DminLine": 4,
>> +   "SYSREG_ID_AA64MMFR0_EL1_BIGEND": 1,
>> "SYSREG_ID_AA64MMFR1_EL1_ECBHB": 0,
>> +   "SYSREG_ID_AA64MMFR2_EL1_CnP": 1,
>> "SYSREG_ID_DFR0_EL1_PerfMon": 4,
>> +   "SYSREG_ID_AA64PFR0_EL1_DIT": 0,
>> "SYSREG_ID_AA64MMFR1_EL1_HAFDBS": 2,
>> +   "SYSREG_ID_AA64ISAR0_EL1_FHM": 0,
>> "SYSREG_ID_AA64ISAR2_EL1_CSSC": 0,
>> +   "SYSREG_ID_AA64ISAR0_EL1_DP": 1, (...)
>> +   }}}}
>> +
>> +If a certain field in an ID register does not show up in this list, it
>> +is not writable with the specific host kernel.
>> +
>> +A note on compatibility
>> +-----------------------
>> +
>> +A common use case for providing a defined set of ID register values is
>> +to be able to present a fixed set of features to a guest, often referred
>> +to as "stable guest ABI". This may take the form of ironing out differences
>> +between two similar CPUs with the intention of being able to migrate
>> +between machines with those CPUs, or providing the same CPU across Linux
>> +kernel updates on the host.
>> +
>> +Over the course of time, the Linux kernel is changing the set of ID register
>> +fields that are writable by userspace. Newly introduced writable ID
>> +registers should be initialized to 0 to ensure compatibility. However, ID
>> +registers that have already been introduced that undergo a change as to
>> +which fields are writable may introduce incompatibities that need to be
> s/incompatibities/incompatibilities/

noted.

Thanks

Eric
>
> Thanks,
> Shameer
>
>> +addressed on a case-by-case basis for the systems that you wish to migrate
>> +inbetween.
>> +
>> +A note on Arm CPU features (FEAT_xxx)
>> +-------------------------------------
>> +
>> +Configuring CPUs is done on a feature level on other architectures, and this
>> +would imply configuring FEAT_xxx values on Arm. However, differences
>> between
>> +CPUs may not map to FEAT_xxx, but to differences in other registers in the
>> +ID register range; for example, differences in the cache architecture exposed
>> +via ``CTR_EL0``. We therefore cannot rely on configuration via FEAT_xxx. A
>> +feature-based interface more similar to other architectures may be
>> implemented
>> +on top of the ID register interface in the future.
>> --
>> 2.53.0

