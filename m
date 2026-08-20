Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D0B445AFE
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 12:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230264; cv=none; b=Q8SgIQ1VZ1qVWZitPKLXEJFkUMCsqaP1lGW4i2f4P6zX7JzPq6AKNuae9AzpXmoW0F7mVsD0bt0Hs2B812zZra3Kr2fPGCUzEeRdnRiNeYIMwiXOGzDeU4paxl2Md/KUvemxDgtI0vP78tzAhBfvcpRNMlle7eRy7ToCh3ReYvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230264; c=relaxed/simple;
	bh=gNv3rmQs8sBjpAmX4m5IzC8H8pWO4C5VE0KwoE7p1CI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QQ14mTQe/3d2B/zONJUGulVOkVuB01EGtvs3Zw3L6fDtJzRrh3NqqOpwysgxT29m1W6nN/cwaiRhzr+i9ELx0LLvOrpbWHh/nsI1LsRDZIXCW0Gg+AqpyUKB6KmsNd6sZ22OOXja3aONZrossACTKueDRPDVgZdu2glAT+V0wwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pZVVZ6Jb; arc=none smtp.client-ip=91.218.175.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pZVVZ6Jb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=gNv3rmQs8sBjpAmX4m5IzC8H8pWO4C5VE0KwoE7p1CI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787230258; v=1; x=1787835058;
 b=pZVVZ6JbyC2cDztRYlDcGowvgre8jqz4srJ25sdm0V16khrUIcrEFBSVg5d+HFErKQUippUU
 sJICNiB5Bf1BI1KX1vcbveyLia8OlodgYaTby1rNHHS/qDWFEg13/o8WZW4qgoMMvt3JcrkHizs
 aFJ7NKch6yiizMRGylorBpWo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 0cbeada787c9c601;
	Thu, 20 Aug 2026 12:50:58 +0000
X-Mizu-Trace-ID: 0cbeada787c9c601
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
Subject: [PATCH 0/3] irqchip/gic-v4, KVM: arm64: Fix the vgic init error paths
Date: Thu, 20 Aug 2026 13:50:50 +0100
Message-Id: <20260820125053.2951078-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Three fixes on the paths that run when vgic init fails partway. Each one
needs an allocation failure to reach.

Sashiko reported the vgic_init() case [1] while reviewing the SPI-array
leak fix. The two irq-gic-v4.c fixes came out of chasing it [2].

Patch 1 clears the irq domain and fwnode pointers at the four GICv4
sites that free them and leave them set. Patch 2 makes
its_alloc_vcpu_irqs() release what it allocated when the SGI loop fails.
Patch 3 releases the SPI array and the vPEs on vgic_init()'s later
failure paths, so KVM_DEV_ARM_VGIC_CTRL_INIT is all or nothing and a
retry starts from scratch.

These patches run across two subsystems, but ordering matters, which is
why this is one series. Patch 3 runs vgic_v4_teardown() on a path it
never ran on before, which adds a route into what patch 1 fixes, and
patch 2 reuses its_free_sgi_irqs() from an error path, which only works
once patch 1 has cleared the pointers.

Based on kvmarm/next (aa8e5dc6a7a2a).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260807105558.73D701F000E9@smtp.kernel.org/
[2] https://lore.kernel.org/all/CA+EHjTyDix+y6NTLTsXP5j9Sn2VLOZcsw94LntQxg_etRBJZuA@mail.gmail.com/

Fuad Tabba (3):
  irqchip/gic-v4: Clear the domain and fwnode pointers after freeing
    them
  irqchip/gic-v4: Unwind what its_alloc_vcpu_irqs() allocated on failure
  KVM: arm64: vgic: Tear down what vgic_init() created when it fails

 arch/arm64/kvm/vgic/vgic-init.c | 11 +++++++++--
 drivers/irqchip/irq-gic-v4.c    | 34 +++++++++++++++++++++++++++------
 2 files changed, 37 insertions(+), 8 deletions(-)


base-commit: aa8e5dc6a7a2a1141ab40706a51010adcd0e57d2
-- 
2.39.5

