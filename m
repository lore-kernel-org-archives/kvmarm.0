Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE731E2843
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 21:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738186026; cv=none; b=XyPI4fHv8Tf0H+dau4ZXvj99wyL+P0S7JJT6xOwUYjTbzg8VL6rilpnYgKyp7qXramw8rOj8aO8csD1lcw6d0HKjhtwqZoFjAtTspRx5h5mL0gZeTOu3Fv3r7Q5m7U2npojaNqiq+1JJSO7FHEXBFGmzdrT5n58WHhDWvO7cU3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738186026; c=relaxed/simple;
	bh=nN9FJWNplkIKmzFXRfsaSEmbobI8sxtet+92PBTyajw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KXM1N+9aQ9v5r7YsTX/euOJXHCI2A0x+drub7+0NytI8AfysoFl9xLjH4jFwbpuAZjhqOIoPgWORwCd8QuPxYZRvt2t3lw+t3E4HBaCKRSZKpE4ZdKzh0RY1TK6Ul1fNl7WwM1ogJwHq/X459iRgc6Z9XbzsZoDZ+PGjZyOM+4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1cODmyAo; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1cODmyAo"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3cfba354f79so3364045ab.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 13:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738186023; x=1738790823; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f5TFKrdlu748ABqlHsuP9NDv0QkMzFjiUtwaLrqTFf0=;
        b=1cODmyAoTc1Ic6rfoqX87GFzO0ny4eAiKsGFAnpp0qKoEj5mGxV086KWiUA99vXogf
         lOgHRx3l19IS5TxOE8D8wQUDpFxRPpKO+F5uFl6cnhFeCo5BkcfR+afGRTae6WszZIyd
         MMwU9q1udwiDsan13anMk094ehpN8ZJJ4Le15vxyayiHkMjMKZzrq3aeNd8XvbsU+9Tm
         eBiFlFBHG7F1REaAMy9DO2lky8GoHu16ZzYYkTS4U0XFGoDuH5p+Dj9tWv/lCEgT1shC
         gIjTov8fVNpjAoLCp5p4HHjcX3fyGuvGXCFXcUDofH/NYNZnHe9lJLYhsS0bC9ihvAI4
         sNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738186023; x=1738790823;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5TFKrdlu748ABqlHsuP9NDv0QkMzFjiUtwaLrqTFf0=;
        b=O7XpuiUrnkwei58Uz7cR7Mc0IY6UKpo4+c08cHK6MJWPicoqAWB3qKfBYRpFDeZS4a
         9ClgpJAW/j1V7eOQtLJToXeUPKSMRT8tDWBwMmNjQrPffKKGVvOFusX3whewCJTdHx9h
         +htFLo+dr603158tpE3bPSI9SVlalyx+L0UlHgwG5vopzr42GbvzwddWZeEsNq1GARJG
         cQdyd+AD8Gua5A9BBXU7i3dzqgMDGbnOiOvFHvKv3JH6MAQ/74f2xYUDYnPBB1hI2zRM
         Hy7WD5mMFPTF7ftEnL9ycYVvWdlYOMOrCXkvHhhfcdmejxGCubSPOUEMkTqaIhjMUQEy
         N8jA==
X-Forwarded-Encrypted: i=1; AJvYcCWYd9oIfL/qjwT13cn6E4zE4gOlotn/RRnjKzrWQ+TMd7V0VPLIqsrABlTroNr9+kNuqZsJr/U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx068t6RkjEYL1bO4Ir11xeTZXlbZzDXTxrCE9BjWCPSw9gCDg+
	GOJxMQ6hQkdF/KosRpOZQN1SoClRQvVmgBJNGVc8UYdfaSXjjVNVY6ZHZcedXagtVmeiBfid8vT
	GdkrTeybpN2/Z4wiwvpuliQ==
X-Google-Smtp-Source: AGHT+IEe9UoVLvNSaHlSkXBd6Ho5IN4ChMz7y7gjFQYGYFiTLbvYP7nErowhtJVcYSVDfJu2qMuLzToHlUCNsQ59Ig==
X-Received: from ilbbb15.prod.google.com ([2002:a05:6e02:f:b0:3ce:69d1:ce53])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:20cd:b0:3a7:66e0:a98a with SMTP id e9e14a558f8ab-3cffe3d1e48mr43753655ab.9.1738186023704;
 Wed, 29 Jan 2025 13:27:03 -0800 (PST)
Date: Wed, 29 Jan 2025 21:27:03 +0000
In-Reply-To: <86bjvpvdn5.wl-maz@kernel.org> (message from Marc Zyngier on Wed,
 29 Jan 2025 15:33:02 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntzfj91fbs.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to
 partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	pbonzini@redhat.com, shuah@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 28 Jan 2025 22:08:27 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> >> +	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
>> >> +
>> >> +	if (reserved_guest_counters > 0 && reserved_guest_counters <  
>> pmcr_n) {
>> >> +		cpu_pmu->hpmn = reserved_guest_counters;
>> >> +		cpu_pmu->partitioned = true;

>> > Isn't this going to completely explode on a kernel running at EL1?

>> Trying to access an EL2 register at EL1 can do that. I'll add the
>> appropriate hypercalls.

> But what about a guest that would get passed the magic parameter? I
> think you want to prevent that too.

That doesn't matter because the ARM manual states that when HPMN is set,
reads of PMCR.N from EL1 have that value and I've made sure in the
second patch KVM does that, so a guest believes it has a system where
reserved_guest_counters/HPMN == PMCR.N so there is no partition.


>> > Also, how does it work in an asymmetric configuration where some CPUs
>> > can satisfy the reservation, and some can't?

>> The CPUs that can't read their own value of PMCR.N below what the
>> attempted reservation is and so do not get partitioned. Nothing changes
>> for that CPU if it can't meet the reservation.

> That's not what I meant. The question really is:

> - do we want the reservation to be the number of counters reserved for
>    the host

> - or do we want it to be for the guest?

> On symmetric systems, it doesn't matter. On broken big-little systems,
> this changes everything (it has a direct impact on userspace's ability
> to use the counters).

> I think the design should reflect a decision on the above.

As currently written and reflected in the name reserved_guest_counters
this series is making a reservation for the guest.

After talking with Oliver it probably makes more sense to make a
reservation for the host. This is closer to the semantics of the
underlying CPU feature.

In the limit case it's impossible to leave the host without
counters. All valid values for HPMN leave the host at least 1, but
should we make any guarantees beyond that?
