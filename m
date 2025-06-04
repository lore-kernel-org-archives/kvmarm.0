Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09892231854
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 20:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749067819; cv=none; b=RMmw2i0FZseRUkqN5MuosyU4IjemY68XSq0Wk1FD/yNpdmHaqrrsaH1zu/E9U5XIhwRMlJQ6UFCDCYYyiRh4EnoSRltxkqujsguMIdI2LTtPVPCnMOCoioLnPlyAEyUE4HaW4Eb4bU0ETo9lbi6VW+3eKg+rj/7lRfKSAHWbKVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749067819; c=relaxed/simple;
	bh=+FLkUpcT3PESJgNscr3x/ohUzN/uoff55tujHNikLec=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UP5iLXIaSwpYfcjKmxDPhH7pfUkfbXVfPMOa4xIBfc5S3R5Uo4gjaplFQ7S6XEvtvSpLCWkJOpudj57uNBNDfttOVw3AV3GKO8jB1jLV1XSb79icWcTFldWlWnQSw2ZWyFUI1myXkNhqyXydgiblNJ0zVDDrNG2IyjR8GSNDNG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WV0dqYDV; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WV0dqYDV"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2d5723630a2so437078fac.2
        for <kvmarm@lists.linux.dev>; Wed, 04 Jun 2025 13:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749067817; x=1749672617; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lHzQy57VH5Dlm3eWN9P8hBycQlEQ3v1q3yM5kgGsFF0=;
        b=WV0dqYDVuCYsxH+YLDxSevxIGo6af181tELtTa/l5LVnqMqsWTSRSpHtw9XqgvalEi
         SLBxPprHA55geUnha2t+BqDDByDUySWE/n1Zpc5ewVooJ0e0ByT56Okd4gCCedXkwAPi
         p2EVIq9+CzuYmeDrha1Jpp0IoVRGeb3lcLmdJekyRdc6BC9rE3CzHRzNfPOetLFRdnOu
         mDe5TPxCcCAKVc/0chOr0R1TIi4GG7QL2SaS/RH8dlfS5tuVx9Zn29OiK5WcVESDmROH
         aMxrm5bYXgTbqlHosRFvKnrSmP28rZBGyEiwU1X8mdQCurGj5Mg5BBRI4iYxdrlL330z
         IzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749067817; x=1749672617;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lHzQy57VH5Dlm3eWN9P8hBycQlEQ3v1q3yM5kgGsFF0=;
        b=V4pzxiMMwBHR9UNbtYlCDs/lWU620KWCtv7K3u2D2UllnS7Z7z3r21YaKXL8kcVOOl
         U1pMBbc5mpSz2oMC32T6tP93FMhOPXmbG2ljCq68UyYEuR85EiC6sGSt/oZuuabCywH3
         X9BgAE2RfXwwwgt5By1FHv4C/JSgRU37rFD5KdT4geBxT36vLoVMnB/2n3ETJi6MjTuq
         NLRnPtQL5IyGNuvc4eAN8DOoDcRMWGS8oCFSWo0/NdudinpHqVqW0dRytPmTcBf/BkBo
         UL1gAWtOjUOFE2Z4Y3WzTzwFvkbqHUyf4b0Sb0Y98tbHu3mfo7qQkT4u0udSZytk3U3m
         8pWw==
X-Forwarded-Encrypted: i=1; AJvYcCWWDCMPHfT7zJQCYRIYntdkx3pvbWFckg3wOaWCq99UejVzzbfN6I5cRI+gs7MIH5PxHNfFpsc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQbrvhuXeQppoNAuV8TEFl/o+/OJFdFVXdjpNG0Bf28bbD35ps
	Z8l9zi1eGsRr9kakDBjYJR8J/UPv2JKYtwY27niuNJBfuKChxzdgzVVp0OHRhKdDOnyJhCNQjqL
	6FwV8xVF+9LfzmuQZuFYEzFf0WQ==
X-Google-Smtp-Source: AGHT+IGLogg78YRXI+ioMZ0+UVCCfd+jEelWcrdnbClXw8ZFThU177ehWe7bFnJXpvQmuVRW9orWyDUTziNbdD2zgw==
X-Received: from oabgq6.prod.google.com ([2002:a05:6870:d906:b0:2b8:e735:4798])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:4387:b0:2b8:f595:2374 with SMTP id 586e51a60fabf-2e9bf502cc2mr2945734fac.36.1749067817128;
 Wed, 04 Jun 2025 13:10:17 -0700 (PDT)
Date: Wed, 04 Jun 2025 20:10:16 +0000
In-Reply-To: <aD96rn78BSUDbEu1@linux.dev> (message from Oliver Upton on Tue, 3
 Jun 2025 15:43:58 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnttt4v1d5j.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 00/17] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Jun 02, 2025 at 07:26:45PM +0000, Colton Lewis wrote:
>> Caveats:

>> Because the most consistent and performant thing to do was untrap
>> PMCR_EL0, the number of counters visible to the guest via PMCR_EL0.N
>> is always equal to the value KVM sets for MDCR_EL2.HPMN. Previously
>> allowed writes to PMCR_EL0.N via {GET,SET}_ONE_REG no longer affect
>> the guest.

>> These improvements come at a cost to 7-35 new registers that must be
>> swapped at every vcpu_load and vcpu_put if the feature is enabled. I
>> have been informed KVM would like to avoid paying this cost when
>> possible.

>> One solution is to make the trapping changes and context swapping lazy
>> such that the trapping changes and context swapping only take place
>> after the guest has actually accessed the PMU so guests that never
>> access the PMU never pay the cost.

> You should try and model this similar to how we manage the debug
> breakpoints/watchpoints. In that case the debug register context is
> loaded if either:

>   (1) Self-hosted debug is actively in use by the guest, or

>   (2) The guest has accessed a debug register since the last vcpu_load()

Okay

>> This is not done here because it is not crucial to the primary
>> functionality and I thought review would be more productive as soon as
>> I had something complete enough for reviewers to easily play with.

>> However, this or any better ideas are on the table for inclusion in
>> future re-rolls.

> One of the other things that I'd like to see is if we can pare down the
> amount of CPU feature dependencies for a partitioned PMU. Annoyingly,
> there aren't a lot of machines out there with FEAT_FGT yet, and you
> should be able to make all of this work in VHE + FEAT_PMUv3p1.

> That "just" comes at the cost of extra traps (leaving TPM and
> potentially TPMCR set). You can mitigate the cost of this by emulating
> accesses in the fast path that don't need to go out to a kernel context
> to be serviced. Same goes for requiring FEAT_HPMN0 to expose 0 event
> counters, we can fall back to TPM traps if needed.

> Taking perf out of the picture should still give you a significant
> reduction vPMU overheads.

Okay

> Last thing, let's table guest support for FEAT_PMUv3_ICNTR for the time
> being. Yes, it falls in the KVM-owned range, but we can just handle it
> with a fine-grained undef for now. Once the core infrastructure has
> landed upstream we can start layering new features into the partitioned
> implementation.

Sure

> Thanks,
> Oliver
