Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B7128A708
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648816; cv=none; b=M5oBGTRMv5buxO9Srzm99E8yGeH7ILoDbNMxmjitghey73DDXLeHdguMGShbWbFeAm6vBrjXeVQFohgnjhgLc24ip2nni7EEwFpJTlj4RtKHcK1qMLF/MQhSJsznjkxiwSJ5zRQSk0zfKtf93ECDCVYoWILBveqsXqBtHE+v1/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648816; c=relaxed/simple;
	bh=r+XqC7uGn13lAp3H+wBcGZnLyvGZSd2YBfaeiZv4mds=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AKll/bwkJPhtNuJSeQh+JJZ7PvQRgdNJnX6NziaKvS7xw+Nb2PgWQXMBT0vWl8SLNbO3dJ1ojvuaslAf28m12SAb8tMdeN73gP6uajvKkmVnN0abP9SWCgunhLjb0oXCV/5vNkQlzLOVbCnr6k83D1amse7+deZXDYzHJ2Q30Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nuHZaGKQ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuHZaGKQ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a4edf5bb4dso4005877f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 06:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648812; x=1750253612; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rSsJgXVmQFLNXrSUPRm9zqOBDde8bKjGO9WdZWsvbm0=;
        b=nuHZaGKQ+BXxmaSmB0/3AguN8tEKm4M9pcTEasA/eWYjO1MwniUrfKE/AKhrQZ4k/3
         vupIrzwSZgNG2lMNr70AqVonaBJn4SVOFPZlbZDRLEidg9XPSpF1GveuZkHajqvHTbpe
         Zxg4CegyTwAMHgxdAFZpKmB4BTLoGoxVqvXXeoELnzZKKydtKqItjSEaZaXKmaH8mkRI
         2wT/IAjo8Z6RyycWCQKj84DaQYG+Oek2T2sj9GAgJ4envvRF9eDIx6kLt5ptc9yk5rPI
         UfOCZqqQv1kumcJ9fALWvQV3ARcQ8y4C268Xd6SeOs4ubvIUflsLzgAh1WoQMFCLYK8B
         iooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648812; x=1750253612;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rSsJgXVmQFLNXrSUPRm9zqOBDde8bKjGO9WdZWsvbm0=;
        b=MfIIOYk4gwTCdx3mnt9Srb41zf38Dao45OCfQCodceDDAKdw2w/lROnUcAkPsa8kN9
         vMLnEAwbAY8/jDszFdSiCbzxvO+WJfchWiTe/9QTaKMR0jTZqJ7f1JZVNHpUtYqdhwN6
         9Wy7ONtmv2pPanILm5CSShxwrpPZsAamRDR/GUionCXm0W459SzgaV6Kpu8Ly8pNGFyK
         n0uQ3RAQ1IVSSC3mI5QDrcbcn31RWCYJswy6R1laUS2Jshyw6QD8Qjs2ckvaS4txbzwL
         rJSJhXzPp3k+O1IcGU/aLBy2p/72y17VBZnh7AT4hiVdvDiZPk7B5z6XmaJSHiQTPpcq
         Ggng==
X-Forwarded-Encrypted: i=1; AJvYcCWSPU+YdNmbwRaCoNI4iUil7Gb1gxs3saHezRiJv6TSyMd06IGwwe7NlaGvmlKwXTsfSrboz0o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWtqGmmi6FP2Kg2sfTT+jSoX6YphwWTDPp3i3eQECV+ItNxcHQ
	R8GX6c700lrDWeS8xUpQt2esK0AZdppy6ERgSZvogF3AA3O/ABDEhm1pZTTWu7fq3So2haVFXeL
	RMQ==
X-Google-Smtp-Source: AGHT+IGEi4Njnn/PJTVKY9QV/QZh9cv9Pk+XkVMH4dPXzSBVTZZ2YPR7bte2KhD8R7o+Ouq1GEzt+pIysg==
X-Received: from wrs3.prod.google.com ([2002:a05:6000:643:b0:3a5:271e:ad7d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c8:b0:3a4:d83a:eb4c
 with SMTP id ffacd0b85a97d-3a558a43cb0mr2865406f8f.57.1749648812045; Wed, 11
 Jun 2025 06:33:32 -0700 (PDT)
Date: Wed, 11 Jun 2025 14:33:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611133330.1514028-1-tabba@google.com>
Subject: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the host
 for software protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v11 [1]:
- Addressed various points of feedback from the last revision.
- Rebased on Linux 6.16-rc1.

This patch series enables mapping of guest_memfd backed memory in the
host. This is useful for VMMs like Firecracker that aim to run guests
entirely backed by guest_memfd [2]. When combined with Patrick's series
for direct map removal [3], this provides additional hardening against
Spectre-like transient execution attacks.

This series also lays the groundwork for restricted mmap() support for
guest_memfd backed memory in the host for Confidential Computing
platforms that permit in-place sharing of guest memory with the host
[4].

Patch breakdown:

Patches 1-7: Primarily refactoring and renaming to decouple the concept
of guest memory being "private" from it being backed by guest_memfd.

Patches 8-9: Add support for in-place shared memory and the ability for
the host to map it. This is gated by a new configuration option, toggled
by a new flag, and advertised to userspace by a new capability
(introduced in patch 16).

Patches 10-15: Implement the x86 and arm64 support for this feature.

Patch 16: Introduces the new capability to advertise this support and
updates the documentation.

Patches 17-18: Add and fix selftests for the new functionality.

For details on how to test this patch series, and on how to boot a guest
that uses the new features, please refer to the instructions in v8 [5],
but use the updated kvmtool for 6.16 (KVM_CAP_GMEM_SHARED_MEM number has
changed) [6].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250605153800.557144-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[6] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.16

Ackerley Tng (2):
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory
  KVM: x86: Consult guest_memfd when computing max_mapping_level

Fuad Tabba (16):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Rename kvm_arch_has_private_mem() to kvm_arch_supports_gmem()
  KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: guest_memfd: Allow host to map guest_memfd pages
  KVM: guest_memfd: Track shared memory support in memslot
  KVM: x86: Enable guest_memfd shared memory for non-CoCo VMs
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: Enable host mapping of shared guest_memfd memory
  KVM: Introduce the KVM capability KVM_CAP_GMEM_SHARED_MEM
  KVM: selftests: Don't use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mapping is allowed

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 189 ++++++++++++----
 arch/x86/include/asm/kvm_host.h               |  22 +-
 arch/x86/kvm/Kconfig                          |   5 +-
 arch/x86/kvm/mmu/mmu.c                        | 135 ++++++-----
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |   4 +-
 arch/x86/kvm/x86.c                            |   4 +-
 include/linux/kvm_host.h                      |  80 +++++--
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 212 +++++++++++++++---
 virt/kvm/Kconfig                              |  14 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  91 +++++++-
 virt/kvm/kvm_main.c                           |  16 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 19 files changed, 630 insertions(+), 169 deletions(-)


base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.50.0.rc0.642.g800a2b2222-goog

