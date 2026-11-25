Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795574686;
	b=WmCDen8hGaXX3JBOgFdeQceaaBFPOtBlNiLASsbN9A2TMU6p4ygzDBAMEO7/BtNL62+6
	 1SF7wp09aNvDURr2vS8+7D4Z/mNl/L2FrCT5dB+MCIs+vtfBOktm9LgkRyyJf+GLTyx5d
	 fiErTN+MNpm5N0lcHIatTihQ4qSY6L1OAEpD1kcaCHy4pS5ezc/CYhkDOkiGI5qP6O5Jy
	 7KnJpMQeUyvT0OtC7oobqOBZds4r+53XdIVtGaUKDgGk1ib2dHzsazzQpYEx3TakLfpmo
	 2ruxyJiQ0J+AcAVsO9CoPSl4/SHAFAxNFm5RGAjIajQE2UrHwmIP2Bq99HnNnNhWXKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795574686;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1p0CvNQuHo4sEI48VqngId1iPLhnIEEPfqYvt5YlWC0=;
	b=x4X7kB1lv75vFC6Nl8DbJPZ1hwVOYoYyRYaksThDJ2crvhW/cerfxAEXSJQRJybHaSlT
	 ArX7OioX3pPDuKsrpv9uSnNYzIASkUBAxODRhzSxxaKh6f68X0+4cI9FX1mxBJMFywrqx
	 W69S1ncG3r9cWC5/h5G9MddQORbP/xTjoctrbXjdEruaOmczZKwXJQjTveA89HY0XUNHg
	 6pnYFLp0rwxhgZl5oTlObjGj9bxHiGjgk0czrvPzdfklwXCdhXo7lOJLbmaAsl3vc9BUL
	 AYeLMYic+bdz/OQTXakHa1zZ3AmumlzmmApXuLii+Sl2AClTu/M40xgf0ZRXyBu6Y5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JmbIT0O7;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B759E606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 02:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B759E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JmbIT0O7
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03849339;
	Tue, 24 Nov 2026 18:44:42 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 40E0A3F86C;
	Tue, 24 Nov 2026 18:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795574684; bh=NQwHqHHgW8dLEuc5KXKT12Xz9cR8nNjFga5yIVgajKg=;
	h=From:To:Cc:Subject:Date:From;
	b=JmbIT0O7HA8kMHuRLJUPexkU+r5Yi9R/kIwcU5r+fBLAvgC2Zl5PTPvnSCfntEhph
	 EdLEZSaGfx0MYkBpoOsWy/hnwrDdyKXmbRl5Z7vU1DVq6jkpX5JIwUdUQmbTTHAwnk
	 MVBbFZGScN1QPa2BGfXU7TmWZmMexvtQj6XebujI=
From: Jia He <justin.he@arm.com>
To: maz@kernel.org,
	oupton@kernel.org
Cc: fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v2 0/3] KVM: arm64: nv: VNCR page in read-only and cacheable PFNMAP memory
Date: Wed, 25 Nov 2026 02:44:23 +0000
Message-Id: <20261125024426.3464050-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a VNCR abort, KVM walks the guest hypervisor's EL2 stage-1 tables
and maps the page that VNCR_EL2 points to. This series fixes two cases
where that fails.

Patch 1 fixes a bug that predates this series. If TCR_EL2.HA is set and
the descriptor that maps VNCR_EL2 is in a read-only memslot, KVM cannot
set the AF and the walk returns -EPERM. kvm_handle_vncr_abort() has no
case for -EPERM, so the vCPU takes the same abort forever. Patch 1
injects the SEA that the walk recorded.

Patch 2 adds a selftest for this case.

Patch 3 allows the VNCR page in a cacheable VM_PFNMAP or VM_MIXEDMAP
VMA. The stage-2 fault path already maps such memory as cacheable, but
kvm_translate_vncr() rejects it and injects an SEA.

Patch 1 can be applied on its own.

Based on v7.4-rc3.

Changes since v1:
- New patches 1 and 2, for the -EPERM issue found by Sashiko.
- Patch 3: get the HVA with gfn_to_hva_memslot_prot() so that a VNCR
  page in a read-only memslot is not rejected (Sashiko).
- Patch 3: limit the stage-2 comparison in the commit message to
  VM_PFNMAP and VM_MIXEDMAP VMAs.

v1: https://lore.kernel.org/r/20261124025336.4107575-1-justin.he@arm.com

Jia He (3):
  KVM: arm64: nv: Inject an SEA when the VNCR walk cannot set the AF
  KVM: arm64: selftests: Add a test for VNCR_EL2 translation faults
  KVM: arm64: nv: Allow the L1 VNCR page in cacheable PFNMAP memory

 arch/arm64/include/asm/kvm_mmu.h              |   2 +
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/arm64/kvm/nested.c                       |  39 +++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/nv_vncr_abort.c       | 211 ++++++++++++++++++
 5 files changed, 248 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_vncr_abort.c

-- 
2.34.1

