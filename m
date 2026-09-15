Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4CF4AFE11
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475973; cv=none; b=hRvOyNbvDpalw971bXGiQ36ymN3GaQT6H/3Z0PF4c2vnNSWo8R0UUg1HVbaLz/G+K0j38ARRUyII9r7np4f+osKhXiVdQabdystOpnarCZqpmlrAo46nAkdiLp7Y1NPLQO7YMekDFVSRYm5t75VacuwxWlNOgyRYPjGgyZbb5ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475973; c=relaxed/simple;
	bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crGKRzba/v/RbI/Vw6R03rG1/v8BL3JRW2f/wMNKbPWrHYfw+CSZ2Bzi49lV0pqrY8lrZbOTN/GJh+iMtTzQXq4cxUtClErYGN1VqnFTNxSnOIullx4gHuLkYx/kAgknvjImusMZWX0q0mb8ygci4unXyulNZ8uvnv3uW0KvSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nyz+h/BA; arc=none smtp.client-ip=91.218.175.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nyz+h/BA"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sXzD5OweRtbt4uiu9AwJiDOee0ALx9j8z+8yBBR+qWw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475968; v=1; x=1790080768;
 b=nyz+h/BAwR5kLcsNmGLMEJY7dQjAHlIyguIRMM6K/gfJF+gO7SNMvfh/rWo4ozH0S04dtMuf
 mfh/8eY93zTxN8B6WBC9dOiCypiegz6Tr7po4/wglpQdqFLzhsOuPCgX5fHvBhsPpNYKvpWYOdX
 oSCQxfXZepL52FW4MnlTQ4zs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3acdc7de5bc4f044;
	Tue, 15 Sep 2026 12:39:28 +0000
X-Mizu-Trace-ID: 3acdc7de5bc4f044
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
Subject: [PATCH 7/7] KVM: arm64: Fix stale VGICv3 comments in the nVHE world switch
Date: Tue, 15 Sep 2026 13:38:46 +0100
Message-Id: <20260915123846.2317931-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915123846.2317931-1-fuad.tabba@linux.dev>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
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

