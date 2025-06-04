Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A91553AA
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 05:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749013748; cv=none; b=Bt7MOuDPxxatPDV5sYPRxkPIJ9UpokkZmotSTG979dqiTxOqNufuL27iuUnim0Tf7ljEHSZN/rsaQnfuTB2MUZLaQH+m39fRMaf6aSjG6CqMdmOFhNybLPRfggTV6aAL4W0/geoD9JvsDlG4NQUn3MwONeRK8pd9vpj+BnAIddE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749013748; c=relaxed/simple;
	bh=bXYb3Fv57WgD098ckyuMFMuLy5/rfO9F4rSK52NJVXg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kOm+VMf3DeQey+lBrRgq9wQkPfWn3njg6oTufLDv/jRe8QSTL7+JqyezkgDTK4iZ2qAcjvCwGQ9HSTbvOymph8o9hjOZiVfZ5Np1BNq6VbtOyvVuc26UPKiPsRxb69yY9yUEIF5EF8h2b1tB/A4/VW3jB3BbhpzUq+IQiNjGO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2twtw8sh; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2twtw8sh"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-740774348f6so5434802b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 22:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749013745; x=1749618545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NrHVO1JlSwACRF1JM0S/mT4335rXAQlO0tShDIgF4kg=;
        b=2twtw8shuFzrIRVYlKfoxRJAHAUVErsSQeaDbj5VTcg097IvdFUh1aPQIL0d17+Lgg
         Ef6roOkW/sRD7cpZR8XRWO5m/kFLfU2FUu7xj54tFOGIU/ubS4waREAZmbjQlatn+R3S
         nDEbtsb5MtE4ELNu/EP+myhLcwYZ0uS7ULh1BlwThM0KHPoReh6DmhhfPKeDL7PUzq0u
         i9d0IXYYdHm5bLAqYWL1dduheTuYqm1PJ+2R6fH299hcqEciNBt7Ca6jPQgDgmJMQ0Zt
         ZUe//XTivzLd7H3nXZ2NNQcc75HE7ama1Fo7bZ+e6hA7mBOY7J9tEwQmAMyLVqyxqg8U
         2lAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749013745; x=1749618545;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NrHVO1JlSwACRF1JM0S/mT4335rXAQlO0tShDIgF4kg=;
        b=RMtGBnujuaNhoPbVVsIG2W64YdXyKQLtrIgCVfI6emn5t/qXcgNymGIUWnNPVMt4L5
         +uIv+tVr5CN68j4YzzzicpALAryMuh0e/pb+Xin4Dhk+fu+GbYmoZJTet0GsQ0agFXYx
         IVQabB9bpCqRWoc18QxGyXPTr4WGqWFpD6wFpFygqgi+tlHdpDA1wi0mJGfBYqiCdEUR
         co3bvLxEXAs2Q/RVEFXf3DB84BtXlxlnOcUW89FdZmMo8nVrHRWjwVpSmwNnbjL94OK0
         wkefrZuz6IQtR1TtFKQuGqVM+OS6uxLLKg6Ae2imFyRU5Kx+LVKzOKdfICJS6F+OKrTm
         ABRg==
X-Forwarded-Encrypted: i=1; AJvYcCWtytjWwoULGyVlNRQ9lIi/Ww5Hw/VdF7iBXjoD43Lzptbz2TZYmIU4ZHof0BAC0vzek3pTDQI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUrxHZq/9h6ab2yz44C7g0RQQh2K1I7MAjzEGgT9AjgXEA4Oxb
	5iBcTB1SJceH+tK0QuNxw84GpQjvBnwYiiByZADjniKyP1iCgJb5NVU1SyFWOhJEUekBqfJUE/N
	qszssLQAXNVG0bw==
X-Google-Smtp-Source: AGHT+IEABKtEFFU5liXpEXSptkYGDpsy283hDhs01hedhxVkwnKMuF3CclWqZbgRuZmc+jHI4P4dRe8JCJ2ZzQ==
X-Received: from pgbcq2.prod.google.com ([2002:a05:6a02:4082:b0:b2d:249f:ea07])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:1586:b0:1f5:8e94:2e81 with SMTP id adf61e73a8af0-21d22a6ca78mr2158789637.9.1749013744670;
 Tue, 03 Jun 2025 22:09:04 -0700 (PDT)
Date: Wed,  4 Jun 2025 05:08:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250604050902.3944054-1-jiaqiyan@google.com>
Subject: [PATCH v2 0/6] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Problem
=======

When host APEI is unable to claim synchronous external abort (SEA)
during stage-2 guest abort, today KVM directly injects an async SError
into the VCPU then resumes it. The injected SError usually results in
unpleasant guest kernel panic.

One of the major situation of guest SEA is when VCPU consumes recoverable
uncorrected memory error (UER), which is not uncommon at all in modern
datacenter servers with large amounts of physical memory. Although SError
and guest panic is sufficient to stop the propagation of corrupted memory
there is room to recover from an UER in a more graceful manner.

Proposed Solution
=================

