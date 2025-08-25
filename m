Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB7D245021
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 20:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152387; cv=none; b=Z7eZfv3r8hYbmOsIK41FZLQfVCOo+COjXE0Coh8Vxde8AXnQw3vJAmjkFWSwRDHO8vM3sZQY+4fiFBBj/Rnm47RMbDH5SC/zkSofS7Q47GfdItj1rY/DJxvl0qxKdSAK8XSn9fXK9VGaRFpy/zV1DlkQdUiVohr23mIRoVsmcCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152387; c=relaxed/simple;
	bh=e6UMH6C4QXeee3JknmCO2I9Y/5OAkfG/m9YVXqh8/eg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=V8qI7rquMmMfM2Z/BaEjUUkcPEpWBKwjpNDRXrVKpg9p+leMvVDlbnw23smWcC/RXmEHfb5mezwxjYBjjHJ0v+de/39y3LRVdaXxo7DXIPfSE7SIMVKYxgJZiSMf0BUqSXeUn2b2xdqnnUUrA9BIlvrVqRgO7r0QNih9ZYAhckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f0hSOs/a; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f0hSOs/a"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32515a033a6so3304013a91.2
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 13:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756152385; x=1756757185; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pR7rIORhhha7uQoj/L4UbVHOw9HCPKdRxBVZAbw60c=;
        b=f0hSOs/a40butemYucJdGv+Q2evjXYPBn2ulJaXeGDZRHU3riV3Ap0cdDmJPFGGR41
         1L5IiDzcet0B9Q2CnKr8tny6GT0lkaOZZLiDh/UIMLbFj0vrdzfdtejfNxS2+QyCmh/Z
         ChY+7GhXRKp3oZkbeCl/y+k9K7Mw8Tx6YLE5/r5tai9JaTdnlMrClKuSXAvEIR00Mc/Y
         QBiryzgDonkociG/JVMqVJFGrB+H0Xuy7lubn0+KQTbFeL3NcXi/ltEqorRxmuP+Q+Uf
         xwrlZO6x1RBExq8s8a0kVXgaWDrRdJPfB5e5cAr4o4/+JpmEB6YVjy36Y0j+dkG/bR3+
         7tHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152385; x=1756757185;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pR7rIORhhha7uQoj/L4UbVHOw9HCPKdRxBVZAbw60c=;
        b=WPEMM7Cl4wTX8HhYgxolsrLzfUSlUSsA0GM+yQRcJ4h6qu5M4pHrYIny1ITMvdFlfH
         XnB0b9KjxWtni1x6s/XG9iKnk6rWm6/z1tWJMDJvCqPJwvKlplR5Vuh1MKch4+jyuXad
         WLabKdBcglar5H0oSu4UH3MCkx9G4BRe98DcojV441lDc954MjZf+bqSzndyZIr9ORlI
         ko/yPruT8rZ8vvFW7G0EtwoQJVY7cgf88kOLyNfABadKkhjN0aog7T7HuAopjAqeFeBg
         w8wjG0Hg4evmiTwJfBRWgMbxkWfih3CAdJkYja3c1/5sXtSamPKknjzcG+5bpfGQPqCx
         ozCA==
X-Forwarded-Encrypted: i=1; AJvYcCU9pawOicjoCFyi1rhHILM4ObXMvfw8TqUZUb7Z7hd31RfdQ7rXyoUm5a8gpfEPj689sim8LYU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyU6YzN+kP+LF1cAKihVVOwwi2OQnNc9+HYWkvDF7Ab5d7xPVr6
	3xom9O/5H/GRk4GTLvwwl/Y1fIItH3LSSi+ZDtFyuk//pK92UfHn9hojynHPLveZMfFUaWLvyII
	iwmV2Mg==
X-Google-Smtp-Source: AGHT+IEXEoKFvYTs3DYHIb6MyIfVoxfIwlslpUf6Y9Z1lNFDWyuIZVc83JO2uwlvd4IbE+BY+ZPFpeZDEbc=
X-Received: from pjkk5.prod.google.com ([2002:a17:90b:57e5:b0:325:9fa7:5d07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ccd:b0:324:eac4:2968
 with SMTP id 98e67ed59e1d1-32515ee13cdmr17210596a91.33.1756152385445; Mon, 25
 Aug 2025 13:06:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 13:06:17 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250825200622.3759571-1-seanjc@google.com>
Subject: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common APIs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
more generic "virt" APIs (which ideally would have been done when MSHV root
support was added).

Assuming all is well, maybe this could go through the tip tree?

The Hyper-V stuff and non-x86 architectures are compile-tested only.

Sean Christopherson (5):
  Drivers: hv: Move TIF pre-guest work handling fully into mshv_common.c
  Drivers: hv: Handle NEED_RESCHED_LAZY before transferring to guest
  entry/kvm: KVM: Move KVM details related to signal/-EINTR into KVM
    proper
  entry: Rename "kvm" entry code assets to "virt" to genericize APIs
  Drivers: hv: Use common "entry virt" APIs to do work before running
    guest

 MAINTAINERS                                 |  2 +-
 arch/arm64/kvm/Kconfig                      |  2 +-
 arch/arm64/kvm/arm.c                        |  3 +-
 arch/loongarch/kvm/Kconfig                  |  2 +-
 arch/loongarch/kvm/vcpu.c                   |  3 +-
 arch/riscv/kvm/Kconfig                      |  2 +-
 arch/riscv/kvm/vcpu.c                       |  3 +-
 arch/x86/kvm/Kconfig                        |  2 +-
 arch/x86/kvm/vmx/vmx.c                      |  1 -
 arch/x86/kvm/x86.c                          |  3 +-
 drivers/hv/Kconfig                          |  1 +
 drivers/hv/mshv.h                           |  2 --
 drivers/hv/mshv_common.c                    | 22 ---------------
 drivers/hv/mshv_root_main.c                 | 31 ++++-----------------
 include/linux/{entry-kvm.h => entry-virt.h} | 19 +++++--------
 include/linux/kvm_host.h                    | 17 +++++++++--
 include/linux/rcupdate.h                    |  2 +-
 kernel/entry/Makefile                       |  2 +-
 kernel/entry/{kvm.c => virt.c}              | 15 ++++------
 kernel/rcu/tree.c                           |  6 ++--
 virt/kvm/Kconfig                            |  2 +-
 21 files changed, 49 insertions(+), 93 deletions(-)
 rename include/linux/{entry-kvm.h => entry-virt.h} (83%)
 rename kernel/entry/{kvm.c => virt.c} (66%)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.261.g7ce5a0a67e-goog

