Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A123FC5AA
	for <kvmarm@lists.linux.dev>; Tue, 13 Oct 2026 08:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879416; cv=none; b=m+CU93HIXWkaCQFZjGo8tKwbNlQAh6qH1UMUsqonf2htdlcSGaUZ02zBqVbIqTtPBUaMInTnl21RS2Q5wRKOA5qo0nvVOP6edTG24TofxPKhOMbYDn47/VMadp/I8E+XvvXF5Te+yU56iRDhrWcccsq0gdwypEz2EehVpJdA6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879416; c=relaxed/simple;
	bh=zV/Y7LUxdXBJHF8yHit6eZfddU4Htkr3/SC3yf26G98=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iWc7VCEmuaQxHJE3FmYHdl+YqCFxdCZz5yhcj4xMEd4toB7g3Gn0PgSe6UfFsTBnvDmaXbPrEd15VGHG6wxPIYV25NFs4m6F6aGxCPa1f+T6Epr81n4cqAvgjWwVmS0Rs/UdFzsKfJ6EO38CAZP7fiB2UsFE2T+YOcNJyPvIHac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pbeGOFck; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pbeGOFck"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=zV/Y7LUxdXBJHF8yHit6eZfddU4Htkr3/SC3yf26G98=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791879411; v=1; x=1792484211;
 b=pbeGOFckERur38IMxOBfFlC10yByql9ZwNRg7RpABlwa/4qWYYEKt55Ups+DAiuFk3Yu0gFS
 Eew5em1lXYR6sY69IrMPqXXMybK6Nv/PVKW++WbowHcFsNuxGvtdmGT/FwVazIyQUT0SJJ6MshR
 V+X+BDMdmFn+0Rru4UMLVmn0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c9420a0c96a5878d;
	Tue, 13 Oct 2026 08:16:51 +0000
X-Mizu-Trace-ID: c9420a0c96a5878d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 0/2] KVM: arm64: vgic-its: Fix LPI double mapping and DISCARD
Date: Tue, 13 Oct 2026 09:16:44 +0100
Message-Id: <20261013081646.933312-1-fuad.tabba@linux.dev>
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
  - Dropped the second mapping of an LPI at MAPTI, instead of keeping a
    doubly mapped LPI out of GICv4 forwarding. (Marc)
  - Keyed that check on whether an ITE maps the LPI, not on whether its
    vgic_irq exists.
  - Added a patch that makes DISCARD remove the pending state. (Marc)

Two fixes to the ITS emulation. The first stops a guest from mapping
one LPI from two events, which can oops a GICv4 host when the VMM then
routes an assigned device's MSI to the second event. The second makes
DISCARD remove the LPI's pending state, as the spec requires.

Tested on QEMU, which emulates a GICv4 ITS. A local reproducer with two
vCPUs DISCARDs an LPI that's pending in the other vCPU's list register.
On rc3, and with patch 2 but without its halt, the guest still takes
the LPI. With the series applied, it doesn't.

Based on Linux 7.3-rc3 (fd73f4a665989).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261012084743.2228612-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: vgic-its: Don't map an LPI from more than one event
  KVM: arm64: vgic-its: Remove the pending state of a discarded LPI

 arch/arm64/kvm/vgic/vgic-its.c | 50 +++++++++++++++++++++++++++++-----
 include/kvm/arm_vgic.h         |  1 +
 2 files changed, 44 insertions(+), 7 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.39.5

