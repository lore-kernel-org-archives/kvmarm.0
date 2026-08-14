Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B371448E0
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786715750; cv=none; b=o7Xt/M+81n+G1N9JOPbntBb+yVTTOfJVXYe/akUsOQsE3kqH00dJ12BZzRQxmiwvNLKV8T8C846raCxU9fuSXCENFZrZ2gQ9ZztqG7xeQIaOGEl0Uplj8fU5s600Icm6rT8iFpOUg9sqqnrSTaGNsBauynjyjEIB3OhMDrqhj4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786715750; c=relaxed/simple;
	bh=/ZGKKIQyBDPYdaFjX4KZaSCiDLxVuuxQzwQHGgg9tOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LkZ7ERjPNXmpoYLZZx6r0fSnWm/NenyWVFeGIaaBCQDgTIbM526H9UlgeMFdwy1Uk/taFVJy5kGqtXqF38dsdDZLu9Mzzv6BNgKIGTZzbyCz5kBBwGbZhMKRPAZsRctlBIgP1welNCCF9PzYAVoX5PUrgX+KwH2q+Mek7IPNUlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPsq1r9+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPsq1r9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786715741;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gKdhtw1m8sht7rTZzs87WSL5+4JwGR90fU7k6i0EFcI=;
	b=IPsq1r9+bMbD2UZEbPd2ELGWZ01jYYrU3PvlC8ou1bpS1FyoKU4F0pYEUUqm20/1XMPPlu
	AJqE16edhoK4pCyi3Q5y5+7CpFGcQd9ujKzTKs6iyjGZYpyA0B8lKYTDjmp5W2y+6w+ffT
	gHpH2JN2g58EbppchO8mFQaT++NQBNI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-cR1XK36dOKG9TAsxSobXwg-1; Fri, 14 Aug 2026 09:55:40 -0400
X-MC-Unique: cR1XK36dOKG9TAsxSobXwg-1
X-Mimecast-MFC-AGG-ID: cR1XK36dOKG9TAsxSobXwg_1786715739
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-492488f8583so8703495e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 06:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786715739; x=1787320539;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gKdhtw1m8sht7rTZzs87WSL5+4JwGR90fU7k6i0EFcI=;
        b=brDuYZwugQhHr8wz8wEgrSVzrGR1v39sm3BgtpzX91ypMlkNV0ExCOMVU7THs/7lS/
         WIoiuM4SHrYzjPgW3XmgQr9oAxM/v69SY+HhvZgrapMvdJs4oHApalAOKJmzgCg0SUCq
         k4mwwJot48lYiK1+Cbe9AcYmO2C9/3DrzUyRfz4RyM978kLv8c2ezjsy4/LTtNQs5o8v
         3jriiRh4nXlbs6LrjRQ8Sb/93bZTlsgthrdVAGSedfhV/2WkWzxLbEDuNH7xtQ+k+CFJ
         JaLoDSFwOTgzzjvEuqG/BSzFXgS43eknKPj25Y2rtARFqwycVoJ86sgBEYMCw1Xc2kxw
         lgYQ==
X-Forwarded-Encrypted: i=1; AHgh+RqcXayOolv52BFJe5LT9oT310Tb5Fe/Xzv8RFnw82EsLJWQgFI/dpbCfZdX7wuSplqPIvdAbp8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf6SAjWAD2EbEEK8jl8jhuYpyDRs8cuMUkwQd1JTku+C1xRiex
	5g2fv8/lV6LOUEKJ6Oia50bNVM1Rz5Z0g3BVPgJW3YvSTY2lIpNHwHUGMlom3+Kb00l3xOMke0j
	qS3a0ijpkF105+7fv6THOoDext4/ENKzX+IWNn36wn9DAdB+yQVjHXSeUcw==
X-Gm-Gg: AR+sD136a2aB4vgw4XakH/5EdjHsNGnYuHcfQMYZF8Y6pCevLboCmQvU5w6Z2ud/DbR
	SiJE/hOygZJ5D5xJYQ+xHB2BjYl0WCz2Q5m+VhSuC6d8w5qs0egdaXCmNsnRJVJcKtQje583/8A
	BtQqhrA+F8VOS2V7VDZ9qEF+n6lUsK8YXlUDH+28XF103wLWQitpXrQknDs0VGRDhYZUvt3CBx1
	jxEJ+BSW2vzqKxrGVV6DX4gamR4XqbKNJ5T5u48PSaQixSg1MUDGXRqz2NxSKn/XEHdyXrCdNbN
	2eziwq2dLhGxhnm8ZtGqzyFWGVN78eqC6rO/aJb7Rb4VzDzcnOUzyQ0lNPbH5D9U3qDJjp/gfBQ
	5X1BAW+ehk9QwzLNVc/RC3zGSPxF/GGxBoPM7aiQl0kHi+Kx9
X-Received: by 2002:a05:600c:4708:b0:495:6396:8b67 with SMTP id 5b1f17b1804b1-499879419bdmr66203015e9.4.1786715739214;
        Fri, 14 Aug 2026 06:55:39 -0700 (PDT)
X-Received: by 2002:a05:600c:4708:b0:495:6396:8b67 with SMTP id 5b1f17b1804b1-499879419bdmr66202295e9.4.1786715738779;
        Fri, 14 Aug 2026 06:55:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998bc827f1sm9878195e9.6.2026.08.14.06.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Aug 2026 06:55:38 -0700 (PDT)
