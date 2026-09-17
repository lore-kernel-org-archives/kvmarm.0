Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6FD418348
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 09:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636717; cv=none; b=fA13Izx0/u3loVF3LU+3IyPclyQ2DnSRV/pjq1lGyghahy8gC0gVINBkRkCQUScOgpbi1sK/u7HaTPlPTTTHoh5Bp+wRxdVXrlvPJ2FgKHZFyj28RfxjRwjtIzm7bc19bs7VQDOM7NEFz5/KeMVHKf6U9qB3yxW90N024fh2nos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636717; c=relaxed/simple;
	bh=qQPrpFqFbLdTmOWfZG9ZieuKIf9/ArvaIv1uQrUh0t4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hYv/DCLCdsHMDtV19hiZlRzwwePmg7C7y5W9sF2YUSrJCljxELpEZSvnp8EsGPzlVu/FJr0Btiva5yLD/fcfrLTigEfecACLXKn6wf4I8xZ7wx54eT04BrnHks//WyvWmYwryr3+gu2cE51KBdK2hpVrZyUQ/NOuXaHt4zepw5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xQMkT2xm; arc=none smtp.client-ip=91.218.175.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xQMkT2xm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qQPrpFqFbLdTmOWfZG9ZieuKIf9/ArvaIv1uQrUh0t4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789636712; v=1; x=1790241512;
 b=xQMkT2xm7tnXgGB2fvULnHiNzu5QsAHf0o5HzkIm1BohsdAy69q1UcFvkurt2KartI9ENuln
 pQ6VFV78NMeoLoSk6CTRK59B6fkHJuO9Ul86J3u5VenZDu+7ca+T8H0VkuSm+8mkmf7qfV0guy7
 2/S/G+0BbqKQSeTHSgFCH2K4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7de1b4b5002de0bd;
	Thu, 17 Sep 2026 09:18:32 +0000
X-Mizu-Trace-ID: 7de1b4b5002de0bd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	qperret@google.com,
	vdonnefort@google.com,
	martijnbogaard@google.com,
	seiden@linux.ibm.com,
	tabba@google.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/4] KVM: arm64: Honour KVM_VM_TYPE_ARM_IPA_SIZE under pKVM
Date: Thu, 17 Sep 2026 10:18:22 +0100
Message-Id: <20260917091826.2639205-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

pKVM has ignored KVM_VM_TYPE_ARM_IPA_SIZE since it started running
guest stage 2 at EL2 (v6.2): every VM gets the host's IPA limit,
whatever its VMM requested, and an out-of-range request that every
other host rejects with -EINVAL is accepted. This series makes pKVM
handle the type the way KVM does everywhere else, fixes the bugs that
causes, and two found on the way.

Ignoring the type has two consequences I hit while testing the ITS table
save series [1]: vgic_init fails on any pKVM host whose limit exceeds 40
bits, because the addresses it expects a 40-bit VM to reject are in
range; and on a 64K kernel built for 48-bit PAs on a 52-bit part the
host sizes a VM at 52 bits while EL2 gives it 48, so a memslot above
2^48 the host accepts can't be mapped.

Patch 3 is the fix. EL2 takes the IPA size from the VTCR the host
sized the VM with, bounded by the same rule as the host's limit, and
the host-side override goes: the request is range-checked and the VM
gets the size it requested, so the VMM owns the guest's IPA layout on
a pKVM host too, and the host and EL2 agree on it.

The rest supports that. Patch 1 moves the limit rule into a helper EL2
can share. Patch 2 rejects a pgd donation that's page-aligned but not
aligned to its own size, which crashes EL2 today; patch 3 changes how
that size is computed, so the check goes in first. Patch 4 frees a VM
vgic_init and vgic_v5 leak when the GIC probe fails.

A VMM that requests less than the host limit under pKVM, the 40-bit
default type included, now gets that size, and on a host whose limit is
below 40 bits the default type is refused, as it is without pKVM.
kvmtool requests the smallest size its RAM needs, for protected VMs
too, and crosvm requests the limit, so neither places anything beyond
its request.

vgic_init passes with this, its range checks untouched, on QEMU under
pKVM and VHE at 52- and 48-bit host IPA limits. On a 64K/PA_BITS_48 pKVM
host a guest mapping above 2^48 fails without patch 3 and works with it.
On an M4, whose limit is 40 bits, pKVM used to create a VM for a 44-bit
request and give a 36-bit VM a 40-bit stage 2; with this it refuses the
first and bounds the second, as the same machine does without pKVM.

Based on Linux 7.3-rc3 (fd73f4a665989; also applies to kvmarm/next
8476ce1f1e949).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260821064445.615838-1-fuad.tabba@linux.dev/

Fuad Tabba (3):
  KVM: arm64: Move the IPA limit rule into kvm_get_ipa_max()
  KVM: arm64: Honour the requested IPA size under pKVM
  KVM: arm64: selftests: Free the VM when the GIC device probe fails

Quentin Perret (1):
  KVM: arm64: Check PGD alignment when creating a pVM

 arch/arm64/include/asm/kvm_pgtable.h          | 15 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 24 +++++++++++++++----
 arch/arm64/kvm/mmu.c                          |  4 +---
 arch/arm64/kvm/reset.c                        | 12 +---------
 tools/testing/selftests/kvm/arm64/vgic_init.c |  4 +++-
 tools/testing/selftests/kvm/arm64/vgic_v5.c   |  4 +++-
 7 files changed, 44 insertions(+), 21 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

