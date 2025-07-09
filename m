Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F6728505D
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 10:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752058792; cv=none; b=l+vwKTLiEaL8xM6q/BRRbffMbISpTfiR8sN36cJReQkF+yv4CJuZom8L5ttz8ZdMcVGYnMIpyVCMHdXDc5BFVLchS2g48mGynAzUZNzFSBOqNH12BWBaH9g4CKHnyvBl1liC69w9EDWl21mbVtcmYiO07HPI0AH5YNrhLwuXyDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752058792; c=relaxed/simple;
	bh=xXuPW7BNu1kc7MdxI3u1vqsSmr7Hbq2kX0tG6vFVM44=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PgY2rVI9vwjyDDNaRcAe0zv2RoBCAB+GcRfpkv8y+p7oMthOX8llrfBWgseeeLBROsiLWNA82dhpXkaeQn8nl8KcsUmsD98spSOvT8Tse2m1cFgsi9A/ZRscMUHc8vu7b7LEzjloJysegmwhuA1xm9jnXPhJyUTdIGbjUKVV118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D6jfkztQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D6jfkztQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-450de98b28eso3656155e9.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Jul 2025 03:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752058789; x=1752663589; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dnO+KloSGnsCSQpQy5155dfzAZ7oAybktNY4973okqU=;
        b=D6jfkztQ1Q04ZanBndQxroaF8bj4nOmNYFxfZmlWOCz1JiUbiuW2jpT0jqDkVum0wF
         SCeZXK+waoDyMz+wjXY+pOmXoBBVNKBkkqJThHA1GvxV/7//KaN6ihpchQwTiozgy2S0
         MXksyJ+FGuF/Tiqu95FqGIeBRzt4ByUFamVbP91n46a/q/HvsnTG7x8oMyRmH+q8R1If
         jnXDRFLz8TfRFeZWblr8CdRJNhSFzoIF58fW0b3aIiX6QuSZiTUZF8hBj00WIDnttDAH
         T0MQ3EP4iPkqAY5o44/ncPxMMuMJjw+0Y+W8BrBnw4alQqMlCbSVEA740kF9Xx2lrQk5
         N6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752058789; x=1752663589;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dnO+KloSGnsCSQpQy5155dfzAZ7oAybktNY4973okqU=;
        b=LSf7EABmj23qPnWNT4tHdVFRSRXDdjtKEJ5E5AJZSrPtC4HJrPOiBQlXrQHQd5ozk6
         NtnDMm3pL/65QWoJL1O9IEiWPIvHABdjZ2bcwtLDCEYjMpyaINQkeqzgrjhweSQZ9bp7
         AgRbwdSy6ckpLvHqCR/HQ0Q9CNLeQuLVoZnvfbvrfnZST4097Ok7LEJZ76orrSmCBWlF
         7KqV5S7WB3X1XKnk7mfDLLGt6p8pGAHbXBOLA1nrzmNHRwR7E1F1MCqMzJ4ITZ+m3JW9
         zku/bCk6fSI3YUAzpO+IGXT/R3YOt5zOd2ove6EvXaTmbafdaJo09nkOeRf/1o52J3GQ
         iF6A==
X-Forwarded-Encrypted: i=1; AJvYcCWwDiCCWdfrkb1Hzlii5qZh5TMAOXI2oEwSaEApBfIe/m075N0w87/pJJv0QiheWq5RkVgWn14=@lists.linux.dev
X-Gm-Message-State: AOJu0YybBFCUqv3eJHUqudb4zXY4prOaZL/C83dLbj+Shw1nEv+gzcEL
	si8rmWHRJrBzwnEuu0mPsZkAgOflpLJwM+iG/XUboypg42WUDAoeR27ZFEhjYvbyMGpJ+ymOhZg
	pgg==
