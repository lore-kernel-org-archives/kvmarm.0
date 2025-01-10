Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E2A1A23A2
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736471715; cv=none; b=Y8r8gJ2YSbznR+mqM16FxGkh8r8mQUyY1v2yBrhzFqBnR28WVq4HFL8LT/72oThZjGtu8JCbCbN6DMZsdOg9rWak/5KkdJGnPSokqDWGZqnJfpB1n3pp5iB6/agOm2jPoNAIwMzGQIWWTLiogI/tEMc6nCpiEoQY/lTS71jv07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736471715; c=relaxed/simple;
	bh=ZSi0AyJ/RHt8qURQBIV0l6kjFCICQc7I9ltkvIwEkCQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DKQFMHevoiEcNoruY7QcK19TM4l+6rNvU8UnYRoyy+51DZA3zGKNp52Wi7pJdFwLdVvTjLVXsavk+hITjXKHbydVbIF9yGb6Tapv6mGEQDzLiFF4060tTefbobu+4mBeVf+Kmd3uPYxvW1oHDQ4ZmmBN8Gb04e0EpGvRpo2t6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DNcohnMO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DNcohnMO"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9b9981f1so3914744a91.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 17:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736471712; x=1737076512; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7VwFFFatQRWj4k7jYl4E+a9CzYdFY2Mg+JsqSac4RoA=;
        b=DNcohnMOgYKZ4JHVlq9heoXpnoTQca/+LtyuDQyB4sLzHUpJjiE8OyKHfKBYZYbY4B
         XSavwuy+1wUgHoq8ov2c+vNjZqnZTQwghLxqQnJI7IeeS4er9Ou49GDsgIJhjW5GWhhO
         FSa+VZeml/zsICiYbh9je6NpGnLUr9+Owc17R/On0HDKTkxBuNOewjBBVsLHbBljU195
         pmOOY69C+R2LzXdfsZHSqkWBr6LjtiqUH6rKctP/e+8XI9fdIa+jvQq1pWUuRowTby/W
         lXilVJip0Xju++FKGuicPzEAW8DkIN3ctqs6H5G9fAnLZr/2oVrwd+J+TRi9OVG7nPQk
         MEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736471712; x=1737076512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7VwFFFatQRWj4k7jYl4E+a9CzYdFY2Mg+JsqSac4RoA=;
        b=dSc1Zm5CY6lgkLckaggsEZtWB1BRUHROJo0RtYLao6WXjdIaCqdfLO5N14yRiHrYKj
         bYK4dXDGESFe0IUPm3D0sI83PSS6WnI8lCP8d0fRHKjg8AcHx/fn+NGvOoQxbysxi05S
         e+aWLeug1jcDj9zIRAIvTrt0mNbcIH3nxZyAXzF4nNhPwI4oQST7OGOmuQ8szFjTFuPC
         06G5IFqLE/Zq2HY79osZBWNuz0Sm6pOJeDxIXIqXtTtUMzR8HxpVUUNtGUf0H4pyHBjp
         xcfGVSF42A2F+kJrsmyqKNtaazPgjWiYoCzEKU8R5FE8rDUCM8uqP4s/haniXrsYgOU+
         76nw==
X-Forwarded-Encrypted: i=1; AJvYcCUUXvwKgfDI2REUx2j26Lq5TgFwESt91RCLPiETo+BDC1Ts9XF2Mj75Z5E0v36O48mxuUnefSc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCiAPYwt5lKPJHoBwbMn8iBUzyEEcQkTSZMDUQeS8Lcff/OMdH
	WoLm+LIe/upN/8yK4Np+16VK+6qNnrtxgggCY/9Dd3SXllaRiAKwi63XwI543urbNEv+b7mUxCE
	ibA==
X-Google-Smtp-Source: AGHT+IHAhOQ1hNL+2ODVngM4YtoUZlDh3MWUPi4xjwAS/ekbAexZ0ECdQPoeafSTa9dwqEUdAQpSzA4aRUA=
X-Received: from pfiu8.prod.google.com ([2002:a05:6a00:1248:b0:72d:35ed:213f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:e83:b0:725:b7dd:e668
 with SMTP id d2e1a72fcca58-72d2201700cmr11665849b3a.17.1736471711800; Thu, 09
 Jan 2025 17:15:11 -0800 (PST)
Date: Thu, 9 Jan 2025 17:15:04 -0800
In-Reply-To: <173645122896.885867.13450184481916964756.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241220013906.3518334-1-seanjc@google.com> <173645122896.885867.13450184481916964756.b4-ty@google.com>
Message-ID: <Z4B0mJOwH6xGjuZ6@google.com>
Subject: Re: [PATCH 0/8] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 09, 2025, Sean Christopherson wrote:
> On Thu, 19 Dec 2024 17:38:58 -0800, Sean Christopherson wrote:
> > Fix a handful of bugs in the binary stats infrastructure, expand support
> > to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
> > enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
> > getting a stat that actually exists.
> > 
> > Most of the bugs are benign, and AFAICT, none actually cause problems in
> > the current code base.  The worst of the bugs is lack of validation that
> > the requested stat actually exists, which is quite annoying if someone
> > fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.
> > 
> > [...]
> 
> Applied 1-7 to kvm-x86 selftests (x86 wants to build tests on the vCPU-scoped
> stats infrastructure).  
> 
> I'll hold off on the compile-time assertions stuff until there's consensus that
> we want to go that route for all architectures (not at all urgent).
> 
> [1/8] KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
>       https://github.com/kvm-x86/linux/commit/b68ec5b6869f
> [2/8] KVM: selftests: Close VM's binary stats FD when releasing VM
>       https://github.com/kvm-x86/linux/commit/a59768d6cb64
> [3/8] KVM: selftests: Assert that __vm_get_stat() actually finds a stat
>       https://github.com/kvm-x86/linux/commit/52ef723593fe
> [4/8] KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name string
>       https://github.com/kvm-x86/linux/commit/7884da344973
> [5/8] KVM: selftests: Add struct and helpers to wrap binary stats cache
>       https://github.com/kvm-x86/linux/commit/384544c026f6
> [6/8] KVM: selftests: Get VM's binary stats FD when opening VM
>       https://github.com/kvm-x86/linux/commit/6d22ccb1c309
> [7/8] KVM: selftests: Add infrastructure for getting vCPU binary stats
>       https://github.com/kvm-x86/linux/commit/60d432517838

Argh, apparently I only tested this series on platforms with high RLIMIT_NOFILE
values.  Creating the stats fd for all vCPUs causes kvm_create_max_vcpus to fail
on some of my systems due to doubling the number of fds needed.

One option would be to figure out a clean way to avoid creating the stats fds
for barebones VMs, but x86's recalc_apic_map_test also fails.  That test creates
512 (max "supported" by selftests) using vm_create_with_vcpus().

Doubling the rlimit from 1024+100 to 2048+100 for the max test doesn't seem insane,
so my plan is to move the rlimit twiddling into common code, and then account for
the vCPU stats fds.

I'll drop the above commits and post a v2.
