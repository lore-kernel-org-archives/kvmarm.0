Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9B6C133
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732640449; cv=none; b=XwZPIQuBmuA8rEhbsDM1K3LAAFy1zH+xavi8wf+VgdX4w9GZGMlC/Qr1n7OAyS0LrIJmG397uthyn6WvocGaAeigNcvD0TySAex/BG7cRjI4m6zE6eYORhmlgbCJzdAYZP0aLCNCa7BxBWaBno5Elh9vWvetEL9tnTpiRPKSPCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732640449; c=relaxed/simple;
	bh=Eg1Rv+vSBEGAGZDiocMh75GFR+rL9I8a/POQDXOqEIg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kExl8Pp0zUIlnmzHy8rVTGVu4afqtl2doOkYadgQ0CALsTfXflJHcGJCde+FPcoqkp3oYHp4Uwj/uLloFEBqhNoYqUw4/0Ly8TL+m56qNM8U+bcJWzOLoasgEwi93ccOa6d4T4XV6pGTWHeAeP3sNTIHLWELud56J/I/s1Zw/6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H1i67Ngi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H1i67Ngi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732640446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ydmtTAzJ7xFTdnZQzRxd9lW2geyaRjzb3DBbsGuXzYg=;
	b=H1i67NgiUN3A93zqAoIfhVBawspt7iU8/hwq3pEMUVx9MvwIf8f6FXCxfeK2QWCBmKFxxK
	CMa2uebPaCeQMuvLhGVXrB/3kl29hrI29Qty07Dmh+8DgJ/7VYQLSVaSIkrnCuBuj4kTwO
	dTcUaOzV0HtHDCIUrpIyS7LtpgmZcs8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-iZ0hJlO8NJ-YTvXYqh27Ww-1; Tue, 26 Nov 2024 12:00:43 -0500
X-MC-Unique: iZ0hJlO8NJ-YTvXYqh27Ww-1
X-Mimecast-MFC-AGG-ID: iZ0hJlO8NJ-YTvXYqh27Ww
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b65d6daa02so396073285a.3
        for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 09:00:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732640443; x=1733245243;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ydmtTAzJ7xFTdnZQzRxd9lW2geyaRjzb3DBbsGuXzYg=;
        b=dBEDQac4Ap1wXhir8PeNYVaIFNNB+igHV4com/wsM8HCJTx8XAzLsIB9pmIKzZH49n
         QgtFTstOKIQlOqkRSc79qw9W3o7og06zgJoVoIWNxMT4eUAZXgMfVogwpKXNpkl2Eqt5
         NbJ68+MF1VzBs02jxsqy3K9z+5eMNaSoWoCRy6mpsmio14IyVuGjZCzv/iForKiMvtam
         z3APq4gq0uIu6sJI+vrVJH68xKbtL0f4sliljmX3pN5QZTdiecapsvzHWJ7SIvlxXbzM
         0NIphl1uuIpSVad8rg8P+jvGPsOQKzXIFjHpxz4XXL7/kwKvNlfprVvwa2BjpgntIVc8
         ZToQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/SHL8WBnCSgvBpn6wUd+5GhN3/ar2D7nfs7Nu8jKMet8ZmUZINkILmY4ZZyvM6Z1vs4RrhTk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9Xe80hesHst/XenpAm5zsx98J8ge4WtVd3czisC7D4hTtibNY
	U8btFuwNb2qkEew8Dezmxny5wx0C/u3y70bYYqcpxW6hLF9ZFJWN7YCG4lwMpieeMkTuQNPqQLh
	asEw987P3wUDNnHklf9w8luO27tnZJ0+1mNcG1N7hOBEaHkidDHJ8Dw==
X-Gm-Gg: ASbGncsOuJbW0Li1KiW+Oo8fpIKZQ31TFOF/YBiZ5NxJlCTuTx9VKrFQ3grdFFe/x1M
	LDYoskNxmFGje1RrhTBO+rIZ49WgIAOtCJqhrJ1Uo6ic/PdSOAzFAVU0sBUUbkruYjT3d+QTnOS
	8jhqG2/fZVv7urc3ONGu6+NH/ERMubYb4f2Z7q7e2QJu1viT5rtr+UYwL7wR6xcqJC81vgRZcDy
	yhlIm/q23UvnC6Tb+qVG1hTEqNT4wGue7dPKhriOEf3DLsEKaIby+4ouopT6xI0hdW4hWXS73EM
	sOtitarIJegbaVccUYK6iA==
