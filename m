Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D97CC2FD
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 09:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732786279; cv=none; b=QFXZqUQhLH0IjB0dHC+yTXZLRVg8SL+jok7lWDQhcJpwdWmt5sVtyrvX4NHV/vYmH6V/edm9OMf5Y24PZMEoLlZ3SyZl1GHaR20Taddav3cCUOQocEP16X5Nwhz2IrgkZWrpvlJXYGbrOqSgf20F0e266eX1YhX/j+lzrpF+d54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732786279; c=relaxed/simple;
	bh=YPd1AghTPh87rqS1DmXcVbWj6uKccCu4V4I5x1CelEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hGvZ7pEvb1ocLCddFaJH5Y2f7XnKeeKOV2PXst8GYucxI3I1jk7aG0pA2PvNlpDy/rSKoP58+NRGxHs/z16TiSCsnil7JeY8bqi7Ur4gUlcgWvbLB79kD4U6ZkkXPDv4czu8SpaJo6psk5QPSuYn6+Cn2XzHsCbjmyXwWw6d4u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bHpcmqcL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHpcmqcL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732786276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qflCQcWqRW8CB1fCDGhgJW1k72thggqLlIsWz11JA6A=;
	b=bHpcmqcLSZ0lP/q5zrtuNNTcLt0iKTDRSGvkbQO+oeuHbpxf4QERqEzHgVTCyAK720HV8a
	YwhhYlUp8UB7E0GC1fNBFSNxTraOaDFvkQuW7SPuNZcZBKpwvMzXu8Ql26lypd7IdUNquI
	60WTd+DiRe3n7U64vP3WFLB3PK/CVzI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-Wk3RgFjtM7KJBSQxhCGVrQ-1; Thu, 28 Nov 2024 04:31:14 -0500
X-MC-Unique: Wk3RgFjtM7KJBSQxhCGVrQ-1
X-Mimecast-MFC-AGG-ID: Wk3RgFjtM7KJBSQxhCGVrQ
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6d402d4ff25so9141976d6.2
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 01:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732786274; x=1733391074;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qflCQcWqRW8CB1fCDGhgJW1k72thggqLlIsWz11JA6A=;
        b=n+wdWoYGXebwo7aMDcZdHYTsmlCRJSQVsGH7XH/abDJrJrfue/ykBdxBa1E4OF6AiA
         kIImG8f3jemIfRp/Nw8QsMahlW6SczvzTxean06wKYLm6uAcodOMF+BlLXonzkTHIEun
         ERrYr/y2bAfV56rOL10/pS7w3KhlKjSJGnMg9UoMBEnoI/mFxnm+Q2Nwxgo3HHgUweaL
         ibc2+q4KRIX/um+4UKgqn9aAVshhXgmHiCtOdqdlxnhpF3upongqhOV0ldfc2xggx9AA
         GsjQySzDgfga3hhAekiIX0KAnucdrvMrKYcfgplhyosiQ/+BCGUh7qID4OLpl912bfKC
         lZLg==
X-Forwarded-Encrypted: i=1; AJvYcCW5CtmbdZvbR23pr4M6iePa83cpM+JD/ttJiIAWe4YVBzfiLT8OEmfctERHCNyg2VOkAgM2JeQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYYN5fCsVWCLaDqipd7MEcb5XGLg0Q3A1AKJUun2I4KdDGyBBl
	evz7ihEOgZfDx0EIZDJS8iO1oP/aODucvgLf3c5kAd1pkTjFKNf4SPXQTrxe/Kk+DQiTEFc6voB
	0xc2xGz71zAYp0mnR9yx8yLN/49tsDOcJ3K1kob+8MIZ4RUPpLBm5FQ==
X-Gm-Gg: ASbGnctZDXd5GGWnczYYao6IYAwlg40fDFzOCckmlQAKO1MSnUuUM0Njy91E0ZXsOSB
	Y3oxpi1LsSiZ56lLw0ZKoTAKZc7qYs3lJfdHIO8QbOr8qrT6P/N2RMdQS0UYqPouaW9pgEm2WFj
	lN0YUaj0BGG8bfffzYEiVaDkBYVqZbrXz5rzuGBtD0HkRPG+LcGVknN+vRygxNdW8NmOVQ2z60/
	VY2nwCN8IBt5R5gDBU/nvZfydigIz20FjzlDzGVIK4LA4H7pGKfE+q9/filCOldWqJZRVS0xxVi
	XuOfRJDxQbQA8Obj
X-Received: by 2002:a05:6214:b61:b0:6d4:1d6f:8fb9 with SMTP id 6a1803df08f44-6d864e009fcmr83159686d6.47.1732786273941;
        Thu, 28 Nov 2024 01:31:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEhJ3V/hfVYirr7KuSaMapUfFbH73MzX/j1DHcPc2Xttffsv/HePJDU9+KtkhJ1+BCu2pSQEg==
X-Received: by 2002:a05:6214:b61:b0:6d4:1d6f:8fb9 with SMTP id 6a1803df08f44-6d864e009fcmr83159346d6.47.1732786273649;
        Thu, 28 Nov 2024 01:31:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d87517e457sm4697116d6.31.2024.11.28.01.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 01:31:12 -0800 (PST)
Message-ID: <c879fda9-db5a-4743-805d-03c0acba8060@redhat.com>
Date: Thu, 28 Nov 2024 10:31:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1
 writable from userspace
