Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5694C3D34A6
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500553; cv=none; b=W0uVw1b9VrKLY8vMPHDSlc4Sm3qYlpj7n4qCzNErp2LeZBAKP46Rlrs+tachrDn8F+xZiUSQuGn0kpl9sCsaFiDkOQ08Z9m+KZkG6+QsVJmu2OiqotH/G2JlcfCPIjg5p4f8RCsPKZUm8l4OWE9ShBZOREORCjMBgyVtZ4zwG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500553; c=relaxed/simple;
	bh=s1vml7vcnt1Rp1v6JVpJDpiVuPBFnkJqBrKshWU1rJQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QrsU6p0YrIVk6gi4CR+/eS9zwAbGHGzCZyvZXRdg/j0OzSIAzNK6t7ogq3vfbs2XqySdsuKGANEREmxfZHlLJvbIrPCMBfp1otQVFSP1znzG3BCIzPDZTMXd+db0Or5oK1AdMElIywCpxj8u2IwEmZZQqdVf5o5aWVVGyJAchMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lqK8Rdxw; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lqK8Rdxw"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65f7130d6aeso3325512eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 10:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500551; x=1769105351; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s1vml7vcnt1Rp1v6JVpJDpiVuPBFnkJqBrKshWU1rJQ=;
        b=lqK8Rdxwtsjp39+RVcs0qYprpV8wUB4grdAWnsSCchIeQ5JDpOmVxk0fUFglrSYuqA
         1ml+Px+I/s2rEGh2V74jHdE5N27XQbKviZbK9MK3HUunDO0OG6RGGp2eq8sNtnlS35Gr
         BnnXStQ6XxTSnmYFQVIrkrIYojwxKlMoqAKzdipJmp1adYdbYh1qQzwmhdEC5WVpcahl
         UMahfK145EbysMYEfuDUclT3ZU05RxnKYTuklUkWeAi/4ZBbBzFpe9pmYnN5f9/BorXH
         uvzlmP0YIqk6lMV8jeeR+rkPMxldStRPfKcwViKDmCy3nVrNXlsR+lDnMC4km8xOOlkO
         GD8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500551; x=1769105351;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s1vml7vcnt1Rp1v6JVpJDpiVuPBFnkJqBrKshWU1rJQ=;
        b=Lr+//gaVU+PI//RnQjYlmREzhBfEH7U1W6Jc5k1f668XZce1VRndr2qkMmBX9afg6d
         4yhQ7QsxGpEf8ogpH+TTjJl5NVPS2IheNam09dcMMVC/lvyrfsWf+Yh3efRV7MPkbOVh
         aGA6BW18+1mV6aadxZlMwABM/F0S2zBc+DBSSlC+EYZUZ79MthOOR9uZBpfWET9G9Ckz
         maW49nFsNygXvzclO8p3tLaHXsXsMCTaPEbPl3eXPNOUoOLUDQW2FC9wA0aE5OljWwPk
         wv00riALZaSQVEIWjUfaw4Ywxe80ZeHKsmsv7im3kYd56ZX7WhrS97/cDZFJ1/WVQuSh
         37Lw==
X-Forwarded-Encrypted: i=1; AJvYcCUQd3iNBrJeZ2ZS4Bff/cK2doVv7HjDoeFfKa46rjWRWi56TFUg+QINbPPNVB12PyzoW7jqjhk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5jtjYwBOm+i3muCuqUh/DRx4TZIFJfDSCHrFGenj8BUwoO2kk
	BS0tml8USutFeFMAvJV1m8auhIPXvoG1Y1N4ihEd13DzXa/E2sN+rkX/v1qO9y0zVNah9bcRDbJ
	ImIzg+JmxTXY4YzQYASe5HwOq/g==
X-Received: from iobet8.prod.google.com ([2002:a05:6602:4c08:b0:957:5463:901e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:480e:b0:660:ffa9:e2ce with SMTP id 006d021491bc7-661189e47e2mr16014eaf.83.1768500551087;
 Thu, 15 Jan 2026 10:09:11 -0800 (PST)
Date: Thu, 15 Jan 2026 18:09:10 +0000
In-Reply-To: <aWjlfl85vSd6sMwT@willie-the-truck> (message from Will Deacon on
 Thu, 15 Jan 2026 13:02:54 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntpl7a694p.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 00/24] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Will Deacon <will@kernel.org>
Cc: oupton@kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Will Deacon <will@kernel.org> writes:

> On Tue, Dec 09, 2025 at 03:00:59PM -0800, Oliver Upton wrote:
>> On Tue, Dec 09, 2025 at 08:50:57PM +0000, Colton Lewis wrote:
>> > This series creates a new PMU scheme on ARM, a partitioned PMU that
>> > allows reserving a subset of counters for more direct guest access,
>> > significantly reducing overhead. More details, including performance
>> > benchmarks, can be read in the v1 cover letter linked below.
>> >
>> > An overview of what this series accomplishes was presented at KVM
>> > Forum 2025. Slides [1] and video [2] are linked below.
>> >
>> > The long duration between v4 and v5 is due to time spent on this
>> > project being monopolized preparing this feature for internal
>> > production. As a result, there are too many improvements to fully list
>> > here, but I will cover the notable ones.

>> Thanks for reposting. I think there's still quite a bit of ground to
>> cover on the KVM side of this, but I would definitely appreciate it if
>> someone with more context on the perf side of things could chime in.

>> Will, IIRC you had some thoughts around counter allocation, right?

> Right, I was hoping that the host counter reservation could be more
> dynamic than a cmdline option. Perf already has support for pinning
> events to a CPU, so the concept of some counters being unavailable
> shouldn't be too much for the driver to handle. You might just need to
> create some fake pinned events so that perf code understands what is
> happening.

Thanks Will. I have a few followup questions:

1. Are you suggesting this be done whenever we enter a guest so the host
always has access to the full range in host context? That would be the
most dynamic.

2. How should we handle the possibility a real event already occupies a
counter wanted by the guest? Is there a good way to create our fake
pinned events then force a reschedule so perf moves the real events out
of the way?

3. Is there an existing fake event type that tells perf not to touch
hardware?

4. Can you point to any example code that already does something like
this?

