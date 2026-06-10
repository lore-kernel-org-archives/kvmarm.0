Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A631F1304
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052823; cv=none; b=izNCM3UBgKp4C5Aq3nspoYq1esFVJJeM3ZONSQdXJtBpldljCTmmCiTcLMwX3lC/h+/dnQCXpcJk0uGBFrCaUjcZ9jeODXb1ffqrktpmFzOJUdAU1tH6fOCFxD/LwHqnR0moXMP9t0+XJuMmeTdsID3JsJk3VL2I/muYxMFZfbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052823; c=relaxed/simple;
	bh=hZc2uFswrNayFNDYFX7KG+zox1SbVBrHAJg1rSy/lTM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cp43f6Ov8YNMEgjhfBASS3nEZPM70kjadB5k099p42lMwF8AGk42O1b7XvdxYoHFdpbiMNrdRA5t97L6ZJuWmJZPwHuMTCaGtlka+Ga8cflfhOyZeHxxS/dxIkEcb93S8K273nnzKI+xrJJFL2/TaXymlIC90/qyGEKW5SOy+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vyhngctZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vyhngctZ"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0c3315d31so66797515ad.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052821; x=1781657621; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2T4JFnvy3isjzB+jWXF2KXb/Imn3RDItMHvYDoBMt3U=;
        b=vyhngctZ1/cSWRoPrIPOjhWUQnYBLxtxiOIAEC7TyfpTbOVTijkQhpDvWVS+srorjd
         imI1iuwPYvXJGqK91dllqSHUj8a6fJWfeDceFmZe1LdOt1tEyX8E6T2Dbg/bzNebnoav
         z0neDUsct80WKfOiPV45qbLt5txw6vtEjAmKN0L1tyIUrpYZHUKM8S4Avy8WLB/KhK30
         A7oIBfdvdScpv3bQesGNi2yVK33/YcX8tfi2iqspfgEqM0pNaP3P4OnahumLVkAUzaJ+
         wI7TlFsafykw6tfSSB6wmup051eAK1Uk7Dkpm4CWVUjWCLlErtoHYdFj5FQ+9PXXom0k
         jdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052821; x=1781657621;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2T4JFnvy3isjzB+jWXF2KXb/Imn3RDItMHvYDoBMt3U=;
        b=XyEkOWOP8orO42JVMIL4XHkGinf2K36yRB8dZerFOfJhM5baRoOH5k2IqeypJy9SD6
         ff2kuUA1nyUxI/FiSoxa1EkPxMVVFBbofwfO2U4qiE+EH7WdJAOR5mQHDfS+EC2FXOye
         LIGeX7V2FCb9/w85Pc9UiKDbc0Zfj3Fena4devZbpAyHSte6ub7492GjdQruJaB6uhvy
         pH61hkVmfQGkHcSvex365UeQV0mUeTpu67UpDVpTIb7zOrCJXuCdklFrpvBmt95kKBE6
         ld8rpOCEU9T7RfQFeHQrEg/OUNK5KabSqNANo9MGWNPbnqjb5PQEKddQRvMqnN3IbqF0
         jg/Q==
X-Forwarded-Encrypted: i=1; AFNElJ8PR3H+6ult1PCW2SXoNTjAyR6q3AiqF6slimcX5kiQwIjHNJ8QQzTZ7wa6noi49/yW6ICsxp0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzN7dcPmMI06e13+mbwcAOQ1vb7MljPIYC3z97+KSIsEQX8rMBV
	RylBBhrEaV2NlaxYpK+0M7vyjj8SianE4LvvppOtTUZ8kfBAKc2T0n4A6XcywSDHnMKlc9wtqDp
	bvguffQ==
