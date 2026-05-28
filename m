Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094AD3FBB55
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981380; cv=none; b=txuUaXo6yjfbt0TO+hHg/ZjjDrNByUsKGwMcZoI19OTyrOzLJiLsZLR/OkyhwIdk+j6je74eTE3UE212rPk6Z2Y7IFvDdoCQbjbz+pKb8Pncc/ITXBpmR6Vr2+UR4B+TDDVlgvlPttdX9v1A0rhVDuN+CfY2+CI5DcxTIgD3E8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981380; c=relaxed/simple;
	bh=6oqbbnw7xeR9ONaDCpAbIAY2rBlSZAfrT0WbBlakLF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CyfFuUtymt8yrKQ1ZP9QaVVOniqILod7JHuDtXxQ/gZ4eMFljmanYOgcNiFycLGsgBKk6XICr3LNyUmeSlLPyc+Bf9O3rBSM/1++bYNYbG8vVgJJ3wr4JBg6gbmdtfKAXdgYF/+HvK8CIxbYMq63FJwJoDeB81w56Z3hD+Xo0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aI5WWuoc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aI5WWuoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779981378;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/+bC7QjDQS+fTuqHVrJHYLhO5StgoEy46exv+WFnTk=;
	b=aI5WWuoc83S/l69VRASZ4NTNwgyHgGlwjD6GJSXyFyVVqWCwT0GzTNUslDV2Rdli+ffLVg
	+t2oiE8Fc6huD1kNYfHsSAOpfLJv3psk//gm/CvawlnePxP9IyM0xlSmD6yO4yg5ezOVAM
	MzveQX+geiZv7Vn9rrWEMe8PS3owIL0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-Sq-gYMvoPhGCiVtI9QMjBA-1; Thu, 28 May 2026 11:14:54 -0400
X-MC-Unique: Sq-gYMvoPhGCiVtI9QMjBA-1
X-Mimecast-MFC-AGG-ID: Sq-gYMvoPhGCiVtI9QMjBA_1779981294
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45eec27f5a5so369267f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 08:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779981293; x=1780586093;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/+bC7QjDQS+fTuqHVrJHYLhO5StgoEy46exv+WFnTk=;
        b=AkTy7aIUt6tHhTVAkJowq9BAKY2yUuw4E6TyJkSbXrzcCLsYvXeldadA4NdJ0EbMtd
         J9QmEqWeJurQF7piZes2nWc+TPnb3Z14gekCiCI5Fo1vcnlwRRNfpNvIu8N2/4bPRHQd
         MDd9N7/7oq+g5+Ry63FdsK7tvRiRXNXFOe7NQbN2GVaLRSUmBstqLkaEiio43tSeB16V
         QgkeOtvpZhtObA482poHIHtGBQWzpZSVzOpGm6TVXvDOv6LyMU6NqsuNLoRbPoUDF592
         DA0UO8lCUtP4vAWYQoREHr2FrKhjnQe+Hm3xdz45ODooqpGdf4rcY2NRUKPKNlnSz8cv
         pelw==
X-Forwarded-Encrypted: i=1; AFNElJ9jN+Ao2Ttcn3VOMnntXedxzVNiboSUJdmQRs730Y4PFys5V7EAObUlPdqWzBpTn7es9tm1N0A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxrJEiOMjj8IlFXIHHT43UE64ACOfLg21Bb782ipq3SV5AbQxPF
	Z2Q5TvVI+fxg7ko+m3qJdqSkASaeiBZQPBajGDgIvEeSw+k2fTSQSNT54JmILzmfEFP3oKCuzS3
	hva7ZMFDoLAJKHB9DvrFTm9Mz/9DVQwByHwMdN4E9ekloqTrpsU08/qctKQprxMkT2Q==