Alternatively KVM can replay the SEA to the faulting VCPU, via existing
KVM_SET_VCPU_EVENTS API. If the memory poison consumption or the fault
that cause SEA is not from guest kernel, the blast radius can be limited
to the consuming or faulting guest userspace process, so the VM can keep
running.

In addition, instead of doing under the hood without involving userspace,
there are benefits to redirect the SEA to VMM:

- VM customers care about the disruptions caused by memory errors, and
  VMM usually has the responsibility to start the process of notifying
  the customers of memory error events in their VMs. For example some
  cloud provider emits a critical log in their observability UI [1], and
  provides playbook for customers on how to mitigate disruptions to
  their workloads.

- VMM can protect future memory error consumption by unmapping the poisoned
  pages from stage-2 page table with KVM userfault, or by splitting the
  memslot that contains the poisoned guest pages [2].

- VMM can keep track of SEA events in the VM. When VMM thinks the status
  on the host or the VM is bad enough, e.g. number of distinct SEAs
  exceeds a threshold, it can restart the VM on another healthy host.

- Behavior parity with x86 architecture. When machine check exception
  (MCE) is caused by VCPU, kernel or KVM signals userspace SIGBUS to
  let VMM either recover from the MCE, or terminate itself with VM.
  The prior RFC proposes to implement SIGBUS on arm64 as well, but
  Marc preferred VCPU exit over signal [3]. However, implementation
  aside, returning SEA to VMM is on par with returning MCE to VMM.

Once SEA is redirected to VMM, among other actions, VMM is encouraged
to inject external aborts into the faulting VCPU, which is already
supported by KVM on arm64. We notice injecting instruction abort is not
fully supported by KVM_SET_VCPU_EVENTS. Complement it in the patchset.

New UAPIs
=========

This patchset introduces following userspace-visiable changes to empower
VMM to control what happens next for SEA on guest memory:

- KVM_CAP_ARM_SEA_TO_USER. While taking SEA, if userspace has enabled
  this new capability at VM creation, and the SEA is not caused by
  memory allocated for stage-2 translation table, instead of injecting
  SError, return KVM_EXIT_ARM_SEA to userspace.

- KVM_EXIT_ARM_SEA. This is the VM exit reason VMM gets. The details
  about the SEA is provided in arm_sea as much as possible, including
  sanitized ESR value at EL2, if guest virtual and physical addresses
  (GPA and GVA) are available and the values if available.

- KVM_CAP_ARM_INJECT_EXT_IABT. VMM today can inject external data abort
  to VCPU via KVM_SET_VCPU_EVENTS API. However, in case of instruction
  abort, VMM cannot inject it via KVM_SET_VCPU_EVENTS.
  KVM_CAP_ARM_INJECT_EXT_IABT is just a natural extend to
  KVM_CAP_ARM_INJECT_EXT_DABT that tells VMM KVM_SET_VCPU_EVENTS now
  supports external instruction abort.


* From v1 [4]:
  - Rebased on commit 4d62121ce9b5 ("KVM: arm64: vgic-debug: Avoid
    dereferencing NULL ITE pointer").
  - Sanitize ESR_EL2 before reporting it to userspace.
  - Do not do KVM_EXIT_ARM_SEA when SEA is caused by memory allocated to
    stage-2 translation table.

[1] https://cloud.google.com/solutions/sap/docs/manage-host-errors
[2] https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@google.com
[3] https://lore.kernel.org/kvm/86pljbqqh0.wl-maz@kernel.org
[4] https://lore.kernel.org/kvm/20250505161412.1926643-1-jiaqiyan@google.com

Jiaqi Yan (5):
  KVM: arm64: VM exit to userspace to handle SEA
  KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
  KVM: selftests: Test for KVM_EXIT_ARM_SEA and KVM_CAP_ARM_SEA_TO_USER
  KVM: selftests: Test for KVM_CAP_INJECT_EXT_IABT
  Documentation: kvm: new uAPI for handling SEA

Raghavendra Rao Ananta (1):
  KVM: arm64: Allow userspace to inject external instruction aborts

 Documentation/virt/kvm/api.rst                | 128 ++++++-
 arch/arm64/include/asm/kvm_emulate.h          |  67 ++++
 arch/arm64/include/asm/kvm_host.h             |   8 +
 arch/arm64/include/asm/kvm_ras.h              |   2 +-
 arch/arm64/include/uapi/asm/kvm.h             |   3 +-
 arch/arm64/kvm/arm.c                          |   6 +
 arch/arm64/kvm/guest.c                        |  13 +-
 arch/arm64/kvm/inject_fault.c                 |   3 +
 arch/arm64/kvm/mmu.c                          |  59 ++-
 include/uapi/linux/kvm.h                      |  12 +
 tools/arch/arm64/include/asm/esr.h            |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   3 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../testing/selftests/kvm/arm64/inject_iabt.c |  98 +++++
 .../testing/selftests/kvm/arm64/sea_to_user.c | 340 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 16 files changed, 718 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/inject_iabt.c
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c

-- 
2.49.0.1266.g31b7d2e469-goog

