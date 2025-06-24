Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB052E92D0
	for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 20:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795504; cv=none; b=hb0Uvx1YuFmwCUUwSqYJDrYcwPtHejUA+U0SvSBpl41ctF3t8SOS9DJlOujeeqCap8hvcBsSY2u2Pjt/b7j1WFds2X2hGro5jc814yovDiO0o+npdO14oStSQJSKVcNe47c9EUBUGlEBiZLrrMa0B5V5i4kGhc14cQ4nlWfYQwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795504; c=relaxed/simple;
	bh=f/D0i2v6lCewKUJtGBKR3xLCM9Mzx3OhGJfQ80nZptI=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=llF/9dWg4t81rcmuga4mTC8IHzmF+nyR8odCDFQ7l/8cJ5UN0euuz4dKJJE/4MQaKPcW0oIsuRVQCyIaoUmlB9wlzxHMBffJRRmXMFSZqmfeZq5UwML48BKKa/8m0KiTWaZQ+/9j6UglHmu6SGohlhoMtz+tmCGn2/KB6qYezw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cS9oPGUS; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cS9oPGUS"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-873fd6e896bso63390339f.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Jun 2025 13:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750795502; x=1751400302; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pP2HWMoMCKbdHfq9EmswNyKqb25oMjrzzlNWwJCxpig=;
        b=cS9oPGUS9x5Wb8UqL+xGJztFbnYCGPVREDvsnhitfw5pO5I9H3yJrKp+/3so09L9BP
         20q6lOvyXEO+eT7H33gB/w0ESz2ypV3VBHoEEz21ySBv7oV52BL4LI6QrY1Mckv/W4Vr
         oiK1GvAWWlKJt0k0TyCBg/a/yFS2Ap2WALamk9mSon3uPIvBpaR4JwuyNnU6KDk/R0Ak
         EBphEmzdPRGI5DiTojF0r0fb2aFlsOPJMyrCsggEM11QnUHbTf0x25iincx74BxK7CWr
         Kop0tMRe644ncLDKJuly4KOLVwgRHmK7ks6t04ioBfbHZiMLR8Io3xQYAsIMBKJY/FLD
         He2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750795502; x=1751400302;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pP2HWMoMCKbdHfq9EmswNyKqb25oMjrzzlNWwJCxpig=;
        b=DPXmoTg1GIndVG0daQfFlVlG0/TaMRtK7duF7/HKkFUeGqDNixmwkJ8EEVrJXwOzTc
         HmG5T5yJnOiqevml63LGDotig4nmZsjhlLsBos0N3AFFz/Znh7AMLyneSf6ORZ2m6cz5
         zq1p3NRyj2V5gbn/vsShNhl3B9DetnEPb+IdnwXME8hwcNVnrFAiWlL5M8WnazNyFVjv
         n+2xwFittHc0pBuFL3p+IGSY32Z7Lm/yoF0Yz4ob/L52UAkOdxz1uzphRbFswbM1Dq5x
         WziMwS4A6CGeujsCdGTEKg9LZYWpEYe0gsh/KMTyKhqkxPyxJ+oMlITQMFW8De/WZQfs
         dV7w==
X-Forwarded-Encrypted: i=1; AJvYcCWFzI1tFBxcp4e1VJOvUBp1vj7M2tPzxwa8roepPnj/J5RRgJ9hX2gCynkiDnYFUKfU24IPGao=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy58/CXvE5bYIq2oXHvAaKexFtZ3nrz9lCzKGIpifjsA2gz4H4Q
	67sGaY8w+idiz2a1Mei9fDfboZLo8xG2ClAedHAGuIGCvDe2Nv4k1T7NNJz/D1X8IDAGCQuSOqy
	phaSjn3iJnpYwcf+uTTazBiBiRA==
X-Google-Smtp-Source: AGHT+IEpwXEjWcAkbmXUn25NbkOypFqMgOZS4LSaytEWOm4lY0osguKw8gnkLrqXfYVp9g/tkoRSIDkKJowW6gl+SA==
X-Received: from ilff3.prod.google.com ([2002:a05:6e02:5e03:b0:3dd:a3df:9d57])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:190a:b0:3dd:d90a:af30 with SMTP id e9e14a558f8ab-3df329364f2mr5932045ab.10.1750795501770;
 Tue, 24 Jun 2025 13:05:01 -0700 (PDT)
Date: Tue, 24 Jun 2025 20:05:00 +0000
In-Reply-To: <aFpOI7cWTOAIjNjV@linux.dev> (message from Oliver Upton on Tue,
 24 Jun 2025 00:05:07 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntecv8aosz.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 07/23] perf: arm_pmuv3: Introduce method to partition
 the PMU
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

> On Mon, Jun 23, 2025 at 06:26:42PM +0000, Colton Lewis wrote:
>> Oliver Upton <oliver.upton@linux.dev> writes:

>> > On Fri, Jun 20, 2025 at 10:13:07PM +0000, Colton Lewis wrote:
>> > > For PMUv3, the register field MDCR_EL2.HPMN partitiones the PMU
>> > > counters into two ranges where counters 0..HPMN-1 are accessible by
>> > > EL1 and, if allowed, EL0 while counters HPMN..N are only accessible  
>> by
>> > > EL2.

>> > > Create module parameters partition_pmu and reserved_guest_counters to
>> > > reserve a number of counters for the guest. These numbers are set at
>> > > boot because the perf subsystem assumes the number of counters will
>> > > not change after the PMU is probed.

>> > > Introduce the function armv8pmu_partition() to modify the PMU  
>> driver's
>> > > cntr_mask of available counters to exclude the counters being  
>> reserved
>> > > for the guest and record reserved_guest_counters as the maximum
>> > > allowable value for HPMN.

>> > > Due to the difficulty this feature would create for the driver  
>> running
>> > > at EL1 on the host, partitioning is only allowed in VHE mode. Working
>> > > on nVHE mode would require a hypercall for every counter access in  
>> the
>> > > driver because the counters reserved for the host by HPMN are only
>> > > accessible to EL2.

>> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> > > ---
>> > >   arch/arm/include/asm/arm_pmuv3.h   | 10 ++++
>> > >   arch/arm64/include/asm/arm_pmuv3.h |  5 ++
>> > >   drivers/perf/arm_pmuv3.c           | 95  
>> +++++++++++++++++++++++++++++-
>> > >   include/linux/perf/arm_pmu.h       |  1 +
>> > >   4 files changed, 109 insertions(+), 2 deletions(-)

>> > > diff --git a/arch/arm/include/asm/arm_pmuv3.h
>> > > b/arch/arm/include/asm/arm_pmuv3.h
>> > > index 2ec0e5e83fc9..9dc43242538c 100644
>> > > --- a/arch/arm/include/asm/arm_pmuv3.h
>> > > +++ b/arch/arm/include/asm/arm_pmuv3.h
>> > > @@ -228,6 +228,11 @@ static inline bool kvm_set_pmuserenr(u64 val)

>> > >   static inline void kvm_vcpu_pmu_resync_el0(void) {}

>> > > +static inline bool has_vhe(void)
>> > > +{
>> > > +	return false;
>> > > +}
>> > > +

>> > This has nothing to do with PMUv3, I'm a bit surprised to see you're
>> > touching 32-bit ARM. Can you just gate the whole partitioning thing on
>> > arm64?

>> The PMUv3 driver also has to compile on 32-bit ARM.

> Quite aware.

>> My first series had the partitioning code in arch/arm64 but you asked me
>> to move it to the PMUv3 driver.

>> How are you suggesting I square those two requirements?

> You should try to structure your predicates in such a way that the
> partitioning stuff all resolves to false for 32 bit arm, generally. That
> way we can avoid stubbing out silly things like has_vhe() which doesn't
> make sense in the context of 32 bit.

Okay. I will do that. When I was reworking it I thought it looked weird
to have the predicates live in a different location than the main
partitioning function.

>> > > +static bool partition_pmu __read_mostly;
>> > > +static u8 reserved_guest_counters __read_mostly;
>> > > +
>> > > +module_param(partition_pmu, bool, 0);
>> > > +MODULE_PARM_DESC(partition_pmu,
>> > > +		 "Partition the PMU into host and guest VM counters [y/n]");
>> > > +
>> > > +module_param(reserved_guest_counters, byte, 0);
>> > > +MODULE_PARM_DESC(reserved_guest_counters,
>> > > +		 "How many counters to reserve for guest VMs [0-$NR_COUNTERS]");
>> > > +

>> > This is confusing and not what we discussed offline.

>> > Please use a single parameter that describes the number of counters  
>> used
>> > by the *host*. This affects the *host* PMU driver, KVM can discover  
>> (and
>> > use) the leftovers.

>> > If the single module parameter goes unspecified the user did not ask  
>> for
>> > PMU partitioning.

>> I understand what we discussed offline, but I had a dilemma.

>> If we do a single module parameter for number of counters used by the
>> host, then it defaults to 0 if unset and there is no way to distinguish
>> between no partitioning and a request for partitioning reserving 0
>> counters to the host which I also thought you requested. Would you be
>> happy leaving no way to specify that?

> You can make the command line use a signed integer for storage and a
> reset value of -1.

> -1 would imply default behavior (no partitioning) and a non-negative
> value would imply partitioning.

Good idea. I thought of that solution myself for the first time after I
logged off yesterday. Slightly embarrassed I didn't see it sooner :(

>> In any case, I think the usage is more self explainatory if
>> partitition=[y/n] is a separate bit.

> What would be the user's intent of "partition_pmu=n  
> reserved_guest_counters=$X"?

That doesn't make sense, which is a decent argument for using just one
parameter. I'm now fine with going back to just reserved_host_counters.
