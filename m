Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666B4224F3
	for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760381950; cv=none; b=H731rNW0QimhcwhCckKc5OoFP2iILdoZuF1DRw5EygMQewA/CltJK5IhlMpnVZ2Qt3UiyaiGH7lQOSQEcKuP0H4vC3CsTWc0a2MyMRtZ1ZiCaJNqbGl+DfZBGbD+GqW/CaSpj5iFD9nOp8GDZfn8iespDXkaCDnTZpnRuZJ2UP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760381950; c=relaxed/simple;
	bh=D2DBVOyfmDfuJQ3NbYBcT2oWdkkwKPWux1rjkEGJ5uE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QEoc6EEA0IJ2eb0kDiujqKgzbV2P+3sMZ0TLpcp5L4KglqGIViDHPsPH7hJKXuzLAZULbeOPTWucCDoWwqrWSIHHPdR90KFjcUA05PqlBM307czOHAyYSaqxipASksDP9v5mpGq290jhBqYT27KzQMPSdu2pf6UdVibyzvn0de4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vYAr485D; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYAr485D"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee4998c50so8728232a91.3
        for <kvmarm@lists.linux.dev>; Mon, 13 Oct 2025 11:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760381948; x=1760986748; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3zyOsXjgR2slTOTUParrmMvaOPp3Y8R1z3YFebNy+kY=;
        b=vYAr485DrAZUModCLsKZN0PDasf3fPrRi53tEljlCLDcOeBD2ASf9V8Q20aIKgciQd
         XEbnoB/M4JVzM6h45oA20sOZOLY1ZpoBPlMPxLsBTowQlEIcauCG4cnsg4txzoZXtNdt
         zWtKt4WsJWYAj9lCsf2CLHZbweYz3NDqymu74lOFKYH3p5BeN3djkXEL8GZCFC+mT238
         4ErDqSsbGG7e3wcECMGeIGIaFbsUFRQVUnxv9nOPEz9v5H3ihn/5gOX2Xlt8tt0Ytm1h
         QGUhV3NorxjB++fJbeKhRC2CAPJ6Hc10lXricVcECHPZjYNgKZ8a45iAbL6nwFfowUCT
         xsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381948; x=1760986748;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3zyOsXjgR2slTOTUParrmMvaOPp3Y8R1z3YFebNy+kY=;
        b=qpHfnvv4WzjiCbdOiRBuJZPp+X/s0aIBX/uz8rLKDzdQx4ktJyJmceBXDBREJRr/6/
         ppChwm8NYLE/DMCdA2O1if/ELPGcuAl7pC+5DS9bXORywy1MBMmYku3EjeQuwH2Z5a1L
         JdUDAX4H28wfTcRfTP2RZd8I3ByluDGarVBWJuwLWTzO6yemIv3HoGj+/UUD+rfivwPC
         JMF4mVS9xkBOOt99dBRlEPcNPMCYW4Jm68bGVAzPykiari1DuEbsAZnEX8q1aG1gL5a7
         tZWMvGCZgWuV3peT9hFXWh7lrt3o5XMpozoSnPOTJDEeEQPSaU0o+I3pnLc4WMoPoJvs
         iRMw==
X-Forwarded-Encrypted: i=1; AJvYcCWlZjikKSQzBFWTK+WXCpVpz57W6mRIdUQvY4IxyVM8QsFNKBjyzV3YhGmZtvUPgI/BgmMIZjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxouW1CYXn1k3ns5jLdNr3V8iMs3w4XQsWjCh0fR5SH1YstZzjo
	dT7blmOxUxuazzEsnZe/Mcg3H+VuFNcY0KA35cgvf+18EHiB5By3/K2oX05E1NYjaQO/xp+Qqn4
	/N5waIdqgEZhJPg==
X-Google-Smtp-Source: AGHT+IFQCZ0F3mAV98Keda3BZRrx76PXArL7t60ZigncnYG4BTa+6j6T70pbIysH6cLO49q77f6O/f7NZYgb1A==
X-Received: from pjbkw19.prod.google.com ([2002:a17:90b:2213:b0:330:8c66:4984])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e82:b0:339:a4ef:c8b9 with SMTP id 98e67ed59e1d1-33b5127ac7fmr33043099a91.17.1760381947731;
 Mon, 13 Oct 2025 11:59:07 -0700 (PDT)
Date: Mon, 13 Oct 2025 18:59:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013185903.1372553-1-jiaqiyan@google.com>
Subject: [PATCH v4 0/3] VMM can handle guest SEA via KVM_EXIT_ARM_SEA
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	vsethi@nvidia.com, jgg@nvidia.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	pbonzini@redhat.com, corbet@lwn.net, shuah@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Problem
=======

When host APEI is unable to claim a synchronous external abort (SEA)
during guest abort, today KVM directly injects an asynchronous SError
into the VCPU then resumes it. The injected SError usually results in
unpleasant guest kernel panic.

