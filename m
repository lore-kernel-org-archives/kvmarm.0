Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6FE3F58DC
	for <kvmarm@lists.linux.dev>; Mon, 21 Sep 2026 07:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975840; cv=none; b=OmxSt38mjLBdrnJP1QDaXAYGnCzeRXR1yMx4NWS+NxXusTI0Am50wCXvKas9xLyoMDBIxjNqDAT3HpLtDHhssg7ppSiQamEnEdRRs1sOF3qDOxBQMGFdHNLquEWxCuVkk+h/mL9Nba0QYu9KXAvb0kMVLLOL9y/g6oa3in+v2IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975840; c=relaxed/simple;
	bh=0njPdbaKLdmcvhV4JMlTlxwDuJcfUS+uR9TLYY7nzIc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rc9TS3kjNwM6dihoMPWN6YMuOQUO+mNDuv0XC8QhtP1TlTmUZNwDFDKiYwJ22uv8CtPf0o6e7W1elW2h3JrCreEteZpxLmSdjIVxd6Rhtz/udlwO8mu8g0sWOArl96DkcP2Qe4xtSqVmf5VavfxbbERW90UhKtNI4S6ydAt8MFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rTt1dg0j; arc=none smtp.client-ip=95.215.58.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rTt1dg0j"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=0njPdbaKLdmcvhV4JMlTlxwDuJcfUS+uR9TLYY7nzIc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975836; v=1; x=1790580636;
 b=rTt1dg0j7DINWZf1ZAgCBj6aNYCpGhMM6eanKKFoafkpZFLHGx12/ZskKp6OWcu0g/8/bIch
 M/C0it8UMQ0Q+oE0brdMiJAcQEiMaYPsNhq775PaLh1fmJhgVP8xKQr2WPDr4yAfBOVdE/UnXRi
 tqZXKRkbT7ciEomvSdNOG/c8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ad2a4d2e289077aa;
	Mon, 21 Sep 2026 07:30:23 +0000
X-Mizu-Trace-ID: ad2a4d2e289077aa
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
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] KVM: arm64: vgic-v4: Restore nr_vpes before freeing the vPE resources
Date: Mon, 21 Sep 2026 08:29:58 +0100
Message-Id: <20260921072958.2918477-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260921072958.2918477-1-fuad.tabba@linux.dev>
References: <20260921072958.2918477-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_v4_init() truncates its_vm.nr_vpes to the failing index to bound
vgic_v4_teardown()'s free_irq() loop, but its_free_vcpu_irqs() reads
the same field: the vPE irqs and the v4.1 SGI domains at or above that
index are never freed, each one leaking a vpe_id and an LPI pending
table.

Restore the count from online_vcpus before that call. This depends on
the previous patch: a failed vgic_init() keeps admitting vCPUs, so
without that patch's teardown the vPE array outlives the failure while
online_vcpus grows past the size it was allocated with.

Fixes: bdb2d2ccac65 ("KVM: arm/arm64: GICv4: Add doorbell interrupt handling")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260820130616.1A7241F000E9@smtp.kernel.org/
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ed236f083f0d7..30e1de3fc7d9d 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -333,6 +333,9 @@ void vgic_v4_teardown(struct kvm *kvm)
 		free_irq(irq, vcpu);
 	}
 
+	/* Make sure we free all VM-wide, per-CPU resources */
+	its_vm->nr_vpes = atomic_read(&kvm->online_vcpus);
+
 	its_free_vcpu_irqs(its_vm);
 	kfree(its_vm->vpes);
 	its_vm->nr_vpes = 0;
-- 
2.39.5

