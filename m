Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9452FCFC9
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752770562; cv=none; b=AwtLl2i6kttgAZQ4TpxO46MQEjCoMOkCh/+ALIl9K99FWikqzIYvlPJIdjtydBVRBzkUbJWGtKkMV4ED27/EfTHhPjlPd381ESIgKNd5OK5Fo8MSHBBvSI3/s50hNLd4hFzu1LXSXamOWI64BM3URzL8sLxII1YMJFgCK6xQJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752770562; c=relaxed/simple;
	bh=Zp+bqdk2AUV+SBqOdeWsNgo02TfpUX044tCk09JCCZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZKXLJ+b2twB3cCirvmrkjAl5yX6620VaT6HKRZ8xZYtHKaV0L6HnqLLRkPPolIL9muAFJ0ySwFGaIkIRDCy0b51hpd4TCjiSUazpNWPJByzmnWcxkzTGqCLRPMRfLSIX6hJpo/cfdR/YEz8dSNbllMrkSt24cr0nRcitObOevfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ttqkTl/L; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ttqkTl/L"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4560add6cd2so9994195e9.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752770559; x=1753375359; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0KIZvn3WMN/D9GaYJuL0YNSf8jbAXvNffTD/qUx3PrA=;
        b=ttqkTl/Lgx1LMxIj+2OKM5EmdCdr9vqxDFzO3NL9air4Eaxj+rZfkrybXdjo2Oyfim
         6JYKuzcsqV9hvXVg07HlltAsKoSDAhaK+R1MkfmP+SHAyeLWftG8K3jd0by9WHgVZPHT
         +UAzMQ5zKinI5zR+81lXBJQ44IydjPZ4a/hjkeFppN9yrSQbNhCzIHJNBIPyrm+He7qH
         wM+NsEm8V88jgQQeNuzTSl4KwsUEtWWkDdqUQR6nPb4O+ECi6z0fGimnU88Ze93rU6Ia
         8asCpajPW7AJ416aiypNgcCY1LK6vS/t+8ZXoKgc9OFN3qV1OLwvYQF08r0cv3sU2wPz
         g0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752770559; x=1753375359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0KIZvn3WMN/D9GaYJuL0YNSf8jbAXvNffTD/qUx3PrA=;
        b=DvSBtWWbCOFqhR2ApCUfWmDjnuvzbElagMESseqIuq3chT/DjQKcn1IHHTSOUutRII
         01H8XMDk/CQlKHTfNGcVWYmG3bGtLOtyIA6Rb/Eiy60PHD6tv3C28lIH0XO4lfLUhZ5Y
         3yvjmQ+Pbk0sqXe9NlPexPiUZWLHMpgYGA9TELQMkGZHNl0HMFWcmOtqR5oBpXGcdvqb
         e2L3N6eRgOC81IcvBuUtdDAkbXxvkHjYO1s9S8XXpMGVBcsjexTMz+cQBngzsVjZIBtd
         pQ3+74tysSWZDI+tcjCFus7P2J92O2M0hPo6S8nhSrlMl+OdKByyIW/sncOioInjr/f+
         tQ3A==
X-Forwarded-Encrypted: i=1; AJvYcCU5uNbQOrZHB9K7DkQaI6tS+Du3YBsnsnfmPRnSiowWiYSTP3W33lccUpwy0PixkbL1h6eGYc4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzlS2Q99tFWLAw5btuS+DF7vStwxSfIdi04Dr6NR+97Az6jhGH9
	fYeKaU+wNEBteFb2nkJigWkqSyPp5TGTlNt7TZNFZDIEejNzaxH9ZIIOGGPzvz5XXJU=
X-Gm-Gg: ASbGncu3f/xJKF6hX9YInsqoblNkbqrpaL9S8PsTinO0LVrheZPmepsAPHkwFXzfXqq
	ydgakDD3OMSTBhpaD7WQ7h5gXD6t8IqhDXQJV38PDg515EYNfJuC5eweBfXJQ7Z2kS+enBcEd87
	JYUonX/mmGJ0EiGrqQrIq7ipctZJrtEpEsI54N2Kdyr4HbDMl7D0wQfjU4T1R1MV+qxaSyRtttO
	FlljJuftSpecyQnfhIF7AziarNbtlvhMcXZOscO5h0yXidBkoAdPeq0sdITU+xaNEWyjaTzWIgx
	P6XE+buqWaLiXm7ZmO3cNzSw8G2ahpiX7SuRXpIhtM+q7eWDAmoz0btGp6JKtdYi65ZBa0+44iX
	O67IjFXjWho6RDMI3lVifOUWqOQ0=
X-Google-Smtp-Source: AGHT+IHw2GCF56hApJyEmdx/xTKHHH5iV9N7ia+pyQS/X4tv7tXWZh4hCv08eoEvqDhMJOVRwHk5hg==
X-Received: by 2002:a05:600c:3f12:b0:456:1ab0:d566 with SMTP id 5b1f17b1804b1-456348cbdb0mr41924525e9.16.1752770558925;
        Thu, 17 Jul 2025 09:42:38 -0700 (PDT)
