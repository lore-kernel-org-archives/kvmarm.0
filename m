Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828523;
	b=Xmfud+KUAfH50J35tNYkcwNxLEhbDKLYzK05zDtoHGtjCqp6xbi690Djb7ERLKhTwdcM
	 qki3psaQYP5SKcIczC1vYloHlu9WdEmoBjOOBx2nRt8g9GMLOkWINk235P4BWQlCLz64F
	 HO/ix4dULbP0MoEGUqcZe9AhEe6flfHwht8niIvxqQUx2hjFp/p7qT0WxBtlkzmu+5Ryx
	 4qB02g85bDRUupVu5TP3/Oa00CJ0/XunJhToT36AZIWpMpawHemLWVjJErvKoeISecbpp
	 GE6sHVSwHw+948SF0J8nvPyBlAmvvwGLfV9Jq6Xfi64WN+PP3mSwMI3jJhuZSf8X5hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828523;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9854QH4TMdL6guUMAEcKJ+FttltmbvocYCBGe/+Uhqo=;
	b=jmfL/RKH1KuFLVMqCAdtJiV7O6GOSlIcOe6A+9Hktx1ckqgYaCBGEx4cFHWxBmJLTQuk
	 elbwo2xi0om06QZSBjCezhHSd8t94b/7fu1FZBVIduHLX47pkBhZnPZyhHFa54uUbO1c1
	 rqPACFpur4+pkvnGJk+ALI/Z0cndy/nK7P+n66bumhYsjfTGKrn59isdCKkVLItEMcgKn
	 7URab8uUV9fS5d2q7lXSXHhJEBqpN5YgFrizm75VSiE8B04uiVcG7T6gVKmGyRJJrebl1
	 VlfZn+yh7l+5Fl4qxesl69+E/6ESj3O/GOvrXKKeOSuYWaju9Cb6BM5+fzppkcCQS4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jSo9ZDls;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3EB606A31E
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:15:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD3EB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jSo9ZDls
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A80C01575;
	Fri, 27 Nov 2026 17:15:17 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 33FFB3F632;
	Fri, 27 Nov 2026 17:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795828520; bh=XgGdTO+fLL8ATBkcKpsheH2Fam2xVx2g5zcyj4vdLus=;
	h=From:To:Cc:Subject:Date:From;
	b=jSo9ZDlsqBhaK4ZXAB1mgci1w3tc2p6rIkZPYzomz4otiDF3EpPzXSIPrFlg/XRZ/
	 9e7/oi308QYswege6FG7vs4CSCtWlSxB8m76DjXTXQRh+5hZtd6vLmtxHZF2CitfZp
	 cOlBrPqKWvSetCL9G6RHP751kgvIjx2K1s95584Y=
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
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v3 0/4] KVM: arm64: nv: VNCR page mapping fixes
Date: Sat, 28 Nov 2026 01:14:43 +0000
Message-Id: <20261128011447.3588988-1-justin.he@arm.com>
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

On a VNCR abort, KVM walks the guest hypervisor's EL2 stage-1 tables,
maps the page that VNCR_EL2 points to at a fixmap, and points the
hardware VNCR_EL2 at that fixmap. This series fixes three cases where
this goes wrong.

Patch 1 fixes the address that KVM programs into VNCR_EL2 on a host
with 16K or 64K pages. The fixmap maps the host page that contains the
VNCR page, and KVM takes the offset of the VNCR page in it from the VA.
If the guest hypervisor uses a smaller stage-1 granule, the VA and the
PA can have different offsets, and the nested context accesses another
page of the guest. Patch 1 takes the offset from the PA.

Patch 2 fixes a walk that cannot set the AF. If TCR_EL2.HA is set and
the descriptor that maps VNCR_EL2 is in a read-only memslot, the walk
returns -EPERM. kvm_handle_vncr_abort() has no case for -EPERM, so the
vCPU takes the same abort forever. Patch 2 injects the SEA that the
walk recorded.

Patch 3 adds a selftest for both. It maps the VNCR page at a VA whose
offset in a 16K or 64K page differs from that of its PA, and puts the
table that maps it in a read-only memslot.

Patch 4 allows the VNCR page in a cacheable VM_PFNMAP or VM_MIXEDMAP
VMA. The stage-2 fault path already maps such memory as cacheable, but
kvm_translate_vncr() rejects it and injects an SEA.

Patches 1 and 2 fix bugs that predate this series, and each can be
applied on its own.

Based on v7.4-rc3.

Patch numbers below are those of v3.

Changes since v2:
- New patch 1 (Sashiko).
- Patch 3: size the read-only memslot to whole host pages, and map the
  VNCR page at a VA whose bits [15:12] differ from those of its PA
  (Sashiko).

Changes since v1:
- New patches 2 and 3 (Sashiko).
- Patch 4: get the HVA with gfn_to_hva_memslot_prot() so that a VNCR
  page in a read-only memslot is not rejected (Sashiko).
- Patch 4: limit the stage-2 comparison in the commit message to
  VM_PFNMAP and VM_MIXEDMAP VMAs.

v2: https://lore.kernel.org/r/20261125024426.3464050-1-justin.he@arm.com
v1: https://lore.kernel.org/r/20261124025336.4107575-1-justin.he@arm.com

Jia He (4):
  KVM: arm64: nv: Locate the VNCR page in the host page from its PA
  KVM: arm64: nv: Inject an SEA when the VNCR walk cannot set the AF
  KVM: arm64: selftests: Add a test for VNCR_EL2 translation faults
  KVM: arm64: nv: Allow the L1 VNCR page in cacheable PFNMAP memory

 arch/arm64/include/asm/kvm_mmu.h              |   2 +
 arch/arm64/include/asm/kvm_nested.h           |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c               |   9 +-
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/arm64/kvm/nested.c                       |  47 +++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/nv_vncr_abort.c       | 221 ++++++++++++++++++
 7 files changed, 273 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/nv_vncr_abort.c

-- 
2.34.1

