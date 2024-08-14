Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9623D15C9
	for <kvmarm@lists.linux.dev>; Wed, 14 Aug 2024 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723638876; cv=none; b=qYRwh+1OACY/mtwgTUqpHe9iQBcd7HUXQg9J0SlUDeIY0tEAYkNlXc1q9hiDr2/kb2WxaQ3cuyy60RFYrYSli6wS2MyxYqUD1Nfju/9/tUM36V7saJ7bxET3844I/t1rJXPL0phaPtvu1DUbmRxpA0WZr4HSx9dQTQKH735j1SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723638876; c=relaxed/simple;
	bh=0lLzlVnV/SkrNnd+QeWCt7iZ7o14ooMiGjV2yyrPM2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XijPhTATUidkS6mehS3sWNu4d2hPwIkiJKwdAGlxPtCgwbV8jnTKCJYkA8nkuOO2eOvhq6YgY9dnhPIxGFZ3wuvgcRbN9iY8JjFn3Ywb3LfUFyRw9zV+FYkOnngoq5dq4Qq6e3z2h3ac1yibbdKpQ2e774Du9HSBU7NUjjHfv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtLxct10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtLxct10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D5AC4AF0D;
	Wed, 14 Aug 2024 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723638876;
	bh=0lLzlVnV/SkrNnd+QeWCt7iZ7o14ooMiGjV2yyrPM2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtLxct10ZKkJY0pWU7zuCSgN1dcnsd8uP+UK8cVZD/sjv+gcFdEZvrbP6scD2UlwX
	 aqDuzWc386Cj+WE9NvUdLVnXJQXsKJ8RJ1lv+0bndNQntMQ8SlTYOywDQrnzspzndY
	 1C49pY10PUXDH9SPvqICXxynKaIfLDkWpwrlAMYx6Kc6IaAkRrrhYm/D0zoFaKntlT
	 J6IjVza1NcECTEh8xtNJ4FtzqCbJq4wkEylJCj+ag8AEEI4Pl6ROQxNcDXxcPL2S/I
	 28g6cdP2u9DN9KFmX6FM5arhCHVFHfPKplZwWCbMZAstd+f29cfkh7yD1ni1lt9OWU
	 430E23YGvhKxA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Subject: [PATCH 1/2] KVM: arm64: Invalidate EL1&0 TLB entries for all VMIDs in nvhe hyp init
Date: Wed, 14 Aug 2024 13:34:28 +0100
Message-Id: <20240814123429.20457-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240814123429.20457-1-will@kernel.org>
References: <20240814123429.20457-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When initialising the nVHE hypervisor, we invalidate potentially stale
TLB entries for the EL1&0 regime using a 'vmalls12e1' invalidation.
However, this invalidation operation applies only to the active VMID
and therefore we could proceed with stale TLB entries for other VMIDs.

Replace the operation with an 'alle1' which applies to all entries for
the EL1&0 regime, regardless of the VMID.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 07120b37da35..401af1835be6 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -130,7 +130,7 @@ alternative_else_nop_endif
 
 	/* Invalidate the stale TLBs from Bootloader */
 	tlbi	alle2
-	tlbi	vmalls12e1
+	tlbi	alle1
 	dsb	sy
 
 	mov_q	x0, INIT_SCTLR_EL2_MMU_ON
-- 
2.46.0.76.ge559c4bf1a-goog

