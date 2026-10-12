Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA824AB3A3
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821762; cv=none; b=L11QOxccoP9Fm1zZOA7Wx/C+oMqz5f8Yzl68MXi2+9yEM4bJqffwjeDMFauotUL3ErMw6gE4z0S8GdjsvhH3LPe/CTcPCq+UprBLlWjwe4xlizEJ2chJaK0sDw7yN9IL/47k33BoG1lOzClN8jLrHN35FfLFhFdRbmhgMiDUBkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821762; c=relaxed/simple;
	bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LVzmyuBH2PGkb3dL2TWoolhPvYgxgEi7xO98TuN02XtdWz/gPP1cQ2VY61M9nI9/2tAnu4G3KFISL9kzxYSdBoN3ovuB+eOCbAe29zXJyLZUTLZBihJI1oowv9JfXj99ZULB0ePHbHuZzYeBxPj2FQwvRjfbENUvkYVXADnvSD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sjchyi9D; arc=none smtp.client-ip=95.215.58.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sjchyi9D"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791821758; v=1; x=1792426558;
 b=sjchyi9Dc7HfKs3LWQyGGgk1Owu8D9l7c4Vyxi1vdxOzv21Tlx/sWGVmfoqsVFvUJYTm61+u
 7SEW/SVjtS8nXukcU8fLy109CjeWOI1mRjPXPKoN4WZ8UXSGo67xj1pn0SYaT5IlqC4+WQ9xCA/
 Lc0qbc89JTiKznQlKNIaU1Lg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a637eb0a5d7055a4;
	Mon, 12 Oct 2026 16:15:58 +0000
X-Mizu-Trace-ID: a637eb0a5d7055a4
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH v3 5/5] KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch
Date: Mon, 12 Oct 2026 17:15:24 +0100
Message-Id: <20261012161524.4016464-6-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261012161524.4016464-1-fuad.tabba@linux.dev>
References: <20261012161524.4016464-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__hyp_vgic_save_state() and __hyp_vgic_restore_state() handle GICv5 as
well as GICv3, but their comments name VGICv3 only.

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

