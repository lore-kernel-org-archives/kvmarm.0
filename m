Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0772521CC5B
	for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744738319; cv=none; b=b3MsH9hAztuIeujF9SUaOSMI2W89WDvacZi5fA+UeDnmamRZy2kDgBdPMfUA27xhUUW6ziznLLyjHBpZ5EqOSv0qHxkcckV9XzOEeb+ghAdVBpyGw5QBpdcvAodfE/Pll3XDva8FSzN338fMzM5BnZvc6M62XoqXKidab5Oz1XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744738319; c=relaxed/simple;
	bh=HzBN5hmj+DMXXsJd2xjl7biOFjXFYV5945zPxaDqALM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oDhPSy89HKGNwmTqnqx+N7HkyTQGmCUYgR7L+MVGOTI1En4nw2RxFd8TU2oMGduAjygDouILHmin7ox86Lfx8mlDCUThC1PuUKMGypUfAxKDvIo99VBdg2N9CzvsmlQCexkSNzr/B4XCdxCqrOhC46vZ5hgJ9bR+ze5QqfeLf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YOSMGZ+q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YOSMGZ+q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744738316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/7mYhx2kRriJ8qhsg8G/2thr6sZGezFvHhrfnmNR+G0=;
	b=YOSMGZ+q+rX9M3vb8OxmaE7wI77O/i5L4AsZuueKOr60a8aL0kj5qXzEcEHPPddEgN3M9W
	mjHkUIq1GkGlVkVo573D2t4/1+3Qb0PUWtWIVELNwjBOlpwoWy3jUC0Pr0H69GOWQlAArd
	X5rMuE/k5nYFpnQ6AlSTyDv6gVnQtcU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-qBEGClAzMl6i8dwmAKPkwA-1; Tue, 15 Apr 2025 13:31:55 -0400
X-MC-Unique: qBEGClAzMl6i8dwmAKPkwA-1
X-Mimecast-MFC-AGG-ID: qBEGClAzMl6i8dwmAKPkwA_1744738314
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf446681cso38246935e9.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Apr 2025 10:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744738314; x=1745343114;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7mYhx2kRriJ8qhsg8G/2thr6sZGezFvHhrfnmNR+G0=;
        b=uBUrqhtJ6J/9gIX7LOjgsjUM7rSDb+Nz8LnWH/cATMjUt5RWW3tedvKWFlFNP1FT3D
         MSjyBGKNepLYUyWDxfxWsqBl66Cn+MNxV+HwGxzAlKRYNwHag9Bbhm++Sh2cSwSbjC8H
         lvUQCaiQt7i8Lr++hP9Pm+58Q4MF+wlp0QVhJ6uRQFr3ThnQlXte6E7+jZ9Vxi/fAz8S
         R0ZANV5cXNJ1BMFPc5fVafGLriUsJ/HFcFwybvMFTkzFZKQkfOCLsGRrCoC+rU7osEOx
         +vLACLy6C8iqRz3JmWC126XAg9HQF7E33nfU6U51zkT9HUHzildKj2X7j9T+c/y1O8Db
         1EJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbQO5tTuVT/INMDsKWlzbq4NFPBm7sBKRIKQqe/ttaYxcLTpBw1Xjdj5MGUCEDQUMuwtjS/Ks=@lists.linux.dev
X-Gm-Message-State: AOJu0YyG+qcqr3+eBzmHRvWC/JUCdNx3cy2thmEBCDm2qybA9x3QzeEG
	21W5rQumFLVFzOPJRazgnIOrr+osBhkEoxCXecOJ8tJDfg9baHxY+lbxaXxPoqtEQCNbWSjemT2
	OfOxnoVyFEPEWmWgZKh/E0Ub4mXs3K6wT7EzZ0yGrLXxUuB3V3kXgSQ==
X-Gm-Gg: ASbGncvnFqP5Ml39IveuXlsZ9soWMnAI9Y1CMAx85OP2yElxI/4SkEK3UPMXdmirScg
	+TiIDkJmBPGgXVzeSPB2B+juVe61ROD5qXw5k+TnoDEBOYHhklk/zOF6OPhbNG/3UxlDf6TXUpX
	X6B0xX3xmaT3jpVr8P1shXjnxxz2B8ag0ImmoHyywN0heEGXQ0ZjLVDgUFladm34fEEWQ4Yq+gS
	m1r/1InhAyw0kAUTI+RfNW7u4E/eCi/CIgAGRAuItUFny7xeyGOhWubaraYiJgboW9AycAKEh9l
	+u/EK2TTcf5ts49NYmooKoBxs8E28/Q6qx4iANPyAyI9Kz//sl0ZWsJw2osB
X-Received: by 2002:a05:600c:348f:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43f3a9b0264mr177173385e9.30.1744738314313;
        Tue, 15 Apr 2025 10:31:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA/tx9grXm5jqEEDz9Bpub9UAtfBltUciF6sMqY25djhf7AkRnDKyrBy1HMtLSSHaxXK+rkA==
X-Received: by 2002:a05:600c:348f:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43f3a9b0264mr177173135e9.30.1744738313974;
        Tue, 15 Apr 2025 10:31:53 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f233a2c53sm213921645e9.14.2025.04.15.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 10:31:53 -0700 (PDT)
Date: Tue, 15 Apr 2025 19:31:52 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: arch_timer_edge_cases failures on ampere-one
In-Reply-To: <86h62wkp1c.wl-maz@kernel.org>
Message-ID: <2490752b-530d-df2c-7ec2-5feb8160c115@redhat.com>
References: <ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com> <86h62wkp1c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -5tp92y2zc4Zoxz3J0Poe7yRL03EhREl78wcCJOGkpE_1744738314
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 10 Apr 2025, Marc Zyngier wrote:
> On Thu, 10 Apr 2025 16:10:43 +0100,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hey,
>>
>> I'm seeing consistent failures for the arch_timer_edge_cases
>> selftest one ampere-one(x):
>> ==== Test Assertion Failure ====
>>   arm64/arch_timer_edge_cases.c:170: timer_condition == istatus
>>   pid=6277 tid=6277 errno=4 - Interrupted system call
>>      1  0x0000000000403bcf: test_run at arch_timer_edge_cases.c:962
>>      2  0x0000000000401f1f: main at arch_timer_edge_cases.c:1083
>>      3  0x0000ffffa8b2625b: ?? ??:0
>>      4  0x0000ffffa8b2633b: ?? ??:0
>>      5  0x000000000040202f: _start at ??:?
>>   0x1 != 0x0 (timer_condition != istatus)
>>
>> The (first) test that's failing is from test_timers_in_the_past():
>>     /* Set a timer to counter=0 (in the past) */
>>     test_timer_cval(timer, 0, wm, true, DEF_CNT);
>>
>> If I understand this correctly then the timer condition is met, an
>> irq should be raised with the istatus bit from SYS_CNTV_CTL_EL0 set.
>>
>> What the guest gets for SYS_CNTV_CTL_EL0 is 1 (only the enable bit
>> set). KVM also reads 1 in timer_save_state() via
>> read_sysreg_el0(SYS_CNTV_CTL). Is this a HW/FW issue?
>
> My hunch is that this is related to AC03_CPU_14 in [1] (now archived
> locally for future reference...).

Thanks! Your hunch seems to point in the right direction. If the diff is
smaller than 2^63 this is working as expected. I'll try to figure out some
changes that let the test succeed on ampere while still doing meaningful
tests.

Sebastian

