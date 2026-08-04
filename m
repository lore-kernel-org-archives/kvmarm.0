Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88FD3EC811
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 21:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785877589; cv=none; b=LR8pplzx3Atq+OScnMlOnMR4YvsqQ80H6tlMoeiyiaJfxLIwRA0EVqFF82x5jqmvEGrVG6Bbfi16worRcUJjuPcCBdKNedYiiVUdcxIvvmuFkHNyEzKBIiHGlsVEJRnOqxsWHhFSaW0qN1dkLUfoCupzRG4DAyDXpMTu9k++MG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785877589; c=relaxed/simple;
	bh=pfxpbIeNFSc0ZoYnjnPfD4XHfZ+dclFczBOLL7vzNQ4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dqDWUvb8lNMNe7uvvF7eGuAru3eoRLrwjXYsmgvP8R1At0ZQ9zynxNBqPZaXa28CbKlnHih9U0BxIKr03Gk1RFbhLq8LfI/0Wci+MZ3PBUQstdohY6wPgXeOzbjHZxvSf3SqrEbhMMjuuLNQo3WPZVe4eymvdxfW6c5/teBqNMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZMRUlIQv; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZMRUlIQv"
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a485034d01so330739b6e.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Aug 2026 14:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785877587; x=1786482387; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i5gQ2rzJspE7/RJU8+W1PyPQZBbheaHsGbRmii6HKrA=;
        b=ZMRUlIQvqmxQhUulg91eaStR0DsxcOgKismoDMO3XR2gXYjrR6alCFTwEnkMQ3h2hY
         m5o+/L/mRq9JmKZRGAjd+9ghcwgZV7z5hxcHP465PM+jaFz1wVWyM8Fe/hIcGA1FUu4o
         x88QAPnBnxH78KW3WRwdxExv6ENX2bfXq3CpWVGhDexOAvyoq+3ye4vTTULlTjhgDvom
         QdYjRBwIV0pHOMh9mlNjqZ2uNbsPAtUVWWAchhSJ6tOV5fk4G3yycK3qwMMGdnrORw/C
         uZ+28obEAsWwmb5hWEMkY93re9smZvc4hjM+mNHtdIL8ni/dXtpWdicRgq1X8CElt9MM
         cK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785877587; x=1786482387;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i5gQ2rzJspE7/RJU8+W1PyPQZBbheaHsGbRmii6HKrA=;
        b=BSjFz7t+cu94VMHg56vIF4oMEZ4h/ipJylCFAIlzZECHXaHDAI9WB69gCK0wenyZ9i
         Z7qpsLs9iB4YdgsuhtDw6xp9BnI1xonPI300V2OWt9BTkX6Qxy2ss5t/07MPb8vdDns4
         ZfaaMOrGCdi7e9vbUPhegaobi79mI1Wc+BhjdIODmEPbIxXvh/aejWZXe9j3OW2zAy9X
         r6eOsg548soTyvCPR4mmVwy3NutfbOEqF+GJSuiM0Yr2Xh7EpTcob5NGbEdBQ+fAsBKy
         AfYg1pkTzDOBNeBQdpmHFAgYjA6it5OX+l+PmqFtWXILqSU1KxT5y6b2xJbw+PycE0+c
         n52Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr0bTTqkdgAwdxYEqfPfFSQeZfsjZw8hENc3uyylPT8O6N+0gOxpogqTZhRQUODzJgfrvpUot0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaXKYpy1HO6/omwE1Up79Qp3PVVWuLMluwtOQ6JN0TsAhqDJ4l
	pJV4Lgo2w9DZQd8/JhwA1QUb9m1vqPEiRyB7U3N1IEaWREea5/TXSVlSuMVB2bH1SqbroOJ3P+V
	kMkwNVkXfl2akIskk443+acNl1w==
X-Received: from ilhw4.prod.google.com ([2002:a92:ad04:0:b0:507:c444:90fb])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1587:b0:487:61da:70fb with SMTP id 5614622812f47-4afae0c7caamr886481b6e.10.1785877586456;
 Tue, 04 Aug 2026 14:06:26 -0700 (PDT)
Date: Tue, 04 Aug 2026 21:06:25 +0000
In-Reply-To: <2941da1a-b0b4-47a6-b57c-b28703dc0454@linaro.org> (message from
 James Clark on Mon, 27 Jul 2026 12:04:17 +0100)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntse4tvbn2.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v8 00/21] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: James Clark <james.clark@linaro.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

James Clark <james.clark@linaro.org> writes:

> On 23/07/2026 9:57 pm, Colton Lewis wrote:
>> James Clark <james.clark@linaro.org> writes:
>>>>> When running the guest on a single CPU I get different counts for the
>>>>> same event for a single process, although this never happens on a  
>>>>> host.
>>>>> I think there might even be some Perf tests which expect them to be  
>>>>> the
>>>>> same, and this doesn't depend on whether any events are running on the
>>>>> host or not. Not sure if you ran all the Perf selftests in a guest or
>>>>> not?

>>>> I'll investigate but I'm not sure perf is intended to guarantee
>>>> that. perf stat just runs the event counters but may not write or read
>>>> them at exactly the same time.


>>> Is that true? The perf core calls perf_pmu_disable() when a process is
>>> scheduled out before reading the count of each event of that process in
>>> an inner loop. The perf_pmu_disable() clears PMCR_EL0.E which freezes
>>> all of the counters so they can be read out in a consistent state.

>>> It's important that they're all stopped at the same time because
>>> counters might be used in metrics as ratios of each other. So I think
>>> it's deliberately designed that way and appears to not be working in a
>>> guest now.

>> By default I think perf assumes events can be measured independently, If
>> you want to guarantee events are scheduled together to avoid measurement
>> skew you need to make sure the events are grouped.

>> The common way to do that is with {} around the event list:

>> perf stat -e {branches,branches}

>> Please see if that resolves the issue.


> Groups only change how the events are scheduled, not how the driver
> starts or stops multiple events running on the same PMU (grouped or
> ungrouped). In my repro I had less events than counters in HW, so they
> will always be scheduled at the same time regardless of grouping.

> I did notice something extra though, you have to first open some amount
> of counters, and then open more than that. Then the second time the ones
> with different counts will be however many were opened first time, as if
> some state has stuck.

> For example if I open two counters then 6, the first two always have
> different counts the second time:

>     $ perf stat -e branches,branches true

>     Performance counter stats for 'true':

>               106129      branches

>               106129      branches



>     $ perf stat -e
> '{branches,branches,branches,branches,branches,branches}' true

>     Performance counter stats for 'true':

>               117013      branches

>               117013      branches

>               110364      branches

>               110364      branches

>               110364      branches

>               110364      branches


> After opening 6 again a third time they'll all have the same counts.

Interesting. Thanks. To clarify, is this happening in the host or VM?
