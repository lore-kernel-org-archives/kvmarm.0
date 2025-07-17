Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33F2FBFE9
	for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 16:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752769657; cv=none; b=cIAWzDN004m8YIekbnK1Inw6A+tpUHuBoZuuyK1KAz+tBhPzaUtcmbnC7hX1KRV3+NaaHzvMH96KrQ/869mx/6CvUCeE8FYnDS3VSszxiZ0nWf5fuSPuckVHrEl2u7oa17CWV8k5jHIiMGiSiIN2CCR7nmX9Ik7WrhGVt/24eL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752769657; c=relaxed/simple;
	bh=+0x1zy0S03qo82jXuaR7Y3whq0yDR7T832KLnLZp2eY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VHSZWGKfMRdeP30+FBG4Vkkm3tunwE+gEOz+Q7MJy72oXBk8SPbmOowWmnzozVkUDA9JohY58QQL0zq2uZcn0bcQarhZsUouaRZLVs5eBLov5QqZuaNGRzIknHuBsNo3/fIFzK6QJXh/bhXX2HhPPIymwz05RFxIj0poCJdnWF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uMTWvQZF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uMTWvQZF"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45626e0d3e1so9125665e9.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Jul 2025 09:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752769652; x=1753374452; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9GxkDomuTKnU/U/4h3Smw3OTQKzEEzCHfMBIZWnrL0c=;
        b=uMTWvQZFQi3yWnbjHqSursE+czKmBUZ1Ebpnp68Cw/cesGdFb+qMLyBve05+M4pytC
         nyfGZcROmYZvBLBtke97lbNMvuZNuXefNBmbNag+FVLEw1UjW0iPg+iIZm6mrUMsf7lc
         4gQ3m4gLD/dEHG1kk2eT89qfbVv+LaucuMS3i/iSDesXMM40Q3oX3FhtZu3kxUUUhvGP
         bQCdSHfk58/KgMk0/9xJ04ZQpTFw/c4+qlFFgJg0hrMry0l9rU1/+4KfZRDIHNTABtV3
         9yYpC+z+ZM11nt1XOZZbKidUPyhuF7RtF/LJjNwdGY6KLRpgI2qNEdqLCYyUZe0r7KVj
         vR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752769652; x=1753374452;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9GxkDomuTKnU/U/4h3Smw3OTQKzEEzCHfMBIZWnrL0c=;
        b=IZiB9tNYrIsft3jMmrdR9FMFW4fo+ay2X0Uoer56W0f5wExiDJ9BREEffvPowKdLeQ
         X1KnvWvPhdvJN6NGRTpcX6RxMbccRmJw4k9UKMBU0Y4qIi3yzhuIj3cI2ucy1Y/kRYHH
         06qD5YPfsnWGuWXsewYCb9AEUQa0+5ETiuwlsZQ9Zx75ISsctPIjWaUWBxf9w9jUsBbo
         32/1ZqJngM+JM6NP2dfFtsPKRmUwdzgjMuk8RjdlE5U8P2gaTnBl8l8cHp2+VhUmWTvs
         gy82aCKwY8uXNV3dYswQR3fUuXTcNUUqt896t6Zz/6e0gWtYxQJz7/9qiTwZlEXa1ODG
         lP5g==
X-Forwarded-Encrypted: i=1; AJvYcCXbYr7tja8lyBa9SQlV3gwheJGi5Q5OidvgVw4W8iAsmNCWO6jYAUggOQgluguFV1DMnSj/Ki4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwefacMpmF7p5SWxjKC6fdtPQE8cmfjRttONMtzw7/4epk2SfYz
	zpHG1ZyfudcYNuwC6PGA2sYd12nRghXjJqL9IurvhVvgpCw8Y2fdnnhbHtf3RJdV0J4eAL0ap6N
	oUg==
X-Google-Smtp-Source: AGHT+IEhu4qA6vg652/QBhFFjNHvXKlvrSwTMmZI0VU84JrjTsHTn5x/ppQDHEzo18yV64UGdVi4CJUM5g==
X-Received: from wmtk6.prod.google.com ([2002:a05:600c:c4a6:b0:456:f37:ad16])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b2e:b0:43c:f8fe:dd82
 with SMTP id 5b1f17b1804b1-45631f7bc87mr57413625e9.18.1752769652010; Thu, 17
 Jul 2025 09:27:32 -0700 (PDT)
Date: Thu, 17 Jul 2025 17:27:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250717162731.446579-1-tabba@google.com>
Subject: [PATCH v15 00/21] KVM: Enable host userspace mapping for
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

Main changes since v14 [1]:
* Removed KVM_SW_PROTECTED_VM dependency on KVM_GENERIC_GMEM_POPULATE
* Fixed some commit messages

Based on Linux 6.16-rc6

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

* Patches 1-7: Primarily infrastructure refactorings and renames to
  decouple guest_memfd from the concept of "private" memory.

* Patches 8-9: Add support for the host to map guest_memfd backed memory
  for non-CoCo VMs, which includes support for mmap() and fault
  handling. This is gated by a new configuration option, toggled by a
  new flag, and advertised to userspace by a new capability (introduced
  in patch 18).

* Patches 10-14: Implement x86 guest_memfd mmap support.

* Patches 15-18: Implement arm64 guest_memfd mmap support.

* Patch 19: Introduce the new capability to advertise this support and
  update the documentation.

* Patches 20-21: Update and expand selftests for guest_memfd to include
  mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250715093350.2584932-1-tabba@google.com/
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

Fuad Tabba (17):
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
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
  KVM: arm64: Enable host mapping of shared guest_memfd memory
  KVM: Introduce the KVM capability KVM_CAP_GMEM_MMAP
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   2 +
 arch/arm64/kvm/mmu.c                          | 203 ++++++++++++-----
 arch/arm64/kvm/nested.c                       |  41 +++-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  18 +-
 arch/x86/kvm/Kconfig                          |   8 +-
 arch/x86/kvm/mmu/mmu.c                        | 114 ++++++----
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
 25 files changed, 665 insertions(+), 179 deletions(-)


base-commit: 347e9f5043c89695b01e66b3ed111755afcf1911
-- 
2.50.0.727.gbf7dc18ff4-goog