One of the major situation of guest SEA is when VCPU consumes recoverable
uncorrected memory error (UER), which is not uncommon at all in modern
datacenter servers with large amounts of physical memory. Although SError
and guest panic is sufficient to stop the propagation of corrupted memory,
there is room to recover from an UER in a more graceful manner.

Proposed Solution
=================

The idea is, we can replay the SEA to the faulting VCPU. If the memory
error consumption or the fault that cause SEA is not from guest kernel,
the blast radius can be limited to the poison-consuming guest process,
while the VM can keep running.

In addition, instead of doing under the hood without involving userspace,
there are benefits to redirect the SEA to VMM:

- VM customers care about the disruptions caused by memory errors, and
  VMM usually has the responsibility to start the process of notifying
  the customers of memory error events in their VMs. For example some
  cloud provider emits a critical log in their observability UI [1], and
  provides a playbook for customers on how to mitigate disruptions to
  their workloads.

- VMM can protect future memory error consumption by unmapping the poisoned
  pages from stage-2 page table with KVM userfault [2], or by splitting the
  memslot that contains the poisoned pages.

- VMM can keep track of SEA events in the VM. When VMM thinks the status
  on the host or the VM is bad enough, e.g. number of distinct SEAs
  exceeds a threshold, it can restart the VM on another healthy host.

- Behavior parity with x86 architecture. When machine check exception
  (MCE) is caused by VCPU, kernel or KVM signals userspace SIGBUS to
  let VMM either recover from the MCE, or terminate itself with VM.
  The prior RFC proposes to implement SIGBUS on arm64 as well, but
  Marc preferred KVM exit over signal [3]. However, implementation
  aside, returning SEA to VMM is on par with returning MCE to VMM.

Once SEA is redirected to VMM, among other actions, VMM is encouraged
to inject external aborts into the faulting VCPU.

New UAPIs
=========

This patchset introduces following userspace-visible changes to empower
VMM to control what happens for SEA on guest memory:

- KVM_CAP_ARM_SEA_TO_USER. While taking SEA, if userspace has enabled
  this new capability at VM creation, and the SEA is not owned by kernel
  allocated memory, instead of injecting SError, return KVM_EXIT_ARM_SEA
  to userspace.

- KVM_EXIT_ARM_SEA. This is the VM exit reason VMM gets. The details
  about the SEA is provided in arm_sea as much as possible, including
  sanitized ESR value at EL2, faulting guest virtual and physical
  addresses if available.

* From v3 [4]
  - Rebased on commit 3a8660878839 ("Linux 6.18-rc1").
  - In selftest, print a message if GVA or GPA expects to be valid.

* From v2 [5]:
  - Rebased on "[PATCH] KVM: arm64: nv: Handle SEAs due to VNCR redirection" [6]
    and kvmarm/next commit 7b8346bd9fce6 ("KVM: arm64: Don't attempt vLPI
    mappings when vPE allocation is disabled")
  - Took the host_owns_sea implementation from Oliver [7, 8].
  - Excluded the guest SEA injection patches.
  - Updated selftest.

* From v1 [9]:
  - Rebased on commit 4d62121ce9b5 ("KVM: arm64: vgic-debug: Avoid
    dereferencing NULL ITE pointer").
  - Sanitize ESR_EL2 before reporting it to userspace.
  - Do not do KVM_EXIT_ARM_SEA when SEA is caused by memory allocated to
    stage-2 translation table.

[1] https://cloud.google.com/solutions/sap/docs/manage-host-errors
[2] https://lore.kernel.org/kvm/20250109204929.1106563-1-jthoughton@google.com
[3] https://lore.kernel.org/kvm/86pljbqqh0.wl-maz@kernel.org
[4] https://lore.kernel.org/kvmarm/20250731205844.1346839-1-jiaqiyan@google.com
[5] https://lore.kernel.org/kvm/20250604050902.3944054-1-jiaqiyan@google.com
[6] https://lore.kernel.org/kvmarm/20250729182342.3281742-1-oliver.upton@linux.dev
[7] https://lore.kernel.org/kvm/aHFohmTb9qR_JG1E@linux.dev
[8] https://lore.kernel.org/kvm/aHK-DPufhLy5Dtuk@linux.dev
[9] https://lore.kernel.org/kvm/20250505161412.1926643-1-jiaqiyan@google.com

Jiaqi Yan (3):
  KVM: arm64: VM exit to userspace to handle SEA
  KVM: selftests: Test for KVM_EXIT_ARM_SEA
  Documentation: kvm: new UAPI for handling SEA

 Documentation/virt/kvm/api.rst                |  61 ++++
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/mmu.c                          |  68 +++-
 include/uapi/linux/kvm.h                      |  10 +
 tools/arch/arm64/include/asm/esr.h            |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/sea_to_user.c | 331 ++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 9 files changed, 480 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/sea_to_user.c

-- 
2.51.0.760.g7b8bcc2412-goog

