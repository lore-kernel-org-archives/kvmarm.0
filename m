Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C328416878;
	Fri, 24 Jul 2026 09:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886106; cv=none; b=ijtFgbP0QOgd9U10ryETON+2NolAHeRDG7GRoNg0B7aZ7ZE0RLPUl90pEViK6dBZZEPeMhmFvZEaP897g18usJ0FUjdbn650dwQL/jQ+99Zy41NsNxolvpsMFhfc3zGmfCylqEW9X0Ew2VZSDIOb4uZkwOR+QzHxraeYH3+Z7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886106; c=relaxed/simple;
	bh=f5CcZqphHBrvD7a007cTCKmcn7WQevg0a7HgyWWOquQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qr/h/4Z/qvpUemDT52rl86F9DiTr8tDVSb+yq8/zPWuwqxDkPNlzcbC9At2x+DSa+ZLxMqmx6GwU7gfzFFnyLevM8xRcBCuWHF8SUGuH+AWjVQD5LEObYG3ZLFrZlORft+SIfT5OPYnytoNhVaIWB4dXZxqY2UY2syJBixZU4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=sISHttSO; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="sISHttSO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784886104; x=1816422104;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f5CcZqphHBrvD7a007cTCKmcn7WQevg0a7HgyWWOquQ=;
  b=sISHttSOekpi3jtFyUO/Q2h11ftJb+8ChEhfbEh3eqJxPprXdMZjJt9o
   /WY649NWRP1O6QTfis17WH/hgng+nkr862UundSpVNodHgG8WKI+ph/xT
   EOA+pYDKAQUzs2yhfJPNma2yV67YcikdFXpMAzG1zlG56XC/UcC3j1uLl
   CYng9bMp5cYG8jU9hm0UQtzZQeR7Kn0SUm3RbEShXY4CWd5yr2LIq8kzS
   ZlfWSYXl7uDiPfk9rMHEAY2RlGoYUhnrUvzUXh0XO5tKThAR7f6a6jtJD
   5P1kHuFHSxU5eVYAwZCU2o4ZwijcQe4D4Mtt0Jm56OLTH7p17yGg1j4Rn
   g==;
X-CSE-ConnectionGUID: FTk6eSvcQoe4vZRgaWU8sA==
X-CSE-MsgGUID: 9rIm4T7ZTOilQXPn7oyDYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="248480914"
X-IronPort-AV: E=Sophos;i="6.25,182,1779116400"; 
   d="scan'208";a="248480914"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 18:41:36 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 51E561002B81;
	Fri, 24 Jul 2026 09:41:36 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 0E09B826790;
	Fri, 24 Jul 2026 09:41:36 +0000 (UTC)
Received: from sm-arm-grace07.ssoft.mng.com (unknown [10.124.178.20])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTP id 53FB7405A97;
	Fri, 24 Jul 2026 09:41:30 +0000 (UTC)
From: Kohei Enju <enju.kohei@fujitsu.com>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	cgroups@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Steven Price <steven.price@arm.com>,
	Kohei Enju <enju.kohei@fujitsu.com>
Subject: [RFC PATCH v1 0/2] KVM: arm64: CCA: Add MEC policy support for CCA Realms
Date: Fri, 24 Jul 2026 18:40:54 +0900
Message-ID: <20260724094120.166536-1-enju.kohei@fujitsu.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds basic support for configuring the Memory Encryption
Context (MEC) policy for Arm CCA Realms.

Patch 1 introduces a new Realm VM ioctl, KVM_ARM_RMI_CONFIG, and uses it
to let userspace select the shared or private MEC policy before the
Realm is created. The default remains the shared MEC policy.

Patch 2 adds a misc cgroup resource for CCA MECIDs and charges one unit
for each Realm using the private MEC policy.

Feedback on the proposed KVM ABI and on using misc cgroup for MECID
accounting would be appreciated.

This series is based on Steven Price's CCA host series [0] [1]. I am
sending it as an RFC while the CCA host series is not yet upstreamed,
and plan to update it as needed to track future revisions of the host
series. Once the host series is merged, I plan to post a non-RFC
version.

[0] https://lore.kernel.org/all/20260715142841.80544-1-steven.price@arm.com/ 
[1] https://gitlab.arm.com/linux-arm/linux-cca  cca-host/v15

Kohei Enju (2):
  KVM: arm64: CCA: Add support for configuring the Realm MEC policy
  cgroup/misc: Add support for Arm CCA MECIDs

 Documentation/virt/kvm/api.rst   | 29 +++++++++++++
 arch/arm64/include/asm/kvm_rmi.h |  6 +++
 arch/arm64/kvm/arm.c             |  9 ++++
 arch/arm64/kvm/rmi.c             | 73 +++++++++++++++++++++++++++++++-
 drivers/firmware/arm_rmm/rmi.c   | 12 +++++-
 include/linux/arm-rmi-cmds.h     |  1 +
 include/linux/misc_cgroup.h      |  4 ++
 include/uapi/linux/kvm.h         | 17 ++++++++
 kernel/cgroup/misc.c             |  4 ++
 9 files changed, 152 insertions(+), 3 deletions(-)

-- 
2.43.0

