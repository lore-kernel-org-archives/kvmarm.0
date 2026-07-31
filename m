Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D628C361944
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527778; cv=none; b=Tor9E1TD1x1N7Mf4IXS6prCdtEGooopZ2vKMdg55jiXtmhZNGYhurqsh0Ju/SF7IPWEmjLYxL9vUcNSQxW/3zQKu1qJXt5/1dILTVz1kwcNrm9nn8bBTX4OLDEBbKkXuXWDWGgGc0yP3xNpqSF2VD3Ijcnhc6/gPKyIgNqWxKf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527778; c=relaxed/simple;
	bh=3fYMoDOUaPLH6H3jOqppLqZSunZ2qguFE3mngU72OtU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=brTvuDMLoN4wjtcOHFlv7918dwI39lGcol8E7F+GneEKm6TN6TXPY8LjDjsZhCJZvp3N9nz8VYDuQrl1w5JsQOJ2uHUzjxHLe+EuQ7FpR3CY5o0vNDInVFXGtzfu3rzijd7SvAQh5gSuk6XnoEF3rZtZpU8df6s9zkMdi8ahO4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OIWPONyh; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OIWPONyh"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84e048a801dso1918343b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 12:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785527776; x=1786132576; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gd1m/0mWimKO7o4EYRsTYXZShyBAIYbMepMSGbfxdyY=;
        b=OIWPONyhhbsNWwmZ5WgQVBZzVQJk45JhR2Sz5TGoYk1ZdZA1ktmStbbgyAlSobwlGc
         gPEvDFTabACh+zUi7/AnQjukI99lDN/8y4htbT9Wq53Asp4psm8N5GBHwbiAvEATGN1d
         RBt80xUJ6uH0FQqa2e19NRo2NYTztOM3u5vqYgNzvmtuSoXFDCrSHLq+9GkRtFB2f+DH
         Fv4+J6o/Vj8IN/3dDDSWLaQ0NzcgWz4+/gv2XXG6MDW2eqMqXvMKsni+x7AKToSWSKo6
         CBVm4xI6gVsWiWCrUTuecmth0bTfuY9D/sg90jFZDPLkqmN+3iXV5hK1Nc3bwap4rxzk
         CGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527776; x=1786132576;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Gd1m/0mWimKO7o4EYRsTYXZShyBAIYbMepMSGbfxdyY=;
        b=Cy/62NANLBjsvSb4oJHD3waGM+Pqm14wF//snnYig0m2Zcxm/EmEBFRfb1ZCwz1VWj
         58bxMuyeUvhvcFlZiGhlXATfLtMqgJ+fWoVIOszN6K8BwPppXDYYloTLWk0PTn0WimM+
         RiIjHbGKqf4BBdREZ2Z2qt1s3NtzbJcRdCZ0b1MAm0+/v68dE9E6hJ5O2Oe8aZq8+YFn
         pbI5hZzLJGSdccnh//uOnYx7fsvULtZSWoaVRcJ+SwN4RaCtFZ3Y1LSCpYGQ5Ups0LsT
         reXNqmp93BIJzaQdX8iEssGh/aHriGDGlf9PtzywJcd9RAcyBSlwvMVbyldwCcVigI5v
         5agA==
X-Forwarded-Encrypted: i=1; AHgh+Rrr6KLCaTo+iXI8cbCGi2D4AbKEbmMaRDS8kh4tXQQRGsXdx/+8JCspKWsul2kfXEtiCgtlF84=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw51WTmMN3WxbO8Nk1Ue/KB+RRyLWXsa5K2+FhMm+L1vrvezXeg
	CeHjiAaBQhh7jRsru3f13g9n+giwf+85JJ55Obi76+1aFv01rjqL4KllpIG212kmqfcu5Y7IfJe
	Xc8iTiQ==
