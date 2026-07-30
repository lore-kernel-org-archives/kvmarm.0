Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E0731E838
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439153; cv=none; b=dQv2GuNLVTtJiJe6jaB7deXDqAKd4AwSYAuKHmbLYyW5iwXIxy6QziOkvZ8b6iXCnE3fZqPWbyN5Bk+HRjpszqYEwfmCkZmbuZadRtWiAo1do8zoYWr+13o1vpU7O5hPu/Um9Xxp12VO3JsWeqU6kLK6FJknfKkNDj1DeYFtp1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439153; c=relaxed/simple;
	bh=vJI6IRp585rLpVefO/o6CIA9NTunPTJN6oA97uyDbvM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YAoRUcK7LaTA0LGvsjoYmVUmQRMU2ZWM/rVrzji9hKLNra29LF9AXORMZaFTrDUXb92sAgL+QoIk5FV/t0OOmQjbgSD8BRUv1gvkvKFV8Mo//MCa3agpBEKHw4LRVPrgol35rR1t3uf/eBncyJpdBXEMbuD58fGoS5Ok/zDud/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMWn++t3; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMWn++t3"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cb7d6ba548eso151091a12.1
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 12:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785439150; x=1786043950; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8xSibPGaP79RuMf+7+dDUpouwIkheHJF/igrm5r11hc=;
        b=JMWn++t3yUruX4voNR4eqlFxARY2ob2SYTcm852b7mCA8c1U9/ngBbjP4PIcBr9bFP
         qLqWzBQKNfaG56bAB+0JTiqd58nHrDIzC+E5deDE5i53SmnMsw+X7i2r5lyTauiu7DM7
         DcPp6xK33T15Xyww+q2MSp2ix1eASfKvOXHayqSJT1WivgNn6tqSTCcgI7gHBiKQ7UIa
         aXi3YVmn7dBA0iYtCL/5cxb1YcMdZgAc0QKwzyePIrb6pn8wOo43c794C+t6sWpzJ5q4
         9mdvEcCz49NEroi3F7V+pKrM1jjf68kA/Fc4GnDMQ8cHAGyi+xW/JIwtt3WbpkeJqgxF
         KT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785439150; x=1786043950;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8xSibPGaP79RuMf+7+dDUpouwIkheHJF/igrm5r11hc=;
        b=Tbpdlv5TSHqw+IcTlvxs07TTNvBVfNobAT8JLw3eAWgWBhy4AGNQXrm3JrnvVSvn0l
         aukO9qk6C9dSQijAXpoSFt/CRAaKKoU6K1m5/LaoKZ4qJFBTfKPbYZmk8CvWH83KGUzS
         svG1AKSgRpLk5ZDPO1szfAHKojJvnmN6ntHuwKnljYyVKb4O96f7Q+0+TzpnU2MdfonE
         7fYxpvVdTMrjEMlwu2ASzugoj00LiTUyMOEloSDQR/TwNzYG9s24lBznfD8ZyfSEGZJ2
         2PXFWijyvY0P7LRA/HQNKqKquV7/1apx5s51wO54fIhbiIqiF6Lkg0w/Lt+GCfXmZPkM
         4VGA==
X-Forwarded-Encrypted: i=1; AHgh+RpOY6POuPa4ppPc5NtkMDKm7xyQ322RFnsVaLEkGq+WoY6gVHep+xojcXy4oerKKNfC1Ucba2I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4wcTbItRD9GNPavjIi0lrR08W6ZHZSqQC67ecKwtD1ps7FCeZ
	emR0ZQMUbHPnMF6E9TH33rxEgPhGcDcJn3TVo5GabKqjHIWjnunihnd8fO6dhSFvNCxL4I2Noaw
	aZHLYKg==
X-Received: from pggi13.prod.google.com ([2002:a63:cd0d:0:b0:c85:db34:d7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:117:b0:3c0:9c1a:8939
 with SMTP id adf61e73a8af0-3c90d6ce7e8mr1439109637.65.1785439149929; Thu, 30
 Jul 2026 12:19:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Jul 2026 12:18:59 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260730191908.2084803-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: selftests: Add more syscall wrappers, fix hardware_disable_test
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

Buried in the middle of this is a fix for the hardware_disable_test where
it can end up with a runtime of multiple minutes on preemptible kernels due
to blindly pinning 68 spinning tasks to pCPUs 0-4, which is "mildly"
problematic if the parent is also affined to those CPUs (or the scheduler
keeps trying to run the parent on those CPUs for whatever reason).

After wasting almost half a day bisecting the kernel to the auto-enablement
of PREEMPT_LAZY, I got fed up with the test and went scorched earth on it,
to try and clean up its many warts.

The vast, vast majority of the changes are adding kvm_xxx() syscall wrappers
so that tests don't need to manually assert that a syscall succeeds (the
hardware disable test had some ugly equivalents).

Note, this somewhat unfortunately applies on top of the bad-in-hindsight
"irq_test" branch in kvm-x86, as I didn't want to re-invent the "pick a
random CPU from a cpuset" functionality.  Luckily, AFAICT none of the nearly
tree-wide changes conflict with anything else that's in-flight in other
KVM arch trees, so I'm planning on smashing the "I'm Feeling Lucky" button
on this and throwing it on top of the irq_test (though I'll rename the branch
so it's not completely ridiculous).

Tested on x86 and arm64, compile tested on other architectures.

Sean Christopherson (9):
  KVM: selftests: Return the target CPU from pin_task_to_random_cpu()
  KVM: selftests: Extract picking of random CPU from cpu_set_t to
    separate API
  KVM: selftests: Affine child tasks to other pCPUs in hardware disable
    test
  KVM: selftests: Drop unreachable, dead code from hardware disable test
  KVM: selftests: Add KVM syscall wrapper for pthread_create()
  KVM: selftests: Add KVM syscall wrappers for pthread_{cancel,join}()
  KVM: selftests: Add helper APIs to cancel+join pthreads
  KVM: selftests: Add KVM syscall wrappers for
    pthread_{g,s}etaffinity_np()
  KVM: selftests: Clean up global constants in hardware disable test

 tools/testing/selftests/kvm/arch_timer.c      |  18 ++--
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  14 +--
 .../selftests/kvm/arm64/vgic_lpi_stress.c     |   8 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   4 +-
 .../selftests/kvm/hardware_disable_test.c     | 101 ++++++++----------
 .../selftests/kvm/include/kvm_syscalls.h      |  47 ++++++++
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
 tools/testing/selftests/kvm/rseq_test.c       |   6 +-
 tools/testing/selftests/kvm/s390/memop.c      |   4 +-
 .../selftests/kvm/set_memory_region_test.c    |   6 +-
 tools/testing/selftests/kvm/steal_time.c      |   6 +-
 tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  32 ++----
 .../selftests/kvm/x86/hyperv_tlb_flush.c      |  30 +-----
 .../kvm/x86/private_mem_conversions_test.c    |   4 +-
 .../kvm/x86/private_mem_kvm_exits_test.c      |   7 +-
 .../selftests/kvm/x86/recalc_apic_map_test.c  |   5 +-
 .../selftests/kvm/x86/sev_migrate_tests.c     |   4 +-
 .../selftests/kvm/x86/sync_regs_test.c        |   5 +-
 .../selftests/kvm/x86/tsc_scaling_sync.c      |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |  31 +-----
 .../selftests/kvm/x86/xen_shinfo_test.c       |  10 +-
 30 files changed, 179 insertions(+), 225 deletions(-)


base-commit: 3c7d7f908d574277a845423ec32250a8d8df44c8
-- 
2.55.0.508.g3f0d502094-goog

