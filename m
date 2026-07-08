Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FFD4307A9
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 18:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535130; cv=none; b=alh+yMo/Ykq810qlhwwZphkZZnKRDhfUn35qv3Hgk0//XiqMa5YsrRhKMt9Uhc8hBBMh9maAYAgSCSWp25ANHDS5AMLP6uhjs0Gkqaq2k/6Zc4LFISRR3o4QrM1GBUSofVrC1zZ2wufIusJQWNCLoNFf5wOKyOaC2Lyo0CQ4on8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535130; c=relaxed/simple;
	bh=RYx5v18Z5gMilMsvjwdRbOpAmNJ9bj6sLktqRdYL3C8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P2ojMlAv7rReXzooaIBe32uvEHQJhngpZ/ijvsJaNHa5AltqCnZmdPNQUOoR6dEtXmi1xMt8901Rm+D9GHq1XH/oI+wB0AZ7z86xjCZbJ5a4Rg4yTzsaRbMBMfVl2spTphrviaNrsEkg8S/igE8DkmHJlKFu/tiFfN3A2vsQi0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENcKiQkl; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENcKiQkl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783535125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nH70brhKreuaxH7Whw6ZNqLkWsohR1XxsGRTQjLL1OE=;
	b=ENcKiQklMlFU4InOky7hb4tnnQBsdPp4rlpyYbMQ1tn070eflxus/0FBExWz1OqFUYs/Up
	P2yK5rjdfb81nRgMWN/z1oCBhAGqpWnjcVJtmWd6Ei6IFJdR+fbdX1jI3oBrjTccdeGEGL
	73ufJ63OB0joWSW9vba8OOdInAc6Sfs=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH kvmtool v2 0/4] Add guest_memfd support for arm64
Date: Wed,  8 Jul 2026 19:25:06 +0100
Message-Id: <20260708182510.2181857-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v1 [1]:
- Use kvm_userspace_memory_region2 only for guest_memfd slots (Suzuki)
- Check KVM_CAP_GUEST_MEMFD before KVM_CAP_GUEST_MEMFD_FLAGS (Alexandru)
- Close guest_memfd fd after unmapping at teardown (Alexandru)
- Carried Reviewed-bys

Due to popular demand, i.e., Alexandru asking me about it, I repolished my
guest_memfd support series. The one I sent years ago was stale and
over-engineered, so this is a fresh start instead.

This series adds support for backing guest RAM with guest_memfd on
arm64, for non-protected VMs under both regular KVM and pKVM.

The first two patches are standalone fixes in the code this series
builds on: an uninitialized return value in kvm__for_each_mem_bank(),
and doubled newlines in die() messages. Patch 3 adds guest_memfd
plumbing to kvm__register_mem(), using kvm_userspace_memory_region2
only for guest_memfd-backed slots.

A new --guest-memfd option creates guest RAM from a guest_memfd with
mmap support (GUEST_MEMFD_FLAG_MMAP and GUEST_MEMFD_FLAG_INIT_SHARED,
Linux 6.18+), maps it to provide the userspace mapping, and registers
it with KVM_SET_USER_MEMORY_REGION2.

Protected VMs need in-place shared/private conversion of guest_memfd,
which is still in progress in the kernel [2], so --protected rejects
the option.

Based on kvmtool master (ca0ddafa941d).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260706083555.302972-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/

Fuad Tabba (4):
  Initialize the return value in kvm__for_each_mem_bank()
  Remove newline from end of die() aborts
  Add support for registering guest_memfd-backed memory regions
  arm64: Add --guest-memfd option to back guest RAM with guest_memfd

 arm64/include/kvm/kvm-config-arch.h |  5 ++-
 arm64/kvm.c                         | 43 +++++++++++++++++++++-----
 hw/cfi_flash.c                      |  2 +-
 include/kvm/kvm.h                   | 16 ++++++++--
 include/kvm/util.h                  |  1 +
 kvm.c                               | 42 ++++++++++++++++++--------
 util/util.c                         | 47 ++++++++++++++++++++++++++---
 7 files changed, 127 insertions(+), 29 deletions(-)

-- 
2.39.5

