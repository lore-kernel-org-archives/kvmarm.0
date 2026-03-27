Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611437CD5A
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 19:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639695; cv=none; b=eqgJVF7qaSLf/ItS4Q98zsdWxgP32AhXo5SHa+5kpaOMVoy8pzsyLBcqY425q0hu6gCsJWZAmWCssNOJUgXtKQ4YlURAkNaRVC0wxX8yaXzUcyLrMxq18nUoSCf3KM6Uc16UAiCT+xctA5Ue/zBYftnNsBTkHxH5KVP6nEbIgqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639695; c=relaxed/simple;
	bh=dRH5suto7lKdlh/Gq94DqSDdG+gmYwpQzMTnbymFdHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izx2BL5AVfCavFXawjk1Eg9c1G1RsDv+ypsVDLA7KWSRwLCu5gRG5GjfTXbNCKqYTB+2XOhIZokFcaVxcq9Kf7AJFwGtKZ6JPv5faj/kQeSgSqqI4vzhRTGGW0Np4Lhp7LReJ2fUZQP9F6kUUalava9ddXN7+ULuYXyZDaNL5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XkqvL1CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XkqvL1CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BBDC2BC9E;
	Fri, 27 Mar 2026 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774639695;
	bh=dRH5suto7lKdlh/Gq94DqSDdG+gmYwpQzMTnbymFdHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkqvL1CUY8iC67H1eEZ8OzYTS+Iej4ii7s0VvZJblR3L7K9qhoq80tp4y19lAj/0F
	 IEPOgh/hDIi7vn4N/6iOIs5Ek5UcAG7lHUkscxrR81+WJGUMipS6MTqsj+yQk24v+S
	 b0YOIlvsNpvr/ZKY3/INpAxHNXkbceIEkjDwyvK9xobjSZUei92SQLoNpjtbH8DQsb
	 uyDkonP7P73RM4QWAzLfxuWP3Ne2prk3apknNtrSgbAgDTHD7cpZgmCRMBGOJFHPKw
	 JKD+bWEfEunIZyintxGCaIY4/Bc+lbxeDfezvNv0xFjTtvURm4cVKXTDhkuYKsturL
	 h5Pq6U3sAS09Q==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: Destroy stage-2 page-table in kvm_arch_destroy_vm()
Date: Fri, 27 Mar 2026 19:27:57 +0000
Message-ID: <20260327192758.21739-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327192758.21739-1-will@kernel.org>
References: <20260327192758.21739-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_arch_destroy_vm() can be called on the kvm_create_vm() error path
after we have failed to register the MMU notifiers for the new VM. In
this case, we cannot rely on the MMU ->release() notifier to call
kvm_arch_flush_shadow_all() and so the stage-2 page-table allocated in
kvm_arch_init_vm() will be leaked.

Explicitly destroy the stage-2 page-table in kvm_arch_destroy_vm(), so
that we clean up after kvm_arch_destroy_vm() without relying on the MMU
notifiers.

Link: https://sashiko.dev/#/patchset/20260327140039.21228-1-will%40kernel.org?patch=12265
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 410ffd41fd73..29bfa79555b2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -301,6 +301,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (is_protected_kvm_enabled())
 		pkvm_destroy_hyp_vm(kvm);
 
+	kvm_uninit_stage2_mmu(kvm);
 	kvm_destroy_mpidr_data(kvm);
 
 	kfree(kvm->arch.sysreg_masks);
-- 
2.53.0.1018.g2bb0e51243-goog

