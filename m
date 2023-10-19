Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B827E15AE9
	for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 08:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVnIdb2b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697705024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sNhtEDb46cdwd0UeanpUYMMLzJiY9Fo2EaQX8hX2fF8=;
	b=KVnIdb2b5/LP4omM8EDUZLjF3xbef5UaEpJzaSibiEyINKlNu4lxC0dQmpSUhOI/eRprOc
	nvcLOoq5DGiFca7zl9IZkcLDYM/1C0+6UAEEsMKW1Sbfe52xRzlXPow0TUGbhZY3SsJVpO
	3rwLsEIGIOa2YwvbtJPNJtrQJIVH+QA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-6u5ocuXMPhy_LydcVWn2sw-1; Thu, 19 Oct 2023 04:43:40 -0400
X-MC-Unique: 6u5ocuXMPhy_LydcVWn2sw-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-66d35dda745so60844746d6.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Oct 2023 01:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697705020; x=1698309820;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sNhtEDb46cdwd0UeanpUYMMLzJiY9Fo2EaQX8hX2fF8=;
        b=VEJEfdYIiUKWmsAHj0AAlKfxtu/PsMltdTDwMaD93nCgA0YjG8R5KKR485rUpit1sx
         HG08K+czaW9n4sDZ3lANJJynZD+jXAnOAdpmK3NriwtnpFIn3cpyq2Th7UTpP5mMhX5X
         ycUD5UrxbYFDa9beBu1usQBmeQP9nmiWK/xRr1ebTRh5pa6P7kGkTNy6HeSmcj9hThZa
         XJm0JDbvZgILY1h0Bydgqq8qbRkfDQ3ztayR6r+tF5pKWl4u/z2mInW7/W3EFFZTYIha
         BVbG/azoeHtRuwuvoLOUIRmpcKyWHL2w+x7TpJMesf65wQOlGIsmHPgykTCBwh3mGRih
         PxSw==
X-Gm-Message-State: AOJu0YyLVcMdmLuy8nqOmFE0hX5K0gDuVitW4ZGoCJ2iJs8GtiVvhLpM
	8PuaIihHct2XyQI6iT/tmNEPvP8htbnFOsaqTzdX/DQZ1P9GfPI4BCM0VSu9wAfMuTzPSg86Yt8
	YeKNR0zu4J8wuvWeQ
X-Received: by 2002:ad4:5fcd:0:b0:66c:ffe1:e244 with SMTP id jq13-20020ad45fcd000000b0066cffe1e244mr2186135qvb.62.1697705020213;
        Thu, 19 Oct 2023 01:43:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETbfgv/8+88fGni1xgnaMxsBgnNEdj2B+ZY0ZeQEa62JYNYio5HxIOk7eFGTP20cQ6OiiUgQ==
X-Received: by 2002:ad4:5fcd:0:b0:66c:ffe1:e244 with SMTP id jq13-20020ad45fcd000000b0066cffe1e244mr2186118qvb.62.1697705019902;
        Thu, 19 Oct 2023 01:43:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t6-20020a056214118600b0066d11c1f578sm625981qvv.97.2023.10.19.01.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 01:43:39 -0700 (PDT)
Message-ID: <48d09c9f-78d9-e5eb-d85a-e75a6df81396@redhat.com>
Date: Thu, 19 Oct 2023 10:43:34 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/5] tools headers arm64: Update sysreg.h with kernel
 sources
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-perf-users@vger.kernel.org, Jing Zhang <jingzhangos@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Ian Rogers <irogers@google.com>,
 Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-5-oliver.upton@linux.dev>
 <73b94274-4561-1edd-6b1e-8c6245133af2@redhat.com>
 <3c5332b0-9035-4cb8-96ce-7a9b8d513c3a@sirena.org.uk>
 <8baca35a-9154-97e6-d682-032fc69d2da6@redhat.com>
 <ZTBzAR1KsWuurob7@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZTBzAR1KsWuurob7@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 10/19/23 02:06, Oliver Upton wrote:
> Hi Eric,
> 
> Thanks for reviewing the series.
> 
> On Wed, Oct 18, 2023 at 03:06:12PM +0200, Eric Auger wrote:
>> Hi Mark, Oliver,
>>
>> On 10/18/23 14:16, Mark Brown wrote:
>>> On Wed, Oct 18, 2023 at 01:57:31PM +0200, Eric Auger wrote:
>>>> On 10/11/23 21:57, Oliver Upton wrote:
>>>
>>>>>  #define set_pstate_pan(x)		asm volatile(SET_PSTATE_PAN(x))
>>>>>  #define set_pstate_uao(x)		asm volatile(SET_PSTATE_UAO(x))
>>>>>  #define set_pstate_ssbs(x)		asm volatile(SET_PSTATE_SSBS(x))
>>>>> +#define set_pstate_dit(x)		asm volatile(SET_PSTATE_DIT(x))
>>>
>>>> could you comment on the *DIT* addictions, what is it for?
>>>
>>> DIT is data independent timing, this tells the processor to ensure that
>>> instructions take a constant time regardless of the data they are
>>> handling.
>>
>>>
>>> Note that this file is just a copy of arch/arm64/include/asm/gpr-num.h,
>>> the main purpose here is to sync with the original.
>>
>> Ah thanks. that's helpful for me to understand where this gpr-num.h
>> comes from. This could be documented in the commit msg though.
>>
>> Something like:
>>
>> adding tools/arch/arm64/include/asm/gpr-num.h matching linux
>> arch/arm64/include/asm/gpr-num.h
>>
>> and syncing tools/arch/arm64/include/asm/sysreg.h with the fellow header
>> in the linux tree.
> 
> Yeah, I could've spelled it out a bit more. I already cracked this off
> of an even larger patch from before I picked up the series because the
> diff was massive.
> 
>> tbh I did not initially understand that all this diffstat was aimed to
>> match the linux arch/arm64/include/asm/sysreg.h. Now diffing both I have
>> some diffs. Doesn't it need a refresh?
> 
> I'm worried it is a fool's errand at this point to keep the two in sync,
> as I'm sure there will be more in -rc1. The tools copy of sysreg.h isn't
> a verbatim copy either, there are some deliberate deletions in there as
> well.
> 
> I've taken this as is, we can always come back and update the headers
> afterwards if we find a need for it

OK np. I did not notice you picked the series up and I jumped in too
late. Anyway that was worthwhile for my education ;-)

Eric
> 

