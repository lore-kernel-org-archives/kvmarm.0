Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C901E1C1F
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 23:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738105698; cv=none; b=rw3ErtDMxdvkys0ipF/Tqlvr2htddV1nXTWupTaTpiO4TrkmtiQs5PR9uS3ECPn8r/b8gyCbIDs1B/soNmYBBrRUZlqnOhB2ZXtDpyhyE9C9eq5qE3RquFmlKaGD3K+wFepWKv8T4f6ZxO7xHFWDn7bGM3GoODCpjGTc2b8F/lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738105698; c=relaxed/simple;
	bh=c1f9GAm+Tfh1fyQTBlChMqr4dttyOYyLRGgVPWFsuGQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XPV1FROi4c+4lW83O1HIo3xoUPb7ECDb9ZKFHTJRxEYI/lCSwVML1fp0LwAjnP4r/jbv9cfAUpWatfqWhrByGiL7eBt0q7AeThWVV6RvbSCVFozlfiUaENcLoYDPcb0Ps+QFSqPeJp1ItXAzjWnpwvLVY18daWSzX0+IogZvvdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oLnSIMm/; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oLnSIMm/"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-71de28807b0so3898721a34.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738105696; x=1738710496; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zFo6TxttEqFIalCsIspeo8mg648WKT4oP0eEXrQLVXM=;
        b=oLnSIMm/olIFRMS1/pqQUWix0EJzmaQL0/0zca80WqajxK9msJDeR0gxBl4TaNln0H
         qNF/zOwdfdRRaeH//WewQsc+9y8n2Cw9EFbTE12fWpNvb3YavI3G3DeWGnuTVsCKqW3A
         qGktocTAT/RuDwkjE+//DEMbnLEE5yN8fXKTfNC4lCJZxiH43d5GuKnbLmQ5H14r/iyH
         c9ECM7R3O6GYn4wYJrBXReJh6I8NQ8dDfb2588xIYgr+SY1/15TfjhREh0dM121I8rU2
         bm26/qTU0dfV0415xbDNoHxHY1gIIE2ZxFv1ZDF3hQ1MvFWozi1mhl4HDNsAk8Jyvvpl
         lXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738105696; x=1738710496;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFo6TxttEqFIalCsIspeo8mg648WKT4oP0eEXrQLVXM=;
        b=mwsaKOmVILRiUdueBHc+RMR7y7ccLuLjAkNlSOoz9CfScvkyW+rr4fLlZf6gI81l0m
         tunKEdRGQJSECP9cfO+Uyv5dyenTygUoAK+Lg2fRR6U/12bu8YJJ24hsvQgRP/ZO2xrc
         I4I+94O/x2qGVKLFq3Jz0tL858QP5RW0pUzj0Tw6P/FJZwkZLJMiBHkNJkkUgw6T3DvZ
         ZNJeikXNByttv9H4WzVagSInb7z0wk9e9d6Z8kuQTMlLR5kgwngj2H8xdTw9wOiytkHa
         PkyPtxJXwWa8dDiww8Vc3c9DKuSO7BdBDhXPsfHgTjeNZZXcjqWH1JGcpQ3hyizTSurj
         R4mA==
X-Forwarded-Encrypted: i=1; AJvYcCVpl3jjf0Nk5BrfCJ/MF0Fy31by3kpglXCTkwxaLp6VSJT9KWFkiFKNPNCyeinAIyrvh2Da6D8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws76iDeooVJp90/DHk7bZgf0TZqHft1hm1Ex/hTQRaJ0VbVeqt
	p1txlZcdrEsA6V4tJcxa41VOV4+Ehstnk7gImkQfZBvTNtntr+jc3nxxLQJMwI0bKy7znfTmAi9
	qtTfm+bDggAlRFYuVaOmNKw==
X-Google-Smtp-Source: AGHT+IG5ddnY6/iHSVzZPnfbt3FF1yw2VhaZJBEOVScosdSTNCWOaSf0V1Rutk3fTReV5GNpySjV/C49wUzgPhrdpA==
X-Received: from oocx8.prod.google.com ([2002:a05:6820:8188:b0:5fa:a33d:6240])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:670f:b0:71e:1c5:4f9a with SMTP id 46e09a7af769-726568f8258mr618751a34.25.1738105695853;
 Tue, 28 Jan 2025 15:08:15 -0800 (PST)
Date: Tue, 28 Jan 2025 23:08:14 +0000
In-Reply-To: <gsntbjvq382s.fsf@coltonlewis-kvm.c.googlers.com> (message from
 Colton Lewis on Tue, 28 Jan 2025 22:08:27 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt34h235b5.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to
 partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: maz@kernel.org, kvm@vger.kernel.org, linux@armlinux.org.uk, 
	catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, pbonzini@redhat.com, shuah@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes


Colton Lewis <coltonlewis@google.com> writes:

> Hey Marc, thanks for looking.

*for the review

> Marc Zyngier <maz@kernel.org> writes:

>> On Mon, 27 Jan 2025 22:20:27 +0000,
>> Colton Lewis <coltonlewis@google.com> wrote:

>>>    	/* Read the nb of CNTx counters supported from PMNC */
>>> -	bitmap_set(cpu_pmu->cntr_mask,
>>> -		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
>>> +	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
>>> +
>>> +	if (reserved_guest_counters > 0 && reserved_guest_counters < pmcr_n) {
>>> +		cpu_pmu->hpmn = reserved_guest_counters;
>>> +		cpu_pmu->partitioned = true;

>> Isn't this going to completely explode on a kernel running at EL1?

> Trying to access an EL2 register at EL1 can do that. I'll add the
> appropriate hypercalls.

>> Also, how does it work in an asymmetric configuration where some CPUs
>> can satisfy the reservation, and some can't?

> The CPUs that can't read their own value of PMCR.N below what the
> attempted reservation is and so do not get partitioned. Nothing changes
> for that CPU if it can't meet the reservation.

My mistake. That does not happen. I originally did these comparisons in
armv8pmu_reset which runs for every CPU but __armv8pmu_probe_pmu
doesn't.
