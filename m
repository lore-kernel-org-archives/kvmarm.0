Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0502C08DF
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 22:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579005; cv=none; b=n5LVGDILW/NUQdTtgUm/JKOD5X/jK0Gr3lIBXr3no5GQTjekaA+9XJJjZFwWr4u7Zt5ZacKKo85bwitEnlJbIu2Bh4T3Wq161Whjp5ZsnF9UBnc682EkiMbkTCMTRmdb8ITzUpdIiYx789aNyUYMz40ioS5XZzoqqTxdVyGNxtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579005; c=relaxed/simple;
	bh=9mFmYvzmJytgvfdsMLBBujUvcXmuhikrBpixw/LzYIw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JFZkRARZ4cyFPwAimpqfbEPCHBezolQ99D6mYXTPWxHXixjXgmSdtyeWyJeXFz0IbgNAxbGFB1r2bDFxpSjOjHlzTi2HbOAo8MBbDa4QDQ9zF7B7z03wInm3G5BxLraDLh1xh0dtbdTKgCqI7JcEAv9d/mps9rk5yfh6Jb41GpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aw/JbGRq; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aw/JbGRq"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-65b325457e5so1442929eaf.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 14:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765579002; x=1766183802; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3V7ABHshgDafwAwYHEV+MXsyHyX7z1eKDaoAGOxARUw=;
        b=aw/JbGRqCMDbOUU7DeHkx3d1GCl79cLPQaiqqZaGX3nV7roVpLale2Mr4DKOiGLrZM
         ee1DAN1XP2tQbkyP8ADkry3r+zoPwFXafPKKFurwxU1uWGANYVwx2d+FqksRiS3jd+X5
         3TamUN607ONHMBOg9Mwr5F+HHbS2RBYWB/CBo6aypsQ+RvwlFoiUKb/zrQvzbefTFaPi
         H/RixfSBvGaeZ050KFUfLAubScb92nh9GPIQ5+iy2Brewxg3b1wQTXURCF/nkGP4etZN
         H9EsPeo5PuPZbcmAA3J4GXxiWp2eGEq1HRaqo0BuBUXLCkuotZFz7U4NAaHY5Z1iz5as
         4QLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765579002; x=1766183802;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V7ABHshgDafwAwYHEV+MXsyHyX7z1eKDaoAGOxARUw=;
        b=ja3cL6dpyeAzuBfkgXvjwIZzr2wZEhF5d5PjK1IxLiMkGHEOl9h45wr0cwY3PCMMfY
         0qKnQCWl/XqCAVs65SB9FcsngW9cqQT2eCBv3EZBkmYIogDYwS/G+2moxvmqws5siD/k
         CRFeRFIRTMN8ODWXHIfzYDgZ60JF0C2ue0TcbdlyMNo+6FkIBAp/AwWuwaDZBSNC+fDK
         OdhiKZ4gz9Qfh+CZbh1xRlDk2m1iMnrCd1aDtgE7JZtiSscEWNG5LD9nv/OzDYkakEqR
         E1rK7qAqbHlQzF/VlKAy+JWvmYiTUyXZlpMum7DfslQBapd3XpaE1bTmTDrFtPDsnCk6
         fQAg==
X-Forwarded-Encrypted: i=1; AJvYcCVe0E76zL/59uScC67stGzTa6Hqj1CRRmC5qazoTqlr+zKKgtrMwC46DcEebCWdyhg1G08Yebs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwUhBfDA9Klk74i65h2vTY2WoJeIo3MTgmufgO0YvvnMEkCaIY
	RgjWIQtliLJtg3IWlBdrVFIHhgzsi5ZTK9/95d6q3Y8An3/HbnqqH5jRC/kZMFZhcw178MWc5/G
	RPDI3FHbue4v5FEERuCJHoTQHlA==
X-Google-Smtp-Source: AGHT+IHkZVgWFjBleB6izi/mYS6b4xrdOCdIwFPbm2svitIfX3LWxEQK52duuNdAGmZBwWfL5PIEmP5Eu+rxvNmu9A==
X-Received: from ilbbl8.prod.google.com ([2002:a05:6e02:32c8:b0:434:972f:bf90])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2223:b0:659:858f:f1d3 with SMTP id 006d021491bc7-65b44ff60f4mr1625746eaf.0.1765579002046;
 Fri, 12 Dec 2025 14:36:42 -0800 (PST)
Date: Fri, 12 Dec 2025 22:36:41 +0000
In-Reply-To: <aTimpRFfr9wI9Hw5@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 14:45:57 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntbjk32upy.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 20/24] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> On Tue, Dec 09, 2025 at 08:51:17PM +0000, Colton Lewis wrote:
>> Because ARM hardware is not yet capable of direct interrupt injection

> PPI injection, it can do LPIs just fine.

Clarification noted. I will update the message.

>> @@ -961,6 +964,12 @@ static irqreturn_t armv8pmu_handle_irq(struct  
>> arm_pmu *cpu_pmu)
>>   		 */
>>   		perf_event_overflow(event, &data, regs);
>>   	}
>> +
>> +	govf = pmovsr & kvm_pmu_guest_counter_mask(cpu_pmu);
>> +
>> +	if (kvm_pmu_is_partitioned(cpu_pmu) && govf)
>> +		kvm_pmu_handle_guest_irq(govf);
>> +

> The state ownership of this whole interaction is very odd. I would much
> rather that KVM have full ownership of the range of counters while the
> guest is loaded. By that I mean the PMUv3 driver only clears overflows
> on PMCs that it owns and KVM will do the same on the back of the IRQ.

If I'm understanding correctly this is a code location concern, because
the host driver has to handle the interrupt in this function or a callee
of this function.

I will do it that way. It would be duplicating a small amount of logic
in kvm_pmu_handle_guest_irq() but I see your reasoning.

> Similarly, KVM should be leaving the "guest" range of counters in a
> non-overflow condition at vcpu_put().

Noted from your comments on kvm_pmu_put()


> Thanks,
> Oliver
