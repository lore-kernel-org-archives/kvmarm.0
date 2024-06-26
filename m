Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F11013AD11
	for <kvmarm@lists.linux.dev>; Wed, 26 Jun 2024 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719392509; cv=none; b=KCFTZfvrrx3leNW/vDLXCcV084xeswOgzx01AO1VnOR2GpTMwp3ftsT6QM+yO7jnAsOAUVHjKhYzpyx2KiplbKp78ZzSoQ70DtYLOcWZKghIOHkH41RCWUsCtaglxWJn/m5V8wQ/18YtGejAu8CkXGk8b8ZWE2sV6TMdz3wm83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719392509; c=relaxed/simple;
	bh=2ciIN+SpmSpfnglqOXEBiKHd1ccbS1FEXjS9vxowFKg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=uFnberrV9n5B3D+sL8hfYrYYATzJnU/fk2ltMxx8SG/F3cf8BGWlFWgKrlMgiVlSIIN/cmSPyiLW8ZEhM8QIu0rBPuXZvLtcb7B6hLQngSRhwdbmVh0WrAZZGttQllvsIhMdN+cM0hm2v/0Hf3GPieMqwxVXtUrYOzIeySuGfoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I7y7FzKE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I7y7FzKE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719392505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1oadlD53pCQIFec/zKp7mDa0vRATXxlFgTZ1DCZKpA=;
	b=I7y7FzKEHcK2QNPoYa4kRsPB70p+JGDSV6YuwzrsvaO7bzqOe8KsxI63SNq3AT5jH+6Fku
	gzW4nIw0v8SCj2AcqNh5v8wswnqTb4ouGmwEwSJScn9EGUdBizkvKme5PSp0ZtFjUrIMbK
	E6PWZJvG6wixSiBIxgXSY7ufGmfnjP0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-Gt__KpgyNr2-JjznU89ISg-1; Wed, 26 Jun 2024 05:01:43 -0400
X-MC-Unique: Gt__KpgyNr2-JjznU89ISg-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2c7b3b67b8eso1629453a91.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Jun 2024 02:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719392502; x=1719997302;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p1oadlD53pCQIFec/zKp7mDa0vRATXxlFgTZ1DCZKpA=;
        b=LxcjKrfIcOkerE2SdJ2B/APr+bAU8Vy0O0BrAPN2emDlVsiNlIvBsLH6B0oZ4vhVb2
         k2yL//lz5EKu1zjfsnblzbN3bXtcJGjsvyo/Zs/uqnyZcdMBkmenntupCwBD7SDcXYPz
         wEx4Lplk0hfR3t/Zqd7F96Qdm6zDosT3nyuY+rhsEq+Tz8RPslaRjMHnY0WRS2dDVWrI
         F/pCmYf5BPZxnkWdCRcEmTaKwa9ufJaIcfv225qDkQtlG9G3EUxJJDQJW1ANQmonyJrP
         LmTU4AkKirgfSdFe4GIxrtrY3gIiO4Nu42K8WOGLehFwMNnO5LktehUPbnMHw6O4dZOo
         w/Sw==
X-Forwarded-Encrypted: i=1; AJvYcCUO8f/aFqS1JEbaGnPA5CWy53mjQ4CQPmHru1EQGrGJbf4dBKZwbEH+RQfW0EotPBghO9yoVH8iYihpImAoKpMIIbU2R9sk
X-Gm-Message-State: AOJu0Yz8fCrgl+VmqAS/ic5nPEe1wyA4+2jgMhCczQpVs3Jrmv3sq2mn
	FFb1NUuIB9LaLO1RlvGgtnvC1MMfdcqjV5hh2Nj8MiMnK34llljH4Gg1nJ8nkcQ4NaLkwj2yrh9
	el+qhvtSENc2QV3fpljf0ahRSP/bd1jmJUIatCGib7sKIL/n4WkxeLQ==
X-Received: by 2002:a17:90a:8c9:b0:2c4:d63b:cde with SMTP id 98e67ed59e1d1-2c8459a1666mr10209373a91.1.1719392502407;
        Wed, 26 Jun 2024 02:01:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6fec9cHWNZyNFNAaBU5CpBsvoyabkVfAUSxogFAm8SfcX7v6bhEwGYG4eMaAqENJK+DiniQ==
X-Received: by 2002:a17:90a:8c9:b0:2c4:d63b:cde with SMTP id 98e67ed59e1d1-2c8459a1666mr10209350a91.1.1719392502002;
        Wed, 26 Jun 2024 02:01:42 -0700 (PDT)
Received: from [10.72.116.72] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c8d8094371sm1115742a91.54.2024.06.26.02.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 02:01:41 -0700 (PDT)
Message-ID: <d0077254-94ef-43cb-8d2b-f45bd8851a47@redhat.com>
Date: Wed, 26 Jun 2024 17:01:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: arm64: Allow userspace to change
 ID_AA64PFR1_EL1
