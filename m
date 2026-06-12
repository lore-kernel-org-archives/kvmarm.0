Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8B72FDC27
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281456; cv=none; b=ejOc7jCMkFooRm1CyvkNKmTK0vvpXvNjr27jrE8VAW3/Ohta/x7dMZrqKaWxf0pienL3h0AlNRFMNuhTz9UDKLUe/kECoetQIP6cwwIjaVyu3/Ik4nZgubDHgGwwl9Zo2YUQQoVmW/EmgXQfSLTiL3KfH9R84FYMgbJZlgHK248=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281456; c=relaxed/simple;
	bh=EM9fYVOVO5wx0AlxxQX5Z5uY6L8sVXrfM9pNCZ2t61Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hscF2qNXBNNT53d0UvI9OeHJ5sRk/rckMXAMsh8U8ZHUBh8VNQR2Ox0Lmu0MQLpfH2VfvCim6OrGkuk8pRAw8ICpFYl8rp9PNnGfJbb8to6tStsqDUXNDgxEYmcFVPxJRNua/+k7CC0yuLbO/d1VsX1wDQyCFoI0ALBue03cGFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y9ydh+XT; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9ydh+XT"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490cdae130cso6509035e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281453; x=1781886253; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M15/H5SXZ3Wzm+97G4xOFVhr5vUJMWE6LcDVgXk/KoI=;
        b=Y9ydh+XT+0QXu0F1bgShRYpLM+bNGFHC1D7L/pmlVN1O77d5BhVK/ESjtJZFsh6URT
         1z6JvcCPRo9YnoEzrWOXz07DFH8UiUGcv2zAx6zFsn67R/Qn0prT3i348ODrGzUwhzve
         uFnauQTFvACjvqfgUA3RHAcQ96icesihwk48MSywtIjriBMVqBvT+bAnJtg3qleVoFIi
         ULLW4dWLxqWU+j0wYT55UPnR8ii4WoO05rBW6Lnc4iqrpDXTeAQUT4rHbQuOSAW3qmnk
         bfcvnQrY6UmGOWvvvrReN/eEC3syzG7P33BzMrfwhCU9yYklCr590ZuRyDstKfyfazwe
         nl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281453; x=1781886253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M15/H5SXZ3Wzm+97G4xOFVhr5vUJMWE6LcDVgXk/KoI=;
        b=RAGKsJI0XFN+6hfwFfADZYc098pSdkE20nZA4t8+ZvqllcolR9N5ZQi9qE70S1gkie
         br+BT1bDXDOCvRSM8xMoBkH+bi+/CpCj+kSnChDAqJmf2293OhmTKCICOpdlHbWjPzot
         bEkCakJnc6PCRCUPNXBOIceHI+ucSWLbIS6WRTn6dHE2M+qrdTfDpezXSnzIBu3O9wJf
         BZ4LtTGRPc/i4lwKhmC+GIlDEXNZcqgepVdwVxKLrwfzs1eO/KC0h0hwSBJPBHiSvHGX
         iff1UaBj0JW5FNn9j5EnaZkzEqHjGxybXYLCo4pXdC2zczBGtVYR3It+5ASLr4WLFJ1f
         hhoQ==
X-Forwarded-Encrypted: i=1; AFNElJ9FfidR9Ab3rD0tcW+3gW6a1rdfw6JKCNBVSrk9lK7/R6oyMC9k3Fbsp2rtvTABK/QD++/j+XA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywnv3VMxgjlsCWuvMSEyrR0kvo06wCUELR4+Ht5GVnCUE5nmjQT
	Of2vxD8uO/kkYTY8JcYBRDacCiCVSaGbxz2XwCSQ2Zs4WPpyXuIqFD09
X-Gm-Gg: Acq92OGMOS3DQagNWpWvnGYxffwJst62jfAqFuAZqI5GNoUvqApWKSAc1qb3SOqTfmn
	ArtUXHgaaCi/a27IbVb7E0h7vP3XoRCDWSvN3+isnwJF5tNaioWPEK9dgMFUb8xhg79vcycZz34
	COc9iqPMlHCdF4AXVoL8bApIEiNJeu95AqT5aXGv1CqqeKfIzs3mKCBlI7DXly7O6+ABIPfujHI
	dElwbV1zylya3wmvSq+wczFEJK/VCEdaNaWsSS0jwthGqQxPBlDi84cmJSYP14LCmdFT+AH3F5x
	O1dBRla0BJIsGf7ZmESAv9aE1oEVmNtT/zXslwoXLcdp7JjkZmmaUUeuyU62Drh78emvcVwsyb5
	AYQAyVAHPhcT/nc1OiRghMdpwm3e3fChgdluH2RIxhnIjI39pUWgP9Xoi2UIxMIm3d4gPG+lBKu
	zfW62W2Esyh3szhYxO9eMxLuCdyna1q+JY1kSXNyNlcJrXEOjvynvFpVvOuMxeyg==
X-Received: by 2002:a05:600c:348b:b0:490:e5c1:b89e with SMTP id 5b1f17b1804b1-49220061e38mr2167415e9.10.1781281452911;
        Fri, 12 Jun 2026 09:24:12 -0700 (PDT)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95c51dsm57620935e9.1.2026.06.12.09.24.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jun 2026 09:24:12 -0700 (PDT)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	corbet@lwn.net,
	vladimir.murzin@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	isaku.yamahata@intel.com,
	Jack Thomson <jackabt@amazon.com>