Message-ID: <d77fc9f7-3057-4dc0-b29e-dc7bdfa0d5a2@redhat.com>
Date: Fri, 14 Aug 2026 15:55:36 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v3 07/19] target/arm/kvm: handle special ID registers
 cases when reading from KVM
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
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
 "armbru@redhat.com" <armbru@redhat.com>,
 "philmd@linaro.org" <philmd@linaro.org>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 Mark Cave-Ayland <mark.caveayland@nutanix.com>,
 Prerna Saxena <prerna.saxena@nutanix.com>
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
 <20260716213858.609699-8-khushit.shah@nutanix.com>
 <134decf2-a084-4cba-8536-a59ecbd6b420@redhat.com>
 <34D1F8A9-C40F-4BA4-80F8-FC611EBCC732@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <34D1F8A9-C40F-4BA4-80F8-FC611EBCC732@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tMmyDdH_ZJpxY5VO8z85nYxppE76sZgGqXcfJmOQDt4_1786715739
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/3/26 5:52 PM, Khushit Shah wrote:
>
>> On 22 Jul 2026, at 6:02 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> Hi Khushit,
>>
>> On 7/16/26 11:38 PM, Khushit Shah wrote:
>>> The generic KVM_GET_ONE_REG loop cannot correctly read a handful of
>>> ID registers, so specially handle those:
>>>
>>> - DCZID_EL0: No fine grain trap exists, hence not tracked by KVM.
>>>  It is EL0-readable and untrapped, so read it directly with MRS.
>>>
>>> - CCSIDR_EL1/CCSIDR2_EL1: not plain ID registers, their value is
>>>  selected by CSSELR_EL1. KVM only exposes them via the DEMUX API
>>>  (KVM_REG_ARM_DEMUX_ID_CCSIDR), so there is no single value to read
>>>  here. Skip them.
>>>
>>> - SMIDR_EL1: KVM does not support SME, so there is no meaningful host
>>>  value. Skip it.
>>>
>>> - GMID_EL1: not in KVM's sys_reg_descs[] and, being an EL1 register,
>>>  cannot be read from userspace via MRS either. The guest reads the
>>>  raw host value; this is a genuine miss when MTE is enabled.
>>>
>>> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
>>> ---
>>> target/arm/kvm.c | 53 ++++++++++++++++++++++++++++++++++++++++--------
>>> 1 file changed, 44 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>> index 42ff731f6e..6974e5c551 100644
>>> --- a/target/arm/kvm.c
>>> +++ b/target/arm/kvm.c
>>> @@ -311,15 +311,50 @@ static int get_host_cpu_idregs(int fd, ARMHostCPUFeatures *ahcf)
>>>         int ret;
>>>
>>>         reg = &ahcf->isar.idregs[i];
>>> -        ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
>>> -        if (ret) {
>>> -            if (errno == ENOENT) {
>>> -                warn_report("%s error reading value of host %s register "
>>> -                                "(ENOENT)", __func__, sysregdesc->name);
>>> -            } else {
>>> -                error_report("%s error reading value of host %s register"
>>> -                            " (%m)", __func__, sysregdesc->name);
>>> -                err = ret;
>>> +        switch (i) {
>>> +        case DCZID_EL0_IDX:
>>> +            /*
>>> +             * DCZID_EL0 is not in KVM's sys_reg_descs[], so
>>> +             * KVM_GET_ONE_REG will fail. Read it directly from
>>> +             * hardware since KVM doesn't trap guest reads of it.
>>> +             */
>>> +            asm volatile("mrs %0, DCZID_EL0" : "=r" (*reg));
>>> +            break;
>>> +        case CCSIDR_EL1_IDX:
>>> +        case CCSIDR2_EL1_IDX:
>>> +            /*
>>> +             * CCSIDR_EL1 is not a plain ID register: the value it
>>> +             * returns is selected by CSSELR_EL1, so there is no single
>>> +             * value to capture here. It is exposed to userspace only via
>>> +             * the DEMUX API (KVM_REG_ARM_DEMUX_ID_CCSIDR), indexed by
>>> +             * CSSELR. Skip reading it here as there is no meaningful host
>>> +             * value to read.
>>> +             */
>> I think you should rely on prerequisite
>> [PATCH v4 3/3] arm/kvm: get demuxed ID registers from kvm
> Currently I am just skipping those as anyway KVM exposes a very
> barebone Cache topology.
>
> Agreed on using DEMUX regs, in case we want to support exopsing some other
> “config”.
>
> Also on this point, I don’t know if CCSIDR_EL1/CCSIDR2_EL1 should
> be part of idregs[], we already have a ccsidr[], maybe this can be fixed
> in your series.

OK i will investigate this.

Thanks

Eric
>
>>> +            break;
>>> +        case SMIDR_EL1_IDX:
>>> +            /*
>>> +             * As SME is not yet supported by KVM, ignore reading SMIDR_EL1
>>> +             */
>>> +             break;
>>> +        case GMID_EL1_IDX:
>>> +            /*
>>> +             * GMID_EL1 is not in KVM's sys_reg_descs[] and guest reads
>>> +             * the raw host value. But as it is an EL1 register, we cannot
>>> +             * read it directly. This is a genuine miss when MTE is
>>> +             * enabled for the guest.
>>> +             */
>>> +            break;
>>> +        default:
>>> +            ret = read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg));
>>> +            if (ret) {
>>> +                if (errno == ENOENT) {
>>> +                    warn_report("%s error reading value of host %s register "
>>> +                                    "(ENOENT)", __func__, sysregdesc->name);
>> trace point
> Noted.
>
> Warm Regards,
> Khushit
>>> +                } else {
>>> +                    error_report("%s error reading value of host %s register"
>>> +                                " (%m)", __func__, sysregdesc->name);
>>> +                    err = ret;
>>> +                }
>>>             }
>>>         }
>>>         trace_get_host_cpu_idregs(sysregdesc->name, *reg);
>> Thanks
>>
>> Eric
>