X-Google-Smtp-Source: AGHT+IH97vlc2PwP5kjBWi2BuUgBLehVgDMNHnMBRqDSahyj4kB6WdLKy5MfyYEnD1QG3au218TPdoT90g==
X-Received: from wmbes22.prod.google.com ([2002:a05:600c:8116:b0:440:5d62:5112])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b0f:b0:453:aca:4d08
 with SMTP id 5b1f17b1804b1-454d545fc59mr18960475e9.1.1752058788528; Wed, 09
 Jul 2025 03:59:48 -0700 (PDT)
Date: Wed,  9 Jul 2025 11:59:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250709105946.4009897-1-tabba@google.com>
Subject: [PATCH v13 00/20] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
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

Main changes since v12 [1]:
* Rename various functions and variables
* Expand and clarify commit messages
* Rebase on Linux 6.16-rc5

This patch series enables host userspace mapping of guest_memfd-backed
memory for non-CoCo VMs. This is required for several evolving KVM use
cases:

* Allows VMMs like Firecracker to run guests entirely backed by
  guest_memfd [2]. This provides a unified memory management model for
  both confidential and non-confidential guests, simplifying VMM design.

* Enhanced Security via direct map removal: When combined with Patrick's
  series for direct map removal [3], this provides additional hardening
  against Spectre-like transient execution attacks by eliminating the
  need for host kernel direct maps of guest memory.

* Lays the groundwork for *restricted* mmap() support for
  guest_memfd-backed memory on CoCo platforms [4] that permit in-place
  sharing of guest memory with the host.

Patch breakdown:

Patches 1-7: Primarily infrastructure refactorings and renames to decouple
guest_memfd from the concept of "private" memory.

Patches 8-9: Add support for the host to map guest_memfd backed memory
for non-CoCo VMs, which includes support for mmap() and fault handling.
This is gated by a new configuration option, toggled by a new flag, and
advertised to userspace by a new capability (introduced in patch 18).

Patches 10-14: Implement x86 guest_memfd mmap support.

Patches 15-17: Implement arm64 guest_memfd mmap support.

Patch 18: Introduce the new capability to advertise this support and
update the documentation.

Patches 19-20: Update and expand selftests for guest_memfd to include
mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250611133330.1514028-3-tabba@google.com/T/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[6] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.16

Ackerley Tng (4):
  KVM: x86/mmu: Generalize private_max_mapping_level x86 op to
    max_mapping_level
  KVM: x86/mmu: Allow NULL-able fault in kvm_max_private_mapping_level
  KVM: x86/mmu: Consult guest_memfd when computing max_mapping_level
  KVM: x86/mmu: Handle guest page faults for guest_memfd with shared
    memory

Fuad Tabba (16):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_KVM_GENERIC_GMEM_POPULATE
  KVM: Introduce kvm_arch_supports_gmem()
  KVM: x86: Introduce kvm->arch.supports_gmem
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: guest_memfd: Allow host to map guest_memfd pages
  KVM: guest_memfd: Track guest_memfd mmap support in memslot
  KVM: x86: Enable guest_memfd mmap for default VM type
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: Enable host mapping of shared guest_memfd memory
  KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 190 ++++++++++++----
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  18 +-
 arch/x86/kvm/Kconfig                          |   7 +-
 arch/x86/kvm/mmu/mmu.c                        | 115 ++++++----
 arch/x86/kvm/svm/sev.c                        |  12 +-
 arch/x86/kvm/svm/svm.c                        |   3 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/main.c                       |   6 +-
 arch/x86/kvm/vmx/tdx.c                        |   6 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |   5 +-
 include/linux/kvm_host.h                      |  64 +++++-
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 208 +++++++++++++++---
 virt/kvm/Kconfig                              |  14 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  96 +++++++-
 virt/kvm/kvm_main.c                           |  14 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 24 files changed, 622 insertions(+), 167 deletions(-)


base-commit: d7b8f8e20813f0179d8ef519541a3527e7661d3a
-- 
2.50.0.727.gbf7dc18ff4-goog

