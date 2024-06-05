Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D7F13AA3F;
	Wed,  5 Jun 2024 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717610207; cv=none; b=H9bWBPYID6j9U3YkUVMzKGj3mcwrfXvmqD7BEkXb7nKLwuFmIwHOrU4O0uABDRQ2bP8q1BBaosM4yn/oUr2Erq3nqyUgBCGttI6GLKDMNIi9x7ce2QvIdyG/AYEhG+Aw1GXTbPU7bPoK6m6PzSq3iR+civG2+AuPCWq/8IvHONo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717610207; c=relaxed/simple;
	bh=strlOwnw4/bnGn8gwD1c1oynUtTrrwMZYOLxaaLrLDE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q+bB6r6y/P7Hu7OGYOlTXMmeAnYcGCqN/NF0sbE0GYuRC+8nWHI1QyaRLcIITuTL8YkY127zYQ7ngrAO5nj841Dj/1w8VeOeq2GqIw97MAGJ0IBgd0r01IV9+z2uo5XDrX7W9SJ3WzIy8QHnuleJsm1PrRoIaaKf1AQjaSI3uRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GmsZnuWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GmsZnuWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7385C2BD11;
	Wed,  5 Jun 2024 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717610206;
	bh=strlOwnw4/bnGn8gwD1c1oynUtTrrwMZYOLxaaLrLDE=;
	h=From:To:Cc:Subject:Date:From;
	b=GmsZnuWWotub3OTkHrlnfILM1banJqPU2PQctlTZE9sFP25BS0ZdOcSf6chO2m8aE
	 jKe3NWYTbnb/i0xA9nSpfbT0MwMzcy3AfN5/QW+T46BmYArr6WpItztvcePYOhjVqm
	 CbHsIZ++YMmzzrb7nmxGF+JaS/JoKz7YpTLQk5jXZDXA/S9ObSkKHHZHK3NqcF3j7R
	 MZeFN+ivdUDDDoxKXe6SyfdHxO641U3qxw6sxZjThLyTiE0Aqoa9+HnTk2JBhpMTsB
	 ACUrPDjqu4C5tLPmZQKUVfyQ2V5wJAIafcGn/gbw+ClhCXIYpqm98DAab9uoPPWN0N
	 FoEId4V6FgAPA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sEusO-0011w7-7X;
	Wed, 05 Jun 2024 18:56:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	glider@google.com,
	stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Disassociate vcpus from redistributor region on teardown
Date: Wed,  5 Jun 2024 18:56:37 +0100
Message-Id: <20240605175637.1635653-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When tearing down a redistributor region, make sure we don't have
any dangling pointer to that region stored in a vcpu.

Fixes: e5a35635464b ("kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 +++++++++++++--
 arch/arm64/kvm/vgic/vgic.h         |  2 +-
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 8f5b7a3e7009..7f68cf58b978 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -391,7 +391,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
-			vgic_v3_free_redist_region(rdreg);
+			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
 	} else {
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index a3983a631b5a..9e50928f5d7d 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -919,8 +919,19 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
 	return ret;
 }
 
-void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg)
+void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg)
 {
+	struct kvm_vcpu *vcpu;
+	unsigned long c;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/* Garbage collect the region */
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+			vcpu->arch.vgic_cpu.rdreg = NULL;
+	}
+
 	list_del(&rdreg->list);
 	kfree(rdreg);
 }
@@ -945,7 +956,7 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count)
 
 		mutex_lock(&kvm->arch.config_lock);
 		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		vgic_v3_free_redist_region(rdreg);
+		vgic_v3_free_redist_region(kvm, rdreg);
 		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 6106ebd5ba42..03d356a12377 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -316,7 +316,7 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
 
 struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
 							   u32 index);
-void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg);
+void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg);
 
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 
-- 
2.39.2