X-Received: from plao3.prod.google.com ([2002:a17:903:3003:b0:2be:3026:1d0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:240f:b0:2bc:db35:96c7
 with SMTP id d9443c01a7336-2c1e822121cmr244254735ad.28.1781052821294; Tue, 09
 Jun 2026 17:53:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:20 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-1-seanjc@google.com>
Subject: [PATCH v6 00/18] KVM: selftests: Add eventfd+VFIO IRQ test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

David and Josh's series to add a selftest for verifying interrupt delivery
via eventfd (via KVM_IRQFD), and also from a real device, wired up via VFIO.

I originally wanted to get this into 7.2, but that's not going to happen.  But
I hope to get this applied early in the 7.3 cycle so that additional features
and whatnot can be developed on top without too much pain (hopefully).

Gory details in the patches, and in the v5 cover letter.

v6:
 - Massage most changelogs.
 - Fix SoB ordering issues.
 - Clean up KVM_SET_GSI_ROUTING helper.
 - Remove misleading "IRQ injection" and "emulated eventfd" terminology.
 - Add GUEST_RECEIVED_INTERRUPT() to simplifiy the core loop.
 - Use cpu_relax() in tight loops while waiting for interrupts.
 - Print as much information as possible in the actual assert, instead of
   printing to stdout separately.
 - Make a best guess as to the right VFIO vs. IOMMUFD mode instead of
   assuming IOMMUFD, and give the user the option to overide said guess.
 - Simplify open_proc_irq_smp_affinity_list() +
   write_proc_irq_smp_affinity_list() into proc_irq_set_smp_affinity().
 - Drop print_proc_irq_file() and kvm_print_vcpu_affinity() (for now) to avoid
   potential issues on systems with high CPU counts.
 - Drop the blocking/HLT testing as it was at best broken.
 - Use -e for "empty", not -c for "clear", when completely tearing down GSI
   routing, because routing can be "cleared" without completely emptying the
   routing information.
 - Use the main task's CPU affinity as the available_cpus set.
 - Allow overcommiting vCPUs:pCPUs.
 - Set the target vCPU's affinity instead of batching when vCPU0 is targeted.
 - Add support for 256+ vCPUs with x2APIC.
 - Restrict xAPIC mode to 255 vCPUs.
 - Restrict the test to KVM selftest's max supported vCPUs.

v5:
 - https://lore.kernel.org/all/20260604020143.748245-1-jrhilke@google.com
 - Rename get_proc_vfio_irq_number() to vfio_msix_to_host_irq()
 - Rename open_proc_irq_affinity() and write_proc_irq_affinity() to include "_smp_affinity_list"
 - Print /proc/irq/<irq>/smp_affinity and effective_affinity on timeout failures
 - Convert IRQ type from 'int' to 'unsigned int' across helpers and the test
 - Fix compiler warnings for uninitialized variables in irq_test.c
 - Remove rate-limiting on affinity changes

v4: https://lore.kernel.org/kvm/20260530002134.558837-1-jrhilke@google.com

David Matlack (12):
  KVM: selftests: Build and link selftests/vfio/lib into KVM selftests
  KVM: selftests: Add macros to read/write+sync to/from guest memory
  KVM: selftests: Add an irqfd send+receive (and later IRQ bypass) test
  KVM: selftests: Add helper to get host IRQ from device MSI-X for IRQ
    bypass test
  KVM: selftests: Add VFIO device support to eventfd IRQ test
  KVM: selftests: Verify interrupts are received when IRQ affinity
    changes in IRQ test
  KVM: selftests: Add option to set empty routing between IRQs in
    eventfd IRQ test
  KVM: selftests: Make number of IRQs configurable in IRQ test
  KVM: selftests: Verify non-postable IRQ remapping in IRQ test
  KVM: selftests: Verify vCPU migration during IRQ delivery in IRQ test
  KVM: selftests: Make number of vCPUs configurable in IRQ test
  KVM: selftests: Add xAPIC support in eventfd IRQ test

Josh Hilke (6):
  KVM: selftests: Rename guest_rng to kvm_rng
  KVM: selftests: Add helper to generate random u64 in range [min,max]
  KVM: selftests: Add a helper to set proc IRQ affinity for IRQ test
  KVM: selftests: Add kvm_gettid() wrapper and convert users
  KVM: selftests: Add kvm_sched_getaffinity() wrapper and convert users
  KVM: selftests: Add a utility to pin a task to a random CPU, given a
    CPU set

 tools/testing/selftests/kvm/Makefile.kvm      |   7 +-
 tools/testing/selftests/kvm/arch_timer.c      |   2 +-
 .../kvm/arm64/arch_timer_edge_cases.c         |   2 +-
 .../selftests/kvm/demand_paging_test.c        |   2 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   4 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  11 +-
 .../selftests/kvm/include/kvm_syscalls.h      |   7 +
 .../testing/selftests/kvm/include/kvm_util.h  |  12 +
 .../testing/selftests/kvm/include/proc_util.h |  11 +
 .../testing/selftests/kvm/include/test_util.h |  25 +-
 .../selftests/kvm/include/x86/kvm_util_arch.h |   4 +-
 tools/testing/selftests/kvm/irq_test.c        | 349 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/assert.c      |   8 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  46 ++-
 tools/testing/selftests/kvm/lib/memstress.c   |   8 +-
 tools/testing/selftests/kvm/lib/proc_util.c   |  54 +++
 tools/testing/selftests/kvm/lib/test_util.c   |  27 +-
 tools/testing/selftests/kvm/mmu_stress_test.c |  15 +-
 tools/testing/selftests/kvm/rseq_test.c       |   6 +-
 tools/testing/selftests/kvm/steal_time.c      |  22 +-
 .../testing/selftests/kvm/x86/sev_dbg_test.c  |   2 +-
 21 files changed, 541 insertions(+), 83 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/proc_util.h
 create mode 100644 tools/testing/selftests/kvm/irq_test.c
 create mode 100644 tools/testing/selftests/kvm/lib/proc_util.c


base-commit: de3a35be92d2391ece4bf3143ef2887192625fd0
-- 
2.54.0.1099.g489fc7bff1-goog

