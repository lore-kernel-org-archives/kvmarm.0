Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976A118F
	for <kvmarm@lists.linux.dev>; Wed, 11 Jan 2023 00:23:23 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1673395412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/eZZc/neLJzaT5SbsrQS+XXWG1igFh8UZKu9r852wV4=;
	b=kjbG7c9LKCmdNB6lZAS8aeSKBdkPzIz9MmWwa9qUOXnoPDiY2a3/vQyF6rO8+1o1ny4axV
	pDPHdlQY7kMikhL0r7jdTXFOr1g95+0iIzMp/MD2+GHTyQqGcAYREugtR7Pa5HIQPlr3ci
	unVSsHaacTs0ITiUYNGZk0gqozaM9dI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/5] KVM: arm64: Handle unaligned memslots in kvm_(test_)_age_gfn()
Date: Wed, 11 Jan 2023 00:02:55 +0000
Message-Id: <20230111000300.2034799-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There is no requirement for userspace to align KVM memslots to an
appropriate boundary for the backing memory source. For example,
userspace could choose to use 2M THP and place the memslot at a 4K
offset within the hugepage.

Under these conditions, KVM can only map at the 4K level, effectively
shattering the hugepage into a table of PTEs.

kvm_(test_)_age_gfn() operate on the assumption that the GFN range is of
a single page or hugepage size. Furthermore, this assumption bleeds into
the table walkers, which walk until reaching the first leaf PTE.

This completely falls apart in the aforementioned example where the
memslot is unalgined, as there could be many leaf PTEs that need to be
visited for a single hugepage. Furthermore, this configuration can lead
to the WARN in kvm_age_gfn() firing as well.

This series addresses the issue by rejigging the related page table
walkers to traverse a specified range of memory. I also roped in some
cleanups that I did along the way (i.e. patches 1 and 5), but can easily
respin w/o them if desired.

Tested on Ampere Altra w/ kvmtool and KVM selftests. I was going to
implement a reproducer for the issue in KVM selftests, but there is a
significant amount of idiot-proofing around the memslots helpers that
prevent an unaligned memslot. Might get back to that when I have more
patience for it.

Applies to 6.2-rc3.

Oliver Upton (5):
  KVM: arm64: Hoist S2 PTE definitions into kvm_pgtable.h
  KVM: arm64: Add a mask for all leaf PTE attributes
  KVM: arm64: Only return attributes from stage2_update_leaf_attrs()
  KVM: arm64: Correctly handle page aging notifiers for unaligned
    memlsot
  KVM: arm64: Consistently use KVM's types/helpers in kvm_age_gfn()

 arch/arm64/include/asm/kvm_pgtable.h | 66 +++++++++++++++++++----
 arch/arm64/kvm/hyp/pgtable.c         | 79 ++++++++--------------------
 arch/arm64/kvm/mmu.c                 | 18 +++----
 3 files changed, 88 insertions(+), 75 deletions(-)


base-commit: b7bfaa761d760e72a969d116517eaa12e404c262
-- 
2.39.0.314.g84b9a713c41-goog

