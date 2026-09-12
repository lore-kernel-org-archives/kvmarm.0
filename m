Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B1A46A5FB
	for <kvmarm@lists.linux.dev>; Sat, 12 Sep 2026 10:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210127; cv=none; b=FdxLFlkJ8L1rAr+HfQtN1aA5hjIcdPxyods0Ybxpi3Fs+nZ0R1Ib52hQDMpt8nYK8ISnM802jQAKW7/naquZGzRsJjcNfYfJG6jSTfJlrO9E3Mqb6n4Y+goE+GkFTXG0dhTKlezljk/GXaIvdD4jNu2VCwdND93SsZM4NbGLn8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210127; c=relaxed/simple;
	bh=n+9cOjkcnEM7aPKE7oVT6ATeJs19NOt3HPC1MGcxbEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHuU+EEX+e3lI4vxjMBVv0HzcogssWqViI0mbmEO3DfG863oqpZtBCfVHIQ75gkPFBTgZUaSMXCK7On6vahL1N4Cpg5uOa+zL49ELBTJuEy0lYoPdH0d8zyMN+ddFE09tUSLtfiRqkcdvkdBdpNJ1DCoVIh+TRgKwHQbTpSqyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9JE2u97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9JE2u97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C1B1F0089C;
	Sat, 12 Sep 2026 10:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789210122;
	bh=jeEAQcYq8edHpB4unIjz9Fmm5hDTDyg9JL0bqDTzrr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9JE2u97Nl4LrsEiV1VoVM6cGQcWs8oWcZvj+ui8A3YhwFnywJO80L8TN+JZupXFI
	 bUlu4j+YTE2IG1WiR4jX11o+uiNzeYG48FFGj5hZMI3oKfPcrjyQoSEwi2+PSsVtnC
	 dzztPMwvlUnqcwasxNgc+L133d1RvPu3BvwfZNxtm6HuVhLRGp1X4AsH2gXrml/D9I
	 Y+ydJacDBOXS26hhC99JmmtOixPNpFLbOMEl9uF7Vj+upLk7KjkryTijUztreqUL7l
	 uENNTXNDfJZhgLUzTj91rwtF3PyTyVZz7PDxgmKaSyGOgQ0fa7R/GSxEGi3CERdHvE
	 xlHZt/n5MyaGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x5LHk-000000084hK-0g5y;
	Sat, 12 Sep 2026 10:48:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <weilin.chang@arm.com>,
	Wang Han <wanghan@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: [PATCH 3/4] KVM: arm64: nv: Move full s2_mmu unmap over to kvm_stage2_unmap_all()
Date: Sat, 12 Sep 2026 11:48:33 +0100
Message-ID: <20260912104834.3093878-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912104834.3093878-1-maz@kernel.org>
References: <20260912104834.3093878-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, weilin.chang@arm.com, wanghan@linux.alibaba.com, xueshuai@linux.alibaba.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have kvm_stage2_unmap_all(), use it when getting rid of a
shadow S2 MMU.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d60f6f69e293d..ebd8d23df0757 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1295,7 +1295,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+			kvm_stage2_unmap_all(mmu, may_block);
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -2014,7 +2014,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			kvm_stage2_unmap_all(mmu, true);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.47.3

