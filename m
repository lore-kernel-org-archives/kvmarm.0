Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4968E37B00E
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787294695; cv=none; b=VjfePK0jzbrJZUglc4k5IUHqpp3E8WjTdjabO3s4+I27D6VKauPH54rn3vMZsnZESm8jBGzu8DdeyghfrTVrcvMl88GgrCULCQPeHaJRQobYA2IX9zGfQlisxYcw5rO5ViOskiX/GxlE+FA2iSRfaHyF/T7WMBL5PVcn+7Kg0ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787294695; c=relaxed/simple;
	bh=7kUZ/3+clATTzGfYeY9/JvP0FEHdJchyOMerj2uhDzk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CVTYIM/78degmqWgGITqG3BmMv1/xgLV4fyw2LxSJkyAKBEN7LRYwnUZ0vmqRfgzKZnHDAsOEztd253a4qmQ39a9ub8JB/+O0vtDSmvF4cdYheyNPfao71G32h5WCHqBtYEZeJp9xHSnQmfptIXJHLXMtQf0ZgqtbAaYARx3p/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h+d68IfN; arc=none smtp.client-ip=91.218.175.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h+d68IfN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7kUZ/3+clATTzGfYeY9/JvP0FEHdJchyOMerj2uhDzk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294691; v=1; x=1787899491;
 b=h+d68IfNnOkKYoiger1sCB8mu51rPUDsCw52+G+I2Rqm+f7iSLN0bmzUUtJHb3hikT1JRljb
 NP8gQpAAymWMBvgGLWVGveTVVpEvJLFsBtVXRKIQJFA7fQvq0TxF969YKBmmTN75W5PKq86P4X2
 l8X8+BGN5EmHU/eVZZEgR9PU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 873a31f318a0fe34;
	Fri, 21 Aug 2026 06:44:50 +0000
X-Mizu-Trace-ID: 873a31f318a0fe34
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: arm64: vgic-its: Make the ITS table save reliable
Date: Fri, 21 Aug 2026 07:44:41 +0100
Message-Id: <20260821064445.615838-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v1 [1]:
  - Free the LPI translation cache in vgic_mmio_write_its_baser() too,
    inside the its_lock section. (Eric)
  - Reworded patch 1 to name the register the write is to. (Eric)
  - Rebased onto kvmarm/next.

Marc pointed out on the v2 ITS series [2] that patch 3 fixed the wrong
end of the problem: KVM should drop the collections when the guest
changes the table that described them, rather than validating them at
save time. He also called that patch's -EINVAL a mistake, since it
aborts a save userspace has to be able to issue. This series does both,
following his answers [3] to the two open questions: purge the whole
list, and skip the offending device rather than fail.

vgic_mmio_write_its_baser() now frees the cached devices or collections
whenever the stored register value changes, not only when VALID is
cleared, and drops the translation cache with them. It tests for a
change rather than a write because the ITS driver rewrites an unchanged
GITS_BASER<n> on resume. With that in place the check patch 3 added is
unreachable, so it is reverted, and vgic_its_save_device_tables() skips
a device the table can no longer address instead of failing the save.

compute_next_devid_offset() now calls vgic_its_check_id(), which reads
guest memory for an indirect table, so the save does 2n reads rather
than n. It stays linear, as the scan stops at the first
reachable successor. Patch 1's Fixes: tag names a v4.15 commit, so it
will be picked up for stable. Drop the tag if that is not wanted.

Patches 1 and 3 apply to v7.2 unchanged, but patch 2 reverts a commit
only in kvmarm/next, so the series is based there.

Tested on QEMU: the new selftest, vgic_irq, vgic_lpi_stress and boots.
Both cases of the new selftest reset and restore the tables they saved,
and both fail without the series.

Based on kvmarm/next (aa8e5dc6a7a2a).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260819102809.310708-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
[3] https://lore.kernel.org/all/86bjaz5s6v.wl-maz@kernel.org/

Fuad Tabba (4):
  KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
  Revert "KVM: arm64: vgic-its: Don't save collections the table cannot
    hold"
  KVM: arm64: vgic-its: Skip unreachable devices instead of failing the
    save
  KVM: arm64: selftests: Add ITS table save tests

 arch/arm64/kvm/vgic/vgic-its.c                |  46 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_its_save.c       | 441 ++++++++++++++++++
 3 files changed, 469 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_save.c

-- 
2.39.5