Subject: [PATCH v5 0/5] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
Date: Fri, 12 Jun 2026 17:23:48 +0100
Message-ID: <20260612162354.73378-1-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Hi,

This series adds arm64 support for KVM_PRE_FAULT_MEMORY, which was added
for x86 in [1]. The ioctl allows userspace to populate stage-2 mappings
before running a vCPU, reducing the number of stage-2 faults taken in
the run path. This is useful for post-copy migration, where stage-2
fault latency shows up directly in memory-intensive workloads.

On arm64, the GPA supplied to the ioctl is treated as an IPA in the
userspace-owned VM's memslot address space. If the vCPU most recently
ran a nested guest, KVM still targets the VM's canonical stage-2. It
does not interpret the GPA as an L2 IPA, and does not try to populate
the nested/shadow stage-2 selected by the vCPU's last run state.

The patches are:

 - Allow callers of kvm_pgtable_get_leaf() to pass walk flags, so the
   prefault path can walk stage-2 under the MMU read lock.

 - Add arm64 support for KVM_PRE_FAULT_MEMORY.

 - Enable pre_fault_memory_test on arm64.

 - Add a backing-source option to pre_fault_memory_test.

 - Add a nested (NV) selftest that prefaults on a vCPU whose last-run
   context is backed by a shadow stage-2 MMU with an empty nested
   stage-2 root.

The prefault flag and page_size output in the stage-2 fault descriptor
remain in this series so the arm64 implementation can advance by the
mapping granule installed by the fault path and report poison without
queueing a SIGBUS.

Tested with pre_fault_memory_test under an arm64 QEMU setup with
anonymous, shmem, anonymous_thp, anonymous_hugetlb and shared_hugetlb
backings, including 64K, 2M and 32M hugetlb pools, and with the new
nv_pre_fault_memory_test on an NV-capable setup.

=== Changes since v4 [2] ===

 - Reworked nested virt semantics: arm64 now treats the ioctl GPA as the
   VM/memslot IPA and always targets the canonical stage-2. It no longer
   translates an L2 IPA through L1's stage-2.

 - Documented the arm64 nested behavior in the KVM API text.

 - Switch to the canonical stage-2 with the vCPU put/load helpers when
   the vCPU last ran with a nested/shadow MMU, keeping VMID, VNCR and
   shadow-MMU refcount state consistent.

 - Split the kvm_pgtable_get_leaf() walk-flag plumbing into a prep patch
   and walk existing mappings with KVM_PGTABLE_WALK_SHARED under the MMU
   read lock.

 - Tightened prefault fault handling: preserve fault info, set IL in the
   synthetic ESR, handle existing mappings, return -EAGAIN for invalid
   memslot races, and report -EHWPOISON without queueing SIGBUS.

 - Avoid directly walking stage-2 page tables when pKVM is enabled.
   Protected VMs remain unsupported via -EOPNOTSUPP.

 - Preserve the selected selftest memory backing when recreating the
   racing memslot.

 - Add the nested (NV) prefault selftest, including an empty nested
   stage-2 root to catch accidental L2-IPA interpretation.

=== Changes since v3 [3] ===

 - Return -EOPNOTSUPP for protected VMs.

 - Reworked nested-vCPU handling to translate an L2 IPA through L1's
   stage-2. This has been superseded by the canonical VM-IPA semantics
   described above.

 - Make page_size unsigned and keep local declarations ordered at the
   top of kvm_arch_vcpu_pre_fault_memory().

=== Changes since v2 [4] ===

 - Update the synthetic fault info. Thanks Suzuki.

 - Remove the selftest change for unaligned mmap allocations. Thanks
   Sean.

[1]: https://lore.kernel.org/kvm/20240710174031.312055-1-pbonzini@redhat.com/
[2]: https://lore.kernel.org/linux-arm-kernel/20260113152643.18858-1-jackabt.amazon@gmail.com/
[3]: https://lore.kernel.org/linux-arm-kernel/20251119154910.97716-1-jackabt.amazon@gmail.com/
[4]: https://lore.kernel.org/linux-arm-kernel/20251013151502.6679-1-jackabt.amazon@gmail.com/

Jack Thomson (5):
  KVM: arm64: Pass walk flags to kvm_pgtable_get_leaf()
  KVM: arm64: Add pre_fault_memory implementation
  KVM: selftests: Enable pre_fault_memory_test for arm64
  KVM: selftests: Add option for different backing in pre-fault tests
  KVM: selftests: Add nested pre-fault test for arm64

 Documentation/virt/kvm/api.rst                |  18 +-
 arch/arm64/include/asm/kvm_pgtable.h          |   5 +-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  10 +-
 arch/arm64/kvm/hyp/pgtable.c                  |   5 +-
 arch/arm64/kvm/mmu.c                          | 164 +++++++++++++-
 arch/arm64/kvm/nested.c                       |   2 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../kvm/arm64/nv_pre_fault_memory_test.c      | 200 ++++++++++++++++++
 .../selftests/kvm/pre_fault_memory_test.c     | 150 ++++++++++---
 11 files changed, 513 insertions(+), 45 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c


base-commit: 98f826f3c500fda08d51fca434b7aefa6a2f7076
-- 
2.43.0