X-Received: by 2002:a05:620a:4393:b0:7b6:66d0:5ab6 with SMTP id af79cd13be357-7b666d05b7fmr1177814985a.51.1732640442841;
        Tue, 26 Nov 2024 09:00:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEk2ACspI3Vw+bJ1uihy2FVtGnZP2FHNgWeUwBtUpzJHCjn+X46VDNrXbQ0bQSxFF1w9gPpfQ==
X-Received: by 2002:a05:620a:4393:b0:7b6:66d0:5ab6 with SMTP id af79cd13be357-7b666d05b7fmr1177812085a.51.1732640442528;
        Tue, 26 Nov 2024 09:00:42 -0800 (PST)
Received: from rh (p200300f6af0bca008282df582fad0b68.dip0.t-ipconnect.de. [2003:f6:af0b:ca00:8282:df58:2fad:b68])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b51416a3a9sm481154685a.113.2024.11.26.09.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 09:00:42 -0800 (PST)
Date: Tue, 26 Nov 2024 18:00:35 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
cc: Marc Zyngier <maz@kernel.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "will@kernel.org" <will@kernel.org>, 
    "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    "james.morse@arm.com" <james.morse@arm.com>, 
    "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
    yuzenghui <yuzenghui@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>, 
    Linuxarm <linuxarm@huawei.com>, "reijiw@google.com" <reijiw@google.com>
Subject: RE: [PATCH] KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1
 writable from userspace
In-Reply-To: <b2dad37ac5464384abe4edf76cb6b546@huawei.com>
Message-ID: <4d3a7dde-e085-fa70-8859-ba153c93b615@redhat.com>
References: <20240813142835.77180-1-shameerali.kolothum.thodi@huawei.com> <86v804z3lk.wl-maz@kernel.org> <b2dad37ac5464384abe4edf76cb6b546@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KwuzzbJtWExV4rJ3NJXKbEDSNhFtgNL3_a3j3_s9xF8_1732640443
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Wed, 14 Aug 2024, Shameerali Kolothum Thodi wrote:
>>
>> On Tue, 13 Aug 2024 15:28:35 +0100,
>> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
>>>
>>> KVM exposes the OS double lock feature bit to Guests but returns
>>> RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
>>> systems where this feature support differ. Add support to make this
>>> feature writable from userspace by setting the mask bit. While at it,
>>> set the mask bits for other exposed features in the AA64DFR0_EL1
>>> register as well.
>>>
>>> Also update the selftest to cover these fields.
>>>
>>> Signed-off-by: Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com>
>>> ---
>>>    This is based on the discussion here(Thanks to Oliver),
>>>    https://lore.kernel.org/all/ZrVSlbVwnaMDShah@linux.dev/
>>> ---
>>>  arch/arm64/kvm/sys_regs.c                         | 6 +++++-
>>>  tools/testing/selftests/kvm/aarch64/set_id_regs.c | 4 ++++
>>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index c90324060436..adb49d681052 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -2376,7 +2376,11 @@ static const struct sys_reg_desc sys_reg_descs[]
>> = {
>>>  	  .get_user = get_id_reg,
>>>  	  .set_user = set_id_aa64dfr0_el1,
>>>  	  .reset = read_sanitised_id_aa64dfr0_el1,
>>> -	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
>>> +	  .val = ID_AA64DFR0_EL1_DoubleLock_MASK |
>>> +		 ID_AA64DFR0_EL1_CTX_CMPs_MASK |
>>> +		 ID_AA64DFR0_EL1_WRPs_MASK |
>>> +		 ID_AA64DFR0_EL1_BRPs_MASK |
>>
>>
>> I think this is going to cause some troubles.
>>
>> The issue is that context-aware breakpoints are the highest-numbered
>> breakpoints, right after the normal breakpoints (D2.8.3 "Breakpoint
>> types and linking of breakpoints"). So if you reduce the number of
>> normal breakpoints, you shift the context-aware ones down, and
>> everything breaks.
>
> Thanks Marc for explaining this. I was not aware of this one.
>
>> I really don't see how you can safely do that without completely
>> changing the way we handle the debug registers.
>
> Looks like Reji has attempted to do this a while back,
> https://lore.kernel.org/kvm/20220419065544.3616948-13-reijiw@google.com/
>

I've got two machines that differ in the number of breakpoints and
it would be nice to be able to migrate between these. Is anything
preventing us from trapping the access and make sure the correct
breakpoint is used? Is anyone working on this? If not I'd like to
give it a shot.

Thanks,
Sebastian

