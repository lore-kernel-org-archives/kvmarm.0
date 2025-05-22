Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F097271A9D
	for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 23:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957956; cv=none; b=W/eQQ9x4I0eo9aYHCDNAvdw1Ub7hyK9mAySoRnPpC23tdUbKu6pq+pCJWvwLhlVoc4goDLuHpMUjKJQdCWdU5Ab+FRHcv7Bxg74EFfgNwjxhOWps6sDBj+4IbyD4wLHKAeSbkVBcTrsg5S6MBTnRy526R5WulNkLg6UYzmANo8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957956; c=relaxed/simple;
	bh=zSgoAnQejqHLW8WQDINPRPjIjmA3d28SSrIQu0zseIM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qg2LPg/9kFSgFvBHFdHCs6fWMO1CrcFeIotzqOLinbaMk/2mCoQYZ7AQywLI8+vJv1RpTBYMTLfL3I3iWUkgxWhh7iZSC3X10JCl6TlRa9z+pg5U1hGCpepTI2nhyM8x9/Y6thP2otZHaLCH06F0Mely+mDGD0glnSQoVKuQ+As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h7iX2l2V; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h7iX2l2V"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310a0668968so2203515a91.0
        for <kvmarm@lists.linux.dev>; Thu, 22 May 2025 16:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957954; x=1748562754; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tip5ipIFHbSR2IYZnXAE5GbVsPWdm0Tjm7OJATFbViQ=;
        b=h7iX2l2Vef0lC0/WIZ24cqWO7tgj5JWs2SqC3M+mdIeKkQAmaaFoF/r0OtS+VrT0hV
         z2+UloU94VNJJ6XAbRc/weuGDXFHROOV0UFsaNu0aF7RAD3RK80ToG+wtRJQGzCR+4yw
         MDTmEGdz1QjgQQyGRedRUFKu34fApJ7s1jI4qDkmmk7wclC1kGL8RZTOOB1WRQ1yB7Tv
         XpjJTFCY8AfJv0q0tj3Mmf0X1OEaKr1aOBw1HvNCUb+OEl3F4qWDXrmjsy1O2Dg19owd
         7Mf9C6wqFumEa/PVkpG2wrN8lZTwHl3r+ECfF6lM6Vk0ayYguGqk/xz4cRktKm9yYyDN
         BvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957954; x=1748562754;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tip5ipIFHbSR2IYZnXAE5GbVsPWdm0Tjm7OJATFbViQ=;
        b=OreP49wprcpWyXmAwXjb4r7ckijcX5V0VsOyVPD94e6254PSKvImJw3W4L1D1CeU+N
         YUoUIeUQ4SzLnwTmNGTYNWXey8IoYlwJ4VUQbBoa+sqAdCYly9SVLj4B5OMdJs2BRgL6
         RzWwqCuFm0e904EfG7UJHWMrE6UpJM+GChfhRmUqdi6gHT5+jK8lBVr6dikNKfAa5Hka
         Gzt60/lkSLk87kJmk2bu+Xu6L0f95pvkLe5M0A74LvypbBrLA4DWnHVF1CATJuYGPRKx
         ZngqC+zeSiNq+Ax3QG30AXmcGy5N5PgRqboSsSmKoEJktIzQhH7SIMEAd0iJvjhECKgR
         4jfw==
X-Forwarded-Encrypted: i=1; AJvYcCWplU8Zfytb6A8GYozhZ3IbCCvnrdHLBHFvka12wMBSSV6lsHy2McgaM+ib5iHtKsyZGnFhGjU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaGReZ8RG1gFbNDFXnpR3dIBrYUvRlK59px23fNf0R5i+5t/I3
	gKDIO7BjiBguAZz7k4GjPbxblJHIZekW5QQNlKiyngk9WqqVutfY8vQKiOlO5nIc+shQ62eMA5l
	w65wQ5A==
