Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36611707
	for <kvmarm@lists.linux.dev>; Thu, 30 Nov 2023 03:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XsxvFMLk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701314315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u+iSpIxtCVTh9BXoYftq0bmE/10+Op2Y3rwSgLPtBkY=;
	b=XsxvFMLkfRFDwwlFDf6R1q13KPZb+E1OmEhddtUAmtUtV7+Nc7rjtnyiIm6SMnzbTVW6p8
	ezlaiySe1PauWxZNHcVDsr8qH5ZpvHqG9m75uphX6ynHtKN9TqdzvlY7bDd/6ggNuAEGd/
	DrwBlxJ2wFUGZfjZeV3FSIEKzBFyZqs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-PrbPvTuMPkWZk6nKf7DCgw-1; Wed, 29 Nov 2023 22:18:34 -0500
X-MC-Unique: PrbPvTuMPkWZk6nKf7DCgw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1cfbeee2265so1304965ad.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Nov 2023 19:18:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701314313; x=1701919113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+iSpIxtCVTh9BXoYftq0bmE/10+Op2Y3rwSgLPtBkY=;
        b=HutrFPRJ99qia7VyiiBJH1A31tI7VlzjylxaCzNWqasx5trGZlfwvuRJ1M1cW7h6Pl
         9S8wBa4Gb0rljyWFdUSZdRFYu5GQJyOKHs33nS6EJMSRWoXP3WsJSdafylFbqcK9CeNw
         qWXMiFJ7F06PX5uql0z+GAu48YgXXLOdl1kInGFJuJXjSPymF8gCX18Kt6D1My/xtpjw
         Ds2bVGD+SxQVPj+5NbLSlag3+rGIIcB8cblxnXJcOtKqS4PzMLz+v8Bc6adwddSn/Fu9
         qMlG7Qz8XGdvZ5Jv0N/b7dp1WUkUEZpWweZZMBJLceIgoaJA0WJkWW7A6zla/WqSMEtS
         fYiw==
X-Gm-Message-State: AOJu0YxgEQ0u6Fpg8LUBN4M9mYBQl6T7d+eeKcrjqh3msdRheG766Fso
	lUOo05uvbf/grDRnyRHhBT+ru/0Q5zXy7uk1C4qkbkODcdFpRh7DRfyFYox5+aa+MLmxbaby+J0
	6SH1Fn/dVFh8FT/Hz
X-Received: by 2002:a17:902:f683:b0:1cf:c680:f37f with SMTP id l3-20020a170902f68300b001cfc680f37fmr14239947plg.2.1701314313437;
        Wed, 29 Nov 2023 19:18:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm1n8ELJdp4RfPk7lYND0rjP6RFv0rZ+fw84nRZl7Y4mDKazCvnKOkvSgAXTtmo4jZAZfpqg==
X-Received: by 2002:a17:902:f683:b0:1cf:c680:f37f with SMTP id l3-20020a170902f68300b001cfc680f37fmr14239928plg.2.1701314313097;
        Wed, 29 Nov 2023 19:18:33 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i18-20020a17090332d200b001cfb971edf3sm126724plr.8.2023.11.29.19.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Nov 2023 19:18:32 -0800 (PST)
Message-ID: <75fd59f0-c47d-ae26-61b2-e6d800c33e90@redhat.com>
Date: Thu, 30 Nov 2023 11:18:29 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests PATCH v1 3/3] arm64: efi: Make running tests on
 EFI can be parallel
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Nikos Nikoleris
 <nikos.nikoleris@arm.com>, Ricardo Koller <ricarkol@google.com>,
 kvm@vger.kernel.org
References: <20231129032123.2658343-1-shahuang@redhat.com>
 <20231129032123.2658343-4-shahuang@redhat.com>
 <20231129-7fbc43944dc62a55cffe131c@orel>
 <a574e4b6-4c1b-d939-e61c-6a97a245341e@redhat.com>
 <20231129-cbddf8063ae5af7a37aa2e4a@orel>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20231129-cbddf8063ae5af7a37aa2e4a@orel>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi drew,

On 11/29/23 19:43, Andrew Jones wrote:
> On Wed, Nov 29, 2023 at 06:14:20PM +0800, Shaoqin Huang wrote:
>> Hi drew,
>>
>> On 11/29/23 17:27, Andrew Jones wrote:
>>> On Tue, Nov 28, 2023 at 10:21:23PM -0500, Shaoqin Huang wrote:
>>>> Currently running tests on EFI in parallel can cause part of tests to
>>>> fail, this is because arm/efi/run script use the EFI_CASE to create the
>>>> subdir under the efi-tests, and the EFI_CASE is the filename of the
>>>> test, when running tests in parallel, the multiple tests exist in the
>>>> same filename will execute at the same time, which will use the same
>>>> directory and write the test specific things into it, this cause
>>>> chaotic and make some tests fail.
>>>
>>> How do they fail? iiuc, we're switching from having one of each unique
>>> binary on the efi partition to multiple redundant binaries, since we
>>> copy the binary for each test, even when it's the same as for other
>>> tests. It seems like we should be able to keep single unique binaries
>>> and resolve the parallel execution failure by just checking for existence
>>> of the binaries or only creating test-specific data directories or
>>> something.
>>>
>>
>> The problem comes from the arm/efi/run script, as you can see. If we
>> parallel running multiple tests on efi, for example, running the pmu-sw-incr
>> and pmu-chained-counters and other pmu tests at the same time, the EFI_CASE
>> will be pmu. So they will write their $cmd_args to the
>> $EFI/TEST/pmu/startup.nsh at the same time, which will corrupt the
>> startup.nsh file.
>>
>> cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>> echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>> ...
>> echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_TEST/$EFI_CASE/startup.nsh"
>>
>> And I can get the log which outputs:
>>
>> * pmu-sw-incr.log:
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-acce'
>> * pmu-chained-counters.log
>>    - ABORT: pmu: Unknown sub-test 'pmu-mem-access-reliab'
>>
>> And the efi-tests/pmu/startup.nsh:
>>
>> @echo -off
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-mem-access-reliability
>> setvar fdtfile -guid 97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823 -rt =L"dtb"
>> pmu.efi pmu-chained-sw-incr
>>
>>
>> Thus when running parallel, some of them will fail. So I create different
>> sub-dir in the efi-tests for each small test.
> 
> Ok, I was guessing it was something like that. Maybe we should create a
> "bin" type of named directory for all the binaries and then create a
> separate subdir for each test and its startup.nsh, rather than copying
> the binaries multiple times.
> 

I can put this kind of improvement into another patch. Currently I want 
to use the safety way to fix this problem, create different directory 
and copy the .efi for each of them will not cause any interfere for each 
of the test. We can tolerate the redundant, it doesn't cost many space.

Thanks,
Shaoqin

>>>>    : "${EFI_CASE:=$(basename $1 .efi)}"
>>>>    : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>>>> @@ -56,20 +58,20 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
>>>>    	EFI_CASE=dummy
>>>>    fi
>>>> -: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
>>>> +: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
>>>>    mkdir -p "$EFI_CASE_DIR"
>>>> -cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
>>>> -echo "@echo -off" > "$EFI_TEST/$EFI_CASE/startup.nsh"
>>>> +cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>>>> +echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
>>>
>>> Unrelated change, should be a separate patch.
>>>
>>
>> Ok, Will separate it.
> 
> Actually, disregard my comment. I was too hasty here and thought the
> '@echo -off' was getting added, but now I see only the path was getting
> updated. It's correct to make this change here in this patch.
> 
> Thanks,
> drew
> 

-- 
Shaoqin

