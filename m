Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D2E4968E8
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002577; cv=none; b=irLm1wjIDEVemKoM24muMT18Dh1gPUerIQ462IaEle0I+6pocHkmTy9LlsMw+oDokzDOq5dt2DX3FRC5L+OV9Ep4X+izNNL8ZWkRnXa8kX9K3wHyJzqrK5P14n6lWWiL/3t7AlyUzL05tNEBsDeLIdu448/OSZZvPRRR/nPMzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002577; c=relaxed/simple;
	bh=hjgzRuRixsji8jEKTlp+FzYkQ4qNfZ44rOs1Pa2QDhE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=vBtQ2jZ2B/KgldvORNXiy5CYNCU4AoLA2b7v6ffLpep0KhhQHdyndYMAgqoq0yco4E0uOWMx21EkjrZHqvId1I6s9ilRa5kjy4xiZyxeFU5KUDYXYSAVFUjFKQjww4DeKAFfE7IAI7Q8SpYHmFcP9BAk7kFX6KY4/QRR2iGCdcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hcPfanP9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hcPfanP9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95752359D;
	Thu,  2 Jul 2026 07:29:28 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB60E3F673;
	Thu,  2 Jul 2026 07:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783002573; bh=hjgzRuRixsji8jEKTlp+FzYkQ4qNfZ44rOs1Pa2QDhE=;
	h=From:To:Subject:Date:From;
	b=hcPfanP9lfgG7RZ/Gbwj9CacIVyBHBgGEX04YYhJlhPyRK19zIgvpcN0502pkPTeJ
	 A0RPfX+tHgtYvVV44MwVqxDuTpfR765q33yWAtMbaH0IzhU2qEOH15m7aoMHLCQakD
	 vCtqfOOcHNQBN6TmE1QFz3TnvWCAeohrD0tirB6k=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	seanjc@google.com,
	david.hildenbrand@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com
Subject: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
Date: Thu,  2 Jul 2026 15:29:09 +0100
Message-ID: <20260702142912.6395-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory represented by guest_memfd-only memslots
(kvm_memslot_is_gmem_only() is true) is shared with userspace, which can
freely mmap it and access it. The only thing that is preventing dirty page
logging for such memslots is that KVM doesn't allow slots backed by
guest_memfd to have their flags changed; they can only be created and
deleted.

When KVM changes the flags for a memslot, it is possible for one reader
handling a guest fault to observe the old memslot, with the old flags, and
another reader to observe the new memslot, with the new flags. With the way
a guest_memfd file keeps track of the associated memslots, it is impossible
to avoid the WARN_ON_ONCE in __kvm_gmem_get_pfn() when one of the two
memslot pointers that the readers observe doesn't match the memslot pointer
stored in the file bindings.

To get around this, I decided to change the way guest_memfd keeps track of
the associated memslots: instead of an xarray of memslot pointers, use an
xarray which stores the memslot id (id and as_id, to be more precise),
which can be used to search for the memslot in the active memslots array.
Whenever guest_memfd wants to access a memslot, it deferences the
kvm->memslots RCU pointer under the RCU read lock, similar to how guest
faults are handled, or how the MMU notifiers work. All of this is
implemented in patch #1, "KVM: guest_memfd: Use memslot id to keep track of
associated memslots".

Building on that, toggling the KVM_MEM_LOG_DIRTY_PAGES flag for
guest_memfd-only memslots is implemented in patch #2, "KVM: Implement dirty
page logging for guest_memfd-only memslots". This is gated by a KVM
capability because it is a userspace visible change in behaviour.

The capability is also architecture specific, not because this is something
tied to a specific architecture, but because when I was testing the series
on arm64 I realized that the arm64 fault handling code required a minor
change, and I don't know enough about the other architectures to tell if
any changes are needed for them.

Just FYI, this is an RFC so it goes without saying that I'm open to any
suggestions, and I'll redo the whole thing if there's a better solution.

Tested the series using kvmtool on an arm64 machine, with guest_memfd
support added, as well as two command line arguments: --enable-dirty-log
and --disable-dirty-log. The arguments toggle the KVM_MEM_LOG_DIRTY_PAGES
memslot flag, they don't read or otherwise touch the list of dirty pages in
any way. Pushed a branch at [1].

[1] https://gitlab.arm.com/linux-arm/kvmtool-ae/-/tree/guest-memfd-v1-wip4-dirty-page-logging

Alexandru Elisei (3):
  KVM: guest_memfd: Use memslot id to keep track of associated memslots
  KVM: Implement dirty page logging for guest_memfd-only memslots
  KVM: arm64: Allow dirty page logging for guest_memfd-only memslots

 Documentation/virt/kvm/api.rst |   9 ++
 arch/arm64/kvm/arm.c           |  22 +++++
 arch/arm64/kvm/mmu.c           |   3 +-
 include/linux/kvm_host.h       |  15 +++
 include/uapi/linux/kvm.h       |   1 +
 virt/kvm/guest_memfd.c         | 165 ++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c            |  44 ++++-----
 virt/kvm/kvm_mm.h              |  11 +++
 8 files changed, 232 insertions(+), 38 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.43.0

