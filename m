Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E07B39792B
	for <kvmarm@lists.linux.dev>; Mon, 24 Aug 2026 07:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557373; cv=none; b=rl+/Jknfhd1fokf8ot8wQlyKhz9BZWDOoGvkLVOgda23ijF9mpewGd98wpDTJ1VeIpGY0jURtY68tGWcbP/y6ZpX1bhXU/v6ddTvjVZjHwneVUD9Zz46ftDxvLFdbT7GbaJAoJRFCUj+/HsFu5iVBOs7dZEOJ9lMuODYXPZuLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557373; c=relaxed/simple;
	bh=q8/l5C+i6hyPfzKiQB5E1nf0gY1rHDKqf5inh26G/MI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MlfL/2q+ZKdmtxCRqGDfUlkU1Y+M/B94fSW3Ig0HHkEarREtfWsD8YSwkWM5ok9UT29ApAnFBcN5V+MHcfZmzExCIag40J4ueK3OfKbdKGbv0UgP2bVLDyvFUVRLalix8agLfHpUp6H3fNTHfyrL+iqXrcsVdju02M/dxKoq0mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jy/J/+KN; arc=none smtp.client-ip=95.215.58.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jy/J/+KN"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=q8/l5C+i6hyPfzKiQB5E1nf0gY1rHDKqf5inh26G/MI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787557370; v=1; x=1788162170;
 b=Jy/J/+KNZpCR1hC7inQ4owY2NuOsyXQK6kBeqW+mksksC3Gtj0v7fdMRKVfq6VQz1Dl9VdAE
 VDloy0wAe7JDYFrT2R5lnYXGuQv3o4Y0eVMzmAcTQ7qT+GLU8djxvW4P/EqJhuthBJT45qnjLsK
 Sj9FFJrzuk/wo6qPuVY6s11k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 5d1d4802d51e7f8a;
	Mon, 24 Aug 2026 07:42:49 +0000
X-Mizu-Trace-ID: 5d1d4802d51e7f8a
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Eric Auger <eauger@redhat.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] irqchip/gic-v4, KVM: arm64: Fix the vgic init error paths
Date: Mon, 24 Aug 2026 08:42:41 +0100
Message-Id: <20260824074245.710955-1-fuad.tabba@linux.dev>
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
  - New patch 4: restore its_vm.nr_vpes in vgic_v4_teardown() so that
    its_free_vcpu_irqs() frees every vPE. (sashiko, Marc)
  - Patch 2: corrected the commit message. Skipping a vPE with no SGI
    domain avoids a wrong free, not a warning.
  - Patch 3: added a second Fixes: tag. The SPI-array leak arrived with
    the routing call, well before the vPE one.
  - No code changes to patches 1 to 3.

Four fixes on the paths that run when vgic init fails partway. Each one
needs an allocation failure to reach.

Sashiko reported the vgic_init() case [2] while reviewing the SPI-array
leak fix, and the two irq-gic-v4.c fixes came out of chasing the first
[3]. Then, just when I thought I'd squashed every bug Sashiko could
find, it turned up one more in its v1 review: the pre-existing nr_vpes
one, fixed in patch 4 as Marc suggested [4].

Patch 1 clears the irq domain and fwnode pointers at the four GICv4
sites that free them and leave them set. Patch 2 makes
its_alloc_vcpu_irqs() release what it allocated when the SGI loop
fails, which is both the SGI domains and the vPE irqs, wider than the
SGI-domain leak I described before posting v1 [3]. Patch 3 releases the
SPI array and the vPEs on vgic_init()'s later failure paths, so
KVM_DEV_ARM_VGIC_CTRL_INIT is all or nothing and a retry starts from
scratch. Patch 4 is Marc's suggested fix [4] for the nr_vpes overload.

These patches run across two subsystems, but ordering matters, which is
why this is one series. Patch 2 reuses its_free_sgi_irqs() from an
error path, which only works once patch 1 has cleared the pointers.
Patch 3 runs vgic_v4_teardown() on a path it never ran on before, which
adds a route into what patch 1 fixes. Patch 4 is only correct on top of
patch 3, which is what stops online_vcpus outgrowing the vPE array.

Based on kvmarm/next (aa8e5dc6a7a2a).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260820125053.2951078-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/20260807105558.73D701F000E9@smtp.kernel.org/
[3] https://lore.kernel.org/all/CA+EHjTyDix+y6NTLTsXP5j9Sn2VLOZcsw94LntQxg_etRBJZuA@mail.gmail.com/
[4] https://lore.kernel.org/all/87ik51np8e.wl-maz@kernel.org/

Fuad Tabba (4):
  irqchip/gic-v4: Clear the domain and fwnode pointers after freeing
    them
  irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
  KVM: arm64: vgic: Tear down what vgic_init() created when it fails
  KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources

 arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
 arch/arm64/kvm/vgic/vgic-v4.c   |  3 +++
 drivers/irqchip/irq-gic-v4.c    | 34 +++++++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 8 deletions(-)


base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
-- 
2.39.5