X-Received: from pfble14.prod.google.com ([2002:a05:6a00:4fce:b0:84e:530a:923a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4fca:b0:84c:4bf4:10c3
 with SMTP id d2e1a72fcca58-84ee490ac3bmr716956b3a.38.1785527775964; Fri, 31
 Jul 2026 12:56:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jul 2026 12:56:00 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731195612.2697986-1-seanjc@google.com>
Subject: [PATCH v3 00/12] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	David Hildenbrand <david@kernel.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Third time's a charm.  Sorry for the spam.

Buried in the middle of this is a fix for the hardware_disable_test where
it can end up with a runtime of multiple minutes when running a preemptible
kernels on a large NUMA system.  Turns out my analysis/guess in v1 was wrong;
the problem isn't direct CPU contention, it's that letting the workers do any
amount of "real" work on any CPUs leads to pthread_create() slowdowns from
the perspective of the caller.

The vast, vast majority of the changes are adding kvm_xxx() syscall wrappers
so that tests don't need to manually assert that a syscall succeeds (the
hardware disable test had some ugly equivalents).

v3:
 - Key off _GNU_SOURCE, not __USE_GNU. [Sashiko]
 - Clear consumed CPUs from the allowed set. [Sashiko]
 - Assert that settings affinity attributes succeeds. [Sasiko]

v2:
 - https://lore.kernel.org/all/20260731170619.2620845-1-seanjc%40google.com
 - pause() the child after creating workers so as not to busy loop, and to
   maintain equivalent functionality. [Sashiko]
 - Don't bother pinning the parent of immediate child, and instead focus on
   affining workers to their CPUs asap.

v1: https://lore.kernel.org/all/20260730191908.2084803-1-seanjc@google.com


Sean Christopherson (12):
  KVM: selftests: Add a KVM syscall wrapper for sched_setaffinity()
  KVM: selftests: Set threads CPU affinity before doing work in hardware
    disable test
  KVM: selftests: Pre-set threads affinity in hardware disable test when
    possible
  KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
  KVM: selftests: Extract picking of random CPU from cpu_set_t to
    separate API
  KVM: selftests: Affine threads to random CPUs in hardware disable test
  KVM: selftests: Drop unreachable, dead code from hardware disable test
  KVM: selftests: Add KVM syscall wrapper for pthread_create()
  KVM: selftests: Add KVM syscall wrappers for pthread_{cancel,join}()
  KVM: selftests: Add helper APIs to cancel+join pthreads
  KVM: selftests: Add KVM syscall wrappers for
    pthread_{g,s}etaffinity_np()
  KVM: selftests: Clean up global constants in hardware disable test

 tools/testing/selftests/kvm/arch_timer.c      |  18 +--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  14 +--
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |   8 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   4 +-
 .../selftests/kvm/hardware_disable_test.c     | 109 ++++++++----------
 .../selftests/kvm/include/kvm_syscalls.h      |  48 ++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  11 +-
 tools/testing/selftests/kvm/irq_test.c        |   4 +-
 tools/testing/selftests/kvm/irqfd_test.c      |   4 +-
 .../selftests/kvm/kvm_page_table_test.c       |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  10 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |   7 +-
 .../testing/selftests/kvm/memslot_perf_test.c |   4 +-
 tools/testing/selftests/kvm/mmu_stress_test.c |   4 +-
 .../selftests/kvm/pre_fault_memory_test.c     |   4 +-
 tools/testing/selftests/kvm/rseq_test.c       |  12 +-
 tools/testing/selftests/kvm/s390/memop.c      |   4 +-
 .../selftests/kvm/set_memory_region_test.c    |   6 +-
 tools/testing/selftests/kvm/steal_time.c      |   6 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  32 +----
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  30 +----
 .../kvm/x86/private_mem_conversions_test.c    |   4 +-
 .../kvm/x86/private_mem_kvm_exits_test.c      |   7 +-
 .../selftests/kvm/x86/recalc_apic_map_test.c  |   5 +-
 .../selftests/kvm/x86/sev_migrate_tests.c     |   4 +-
 .../selftests/kvm/x86/sync_regs_test.c        |   5 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  31 +----
 .../selftests/kvm/x86/xen_shinfo_test.c       |  10 +-
 30 files changed, 187 insertions(+), 232 deletions(-)


base-commit: 3c7d7f908d574277a845423ec32250a8d8df44c8
-- 
2.55.0.508.g3f0d502094-goog

