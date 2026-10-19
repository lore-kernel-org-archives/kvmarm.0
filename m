Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F434E020F
	for <kvmarm@lists.linux.dev>; Mon, 19 Oct 2026 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416072; cv=none; b=MiOwo/edRtKEALesduFkWvbj4SykPuTo5HKpfY+BSfs1mb4SWa0GA0xAfbjnCY3XVWJLVheUUGF9iUaDvnB7acNDjSVSldT5P1Z09ykPOkvsl/ZrkP9ow6QpVURZ0tzuBaWH3++DE2WN41+CSt8gNQBT/6buj1mKlsSvFFR7hrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416072; c=relaxed/simple;
	bh=oEZCYVkZJ7MChk8kB7z/mT2HN0rQx4gixCr14FuhrgU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nR6MuF76rJPnZT/s6ZZLXYGvaS/NhyMWg/kUY9CDunKpCaibV3HbT38ouZtajNJOHkpxyJjRipUsh/wJVL2oWHueeyyM7jYZJQLenFFRgoDyyWNVyVzZkswUtedzan704mK0xdDBg4/FZhp+wn0oqLFycQoTptRxQopcxL9jCyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q9xvosEG; arc=none smtp.client-ip=91.218.175.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q9xvosEG"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=oEZCYVkZJ7MChk8kB7z/mT2HN0rQx4gixCr14FuhrgU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792416067; v=1; x=1793020867;
 b=Q9xvosEGHrBGdPQtrwCirPVplZXbX6wuys7UVlNjr0n1ZmtIe0NNZV66oKwVryUoxYiig20S
 IBFbS3M/15/SoRL0cXZcRwaH71lJMzk1NfwC0gqE4kSPZWSLdG8zl/CMl8ALSmCYOaSRRkH/PPV
 216uI1oPzHTHNQAc/mrvyLnw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8616446d7d753be6;
	Mon, 19 Oct 2026 13:21:07 +0000
X-Mizu-Trace-ID: 8616446d7d753be6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: Fix stale MTE tags reaching a guest
Date: Mon, 19 Oct 2026 14:21:00 +0100
Message-ID: <20261019132103.3836646-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Three fixes for hugetlb and THP pages that reach an MTE guest without
their tags cleared, so the guest can read whatever tags the pages'
previous owners left.

The first clears the whole of a hugetlb folio before marking it tagged,
rather than only the pages being mapped. The second does the same when
KVM_ARM_MTE_COPY_TAGS copies tags into a page. The third sanitises when
a permission fault installs a THP block, and runs the VM_MTE_ALLOWED
check on permission faults too. A VMM that maps guest memory with
PROT_MTE isn't affected, as faulting that memory into its mapping clears
the tags first. QEMU and kvmtool map it without.

I have a reproducer that reads the previous owner's tag from 511 of 512
pages in each case. With any one patch applied, it reads none in that
patch's case.

Based on Linux 7.3-rc3 (fd73f4a665989; also applies to kvmarm/next
dd0bc00e3e920 with a three-way merge).

Cheers,
/fuad

Fuad Tabba (3):
  KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
  KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
  KVM: arm64: Sanitise MTE tags when a permission fault installs a
    mapping

 arch/arm64/kvm/guest.c | 11 +++++++----
 arch/arm64/kvm/mmu.c   |  7 ++++---
 2 files changed, 11 insertions(+), 7 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.47.3

