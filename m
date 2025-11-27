Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52640302158
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764245057; cv=none; b=Fitj797F+6ealwg00z5nzhMgDSX7BgT9GqWSUr+2CVt0FugYalV42n7HbQbK4Xfy9+m9M6Nv8nzOa4F/hx7G09YN2vF7FoahXGq56dXyyrcJLoHiD7nyhlfMsHE3JBDTyIHMZ/NL/XK8AXRotOpp8Hs9srTFjl8g9JVrV2CCigc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764245057; c=relaxed/simple;
	bh=vcSXBRpRjVeGJFE9km19JH+aMnIZwPimIcdlAG4Ob/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=izde+Vn5I7PpL2QGr50OO2tY3WvCQEBMw859Az/C804Ae6VFb1ko3nEtKlHV2Ss65Cags01pLc1sok/Yloms5DZTR2mUsGIbiPBhAywXt60DdTAwTK58nHYX8DNJG/FtvRBRMr1EiYUkXoy7y1tPf1V56wv9QCBsvyE6ku5YOEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpKV3n5i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpKV3n5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764245054;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUjVZ+gcdBFdHXG7icB0DaRoz7GxwtKyjiMLmgn2VbY=;
	b=HpKV3n5iovVIRIO3PNy6bcHCY2U5U6xZUU9wUAfgQSF+VAaSaR3HZac1WDxRcDMg850r1H
	SVt+tb6J0Hw7aj6Ma3M4k1GkJ3xici/ospglMt9uguQr04uXUZOWFvzulND+zX4XNWZ7Pf
	uCcxU8BD7myOTVWjSo0F6ikkxL2YcTk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-uGlpU7_FMOS8fpkOs-3G5g-1; Thu, 27 Nov 2025 07:04:12 -0500
X-MC-Unique: uGlpU7_FMOS8fpkOs-3G5g-1
X-Mimecast-MFC-AGG-ID: uGlpU7_FMOS8fpkOs-3G5g_1764245052
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2dbd36752so152040985a.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764245052; x=1764849852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUjVZ+gcdBFdHXG7icB0DaRoz7GxwtKyjiMLmgn2VbY=;
        b=lMBCsHgfufWFNddtxaLV3X/SkpgVtWQlNyXvfufPznW3ta1QyBU8uwcXFUvey3hGs+
         5Z9Rq8tIx2l/np9Axb6MyRpk2SJxe/5cOyme4i2U8R6Zl3tnM3ZkdYmsr7LK/rn1Isw6
         il8D45ScPCTzxizLz+xVKi8dBXNhl1vNPMpuHozhoQ1g7lc4/2iD8mFgTwlfDQ1cQCAj
         +QmBofb33ADOqGCzrlP7OBtoqc1aZ2IzrBrHacPTXnjYMuOtbx3r4bq6pYPSPO/DrHUP
         WJgtqhH4eexYqMIV1Sj5qeMYHUnYMBKdaI1GECcd3iLsKztB3K/odpqZgJ1oRuyTmmwh
         /hVw==
X-Forwarded-Encrypted: i=1; AJvYcCXzKY+S8b4XpolXEMSnOGEmhJ0+ETuh9/ypW08ce/nA1kjPCJTpLCc+5jUv1PNe4Dqe5gTSHdg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPQTWp2hk5oU9nWDb2cK+p2HuYjKK3EkxUkdBBrQNNZggZSnrt
	tLWSPfeMAOyh61+3baGJplfNwoCN4nIWzWOjUe/eFiPMHGrSFe2sOLQn1xosAacN7NN6YDnczwY
	LHu+zTusyeYwIrkyOh3num7RILMxrUOEU9y5nT8oPxD+MLnWn7nplQeW8ow==
X-Gm-Gg: ASbGnculaRyEQZPI7fPrmRSXjlG+zqSr1qBC/MajVbpMYPnbQW5EP8l88MDpFX4zkzU
	3kC+ICP/AByHExPzzFXPQMAes59Nt7fBzdQgkhyc5ikcKyJ5zwUprmpSJDS7/NqpA8xxSJir2m5
	g+f/p3W4Kjs8pS5GzVfvDQUyG3ZvTwMxm5oAut7JvueuifDzDxyPlIPdT3DV+HeDTs0yJc+iwkK
	CU5mrPIhG9EaP1L9SP6rjRoAePavb4JbuvIpd7EczWSLewG1xlFs7L0Vdv9SFyAHxFglqaMR3Ws
	8/SC/hjThLt75uYV50jXN907WhUmXPskcFEhoFvlvp5LScRi5Lyc4LsMozLCfsVmihHKsyXdP7C
	QGlPtnk8+C1WBLiDaxb+KPUs3MoorQ08UfM6nGWuSKW/M+fr5ACdzZqXPnA==
