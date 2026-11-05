Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876460;
	b=iI8mJgHg5K2oPVqwf4Sm/w6A2QkpTL6oCFN1bJMFMnIyQDBiUqkNaepQXrS8IUL+H3Yv
	 DyMNdNjdmlVKCxN8Fr7aXG6f2uWyn1r43JWgbmEft7u1e6DzBU6tUh2XJlZoU9FKVhIC0
	 rDBqR2T+tpD4buIPrrJnCmRumVHGHAm8GUt4oJG+4ztIakuVzWWW8UJRE5ytubp/k90bl
	 bCfCB7DAFEn97BDOUMNYal7XgSWkMOgZC0Qh/G4PnPsixGium6zFWuudK/zADd6ozahM0
	 E/2/2rqt/9IH1iRJkKfBHKZPeNF/QVJZ8xfYt/FpXtDsVmEPuaOzUrmfEWOXIFGsDOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876460;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hu/VCXv0pK0QVa21PPH8FfuyU2lKhIQq9BLyUFz++I8=;
	b=TxpkNnmNC0+cm+/4/jdSDm/mkl5SBXfaDDblXVNGyWhwhf74AYa/LagMRV1/hLzoXSkp
	 yG6XXF3euNktIKq3BUp70qmqBqyWlXRHBvGST2WnewAsPmdtI7AicfEq7anJzHf4GJrXg
	 wQcIXKerOXC8MQ/Izi+80LMuNxZeyctnaBkEb2C0qTHWCqhtYdQgrMWLGWkAKZQrQxnGA
	 F8kMl2cVXSdT5H12Dt7xHTJQlmrMzAAPzj7APSRdjBgxILSdAj3xcDtCR7ua4IbJPUaLv
	 iNEqA4H1GgB4kSTlPokGVD/1DT37Z/BzLHA3c04xBzvZKBn9CeqAGVpDkJMemycwxYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pYFNCO5R;
	arc=none smtp.remote-ip=91.218.175.169
Received: from mta0.migadu.com (out-169.mta0.migadu.com [91.218.175.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95ABF606A31B
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 11:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95ABF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pYFNCO5R
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=oNPULxolfeqGA8zrrmcWP4Y839okpyulp0cDosAwCuY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793876456; v=1; x=1794481256;
 b=pYFNCO5ReUUb9bCeJh5k8Bha0VGFUNkzsI6W94p8DZtvb3jItrNzFYdis6QmrRZeXTPxBVVA
 rv5NwalCekzo2akHMoO+hdQMpOMI6rA72isnBFz6bY8Wg0eTBLFOqdE4Bbypt4xiEedTIMt7j2J
 4RabLKy843sMm9ww4zCMmWGc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a394ecf1d1f2d65a;
	Thu, 05 Nov 2026 11:00:56 +0000
X-Mizu-Trace-ID: a394ecf1d1f2d65a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: vgic: Drop stale LPI pending state
Date: Thu,  5 Nov 2026 11:00:47 +0000
Message-ID: <20261105110050.1244525-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
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

Hi folks,

The GIC just keeps on giving. Three follow-ups to my LPI fixes for
redistributors with LPIs disabled [1], to fix pre-existing bugs Sashiko
found.

The first drops the pending state of every LPI targeting a
redistributor when the guest disables its LPIs, not just of those on
the AP list, so a re-enable with GICR_PENDBASER.PTZ set doesn't bring
any of them back. Linux never sets PTZ.

The second stops the pending-table save from writing to the table of a
redistributor while its LPIs are disabled.

The third stops KVM reading the pending table when mapping an LPI, so
that mapping a discarded LPI's INTID again doesn't make it pending a
second time. A Linux guest can hit that after its VMM pauses and
resumes it. It also drops the copy that patch 2 of [1] takes, which is
why it comes after the second. An LPI mapped after its redistributor
enabled LPIs no longer takes a bit the guest wrote into the table
before the enable. Keeping that needs a per-redistributor record of
the pending state of unmapped INTIDs. I can add it on top if you think
it's worth it.

A pending LPI that MOVI moves onto a redistributor with LPIs disabled,
or that a device signals there through a translation cached before the
move, can still be taken once after a PTZ-set enable. The architecture
lets KVM drop it, but that's pending state moved or raised onto a
redistributor with LPIs disabled, not state the guest gave up. I've
left it alone, but can fix it on top if you think it's worth it.

Reproducers for all three fail on kvmarm/fixes and pass with the
series. I'll fold them into vgic_lpi_stress separately.

Based on kvmarm/fixes (181a701fc14d3), which has [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261026092802.2636798-1-fuad.tabba@linux.dev/

Fuad Tabba (3):
  KVM: arm64: vgic: Drop the pending state of all LPIs when disabling
    LPIs
  KVM: arm64: vgic-v3: Don't save pending tables with LPIs disabled
  KVM: arm64: vgic-its: Don't read the pending table when mapping an LPI

 .../virt/kvm/devices/arm-vgic-v3.rst          |  1 +
 arch/arm64/kvm/vgic/vgic-its.c                | 33 ++++++++----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 13 ++---
 arch/arm64/kvm/vgic/vgic-v3.c                 | 50 ++-----------------
 arch/arm64/kvm/vgic/vgic.c                    | 16 +++++-
 arch/arm64/kvm/vgic/vgic.h                    |  1 -
 6 files changed, 49 insertions(+), 65 deletions(-)


base-commit: 181a701fc14d3d468c603b5ecfb9f12115c5fb72
-- 
2.47.3

