Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DF2399351;
	Mon,  8 Jun 2026 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780906326; cv=none; b=Lx7OjN3OArSFxto/NcTamanbElWigy0CGhxfLz00HEqPqiWQtVt6Z9wXM7m7gFP5TB6MIpQxRJktPpKSEJjwyGeMkbRfXP2fabsS/ZEfDmYjliUjqPfxk2ylgZwIAOYxMyCQFpYVylqZ1IkUFs7hcx2urf4GeFn+b21MOXiiNnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780906326; c=relaxed/simple;
	bh=cOjS2e2C5T1rD0ULM3LGdL9XD5ykiLQVenEhKS/uybs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPyQTwSVg+uTZSZiaPUpOyOyW9pKDADYw+5Yv/qcBh2vwa05PwcIx29Dtc0eBYEs7jJGtrZZCWqM6y2SGxReIL1l927WFJ7NHe+5kt6yu/Q//GJLwWMDfciYk/p8rGo2Er4l1t1A4gRzSgyPHzA2APAlnr8XAtfsF/J0eS+eauA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRcbnJgm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRcbnJgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C93B1F00893;
	Mon,  8 Jun 2026 08:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780906325;
	bh=jQGth3uiwb0BlK7HMd9jRw5PF8jfshBmNB52ngskoPg=;
	h=From:To:Cc:Subject:Date;
	b=bRcbnJgmyUxJ5vaZqOr1e5XO7O6zV/mSlBnkt3xu74BoclQRoqQR190+tEsKfx0SX
	 KjC9dlsaQHlmMw5OOYS+8hTb7+J7feQpiTdnHHzUyszpPyJxDGNPM5XEopAsjjmioe
	 28Ua5PCWQEHDASVhWUhGrfRPgifVh7FNpVvgZihz8t/wbVyXpcRCk99ZsEH4gMT1PV
	 ykPh06LyGIRZZym+CHASGtsRtovL1Mi/I+9xqbxO/qw1BtebhD7rIWsVUqPtG7EB+y
	 TNCbw010YL0NDrdk27dVpryUhYdBAKkoO/PnkIOaBeaPN/y72zmSQOZMdL89wHZ8zd
	 d82y9NgHx5gIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wWV5X-0000000ANHQ-11V6;
	Mon, 08 Jun 2026 08:12:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Hold kvm->mmu_lock while initialising vcpu->arch.vncr_tlb
Date: Mon,  8 Jun 2026 09:11:08 +0100
Message-ID: <20260608081108.2244133-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Sashiko reports that there is a race between initialising vncr_tlb
and making use of it, as we don't hold the mmu_lock at this point.

Additionally, it identifies a memory leak, should userspace repeatedly
invokes the KVM_RUN ioctl after a failure of kvm_arch_vcpu_run_pid_change(),
as we assign vncr_tlb blindly on first run, irrespective of prior
allocations.

Slap the two bugs in one go by taking the kvm->mmu_lock on assigning
vncr_tlb, preventing the race for good, and by checking that vncr_tlb
is indeed NULL prior to allocation.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20260607180815.85FBC1F00893@smtp.kernel.org
---
 arch/arm64/kvm/nested.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 690b8e8564166..d11e36b3cfcc2 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1253,8 +1253,14 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
 		return 0;
 
-	vcpu->arch.vncr_tlb = kzalloc_obj(*vcpu->arch.vncr_tlb,
-					  GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.vncr_tlb) {
+		struct vncr_tlb *vt = kzalloc_obj(*vcpu->arch.vncr_tlb,
+						  GFP_KERNEL_ACCOUNT);
+
+		scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
+			vcpu->arch.vncr_tlb = vt;
+	}
+
 	if (!vcpu->arch.vncr_tlb)
 		return -ENOMEM;
 
-- 
2.47.3

