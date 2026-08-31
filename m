Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756B44E65A
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194067; cv=none; b=c6DwN3bwl46ys31DK3OG5Skdiu4VBkKWFcQDt5/HG3owQacsPYJGZtjHppmMU1WEblHuWkWYwqWMyjGeH2xuVCXJ2OlQPYv0n8rpWYJDCUlhYlvUSrNogmGPSutUxN4IFDdadiIOi93Our3aIDUL3YitEikCx3ZNkkSzSBjIRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194067; c=relaxed/simple;
	bh=PJujOV+1Z+2Pic9F+Xx2wknBh2QM3e+/EoajCgxNjqc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DSTdWxHmTMB+gBZTc2Sh3OEONS7lT1SjmigX0zL+CT1IK1+fmXUoC1293tNPhg3MnP6NZ/Qfg4bEbXhV2v1XeuZqcCeLgiRiHvHj2cB4kohiVE5XN4hgU8714v7lIj8zlwWVlfElbpyvjtJ1dmdSyr9m/xO6NFUZPIpCKMdFqng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X6pQZJbZ; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X6pQZJbZ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PJujOV+1Z+2Pic9F+Xx2wknBh2QM3e+/EoajCgxNjqc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194063; v=1; x=1788798863;
 b=X6pQZJbZ69yGH+cU7Rqp0jtm1AXp2YM3wzkKGq6CP4rVARiVzT0NEBFeJ+BQ87St12hoham1
 ILpv/LHz+oKKsD6MrxhiSKtgAQLYZSvoAfYhjOgggYLhLmGjW6scxyWlXYr38tev1W5bfSdi8wz
 ZyjSa7KWmokn07PcEvLRWuWY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 914f3f102f58101c;
	Mon, 31 Aug 2026 16:34:23 +0000
X-Mizu-Trace-ID: 914f3f102f58101c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 01/17] KVM: arm64: Sync HCR_EL2.VSE back to the host vCPU under pKVM
Date: Mon, 31 Aug 2026 17:34:05 +0100
Message-Id: <20260831163421.272420-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flush_hyp_vcpu() copies HCR_EL2.VSE from the host vCPU into the hyp
vCPU on every entry, and nothing copies it back. Once the guest takes
the vSError the hyp vCPU's copy clears with the hardware bit while the
host's stays set, so the next entry pends the same SError again,
KVM_GET_VCPU_EVENTS keeps reporting it, and kvm_arch_vcpu_runnable()
never lets the vCPU block in WFI.

Reflect VSE back on every exit, which the flush-side comment already
states.

Fixes: 734dc8c01c838 ("KVM: arm64: Implement lazy vCPU state sync for non-protected guests")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 9a3b92e626adb..b6bfe502bcd04 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -276,6 +276,10 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
 
+	/* Cleared by hardware once the guest takes the vSError. */
+	host_vcpu->arch.hcr_el2 &= ~HCR_VSE;
+	host_vcpu->arch.hcr_el2 |= hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
+
 	sync_hyp_vgic_state(hyp_vcpu);
 }
 
-- 
2.39.5

