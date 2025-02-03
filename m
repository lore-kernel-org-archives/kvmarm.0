Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEB820FAB0
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738618647; cv=none; b=iXh+E65cZ2dZATeglkHADBT+K5067HXJr0S0qTY9nkCD47krpL29JV8EjXRFrEo9k2SMDH2WPJL088XNnikbVVPDZp+PY/9rFaZINREcjqlsG0fwcRpnOwlr+sQ4wQemNL5gpeBqLeyaRWQ3g3Hi7Ka3cOrCYTTWLFrJdVTOACA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738618647; c=relaxed/simple;
	bh=QLnx4/Rgy7zQOoI/TasPwiI6+hjEJs/e68fuOcK9rGs=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=GfU9c5uTcbxuR7SfyLMFK0PY0JuBj8EfcjHzI2FsZLI0wTx3GyeQMvhg2qhGZDi+n5NsO0dO6vbeYspNRpz0cQ6yghhKpZwtdpQ5yq31rGnc4QjC09+doO5PL2a/QgbypG2YDnZHUXoaXUxDvT0DfnfLEv1Bw0LIZBkNd9bvHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ElZAX9lX; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ElZAX9lX"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-844e5b72c69so774414739f.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Feb 2025 13:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738618645; x=1739223445; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XEqP/YEsjQP6HXPcAZ+OLL0SnqZRyU2wi8fLU4Seg48=;
        b=ElZAX9lXipl2tpx6GPKkb/Y6PrI9RvJp6sdfIetfUJUgcvBXExj2OdYMdY3XQLYXUD
         TlDP2i9RtR0NUpK3EsSWUv3Bwp4dtcngx6pH1LRI39aE8MYAe07/0FxfNX18Oz7LaUE7
         J2RPFU9lAbHgsAjGgmCdi8b+G/tZP/Yg8p/TXMqoYPGY2F9ZgJ3bYvzZaJEP161QT8eO
         aZLreYeV2nCiVJsbyLOF4TvL+49i62/G95bHVviElN81JzT+2iP1wGTOmUL3N8YtmCrc
         Zk37VkrBN0Mc7Tcz1+z/XeqhgltuA0c5yu6iBt1EWFSDlY2NY0Gzjns5yHWd5j8sDABl
         Ky7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738618645; x=1739223445;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XEqP/YEsjQP6HXPcAZ+OLL0SnqZRyU2wi8fLU4Seg48=;
        b=ehjVoyLb1Xf0rGmmDLeNQXHTkpZlWTaG+1YGAbnB4lgMr5kkwcUydFRsalY0jZ0/fL
         lhwyH2LY9UlMFrav54Sott6RdxXc0+Ro/nYFTqa69wAq5Opk25bUBRO7mC1XcjGoYd0E
         /KQDtuZYVGZ0dSa+XY/AaSUqzuNSmlkw+xT7UHrQnoQIFqmuhKbZHAYHwJj9OqPm0qvk
         jBDuDvXAPSmOz3xip5nuHHZqX8veFfeDHa68vcWykrdiCuhuU3tVkdc77rhEFS/5W9oL
         TKnC9zgiwo5vtK5YOck4jNsyJe2GFF9dC/UyDUi0jaCIDeJAWIVQ1Msl7obXsl8hEy5m
         4nlg==
X-Forwarded-Encrypted: i=1; AJvYcCWSOnnvImuTGGcmnkPoWhPYT9+8a2Ix/O5J/+hCbYYlxl3x99BEa3W2c8DXw2etXkcsLOxw+5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhjCvpdgoaxPtFE2e0ijzCnEHRW/8SBKCfdDCUxsCk4Eo4fmi9
	M40aU65O3/qxNbYFaIR1+uhnGucTeNaBroxOyn3mhTWC70qBYYXgqXYZouV8GQvk6XqsBDH1Ky0
	EZgsRfkdtlzLU5JsRP2SqxQ==
X-Google-Smtp-Source: AGHT+IFzEQXFVr/GsJOoiYsXrEqAdOToUP7ubJ3+EUez4554ouloGovsV2x1HVo9oXN98kh3qBpaq5S0IrbbEWoKkA==
X-Received: from ilbby19.prod.google.com ([2002:a05:6e02:2613:b0:3cf:c127:d037])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a92:cd83:0:b0:3cf:b571:c08c with SMTP id e9e14a558f8ab-3cffe3d1bc2mr218960215ab.3.1738618645230;
 Mon, 03 Feb 2025 13:37:25 -0800 (PST)
Date: Mon, 03 Feb 2025 21:37:24 +0000
In-Reply-To: <gsntzfj91fbs.fsf@coltonlewis-kvm.c.googlers.com> (message from
 Colton Lewis on Wed, 29 Jan 2025 21:27:03 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntwme61zhn.fsf@coltonlewis-kvm.c.googlers.com>
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

> Marc Zyngier <maz@kernel.org> writes:

>> On Tue, 28 Jan 2025 22:08:27 +0000,
>> Colton Lewis <coltonlewis@google.com> wrote:

>>> >> +	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
>>> >> +
>>> >> +	if (reserved_guest_counters > 0 && reserved_guest_counters <
>>> pmcr_n) {
>>> >> +		cpu_pmu->hpmn = reserved_guest_counters;
>>> >> +		cpu_pmu->partitioned = true;

>>> > Isn't this going to completely explode on a kernel running at EL1?

>>> Trying to access an EL2 register at EL1 can do that. I'll add the
>>> appropriate hypercalls.

Ooohh. Making this work at EL1 is much more complicated than adding the
hypercall to write MDCR because once HPMN takes effect, the upper range
of counters that the host will use is only writable at EL2. That means
using any register related to any counter in the upper range would also
require a hypercall. The only way around that would be to avoid using
this feature in the host entirely and only enable it when we load a
guest.

I know we don't like feature discrepencies between VHE and nVHE mode,
but Oliver thinks it might be justified here to have PMU partitioning be
VHE-only.
