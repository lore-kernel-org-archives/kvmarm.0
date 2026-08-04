Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0832541E6DA
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 21:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785878730; cv=none; b=YCbmUlTJjpayMSFAkLoprFPdtSfV9x2f/t9ovt28sxQTMpkyjfF1dQ1S40E5dLv/4m+ImGWfUBNn6a1ZCgnZyQ2ngC/XsbutKZakySI3kfOyfbmqPPm4UoBAQ6vSeRlwFtPlhT+r37CYOBDNKD1o3QurCKeVf6OpK7gTPelC95w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785878730; c=relaxed/simple;
	bh=huPoN5bucRUnQLu5sCfSPLzeR3X2OREye170NNUzpZQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=o1aBbrvNBvV9nbFkzF/3VU2nMdji6NqJT4FLpylkj0vV0IyTUFMCBdIhU4kISGBUS5J5HeuSlccyLQYhRLxY6O5vDo00C0fbw6Zro+5WFf+YnLjNldLfuFW+ScRrbCw/jhWU0nt8lmI4P6wqwh1WFtWFJRiBY2RCdcF92+Dr3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a22T/zG6; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a22T/zG6"
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4ab8b646492so402580b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Aug 2026 14:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785878728; x=1786483528; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OoNJERa7N+ihiUvZZhE29iP6C+dCF84EVkVoe6Oj4kU=;
        b=a22T/zG6lYM2exui2AHV4vfsmZ42/Qb4dvNvDeR2UbZhf0GdiotyvZVQpb74g8fQhC
         9c4HXX78tUW9cXgAw/u5WVTxVWtlU234nNPSM9ewEzQFKsP6tDX/q7g1E67swql+Nnhw
         gUtIn9gBNcYKHFIb0JJLUq3+XHW+f9pMJYbXOiIn1dNLQf83Yw40x3scEI6pw260Ww/F
         IaCuRB0F/ET/IH0m630FyXm1Ru88yvt5keu4H8xqRP8CuzhBgvsB8QeJwAVbKX93bZEz
         F20/bqtAVsvFtz2XK29lgEk8nmhvQspGvny9jN9iGqpIlAUg6zvlIy03M540LFntT7ts
         zwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785878728; x=1786483528;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OoNJERa7N+ihiUvZZhE29iP6C+dCF84EVkVoe6Oj4kU=;
        b=Me+EmQ0PCzGtBY6pb7xvSB5wWPCHDCV9j7dGj4czUHEb7KWPo/M6a80tTJxSmyOvg+
         G9LrfRpITNQow8AtXWIujyGDGdTNikiQ7hJvZlf7EgzQx3iXZRpxpTSqRxaMbH3Kp6rL
         kS1uX5lilzqmTOGF7DyKejvt4ltiPwssq39sYSt96ozPfTRoltVvoP+LWG5w83oOAgXx
         iDGzVQaV9akitI+JXsVcaaawjFSKcmS8wPa5Otkdm/lB1EyAE6r2cIWid10xL3pVE86J
         1AlIMh14ULIFnOmigmKk4gQGBYHwsggVnEv98NSxdnwkVg8mIPus4qVXxqGJ5pCMQNv2
         yNnQ==
X-Forwarded-Encrypted: i=1; AHgh+RpttykgFYFD93zuP36NfX9GZWH297V/Km3G5pqjKn2+b7u0FXMlUdc1ghvkAZ1YNclp3DY/Dds=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4E0nVRGcrGq6vNYAQ8IomChDthcSdjZJFLkeqQL8hLCOv4gdN
	2G1GrWlsmGV+wIZpLLpIryIE3Qr7fnFa7i37hOShurzCR713g01gIs3jyl/GUaeDoFcND/AvIcE
	K3GqIZ9L59n/1zR2NFogeftFyEw==
X-Received: from iobmp17-n2.prod.google.com ([2002:a05:6602:a2d1:20b0:9ab:7c1:c30a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3986:b0:495:f85b:d08f with SMTP id 5614622812f47-4afadfd7dc5mr1041308b6e.18.1785878727621;
 Tue, 04 Aug 2026 14:25:27 -0700 (PDT)
Date: Tue, 04 Aug 2026 21:25:27 +0000
In-Reply-To: <b8b1fbe4-fb73-418a-b43d-086894d31ce8@arm.com> (message from
 Robin Murphy on Tue, 28 Jul 2026 16:07:44 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntpkzxvarc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 05/21] perf: arm_pmuv3: Check cntr_mask before using pmccntr
From: Colton Lewis <coltonlewis@google.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	james.clark@linaro.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Robin, thanks for the review

Robin Murphy <robin.murphy@arm.com> writes:

> On 12/06/2026 8:28 pm, Colton Lewis wrote:
>> Check cntr_mask before using pmccntr to ensure it's available. With a
>> partitioned PMU, there may be instances where pmccntr is being used by
>> the guest and will be absent from cntr_mask.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>    drivers/perf/arm_pmuv3.c | 3 ++-
>>    1 file changed, 2 insertions(+), 1 deletion(-)

>> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
>> index 1cceb1f614515..17bb1cfdc271c 100644
>> --- a/drivers/perf/arm_pmuv3.c
>> +++ b/drivers/perf/arm_pmuv3.c
>> @@ -1028,7 +1028,8 @@ static int armv8pmu_get_event_idx(struct  
>> pmu_hw_events *cpuc,

>>    	/* Always prefer to place a cycle counter into the cycle counter. */
>>    	if (armv8pmu_can_use_pmccntr(cpuc, event)) {

> Something smells wrong here - we can use PMCCNTR but we can't?

>> -		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>> +		if (test_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask) &&

> ...i.e. this test would seem to belong in the helper function.
>> +		    !test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
>>    			return ARMV8_PMU_CYCLE_IDX;
>>    		else if (armv8pmu_event_is_64bit(event) &&
>>    			   armv8pmu_event_want_user_access(event) &&

> Plus it also doesn't make much sense to fall through to the "we _could_
> accommodate this event if only PMCCNTR was free" case here if we know
> PMCCNTR can never be free because it's not even available.

I agree it would be a good idea to refactor these if statements.

Probably something like:

/* tests moved to `armv8pmu_can_use_pmccntr` */
if (armv8pmu_can_use_pmccntr()) {
	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->used_mask);
         return ARMV8_PMU_CYCLE_IDX;
}

if (armv8pmu_event_is_64bit(event) &&
     armv8pmu_event_want_user_access(event) &&
     !armv8pmu_has_long_event(cpu_pmu))
	return -EAGAIN;