To: Marc Zyngier <maz@kernel.org>, Sebastian Ott <sebott@redhat.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "will@kernel.org" <will@kernel.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>,
 Linuxarm <linuxarm@huawei.com>, "reijiw@google.com" <reijiw@google.com>
References: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com>
 <86v804z3lk.wl-maz@kernel.org> <b2dad37ac5464384abe4edf76cb6b546@huawei.com>
 <4d3a7dde-e085-fa70-8859-ba153c93b615@redhat.com>
 <87zfllssji.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <87zfllssji.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CM7jgiyosFZTvQMxD_AxAfyp-uXrSPeWs920WvjMvZ4_1732786274
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 11/26/24 20:29, Marc Zyngier wrote:
> On Tue, 26 Nov 2024 17:00:35 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hi,
>>
>> On Wed, 14 Aug 2024, Shameerali Kolothum Thodi wrote:
>>>>
>>>> On Tue, 13 Aug 2024 15:28:35 +0100,
>>>> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
>>>>>
>>>>> KVM exposes the OS double lock feature bit to Guests but returns
>>>>> RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
>>>>> systems where this feature support differ. Add support to make this
>>>>> feature writable from userspace by setting the mask bit. While at it,
>>>>> set the mask bits for other exposed features in the AA64DFR0_EL1
>>>>> register as well.
>>>>>
>>>>> Also update the selftest to cover these fields.
>>>>>
>>>>> Signed-off-by: Shameer Kolothum
>>>> <shameerali.kolothum.thodi@huawei.com>
>>>>> ---
>>>>>    This is based on the discussion here(Thanks to Oliver),
>>>>>    https://lore.kernel.org/all/ZrVSlbVwnaMDShah@linux.dev/
>>>>> ---
>>>>>  arch/arm64/kvm/sys_regs.c                         | 6 +++++-
>>>>>  tools/testing/selftests/kvm/aarch64/set_id_regs.c | 4 ++++
>>>>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index c90324060436..adb49d681052 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -2376,7 +2376,11 @@ static const struct sys_reg_desc sys_reg_descs[]
>>>> = {
>>>>>  	  .get_user = get_id_reg,
>>>>>  	  .set_user = set_id_aa64dfr0_el1,
>>>>>  	  .reset = read_sanitised_id_aa64dfr0_el1,
>>>>> -	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
>>>>> +	  .val = ID_AA64DFR0_EL1_DoubleLock_MASK |
>>>>> +		 ID_AA64DFR0_EL1_CTX_CMPs_MASK |
>>>>> +		 ID_AA64DFR0_EL1_WRPs_MASK |
>>>>> +		 ID_AA64DFR0_EL1_BRPs_MASK |
>>>>
>>>>
>>>> I think this is going to cause some troubles.
>>>>
>>>> The issue is that context-aware breakpoints are the highest-numbered
>>>> breakpoints, right after the normal breakpoints (D2.8.3 "Breakpoint
>>>> types and linking of breakpoints"). So if you reduce the number of
>>>> normal breakpoints, you shift the context-aware ones down, and
>>>> everything breaks.
>>>
>>> Thanks Marc for explaining this. I was not aware of this one.
>>>
>>>> I really don't see how you can safely do that without completely
>>>> changing the way we handle the debug registers.
>>>
>>> Looks like Reji has attempted to do this a while back,
>>> https://lore.kernel.org/kvm/20220419065544.3616948-13-reijiw@google.com/
>>>
>>
>> I've got two machines that differ in the number of breakpoints and
>> it would be nice to be able to migrate between these. Is anything
> 
> Is that the *only* thing that differ? Do the have the same number of
> context-aware breakpoints?
> 
>> preventing us from trapping the access and make sure the correct
>> breakpoint is used? Is anyone working on this? If not I'd like to
>> give it a shot.
> 
> Not only trapping. You also need to handle some interesting parts of
> the architecture, such as the breakpoint linking fun.
> 
> But if we are to go down that road, I really want to restrict that to
> implementations that have FEAT_FGT. Because otherwise we need to trap
> and emulate *everything*, instead of just the breakpoint registers.
> And that would be pretty bad from a performance perspective.
> 
> Another thing is that this only works because there is no report of
> the breakpoint number in ESR_ELx. The moment we offering this
> migration "feature", we are painting ourselves in a corner, should the
> architecture ever evolve to something less... bizarre.
> 
> Finally, who is going to ensure this keeps working in the foreseeable
> future? Because while this is nice, that's not what gets deployed in
> production, as it leads to unpredictable performances. My take is that
> this thing will eventually bitrot and die.
In the context of our works to define qemu vcpu models for ARM
(https://lore.kernel.org/all/20241025101959.601048-1-eric.auger@redhat.com/)
, our current approach is to try migrating between modern HW we have
access to. The case above is migration between AmpereOne and Grace which
both should be prevalent systems. Do you think this does not make sense
at all to try migrating between those, alhough this may be challenging?

Other cases we have looked at are migration within Ampere Altra Max
system family (which should be hopefully fine now with have CTR_EL0
works from Sebastian upstream), mig between Graviton hosts. Wrt Ampere
Altra Max to AmpereOne, Oliver pointed out the cntfrq issue which is
blocking.

Do you think we should restrict our studies to systems which are
"closer" to each other in terms of ARM spec rev. We throught that
migration bewteen AmpereOne And Grace would be an interesting POC and
not totally irrelevant in terms of industry.

Thanks

Eric
> 
> So, do we *really* want to go down that road?
> 
> 	M.
> 

