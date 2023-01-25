Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E891381
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 07:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674633356;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O27zZx2fjGXVLntPmy1wi4nf/LLllnmjmtwtEs3YlHs=;
	b=JnLAoHIf7RlSpIElwFwD8HjwA6VOK/KQ4vt/idtcMVfiNnGmGiD6cFXztysiN9fXVcTNDZ
	aU0f7JBZj1dYQoW8iklNAGiFIOGdyl7588ea4NkPIGezJlVwygocrW1tW6zl8FCfxwVTfq
	GOSTnb869rzKNwhKEq4AnpTTd9zbevg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-540-FDHuoO2WO7OxMzATWqvqJQ-1; Wed, 25 Jan 2023 02:55:55 -0500
X-MC-Unique: FDHuoO2WO7OxMzATWqvqJQ-1
Received: by mail-qv1-f70.google.com with SMTP id mi16-20020a056214559000b005346c5c1f81so8875174qvb.15
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 23:55:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O27zZx2fjGXVLntPmy1wi4nf/LLllnmjmtwtEs3YlHs=;
        b=VZVHM6U8oDv5L4uF36C8BHlMH1X/ZNGfIWmrZlot7k7PbshWoaa3fOlHUaFSdZ6wqn
         0YyYSxCGfXAJrWSC/FdEGvr3qI5lTsgUBsZagWsnglJSVRswmnbwWBWprtTzXW2Qb0VE
         ZCPcZMzBG+iWk7xPgvJcAxAC6y2WGgMtqln3R5V1bqbilx+6Wi9NwPqwD4+hKMo/g4yL
         CqzA8XDqTN1OEkigy4K3IJW8vr7dVKi5wHCGfepV/scunBs3uzXuqADnH78u/Tz3MnDr
         Z0MYgjVkUeyg8UVSzhOxm+AyykNjz9z/rJ05gtiSjmVQspfe+WIBjCbPMubysAyT79Nk
         8U7w==
X-Gm-Message-State: AFqh2kq4SXtdm8S+fbAr2LR7uNkTaMP8nYmBiXfyRtfvyWDYKJf39i58
	FotkYTDCiwiQK8GP9JIl5DSiLejSEBVzG54GvJTULJ33jU5PemD9mUFm846l/mfbRxNh4esVtgo
	7SYzEZEDQLVE1CMN2
X-Received: by 2002:a05:622a:1a08:b0:3b6:340b:fb29 with SMTP id f8-20020a05622a1a0800b003b6340bfb29mr61433311qtb.15.1674633354473;
        Tue, 24 Jan 2023 23:55:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsDVwkxMfe/xtSrhm+NVGpcvVkFVI2tHJ6Kil61r+JE9vARpW1B0Sdxlz2Zbz7Fgdm0B+8Slg==
X-Received: by 2002:a05:622a:1a08:b0:3b6:340b:fb29 with SMTP id f8-20020a05622a1a0800b003b6340bfb29mr61433289qtb.15.1674633354226;
        Tue, 24 Jan 2023 23:55:54 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id m15-20020aed27cf000000b003afbf704c7csm2865980qtg.24.2023.01.24.23.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:55:53 -0800 (PST)
Message-ID: <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>
Date: Wed, 25 Jan 2023 08:55:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
To: Reiji Watanabe <reijiw@google.com>, Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
 maz@kernel.org, alexandru.elisei@arm.com, oliver.upton@linux.dev
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
 <Y9CRxb2YvPtX340D@google.com>
 <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 1/25/23 05:11, Reiji Watanabe wrote:
> On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
>> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
>>> Hi Ricardo,
>>>
>>> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
>>>> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
>>>>
>>>>         pmu_reset_stats();
>>> This isn't directly related to the patch.
>>> But, as bits of pmovsclr_el0 are already set (although interrupts
>>> are disabled), I would think it's good to clear pmovsclr_el0 here.
>>>
>>> Thank you,
>>> Reiji
>>>
>> There's no need in this case as there's this immediately before the
>> pmu_reset_stats();
>>
>>         report(expect_interrupts(0), "no overflow interrupt after counting");
>>
>> so pmovsclr_el0 should be clear.
> In my understanding, it means that no overflow *interrupt* was reported,
> as the interrupt is not enabled yet (pmintenset_el1 is not set).
> But, (as far as I checked the test case,) the both counters should be
> overflowing here. So, pmovsclr_el0 must be 0x3.

I would tend to agree with Reiji.  The PMOVSSET_EL0<idx> will impact the
next test according to aarch64/debug/pmu/AArch64.CheckForPMUOverflow and
I think the overflow reg should be reset.

Eric
>
> Or am I misunderstanding something?
>
> Thank you,
> Reiji
>
>
>>>> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
>>>> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
>>>> +       write_regn_el0(pmevcntr, 0, pre_overflow);
>>>> +       write_regn_el0(pmevcntr, 1, pre_overflow);
>>>>         write_sysreg(ALL_SET, pmintenset_el1);
>>>>         isb();
>>>>

