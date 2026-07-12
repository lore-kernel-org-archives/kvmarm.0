Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74691FF5E3
	for <kvmarm@lists.linux.dev>; Sun, 12 Jul 2026 14:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783866344; cv=none; b=WvRSU/NGYjw4if5r58SRETUEnqc6adK51T3sOapiwGi9oxOaOx69idgepwrBrXKy+J83RDHU7TLVC/vUQxXizMwRFjUsoTn7OQ+aiLUVmva5NH87ePLRVW/sUqfUpYel0LK/ZlUj4+hYuIwtR61aDc4BSaHTw63n6YmOaYqJKjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783866344; c=relaxed/simple;
	bh=Fs7bpaD2Xsz41zF9kTW6r8cevFPTVVpxDvtTnxDQOzo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mOJjQ5CjNVGCSYmhj/lcjfgQWTKv8daOcqQL4yvmbXsAbeJgQsYYUQqfMzy0p3qYKLWoDkfEujT/5CITZrg6HLod3viSZreE+Hl7BruWZBqPP2674uze8ja1j9n/GvZpeDA13c9yT0luDzYqG2t8Yrei0/jRAIIkdasnAwLD9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pUPLmEYG; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pUPLmEYG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783866340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZvN91iS9stiov8fLhIwSd9j4bRiaFGaxl4YPZ3B5wD4=;
	b=pUPLmEYGBj9NiXgNcTlJdQHnhb9SfSBqKbx87QdC9sE+626LU1TvDL2F4uHs5/ZHya1fUb
	5I6guk7UdZwsp0l8XyTwnK2gePW6p53nydefvaDCBCh2xCU4NZqRWUIIFcHaMBelIQEZRD
	SSLyDhqKLhOsiRxmABdsb06HKPHvtvw=
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
Subject: [PATCH kvmtool v3 0/4] Add guest_memfd support for arm64
Date: Sun, 12 Jul 2026 15:25:32 +0100
Message-Id: <20260712142536.1391557-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Changes since v2 [1]:
- Assert guest_memfd >= 0 in kvm__register_ram_guest_memfd() (Alexandru)
- Don't split line after = sign (Alexandru)
- Disable MTE when --guest-memfd is used (Alexandru)
- Carried Reviewed-bys

Changes since v1 [2]:
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
which is still in progress in the kernel [3], so --protected rejects
the option.

Based on kvmtool master (ca0ddafa941d).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260708182239.1489297-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260706083555.302972-1-fuad.tabba@linux.dev/
[3] https://lore.kernel.org/all/20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com/

Fuad Tabba (4):
  Initialize the return value in kvm__for_each_mem_bank()
  Remove newline from end of die() aborts
  Add support for registering guest_memfd-backed memory regions
  arm64: Add --guest-memfd option to back guest RAM with guest_memfd

 arm64/include/kvm/kvm-config-arch.h |  5 ++-
 arm64/kvm.c                         | 44 +++++++++++++++++++++++----
 hw/cfi_flash.c                      |  2 +-
 include/kvm/kvm.h                   | 17 +++++++++--
 include/kvm/util.h                  |  1 +
 kvm.c                               | 42 ++++++++++++++++++--------
 util/util.c                         | 47 ++++++++++++++++++++++++++---
 7 files changed, 131 insertions(+), 27 deletions(-)

-- 
2.39.5

