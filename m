Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B820966B
	for <kvmarm@lists.linux.dev>; Fri, 10 Jan 2025 22:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549634; cv=none; b=UXUNZZACQkLkjjmmYtazWY0Qece8fGaS+wqb1sW+DjQZr9yyURKX2AD/GBEf0Hszobhnd/YboZMxLGw+NOq10H11d71QKaDHe+QuMoJmrcRCqKypVutL23l2mPBOcyCBdDnXtuV1RaSnCrvLBkreELd3lsVgJ4hTRJSHymCIDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549634; c=relaxed/simple;
	bh=JTjqSHbfRwOx/pr5FfQIXpFcwvpdy7keNJ14EYu0g2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mm05Ss1OrbyWLCVSLkE8+CF6pIE+V7adY5kqu2Pn6txD5Hblh7jXgnuSomPjvxiBcK7DtRZQpJ4Zk2OzpKQCAzhuKyXJfGC5kj37DCLniyBiRY/ASr0df8j21J8ah1RpZmYZCTraqYceUHQf7bhdYFo0IzwN/b7AN0U3a2TVuRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rxRidBOW; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rxRidBOW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736549629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eJTTDJmqLymoNkdRC+AVperlrWlU0YZNLMNy9tALto8=;
	b=rxRidBOWYfEutC16dOZAuW3ZTMoV+kHg5ik3aLx5CZRtabjkTcVS5FGW1ERMCF3/hv7ZbF
	PeKpOjRfUnU5KhiGJz5Pe3ErFWQUT2PHVkQ+IkOwQ3eBdCo4hTK232/S823GL6PC+RP4Qx
	VROEmT7dSLG0nXwNUfQMrQhd8dtSHzI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Ott <sebott@redhat.com>,
	Fuad Tabba <tabba@google.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: vgic: Use str_enabled_disabled() in vgic_v3_probe()
Date: Fri, 10 Jan 2025 23:53:09 +0100
Message-ID: <20250110225310.369980-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index f267bc2486a1..528ee93fefd4 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -6,6 +6,7 @@
 #include <linux/kstrtox.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/string_choices.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -663,9 +664,9 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	if (info->has_v4) {
 		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
 		kvm_vgic_global_state.has_gicv4_1 = info->has_v4_1 && gicv4_enable;
-		kvm_info("GICv4%s support %sabled\n",
+		kvm_info("GICv4%s support %s\n",
 			 kvm_vgic_global_state.has_gicv4_1 ? ".1" : "",
-			 gicv4_enable ? "en" : "dis");
+			 str_enabled_disabled(gicv4_enable));
 	}
 
 	kvm_vgic_global_state.vcpu_base = 0;
-- 
2.47.1