X-Received: by 2002:a05:620a:4709:b0:8b2:5fa9:61 with SMTP id af79cd13be357-8b33d267d7bmr3011831085a.25.1764245052095;
        Thu, 27 Nov 2025 04:04:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7AU1H8HX4rSD8NL5MRN6YXPh1SkI42ZloscGdOxWAXNWPrUmGzHDfCOVRgii92cyc2qmrPQ==
X-Received: by 2002:a05:620a:4709:b0:8b2:5fa9:61 with SMTP id af79cd13be357-8b33d267d7bmr3011826085a.25.1764245051650;
        Thu, 27 Nov 2025 04:04:11 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1df6b9sm92833385a.53.2025.11.27.04.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 04:04:10 -0800 (PST)
Message-ID: <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
Date: Thu, 27 Nov 2025 13:04:08 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251127110832.GA3240191@e124191.cambridge.arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iR4DvTOa3P7bd1O85Akju2nSL6SbaoTrDKz6GkECko8_1764245052
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 11/27/25 12:08 PM, Joey Gouly wrote:
> On Thu, Nov 27, 2025 at 11:04:43AM +0100, Eric Auger wrote:
>> Hi Joey,
>>
>> On 9/25/25 4:19 PM, Joey Gouly wrote:
>>> Hi all,
>>>
>>> This series is for adding support to running the kvm-unit-tests at EL2. These
>>> have been tested with Linux 6.17-rc6 KVM nested virt.
>>>
>>> This latest round I also tested using the run_tests.sh script with QEMU TCG,
>>> running at EL2.
>>>
>>> The goal is to later extend and add new tests for Nested Virtualisation,
>>> however they should also work with bare metal as well.
>>>
>>> Changes since v2[1]:
>>> 	- Move the sctlr setup in EFI to a function.
>>> 	- Decided to not re-use el2_setup.h from Linux, looked more
>>> 	  complicated to use than needed for KUT.
>>> 	- Add EL2 env variable for testing, open to feedback for that.
>>> 	  This was untested with kvmtool as my testing setup only has
>>> 	  busybox ash currently, and the run_tests.sh script needs bash.
>>>
>>> Issues (that I think are fine to investigate/fix later):
>>> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
>>> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.
>> Have you noticed any failure with migration tests. On my end, as soon as
>> I set EL2=1 migration tests do fail.
> Yes migration also fails here, forgot to mention that.
>
> Seems like migration completes, but then something bad happens on the first
> interrupt. I will investigate a bit now and see if it's an easy fix.

while you do that I will go through the series. My apologies for the delay

Eric
>
> Thanks,
> Joey
>
>> Eric
>>> Thanks,
>>> Joey
>>>
>>> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
>>>
>>> Alexandru Elisei (2):
>>>   arm64: micro-bench: use smc when at EL2
>>>   arm64: selftest: update test for running at EL2
>>>
>>> Joey Gouly (8):
>>>   arm64: drop to EL1 if booted at EL2
>>>   arm64: efi: initialise SCTLR_ELx fully
>>>   arm64: efi: initialise the EL
>>>   arm64: timer: use hypervisor timers when at EL2
>>>   arm64: micro-bench: fix timer IRQ
>>>   arm64: pmu: count EL2 cycles
>>>   arm64: run at EL2 if supported
>>>   arm64: add EL2 environment variable
>>>
>>>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>>>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>>>  arm/micro-bench.c          | 26 ++++++++++++++++--
>>>  arm/pmu.c                  | 13 ++++++---
>>>  arm/run                    |  7 +++++
>>>  arm/selftest.c             | 18 ++++++++----
>>>  arm/timer.c                | 10 +++++--
>>>  lib/acpi.h                 |  2 ++
>>>  lib/arm/asm/setup.h        |  8 ++++++
>>>  lib/arm/asm/timer.h        | 11 ++++++++
>>>  lib/arm/setup.c            |  4 +++
>>>  lib/arm/timer.c            | 19 +++++++++++--
>>>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>>>  lib/arm64/processor.c      | 12 ++++++++
>>>  14 files changed, 191 insertions(+), 19 deletions(-)
>>>

