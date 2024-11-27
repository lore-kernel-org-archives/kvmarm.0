Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD62819
	for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 17:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732730005; cv=none; b=ny4Pg244JK3BTx5nbGkylkPZudlQoGPEbx5b5WxssdYuD2C5S23zWpBauz9/Z26NKC6LDsP9RVIY0Ik+HCe4L93fNY0afSLhINDu0RFRnHx/i4OuAb4+7N2719hw7sgelUZ/KDJc9OcLrzjV3OYQSIUW4mPkRPaSy6N3E1DY5Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732730005; c=relaxed/simple;
	bh=IG/rpNVIGU08DPyCKXGhXrUYIPdoGrJ85FUEOFJzS28=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WLtZKbB3uGkIh7hflk3onyls04z/3DKLG11GYuIucUNWF7O+hyVvrE6ZKKUcOXwkDDgVFdJzcT/QThmwAMniktAz0Ru3aJzD03a+/CRK64EyzEEziGn1Qey1tzepb/WH4YAXOa4kXIK/sArjVVEN+lWAqKKQWkr3G9eknNnZ1xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LkhTdqGb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LkhTdqGb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732730002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oXebUtxKx7Yue8TaCMkSObpvA/kHo5Badeg+J8Y9otg=;
	b=LkhTdqGbuzERLtdGfEsZFuYM/yg7iYJXFvuE4DJdK+eKlME3yuH0gxyfd8VKp8hPvNbH3s
	4AhubvG2hGK96pQ7CDT9r44WVu6xXwFRi1ThysBnX3qVWgNfezYeCvJY1irOVBW9KjMT4T
	0CiaCB/OewEixi0haYoslZSV2bFxqms=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-COV_FrtVO1-YIrhmNqBtww-1; Wed, 27 Nov 2024 12:53:20 -0500
X-MC-Unique: COV_FrtVO1-YIrhmNqBtww-1
X-Mimecast-MFC-AGG-ID: COV_FrtVO1-YIrhmNqBtww
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a73651e2so13971695e9.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 09:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732729999; x=1733334799;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oXebUtxKx7Yue8TaCMkSObpvA/kHo5Badeg+J8Y9otg=;
        b=cqGTvIMJ1uo6PWqtgU3Kr/H9Au88i2RLJX+hIDiMiIqcM5JlVxjBnke/SQIKmSbnVP
         c+Ud6EWenDtbxVT6X40gYnffD3e34kyOsfxfUF1tjnHkNippF5Q6ZqNzjzKDOEgFW8eO
         ICPGzg5aVi+iegoY3d6Lu+mfPzn4pGikVbV839IDysHCKmyZidbqgqz6XPxfibvcPKoB
         IJhCqEAyQaeSWebhrhw15Cdzij2M65WRRTdvwkoltbX+OyfsP6paNC6GY0Zvu3u/iOOy
         p5XQLDGGtqzp2FfNSBsJk6NYINAvRHUPDal1u+Lo39y4NxzFnTWOZsXuZEgoij0IZIoa
         d2sw==
X-Forwarded-Encrypted: i=1; AJvYcCXJEu05in5PDbMbcAbeKdUOhnlEEyuYBRSQJjnwwwPtSceap26aglV0qRUDahHXPubo99fhAek=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqaJjP6hbwW6YULrM3GB6eJB4gbUbYOQKKnOezOaWO14Xwrzez
	Gt9jbinnscGDe/z/4V5+hE6zEuGTgk5ZwE6DwUVMrtjvCPqhA5FTqrfzg2d74hgshqrjPgF9Cf2
	3csZWz/NDa8DytGtIC8sRVFEItzocW2ctYxRrqDapr8ImN+yjip6rhg==
X-Gm-Gg: ASbGncsg7M560wpR5zDHpqgjvJIwz/5qUlnX8NRmx3gffK4iKdtNBX7rzjTGx0PQc4s
	mPcXiF8ZPfkeVYTSsJBLIJbVMGYu+KPxsvrIVF5Qc730lQD9VI3frsh60626Ni9RJ83haYaueLP
	ztH3yIG6iGEOOGRrJ8U7EjFELBTHrhK0jpLw0pQ7YnwTML0p3Niu8iRGDg0N4OUmwYWR8obCPW3
	SUZCaW5IGx6jBvkzykUBj9oAQxjk/X6r7W5y5oXgmrQDLLJ5MQE6vAYt59di4RkcEEHw1QkUqBE
	BKpc+08r/6x/94x52kOUmA==
X-Received: by 2002:a05:600c:3546:b0:434:9fb5:fddd with SMTP id 5b1f17b1804b1-434a9dec6c1mr31792625e9.23.1732729999674;
        Wed, 27 Nov 2024 09:53:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6anDJQjt8ptWxGgz7dhwaMeTQsYcl8C3n27l3PnWHFhWZjEJlpfVjhPH6uqi9gMk12+ahIA==
X-Received: by 2002:a05:600c:3546:b0:434:9fb5:fddd with SMTP id 5b1f17b1804b1-434a9dec6c1mr31792415e9.23.1732729999273;
        Wed, 27 Nov 2024 09:53:19 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fafe504sm16773349f8f.25.2024.11.27.09.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2024 09:53:18 -0800 (PST)
Date: Wed, 27 Nov 2024 18:53:18 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "will@kernel.org" <will@kernel.org>, 
    "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    "james.morse@arm.com" <james.morse@arm.com>, 
    "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
    yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, 
    Linuxarm <linuxarm@huawei.com>, "reijiw@google.com" <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1
 writable from userspace
In-Reply-To: <87zfllssji.wl-maz@kernel.org>
Message-ID: <9d8e1bb6-797b-d0c9-6456-eb001271ba0e@redhat.com>
References: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com> <86v804z3lk.wl-maz@kernel.org> <b2dad37ac5464384abe4edf76cb6b546@huawei.com> <4d3a7dde-e085-fa70-8859-ba153c93b615@redhat.com> <87zfllssji.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mPw5f1_v4_vLm5sSBtHlCOHEQBg1XRKY1P_J9zw_Cvo_1732730000
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 26 Nov 2024, Marc Zyngier wrote:
> On Tue, 26 Nov 2024 17:00:35 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
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

It's the only diff in DFR0 - CTX_CMPs is the same. There are diffs in
other ID regs as well but these are already writable.

>> preventing us from trapping the access and make sure the correct
>> breakpoint is used? Is anyone working on this? If not I'd like to
>> give it a shot.
>
> Not only trapping. You also need to handle some interesting parts of
> the architecture, such as the breakpoint linking fun.

Ugh, and I was thinking this might be straightforward ;-(

> But if we are to go down that road, I really want to restrict that to
> implementations that have FEAT_FGT. Because otherwise we need to trap
> and emulate *everything*, instead of just the breakpoint registers.
> And that would be pretty bad from a performance perspective.

OK, understood.

> Another thing is that this only works because there is no report of
> the breakpoint number in ESR_ELx. The moment we offering this
> migration "feature", we are painting ourselves in a corner, should the
> architecture ever evolve to something less... bizarre.
>
> Finally, who is going to ensure this keeps working in the foreseeable
> future? Because while this is nice, that's not what gets deployed in
> production, as it leads to unpredictable performances. My take is that
> this thing will eventually bitrot and die.
>
> So, do we *really* want to go down that road?

Thanks a lot for the pointers! I'll do some more digging to figure out
what needs to be done and if that's actually worth it..

Sebastian