X-Google-Smtp-Source: AGHT+IFoFNCkbt8aJJ0xnDKCzmCnIh6gGll4rd5AbALinv7jGcAxGvJdpWgEmk1cX+UlvCwIOcTYID0HpNU=
X-Received: from pjtu15.prod.google.com ([2002:a17:90a:c88f:b0:30a:2020:e2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:303:75a7:26a4
 with SMTP id 98e67ed59e1d1-30e7d4fea75mr43035958a91.7.1747957954327; Thu, 22
 May 2025 16:52:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:52:10 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522235223.3178519-1-seanjc@google.com>
Subject: [PATCH v3 00/13] KVM: Make irqfd registration globally unique
From: Sean Christopherson <seanjc@google.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Shuah Khan <shuah@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Non-KVM folks,

I am hoping to route this through the KVM tree (6.17 or later), as the non-KVM
changes should be glorified nops.  Please holler if you object to that idea.

Hyper-V folks in particular, let me know if you want a stable topic branch/tag,
e.g. on the off chance you want to make similar changes to the Hyper-V code,
and I'll make sure that happens.


As for what this series actually does...

Rework KVM's irqfd registration to require that an eventfd is bound to at
most one irqfd throughout the entire system.  KVM currently disallows
binding an eventfd to multiple irqfds for a single VM, but doesn't reject
attempts to bind an eventfd to multiple VMs.

This is obviously an ABI change, but I'm fairly confident that it won't
break userspace, because binding an eventfd to multiple irqfds hasn't
truly worked since commit e8dbf19508a1 ("kvm/eventfd: Use priority waitqueue
to catch events before userspace").  A somewhat undocumented, and perhaps
even unintentional, side effect of suppressing eventfd notifications for
userspace is that the priority+exclusive behavior also suppresses eventfd
notifications for any subsequent waiters, even if they are priority waiters.
I.e. only the first VM with an irqfd+eventfd binding will get notifications.

And for IRQ bypass, a.k.a. device posted interrupts, globally unique
bindings are a hard requirement (at least on x86; I assume other archs are
the same).  KVM and the IRQ bypass manager kinda sorta handle this, but in
the absolute worst way possible (IMO).  Instead of surfacing an error to
userspace, KVM silently ignores IRQ bypass registration errors.

The motivation for this series is to harden against userspace goofs.  AFAIK,
we (Google) have never actually had a bug where userspace tries to assign
an eventfd to multiple VMs, but the possibility has come up in more than one
bug investigation (our intra-host, a.k.a. copyless, migration scheme
transfers eventfds from the old to the new VM when updating the host VMM).

v3:
 - Retain WQ_FLAG_EXCLUSIVE in mshv_eventfd.c, which snuck in between v1
   and v2. [Peter]
 - Use EXPORT_SYMBOL_GPL. [Peter]
 - Move WQ_FLAG_EXCLUSIVE out of add_wait_queue_priority() in a prep patch
   so that the affected subsystems are more explicitly documented (and then
   immediately drop the flag from drivers/xen/privcmd.c, which amusingly
   hides that file from the diff stats).

v2:
 - https://lore.kernel.org/all/20250519185514.2678456-1-seanjc@google.com
 - Use guard(spinlock_irqsave). [Prateek]

v1: https://lore.kernel.org/all/20250401204425.904001-1-seanjc@google.com


Sean Christopherson (13):
  KVM: Use a local struct to do the initial vfs_poll() on an irqfd
  KVM: Acquire SCRU lock outside of irqfds.lock during assignment
  KVM: Initialize irqfd waitqueue callback when adding to the queue
  KVM: Add irqfd to KVM's list via the vfs_poll() callback
  KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
  sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
  xen: privcmd: Don't mark eventfd waiter as EXCLUSIVE
  sched/wait: Add a waitqueue helper for fully exclusive priority
    waiters
  KVM: Disallow binding multiple irqfds to an eventfd with a priority
    waiter
  KVM: Drop sanity check that per-VM list of irqfds is unique
  KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
  KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
  KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements

 drivers/hv/mshv_eventfd.c                     |   8 ++
 include/linux/kvm_irqfd.h                     |   1 -
 include/linux/wait.h                          |   2 +
 kernel/sched/wait.c                           |  22 ++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  12 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  40 ++++++
 tools/testing/selftests/kvm/irqfd_test.c      | 130 ++++++++++++++++++
 .../selftests/kvm/x86/xen_shinfo_test.c       |  21 +--
 virt/kvm/eventfd.c                            | 130 +++++++++++++-----
 10 files changed, 302 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/irqfd_test.c


base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
-- 
2.49.0.1151.ga128411c76-goog

