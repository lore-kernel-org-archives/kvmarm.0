Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF01AA795
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 15:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747235334; cv=none; b=DPP1nPfIhXr9IJp9Ho40zxJl4h8MJX8R5YHJq8MgJNNlsO+bQiGXTUjaye5Xk+Cq8ISTgyalist8HqvAHR7a4cnn9xHdflfPvaK+I0kre1nHA4TB56gUlf+qoqoH75nDtgbX599Argd5PYEsFVC84y9oYP0vuJnABr33vKsMZC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747235334; c=relaxed/simple;
	bh=mAcmrBbkNFx5yQUC0RSTnNe26cuj+jPnQVvy9m0n6jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D9uku/T9Ino6X1HioLOItvlyZHG0Iro5Roh/lf6XCC5omG8bB26xLJ3sIDzLa8g84BMTr2hXj/5hro8tIZxvUfbjDbq44a/ZnmtPVV/53JSREs4NNSj2cbA/NOvoXApeyJ07RrPRBK/G69rh2t1aH+ZDW7uvRabulM4XeqdC7Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hhE+2URX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hhE+2URX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747235332;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbuRFuKD5JpjQw2f4iee9uAmZP1oYGiVJtTJHjTRBb4=;
	b=hhE+2URX5aWSAapZfuzdc54V5HFZevdTB/f8aSuLpCvzCnTs/LaTYTE6PnId2KGT1xrR77
	CNYNrtRQuqc70qUZVSB5VeBRLXNe37lbp6+eW7Qm3aGC+pJlNoEKSoyuw86sXph7T4rOIi
	MhRNmuYsLcqZQ8XikiU8w2H5rd4Q//A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-PQx_v8MYPLCSABoa0ZEPHQ-1; Wed, 14 May 2025 11:08:51 -0400
X-MC-Unique: PQx_v8MYPLCSABoa0ZEPHQ-1
X-Mimecast-MFC-AGG-ID: PQx_v8MYPLCSABoa0ZEPHQ_1747235330
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5fcd19e6305so4151271a12.2
        for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 08:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747235329; x=1747840129;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbuRFuKD5JpjQw2f4iee9uAmZP1oYGiVJtTJHjTRBb4=;
        b=LEl02Ayp+qVpQMpXLaFwL6nSotRcAy9toOW6E4rQOuGp718ZosNy2TjJogmJFwSUOT
         xpMtd1+8SojBPM3jddnScWcEAXSXKwuN7xk6y0YFaP5C5LV2xYLH+1pHYNxi8r8RYi4K
         iTmag4b72A8XDEp/oByvL+HD/eQql3JptL/iYW9Ao4dmwHyeFl9qfHL3WxsoOp01mikX
         +33xJCG8goA8pQaQ1WYKEDiLPqAKrkwUPg8f7/hKQbLbRlAo9+fF47YMyACBOFiqFHGD
         bucK683KYytJa+8exTiZ+iraVDxfq44vuQky4511610RTGboeBcyBXDaZsNBXdflnoQi
         KwKg==
X-Forwarded-Encrypted: i=1; AJvYcCWt/oj2Kt6KHHl7FTMODfJd2stzYc+xbBXwGCs6Mzm/97qxGFeFkKnopQSuafMUoq0Sgw2Cmd4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxT/9mdf02/koHEecL3mPJHaQCg69L6YqhJkAewzb+PbC7h1GDG
	8xWylYUrV7qGhtOycBcmPIhFJk5kMMDqU9G+WfLIXy5j1+7dLo0xCLhd9Xb2dDqN2HEUvAOq+Mg
	2UFxvfHdfmUykiVmb8ZcMk063w7O36T+PdYyp59LTMB39+ucVWLTzilrFxm9/jQ==
X-Gm-Gg: ASbGncuSMnk5vEnizgizF2cRS97YICLLZwit+opKU1TzCARgq6HFpcY7kvEyh7O5btP
	5QHl+WQemSSksV0ciwSB6bkzz022eq6uyRS49ZUkXFXe2lFPEYolCnsXhoezwCVIMKkc/s86UDv
	+vWEvZwVof6Ihk/Wg/5YXX/I7e//SR+YDQYOtPBZZ2tgSWuNE9nb3j36CmsvC0jyXL1F9beG+NK
	n15Nvfuu8TkM/LOuBJJdrM1UYUkBhoK0Ko5rn3Jyp2/iXXVxeNqjtyNxJF5ejW0jybBw10ZY4YD
	jF5YHbfgwmIWYYJw+fpD5AztEH6B6LoEF6Y2HGQJ5UEUe/uLmPJelAqcwvo=