Received: from [192.168.1.3] ([185.48.76.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45634f5dd61sm28041015e9.11.2025.07.17.09.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 09:42:38 -0700 (PDT)
Message-ID: <95468171-a09d-4b6b-a0bd-189d83ff33a6@linaro.org>
Date: Thu, 17 Jul 2025 17:42:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] perf: arm_spe: Add support for filtering on data
 source
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-7-71b0c9f98093@linaro.org>
 <aHUOig-kaRo15ZH5@willie-the-truck>
 <7f51d4f9-7e08-49b5-ab43-8bc765bb2ca8@linaro.org>
 <aHkI5_IOV35L4YJa@willie-the-truck>
 <ca99af3b-e358-4c2b-8d62-0b6c29984391@linaro.org>
 <aHkWTlaRKdXbnA0r@willie-the-truck>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <aHkWTlaRKdXbnA0r@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 17/07/2025 4:27 pm, Will Deacon wrote:
> On Thu, Jul 17, 2025 at 04:16:32PM +0100, James Clark wrote:
>>
>>
>> On 17/07/2025 3:29 pm, Will Deacon wrote:
>>> On Tue, Jul 15, 2025 at 02:04:18PM +0100, James Clark wrote:
>>>> On 14/07/2025 3:04 pm, Will Deacon wrote:
>>>>> On Thu, Jun 05, 2025 at 11:49:05AM +0100, James Clark wrote:
>>>>>> @@ -406,6 +416,9 @@ static u64 arm_spe_event_to_pmsfcr(struct perf_event *event)
>>>>>>     	if (ATTR_CFG_GET_FLD(attr, inv_event_filter))
>>>>>>     		reg |= PMSFCR_EL1_FnE;
>>>>>> +	if (ATTR_CFG_GET_FLD(attr, data_src_filter))
>>>>>> +		reg |= PMSFCR_EL1_FDS;
>>>>>
>>>>> Is the polarity correct here? The description of PMSDSFR_EL1.S<m> suggests
>>>>> that setting bits to 1 _excludes_ the FDS filtering.
>>>>>
>>>>
>>>> Setting filter bits to 1 means that samples matching are included. Setting
>>>> bits to 0 means that they are excluded. And PMSFCR_EL1.FDS enables filtering
>>>> as a whole, so if the user sets any filter bit to 1 we want to enable
>>>> filtering:
>>>>
>>>>     PMSDSFR_EL1.S<m>
>>>>
>>>>     0b0  If PMSFCR_EL1.FDS is 1, do not record load operations that have
>>>>          bits [5:0] of the Data Source packet set to <m>.
>>>>
>>>>     0b1  Load operations with Data Source <m> are unaffected by
>>>>          PMSFCR_EL1.FDS.
>>>>
>>>> I think it's all the right way around and it ends up being the same as the
>>>> other filters in SPE. Because we're using any bit being set to enable the
>>>> filtering, the only thing you can't do is enable filtering with a 0 filter,
>>>> but I didn't think that was useful. See the previous discussion on this
>>>> here:
>>>> https://lore.kernel.org/all/5752f039-51c1-4452-b5df-03ff06da7be3@linaro.org/
>>>>
>>>> Reading the "Data source filtering" section in the docs change at the end
>>>> might help too.
>>>
>>> Sorry, but I still don't get it :/
>>>
>>> afaict, if any of the bits in 'data_src_filter' are _zero_ then we
>>> should set PMSFCR_EL1.FDS. That also means that a mask of zero means all
>>> loads are filtered, which is what the architecture says and is what we
>>> should provide to userspace.
>>>
>>> Will
>>
>> We'd have to add another format flag to enable data source filtering then,
>> because otherwise the default would be zero and people's samples would
>> disappear.
>>
>> But the only use cases I could think of were more like "I want to see
>> samples from data source 1":
>>
>>    -e arm_spe/data_src_filter=0x1/
>>
>> Or "I want to see all data sources except 1":
>>
>>    -e arm_spe/data_src_filter=0xfffffffe/
>>
>> Filtering out all samples with any data source didn't seem to make sense to
>> me, and I think you can already do that with the other filters (remove loads
>> etc).
>>
>> It would be a shame to be inconsistent and to add an enable flag just for
>> that one case because the other filters in SPE are auto enabled for non-zero
>> values. Although to be fair for PMSFCR.FT and others, zero filters are
>> explicitly not allowed:
>>
>>    If this field is set to 1 and the PMSFCR_EL1.{ST, LD, B} bits are all
>>    set to zero, it is CONSTRAINED UNPREDICTABLE whether no samples are
>>    recorded or the PE behaves as if PMSFCR_EL1.FT is set to 0
>>
>> Seems like FDS doesn't end up as neat as the others, but IMO I can't see
>> anyone needing a zero filter. I did discuss it with Leo and we decided that
>> we could always add the enable flag at a later date if a use case turned up
>> and it wouldn't be a breaking change.
>>
>> But if you think it's there so it should be exposed I can add it.
> 
> What about if we expose the inverse of PMSDSFR_EL1 to userspace instead?
> 
> Will

That's exactly what I was thinking. It does seem a bit weird, but I can 
call it inv_data_src_filter and document it appropriately so it should 
be fine.