From: Shaoqin Huang <shahuang@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20240618063808.1040085-1-shahuang@redhat.com>
 <20240618063808.1040085-2-shahuang@redhat.com> <86ed8uk8cr.wl-maz@kernel.org>
 <f73cabc6-8c48-4c12-9d60-269e50df41f3@redhat.com>
 <861q4qk9z7.wl-maz@kernel.org>
 <6935be08-f29e-4dd1-9fe7-3d51d3f97509@redhat.com>
In-Reply-To: <6935be08-f29e-4dd1-9fe7-3d51d3f97509@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/26/24 15:33, Shaoqin Huang wrote:
> Hi Marc,
> 
> On 6/21/24 15:53, Marc Zyngier wrote:
>> On Fri, 21 Jun 2024 07:17:57 +0100,
>> Shaoqin Huang <shahuang@redhat.com> wrote:
>>>
>>> Hi Marc,
>>>
>>> On 6/18/24 15:39, Marc Zyngier wrote:
>>>> On Tue, 18 Jun 2024 07:38:06 +0100,
>>>> Shaoqin Huang <shahuang@redhat.com> wrote:
>>>>>
>>>>> Allow userspace to change the guest-visible value of the register with
>>>>> some severe limitation:
>>>>>
>>>>>     - No changes to features not virtualized by KVM (MPAM_frac, 
>>>>> RAS_frac)
>>>>> ---
>>>>>    arch/arm64/kvm/sys_regs.c | 3 ++-
>>>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index 22b45a15d068..bead81867bce 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -2306,7 +2306,8 @@ static const struct sys_reg_desc 
>>>>> sys_reg_descs[] = {
>>>>>               ID_AA64PFR0_EL1_GIC |
>>>>>               ID_AA64PFR0_EL1_AdvSIMD |
>>>>>               ID_AA64PFR0_EL1_FP), },
>>>>> -    ID_SANITISED(ID_AA64PFR1_EL1),
>>>>> +    ID_WRITABLE(ID_AA64PFR1_EL1, ~(ID_AA64PFR1_EL1_RAS_frac |
>>>>> +                       ID_AA64PFR1_EL1_MPAM_frac)),
>>>>>        ID_UNALLOCATED(4,2),
>>>>>        ID_UNALLOCATED(4,3),
>>>>>        ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
>>>>
>>>> This isn't a valid patch.
>>>>
>>>> Furthermore, how about all the other features that may or may not be
>>>> currently handled by KVM? Please see [1] and make sure that all
>>>> existing fields have a known behaviour (a combination of masked,
>>>> preserved, capped, writable or read-only).
>>>>
>>>> I can at least see problems with MTE_frac and MTEX, plus all the other
>>>> things that KVM doesn't know how to save/restore (THE, GCS, NMI...).
>>>>
>>>> What I asked you to handle the whole register, I really meant it.
>>>
>>> I currently only found the BT and SSBS fields can be written without
>>> any unknown behavior.
>>
>> I can only assume you haven't looked hard enough.
>>
>>>
>>> All other fields in the ID_AA64PFR1_EL1 are either not supported by
>>> KVM or the field involved with other register and KVM don't know how
>>> to handle them.
>>
>> Why can't CSV2_frac be writable? Why can't most of the other fields be
>> hidden depending on the VM configuration, as pointed out above?
> 
> I looked at the "struct arm64_ftr_bits ftr_id_aa64pfr1[]" in the 
> kernel/cpufeature.c, I don't see the CSV2_frac has been supported on ARM 
> bare-mental. In this situation, can we first support it in KVM? If so, 
> how can we do that, I don't understand that, could you give me some 
> hints about that.

More description about the CSV2_frac.

static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 
ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, 
ID_AA64PFR1_EL1_RAS_frac_SHIFT, 4, 0),
	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_MTE),
		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_SHIFT, 4, 
ID_AA64PFR1_EL1_MTE_NI),
	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, 
ID_AA64PFR1_EL1_SSBS_SHIFT, 4, ID_AA64PFR1_EL1_SSBS_NI),
	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_BTI),
				    FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_BT_SHIFT, 4, 0),
	ARM64_FTR_END,
};

If we make the CSV2_frac writable, there isn't definition about 
CSV2_frac in the ftr_id_aa64pfr1. And the KVM really depends on the 
ftr_id_aa64pfr1 in the arm64_check_features() function. We're missing 
the CSV2_frac.

So the arm64_check_features() will not check the CSV2_frac if it's 
writable, and the user can write any value into it.

Thanks,
Shaoqin

> 
> Other fields are same with CSV2_frac I think. The KVM don't know the 
> configuration about them. Why we should allow them writable and hidden 
> them right now? Instead of just make them still unwrittable? >
> Thanks,
> Shaoqin
> 
>>
>>     M.
>>
> 

-- 
Shaoqin

