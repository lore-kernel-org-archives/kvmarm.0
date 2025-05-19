Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6444020B1FC
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680921; cv=none; b=jkLcsDGu2tZ+3KvstypDpdy4Rzt0pKzOlHL/nKeLFzE+uxDxLb1lCQTVXKrg+jDqzRS8JU1HZhqa9uCeyqDS9HRebun5xVKT2Cu+z6VTnOjan+HCLDymkV0oXLG6cxYa2wkdttZLudSBJKsnqpwvq7uSImoDHXAYtIK8F3pHCT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680921; c=relaxed/simple;
	bh=nP8MRWpIXVcQgjDcQiZLkDJeO5oiTxgWVgZNRHvuMCQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=m2zkhi6i+OyHy305RmjC791Sq5QuynoWarg1hk78WBYD+pR8LwhlNIHD+/s9xgLP2W6pqL8B1sjpvCGu2V7e20iOtpwQ0mDG3i/ASOMPqGHH3Frz0Jtca1CjCbTEf5EzVSN7mvd6Z4QNZ6QZZAlNFARLeHMphquk7q/l/OWw93s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lkWp05hP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lkWp05hP"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-22aa75e6653so33161335ad.0
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680918; x=1748285718; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5g0ChK+VU2x5v032q51hIsX3hlUPkCrfaGOtPqHgaN4=;
        b=lkWp05hPjDDX805ZTHIjftF26z8kvHt1UNS4kfRhJcE0HVp5vrcSA1ZsptkerqdH1Z
         RDq9EhbLekrDI0lr4bx3Du4Ay0sVyVialenw+x0S3hsiqlb9yiswUE6TUs5fyielnqeM
         VEOql/bbLAEXl0zH8UoAuZTuicMtMGYjPCr5OnBx6p2ZvBf2fwhM8F+M7HQSvIsWF7te
         0m/w09oG4QTJfl3+/gOmFGBHTs60EfQ0IG6Qk4g8utFiE/43H7BY24tCIKSu4GVbfrPB
         lGEnArwjMbuSpealhOAeExADs4baEEx1dKwsfGZhC8NSYOHbFlMffpde4m6blyELGxij
         miDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680918; x=1748285718;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5g0ChK+VU2x5v032q51hIsX3hlUPkCrfaGOtPqHgaN4=;
        b=WpwqKH0cu3/1dqnvDCzbSi6EAArQ0sIutBwYzSbtzPDbVV1tZcsSc9xv35mXBcH7lx
         qeKjq4ErkJS+vCPTDb9Nb7Ttov4yiT5ahLDbXHnqJIFixB9Zvq/1xl3ZuB+ipa5YJaiJ
         G/SUDNQAejWh3lllJo4wvdEa5idjokDFB5dtyjExq3bmdtSoIt6djqs6dEg2DGRrc4a6
         azSeJymM1/IF36BKHW6ZgOge7U3+bCKddr61W+9nNLzQa/o/nj15ErtxrBVWcJ7CBqhk
         mxq+JnRwKhyFFWw/YOtHvrFtkH/qsd4rH23bpBcimLPUEapr4rKRlkBKEopnlWzEipNr
         uEYw==
X-Forwarded-Encrypted: i=1; AJvYcCULdRRFK+rrivwzITGwxqR34pyUGllPH/ZC7HcHj04+lgnKSzuQwKZSqfF8RZNtR8jXWqJt7VY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMjJGYB/K9I43vVLPepQNHlAG9qiQUMkxstryV9kwPGMx7xeK5
	hOqIexFEg4Hs8mQJBSOovmTPZajzWZ7Oj+ZCBFa7YsizXKLnDXGEQl5ChHKjSgkqVr6Lo3zQume
	JOBUXXw==
X-Google-Smtp-Source: AGHT+IFREGE+bVXqGWSTvcQtoaMDWNnydT+jkDJYEQ3EGIJqIQGkri2TmVqBm1NbHON/mC+PC5tsJfUk/NE=
X-Received: from plpd8.prod.google.com ([2002:a17:903:1b68:b0:230:136b:a034])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5ca:b0:223:f9a4:3f9c
 with SMTP id d9443c01a7336-231d43d5526mr191572235ad.9.1747680918570; Mon, 19
 May 2025 11:55:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:02 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-1-seanjc@google.com>
Subject: [PATCH v2 00/12] KVM: Make irqfd registration globally unique
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Ingo/Peter,

Any objection to taking this through the KVM tree? (6.17 or later)
Assuming no one objects to the KVM changes...


Rework KVM's irqfd registration to require that an eventfd is bound to at
most one irqfd throughout the entire system.  KVM currently disallows
binding an eventfd to multiple irqfds for a single VM, but doesn't reject
attempts to bind an eventfd to multiple VMs.

This is obvious an ABI change, but I'm fairly confident that it won't
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

v2: Use guard(spinlock_irqsave). [Prateek]

v1: https://lore.kernel.org/all/20250401204425.904001-1-seanjc@google.com

Sean Christopherson (12):
  KVM: Use a local struct to do the initial vfs_poll() on an irqfd
  KVM: Acquire SCRU lock outside of irqfds.lock during assignment
  KVM: Initialize irqfd waitqueue callback when adding to the queue
  KVM: Add irqfd to KVM's list via the vfs_poll() callback
  KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
  sched/wait: Add a waitqueue helper for fully exclusive priority
    waiters
  KVM: Disallow binding multiple irqfds to an eventfd with a priority
    waiter
  sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
  KVM: Drop sanity check that per-VM list of irqfds is unique
  KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
  KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
  KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements

 include/linux/kvm_irqfd.h                     |   1 -
 include/linux/wait.h                          |   2 +
 kernel/sched/wait.c                           |  22 ++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  12 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  40 ++++++
 tools/testing/selftests/kvm/irqfd_test.c      | 130 ++++++++++++++++++
 .../selftests/kvm/x86/xen_shinfo_test.c       |  21 +--
 virt/kvm/eventfd.c                            | 130 +++++++++++++-----
 9 files changed, 294 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/irqfd_test.c


base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
-- 
2.49.0.1101.gccaa498523-goog