X-Gm-Gg: Acq92OGKHRdbr7ulWJlXwScQH5L/vrNUUl7fZ9mZlFP6LzE+APDp+8q5lYGeBw+Br5c
	8j77dM+Wy1+SLdMj2tl2lRG4PAtqazzQfOD+DwWDpaW3bsJ8h0HrqyefkKbJuSjuivZ7Tc4O7+f
	4rN7sGDuqhwndgVU/zZyZznLYkMRt0GARYuBGMgtdP/VUWEPehALcF6C84BUm9BZxbn8KKfvpKO
	Hrz9WwRH8t8wnW3WDrT5w7xgXY+rSoCme6gtdU6NRb52ceXWdTrTfReXM9b757dSmV4z5PgRL9y
	MR0ZxFwxYfA837pS0VBkjgb3kWJ09rjMIfIr/wdxgUIvG+3sWHL8aFaZI/9sEzLHDvUdFqnyYeg
	O4Ci+TOoEB9GmP9hvT49AYeHGuD7MTmiJ9aVuJPaxDhWPilUOWiNHIpagpyyI4Lh6M9ORnwi6ct
	mHPjid
X-Received: by 2002:a05:6000:400c:b0:45e:b2b7:1863 with SMTP id ffacd0b85a97d-45eb38a8507mr45091478f8f.16.1779981293643;
        Thu, 28 May 2026 08:14:53 -0700 (PDT)
X-Received: by 2002:a05:6000:400c:b0:45e:b2b7:1863 with SMTP id ffacd0b85a97d-45eb38a8507mr45091427f8f.16.1779981293242;
        Thu, 28 May 2026 08:14:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb549e79sm15071313f8f.7.2026.05.28.08.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 08:14:52 -0700 (PDT)
Message-ID: <6a402e30-91c1-4be7-aa93-0c287839bac2@redhat.com>
Date: Thu, 28 May 2026 17:14:50 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v5 16/18] target/arm/cpu: Expose writable ID reg field
 properties on the kvm host vcpu model
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
 <20260519132905.145643-17-eric.auger@redhat.com>
 <30F66A6A-E26B-486C-81D1-8E1B2CCB558A@nutanix.com>
 <6c14a58a-60ab-419f-9395-ca3489f6cff8@redhat.com>
 <CA136979-E0CC-420E-9271-63CF27CD7DA5@nutanix.com>
 <2fd2057d-c74b-4bbe-b2d0-cb9ed092a37d@redhat.com>
 <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <6F6ECB0E-82A8-4FFA-8687-2D6E243A2096@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cbsx3FukyrXW0s7OLpuv6cII0-miLG-oshg8U1WYr9w_1779981294
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/27/26 6:11 PM, Khushit Shah wrote:
>
>> On 27 May 2026, at 9:34 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> On 5/27/26 5:56 PM, Khushit Shah wrote:
>>> So you are saying, if I do, 
>>> -cpu host,sve=on,SYSREG_ID_AA64PFR0_SVE=0
>>> QEMU will still show sve capabilities to the guest?
>> Yes that's what I expect. Require more extensive testing though. That
>> could be way to handle coexistence of different levels of granulaity.
>> Lowest level applies first, overriden by legacy compositive options. I
>> guess if you plan to introduce other layers of compositive props you
>> will most probably handle this situation too.
>>
> I am sure this at-least does not work with sve, 
> because arm_cpu_sve_finalize() just takes looks at the PFR0.SVE field and If value is 0 sve is 'off' otherwise 'on’.
ID_AA64PFR0_EL1 SVE field is not writable if I am not wrong. Only
ID_AA64ZFR0_EL1.SVEver is

        ID_FILTERED(ID_AA64PFR0_EL1, id_aa64pfr0_el1,
                    ~(ID_AA64PFR0_EL1_AMU |
                      ID_AA64PFR0_EL1_MPAM |
                      ID_AA64PFR0_EL1_SVE |
                      ID_AA64PFR0_EL1_AdvSIMD |
                      ID_AA64PFR0_EL1_FP)),

Eric

>
> What you describe might work for legacy props backed by prop_* boolean variables in ARMCPU like pauth (backed by cpu->prop_pauth).
>
> I have not tested this. I maybe wrong if some prop ordering magic happens at machine level.
>
> My plan is to just parse properties in order they arrive in cmdline :)
>
> Warm Regards,
> Khushit

