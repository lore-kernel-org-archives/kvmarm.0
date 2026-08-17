Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C3C3AFD16
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962775; cv=none; b=k0u3IYbTQH2dGDXqHKYFOSxEqlPlAzIScZ6iZPKBX875hs86ITjNY0QWuelDNHSuhXsmTDIKPyjuklMVExYx3Yv+rJ3si2Z7YmmT7sG9IYv1/XkQrPvJLJg81e3KwG6saa9ov4qROScMSpQ4ZQsw+zvjZ89spJZF7LjkrR8tFxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962775; c=relaxed/simple;
	bh=9mF2czhn+PnLAGkFt/8xXgdkUXHiz0TaF0VIj2w/Nqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e1L2iJRjXlegRdNfyVUIDyHQyRsx7eL+T8Pzc5Vepqf2Zd+SZrv5EM/1Jsu5EAD5mZfCQRRmGyNPC3fmfhP6ZgSdO+rdVtpnIYUmZQO+e3moCNnWtb3IuC01iputTor3Gs2jq737AUWUJt/JJLWXABaYjk44sNKJAzmnOAyC9VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vVwx+pn9; arc=none smtp.client-ip=91.218.175.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vVwx+pn9"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9mF2czhn+PnLAGkFt/8xXgdkUXHiz0TaF0VIj2w/Nqw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962771; v=1; x=1787567571;
 b=vVwx+pn9VmoUXHpPIJGgfvsGQ9k8w70YkxzXdXFEiiOWrPh/OfwgFra0xGYkh9vG+f2c0Ri+
 GOEP8SIv3yvzBspZyM7+oReYX67pgKulMrqf2ARViGQ1z4T8b6FZClHoePHZQIvZjSShKnCQkur
 fM2dQZHI5yonQTVT8QTCnNPQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 39157fbb1d010fff;
	Mon, 17 Aug 2026 10:32:51 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v2 4/4] KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch
Date: Mon, 17 Aug 2026 11:32:28 +0100
Message-Id: <20260817103228.1203140-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260817103228.1203140-1-fuad.tabba@linux.dev>
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__hyp_vgic_save_state() and __hyp_vgic_restore_state() handle GICv5 as
well as GICv3, but their comments name VGICv3 only.

No functional change intended.

Reviewed-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f36..6b9e20f6b31b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -110,7 +110,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
-/* Save VGICv3 state on non-VHE systems */
+/* Save vgic state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
@@ -125,7 +125,7 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Restore VGICv3 state on non-VHE systems */
+/* Restore vgic state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
-- 
2.39.5