X-Received: by 2002:a05:6402:5cd:b0:5fa:a369:7fc0 with SMTP id 4fb4d7f45d1cf-5ff988b0968mr2688474a12.18.1747235329442;
        Wed, 14 May 2025 08:08:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWuSv9/zfPHqoWNNm06AVsXh/VAzx0R1BskaTdoOty31H22/F/jMydZXd2oUtfyetk6jO3jg==
X-Received: by 2002:a05:600c:3b02:b0:441:b00d:e9d1 with SMTP id 5b1f17b1804b1-442f20baee4mr34112625e9.2.1747234896892;
        Wed, 14 May 2025 08:01:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f337db30sm33725535e9.11.2025.05.14.08.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 08:01:36 -0700 (PDT)
Message-ID: <3f1c89a5-5887-4761-84a1-366dd9ef7fc2@redhat.com>
Date: Wed, 14 May 2025 17:01:35 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v6 12/14] arm/cpu: Add sysreg generation scripts
To: Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, sebott@redhat.com,
 shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 abologna@redhat.com, jdenemar@redhat.com, agraf@csgraf.de,
 shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-13-cohuck@redhat.com> <aCNwKBDtJES0GX3q@redhat.com>
 <87ecwrckfc.fsf@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <87ecwrckfc.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S-5sa6lPJSNq-OWTPXSaosib-pkKU2FxSJ5EewFc99M_1747235330
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Connie,

On 5/14/25 4:54 PM, Cornelia Huck wrote:
> On Tue, May 13 2025, Daniel P. Berrangé <berrange@redhat.com> wrote:
>
>> On Tue, May 06, 2025 at 10:52:32AM +0200, Cornelia Huck wrote:
>>> From: Eric Auger <eric.auger@redhat.com>
>>>
>>> Introduce scripts that automate the generation of system register
>>> definitions from a given linux source tree arch/arm64/tools/sysreg.
>>>
>>> Invocation of
>>> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
>>> in scripts directory generates target/arm/cpu-sysregs.h.inc
>>> containing defines for all system registers.
>>>
>>> [CH: update to handle current kernel sysregs structure, and to emit
>>>      the re-worked register structures; cpu properties will be added
>>>      later]
>>> Reviewed-by: Sebastian Ott <sebott@redhat.com>
>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  scripts/gen-cpu-sysregs-header.awk    | 35 +++++++++++++++++++++++++++
>>>  scripts/update-aarch64-sysreg-code.sh | 25 +++++++++++++++++++
>>>  2 files changed, 60 insertions(+)
>>>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
>>>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
>>>
>>> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
>>> new file mode 100755
>>> index 000000000000..b6b207e3c0fd
>>> --- /dev/null
>>> +++ b/scripts/gen-cpu-sysregs-header.awk
>>> @@ -0,0 +1,35 @@
>>> +#!/bin/awk -f
>>> +# SPDX-License-Identifier: GPL-2.0
>> Invalid license name here - hopefully checkpatch.pl is warning
>> about this.
> It might not check .awk scripts?
>
>> Same issue as in the other sysreg script in the host CPU model
>> series.
>>
>>
>>> diff --git a/scripts/update-aarch64-sysreg-code.sh b/scripts/update-aarch64-sysreg-code.sh
>>> new file mode 100755
>>> index 000000000000..721f41a9a516
>>> --- /dev/null
>>> +++ b/scripts/update-aarch64-sysreg-code.sh
>>> @@ -0,0 +1,25 @@
>>> +#!/bin/sh -e
>>> +#
>>> +# Update target/arm/cpu-sysregs.h
>>> +# from a linux source tree (arch/arm64/tools/sysreg)
>>> +#
>>> +# Copyright Red Hat, Inc. 2024
>>> +#
>>> +# Authors:
>>> +#          Eric Auger <eric.auger@redhat.com>
>> Although its fairly short, this still deserves SPDX-License-Identifier
>> to be set.
> @Eric: do you agree on "GPL-2.0-or-later"?

Yes I agree

Eric
>

