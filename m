Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5822A4399F7
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 10:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787135312; cv=none; b=raTuZyGcxXsWGogWwVpeY5CcpF7iVZkJsFOWJnUqu3SzP6nii4g85632U9NudLWrmYNqnmOLrdBCZHHN5RKZ0Ix5KlzItlJ4zUtRzZhnPW8aaWVnLs3S7cKevRHyRYF6R7AnewcTx+FtSoT9w9GxOelBHUAedSsd+iv8jVrTIOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787135312; c=relaxed/simple;
	bh=YaVhIGIsz8p83eXEbXp+Vqimu9cE0WdJmkMbBsASobQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UCnG12RbEknSB6qXp3pO1ikTBdKCFlDncJhkDGzAffE4a4lpIKgmAa2k7fY8UbsaRO8IH7JOQUDx0TiacOoRTp8inEQoOCw/iqo7jYL/d0m7c+ROIF+13BUCK1UKSEv/vgI0ARoMbuFpL38x14r7JlLODd0xggJGV641YLoDdfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j+/7hSd/; arc=none smtp.client-ip=95.215.58.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j+/7hSd/"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YaVhIGIsz8p83eXEbXp+Vqimu9cE0WdJmkMbBsASobQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787135304; v=1; x=1787740104;
 b=j+/7hSd/yd2P78Bb6G0ncFkcmr7pOaRdq/AgYH7WgEWyW6SNVfnB3VN9U76i/gqHGbnhaDVv
 9vbNLMCbZWmt2+mkU0eVzNr/E1WDxCm/RgejL6vf3csFvRXD/ECbG46WWnxv6P6psvSEnNOYa/u
 a/+v9KPDi+jCWkv4xHAdWDpM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id b8ee4b28d9b81da1;
	Wed, 19 Aug 2026 10:28:14 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Eric Auger <eauger@redhat.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: arm64: vgic-its: Make the ITS table save reliable
Date: Wed, 19 Aug 2026 11:28:05 +0100
Message-Id: <20260819102809.310708-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Marc pointed out on the v2 ITS series [1] that patch 3 fixed the wrong
end of the problem: KVM should drop the collections when the guest
changes the table that described them, rather than validating them at
save time. He also called that patch's -EINVAL a mistake, since it
aborts a save userspace has to be able to issue. This series does both,
following his answers [2] to the two open questions: purge the whole
list, and skip the offending device rather than fail.

vgic_mmio_write_its_baser() now frees the cached devices or collections
whenever the stored register value changes, not only when VALID is
cleared. It tests for a change rather than a write because the ITS
driver rewrites an unchanged GITS_BASER<n> on resume. With that in place
the check patch 3 added is unreachable, so it is reverted, and
vgic_its_save_device_tables() skips a device the table can no longer
address instead of failing the save.

Note that compute_next_devid_offset() now calls vgic_its_check_id(),
which reads guest memory for an indirect table, so the save does 2n
reads rather than n. It stays linear, as the scan stops at the first
reachable successor. Patch 1's Fixes: tag names a v4.15 commit, so it
will be picked up for stable. Drop the tag if that is not wanted.

Patches 1 and 3 apply to v7.2 unchanged, but patch 2 reverts a commit
only in kvmarm/next, so the series is based there.

Tested on QEMU: the new selftest, vgic_irq, vgic_lpi_stress and boots.
Both cases of the new selftest reset and restore the tables they saved,
and both fail without the series.

Based on kvmarm/next (57e7cf13ac26b).

Cheers,
/fuad

[1] https://lore.kernel.org/all/87ecg9owwa.wl-maz@kernel.org/
[2] https://lore.kernel.org/all/86bjaz5s6v.wl-maz@kernel.org/

Fuad Tabba (4):
  KVM: arm64: vgic-its: Free the caches when GITS_BASER changes
  Revert "KVM: arm64: vgic-its: Don't save collections the table cannot
    hold"
  KVM: arm64: vgic-its: Skip unreachable devices instead of failing the
    save
  KVM: arm64: selftests: Add ITS table save tests

 arch/arm64/kvm/vgic/vgic-its.c                |  44 +-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_its_save.c       | 441 ++++++++++++++++++
 3 files changed, 467 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_its_save.c


base-commit: 57e7cf13ac26bf1a3dba6cfa601f7b2481811575
-- 
2.39.5

